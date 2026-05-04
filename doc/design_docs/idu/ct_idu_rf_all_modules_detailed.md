# ct_idu_rf 全模块详细方案

## 1. 范围与定位

本文档依据 `C910_RTL_FACTORY/gen_rtl/idu/rtl` 下 `ct_idu_rf_*.v` 源码补充 RF 阶段所有模块的详细方案。RF 阶段位于 issue queue 之后、执行单元之前，负责从各 issue queue 接收已发射指令，读取物理寄存器文件，执行前递选择，生成各执行 pipe 的操作数、功能码、发射选择和 latch ready 回写控制。

覆盖模块：

| 类别 | 模块 |
| --- | --- |
| RF 顶层控制/数据 | `ct_idu_rf_ctrl`、`ct_idu_rf_dp` |
| 前递网络 | `ct_idu_rf_fwd`、`ct_idu_rf_fwd_preg`、`ct_idu_rf_fwd_vreg` |
| pipe 解码 | `ct_idu_rf_pipe0_decd`、`ct_idu_rf_pipe1_decd`、`ct_idu_rf_pipe2_decd`、`ct_idu_rf_pipe3_decd`、`ct_idu_rf_pipe4_decd`、`ct_idu_rf_pipe6_decd`、`ct_idu_rf_pipe7_decd` |
| 物理寄存器文件 | `ct_idu_rf_prf_pregfile`、`ct_idu_rf_prf_fregfile`、`ct_idu_rf_prf_eregfile`、`ct_idu_rf_prf_vregfile` |
| 寄存器单元 | `ct_idu_rf_prf_gated_preg`、`ct_idu_rf_prf_gated_vreg`、`ct_idu_rf_prf_gated_ereg` |

## 2. 阶段结构

```text
AIQ0/AIQ1/BIQ/LSIQ/SDIQ/VIQ0/VIQ1 issue
        |
        v
+----------------+       +----------------+
| rf_ctrl        |<----->| rf_dp          |
| issue/stall    |       | issue payload  |
| latch/fwd ctl  |       | pipe decode    |
+----------------+       +----------------+
                               |
                               +--> pipe0/1/2/3/4/6/7 decd
                               +--> PRF/FPRF/ERF/VRF read
                               +--> rf_fwd
                                      |
                                      +--> fwd_preg / fwd_vreg
                               |
                               v
                 IU / LSU / VFPU select, operand and issue
```

pipe 分工：

| Pipe | 主要来源 | 执行目标 | 说明 |
| --- | --- | --- | --- |
| pipe0 | AIQ0 | IU ALU/DIV/SPECIAL/CP0 | 主整数执行通路，支持短 ALU、DIV、特殊指令 |
| pipe1 | AIQ1 | IU ALU/MULT | 第二整数通路，包含乘法相关控制 |
| pipe2 | BIQ | BJU | 分支/跳转类指令 |
| pipe3 | LSIQ | LSU pipe3 | load/store 地址或访存相关通路 |
| pipe4 | LSIQ | LSU pipe4 | store data/fence/barrier/特殊 LSU 控制 |
| pipe5 | SDIQ | LSU store data | RF 数据通路中存在 pipe5 数据和前递路径，但没有独立 `pipe5_decd` 文件 |
| pipe6 | VIQ0 | VFPU/VFALU/VFMAU/VFDSU | 主向量/浮点向量通路 |
| pipe7 | VIQ1 | VFPU/VFALU/VFMAU/VFDSU | 第二向量/浮点向量通路 |

## 3. 顶层控制与数据通路

### 3.1 `ct_idu_rf_ctrl`

`ct_idu_rf_ctrl` 源码端口规模为 73 个输入、111 个输出，是 RF 阶段发射控制、latch ready、前递有效和执行单元选择的控制中心。

输入分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| issue 有效 | `aiq0/aiq1/biq/lsiq/sdiq/viq0/viq1_xx_issue_en` | 各 issue queue 已选择指令 |
| issue 门控 | `*_xx_gateclk_issue_en` | 为各 pipe RF 寄存器生成局部门控 |
| RF 数据属性 | `dp_ctrl_rf_pipe*_src_no_rdy`、`dp_ctrl_rf_pipe*_eu_sel`、`dp_ctrl_is_*_issue_lch_rdy` | 从 `rf_dp` 返回的源 ready、latch ready、指令属性 |
| 执行单元停顿 | `iu_idu_div_wb_stall`、`iu_idu_ex1_pipe1_mult_stall`、`vfpu_idu_vdiv_wb_stall` | 多周期执行单元反压 |
| flush | `rtu_idu_flush_fe`、`rtu_idu_flush_is`、`rtu_yy_xx_flush` | 清除错误路径发射 |

输出分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| issue queue pop | `ctrl_*_rf_pop_vld`、`ctrl_*_rf_pop_dlb_vld` | 指令成功进入 RF 后通知队列弹出 |
| latch fail | `ctrl_*_rf_lch_fail_vld`、`ctrl_dp_rf_pipe*_other_lch_fail` | 源未 ready 或执行单元停顿导致 latch 失败 |
| 前递/唤醒 | `ctrl_*_rf_pipe*_reg_fwd_vld`、`ctrl_*_rf_pipe*_vreg_fwd_vld` | 反馈给 issue queue 的前递命中/ready 设置 |
| 执行单元选择 | `idu_iu_rf_*_sel`、`idu_lsu_rf_pipe*_sel`、`idu_vfpu_rf_pipe*_sel`、`idu_cp0_rf_sel` | 驱动 IU/LSU/VFPU/CP0 接收 RF 输出 |
| 性能计数 | `idu_hpcp_rf_pipe*_inst_vld`、`*_lch_fail_vld` | RF 发射/失败事件 |

核心逻辑：

- 由各 queue issue/gateclk 信号生成 pipe0/1/2/3/4/5/6/7 本地 RF 有效寄存器。
- 对每个 pipe 判断 `src_no_rdy`、执行单元 stall 和特殊 hazard，生成 latch fail。
- 对成功发射的 queue 输出 pop，失败则保持队列项并输出 fail/vld。
- 对 pipe0/pipe1 的整数前递 ready 生成多份 duplicate 输出，降低扇出压力。
- 对 pipe6/pipe7 的 VMLA/vector 前递 ready 也做 duplicate 输出，供 VIQ 和相关 latch ready 网络使用。

### 3.2 `ct_idu_rf_dp`

`ct_idu_rf_dp` 是 RF 阶段最大的数据通路模块，源码端口规模为 152 个输入、307 个输出，并实例化所有 pipe 解码器。它从 issue queue read data 中拆出 opcode、物理源/目的寄存器、ready bitmap 和控制字段，读取 PRF/FPRF/VRF/ERF，接收前递模块输出，最终组装送往 IU/LSU/VFPU/CP0 的源操作数和控制信息。

输入分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| issue payload | `aiq0_dp_issue_read_data[226:0]`、`aiq1_dp_issue_read_data[213:0]`、`biq_dp_issue_read_data[81:0]`、`lsiq_dp_pipe*_issue_read_data[162:0]`、`sdiq_dp_issue_read_data[26:0]`、`viq*_dp_issue_read_data` | 各队列发射项 |
| issue entry | `*_dp_issue_entry` | latch fail 或 ready clear 回写的队列项选择 |
| PRF 读数据 | `prf_dp_rf_pipe*_src*_data`、`prf_xx_rf_pipe1_src*_data` | 物理寄存器文件输出 |
| 前递数据 | `fwd_dp_rf_pipe*_src*_data`、`*_no_fwd` | 前递网络选择结果 |
| 控制反馈 | `ctrl_dp_rf_pipe*_other_lch_fail` | 控制侧 latch fail 影响数据通路 ready clear |

输出分组：

| 分组 | 代表信号 | 说明 |
| --- | --- | --- |
| 给 RF 控制 | `dp_ctrl_rf_pipe*_src_no_rdy`、`dp_ctrl_rf_pipe*_eu_sel`、`dp_ctrl_is_*_issue_*` | 控制模块判断是否 pop/issue |
| 给 issue queue | `dp_*_rf_lch_entry`、`dp_*_rf_rdy_clr` | latch 失败时清 ready 或定位 entry |
| 给 PRF | `dp_prf_rf_pipe*_src*_reg`、`*_vld` | 读寄存器号和读有效 |
| 给前递 | `dp_fwd_rf_pipe*_src*_reg`、`*_vld` | 前递比较所需源物理寄存器 |
| 给执行单元 | `idu_iu_rf_*`、`idu_lsu_rf_*`、`idu_vfpu_rf_*`、`idu_cp0_rf_*` | 操作数、立即数、功能码、控制位 |

内部要点：

- 对 AIQ0/AIQ1/VIQ0/VIQ1 等 issue data 使用宏位段拆包，例如 `AIQ0_DST_VLD`、`AIQ0_LCH_RDY_*`。
- 每个 pipe 的 opcode 进入对应 `ct_idu_rf_pipe*_decd`，生成执行单元选择、功能码、立即数和源选择控制。
- 源操作数优先使用前递数据；若 `fwd_*_no_fwd` 为真，则选择 PRF 读出的寄存器数据。
- pipe3/4/5 是 LSU 相关路径，其中 pipe4 还承载 fence/fencei/tlb/barrier 广播控制。
- pipe6/7 对向量源包含 `srcv0/srcv1/srcv2/srcvm`，每个源又可能来自浮点寄存器片、向量寄存器 VR0/VR1 片或前递网络。

## 4. 前递网络

### 4.1 `ct_idu_rf_fwd`

`ct_idu_rf_fwd` 是 RF 阶段前递网络集成模块，源码端口规模为 86 个输入、63 个输出。它实例化多个 `ct_idu_rf_fwd_preg` 和 `ct_idu_rf_fwd_vreg`，分别覆盖标量物理寄存器源和向量/浮点向量源。

实例覆盖：

| 类型 | 覆盖源 |
| --- | --- |
| `fwd_preg` | pipe0 src0/src1，pipe1 src0/src1，pipe2 src0/src1，pipe3 src0/src1，pipe4 src0/src1，pipe5 src0 |
| `fwd_vreg` | pipe3/4 srcvm，pipe5 srcv0，pipe6 srcv0/srcv1/srcv2/srcvm，pipe7 srcv0/srcv1/srcv2/srcvm |

设计要点：

- 集成模块不直接比较所有源，而是按每个 RF 源实例化专门比较单元。
- 对 pipe5/pipe6/pipe7 的部分源存在“排除 MLA/VMLA”的 no-fwd 信号，用于特殊乘加类指令的源可用性判断。
- 输出既包括前递数据，也包括 `*_no_fwd`，供 `rf_dp` 在前递数据和 PRF 数据之间选择。

### 4.2 `ct_idu_rf_fwd_preg`

标量物理寄存器前递选择单元，输入 19 个、输出 2 个。输入包括当前源物理寄存器号、读有效，以及来自 IU/LSU 写回/前递级的物理寄存器号、数据和有效位。

前递源优先级按源码 `fwd_src_sel[5:0]` 排列：

| 选择位 | 来源 | 说明 |
| --- | --- | --- |
| 0 | `iu_idu_ex1_pipe0_fwd_preg_*` | IU pipe0 EX1 最近结果 |
| 1 | `iu_idu_ex2_pipe0_wb_preg_*` | IU pipe0 EX2/WB 结果 |
| 2 | `iu_idu_ex1_pipe1_fwd_preg_*` | IU pipe1 EX1 最近结果 |
| 3 | `iu_idu_ex2_pipe1_wb_preg_*` | IU pipe1 EX2/WB 结果 |
| 4 | `lsu_idu_da_pipe3_fwd_preg_*` | LSU DA 前递结果 |
| 5 | `lsu_idu_wb_pipe3_wb_preg_*` | LSU WB 写回结果 |

`x_src_no_fwd = !(|fwd_src_sel[5:0])`，表示没有任何前递源命中，`rf_dp` 应使用 PRF 读数据。

### 4.3 `ct_idu_rf_fwd_vreg`

向量/浮点向量寄存器前递选择单元，输入 25 个、输出 2 个。比较当前源向量物理寄存器与 VFPU/LSU 的向量前递/写回目的寄存器。

前递源：

| 选择位 | 来源 |
| --- | --- |
| 0 | `vfpu_idu_ex3_pipe6_fwd_vreg_*` |
| 1 | `vfpu_idu_ex4_pipe6_fwd_vreg_*` |
| 2 | `vfpu_idu_ex5_pipe6_fwd_vreg_*` |
| 3 | `vfpu_idu_ex3_pipe7_fwd_vreg_*` |
| 4 | `vfpu_idu_ex4_pipe7_fwd_vreg_*` |
| 5 | `vfpu_idu_ex5_pipe7_fwd_vreg_*` |
| 6 | `lsu_idu_da_pipe3_fwd_vreg_*` |
| 7 | `lsu_idu_wb_pipe3_fwd_vreg_*` |

该模块输出 `x_srcv_data` 和 `x_srcv_no_fwd`，为 pipe3/4/5/6/7 的向量源提供统一前递选择。

## 5. Pipe 解码模块

### 5.1 `ct_idu_rf_pipe0_decd`

pipe0 解码器输入 `pipe0_decd_expt_vld` 和 `pipe0_decd_opcode[31:0]`，输出 `eu_sel[3:0]`、`func[4:0]`、`imm[5:0]`、`sel[20:0]` 和 64 位 `src1_imm`。

设计功能：

- 支持 32 位普通整数指令和 16 位压缩指令的立即数展开。
- 生成 ALU/DIV/SPECIAL/CP0 执行单元选择。
- 对 LUI/ADDI/压缩 ADDI4SPN/CADDI 等立即数格式生成统一 64 位操作数。
- 在异常有效 `pipe0_decd_expt_vld` 时屏蔽普通执行选择，避免异常指令错误进入功能单元。

### 5.2 `ct_idu_rf_pipe1_decd`

pipe1 解码器输入 opcode，输出 `eu_sel[1:0]`、`func[4:0]`、`imm[5:0]`、`mult_func[7:0]`、`sel[20:0]` 和 64 位 `src1_imm`。

相对 pipe0 的特点：

- 同样支持 16/32 位整数立即数展开。
- 增加 `mult_func[7:0]`，用于乘法/MAC 类操作控制。
- 主要服务 AIQ1 第二整数执行通路，功能覆盖 ALU 与 MULT。

### 5.3 `ct_idu_rf_pipe2_decd`

pipe2 解码器服务 BIQ/BJU。输入 opcode，输出 `func[7:0]`、`offset[20:0]` 和固定为 0 的 `src1_imm[63:0]`。

功能：

- 根据 opcode/压缩指令格式识别分支、跳转和返回类控制转移。
- 生成 BJU 所需的 branch/jump 功能码。
- 展开不同格式的 PC 相对偏移，包括 B/J/压缩跳转等立即数字段。

### 5.4 `ct_idu_rf_pipe3_decd`

pipe3 解码器服务 LSU pipe3。输入 opcode，输出 LSU 地址/访存控制相关字段，包括 `offset`、`offset_plus`、`expt_vec`、`split`、`srcv0_vld` 等 11 类输出。

功能：

- 解析 load/store 地址偏移。
- 生成向量访存异常/拆分/元素访问相关信息。
- 对 `offset_plus` 做符号扩展，为 LSU 地址生成提供快速输入。

### 5.5 `ct_idu_rf_pipe4_decd`

pipe4 解码器服务 LSU pipe4 及 fence/barrier 类控制。输入包括 opcode、异常向量、fence 广播禁用配置等，输出 18 类控制信号。

功能：

- 解析 store data、fence、fencei、fencerw、TLB broadcast 等特殊 LSU 指令。
- 根据 `cp0_lsu_fencei_broad_dis`、`cp0_lsu_fencerw_broad_dis`、`cp0_lsu_tlb_broad_dis` 屏蔽对应广播。
- 判断 `rs1/rs2` 是否为 0，用于 fence 类语义约束。
- 生成 LSU 所需 offset、分裂、异常向量和同步控制。

### 5.6 `ct_idu_rf_pipe6_decd`

pipe6 解码器服务 VIQ0/VFPU 主向量通路。输入 opcode 和 `pipe6_decd_vsew[2:0]`，输出 `eu_sel`、`func`、`imm0`、`inst_type`、`oper_size`、`ready_stage`、`vmla_type`。

功能：

- 解析浮点/向量 opcode，选择 VFPU/VFALU/VFMAU/VFDSU 等执行单元。
- 根据 `vsew` 和 opcode 字段生成元素宽度、操作宽度和 ready stage。
- 生成 VMLA 类型编码，供向量乘加路径使用。
- 当前源码中 `decd_vec_inst` 为固定默认路径，需结合工程宏配置确认真实向量 decode 是否由其他生成配置打开。

### 5.7 `ct_idu_rf_pipe7_decd`

pipe7 解码器与 pipe6 结构基本一致，服务 VIQ1 第二向量通路。接口和输出语义与 pipe6 对齐，便于两个 VIQ 共享后端执行单元选择和功能码定义。

验证时建议将 pipe6/pipe7 做等价类覆盖：同一向量 opcode 在两个 pipe 上应生成一致的 `eu_sel/func/oper_size/ready_stage`，除非 issue queue 属性明确要求差异。

## 6. 物理寄存器文件

### 6.1 `ct_idu_rf_prf_pregfile`

整数物理寄存器文件。源码实例化 `ct_idu_rf_prf_gated_preg` 表项，覆盖 preg1 到 preg95，并将 preg0 固定为 0。

接口规模为 25 输入、13 输出。主要写回源：

| 写回源 | 说明 |
| --- | --- |
| `iu_idu_ex2_pipe0_wb_preg_*` | IU pipe0 写回 |
| `iu_idu_ex2_pipe1_wb_preg_*` | IU pipe1 写回 |
| `lsu_idu_wb_pipe3_wb_preg_*` | LSU load 写回 |

读端覆盖 pipe0/1/2/3/4/5 等标量源。每个物理寄存器表项根据三个写回源生成 `x_wb_vld[2:0]`，再由 gated preg 单元内部选择写入数据。

### 6.2 `ct_idu_rf_prf_fregfile`

浮点/向量低位片寄存器文件。源码实例化 64 个 `ct_idu_rf_prf_gated_vreg` 表项，写回源包括 VFPU pipe6、VFPU pipe7 和 LSU pipe3。

主要用途：

- 为 pipe5/6/7 的浮点/向量源提供 64 位片段数据。
- 支持 VFPU ex5 和 LSU WB 的多源写回仲裁。
- 输出多个 `prf_dp_rf_pipe*_srcv*_vreg_*_data`，供 RF 数据通路和前递选择使用。

### 6.3 `ct_idu_rf_prf_eregfile`

扩展寄存器文件。源码实例化 32 个 `ct_idu_rf_prf_gated_ereg`，输入 13 个、输出 2 个。写回源主要来自 VFPU pipe6/pipe7 的 ex5 扩展寄存器写回。

用途：

- 保存向量/浮点执行附加状态或累加类扩展字段。
- `gated_ereg` 内部有 retired/released 写回门控，输出 `x_acc_reg_dout[5:0]` 时受 `x_retired_released_wb` 控制。

### 6.4 `ct_idu_rf_prf_vregfile`

当前 `ct_idu_rf_prf_vregfile` 在此源码配置中为默认占位实现，输入 18 个、输出 9 个，所有读数据固定为 `64'b0`。

设计含义：

- 完整向量寄存器文件可能由 `fregfile` 的 64 位片或其他配置模块承担。
- 若目标配置需要真实宽向量 VRF，需要替换该占位模块或检查宏生成路径。
- 验证 RVV 指令时不要只依据该模块判断向量数据通路是否完整。

### 6.5 gated register 单元

| 模块 | 数据宽度/用途 | 写源数 | 关键行为 |
| --- | --- | --- | --- |
| `ct_idu_rf_prf_gated_preg` | 64 位整数物理寄存器 | 3 | `write_en = |x_wb_vld[2:0]`，写使能打开本地门控时钟 |
| `ct_idu_rf_prf_gated_vreg` | `VEC_MSB:0` 向量/浮点片 | 3 | 多源写回选择后输出寄存器数据 |
| `ct_idu_rf_prf_gated_ereg` | 6 位扩展寄存器 | 2 | 输出受 retired/released 写回状态门控 |

这些单元共同采用局部门控时钟模式：只有表项被写入时打开对应寄存器时钟，降低大寄存器文件动态功耗。

## 7. 关键流程

### 7.1 发射成功

1. issue queue 输出 `*_issue_en`、`*_issue_read_data` 和 entry。
2. `rf_dp` 拆包并送对应 pipe 解码器。
3. `rf_dp` 同时向 PRF 和前递网络提供源物理寄存器号。
4. `rf_fwd` 若命中更近执行结果，则返回前递数据；否则 `rf_dp` 使用 PRF 读数据。
5. `rf_ctrl` 检查源 ready、执行单元 stall 和特殊 hazard。
6. 成功时输出 queue pop、执行单元 select/gateclk、HPCP inst valid。

### 7.2 latch fail

发生条件包括源未 ready、对应执行单元写回/多周期 stall、特殊 LSU/VFPU hazard 等。

处理方式：

- `rf_ctrl` 输出 `ctrl_*_rf_lch_fail_vld`。
- `rf_dp` 根据 entry 输出 `dp_*_rf_lch_entry` 和 ready clear。
- issue queue 保留该项，等待后续前递 ready 或写回 ready 重新发射。

### 7.3 前递选择

标量源优先从 IU EX1/EX2 和 LSU DA/WB 匹配；向量源优先从 VFPU EX3/EX4/EX5 和 LSU DA/WB 匹配。若没有任何 match，`*_no_fwd` 为 1，RF 数据通路回退到寄存器文件读值。

## 8. 设计风险与验证建议

| 风险点 | 建议验证 |
| --- | --- |
| queue pop 与 latch fail 同拍 | 对每个 queue 构造源未 ready/执行单元 stall，检查 pop 不误发 |
| 前递优先级 | 同一物理寄存器被多个前递源命中时，检查选择最近结果 |
| preg0 固定零 | 写 preg0 不应改变读值 |
| pipe6/pipe7 对称性 | 相同向量 opcode 在 VIQ0/VIQ1 输出功能码一致 |
| PRF 多写源冲突 | 同一物理寄存器多写源同拍时确认架构禁止或优先级正确 |
| `prf_vregfile` 占位 | RVV 数据路径需确认真实 VRF 来源 |
| flush 与 issue 同拍 | `rtu_yy_xx_flush` 同拍 issue 时，不应向执行单元送错路径有效 |

## 9. 源码清单

| 文件 | 说明 |
| --- | --- |
| `ct_idu_rf_ctrl.v` | RF 控制、pop、latch fail、前递 ready、执行单元 select |
| `ct_idu_rf_dp.v` | RF 数据通路、issue payload 拆包、PRF/FWD 选择、执行输出 |
| `ct_idu_rf_fwd.v` | 前递网络集成 |
| `ct_idu_rf_fwd_preg.v` | 标量物理寄存器前递比较/选择 |
| `ct_idu_rf_fwd_vreg.v` | 向量物理寄存器前递比较/选择 |
| `ct_idu_rf_pipe0_decd.v` | AIQ0/IU pipe0 解码 |
| `ct_idu_rf_pipe1_decd.v` | AIQ1/IU pipe1 解码 |
| `ct_idu_rf_pipe2_decd.v` | BIQ/BJU pipe2 解码 |
| `ct_idu_rf_pipe3_decd.v` | LSU pipe3 解码 |
| `ct_idu_rf_pipe4_decd.v` | LSU pipe4/fence 解码 |
| `ct_idu_rf_pipe6_decd.v` | VIQ0/VFPU pipe6 解码 |
| `ct_idu_rf_pipe7_decd.v` | VIQ1/VFPU pipe7 解码 |
| `ct_idu_rf_prf_pregfile.v` | 整数物理寄存器文件 |
| `ct_idu_rf_prf_fregfile.v` | 浮点/向量片寄存器文件 |
| `ct_idu_rf_prf_eregfile.v` | 扩展寄存器文件 |
| `ct_idu_rf_prf_vregfile.v` | 当前配置下的向量寄存器文件占位 |
| `ct_idu_rf_prf_gated_preg.v` | 整数物理寄存器表项 |
| `ct_idu_rf_prf_gated_vreg.v` | 向量/浮点片寄存器表项 |
| `ct_idu_rf_prf_gated_ereg.v` | 扩展寄存器表项 |

