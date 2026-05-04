# ct_idu_ir 全模块详细方案

## 1. 范围与定位

本文档依据 `C910_RTL_FACTORY/gen_rtl/idu/rtl` 下 `ct_idu_ir_*.v` 源码补充 IR 阶段的全模块设计说明。IR 阶段位于 IDU 前段，承接 ID 阶段下传的 4 路指令信息，完成 IR 流水寄存、基础类型解码、重命名表查询/更新相关信息组织、资源预分派控制，并向后续 ID/IS/RTU/HPCP 等模块提供控制与状态。

覆盖模块：

| 模块 | 文件 | 定位 |
| --- | --- | --- |
| `ct_idu_ir_ctrl` | `ct_idu_ir_ctrl.v` | IR 阶段控制、停顿、下传、预分派、物理寄存器分配有效控制 |
| `ct_idu_ir_dp` | `ct_idu_ir_dp.v` | IR 阶段数据通路，保存 4 路指令数据并组合解码/重命名表结果 |
| `ct_idu_ir_decd` | `ct_idu_ir_decd.v` | 单条指令轻量解码，产生 load/store/bar/vector/fp 等类型标志 |
| `ct_idu_ir_rt` | `ct_idu_ir_rt.v` | 整数物理寄存器重命名/相关性表查询 |
| `ct_idu_ir_frt` | `ct_idu_ir_frt.v` | 浮点/扩展寄存器重命名/相关性表查询 |
| `ct_idu_ir_vrt` | `ct_idu_ir_vrt.v` | 向量寄存器重命名接口占位/默认返回逻辑 |

## 2. 阶段结构

```text
ID pipedown data
      |
      v
+-------------+      +----------------+
| ir_ctrl     |<---->| ir_dp          |
| stall/alloc |      | 4 inst latches |
+-------------+      +----------------+
                           |
                           +--> 4 x ir_decd
                           |
                           +--> ir_rt  : integer source/remap query
                           +--> ir_frt : fp/extension source/remap query
                           +--> ir_vrt : vector source/remap query/defaults
                           |
                           v
                    ID/IS/RTU/HPCP outputs
```

IR 阶段采用 4 指令宽度处理。控制面主要关注是否允许从 ID 下传、是否因后级/资源/flush 停顿、以及每条指令是否需要 ROB/PST/各 issue queue/物理寄存器分配。数据面保存 `dp_id_pipedown_inst[0:3]_data[177:0]` 和依赖信息，并将字段拆解给控制、重命名表、后级流水和性能计数。

## 3. 模块详细设计

### 3.1 `ct_idu_ir_ctrl`

`ct_idu_ir_ctrl` 是 IR 阶段控制核心。源码端口规模为 84 个输入、100 个输出，说明其并非单纯流水寄存器控制，而是同时承担队列资源预分派、寄存器分配有效、HPCP 事件和前端可见状态输出。

主要输入分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| 时钟复位/门控 | `forever_cpuclk`、`cpurst_b`、`cp0_idu_icg_en`、`cp0_yy_clk_en`、`pad_yy_icg_scan_en` | 生成 IR 本地门控时钟 |
| ID 下传 | `ctrl_id_pipedown_gateclk`、`ctrl_id_pipedown_inst[0:3]_vld` | ID 阶段送入 IR 的有效信息 |
| 后级停顿/刷新 | `ctrl_is_stall`、`ctrl_is_dis_type_stall`、`rtu_idu_flush_fe`、`rtu_idu_flush_is`、`rtu_idu_flush_stall`、`rtu_yy_xx_flush` | 控制 IR 是否保持或清空 |
| 数据通路反馈 | `dp_ctrl_ir_inst*_dst*_vld`、`dp_ctrl_ir_inst*_ctrl_info`、`dp_ctrl_ir_inst*_bar`、`dp_ctrl_ir_inst*_hpcp_type` | 由 `ir_dp` 解码出的指令属性 |
| RTU 资源反馈 | `rtu_idu_alloc_{p,f,e,v}reg*_vld`、`rtu_idu_srt_en` | 物理寄存器可分配/特殊重命名状态 |
| issue queue 计数 | `aiq0/aiq1/viq0/viq1_ctrl_entry_cnt_updt_*` | 预分派时用于估计队列空间 |

主要输出分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| IR 流水控制 | `ctrl_ir_stall`、`ctrl_ir_stage_stall`、`ctrl_ir_pipedown`、`ctrl_ir_pipedown_inst[0:3]_vld` | IR 当前停顿和向后级下传有效 |
| 预分派控制 | `ctrl_ir_pre_dis_*_create*_en/sel` | 为 AIQ/BIQ/LSIQ/SDIQ/VIQ/VMB/ROB/PST 生成 create 选择 |
| 重命名控制 | `ctrl_rt_inst[0:3]_vld`、`idu_rtu_ir_{p,f,e,v}reg*_alloc_vld` | 控制 RT/VRT/FRT 查询与 RTU 资源申请 |
| 顶层状态 | `ctrl_top_ir_inst*_vld`、`ctrl_top_ir_*reg_not_vld`、`ctrl_top_ir_mispred_stall` | 暴露给 IDU top/调试/性能路径 |
| 性能计数 | `idu_hpcp_ir_inst*_vld/type` | IR 级指令类型计数 |

核心逻辑：

- `ir_inst_clk_en` 由 ID 下传门控、RTU flush 和本级有效寄存器共同驱动，只在指令进入、清空或保持有效状态需要更新时打开。
- `ir_inst[0:3]_vld` 保存 4 路 IR 有效位，reset/flush 时清零，ID 下传且未被 IR stall 阻塞时更新。
- `ctrl_ir_pipedown_stall = ctrl_ir_stage_stall || ctrl_is_dis_type_stall`，将本级资源型停顿和后级分派类型停顿合并。
- `ctrl_ir_pipedown_inst*_vld` 由本级指令有效、后级停顿和 flush 条件共同决定。
- 预分派信号按指令类型把最多 4 条指令映射到不同 issue queue create 口；对双 create 队列输出 `create0/create1` 与 `sel`，对 ROB/PST 输出 create 顺序选择。
- 物理寄存器分配有效按目的寄存器类型拆分：整数 `preg`、浮点 `freg`、扩展 `ereg`、向量 `vreg`。目的为 x0 或对应类型无效时不会申请。

时序与异常处理：

- 本模块只有 `forever_cpuclk` 时钟域。
- reset 使用低有效 `cpurst_b`。
- `rtu_idu_flush_fe/is` 和 `rtu_yy_xx_flush` 优先级高于普通下传，保证错误路径指令不继续分配资源。
- `rtu_idu_flush_stall` 会阻止 pipe down，避免 flush 窗口内错误地推进资源状态。

### 3.2 `ct_idu_ir_dp`

`ct_idu_ir_dp` 是 IR 阶段数据通路，源码端口规模为 103 个输入、173 个输出，并实例化 4 个 `ct_idu_ir_decd`。模块把来自 ID 阶段的压缩数据包拆字段、寄存、解码，并组合来自 RT/FRT/VRT 的源寄存器映射结果。

主要输入：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| ID 下传包 | `dp_id_pipedown_inst[0:3]_data[177:0]`、`dp_id_pipedown_dep_info[16:0]` | 4 路指令和相关性信息 |
| 控制 | `ctrl_id_pipedown_gateclk`、`ctrl_ir_stall`、`ctrl_dp_ir_inst0_vld` | 流水寄存器更新控制 |
| RT 查询结果 | `rt_dp_inst*_src*_data`、`rt_dp_inst*_rel_preg`、`rt_dp_inst**_src2_match` | 整数源/释放寄存器映射 |
| FRT 查询结果 | `frt_dp_inst*_srcf*_data`、`frt_dp_inst*_rel_freg/ereg`、`frt_dp_inst**_srcf2_match` | 浮点/扩展源映射 |
| VRT 查询结果 | `vrt_dp_inst*_srcv*_data`、`vrt_dp_inst*_rel_vreg`、`vrt_dp_inst**_srcv2_match` | 向量源映射 |

主要输出：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| 给控制 | `dp_ctrl_ir_inst*_dst*_vld`、`dp_ctrl_ir_inst*_ctrl_info`、`dp_ctrl_ir_inst*_hpcp_type`、`dp_ctrl_ir_inst*_bar` | 资源分配和预分派所需属性 |
| 给 RT/FRT/VRT | `dp_rt_inst*_src*`、`dp_frt_inst*_srcf*`、`dp_vrt_inst*_srcv*` | 逻辑寄存器号/读请求 |
| 给后级 | `dp_ir_pipedown_inst*_data`、`dp_ir_pipedown_dep_info` | 带物理寄存器号和解码属性的下传包 |
| 给 RTU | `idu_rtu_ir_*` 相关释放/分配辅助信息 | ROB/PST/重命名状态维护 |

内部设计要点：

- IR 数据包使用宏位段访问，如 `IR_DST_VLD`、`IR_DST_X0`、`IR_DSTV_VLD`、`IR_CTRL_INFO` 等，减少字段手写错误。
- 4 路指令各自实例化 `ct_idu_ir_decd`，输出 load/store/bar/vector/fp/vset 等轻量类型标志。
- 对源寄存器处理采用“逻辑字段 + 重命名表返回”的组合方式：`ir_dp` 提供逻辑源号，`ir_rt/frt/vrt` 返回物理源号、ready 位、源间 bypass match。
- 对同一拍内多指令的目的/源相关性，依赖 RT/FRT 的 `instXY_src*_match` 信号识别年轻指令读取年长指令刚分配的物理寄存器。
- 输出到后级的数据包既包含原始 opcode/PC/控制信息，也包含重命名后源/目的物理寄存器和释放寄存器信息。

### 3.3 `ct_idu_ir_decd`

`ct_idu_ir_decd` 是单条指令的快速分类解码器，输入 6 个、输出 26 个。它不产生完整执行功能码，而是把 opcode 和前级类型信号转化为 IR 阶段资源控制需要的标志位。

输入：

| 信号 | 说明 |
| --- | --- |
| `x_illegal` | 当前指令非法，非法时所有类型输出被屏蔽 |
| `x_opcode[31:0]` | 原始指令 |
| `x_type_alu` | 前级已识别的 ALU 类型 |
| `x_type_staddr` | store address 类型 |
| `x_type_vload` | vector load 类型 |
| `x_vsew[2:0]` | 向量元素宽度 |

输出类型：

| 类别 | 代表输出 | 用途 |
| --- | --- | --- |
| 标量访存/控制 | `x_load`、`x_store`、`x_bar`、`x_bar_type`、`x_pcall`、`x_rts`、`x_sync` | 选择 BIQ/LSIQ/SDIQ/控制类资源 |
| 系统/特殊 | `x_csr`、`x_ecall`、`x_pcfifo`、`x_str` | CP0/特殊流水控制 |
| 浮点/向量 | `x_fp`、`x_vec`、`x_vamo`、`x_unit_stride` | 选择浮点或向量资源 |
| 向量执行属性 | `x_vdiv`、`x_vmul`、`x_vmul_unsplit`、`x_vmla_short`、`x_vmla_type` | 后续 VIQ/VFPU 调度提示 |
| 向量配置 | `x_vsetvl`、`x_vsetvli`、`x_vsetivli` | vtype/vl 配置类指令识别 |
| 向量寄存器搬移 | `x_mfvr`、`x_mtvr`、`x_viq_srcv12_switch` | 标量/向量源选择和 VIQ 源顺序 |

核心逻辑：

- 所有最终输出都以 `!x_illegal` 作为有效门控，非法指令不参与普通资源分类。
- 向量类输出根据 opcode 子字段、`x_type_vload`、`x_vsew` 等组合产生。
- `x_vmla_type[2:0]` 编码向量乘加/累加类子类型，供 RF/VIQ 后续生成执行功能。

### 3.4 `ct_idu_ir_rt`

`ct_idu_ir_rt` 是整数寄存器重命名相关性表。源码实例化 32 个 `ct_idu_dep_reg_src2_entry`，覆盖 x1 到 x32 形式的表项，其中 x0 固定读零，不需要普通表项更新。

主要职责：

- 根据 `dp_rt_inst[0:3]_src[0:2]` 查询整数源物理寄存器与 ready 状态。
- 根据 4 路指令目的寄存器和 RTU 分配的 `preg` 信息更新映射。
- 输出每条指令需要释放的旧物理寄存器 `rt_dp_inst*_rel_preg`。
- 检测同拍内更年轻指令源寄存器是否命中更年长指令目的寄存器，例如 `inst01/02/03_src2_match`，用于同拍重命名 bypass。

表项实例接口模式：

| 信号类型 | 说明 |
| --- | --- |
| create/update | 当某条指令写对应逻辑寄存器时，写入新分配物理寄存器 |
| read source | 对 src0/src1/src2 输出当前映射物理寄存器和 ready |
| retire/release | 与 RTU 释放/提交路径配合维护可回收旧映射 |
| flush/srt | 在前端 flush 或特殊重命名恢复时更新表状态 |

设计注意点：

- x0 不分配新物理寄存器，读值固定为零/ready。
- 同拍 4 指令 rename 需要按程序顺序处理 WAW/RAW，年轻指令读取年长指令当拍新目的映射。
- 该模块仅维护映射与 ready/相关性，不保存 64 位寄存器数据，真实数据在 RF 阶段 PRF 中读取。

### 3.5 `ct_idu_ir_frt`

`ct_idu_ir_frt` 是浮点/扩展寄存器重命名相关性表。源码实例化 33 个 `ct_idu_dep_vreg_srcv2_entry`，表项命名为 `freg_0` 到 `freg_32`，支持源 `srcf0/srcf1/srcf2` 及扩展寄存器释放信息。

主要职责：

- 查询浮点源寄存器物理映射，输出 `frt_dp_inst*_srcf*_data`。
- 输出释放的旧浮点/扩展物理寄存器：`frt_dp_inst*_rel_freg`、`frt_dp_inst*_rel_ereg`。
- 维护多指令同拍 rename 相关性：`frt_dp_inst01_srcf2_match` 等。
- 接收 RTU 的 `alloc_freg/alloc_ereg`、flush 和特殊恢复控制。

与 `ir_rt` 的差异：

- 浮点路径额外关联扩展寄存器 `ereg`，用于浮点/向量执行中的附加状态或累加类寄存器资源。
- 源数据位宽包含物理号和 ready/valid 编码，`srcf2` 使用更宽编码以表达第三源相关性。
- 表项使用 `ct_idu_dep_vreg_srcv2_entry`，说明该实现复用了向量/浮点多源依赖表项模板。

### 3.6 `ct_idu_ir_vrt`

`ct_idu_ir_vrt` 是向量重命名表接口模块，但当前 RTL 版本基本为默认返回/占位实现。源码将所有 match 输出置零，释放寄存器置零，源向量数据返回固定编码，例如 `9'b100000011`、`10'b1000000111`。

主要输出行为：

| 输出 | 当前行为 | 含义 |
| --- | --- | --- |
| `vrt_dp_inst**_srcv2_match` | 固定 `1'b0` | 不做同拍 srcv2 命中旁路 |
| `vrt_dp_inst*_rel_vreg[6:0]` | 固定 `7'b0` | 不输出待释放旧向量物理寄存器 |
| `vrt_dp_inst*_srcv[0:2]_data` | 固定 ready/物理号编码 | 向量源映射未启用真实表项 |
| `vrt_dp_inst*_srcvm_data` | 固定 ready/物理号编码 | mask 源同样默认 |

设计含义：

- 当前工程的向量物理寄存器重命名可能尚未在 IR VRT 内完全实现，或在该配置下使用固定映射/其他路径管理。
- `ir_dp` 已预留完整 VRT 接口，因此后续若启用真实向量重命名，可在 `ct_idu_ir_vrt` 内替换为类似 `ir_rt/frt` 的表项实例结构。
- 验证时需要重点确认向量写目的分配、释放和 ready 状态是否由其他模块承担，避免误以为 VRT 已维护完整物理映射。

## 4. 关键流程

### 4.1 正常下传

1. ID 阶段给出 `ctrl_id_pipedown_inst[0:3]_vld` 和 `dp_id_pipedown_inst[0:3]_data`。
2. `ir_ctrl` 在无 flush、无资源停顿、后级允许时打开 `ir_inst_clk_en`。
3. `ir_dp` 锁存 4 路数据，4 个 `ir_decd` 并行产生类型标志。
4. `ir_dp` 向 `ir_rt/frt/vrt` 发起逻辑源寄存器查询。
5. `ir_ctrl` 根据解码属性和资源状态产生 ROB/PST/issue queue/物理寄存器分配有效。
6. `ir_dp` 将原始信息、解码属性和重命名结果拼入 pipe down 数据包。

### 4.2 停顿与清空

- 后级分派类型冲突使用 `ctrl_is_dis_type_stall` 反馈到 `ctrl_ir_pipedown_stall`。
- IS 全局停顿、RTU flush stall、资源不足会保持 IR 有效位和数据包。
- `rtu_idu_flush_fe/is` 清除错误路径指令，且优先级高于普通 pipe down。

### 4.3 同拍重命名相关性

IR 每拍最多处理 4 条指令，必须保证程序顺序语义：

- inst1 读到 inst0 当拍写同一逻辑寄存器时，应使用 inst0 新分配物理寄存器。
- inst2/inst3 需要依次考虑更年长指令的目的寄存器。
- RT/FRT 通过 `instXY_src*_match` 一类信号把这种同拍 RAW 传回 `ir_dp`。

## 5. 设计风险与验证建议

| 风险点 | 建议验证 |
| --- | --- |
| flush 与资源分配同拍 | 构造 flush_fe/flush_is 与 4 路目的寄存器分配同拍场景，检查 RTU alloc 不误触发 |
| x0 目的寄存器 | 写 x0 指令不应申请 preg，不应改变 RT 映射 |
| 4 路 WAW/RAW | 连续 4 条写同一逻辑寄存器、年轻指令读取年长指令目的寄存器 |
| 向量 VRT 默认实现 | RVV 场景检查向量物理寄存器分配/释放真实来源 |
| issue queue 预分派 | 队列 nearly full、双 create、混合 AIQ/BIQ/LSIQ/VIQ 指令 |

## 6. 源码清单

| 文件 | 说明 |
| --- | --- |
| `ct_idu_ir_ctrl.v` | IR 控制、有效位、停顿、预分派、分配有效和 HPCP 输出 |
| `ct_idu_ir_dp.v` | IR 数据寄存、字段拆包、4 路轻量解码、重命名结果组合 |
| `ct_idu_ir_decd.v` | 单指令类型解码 |
| `ct_idu_ir_rt.v` | 整数重命名/依赖表 |
| `ct_idu_ir_frt.v` | 浮点/扩展重命名/依赖表 |
| `ct_idu_ir_vrt.v` | 向量重命名接口默认实现 |

