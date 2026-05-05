# 基于 Ara 向量算子的 RVV1.0 支持完善计划

## 1. 目标与复用边界

本计划建议优先复用 `D:/code/ara-main/hardware/src/lane` 中的整数/定点向量算子，而不是整体搬入 Ara 协处理器。

首选复用对象：

| Ara 模块 | 复用级别 | 覆盖能力 | 说明 |
| --- | --- | --- | --- |
| `simd_alu.sv` | P0 | `vadd/vsub/vrsub`、逻辑、比较、min/max、shift、narrow shift、merge、mask 结果生成、部分 fixed-point | 端口最简单，64-bit SIMD，适合封装到 C910 pipe6/pipe7 |
| `simd_mul.sv` | P1 | `vmul/vmulh/vmulhu/vmulhsu`、`vmacc/vnmsac/vmadd/vnmsub`、`vsmul` | 带 valid/ready pipeline，需要接入 ready stage/scoreboard |
| `simd_div.sv` | P1 | `vdiv/vdivu/vrem/vremu` | 多周期，需和现有 `vfdsu`/除法 issue 仲裁解耦 |
| `fixed_p_rounding.sv` | P1 | `vaadd/vaaddu/vasub/vasubu/vssra/vssrl/vnclip/vnclipu/vsmul` 相关舍入 | 可随 `simd_alu/simd_mul` 一起引入 |
| `valu.sv` | P2 | Ara 完整 lane ALU 调度、reduction/result queue | 依赖 `vfu_operation_t`、operand queue、lane sequencer，直接接入成本高 |

不建议 P0 直接复用：

| Ara 模块 | 原因 |
| --- | --- |
| `lane.sv` / `lane_sequencer.sv` / `operand_queue*.sv` / `vector_regfile.sv` | 会引入 Ara VRF 组织、lane 调度、地址映射，和 C910 现有 IDU/RF/VFPU 流水冲突较大 |
| `vmfpu.sv` | 覆盖 RVV FP 很完整，但依赖 `fpnew_pkg/config_pkg` 和 Ara 微操作队列，适合作为 P2/P3 替换现有 `vfalu/vfmau/vfdsu` 的长期方案 |
| `masku.sv` / `sldu.sv` / `vlsu.sv` | 需要全局向量长度、跨 lane/VRF 访问、LSU 协同，建议后续独立规划 |

## 2. 总体接入架构

采用“C910 解码/寄存器读取保持不变，新增 Ara 算子适配层”的方式：

```text
IDU ID/RF decode
  -> ct_idu_rf_pipe6/7_decd 生成 RVV1.0 op/vsew/vlmul/vm/func
  -> ct_vfpu_top pipe6/7
  -> ct_vfalu_top_pipe6/7
  -> 新增 ct_ara_valu_adapter_pipe6/7
       -> ara_pkg/rvv_pkg 映射层
       -> simd_alu / simd_mul / simd_div
  -> ct_vfalu_dp_pipe6/7 选择结果
  -> VFPU writeback / forward / VRT ready update
```

P0 实现范围建议限定为单 64-bit 数据片：

- `VLEN`/LMUL 的多拍展开仍由 C910 现有 RF/VFPU 流水控制负责。
- Ara 算子只处理当前 pipe 的 `srcv0/srcv1/srcv2/scalar/mask` 64-bit 数据。
- mask 采用 RVV v0 的 byte/element mask，经适配后输入 Ara `mask_i/vm_i`。
- 输出仍走 C910 现有 `pipex_dp_ex3_*` forward/writeback 选择。

## 3. 需要新增的模块

| 模块 | 目录建议 | 作用 | 主要修改点 |
| --- | --- | --- | --- |
| `ct_ara_rvv_pkg_bridge.sv` | `common/rtl` 或 `vfalu/rtl` | 定义 C910 func 到 Ara `ara_op_e/vew_e/vxrm_t` 的映射 | 引入 `rvv_pkg.sv/ara_pkg.sv`，提供 `ct_vsew_to_ara_vew`、`ct_func_to_ara_op` |
| `ct_ara_simd_alu_wrap.sv` | `vfalu/rtl` | 封装 Ara `simd_alu` 为 C910 64-bit 组合/单拍接口 | 适配 `operand_a/b`、`valid`、`vm`、`mask`、`op`、`vsew`、`vxrm`、`result/vxsat` |
| `ct_ara_simd_mul_wrap.sv` | `vfalu/rtl` 或 `vfmau/rtl` | 封装 Ara `simd_mul` | 接 C910 ready/valid；输出 valid 要接 ready_stage 和 VRT ready |
| `ct_ara_simd_div_wrap.sv` | `vfdsu/rtl` 或 `vfalu/rtl` | 封装 Ara `simd_div` | 多周期 valid/ready，和现有 `idu_vfpu_is_vdiv_issue` 或 VFDSU 仲裁 |
| `ct_ara_valu_adapter_pipe6.v/sv` | `vfalu/rtl` | pipe6 算子选择和结果打包 | 接 `dp_vfalu_ex1_pipex_func/srcf0/srcf1/srcv2/imm/vsew/vm`，输出 forward/result |
| `ct_ara_valu_adapter_pipe7.v/sv` | `vfalu/rtl` | pipe7 同构适配 | 与 pipe6 保持端口一致 |
| `ct_vmask_prepare.v` | `vfpu/rtl` 或 `vfalu/rtl` | 将 v0 mask 数据按 SEW 转换为 Ara `strb_t mask_i` | 支持 `vm=1` 全使能、`vm=0` 按元素屏蔽 |
| `ct_rvv_vtype_ctrl.v` | `cp0/rtl` 或 `vfpu/rtl` | 统一提供 RVV1.0 `vl/vtype/vxrm/vxsat/vstart` | 现有 `cp0_vfpu_vl/fxcr/fcsr` 不足以表达完整 RVV1.0 状态 |

## 4. 需要修改的现有模块

### 4.1 IDU 解码与发射

| 模块 | 修改点 |
| --- | --- |
| `idu/rtl/ct_idu_id_decd.v` | 补齐 RVV1.0 opcode 到内部 `func` 分类，尤其 integer/fixed-point/mask/reduction/permute；扩展 `vsew/vlmul` 到 RVV1.0 3-bit 编码；保留并完善 illegal/overlap 判断 |
| `idu/rtl/ct_idu_rf_pipe6_decd.v` | 新增 Ara op 映射字段或扩展 `pipe6_decd_func[19:0]`，区分 ALU/MUL/DIV/FIXED/MASK/RED/PERM；补充 `vxrm/vm/vsew` 对执行单元可见 |
| `idu/rtl/ct_idu_rf_pipe7_decd.v` | 与 pipe6 同步修改 |
| `idu/rtl/ct_idu_ir_vrt.v` | 后续扩展 LMUL/EMUL group rename：一次目的寄存器写入需要标记整个 register group；增加独立 `srcv2_reg`，避免当前复用 `srcv1_reg` |
| `idu/rtl/ct_idu_ir_rt.v` / `ct_idu_ir_frt.v` | 与 VRT 一起统一 recover/flush/ready 行为，确保向量多周期算子 replay/flush 不污染 rename table |
| `idu/rtl/ct_idu_rf_dp.v` | 为 Ara adapter 提供 `srcv2`、mask v0、scalar x/f 数据，以及 `vm/vxrm/vtype/vl/vstart` |

### 4.2 VFPU/VFALU 执行通路

| 模块 | 修改点 |
| --- | --- |
| `vfpu/rtl/ct_vfpu_top.v` | 新增 `vtype/vxrm/vxsat/vstart` 通路；将 pipe6/pipe7 的 Ara adapter ready/data valid 纳入现有 ex1-ex5 forward/writeback |
| `vfpu/rtl/ct_vfpu_ctrl.v` | 增加 Ara ALU/MUL/DIV 多周期 busy、flush kill、issue hold；生成 VRT ready 更新点 |
| `vfpu/rtl/ct_vfpu_dp.v` | 增加 64-bit vector src2/mask 数据选择；将 Ara 结果写回 `wb_vreg_vr*` |
| `vfalu/rtl/ct_vfalu_top_pipe6.v` | 例化 `ct_ara_valu_adapter_pipe6`；结果 mux 增加 `ara_valu_forward_r_vld/result` |
| `vfalu/rtl/ct_vfalu_top_pipe7.v` | 同 pipe6 |
| `vfalu/rtl/ct_vfalu_dp_pipe6.v` | 结果选择增加 Ara ALU/MUL/DIV/FIXED/MASK 路径；处理 `vxsat` side effect |
| `vfalu/rtl/ct_vfalu_dp_pipe7.v` | 同 pipe6 |
| `vfmau/rtl/ct_vfmau_top.v` / `ct_vfmau_mult1.v` | 如果 P1 选择 Ara `simd_mul` 替代/补齐整数乘法，应将整数向量乘法从 FP FMAU 中拆分，避免 func 混用 |
| `vfdsu/rtl/*` | 如果 P1 接入 Ara `simd_div`，需决定复用 VFDSU 除法仲裁还是新增 vector integer div 子通路 |

### 4.3 VRF/LSU/提交

| 模块 | 修改点 |
| --- | --- |
| `idu/rtl/ct_idu_rf_*` | 为每条 RVV 指令传递 `vl/vstart/vtype/vm`，并支持 mask source v0 实读 |
| `lsu/rtl/ct_lsu_top.v` | RVV load/store 的 element width、mask、fault-only-first、segment/indexed 需要和 VRF 写回协议统一；Ara VLSU 不建议 P0 复用 |
| `rtu/rtl/*` | 增加 RVV `vstart/vxsat/fflags` 精确异常提交；flush 时 kill VFPU 多周期结果 |
| `cp0/rtl/*` | 实现 RVV CSR：`vstart/vxsat/vxrm/vcsr/vl/vtype/vlenb`，并对 `vset{i}vl{i}` 写入提供旁路 |

## 5. 指令覆盖优先级

### P0：复用 `simd_alu`

目标：以最小风险补齐 integer ALU/fixed-point 的核心单拍能力。

| 指令类 | Ara op | C910 修改点 |
| --- | --- | --- |
| add/sub/reverse sub | `VADD/VSUB/VRSUB` | IDU decode、func 映射、VFALU result mux |
| bitwise | `VAND/VOR/VXOR` | 同上 |
| compare/mask result | `VMSEQ/VMSNE/VMSLT*/VMSLE*/VMSGT*` | mask result byte/bit pack，写回 vreg/v0 |
| min/max | `VMIN*/VMAX*` | signed/unsigned 映射 |
| shift/narrow shift | `VSLL/VSRL/VSRA/VNSRL/VNSRA` | `vsew`、narrowing select、byte enable |
| saturating/averaging/clip | `VSADD*、VSSUB*、VAADD*、VASUB*、VNCLIP*` | 接入 `vxrm`、`vxsat` |
| merge/move | `VMERGE/VMV` | `vm` 和 mask 处理 |

### P1：复用 `simd_mul/simd_div`

目标：补齐 integer multiply/divide/fixed-point multiply。

| 指令类 | Ara op | C910 修改点 |
| --- | --- | --- |
| mul/mulh | `VMUL/VMULH/VMULHU/VMULHSU` | 多周期 valid/ready，写回延迟更新 |
| multiply-add | `VMACC/VNMSAC/VMADD/VNMSUB` | 需要第三源 `srcv2` 真正接入 RF/VRT |
| fixed-point mul | `VSMUL` | `vxrm/vxsat` side effect |
| div/rem | `VDIV*/VREM*` | 需要 issue hold、busy、flush kill、除零语义验证 |

### P2：reduction/mask/permute/slide

目标：先复用 Ara 算法，再决定是否接入 Ara `valu/masku/sldu` 整体逻辑。

| 指令类 | 建议 |
| --- | --- |
| reduction | P0/P1 可先在 C910 内部做 64-bit lane 内 reduction；跨 lane/group reduction 后续参考 Ara `valu.sv` reduction FSM |
| mask logical / `viota/vid/vcpop/vfirst` | 可参考 Ara `masku.sv`，但建议新写 C910 风格 wrapper，避免搬 operand requester |
| `vrgather/vcompress` | 参考 Ara `masku` 的 request 协议，但需要 C910 VRF 多拍读支持 |
| slide | 参考 Ara `sldu.sv`，需要跨元素/跨 64-bit 片搬运，建议独立模块 |

### P3：浮点完整 RVV1.0

目标：评估 Ara `vmfpu.sv` 是否替换当前 `vfalu/vfmau/vfdsu` 的分散实现。

主要工作：

- 引入 `fpnew` 依赖和 `config_pkg/cva6_config_pkg` 适配。
- 将 C910 `func[19:0]` 映射到 Ara `VFADD..VMFGE` op。
- 对齐 `fflags`、rounding mode、NaN boxing、half/single/double 支持。

## 6. 文件引入建议

P0 最小文件集：

```text
D:/code/ara-main/hardware/include/rvv_pkg.sv
D:/code/ara-main/hardware/include/ara_pkg.sv
D:/code/ara-main/hardware/src/lane/simd_alu.sv
D:/code/ara-main/hardware/src/lane/fixed_p_rounding.sv
```

P1 增量：

```text
D:/code/ara-main/hardware/src/lane/simd_mul.sv
D:/code/ara-main/hardware/src/lane/simd_div.sv
```

注意：Ara 文件依赖 `common_cells/registers.svh`、`cf_math_pkg` 等外部包时，应优先通过 Bender/filelist 正式引入；如果当前 C910 仿真环境不支持 SystemVerilog package/import，需要在 `gen_rtl _rvv1.0/common/rtl` 新增兼容 wrapper 或做局部 Verilog 化。

## 7. 关键风险与规避

| 风险 | 影响 | 规避 |
| --- | --- | --- |
| SystemVerilog package/import 不兼容当前 C910 编译流 | 无法直接综合/仿真 | P0 wrapper 保持 SV，先在 filelist 中打开 SV 支持；必要时将 `simd_alu` 局部 Verilog 化 |
| C910 当前 VRT 还未完整支持 LMUL group | RVV group hazard/rename 错误 | 先限定 LMUL=1 验证；随后扩展 VRT group map |
| 当前 VRT 缺独立 `srcv2_reg` | multiply-add/三源指令依赖错误 | P1 前必须扩展 IR DP/RF/VRT 的 `srcv2_reg` |
| Ara `valu` 内部 result queue 和 C910 pipe ready 不一致 | 写回乱序或 ready 提前 | P0 不复用完整 `valu`，只复用 leaf 算子 |
| mask bit 语义差异 | masked-off element 写回错误 | 新增 `ct_vmask_prepare` 并用 RVV directed tests 覆盖 `vm=0/1` |
| `vxsat/fflags/vstart` side effect 缺失 | CSR 可见行为错误 | CP0/RTU 增加精确提交点，flush 不提交 side effect |

## 8. 建议开发步骤

1. 建立 `ct_ara_rvv_pkg_bridge`，完成 C910 `vsew/func/vxrm/vm` 到 Ara 类型映射。
2. 新增 `ct_ara_simd_alu_wrap`，仅接入 `simd_alu` 和 `fixed_p_rounding`。
3. 在 `ct_vfalu_top_pipe6/7` 中例化 adapter，在 `ct_vfalu_dp_pipe6/7` 中加入结果选择。
4. 修改 `ct_idu_rf_pipe6/7_decd`，给 P0 指令生成 Ara ALU 路由和 func。
5. 修改 `ct_vfpu_ctrl/dp/top`，传递 `vsew/vm/vxrm/mask`，并把 `vxsat` 汇入 CP0/RTU。
6. 增加 P0 directed tests：`vadd/vsub/vand/vor/vxor/vsll/vsrl/vsra/vmin/vmax/vmerge/vsaddu/vaadd/vnclip`。
7. P0 稳定后再接 `simd_mul`，同时完成 `srcv2_reg` 与 VRT group rename。
8. 最后规划 `simd_div`、mask/permute/slide、浮点 `vmfpu`。
