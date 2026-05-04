# RVV 1.0 对 IDU IR/RF 模块的修改点分析

## 1. 分析范围

参考文档：

- `doc/Instruction_Set/riscv-v-spec-v1.0-extracted.json`
- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_*.v`
- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_rf_*.v`

本文只分析 IR/RF 阶段为了支持 RVV 1.0 指令集需要补充或确认的修改点。ID 阶段、IS 阶段、CP0、RTU、LSU、VFPU 也会被牵连，但本文只在必要处说明 IR/RF 的接口依赖。

## 2. RVV 1.0 关键要求摘要

从 `riscv-v-spec-v1.0-extracted.json` 可提取到以下对 IR/RF 有直接影响的要求：

| 规范主题 | RVV 1.0 要求 | 对 IR/RF 的影响 |
| --- | --- | --- |
| `vtype` | 包含 `vill`、`vma`、`vta`、`vsew[2:0]`、`vlmul[2:0]` | 指令包必须携带完整 `vsew/vlmul/vma/vta/vill` 或可由后级可靠取得 |
| `vsetvli/vsetivli/vsetvl` | 三类配置指令均为标准配置指令 | IR 解码需区分 `vsetivli`，RF/后级需获得 zimm/uimm/rs1/rs2 形式 |
| `vsew` | RVV 1.0 标准 SEW 编码为 8/16/32/64，`100-111` 保留 | 现有 RF pipe6/7 只接收 2 位 `vsew`，无法完整表达保留值和未来扩展 |
| `vlmul` | 3 位有符号编码，支持 1/2、1/4、1/8、1、2、4、8，`100` reserved | 现有若只传 2 位 LMUL，将丢失 fractional LMUL 和 reserved 判断信息 |
| `vta/vma` | tail/mask agnostic/undisturbed 四种组合，汇编中 flags 已强制显式 | IR/RF 需要把 policy 随指令传给执行/写回，尤其影响旧目的读、mask/tail merge |
| mask | 指令 bit25 `vm` 定义 mask enabled/disabled，mask 寄存器总是单寄存器 | IR/RF 需要准确生成 `srcvm_vld`，并处理 mask 目的和 tail-agnostic 例外 |
| load/store | `mew/mop/vm/nf/lumop/sumop/width` 覆盖 unit/strided/indexed/segment/whole/fault-only-first | IR 需更细分类到 LSIQ/SDIQ/VMB，RF pipe3/4 需传递完整 LSU 控制 |
| 算术清单 | RVV 1.0 包含 OPIVV/OPIVX/OPIVI、OPMVV/OPMVX、OPFVV/OPFVF 的完整 funct6 清单 | RF pipe6/7 需要打开并校验完整向量 decode，而不是只保留参数和 case |
| V extension profile | V profile 要求 Zvl128b、EEW 8/16/32/64、全部 load/store、全部整数/定点/浮点相关指令 | RF/PRF/VRT 需确认物理向量寄存器宽度、分组、读写端口和前递能力 |

## 3. 当前 RTL 现状判断

### 3.1 IR 已有基础向量分类，但 RVV 1.0 不完整

`ct_idu_ir_decd.v` 已识别 `opcode == 7'b1010111` 为 vector 指令，并已有以下输出：

- `x_vec`
- `x_vdiv`
- `x_vmul`
- `x_vmul_unsplit`
- `x_vmla_short`
- `x_vmla_type`
- `x_vsetvl`
- `x_vsetvli`
- `x_unit_stride`
- `x_vamo`
- `x_viq_srcv12_switch`

现有明显缺口：

- 只有 `x_vsetvl` 和 `x_vsetvli`，没有 `x_vsetivli` 输出。
- `decd_vsetvli = x_opcode[31] == 0 && funct3 == 111 && opcode == 1010111`，这会把 RVV 1.0 的 `vsetivli` 混入 `vsetvli` 大类，后级无法区分 rs1 AVL 与 uimm AVL。
- `decd_unit_stride = x_opcode[27:26] == 0 && x_opcode[31:29] == 000` 只做粗分类，不足以覆盖 RVV 1.0 `lumop/sumop/nf/mew/mop/vm` 的完整 LSU 语义。
- `decd_vamo = opcode == 0101111 || |x_opcode[31:29]` 过粗，会把 segment/非 unit stride 等统一映射到 VMB 相关控制，需和 RVV 1.0 load/store 编码重新对齐。

### 3.2 `ct_idu_ir_vrt` 目前是占位实现

`ct_idu_ir_vrt.v` 接口已经包含 4 路向量目的、源、mask、VMA/多源相关性输入，但输出固定：

- `vrt_dp_inst**_srcv2_match = 1'b0`
- `vrt_dp_inst*_rel_vreg = 7'b0`
- `vrt_dp_inst*_srcv*_data` 固定为常量

这意味着 IR 阶段当前没有真实向量物理寄存器重命名表。若目标是完整 RVV 1.0，必须补真实 VRT 或明确采用固定映射/非重命名架构，并相应修改 RF/RTU/PRF 的资源模型。

### 3.3 RF pipe6/7 向量完整解码被关闭

`ct_idu_rf_pipe6_decd.v` 和 `ct_idu_rf_pipe7_decd.v` 内部定义了大量 RVV 执行单元和功能码，包括：

- `VALU/VPERM/VMISC/VREDU/VSHIFT/VMULU/VDIRU`
- `VADD/VSUB/VMADC/VMSBC/...`
- `VRED*`
- `VSLIDE*/VRGATHER/VCOMPRESS`
- `VMAND/VMOR/VMXOR/...`
- 浮点向量 `VFADD/VFMUL/VFMACC/...`

但最终选择处存在硬编码：

```verilog
assign decd_vec_inst = 1'b0;
```

结果是 `pipe6_decd_eu_sel/func/ready_stage` 永远走 FPU 标量分支，不会采用 `decd_vec_eu_sel/decd_vec_func/decd_vec_ready_stage`。这是 RF 阶段支持 RVV 1.0 的最高优先级修改点。

### 3.4 `vsew/vlmul` 信息宽度不足或传递不一致

IS entry 中可以看到 `vsew[2:0]` 和 `vlmul[1:0]` 被保存，但 RF pipe6/7 解码器接口只接收：

```verilog
input [1:0] pipe6_decd_vsew;
input [1:0] pipe7_decd_vsew;
```

风险：

- `vsew[2]` 的 reserved/未来扩展判断无法在 RF pipe 解码中看见。
- RVV 1.0 `vlmul[2:0]` 是 3 位 signed 编码，现有 `vlmul[1:0]` 无法表达 `mf2/mf4/mf8` 与 reserved `100` 的完整语义。
- `pipe6/7` 只用 `vsew[1:0]` 判断 half/single/double，缺少对 illegal/reserved vtype 的本地防护。

### 3.5 RF 数据通路已有 mask/向量源接口，但需要校验 RVV 1.0 语义

`ct_idu_rf_dp.v` 已有以下路径：

- `srcv0/srcv1/srcv2/srcvm`
- `dstv_vld`
- `srcvm_vreg_vr0/vr1`
- VIQ0/VIQ1 `VSEW/VLMUL`
- pipe3/4 LSU mask 源
- pipe6/7 VFPU mask 源

需要重点确认：

- `srcvm_vld` 生成是否严格等价于 RVV 1.0 `vm == 0`，并排除 mask 指令、`vcompress.vm` 等特殊保留约束。
- mask 寄存器始终为单寄存器，不受 LMUL 分组影响；当前 VRT/PRF 地址展开不能按普通 LMUL 扩展 v0。
- mask destination tail 始终 agnostic，这会影响 RF 是否需要旧目的读用于 merge。

### 3.6 `ct_idu_rf_prf_vregfile` 是默认零输出

`ct_idu_rf_prf_vregfile.v` 当前把 pipe5/6/7 的向量读数据固定为 `64'b0`。虽然 `ct_idu_rf_prf_fregfile.v` 也实例化了多个 `gated_vreg`，可能承担部分向量/浮点向量片数据，但如果目标是完整 RVV 1.0，需要明确：

- 真正的 VRF 是否在 `fregfile` 或其他生成文件中实现。
- VLEN=128b 时至少需要 VR0/VR1 两个 64b 片；若支持更高 Zvl，则 RF 端口和数据宽度要扩展。
- Whole-register load/store、LMUL=8、segment load/store 对连续寄存器组读写的支持路径是否完整。

## 4. IR 模块修改点

### 4.1 `ct_idu_ir_decd`

优先级 P0：

1. 新增 `x_vsetivli` 输出。
2. 将配置指令拆分为：
   - `vsetvli`: `opcode=1010111, funct3=111, bit31=0`
   - `vsetivli`: `opcode=1010111, funct3=111, bit31=1, bits[30:30]` 按规范约束
   - `vsetvl`: `opcode=1010111, funct3=111, funct7=1000000`
3. 输出配置指令格式类型，供后续区分 AVL 来源：
   - rs1 AVL
   - uimm AVL
   - rs2/vtype register

优先级 P1：

1. 增加 RVV 1.0 load/store 细分类：
   - unit-stride
   - unit-stride fault-only-first
   - whole register load/store
   - strided
   - indexed ordered/unordered
   - segment load/store
   - vector AMO
2. 从 `mew/mop/lumop/sumop/nf/vm/width` 生成更明确的控制位，避免用 `decd_vamo = |opcode[31:29]` 这种粗糙判断。
3. 明确 `vcompress.vm`：RVV 1.0 规定它是 unmasked 编码，`vm=0` 保留，需要在 IR/ID illegal 或分派控制中体现。

优先级 P2：

1. 对 RVV 1.0 完整指令清单补分类覆盖，尤其是：
   - `vcpop.m/vfirst.m/vmsbf.m/vmsif.m/vmsof.m/viota.m/vid.v`
   - `vrgatherei16.vv`
   - `vmv<nr>r.v`
   - `vfslide1up/down`
   - fixed-point `vaadd/vasub/vsmul/vssrl/vnclip`
2. 将 `vmla_short/vmul_unsplit/viq_srcv12_switch` 与 RVV 1.0 funct6 表重新核对，避免遗漏新增或编码变化的乘加/归约/置换指令。

### 4.2 `ct_idu_ir_dp`

优先级 P0：

1. 扩展 IR 数据包字段，携带：
   - `vsetivli`
   - `vsew[2:0]`
   - `vlmul[2:0]`
   - `vta`
   - `vma`
   - `vm`
   - load/store `nf/mew/mop/lumop/sumop/width`
2. 当前 `vsetvli` 与 `vsetivli` 若共用一位，会导致后级无法正确计算 AVL 和 vtype，需要拆开。
3. 对向量 load/store，把 IR 解码出的细分类传给 LSIQ/SDIQ/VMB 相关 create data，而不是只传 `unit_stride/vamo`。

优先级 P1：

1. 若启用真实向量重命名，`ir_dp` 需要把每条指令的 `EMUL` 信息传给 `ir_vrt`，用于多物理寄存器组分配/释放。
2. 对 widening/narrowing/reduction/mask 指令，输出目的寄存器有效和旧目的保留策略：
   - tail/mask undisturbed 可能需要读旧目的
   - agnostic 可允许不读旧目的，适合重命名优化

### 4.3 `ct_idu_ir_ctrl`

优先级 P0：

1. 根据真实 `dstv_vld` 和 EMUL 申请足够数量的 vector physical register，而不是按单个 `vreg*_alloc_vld` 处理。
2. `vsetvl/vsetvli/vsetivli` 应作为配置/CSR 类资源分派，确保与后续 vector 指令的 `vtype/vl` 依赖有序。
3. 对 `vill` 或 vtype 更新相关 flush/stall 关系增加保护：配置指令更新前后，后续 vector 指令不能错误使用旧 `vtype`。

优先级 P1：

1. VIQ0/VIQ1 预分派选择需要覆盖完整 RVV 1.0 指令类别，尤其是 reduction、permute、mask、vf、vdiv 等不同执行单元约束。
2. 对 whole-register load/store、segment load/store 这类可能占用多个寄存器组/多个 LSU slot 的指令增加资源估计。

### 4.4 `ct_idu_ir_vrt`

优先级 P0：

1. 将占位常量实现替换为真实向量重命名表，至少支持 32 个架构向量寄存器的当前物理映射。
2. 支持 4 路 IR 同拍 rename 的 RAW/WAW bypass。
3. 输出每条指令旧目的 `rel_vreg`，供 RTU 提交后释放。
4. 支持 `rtu_idu_rt_recover_vreg` 恢复。

优先级 P1：

1. 支持 LMUL/EMUL 对连续寄存器组的分配、对齐检查和释放。
2. mask v0 作为单寄存器处理，不能按 LMUL 扩展。
3. 对 tail/mask undisturbed 需要读旧目的的场景，给 RF 提供旧目的物理号或额外源标记。

## 5. RF 模块修改点

### 5.1 `ct_idu_rf_pipe6_decd` / `ct_idu_rf_pipe7_decd`

优先级 P0：

1. 打开向量 decode：

   ```verilog
   assign decd_vec_inst = (decd_op[6:0] == 7'b1010111);
   ```

   或使用 issue data 中明确的 `vec` 标志，避免把标量 FPU 指令误判。

2. 把 `pipe*_decd_vsew` 从 2 位扩展到 3 位，并在 `vsew[2]` 为 1 时输出 illegal/保留配置保护，或确保上游已完全屏蔽。
3. 增加/传入 `vlmul[2:0]`、`vta`、`vma`、`vm`，使 decode 能区分：
   - ordinary vector
   - mask result
   - widening/narrowing EMUL
   - tail/mask undisturbed 是否需要旧目的

优先级 P1：

1. 用 RVV 1.0 指令清单逐项核对 `case(funct6/funct3)`：
   - OPIVV/OPIVX/OPIVI
   - OPMVV/OPMVX
   - OPFVV/OPFVF
2. 补齐或确认以下类：
   - `vadd/vsub/vrsub`
   - compare `vmseq/vmsne/vmslt/vmsle/vmsgt`
   - mask logical `vmand/vmor/vmxor/...`
   - reduction `vred* / vwred* / vfred* / vfwred*`
   - permute `vrgather/vrgatherei16/vslide*/vcompress`
   - fixed-point `vsadd/vssub/vaadd/vasub/vsmul/vssrl/vnclip`
   - widening integer/fp multiply accumulate `vwmacc* / vfwmacc*`
3. 对 `vcompress.vm` 增加 `vm=1` 检查，`vm=0` 保留。

优先级 P2：

1. 根据 RVV 1.0 ready stage 与实际 VFPU/VALU 单元重新校准 `EX3/EX4/EX5/DIV_READY`。
2. 对 `vdiv/vfsqrt/vfrsqrt7/vfrec7` 等长延迟指令，确认 RF ctrl 的 `vfpu_idu_vdiv_wb_stall` 覆盖足够。

### 5.2 `ct_idu_rf_dp`

优先级 P0：

1. 扩展 VIQ read data 字段：
   - `vsew[2:0]`
   - `vlmul[2:0]`
   - `vta/vma/vm`
   - vector load/store 细分类字段
2. pipe6/7 调用解码器时传入完整 `vsew/vlmul/policy`。
3. 对 mask 源 `srcvm`：
   - `vm=0` 时读 v0 mask
   - `vm=1` 时不读 mask，除 mask 指令自身语义要求外
   - mask 寄存器地址固定 v0，不受 LMUL 扩展
4. 对 tail/mask undisturbed，需要引入旧目的读数据或标记给执行单元完成 merge。

优先级 P1：

1. 对 vector scalar operand 区分 x/f 标量来源：
   - `.vx` 从整数 PRF
   - `.vf` 从浮点 PRF/FPRF
   - `.vi` 从 `uimm/simm`
2. 对 reduction 指令，确认 vs1 初始标量/向量第 0 元素读取路径。
3. 对 `vmv.s.x/vfmv.s.f/vmv.x.s/vfmv.f.s` 等标量-向量搬移指令，确认 pipe0/1 与 pipe6/7 间的目的有效和前递一致。

### 5.3 `ct_idu_rf_ctrl`

优先级 P0：

1. 在 `decd_vec_inst` 打开后，重新检查 pipe6/7 的 select、pop、latch fail 条件，确保 vector 指令不会被当成标量 FPU 指令发射。
2. 对 `vdiv/vmul_unsplit/vmla_short` 现有控制与 RVV 1.0 指令类别重新匹配。
3. 对 mask/permute/reduction 等指令的 queue pop 条件加入特殊源 ready 和执行单元可用判断。

优先级 P1：

1. 对 `vset*` 与后续 vector 指令建立顺序约束，避免乱序使用旧 `vtype/vl`。
2. 对 whole-register/segment load/store 可能产生的多寄存器写回，增加 latch/ready 回写覆盖。

### 5.4 `ct_idu_rf_fwd` / `ct_idu_rf_fwd_vreg`

优先级 P1：

1. 扩展前递比较支持 LMUL/EMUL 寄存器组，而不只是单个 6/7 位物理向量寄存器号。
2. 对 mask v0 前递按单寄存器处理。
3. 对 widening/narrowing 目的和源不同 EEW/EMUL 的场景，确认前递命中粒度。
4. 对 LSU vector load 写回、VFPU/VFALU/VFMAU 多级写回，确认所有 RVV 1.0 写回源都进入 `fwd_srcv_sel`。

### 5.5 PRF/VRF 相关模块

优先级 P0：

1. 明确真实 VRF 实现位置。若 `ct_idu_rf_prf_vregfile.v` 仍固定零输出，则必须实现真实读写。
2. 支持 V profile 至少 Zvl128b，即每个架构向量寄存器至少 128 bit。
3. 支持 EEW 8/16/32/64 下的元素访问和 mask bit 布局。

优先级 P1：

1. 支持 LMUL=1/2/1/4/1/8/1/2/4/8 对寄存器组的映射。
2. 支持 whole-register load/store `vl<nf>r.v/vs<nf>r.v` 连续寄存器组读写。
3. 支持 segment load/store 的多目的/多源寄存器组写读。
4. 对 tail/mask agnostic 可选择不保留旧目的；对 undisturbed 必须能提供旧目的元素。

## 6. 建议实施顺序

1. **先修 RF pipe6/7 向量 decode 使能**：打开 `decd_vec_inst`，接入完整 `vsew[2:0]`，跑基本 `vadd/vle/vse/vsetvli` smoke。
2. **补 IR vsetivli 与 vtype 字段传递**：拆分 `vsetvli/vsetivli/vsetvl`，打通 `vta/vma/vsew/vlmul/vill`。
3. **实现或确认真实 VRT/VRF**：这是完整 RVV 1.0 的架构级前提。
4. **补 load/store 细分类**：覆盖 `mew/mop/lumop/sumop/nf/vm`，再接 LSU。
5. **逐类补 RF vector funct6 decode 覆盖**：按 RVV 1.0 instruction listing 建 coverage matrix。
6. **补 mask/tail policy 与旧目的 merge**：特别覆盖 `tu/mu`、mask 指令、mask load tail 例外。
7. **补复杂类验证**：reduction、permute、compress、widen/narrow、vdiv/vsqrt、segment/whole register。

## 7. 最小回归用例建议

| 类别 | 指令示例 | 目标 |
| --- | --- | --- |
| 配置 | `vsetvli`、`vsetivli`、`vsetvl` | 区分 AVL/vtype 来源，更新 `vl/vtype` |
| 基本访存 | `vle8/16/32/64.v`、`vse8/16/32/64.v` | LSU 分类、mask、EEW |
| mask | `vmslt.vi`、`vmnot.m`、`vcpop.m`、`vfirst.m` | v0 mask、mask tail agnostic |
| 算术 | `vadd.vv/vx/vi`、`vsub.vv/vx`、`vrsub.vx/vi` | OPIVV/OPIVX/OPIVI |
| 乘除 | `vmul/vmulh/vdiv/vrem` | VMUL/VDIV issue 和 stall |
| widening/narrowing | `vwadd/vwsub/vnsrl/vnclip` | EMUL、对齐、overlap |
| reduction | `vredsum/vredmax/vwredsum` | reduction 源和 ready stage |
| permute | `vrgather/vrgatherei16/vslideup/vcompress` | VPERM decode 和特殊保留约束 |
| 浮点向量 | `vfadd/vfmul/vfmacc/vfwmacc/vfredsum` | OPFVV/OPFVF 和 FPRF/VRF 源选择 |
| whole/segment | `vl1r/vl8r/vs1r/vs8r`、`vlseg/vsseg` | 多寄存器组资源与写回 |

