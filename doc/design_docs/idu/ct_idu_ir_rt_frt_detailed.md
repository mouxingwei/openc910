# ct_idu_ir_rt 与 ct_idu_ir_frt 详细方案

## 1. 范围与结论

本文档依据 `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_rt.v` 与 `ct_idu_ir_frt.v` 源码整理，覆盖整数寄存器重命名表 RT 和浮点寄存器重命名表 FRT 的模块定位、表项结构、读写流程、组内旁路、ready 更新、flush/recover、时钟门控和验证关注点。

结论：

| 模块 | 是否实现 | 主要功能 |
| --- | --- | --- |
| `ct_idu_ir_rt` | 已实现 | 维护整数架构寄存器到整数物理寄存器的映射，并输出源操作数 ready/wb/物理寄存器号和旧目的寄存器 |
| `ct_idu_ir_frt` | 已实现 | 维护浮点架构寄存器到浮点/向量物理寄存器视图的映射，同时维护 EREG 映射和 FMLA/FM0V 相关状态 |

二者都不是单纯占位模块。`ct_idu_ir_rt` 中 `x0` 特殊常量 ready，其余表项实例化 `ct_idu_dep_reg_src2_entry`；`ct_idu_ir_frt` 实例化 `ct_idu_dep_vreg_srcv2_entry` 并额外维护 `ereg`。两者均支持四路 IR 指令同时读写、RTU recover、同步 reset 和执行单元写回 ready 更新。

## 2. 设计定位

IR 阶段负责 rename 之后、进入 issue queue 之前的依赖信息生成。RT/FRT 位于 `ct_idu_ir_dp` 旁边，向 DP 返回每条指令的源寄存器依赖信息和目的旧映射。

```text
------------------+
| ct_idu_ir_dp    |
| decode/rename   |
+--------+---------+
         |
         | inst[0:3] src/dst arch reg, new physical dst
         v
+--------+---------+        +----------------------+
| ct_idu_ir_rt    |<------- | IU/LSU/VFPU/RF ready |
| integer RT      |        +----------------------+
+--------+---------+
         |
         | source data, released old preg
         v
+--------+---------+
| ct_idu_ir_dp    | -> issue queue create data
+------------------+

+------------------+
| ct_idu_ir_frt   | 同理服务浮点/向量寄存器视图，并输出 EREG old mapping
+------------------+
```

### 2.1 与上下游的职责边界

| 模块 | 对 RT/FRT 的职责 |
| --- | --- |
| `ct_idu_ir_dp` | 提供 4 路指令的源/目的架构寄存器号、目的物理寄存器号、目的有效、FMLA/FMOV 等属性；接收源依赖数据和释放旧寄存器号 |
| `ct_idu_ir_ctrl` | 提供 `ctrl_rt_inst[0:3]_vld`、`ctrl_ir_stall`，决定本周期哪些指令真正更新 rename table |
| `ct_idu_rf_ctrl/rf_dp` | 通过目的寄存器 latch valid 和目的物理寄存器号，反馈 RF 阶段已 latch 的目的寄存器状态 |
| IU/LSU/VFPU | 反馈执行/写回阶段的目的物理寄存器号和 valid，用于置 ready/wb |
| RTU | 在 flush/recover/reset 时提供 retire/recover 视图，恢复投机 rename table |

## 3. 表项数据结构

### 3.1 RT 表项

`ct_idu_ir_rt` 的普通表项通过 `ct_idu_dep_reg_src2_entry` 维护，读出宽度为 13 位。`x0` 不实例化表项，而是固定输出常量。

| 字段 | 位 | 含义 |
| --- | --- | --- |
| `rdy` | `[0]` | 当前映射的物理整数寄存器是否 ready |
| `wb` | `[1]` | 当前映射是否已经写回/可认为完成 |
| `preg` | `[8:2]` | 当前架构寄存器映射到的物理整数寄存器号 |
| `mla_rdy` | `[9]` | MLA/特殊多源相关 ready 辅助位 |
| 保留/entry 内部状态 | `[12:10]` | entry 模块内部用于依赖/旁路控制的状态位 |

`x0` 表项固定为 `13'b0111000000011`，含义是始终 ready、始终 wb，物理寄存器号固定为 0。

### 3.2 FRT 表项

`ct_idu_ir_frt` 的普通表项通过 `ct_idu_dep_vreg_srcv2_entry` 维护，读出同样为 13 位，但物理寄存器号为 6 位 `freg/vreg` 视图。

| 字段 | 位 | 含义 |
| --- | --- | --- |
| `rdy` | `[0]` | 当前映射是否 ready |
| `wb` | `[1]` | 当前映射是否已经写回 |
| `freg/vreg` | `[7:2]` | 当前浮点架构寄存器映射到的物理寄存器号 |
| `mla_rdy` | `[8]` 或输出组合中的辅助位 | FMLA/VMLA 类指令的源 ready 辅助信息 |
| `srcv2/vmla` 辅助状态 | entry 内部状态 | 用于源 2、FMLA/VMLA 相关依赖跟踪 |

FRT 还包含独立的 EREG 映射：

| 字段 | 位宽 | 含义 |
| --- | --- | --- |
| `ereg` / `reg_e_create_ereg` | 5 | 当前浮点异常/扩展状态寄存器映射 |
| `frt_dp_inst*_rel_ereg` | 5 | 当前指令重命名前释放的旧 EREG 映射 |

### 3.3 表项数量

| 模块 | 表项范围 | 说明 |
| --- | --- | --- |
| RT | `reg_0` 到 `reg_32` | `reg_0` 对应 x0 常量；`reg_1~31` 对应整数架构寄存器；`reg_32` 用于 `dst_reg[5]` 扩展编码场景 |
| FRT | `reg_0` 到 `reg_32` + `reg_e` | `reg_0~31` 对应浮点架构寄存器；`reg_32` 用于 `dstf_reg[5]` 扩展编码场景；`reg_e` 维护 EREG |

## 4. `ct_idu_ir_rt` 详细方案

### 4.1 模块接口分组

| 分组 | 代表信号 | 方向 | 功能 |
| --- | --- | --- | --- |
| 时钟/控制 | `forever_cpuclk`、`cpurst_b`、`cp0_idu_icg_en`、`cp0_yy_clk_en`、`pad_yy_icg_scan_en` | input | 主时钟、复位、门控和扫描控制 |
| IR 控制 | `ctrl_ir_stall`、`ctrl_rt_inst[0:3]_vld` | input | 控制本周期四路指令是否写入 RT |
| DP 源/目的 | `dp_rt_inst*_src[0:2]_reg/vld`、`dp_rt_inst*_dst_reg/dst_preg/dst_vld` | input | 四路指令的架构源/目的和新分配物理目的 |
| RF latch | `ctrl_xx_rf_pipe[0:1]_preg_lch_vld_dupx`、`dp_xx_rf_pipe[0:1]_dst_preg_dupx` | input | RF 阶段目的寄存器已 latch，更新 ready 相关状态 |
| 执行写回 | `iu_idu_*_preg_*`、`lsu_idu_*_preg_*`、`vfpu_idu_*_preg_*` | input | IU/LSU/VFPU 对整数物理寄存器的执行/写回 ready 更新 |
| 恢复 | `ifu_xx_sync_reset`、`rtu_yy_xx_flush`、`rtu_idu_rt_recover_preg` | input | reset 或 flush 后恢复 rename table |
| 输出到 DP | `rt_dp_inst*_src[0:2]_data`、`rt_dp_inst*_rel_preg` | output | 源依赖信息和目的重命名前的旧物理寄存器 |

### 4.2 写入流程

RT 支持 4 路 IR 指令同周期写入。每路指令写入条件：

```text
instN_write_en =
  ctrl_rt_instN_vld
  && !ctrl_ir_stall
  && !rt_recover_updt_vld
  && dp_rt_instN_dst_vld
```

目的架构寄存器号的低 5 位通过 `ct_rtu_expand_32` 展开为 32 位 one-hot。若 `dst_reg[5] == 0`，写 `reg_0~31`；若 `dst_reg[5] == 1`，通过 `reg_writeN_en[32]` 写扩展表项 `reg_32`。

同周期多路写同一个架构寄存器时，后面的 inst 优先级更高。创建值由类似如下逻辑选择：

```text
reg_X_create_preg =
  inst3 命中 ? inst3_dst_preg :
  inst2 命中 ? inst2_dst_preg :
  inst1 命中 ? inst1_dst_preg :
  inst0 命中 ? inst0_dst_preg :
  recover/reset 映射
```

表项 create data 的核心内容是 `{ready/recover state, physical register, wb state}`。普通重命名写入后，新目的物理寄存器初始通常处于 not ready，等待 RF/执行/写回路径置位。

### 4.3 读取流程

RT 对每路指令读取：

| 指令 | 读取项 |
| --- | --- |
| inst0 | `src0`、`src1`、`dst old mapping` |
| inst1 | `src0`、`src1`、`src2`、`dst old mapping` |
| inst2 | `src0`、`src1`、`dst old mapping` |
| inst3 | `src0`、`src1`、`dst old mapping` |

源读取通过 `case (dp_rt_instN_srcM_reg[5:0])` 从 `reg_0_read_data` 到 `reg_32_read_data` 选择表项。输出编码：

| 输出字段 | 位 | 含义 |
| --- | --- | --- |
| `rt_dp_inst*_src*_data[0]` | 1 | 源 ready，若源无效则强制 ready |
| `rt_dp_inst*_src*_data[1]` | 1 | 源 wb，若源无效则强制 wb |
| `rt_dp_inst*_src*_data[8:2]` | 7 | 源物理寄存器号 |
| `rt_dp_inst*_src2_data[9]` | 1 | 第三源/MLA 相关辅助 ready |

目的旧映射读取用于释放旧物理寄存器：

```text
rt_dp_instN_rel_preg = 当前 dst 架构寄存器在 RT 中的旧 preg
```

### 4.4 组内 RAW 旁路

四路指令同周期进入 RT 时，后序指令的源可能依赖前序指令的目的。例如：

```text
inst0: x5 <- p40
inst1: src0 = x5
```

此时 inst1 不能直接使用旧 RT 表中的 x5 映射，而应拿到 inst0 的新目的物理寄存器 `p40`。RT 通过 `rt_inst*_src*_match_inst*` 类组合逻辑检测包内依赖，并在输出 `rt_dp_inst*_src*_data` 时选择前序指令的新 `dst_preg`。

组内旁路优先级遵循指令顺序：

| 读取指令 | 可匹配前序 |
| --- | --- |
| inst1 | inst0 |
| inst2 | inst1、inst0 |
| inst3 | inst2、inst1、inst0 |

RT 对 MOV/MLA 类指令还有额外的 ready 旁路辅助，避免只旁路物理寄存器号而丢失特殊 ready 语义。

### 4.5 Ready 更新来源

RT 表项不仅记录映射，还追踪当前物理寄存器是否 ready。主要 ready 更新来源：

| 来源 | 代表信号 | 说明 |
| --- | --- | --- |
| RF latch | `ctrl_xx_rf_pipe[0:1]_preg_lch_vld_dupx` + `dp_xx_rf_pipe[0:1]_dst_preg_dupx` | 指令进入 RF 后，相关 latch 状态反馈给 RT entry |
| IU EX/WB | `iu_idu_ex2_pipe[0:1]_wb_preg_*`、`iu_idu_div_preg_dupx` | 整数执行和除法写回更新 ready/wb |
| LSU | `lsu_idu_ag/dc/wb_pipe3_preg_*` | load 相关执行和写回更新 ready/wb |
| VFPU MFVR | `vfpu_idu_ex1_pipe[6:7]_preg_dupx` | 向量/浮点到整数寄存器搬移路径更新整数 preg |

当前 RT 中 issue bypass ready 被固定为 0：

```text
alu0_reg_fwd_vld = 1'b0
alu1_reg_fwd_vld = 1'b0
mla_reg_fwd_vld  = 1'b0
```

源码注释说明 IR 阶段不需要 issue bypass 信号，只有 IS 阶段需要；这里固定为 0 也是时序优化。

### 4.6 Flush/Recover/Reset

RT 恢复逻辑由 `rt_recover_updt_vld` 控制：

| 场景 | 恢复源 |
| --- | --- |
| `ifu_xx_sync_reset` | 初始化映射，通常为 `x0~x31 -> p0~p31` |
| `rtu_yy_xx_flush` | 使用 `rtu_idu_rt_recover_preg[223:0]` 从 RTU/PST 恢复精确架构状态 |

恢复优先级高于正常 rename 写入。恢复时 `reg_write_en[32:0]` 全部打开，将所有表项写回恢复映射。

## 5. `ct_idu_ir_frt` 详细方案

### 5.1 模块接口分组

| 分组 | 代表信号 | 方向 | 功能 |
| --- | --- | --- | --- |
| 时钟/控制 | `forever_cpuclk`、`cpurst_b`、`cp0_idu_icg_en`、`cp0_yy_clk_en`、`pad_yy_icg_scan_en` | input | 主时钟、复位、门控和扫描控制 |
| IR 控制 | `ctrl_ir_stall`、`ctrl_rt_inst[0:3]_vld` | input | 控制四路 FRT rename 写入 |
| DP 源/目的 | `dp_frt_inst*_srcf[0:2]_reg/vld`、`dstf_reg/dstf_vld`、`dst_freg` | input | 浮点源/目的架构寄存器和新分配物理寄存器 |
| EREG | `dp_frt_inst*_dst_ereg`、`dp_frt_inst*_dste_vld` | input | 浮点异常/扩展状态目的映射 |
| 特殊属性 | `dp_frt_inst*_fmla`、`dp_frt_inst*_fmov` | input | FMLA/FMOV 相关旁路和 ready 语义 |
| RF/VFPU/LSU 更新 | `ctrl_xx_rf_pipe[6:7]_vmla_lch_vld_dupx`、`vfpu_idu_*_vreg_*`、`lsu_idu_*_vreg_*` | input | 向量/浮点目的寄存器 ready/wb 更新 |
| 恢复 | `ifu_xx_sync_reset`、`rtu_yy_xx_flush`、`rtu_idu_rt_recover_freg`、`rtu_idu_rt_recover_ereg` | input | 恢复 FRT 和 EREG |
| 输出到 DP | `frt_dp_inst*_srcf[0:2]_data`、`frt_dp_inst*_rel_freg`、`frt_dp_inst*_rel_ereg` | output | 浮点源依赖信息和释放旧映射 |

### 5.2 写入流程

FRT 同样支持 4 路写入。普通浮点目的写入条件：

```text
instN_write_en =
  ctrl_rt_instN_vld
  && !ctrl_ir_stall
  && !frt_recover_updt_vld
  && dp_frt_instN_dstf_vld
```

EREG 写入条件：

```text
e_writeN_en =
  ctrl_rt_instN_vld
  && !frt_recover_updt_vld
  && !ctrl_ir_stall
  && dp_frt_instN_dste_vld
```

`dstf_reg[4:0]` 通过 `ct_rtu_expand_32` 展开为 32 位 one-hot；`dstf_reg[5]` 为 1 时写扩展表项 `reg_32`。多路同时写同一个架构浮点寄存器时，inst3 优先于 inst2，inst2 优先于 inst1，inst1 优先于 inst0。

### 5.3 初始化与恢复

FRT reset 时构造初始浮点映射：

```text
fr0 -> f0
fr1 -> f1
...
fr31 -> f31
```

对应源码中 `frt_reset_updt_freg[191:0]` 由 32 个 6 位物理寄存器号拼接而成。

恢复逻辑：

| 条件 | FRT 映射来源 | EREG 来源 |
| --- | --- | --- |
| `ifu_xx_sync_reset` | `frt_reset_updt_freg` | `5'd0` |
| `rtu_yy_xx_flush` | `rtu_idu_rt_recover_freg[191:0]` | `rtu_idu_rt_recover_ereg[4:0]` |

恢复时 `frt_recover_updt_vld` 拉高，所有 FRT 表项和 EREG 同步写入恢复值，并屏蔽正常 rename 写入。

### 5.4 读取流程

FRT 对每路指令最多读取 3 个浮点源和 1 个目的旧映射。

| 输出字段 | 位宽 | 含义 |
| --- | --- | --- |
| `frt_dp_inst*_srcf0_data` | 9 | 源 0 ready/wb/物理寄存器号 |
| `frt_dp_inst*_srcf1_data` | 9 | 源 1 ready/wb/物理寄存器号 |
| `frt_dp_inst*_srcf2_data` | 10 | 源 2 ready/wb/物理寄存器号和 FMLA/VMLA 辅助位 |
| `frt_dp_inst*_rel_freg` | 7 | 目的重命名前的旧物理浮点/向量寄存器 |
| `frt_dp_inst*_rel_ereg` | 5 | 目的重命名前的旧 EREG 映射 |

源读取和 RT 类似，通过 `case (dp_frt_instN_srcfM_reg[5:0])` 从 `reg_0_read_data` 到 `reg_32_read_data` 选择当前映射。如果源无效，输出 ready/wb 被置为有效，避免无用依赖阻塞。

### 5.5 组内 RAW 旁路

FRT 处理同一个 fetch/rename packet 内的浮点 RAW 依赖：

| 读取指令 | 可匹配前序 |
| --- | --- |
| inst1 | inst0 |
| inst2 | inst1、inst0 |
| inst3 | inst2、inst1、inst0 |

匹配条件包括：

```text
ctrl_rt_instN_vld
&& dp_frt_instN_srcfM_vld
&& ctrl_rt_instK_vld
&& dp_frt_instK_dstf_vld
&& dp_frt_instK_dstf_reg == dp_frt_instN_srcfM_reg
```

匹配后，后序源直接使用前序指令的新 `dst_freg`，而不是表中旧映射。对 `srcf2`、FMLA、FMOV，FRT 还有 `frt_dp_inst01_srcf2_match`、`frt_dp_inst12_srcf2_match` 等 match 输出，供 DP 处理多源/乘加类依赖。

### 5.6 Ready 更新来源

FRT 表项的 ready/wb 更新覆盖 LSU vector load、VFPU pipe6/7、RF VMLA latch 等路径：

| 来源 | 代表信号 | 说明 |
| --- | --- | --- |
| RF VMLA latch | `ctrl_xx_rf_pipe[6:7]_vmla_lch_vld_dupx` + `dp_xx_rf_pipe[6:7]_dst_vreg_dupx` | VMLA 指令进入 RF 后对目的向量寄存器状态产生影响 |
| LSU vector load | `lsu_idu_ag_pipe3_vload_inst_vld`、`lsu_idu_dc_pipe3_vload_inst_vld_dupx`、`lsu_idu_wb_pipe3_wb_vreg_vld_dupx` | load 向量目的寄存器的 AG/DC/WB ready 更新 |
| VFPU EX/WB | `vfpu_idu_ex[1:3]_pipe[6:7]_data_vld_dupx`、`vfpu_idu_ex5_pipe[6:7]_wb_vreg_vld_dupx` | VFPU pipeline 中的目的寄存器 ready/wb 更新 |
| FMLA 特殊 ready | `vfpu_idu_ex[1:2]_pipe[6:7]_fmla_data_vld_dupx` | FMLA 结果 ready 时序与普通 VFPU 指令不同，需要单独处理 |

### 5.7 EREG 更新

FRT 中 `ereg` 记录当前浮点异常/扩展状态映射。四路指令的 `dste_vld` 控制写入，优先级同样按 inst3 到 inst0。恢复时使用 RTU 的 `rtu_idu_rt_recover_ereg`，reset 时置 0。

EREG 输出 `frt_dp_inst*_rel_ereg` 用于 IR DP 记录旧映射，后续在 retire/flush/free-list 管理时释放或恢复。

## 6. RT 与 FRT 对比

| 项目 | RT | FRT |
| --- | --- | --- |
| 架构寄存器 | 整数 `x` 寄存器 | 浮点 `f` 寄存器及扩展 `ereg` |
| 物理寄存器号宽度 | 7 位 `preg` | 6 位 `freg/vreg`，输出释放号扩展为 7 位 |
| 表项模块 | `ct_idu_dep_reg_src2_entry` | `ct_idu_dep_vreg_srcv2_entry` |
| x0/fr0 特殊性 | `x0` 固定 ready/wb，物理号 0 | `fr0` 是普通可重命名表项 |
| ready 来源 | IU、LSU、VFPU MFVR、RF integer latch | VFPU、LSU vector load、RF VMLA latch |
| 额外状态 | MLA ready 辅助 | FMLA/VMLA、FMOV、EREG |
| recover 输入 | `rtu_idu_rt_recover_preg[223:0]` | `rtu_idu_rt_recover_freg[191:0]`、`rtu_idu_rt_recover_ereg[4:0]` |

## 7. 关键时序与门控

### 7.1 写使能与门控写使能分离

两个模块都区分：

| 信号 | 是否受 stall 影响 | 用途 |
| --- | --- | --- |
| `instN_write_en` | 受 `ctrl_ir_stall` 影响 | 真正更新表项内容 |
| `instN_gateclk_write_en` | 不受 `ctrl_ir_stall` 影响 | 打开局部时钟门控，降低关键路径压力 |

这种设计允许门控条件更早、更宽松地产生，而数据状态更新仍受 stall 精确控制。

### 7.2 Recover 优先级

Recover/reset 优先于普通 rename 写入：

```text
reg_write_en = recover_all_entries | inst0_write | inst1_write | inst2_write | inst3_write
```

同时 `instN_write_en` 中包含 `!recover_updt_vld`，避免 flush 周期产生投机写入污染恢复状态。

### 7.3 读路径复杂度

RT/FRT 的源读取采用大 case 从 33 个表项中选择，且每路指令多个源并行读取。组内 RAW 旁路又增加了前序指令比较和选择逻辑，因此这是 IR 阶段较重的组合路径之一。源码中多个 bypass ready 信号固定为 0 或门控写使能忽略 stall，都是为时序做的折中。

## 8. 异常、Flush 与精确状态

RT/FRT 的关键目标是支持乱序投机执行下的精确状态恢复：

1. Rename 时，目的架构寄存器写入新物理寄存器号。
2. 同时输出旧映射 `rel_preg/rel_freg/rel_ereg`，供后续 retire/free-list 或 rollback 使用。
3. 发生 flush 时，RTU 将 committed 或 recover 点的映射表送回 IR。
4. RT/FRT 全表恢复，丢弃错误路径 rename 结果。

因此 RT/FRT 的正确性不仅影响依赖判断，也直接影响物理寄存器释放、错误路径清理和异常精确性。

## 9. 验证建议

| 场景 | 检查点 |
| --- | --- |
| reset 初始化 | RT `x0~x31`、FRT `fr0~fr31` 映射是否初始化为固定顺序 |
| 四路连续写同一目的 | inst3 是否最高优先级，旧映射输出是否符合指令顺序 |
| 包内 RAW | inst1/2/3 读取前序目的时是否得到新物理寄存器 |
| 源无效 | `src*_vld=0` 时 ready/wb 是否强制为 1 |
| x0 | `x0` 是否始终 ready/wb 且物理号为 0，不被普通写污染 |
| recover 同周期写入 | recover 是否屏蔽正常 rename 写入 |
| LSU/IU/VFPU 写回 | 对应目的物理寄存器的 ready/wb 是否被正确置位 |
| FRT FMLA/FM0V | `srcf2_match`、FMLA ready、FMOV 旁路是否正确 |
| EREG | `dste_vld` 写入、`rel_ereg` 输出、flush 恢复是否一致 |

## 10. RVV 1.0 相关提示

`ct_idu_ir_frt` 复用了向量依赖表项 `ct_idu_dep_vreg_srcv2_entry`，并能追踪 VFPU/LSU 的向量物理寄存器 ready，但它的设计目标仍是浮点 FRT/EREG，不等同于完整 RVV 1.0 的 VRT。

若补齐 RVV 1.0，应避免直接把 FRT 当作 VRT 使用，需要单独确认：

- `ct_idu_ir_vrt` 是否真正实例化并维护 `v0~v31` 映射。
- RVV 的 `v0` mask、`vm`、`vta/vma`、`vstart`、`vl/vtype` 与 rename/ready 的关系。
- 向量目的寄存器组在 LMUL > 1 时的多物理寄存器分配、释放和恢复。
- VIQ/RF/VFPU 对 `vsew[2:0]`、`vlmul[2:0]`、`vill` 等字段的传递是否完整。

## 11. 文件位置

| 文件 | 说明 |
| --- | --- |
| `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_rt.v` | 整数寄存器重命名表 |
| `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_ir_frt.v` | 浮点寄存器重命名表与 EREG 映射 |
| `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_dep_reg_src2_entry.v` | RT 表项依赖/ready 单元 |
| `C910_RTL_FACTORY/gen_rtl/idu/rtl/ct_idu_dep_vreg_srcv2_entry.v` | FRT/VRT 风格表项依赖/ready 单元 |
