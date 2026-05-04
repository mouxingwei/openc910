# RVV 1.0 向量寄存器重命名/VRF 支持方案

## 1. 范围与目标

本文档基于以下源码和已有文档，给出后续实现 RVV 1.0 向量寄存器支持的开发方案：

- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_rt.v`
- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_frt.v`
- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_vrt.v`
- `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_dep_vreg_srcv2_entry.v`
- `doc/design_docs/idu/ct_idu_ir_rt_frt_detailed.md`
- `doc/design_docs/idu/rvv1.0_ir_rf_modification_points.md`
- `doc/Instruction_Set/riscv-v-spec-v1.0-extracted.json`

本文中的“VRF 支持”分为两层：

| 层级 | 建议模块 | 目标 |
| --- | --- | --- |
| IR rename table | `ct_idu_ir_vrt` | 实现 32 个架构向量寄存器 `v0~v31` 到物理向量寄存器的投机映射、源读取、旧目的释放、flush/recover |
| RF physical register file | `ct_idu_rf_prf_vregfile` 及相关 RF/VFPU/LSU 接口 | 实现真实向量物理寄存器读写、前递、LMUL/EMUL 组访问和 mask/tail 策略支持 |

优先建议先完成 IR 侧 `ct_idu_ir_vrt`，使向量指令能拥有和 RT/FRT 一致的 rename/ready 语义；再推进 RF 侧真实 VRF 数据存储和多寄存器组读写。

## 2. 当前现状判断

### 2.1 RT/FRT 可作为实现模板

RT 和 FRT 都已经实现了完整 rename table 的基本形态：

| 能力 | RT | FRT | 对 VRT 的启发 |
| --- | --- | --- | --- |
| 多表项 | `reg_0~reg_32` | `reg_0~reg_32` + `reg_e` | VRT 应至少实现 `reg_0~reg_31`，可保留 `reg_32/33` 兼容现有接口骨架 |
| 四路写入 | 支持 inst0~inst3 | 支持 inst0~inst3 | VRT 应支持四路 IR 同拍 rename |
| 组内 RAW/WAW | 支持 | 支持 | VRT 必须处理同拍 vector RAW/WAW |
| ready/wb 更新 | IU/LSU/VFPU/RF | LSU/VFPU/RF VMLA | VRT 可复用 FRT 的 vreg ready 更新路径 |
| flush/recover | `rtu_idu_rt_recover_preg` | `rtu_idu_rt_recover_freg/ereg` | VRT 应使用 `rtu_idu_rt_recover_vreg` |
| 表项模块 | `ct_idu_dep_reg_src2_entry` | `ct_idu_dep_vreg_srcv2_entry` | VRT 应优先复用 `ct_idu_dep_vreg_srcv2_entry` |

### 2.2 `ct_idu_ir_vrt` 当前是占位实现

现有 `ct_idu_ir_vrt.v` 的端口已经包含：

- `dp_vrt_inst[0:3]_dst_vreg`
- `dp_vrt_inst[0:3]_dstv_reg`
- `dp_vrt_inst[0:3]_dstv_vld`
- `dp_vrt_inst[0:3]_srcv0_reg/srcv1_reg`
- `dp_vrt_inst[0:3]_srcv0_vld/srcv1_vld/srcv2_vld/srcvm_vld`
- `rtu_idu_rt_recover_vreg[191:0]`
- `vrt_dp_inst[0:3]_srcv*_data`
- `vrt_dp_inst[0:3]_rel_vreg`

但真正的表项实例化和读写逻辑被注释，最终输出为常量：

```verilog
assign vrt_dp_inst0_rel_vreg[6:0]   = 7'b0;
assign vrt_dp_inst0_srcv0_data[8:0] = 9'b100000011;
...
```

因此当前没有真实向量 rename table。后续 RVV 1.0 支持必须将其替换为和 FRT 类似的真实实现。

### 2.3 RVV 1.0 对向量寄存器的关键要求

| 要求 | 对 VRT/VRF 的影响 |
| --- | --- |
| 32 个架构向量寄存器 `v0~v31` | VRT 需要维护 32 个架构映射 |
| `vtype` 包含 `vill/vma/vta/vsew[2:0]/vlmul[2:0]` | rename 和 RF payload 需携带完整 vtype 策略 |
| `LMUL` 支持 `mf8/mf4/mf2/m1/m2/m4/m8`，`100` reserved | VRT 需处理寄存器组合法性、对齐、分配数量和释放数量 |
| mask 由 `vm` 控制，mask 源固定使用 `v0` | `srcvm` 必须固定读取架构 `v0` 当前映射，且 mask 不按 LMUL 扩展 |
| tail/mask agnostic/undisturbed | undisturbed 场景可能需要读旧目的寄存器作为 merge 源 |
| widening/narrowing/indexed load 等存在 EMUL | VRT 需要按 EMUL 而非简单 LMUL 决定源/目的寄存器组资源 |
| segment/whole-register load/store | 可能一次涉及多个连续向量寄存器组，需扩展分配和释放模型 |

## 3. 总体架构方案

建议将向量支持拆成三个子系统：

```text
IR DP decode/rename
        |
        | arch src/dst, new physical dst, vtype/vl policy, EMUL info
        v
+--------------------+
| ct_idu_ir_vrt      |
| vector rename table|
+---------+----------+
          |
          | src physical vreg, old dst physical vreg, ready/wb
          v
IR DP issue create data -> VIQ/LSIQ/SDIQ
          |
          v
RF pipe6/7 + pipe3/4/5
          |
          | read addr, mask addr, old dst merge addr
          v
+--------------------+
| RF vector PRF/VRF  |
+--------------------+
```

### 3.1 开发阶段划分

| 阶段 | 目标 | 输出 |
| --- | --- | --- |
| P0 | 实现单寄存器 VRT，替换常量输出 | RVV 基础算术、mask 源、单寄存器 load/store 可正确 rename |
| P1 | 支持 LMUL/EMUL 寄存器组 rename | LMUL=2/4/8、widen/narrow、segment 基础路径具备资源模型 |
| P2 | 支持 tail/mask undisturbed 旧目的读和真实 RF VRF | 旧目的 merge、mask/tail policy 与 RF 数据路径闭环 |
| P3 | 完整 RVV 1.0 指令覆盖和性能优化 | 完整 decode、异常、flush、free-list、formal/checker |

## 4. `ct_idu_ir_vrt` 详细设计

### 4.1 模块定位

`ct_idu_ir_vrt` 应作为向量版 RT/FRT：

| 输入 | 来源 | 功能 |
| --- | --- | --- |
| `dp_vrt_inst*_srcv0_reg/srcv1_reg` | IR DP | 架构向量源寄存器号 |
| `dp_vrt_inst*_srcv*_vld` | IR DP | 各源是否参与依赖 |
| `dp_vrt_inst*_srcvm_vld` | IR DP | 是否读取 mask 源 `v0` |
| `dp_vrt_inst*_dstv_reg` | IR DP | 架构向量目的寄存器号 |
| `dp_vrt_inst*_dst_vreg` | IR DP/free-list | 新分配物理向量寄存器号 |
| `dp_vrt_inst*_dstv_vld` | IR DP | 目的向量寄存器有效 |
| `rtu_idu_rt_recover_vreg` | RTU | flush/recover 映射 |
| VFPU/LSU/RF ready 信号 | RF/LSU/VFPU | 更新表项 ready/wb |

| 输出 | 去向 | 功能 |
| --- | --- | --- |
| `vrt_dp_inst*_srcv0_data/srcv1_data/srcv2_data/srcvm_data` | IR DP | 源 ready/wb/物理向量寄存器号 |
| `vrt_dp_inst*_rel_vreg` | IR DP/RTU/free-list | 目的重命名前旧物理向量寄存器 |
| `vrt_dp_inst**_srcv2_match` | IR DP | 包内源 2 RAW 匹配辅助 |

### 4.2 表项结构

P0 建议直接复用 FRT 的 `ct_idu_dep_vreg_srcv2_entry`。

| 字段 | 位 | 含义 |
| --- | --- | --- |
| `rdy` | `[0]` | 当前物理向量寄存器是否 ready |
| `wb` | `[1]` | 当前物理向量寄存器是否写回完成 |
| `vreg` | `[8:2]` | 当前架构向量寄存器映射到的物理向量寄存器号，7 位 |
| `mla/vmla ready` | `[9]` 或 entry 内部 | VMLA/源 2 相关 ready 辅助 |
| `lsu_match/保留` | entry 内部 | LSU vector load 与特殊 ready 状态 |

P0 可保持与当前 VRT 输出位宽兼容：

| 输出 | 位宽 | 编码建议 |
| --- | --- | --- |
| `srcv0_data/srcv1_data/srcvm_data` | 9 | `[0]=rdy`，`[1]=wb`，`[8:2]=vreg` |
| `srcv2_data` | 10 | `[0]=rdy`，`[1]=wb`，`[8:2]=vreg`，`[9]=vmla/srcv2 ready` |
| `rel_vreg` | 7 | 旧目的物理向量寄存器号 |

### 4.3 表项数量

P0 建议实现 32 个架构向量寄存器：

```text
reg_0  -> v0
reg_1  -> v1
...
reg_31 -> v31
```

是否保留 `reg_32/reg_33`：

| 方案 | 优点 | 风险 |
| --- | --- | --- |
| 仅实现 `reg_0~31` | 符合 RVV 架构寄存器数 | 需要清理当前注释骨架中的 `reg_32/33` 兼容逻辑 |
| 保留 `reg_32/33` 但不参与架构选择 | 改动小，可复用 FRT 生成风格 | 需要确保非法地址不会误选到保留表项 |

建议 P0 保留内部 `reg_32/33` 作为 default/非法保护表项，但 DP 侧合法架构寄存器只允许 0~31。

### 4.4 初始化和恢复

reset 初始化：

```text
v0  -> pv0
v1  -> pv1
...
v31 -> pv31
```

恢复逻辑对齐 FRT：

```text
vrt_recover_updt_vld =
  ifu_xx_sync_reset || rtu_yy_xx_flush

vrt_recover_updt_vreg =
  ifu_xx_sync_reset ? vrt_reset_updt_vreg
                    : rtu_idu_rt_recover_vreg
```

当前 `rtu_idu_rt_recover_vreg[191:0]` 是 32 x 6 位。若 VRT 物理向量寄存器号采用 7 位，需要同步修改 RTU/PST recover 接口为 32 x 7 位，即 224 位。若暂时沿用 6 位物理号，则 VRT 输出的 7 位高位固定 0。

建议开发决策：

| 决策项 | P0 建议 |
| --- | --- |
| 物理向量寄存器号宽度 | 与 RF/VFPU 现有 `vreg[6:0]` 对齐，内部使用 7 位 |
| recover 宽度 | 尽早扩展到 224 位，避免后续物理寄存器数量受限 |
| 兼容过渡 | 若 RTU 尚未扩展，提供 `{1'b0, recover_vreg_6b}` 临时适配层 |

### 4.5 写入流程

四路写入条件对齐 RT/FRT：

```text
instN_write_en =
  ctrl_rt_instN_vld
  && !ctrl_ir_stall
  && !vrt_recover_updt_vld
  && dp_vrt_instN_dstv_vld
```

需要新增或确认端口：

| 端口 | 必要性 | 说明 |
| --- | --- | --- |
| `ctrl_ir_stall` | 必须 | 当前 VRT 端口缺失，真实写入必须受 stall 控制 |
| `ctrl_rt_inst[0:3]_vld` | 必须 | 当前 VRT 端口缺失，决定四路指令是否参与 rename |
| `ifu_xx_sync_reset`、`rtu_yy_xx_flush` | 必须 | 当前 VRT 只有 recover data，没有 recover valid 来源 |
| `forever_cpuclk/cp0_idu_icg_en/cp0_yy_clk_en/cpurst_b/pad_yy_icg_scan_en` | 必须 | 当前 VRT 没有真实时钟端口，需恢复表项实例化所需端口 |
| VFPU/LSU/RF ready 更新输入 | 必须 | 可按 FRT 同名向量路径补入 |

P0 写入优先级：

```text
recover/reset > inst3 > inst2 > inst1 > inst0
```

这样满足同拍多条指令写同一架构向量寄存器时，程序顺序最后一条成为最终映射。

### 4.6 源读取流程

VRT 需要为每条指令读取：

| 源 | 架构语义 | P0 读取方式 |
| --- | --- | --- |
| `srcv0` | vs1/vs2/源 0，取决于 DP 编码 | 按 `dp_vrt_inst*_srcv0_reg` 读表 |
| `srcv1` | 第二向量源 | 按 `dp_vrt_inst*_srcv1_reg` 读表 |
| `srcv2` | VMLA/三源向量指令源 2 | P0 需新增 `srcv2_reg` 端口；若暂不新增，只能由 DP 复用 srcv0/srcv1，风险较高 |
| `srcvm` | mask 源 | 固定读取架构 `v0` 当前映射，不应使用任意 `srcvm_reg` |

当前 VRT 接口只有 `srcv2_vld`，没有 `srcv2_reg`。这对 RVV 1.0 不够，建议新增：

```verilog
input [5:0] dp_vrt_inst0_srcv2_reg;
input [5:0] dp_vrt_inst1_srcv2_reg;
input [5:0] dp_vrt_inst2_srcv2_reg;
input [5:0] dp_vrt_inst3_srcv2_reg;
```

若 IR DP 已经能保证 `srcv2` 总是等于某个现有源寄存器，需要在 DP/VRT 接口文档中明确复用规则，否则后续三源指令会产生错误依赖。

### 4.7 包内 RAW/WAW 旁路

VRT 需要复制 FRT 的包内旁路机制：

| 读取指令 | 可匹配前序目的 |
| --- | --- |
| inst1 | inst0 |
| inst2 | inst1、inst0 |
| inst3 | inst2、inst1、inst0 |

匹配条件：

```text
ctrl_rt_instN_vld
&& srcvM_vld
&& ctrl_rt_instK_vld
&& dstv_vld[K]
&& srcvM_arch_reg[N] == dstv_arch_reg[K]
```

命中后：

```text
srcvM_data.vreg = dp_vrt_instK_dst_vreg
srcvM_data.rdy  = 0, 除非该指令类型允许 move/merge 特殊 ready 旁路
srcvM_data.wb   = 0
```

对 `srcvm`，如果前序指令写 `v0`，后序 mask 源也必须旁路到前序新目的物理寄存器。这个点很容易漏，必须作为验证用例。

### 4.8 旧目的释放

每条目的有效的向量指令都需要输出旧映射：

```text
vrt_dp_instN_rel_vreg = old_mapping[dstv_reg]
```

如果存在包内 WAW：

```text
inst0: v5 -> pv40
inst1: v5 -> pv41
```

则：

| 指令 | `rel_vreg` 应为 |
| --- | --- |
| inst0 | rename 前表中 v5 的旧映射 |
| inst1 | inst0 新分配的 pv40 |

即后序指令释放的是前序指令的新映射，而不是更早的表中旧映射。FRT/RT 已经有类似逻辑，VRT 应照搬。

## 5. RVV 1.0 LMUL/EMUL 支持方案

### 5.1 P0 单寄存器方案

P0 先按 LMUL=1 实现 VRT，所有目的只分配一个物理向量寄存器。该方案适合尽快打通基础 RVV 标量：

- `vadd.vv`
- `vadd.vx`
- `vle*.v` 的基础 unit-stride
- `vse*.v`
- mask 源读取
- 基础 VFPU pipe6/7 ready 更新

限制：

- 不支持 LMUL > 1 的寄存器组精确 rename。
- 不支持 fractional LMUL 的资源压缩优化，只能按 1 个物理寄存器保守分配。
- widening/narrowing/segment/whole-register 指令需要先禁止或走保守 illegal/stall 路径。

### 5.2 P1 寄存器组方案

RVV 1.0 中目的寄存器可能是寄存器组。建议 VRT 新增组信息：

| 字段 | 位宽 | 说明 |
| --- | --- | --- |
| `dst_group_size` | 4 | 目的占用物理向量寄存器个数，1/2/4/8 |
| `srcv*_group_size` | 4 | 源寄存器组大小 |
| `dst_align_ok` | 1 | 架构目的寄存器是否满足 LMUL 对齐 |
| `src_align_ok` | 1 | 源寄存器组是否满足 LMUL/EMUL 对齐 |
| `rel_vreg_group` | 7 x 8 | 旧目的组物理寄存器列表 |

建议不要只输出单个 `rel_vreg`。对 LMUL=8，释放旧目的需要最多 8 个物理寄存器号。可新增压缩接口：

```verilog
output [55:0] vrt_dp_instN_rel_vreg_group; // 8 x 7b
output [3:0]  vrt_dp_instN_rel_vreg_cnt;   // 1/2/4/8
```

### 5.3 EMUL 计算职责

EMUL 计算依赖指令类型、SEW、EEW、LMUL。建议职责划分：

| 模块 | 职责 |
| --- | --- |
| `ct_idu_ir_decd` | 分类指令是 normal/widen/narrow/index/segment/whole-register |
| `ct_idu_ir_dp` | 根据 `vsew/vlmul/EEW` 生成 `src/dst group_size` 和 illegal/alignment 标记 |
| `ct_idu_ir_vrt` | 只消费已计算好的 group_size/alignment，不重复复杂 decode |

这样 VRT 保持 rename table 属性，不被 RVV 指令 decode 细节污染。

### 5.4 对齐规则

寄存器组的架构寄存器需要按组大小对齐：

| 组大小 | 合法起始架构寄存器示例 |
| --- | --- |
| 1 | 任意 `v0~v31` |
| 2 | 偶数寄存器 |
| 4 | 4 对齐寄存器 |
| 8 | 8 对齐寄存器 |

fractional LMUL 使用单个架构寄存器的一部分，不需要多寄存器组分配；P1 可先保守按 1 个物理寄存器处理。

### 5.5 mask v0 特殊处理

mask 源规则：

- `vm=0` 时读取 mask 源，架构寄存器固定为 `v0`。
- `vm=1` 时不读取 mask 源，`srcvm_data` 应强制 ready/wb。
- mask 寄存器总是单寄存器，不按 LMUL/EMUL 扩展。
- 如果当前 packet 前序指令写 `v0`，后序 `srcvm` 必须包内旁路。

mask 目的规则：

- 产生 mask 结果的指令目的仍是向量寄存器，但结果布局按 mask EEW=1。
- mask 目的 tail 总是 agnostic，通常不需要旧目的 merge；但是否可省旧目的读应由 DP 的 policy 信号明确控制。

## 6. Tail/Mask Policy 与旧目的读

RVV 1.0 中 `vta/vma` 会影响 inactive/tail 元素是否保留旧目的。

| 场景 | 是否需要旧目的物理寄存器 |
| --- | --- |
| tail agnostic 且 mask agnostic | 通常不需要 |
| tail undisturbed | 需要旧目的用于 tail merge |
| mask undisturbed 且 mask enabled | 需要旧目的用于 inactive merge |
| mask 目的寄存器 | tail 规则特殊，按规范 mask tail agnostic 处理 |

建议在 IR DP 中新增：

```verilog
dp_vrt_instN_old_dst_need;
```

VRT 输出：

```verilog
vrt_dp_instN_old_dst_data
```

或者复用 `rel_vreg`，由 RF 侧把 `rel_vreg` 当作 old-dst merge 源读地址。但要注意：`rel_vreg` 原本给 free-list/RTU 用，不能在 retire 前被释放，否则 RF merge 读会读到错误数据。建议显式区分：

| 信号 | 用途 |
| --- | --- |
| `rel_vreg` | 旧映射，供释放/恢复管理 |
| `old_dst_vreg` | 旧目的 merge 源，供 RF/执行读 |

P0 可先不实现 old-dst merge，只支持 agnostic 策略或让执行单元保守处理；P2 必须补齐。

## 7. RF 侧 VRF/PRF 开发要求

### 7.1 `ct_idu_rf_prf_vregfile` 需要真实实现

当前 `ct_idu_rf_prf_vregfile.v` 输出固定 0，不满足 RVV 1.0。建议实现目标：

| 能力 | P0 | P1/P2 |
| --- | --- | --- |
| 基础读端口 | pipe5 srcv0、pipe6/7 srcv0/1/2/srcvm | 支持 old dst merge 源、更多 segment/whole-register 读端口 |
| 写端口 | LSU pipe3 WB、VFPU pipe6/7 WB | 支持 group write、partial write、tail/mask merge |
| 数据宽度 | 现有 64b 片兼容 | VLEN=128b 至少 VR0/VR1 两片；更高 VLEN 需要参数化 |
| 前递 | 复用 `ct_idu_rf_fwd_vreg` | 增加 group/old-dst/mask 前递 |

### 7.2 RF pipe6/7 payload 扩展

RF pipe6/7 需要获得完整 RVV policy：

| 字段 | 当前风险 | 建议 |
| --- | --- | --- |
| `vsew` | pipe6/7 decode 输入仅 2 位 | 扩展为 3 位 |
| `vlmul` | 多处仅 2 位 | 扩展为 3 位 signed 编码 |
| `vta/vma` | 可能未进入 RF payload | 加入 VIQ/RF pipe payload |
| `vm` | 需要驱动 `srcvm_vld` | 明确从 opcode bit25 生成并保存 |
| `vill` | 影响 illegal/执行 | 随 vtype 或在 IR 阶段拦截 |
| `old_dst_need` | 当前缺失 | 供 RF 读旧目的 merge |

### 7.3 前递网络

前递比较必须从单寄存器扩展到寄存器组：

| 场景 | P0 | P1/P2 |
| --- | --- | --- |
| LMUL=1 | 比较单个 `vreg` | 保持 |
| LMUL>1 源组 | 暂不支持或保守 stall | 比较组内每个物理 vreg |
| mask v0 | 单独比较当前 `v0` 映射 | 保持单寄存器 |
| old dst merge | 可不支持 | 增加 old-dst 前递或 stall 等待 |

## 8. Free-list/RTU/PST 修改点

真实 VRT 不是孤立模块，还需要资源管理闭环。

### 8.1 分配

`ct_idu_ir_ctrl` 或相关 free-list 需要支持：

| 分配类型 | 数量 |
| --- | --- |
| 普通 LMUL=1 目的 | 1 个物理 vreg |
| LMUL=2/4/8 目的 | 2/4/8 个物理 vreg |
| fractional LMUL | P1 可保守 1 个物理 vreg |
| segment/whole-register | 按 NFIELDS/whole-register 数量扩展 |

### 8.2 释放

释放不能只依赖单个 `rel_vreg`。P1 后需要：

```verilog
rel_vreg_group[7:0]
rel_vreg_cnt
```

释放时机仍应与现有 RT/FRT 一致：投机 rename 阶段只记录旧映射，真正释放由 retire 或错误路径恢复控制，避免精确状态被破坏。

### 8.3 Recover/PST

RTU/PST 需要保存架构向量寄存器到物理向量寄存器组的 committed 映射：

| 阶段 | P0 | P1/P2 |
| --- | --- | --- |
| recover map | 32 x 7b 当前映射 | 32 x base physical vreg + group metadata |
| old mapping | 单 `rel_vreg` | group list/count |
| flush | 全表恢复 | 全表恢复并恢复 group ownership |

## 9. 接口修改清单

### 9.1 `ct_idu_ir_vrt` 新增/恢复端口

| 端口 | 方向 | 位宽 | 说明 |
| --- | --- | --- | --- |
| `forever_cpuclk` | input | 1 | VRT 表项主时钟 |
| `cpurst_b` | input | 1 | 低有效复位 |
| `cp0_idu_icg_en` | input | 1 | 时钟门控使能 |
| `cp0_yy_clk_en` | input | 1 | 全局时钟使能 |
| `pad_yy_icg_scan_en` | input | 1 | 扫描模式 |
| `ctrl_ir_stall` | input | 1 | IR stall，屏蔽真实写入 |
| `ctrl_rt_inst[0:3]_vld` | input | 1 | 四路 rename valid |
| `ifu_xx_sync_reset` | input | 1 | reset 初始化映射 |
| `rtu_yy_xx_flush` | input | 1 | flush 恢复映射 |
| `rtu_idu_flush_fe/is` | input | 1 | 传给 entry 清理 ready 状态 |
| `dp_vrt_inst[0:3]_srcv2_reg` | input | 6 | 第三向量源架构寄存器 |
| `dp_vrt_inst[0:3]_old_dst_need` | input | 1 | 旧目的 merge 需要 |
| `dp_vrt_inst[0:3]_dst_group_size` | input | 4 | 目的寄存器组大小 |
| `dp_vrt_inst[0:3]_srcv*_group_size` | input | 4 | 源寄存器组大小 |
| `vrt_dp_inst[0:3]_old_dst_vreg` | output | 7 | 旧目的 merge 源物理寄存器 |
| `vrt_dp_inst[0:3]_rel_vreg_group` | output | 56 | P1，旧目的组列表 |
| `vrt_dp_inst[0:3]_rel_vreg_cnt` | output | 4 | P1，旧目的组数量 |

### 9.2 `ct_idu_ir_dp` 修改

| 修改 | 说明 |
| --- | --- |
| 生成完整 `srcv2_reg` | 不再只有 `srcv2_vld` |
| 生成 `srcvm_vld = vec && vm==0` | mask 源固定读 v0 |
| 生成 `old_dst_need` | 根据 `vta/vma/vm/指令类型` 判断 |
| 生成 `group_size` | 根据 LMUL/EMUL/segment/whole-register 判断 |
| 保留完整 `vtype` | `vsew[2:0]`、`vlmul[2:0]`、`vta`、`vma`、`vill` |

### 9.3 `ct_idu_ir_ctrl/free-list` 修改

| 修改 | 说明 |
| --- | --- |
| 向量物理寄存器多分配 | 支持每条指令最多 8 个物理 vreg |
| 分配失败 stall | free-list 不足时阻塞 IR |
| recover 回滚 | flush 时恢复 free-list 和 VRT 一致 |
| VIQ/LSIQ 资源估计 | segment/whole-register 可能占更多资源 |

### 9.4 RF/VFPU/LSU 修改

| 修改 | 说明 |
| --- | --- |
| `ct_idu_rf_prf_vregfile` 真实存储 | 替换零输出 |
| pipe6/7 `vsew` 扩到 3 位 | 支持 RVV 1.0 reserved/illegal 判断 |
| `vlmul` 扩到 3 位 | 支持 fractional LMUL |
| old-dst 读端口 | 支持 undisturbed merge |
| group read/write | 支持 LMUL>1、segment、whole-register |

## 10. 实现步骤建议

### 10.1 P0：真实 VRT 单寄存器实现

1. 从 `ct_idu_ir_frt.v` 复制生成风格到 `ct_idu_ir_vrt.v`。
2. 恢复时钟、reset、stall、四路 valid、flush/recover 端口。
3. 实例化 `ct_idu_dep_vreg_srcv2_entry`，至少 `reg_0~reg_31`。
4. 实现 `vrt_reset_updt_vreg`。
5. 实现 inst0~inst3 写使能和 one-hot 写选择。
6. 实现 srcv0/srcv1/srcv2/srcvm 读取。
7. 实现包内 RAW/WAW 旁路。
8. 实现 `rel_vreg` 输出。
9. 接入 FRT 已使用的 VFPU/LSU ready 更新信号。
10. 暂时限制 LMUL>1 或保守按单寄存器处理。

### 10.2 P1：LMUL/EMUL 组 rename

1. IR DP 输出每条指令的 source/dest group size。
2. free-list 支持多物理 vreg 分配。
3. VRT 表项扩展为 base physical vreg + group metadata，或建立 group allocation side table。
4. 输出 `rel_vreg_group/cnt`。
5. RF 支持组读地址生成。
6. 补对齐 illegal/stall 逻辑。

### 10.3 P2：policy 和 old-dst merge

1. IR DP 生成 `old_dst_need`。
2. VRT 输出 old-dst merge 源。
3. RF VRF 增加旧目的读端口或复用读端口。
4. VFPU/LSU 写回支持 tail/mask merge。
5. 对 mask destination 的特殊 tail agnostic 规则加验证。

### 10.4 P3：完整 RVV 1.0 闭环

1. 打开 RF pipe6/7 vector decode。
2. 完成 `vsetvli/vsetivli/vsetvl` 和 `vtype/vl` 有序性。
3. 完成 vector load/store segment/indexed/whole-register。
4. 完成异常、vill、reserved encoding 检查。
5. 做随机指令流和 flush/recover 压测。

## 11. 验证计划

### 11.1 VRT 基础 directed case

| 用例 | 期望 |
| --- | --- |
| reset 后读 `v0~v31` | 映射为初始物理寄存器，ready/wb 为 1 |
| 单条 `vd` rename | `rel_vreg` 为旧映射，表项更新为新物理寄存器 |
| 后续读同一 `vd` | 源物理寄存器为新映射 |
| `srcv*_vld=0` | 源 ready/wb 强制为 1 |
| `vm=1` | `srcvm` 强制 ready，不读 v0 |
| `vm=0` | `srcvm` 读取 v0 当前映射 |

### 11.2 包内依赖 case

| 指令包 | 检查 |
| --- | --- |
| inst0 写 v5，inst1 读 v5 | inst1 源旁路到 inst0 新物理 vreg |
| inst0 写 v0，inst1 masked 指令读 mask | inst1 `srcvm` 旁路到 inst0 新物理 vreg |
| inst0 写 v5，inst1 写 v5 | inst1 `rel_vreg` 为 inst0 新物理 vreg |
| inst0/1/2 都写 v7，inst3 读 v7 | inst3 读到 inst2 新物理 vreg |

### 11.3 Recover case

| 场景 | 检查 |
| --- | --- |
| rename 后 flush | VRT 恢复到 RTU recover map |
| recover 同周期有新 rename | recover 优先，屏蔽新写入 |
| recover 后读源 | 读到 recover map 中的物理 vreg |
| free-list recover | VRT 映射与 free-list 可用集合一致 |

### 11.4 RVV policy case

| 场景 | 检查 |
| --- | --- |
| tail undisturbed | old-dst merge 源有效 |
| mask undisturbed 且 `vm=0` | old-dst merge 源和 mask 源都有效 |
| tail/mask agnostic | 可不读 old-dst |
| mask destination | 按 mask tail agnostic 特例处理 |

### 11.5 LMUL/EMUL case

| 场景 | 检查 |
| --- | --- |
| LMUL=2/4/8 合法对齐 | 分配对应数量物理 vreg |
| LMUL=2/4/8 非对齐 | illegal 或阻止分派 |
| fractional LMUL | 单物理 vreg 保守处理 |
| widening/narrowing | EMUL 与源/目的组大小符合预期 |
| segment load/store | `NFIELDS` 相关寄存器组资源正确 |

## 12. 风险与决策点

| 风险 | 影响 | 建议 |
| --- | --- | --- |
| 只实现单 `rel_vreg` | LMUL>1 释放错误 | P1 增加 group release 接口 |
| `srcv2_reg` 缺失 | 三源向量指令依赖错误 | P0 就补接口 |
| recover 宽度仍为 192 位 | 物理 vreg 数量限制为 64 | 尽早扩展到 224 位 |
| mask v0 未包内旁路 | masked 指令读取错误 mask | 加专门 directed case |
| old-dst 与 rel 复用 | 旧目的可能过早释放 | 区分 old-dst merge 源和 release 旧映射 |
| VRF 仍零输出 | RF/执行数据错误 | P2 前必须实现真实 `ct_idu_rf_prf_vregfile` |
| `vsew/vlmul` 位宽不足 | RVV 1.0 vtype 不完整 | pipe6/7 和 VIQ payload 扩展为 3 位 |

## 13. 推荐代码修改顺序

1. 修改 `ct_idu_ir_vrt.v`，实现 P0 真实 VRT。
2. 修改 `ct_idu_top.v` 连接 VRT 新增端口。
3. 修改 `ct_idu_ir_dp.v`，补 `srcv2_reg`、`srcvm`、`old_dst_need`、完整 vtype 输出。
4. 修改 `ct_idu_ir_ctrl.v` 和 free-list，支持向量目的分配失败 stall。
5. 修改 RTU/PST recover 接口，扩展 `recover_vreg` 宽度。
6. 打开并修正 RF pipe6/7 vector decode。
7. 实现 `ct_idu_rf_prf_vregfile` 真实读写。
8. 增加 directed test 和随机 RVV rename/flush 测试。

## 14. 最小可交付定义

P0 最小可交付应满足：

- `ct_idu_ir_vrt` 不再输出常量。
- `v0~v31` 有真实当前物理映射。
- 支持四路 rename 写入和源读取。
- 支持包内 RAW/WAW。
- 支持 `srcvm` 固定读 `v0`。
- 支持 `rtu_idu_rt_recover_vreg` 恢复。
- 能输出每条指令 `rel_vreg`。
- 能接收 VFPU/LSU/RF 的 ready/wb 更新。
- 对 LMUL>1 明确保守策略：要么阻止发射，要么单寄存器临时实现并在文档/断言中限制。

完成 P0 后，IR 阶段才具备 RVV 1.0 后续扩展的基本 rename 基座。
