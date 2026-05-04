# ct_idu_rf 模块接口列表

## 1. 说明

本文档依据 `C910_RTL_FACTORY/gen_rtl/idu/rtl` 下 `ct_idu_rf_*.v` 端口声明整理。RF 阶段模块数量和端口数量较多，其中 `ct_idu_rf_dp`、`ct_idu_rf_ctrl`、`ct_idu_rf_fwd` 存在大量按 pipe、源操作数、重复副本展开的同构接口，因此本文使用范围化写法压缩列表。

- `pipe[0:7]` 表示多个 RF 执行 pipe 的同构信号，具体是否包含某 pipe 以表格说明为准。
- `src[0:2]` 表示源操作数 0、1、2。
- `srcv[0:2]/srcvm` 表示向量源操作数和 mask 源。
- `dup[0:4]` 表示同一寄存器号或 latch valid 的多副本广播。
- `queue` 表示 `aiq0/aiq1/biq/lsiq/sdiq/viq0/viq1` 中对应 issue queue。
- 对端模块按信号前缀、顶层实例连接和 IDU 阶段关系推断；跨 IDU 顶层的接口标记为 `ct_idu_top/外部执行单元`。

表格字段：

| 字段 | 含义 |
| --- | --- |
| IO 类型 | `input` 或 `output` |
| 信号/信号组 | RTL 端口名或范围化端口名 |
| 位宽 | 单个端口位宽 |
| 对端模块 | 输入来源或输出去向 |
| 信号功能 | 接口语义说明 |

覆盖模块：

| 类别 | 模块 |
| --- | --- |
| RF 顶层控制/数据 | `ct_idu_rf_ctrl`、`ct_idu_rf_dp` |
| 前递网络 | `ct_idu_rf_fwd`、`ct_idu_rf_fwd_preg`、`ct_idu_rf_fwd_vreg` |
| pipe 解码 | `ct_idu_rf_pipe0_decd`、`ct_idu_rf_pipe1_decd`、`ct_idu_rf_pipe2_decd`、`ct_idu_rf_pipe3_decd`、`ct_idu_rf_pipe4_decd`、`ct_idu_rf_pipe6_decd`、`ct_idu_rf_pipe7_decd` |
| 物理寄存器文件 | `ct_idu_rf_prf_pregfile`、`ct_idu_rf_prf_fregfile`、`ct_idu_rf_prf_eregfile`、`ct_idu_rf_prf_vregfile` |
| gated 寄存器单元 | `ct_idu_rf_prf_gated_preg`、`ct_idu_rf_prf_gated_vreg`、`ct_idu_rf_prf_gated_ereg` |

## 2. `ct_idu_rf_ctrl`

RF 控制模块负责 issue queue pop、RF latch fail、执行单元选择、前递 ready/latch valid 反馈和 HPCP 事件输出。

### 2.1 时钟、复位与全局控制

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | RF 控制寄存器主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | IDU 内部时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式下打开门控 |
| input | `rtu_idu_flush_fe` | 1 | RTU | 前端 flush，清除 RF 有效 |
| input | `rtu_idu_flush_is` | 1 | RTU | issue 阶段 flush，阻止/清除当前发射 |
| input | `rtu_yy_xx_flush` | 1 | RTU | 全局 flush |
| input | `hpcp_idu_cnt_en` | 1 | HPCP | 性能计数使能 |

### 2.2 Issue Queue 发射输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `aiq[0:1]_xx_issue_en` | 1 | `ct_idu_is_aiq0/1` | 整数 issue queue 发射有效 |
| input | `aiq[0:1]_xx_gateclk_issue_en` | 1 | `ct_idu_is_aiq0/1` | 整数 issue queue 发射门控有效 |
| input | `biq_xx_issue_en` | 1 | `ct_idu_is_biq` | 分支 issue queue 发射有效 |
| input | `biq_xx_gateclk_issue_en` | 1 | `ct_idu_is_biq` | 分支 issue queue 发射门控有效 |
| input | `lsiq_xx_pipe3_issue_en` | 1 | `ct_idu_is_lsiq` | LSU pipe3 发射有效 |
| input | `lsiq_xx_pipe4_issue_en` | 1 | `ct_idu_is_lsiq` | LSU pipe4 发射有效 |
| input | `lsiq_xx_gateclk_issue_en` | 1 | `ct_idu_is_lsiq` | LSU issue queue 发射门控有效 |
| input | `sdiq_xx_issue_en` | 1 | `ct_idu_is_sdiq` | store data queue 发射有效 |
| input | `sdiq_xx_gateclk_issue_en` | 1 | `ct_idu_is_sdiq` | store data queue 发射门控有效 |
| input | `viq[0:1]_xx_issue_en` | 1 | `ct_idu_is_viq0/1` | 向量 issue queue 发射有效 |
| input | `viq[0:1]_xx_gateclk_issue_en` | 1 | `ct_idu_is_viq0/1` | 向量 issue queue 发射门控有效 |

### 2.3 RF 数据通路属性输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_ctrl_is_aiq0_issue_alu_short` | 1 | `ct_idu_rf_dp` | AIQ0 指令为短 ALU，可参与特定 latch/ready 处理 |
| input | `dp_ctrl_is_aiq0_issue_div` | 1 | `ct_idu_rf_dp` | AIQ0 指令为 DIV |
| input | `dp_ctrl_is_aiq0_issue_special` | 1 | `ct_idu_rf_dp` | AIQ0 特殊执行单元指令 |
| input | `dp_ctrl_is_aiq[0:1]_issue_dst_vld` | 1 | `ct_idu_rf_dp` | 整数目的物理寄存器有效 |
| input | `dp_ctrl_is_aiq[0:1]_issue_lch_preg` | 1 | `ct_idu_rf_dp` | 当前 issue 需要 latch 整数物理寄存器 |
| input | `dp_ctrl_is_aiq[0:1]_issue_lch_rdy` | 108 | `ct_idu_rf_dp` | AIQ 源/目的相关 latch ready 向量 |
| input | `dp_ctrl_is_aiq1_issue_mla_vld` | 1 | `ct_idu_rf_dp` | AIQ1 MLA 源 2 有效 |
| input | `dp_ctrl_is_aiq1_issue_mla_lch_rdy` | 8 | `ct_idu_rf_dp` | AIQ1 MLA 相关 latch ready |
| input | `dp_ctrl_is_viq[0:1]_issue_dstv_vld` | 1 | `ct_idu_rf_dp` | VIQ 目的向量寄存器有效 |
| input | `dp_ctrl_is_viq[0:1]_issue_lch_rdy` | 16 | `ct_idu_rf_dp` | VIQ 源/目的相关 latch ready |
| input | `dp_ctrl_is_viq0_issue_vdiv` | 1 | `ct_idu_rf_dp` | VIQ0 指令为向量除法 |
| input | `dp_ctrl_is_viq[0:1]_issue_vmla_rf` | 1 | `ct_idu_rf_dp` | VIQ 指令为 RF 阶段可识别的 VMLA |
| input | `dp_ctrl_is_viq[0:1]_issue_vmla_short` | 1 | `ct_idu_rf_dp` | VIQ VMLA 短路径属性 |

### 2.4 Pipe ready/stall 属性输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_ctrl_rf_pipe0_eu_sel` | 4 | `ct_idu_rf_dp` | pipe0 执行单元选择 |
| input | `dp_ctrl_rf_pipe1_eu_sel` | 2 | `ct_idu_rf_dp` | pipe1 执行单元选择 |
| input | `dp_ctrl_rf_pipe[0:7]_src_no_rdy` | 1 | `ct_idu_rf_dp` | 对应 pipe 存在源操作数未 ready |
| input | `dp_ctrl_rf_pipe[0:1]_mtvr` | 1 | `ct_idu_rf_dp` | 整数到向量/浮点寄存器搬移属性 |
| input | `dp_ctrl_rf_pipe[0:1]_src2_vld` | 1 | `ct_idu_rf_dp` | pipe0/1 第三源有效 |
| input | `dp_ctrl_rf_pipe3_src1_vld` | 1 | `ct_idu_rf_dp` | LSU pipe3 源 1 有效 |
| input | `dp_ctrl_rf_pipe[3:4]_srcvm_vld` | 1 | `ct_idu_rf_dp` | LSU 向量 mask 源有效 |
| input | `dp_ctrl_rf_pipe4_staddr` | 1 | `ct_idu_rf_dp` | pipe4 指令为 store address 相关 |
| input | `dp_ctrl_rf_pipe5_src0_vld` | 1 | `ct_idu_rf_dp` | SDIQ pipe5 整数源 0 有效 |
| input | `dp_ctrl_rf_pipe[6:7]_mfvr` | 1 | `ct_idu_rf_dp` | 向量/浮点到整数寄存器搬移属性 |
| input | `dp_ctrl_rf_pipe[6:7]_srcv2_vld` | 1 | `ct_idu_rf_dp` | 向量源 2 有效 |
| input | `dp_ctrl_rf_pipe6_vmul` | 1 | `ct_idu_rf_dp` | pipe6 VMUL/VMLA 类属性 |
| input | `dp_ctrl_rf_pipe7_vmul_unsplit` | 1 | `ct_idu_rf_dp` | pipe7 未拆分 VMUL 类属性 |
| input | `iu_idu_div_wb_stall` | 1 | IU | DIV 写回反压 |
| input | `iu_idu_ex1_pipe1_mult_stall` | 1 | IU | pipe1 乘法单元反压 |
| input | `vfpu_idu_vdiv_wb_stall` | 1 | VFPU | 向量除法写回反压 |

### 2.5 输出到 Issue Queue 与 RF DP

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `ctrl_aiq[0:1]_rf_pop_vld` | 1 | `ct_idu_is_aiq0/1` | AIQ 当前发射指令成功进入 RF，可从队列弹出 |
| output | `ctrl_aiq[0:1]_rf_pop_dlb_vld` | 1 | `ct_idu_is_aiq0/1` | AIQ 双发/特殊场景 pop 有效 |
| output | `ctrl_aiq[0:1]_rf_lch_fail_vld` | 1 | `ct_idu_is_aiq0/1` | AIQ 发射到 RF latch 失败 |
| output | `ctrl_aiq[0:1]_stall` | 1 | `ct_idu_is_aiq0/1` | AIQ 发射停顿 |
| output | `ctrl_biq_rf_pop_vld` | 1 | `ct_idu_is_biq` | BIQ 当前发射指令成功进入 RF |
| output | `ctrl_biq_rf_lch_fail_vld` | 1 | `ct_idu_is_biq` | BIQ latch 失败 |
| output | `ctrl_lsiq_rf_pipe[3:4]_lch_fail_vld` | 1 | `ct_idu_is_lsiq` | LSIQ pipe3/4 latch 失败 |
| output | `ctrl_sdiq_rf_lch_fail_vld` | 1 | `ct_idu_is_sdiq` | SDIQ latch 失败 |
| output | `ctrl_sdiq_rf_staddr_rdy_set` | 1 | `ct_idu_is_sdiq` | store address ready 置位 |
| output | `ctrl_viq[0:1]_rf_pop_vld` | 1 | `ct_idu_is_viq0/1` | VIQ 当前发射指令成功进入 RF |
| output | `ctrl_viq[0:1]_rf_pop_dlb_vld` | 1 | `ct_idu_is_viq0/1` | VIQ 双发/特殊场景 pop 有效 |
| output | `ctrl_viq[0:1]_rf_lch_fail_vld` | 1 | `ct_idu_is_viq0/1` | VIQ latch 失败 |
| output | `ctrl_viq[0:1]_stall` | 1 | `ct_idu_is_viq0/1` | VIQ 发射停顿 |
| output | `ctrl_dp_rf_pipe[0,3,4,5,6,7]_other_lch_fail` | 1 | `ct_idu_rf_dp` | 由执行单元反压或跨 pipe 条件造成的非本源 ready latch 失败 |

### 2.6 前递、执行选择与性能事件输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `ctrl_*_rf_pipe[0:1]_alu_reg_fwd_vld` | 24/12 | issue queue | 整数 ALU 前递 ready 有效，AIQ/BIQ 为 24 位，SDIQ 为 12 位 |
| output | `ctrl_aiq1_rf_pipe1_mla_reg_lch_vld` | 8 | `ct_idu_is_aiq1` | MLA 源寄存器 latch valid |
| output | `ctrl_viq[0:1]_rf_pipe[6:7]_vmla_vreg_fwd_vld` | 8 | `ct_idu_is_viq0/1` | VMLA 向量寄存器前递 ready 有效 |
| output | `ctrl_xx_rf_pipe[0:1]_preg_lch_vld_dup[0:4]` | 1 | IDU 内部广播 | pipe0/1 整数目的寄存器 latch valid 多副本 |
| output | `ctrl_xx_rf_pipe[6:7]_vmla_lch_vld_dup[0:3]` | 1 | IDU 内部广播 | pipe6/7 VMLA latch valid 多副本 |
| output | `idu_iu_rf_pipe[0:1]_sel/gateclk_sel/cbus_gateclk_sel` | 1 | IU | 整数 RF pipe 选择和门控选择 |
| output | `idu_iu_rf_bju_sel/gateclk_sel` | 1 | BJU | 分支 pipe 选择和门控选择 |
| output | `idu_iu_rf_div_sel/gateclk_sel` | 1 | IU DIV | 除法单元选择和门控选择 |
| output | `idu_iu_rf_mult_sel/gateclk_sel` | 1 | IU MULT | 乘法单元选择和门控选择 |
| output | `idu_iu_rf_special_sel/gateclk_sel` | 1 | IU special | 特殊执行单元选择和门控选择 |
| output | `idu_lsu_rf_pipe[3:5]_sel/gateclk_sel` | 1 | LSU | LSU pipe3/4/5 选择和门控选择 |
| output | `idu_vfpu_rf_pipe[6:7]_sel/gateclk_sel` | 1 | VFPU | VFPU pipe6/7 选择和门控选择 |
| output | `idu_cp0_rf_sel/gateclk_sel` | 1 | CP0 | CP0 RF 选择和门控选择 |
| output | `idu_iu_is_div_issue/gateclk_issue` | 1 | IU | DIV issue 事件直连 |
| output | `idu_vfpu_is_vdiv_issue/gateclk_issue` | 1 | VFPU | VDIV issue 事件直连 |
| output | `idu_hpcp_rf_inst_vld` | 1 | HPCP | RF 阶段任意指令有效 |
| output | `idu_hpcp_rf_pipe[0:7]_inst_vld` | 1 | HPCP | 各 pipe 指令有效事件 |
| output | `idu_hpcp_rf_pipe[0:7]_lch_fail_vld` | 1 | HPCP | 各 pipe latch fail 事件 |
| output | `idu_hpcp_rf_pipe[3:5]_reg_lch_fail_vld` | 1 | HPCP | LSU/SDIQ 寄存器 latch fail 事件 |

## 3. `ct_idu_rf_dp`

RF 数据通路模块负责接收 issue queue payload，抽取 opcode/寄存器号/控制位，读 PRF/VRF/FRF，选择前递数据，生成送往 IU/LSU/VFPU/CP0 的操作数和控制字段。

### 3.1 时钟、复位与控制输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | RF DP 主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | IDU ICG 使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `cp0_lsu_fencei_broad_dis` | 1 | CP0 | 禁止 fence.i broadcast |
| input | `cp0_lsu_fencerw_broad_dis` | 1 | CP0 | 禁止 fence rw broadcast |
| input | `cp0_lsu_tlb_broad_dis` | 1 | CP0 | 禁止 TLB broadcast |
| input | `ctrl_dp_rf_pipe[0,3,4,5,6,7]_other_lch_fail` | 1 | `ct_idu_rf_ctrl` | 控制模块返回的跨条件 latch fail |

### 3.2 Issue Queue Payload 输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `aiq0_dp_issue_entry` | 8 | `ct_idu_is_aiq0` | AIQ0 发射 entry one-hot |
| input | `aiq0_dp_issue_read_data` | 227 | `ct_idu_is_aiq0` | AIQ0 发射指令 payload |
| input | `aiq0_xx_issue_en/gateclk_issue_en` | 1 | `ct_idu_is_aiq0` | AIQ0 发射有效/门控有效 |
| input | `aiq1_dp_issue_entry` | 8 | `ct_idu_is_aiq1` | AIQ1 发射 entry one-hot |
| input | `aiq1_dp_issue_read_data` | 214 | `ct_idu_is_aiq1` | AIQ1 发射指令 payload |
| input | `aiq1_xx_issue_en/gateclk_issue_en` | 1 | `ct_idu_is_aiq1` | AIQ1 发射有效/门控有效 |
| input | `biq_dp_issue_entry` | 12 | `ct_idu_is_biq` | BIQ 发射 entry one-hot |
| input | `biq_dp_issue_read_data` | 82 | `ct_idu_is_biq` | BIQ 发射指令 payload |
| input | `biq_xx_issue_en/gateclk_issue_en` | 1 | `ct_idu_is_biq` | BIQ 发射有效/门控有效 |
| input | `lsiq_dp_issue_entry` | 12 | `ct_idu_is_lsiq` | LSIQ 发射 entry one-hot |
| input | `lsiq_dp_issue_read_data` | 165/按 pipe | `ct_idu_is_lsiq` | LSIQ pipe3/4 发射 payload |
| input | `sdiq_dp_issue_entry` | 12 | `ct_idu_is_sdiq` | SDIQ 发射 entry one-hot |
| input | `sdiq_dp_issue_read_data` | 117/按字段 | `ct_idu_is_sdiq` | SDIQ store data payload |
| input | `viq[0:1]_dp_issue_entry` | 8 | `ct_idu_is_viq0/1` | VIQ 发射 entry one-hot |
| input | `viq[0:1]_dp_issue_read_data` | 150 | `ct_idu_is_viq0/1` | VIQ 发射指令 payload |
| input | `viq[0:1]_xx_issue_en/gateclk_issue_en` | 1 | `ct_idu_is_viq0/1` | VIQ 发射有效/门控有效 |

### 3.3 PRF/FRF/VRF 读数据与前递输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `prf_dp_rf_pipe[0:5]_src*_data` | 64 | `ct_idu_rf_prf_pregfile` | 整数物理寄存器读数据 |
| input | `prf_xx_rf_pipe1_src[0:1]_data` | 64 | `ct_idu_rf_prf_pregfile` | pipe1 整数源读数据 |
| input | `prf_dp_rf_pipe[5:7]_srcv*_vreg_data` | 64 | `ct_idu_rf_prf_fregfile/vregfile` | 浮点/向量寄存器读数据 |
| input | `prf_dp_rf_pipe[6:7]_srcvm_vreg_data` | 64 | `ct_idu_rf_prf_vregfile` | VIQ mask 源读数据 |
| input | `fwd_dp_rf_pipe[0:5]_src*_data` | 64 | `ct_idu_rf_fwd` | 整数/LSU 前递源数据 |
| input | `fwd_dp_rf_pipe[0:5]_src*_no_fwd` | 1 | `ct_idu_rf_fwd` | 对应整数/LSU 源没有前递命中 |
| input | `fwd_dp_rf_pipe[3:4]_srcvm_vreg_vr[0:1]_data` | 64 | `ct_idu_rf_fwd` | LSU vector mask 前递数据 |
| input | `fwd_dp_rf_pipe[3:4]_srcvm_no_fwd_expt_vmla` | 1 | `ct_idu_rf_fwd` | LSU mask 源无前递，排除 VMLA 场景 |
| input | `fwd_dp_rf_pipe5_srcv0_vreg_fr/vr[0:1]_data` | 64 | `ct_idu_rf_fwd` | SDIQ 向量 store data 前递数据 |
| input | `fwd_dp_rf_pipe[6:7]_srcv[0:2]_vreg_fr/vr[0:1]_data` | 64 | `ct_idu_rf_fwd` | VFPU 源向量/浮点前递数据 |
| input | `fwd_dp_rf_pipe[6:7]_srcv[0:2]_no_fwd` | 1 | `ct_idu_rf_fwd` | VFPU 源无前递命中 |
| input | `fwd_dp_rf_pipe[6:7]_srcvm_vreg_vr[0:1]_data` | 64 | `ct_idu_rf_fwd` | VFPU mask 前递数据 |
| input | `fwd_dp_rf_pipe[6:7]_srcvm_no_fwd` | 1 | `ct_idu_rf_fwd` | VFPU mask 无前递命中 |

### 3.4 输出到 RF Control

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `dp_ctrl_is_aiq[0:1]_issue_*` | 1/8/108 | `ct_idu_rf_ctrl` | AIQ 指令类别、目的有效、latch ready 等控制属性 |
| output | `dp_ctrl_is_viq[0:1]_issue_*` | 1/16 | `ct_idu_rf_ctrl` | VIQ 指令类别、目的向量有效、VMLA/VDIV 属性 |
| output | `dp_ctrl_rf_pipe0_eu_sel` | 4 | `ct_idu_rf_ctrl` | pipe0 执行单元选择 |
| output | `dp_ctrl_rf_pipe1_eu_sel` | 2 | `ct_idu_rf_ctrl` | pipe1 执行单元选择 |
| output | `dp_ctrl_rf_pipe[0:7]_src_no_rdy` | 1 | `ct_idu_rf_ctrl` | pipe 源操作数未 ready 汇总 |
| output | `dp_ctrl_rf_pipe[0:1]_mtvr` | 1 | `ct_idu_rf_ctrl` | move-to-vector/floating 属性 |
| output | `dp_ctrl_rf_pipe[0:1]_src2_vld` | 1 | `ct_idu_rf_ctrl` | pipe0/1 第三源有效 |
| output | `dp_ctrl_rf_pipe[3:4]_srcvm_vld` | 1 | `ct_idu_rf_ctrl` | LSU mask 源有效 |
| output | `dp_ctrl_rf_pipe4_staddr` | 1 | `ct_idu_rf_ctrl` | store address 指令标记 |
| output | `dp_ctrl_rf_pipe5_src0_vld` | 1 | `ct_idu_rf_ctrl` | pipe5 整数源有效 |
| output | `dp_ctrl_rf_pipe[6:7]_mfvr` | 1 | `ct_idu_rf_ctrl` | move-from-vector/floating 属性 |
| output | `dp_ctrl_rf_pipe[6:7]_srcv2_vld` | 1 | `ct_idu_rf_ctrl` | VFPU 源 2 有效 |
| output | `dp_ctrl_rf_pipe6_vmul` | 1 | `ct_idu_rf_ctrl` | pipe6 VMUL 属性 |
| output | `dp_ctrl_rf_pipe7_vmul_unsplit` | 1 | `ct_idu_rf_ctrl` | pipe7 未拆分 VMUL 属性 |

### 3.5 输出到 Issue Queue、PRF 与 Forward

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `dp_aiq[0:1]_rf_lch_entry` | 8 | `ct_idu_is_aiq0/1` | RF latch 的 AIQ entry |
| output | `dp_aiq[0:1]_rf_rdy_clr` | 3 | `ct_idu_is_aiq0/1` | AIQ 源 ready 清除 |
| output | `dp_biq_rf_lch_entry` | 12 | `ct_idu_is_biq` | RF latch 的 BIQ entry |
| output | `dp_biq_rf_rdy_clr` | 2 | `ct_idu_is_biq` | BIQ 源 ready 清除 |
| output | `dp_lsiq_rf_pipe[3:4]_lch_entry` | 12 | `ct_idu_is_lsiq` | RF latch 的 LSIQ entry |
| output | `dp_lsiq_rf_pipe[3:4]_rdy_clr` | 3 | `ct_idu_is_lsiq` | LSIQ 源 ready 清除 |
| output | `dp_sdiq_rf_lch_entry` | 12 | `ct_idu_is_sdiq` | RF latch 的 SDIQ entry |
| output | `dp_sdiq_rf_rdy_clr` | 2 | `ct_idu_is_sdiq` | SDIQ 源 ready 清除 |
| output | `dp_sdiq_rf_sdiq_entry` | 12 | `ct_idu_is_sdiq/LSU` | store data entry |
| output | `dp_sdiq_rf_staddr1_vld/stdata1_vld/staddr_rdy_clr` | 1 | `ct_idu_is_sdiq` | store address/data ready 控制 |
| output | `dp_viq[0:1]_rf_lch_entry` | 8 | `ct_idu_is_viq0/1` | RF latch 的 VIQ entry |
| output | `dp_viq[0:1]_rf_rdy_clr` | 4 | `ct_idu_is_viq0/1` | VIQ 源 ready 清除 |
| output | `dp_prf_rf_pipe[0:5]_src*_preg` | 7 | `ct_idu_rf_prf_pregfile` | 整数 PRF 读地址 |
| output | `dp_prf_rf_pipe[5:7]_srcv*_vreg_fr/vr[0:1]` | 6 | `ct_idu_rf_prf_fregfile/vregfile` | 浮点/向量寄存器读地址 |
| output | `dp_prf_rf_pipe[6:7]_srcvm_vreg_vr[0:1]` | 6 | `ct_idu_rf_prf_vregfile` | 向量 mask 读地址 |
| output | `dp_fwd_rf_pipe[0:5]_src*_preg` | 7 | `ct_idu_rf_fwd` | 整数/LSU 前递比较源寄存器号 |
| output | `dp_fwd_rf_pipe[5:7]_srcv*_vreg` | 7 | `ct_idu_rf_fwd` | 向量/浮点前递比较源寄存器号 |
| output | `dp_fwd_rf_pipe[6:7]_srcvm_vreg` | 7 | `ct_idu_rf_fwd` | mask 源前递比较寄存器号 |
| output | `dp_fwd_rf_pipe[6:7]_vmla` | 1 | `ct_idu_rf_fwd` | VMLA 前递特殊路径标记 |
| output | `dp_xx_rf_pipe[0:1]_dst_preg_dup[0:4]` | 7 | IDU 内部广播 | pipe0/1 目的整数物理寄存器多副本 |
| output | `dp_xx_rf_pipe[6:7]_dst_vreg_dup[0:3]` | 7 | IDU 内部广播 | pipe6/7 目的向量物理寄存器多副本 |

### 3.6 输出到执行单元

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `idu_cp0_rf_func` | 5 | CP0 | CP0 功能码 |
| output | `idu_cp0_rf_iid` | 7 | CP0 | 指令 IID |
| output | `idu_cp0_rf_opcode` | 32 | CP0 | 原始 opcode |
| output | `idu_cp0_rf_preg` | 7 | CP0 | CP0 相关目的/源物理寄存器 |
| output | `idu_cp0_rf_src0` | 64 | CP0 | CP0 源操作数 |
| output | `idu_iu_rf_pipe[0:1]_dst_preg/dst_vreg` | 7 | IU | pipe0/1 整数/向量目的物理寄存器号 |
| output | `idu_iu_rf_pipe[0:1]_dst_vld/dstv_vld` | 1 | IU | pipe0/1 目的有效 |
| output | `idu_iu_rf_pipe[0:1]_func` | 5 | IU | pipe0/1 ALU 功能码 |
| output | `idu_iu_rf_pipe[0:1]_imm` | 6 | IU | pipe0/1 小立即数字段 |
| output | `idu_iu_rf_pipe[0:1]_rslt_sel` | 21 | IU | pipe0/1 结果选择控制 |
| output | `idu_iu_rf_pipe[0:1]_src0/src1/src2` | 64 | IU | pipe0/1 源操作数 |
| output | `idu_iu_rf_pipe[0:1]_src1_no_imm` | 64 | IU | 未经立即数选择的源 1 |
| output | `idu_iu_rf_pipe[0:1]_iid` | 7 | IU | pipe0/1 指令 IID |
| output | `idu_iu_rf_pipe[0:1]_opcode` | 32 | IU | pipe0/1 原始 opcode |
| output | `idu_iu_rf_pipe[0:1]_vl` | 8 | IU | 向量长度字段 |
| output | `idu_iu_rf_pipe[0:1]_vlmul` | 2 | IU | LMUL 编码 |
| output | `idu_iu_rf_pipe[0:1]_vsew` | 3 | IU | SEW 编码 |
| output | `idu_iu_rf_pipe0_expt_vec/expt_vld/high_hw_expt` | 5/1/1 | IU | pipe0 异常向量、异常有效和高半字异常 |
| output | `idu_iu_rf_pipe0_special_imm` | 20 | IU | special 指令立即数 |
| output | `idu_iu_rf_pipe1_mult_func` | 8 | IU MULT | 乘法功能码 |
| output | `idu_iu_rf_pipe1_mla_src2_preg/src2_vld` | 7/1 | IU MULT | MLA 源 2 物理寄存器和有效 |
| output | `idu_iu_rf_pipe2_func` | 8 | BJU | 分支功能码 |
| output | `idu_iu_rf_pipe2_offset` | 21 | BJU | 分支偏移 |
| output | `idu_iu_rf_pipe2_src0/src1` | 64 | BJU | 分支比较源操作数 |
| output | `idu_iu_rf_pipe2_iid/pid` | 7/5 | BJU | 指令 IID/PID |
| output | `idu_iu_rf_pipe2_length/pcall/rts` | 1 | BJU | 分支长度、调用、返回属性 |
| output | `idu_lsu_rf_pipe3_*` | 多种 | LSU pipe3 | load/atomic 地址 pipe 的源、偏移、属性、entry、异常/调试属性 |
| output | `idu_lsu_rf_pipe4_*` | 多种 | LSU pipe4 | store/fence/TLB/flush pipe 的源、偏移、fence 模式、entry、属性 |
| output | `idu_lsu_rf_pipe5_*` | 多种 | LSU pipe5 | store data 源操作数、向量 store data 和 SDIQ entry |
| output | `idu_vfpu_rf_pipe[6:7]_dst_ereg` | 5 | VFPU | 浮点异常/扩展寄存器目的号 |
| output | `idu_vfpu_rf_pipe[6:7]_dst_preg/dst_vreg` | 7 | VFPU | VFPU 目的整数/向量寄存器 |
| output | `idu_vfpu_rf_pipe[6:7]_dst_vld/dstv_vld/dste_vld` | 1 | VFPU | VFPU 目的有效 |
| output | `idu_vfpu_rf_pipe[6:7]_eu_sel` | 12 | VFPU | VFPU 执行单元选择 |
| output | `idu_vfpu_rf_pipe[6:7]_func` | 20 | VFPU | VFPU 功能码 |
| output | `idu_vfpu_rf_pipe[6:7]_iid` | 7 | VFPU | VFPU 指令 IID |
| output | `idu_vfpu_rf_pipe[6:7]_imm0` | 3 | VFPU | VFPU 立即数字段 |
| output | `idu_vfpu_rf_pipe[6:7]_inst_type` | 6 | VFPU | VFPU 指令类型 |
| output | `idu_vfpu_rf_pipe[6:7]_ready_stage` | 3 | VFPU | 结果 ready stage |
| output | `idu_vfpu_rf_pipe[6:7]_srcv[0:2]_fr` | 64 | VFPU | VFPU 浮点/向量源操作数 FR 视图 |
| output | `idu_vfpu_rf_pipe[6:7]_mla_srcv2_vreg/srcv2_vld` | 7/1 | VFPU | VMLA 源 2 寄存器和有效 |
| output | `idu_vfpu_rf_pipe[6:7]_vmla_type` | 3 | VFPU | VMLA 类型 |

## 4. `ct_idu_rf_fwd`

RF 前递顶层模块根据 RF DP 给出的源寄存器号，与 IU/LSU/VFPU 的 EX/WB 前递端口比较，输出每个 RF 源操作数的前递数据和 no_fwd 标志。

### 4.1 前递比较源输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `cp0_idu_src2_fwd_disable` | 1 | CP0 | 禁止整数源 2 前递 |
| input | `cp0_idu_srcv2_fwd_disable` | 1 | CP0 | 禁止向量源 2 前递 |
| input | `dp_fwd_rf_pipe[0:5]_src*_preg` | 7 | `ct_idu_rf_dp` | 整数/LSU 源物理寄存器号 |
| input | `dp_fwd_rf_pipe1_mla` | 1 | `ct_idu_rf_dp` | pipe1 MLA 指令标记 |
| input | `dp_fwd_rf_pipe5_srcv0_vreg` | 7 | `ct_idu_rf_dp` | SDIQ 向量 store data 源寄存器 |
| input | `dp_fwd_rf_pipe[6:7]_srcv[0:2]_vreg` | 7 | `ct_idu_rf_dp` | VFPU 向量源寄存器 |
| input | `dp_fwd_rf_pipe[6:7]_srcvm_vreg` | 7 | `ct_idu_rf_dp` | VFPU mask 源寄存器 |
| input | `dp_fwd_rf_pipe[6:7]_vmla` | 1 | `ct_idu_rf_dp` | VMLA 前递特殊处理标记 |

### 4.2 执行单元前递源输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg` | 7 | IU EX1 | IU EX1 前递目的整数寄存器 |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg_data` | 64 | IU EX1 | IU EX1 前递数据 |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg_vld` | 1 | IU EX1 | IU EX1 前递有效 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg` | 7 | IU EX2/WB | IU 写回目的整数寄存器 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_data` | 64 | IU EX2/WB | IU 写回数据 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_vld` | 1 | IU EX2/WB | IU 写回有效 |
| input | `iu_idu_pipe1_mla_src2_no_fwd` | 1 | IU | pipe1 MLA 源 2 不允许前递 |
| input | `lsu_idu_da_pipe3_fwd_preg` | 7 | LSU DA | LSU DA 前递整数目的寄存器 |
| input | `lsu_idu_da_pipe3_fwd_preg_data` | 64 | LSU DA | LSU DA 前递整数数据 |
| input | `lsu_idu_da_pipe3_fwd_preg_vld` | 1 | LSU DA | LSU DA 整数前递有效 |
| input | `lsu_idu_wb_pipe3_wb_preg` | 7 | LSU WB | LSU 写回整数目的寄存器 |
| input | `lsu_idu_wb_pipe3_wb_preg_data` | 64 | LSU WB | LSU 写回整数数据 |
| input | `lsu_idu_wb_pipe3_wb_preg_vld` | 1 | LSU WB | LSU 整数写回有效 |
| input | `lsu_idu_da_pipe3_fwd_vreg` | 7 | LSU DA | LSU DA 前递向量目的寄存器 |
| input | `lsu_idu_da_pipe3_fwd_vreg_fr/vr[0:1]_data` | 64 | LSU DA | LSU DA 向量/浮点前递数据 |
| input | `lsu_idu_da_pipe3_fwd_vreg_vld` | 1 | LSU DA | LSU DA 向量前递有效 |
| input | `lsu_idu_wb_pipe3_fwd_vreg` | 7 | LSU WB | LSU WB 向量目的寄存器 |
| input | `lsu_idu_wb_pipe3_wb_vreg_fr/vr[0:1]_data` | 64 | LSU WB | LSU WB 向量/浮点写回数据 |
| input | `lsu_idu_wb_pipe3_fwd_vreg_vld` | 1 | LSU WB | LSU 向量写回前递有效 |
| input | `vfpu_idu_ex[3:5]_pipe[6:7]_fwd_vreg` | 7 | VFPU | VFPU EX3/EX4/EX5 前递目的向量寄存器 |
| input | `vfpu_idu_ex[3:4]_pipe[6:7]_fwd_vreg_fr/vr[0:1]_data` | 64 | VFPU | VFPU EX3/EX4 前递数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_fr/vr[0:1]_data` | 64 | VFPU | VFPU EX5 写回前递数据 |
| input | `vfpu_idu_ex[3:5]_pipe[6:7]_fwd_vreg_vld` | 1 | VFPU | VFPU 前递有效 |

### 4.3 前递结果输出

| IO 类型  | 信号/信号组                                               | 位宽  | 对端模块           | 信号功能                     |
| ------ | ---------------------------------------------------- | --- | -------------- | ------------------------ |
| output | `fwd_dp_rf_pipe[0:4]_src[0:1]_data`                  | 64  | `ct_idu_rf_dp` | pipe0/1/2/3/4 整数源前递数据    |
| output | `fwd_dp_rf_pipe[0:4]_src[0:1]_no_fwd`                | 1   | `ct_idu_rf_dp` | pipe0/1/2/3/4 整数源没有前递命中  |
| output | `fwd_dp_rf_pipe5_src0_data`                          | 64  | `ct_idu_rf_dp` | pipe5 store data 整数源前递数据 |
| output | `fwd_dp_rf_pipe5_src0_no_fwd`                        | 1   | `ct_idu_rf_dp` | pipe5 整数源没有前递命中          |
| output | `fwd_dp_rf_pipe5_src0_no_fwd_expt_mla`               | 1   | `ct_idu_rf_dp` | pipe5 整数源无前递，排除 MLA 场景   |
| output | `fwd_dp_rf_pipe[3:4]_srcvm_vreg_vr[0:1]_data`        | 64  | `ct_idu_rf_dp` | LSU mask 源前递数据           |
| output | `fwd_dp_rf_pipe[3:4]_srcvm_no_fwd_expt_vmla`         | 1   | `ct_idu_rf_dp` | LSU mask 源无前递，排除 VMLA 场景 |
| output | `fwd_dp_rf_pipe5_srcv0_vreg_fr/vr[0:1]_data`         | 64  | `ct_idu_rf_dp` | pipe5 向量 store data 前递数据 |
| output | `fwd_dp_rf_pipe5_srcv0_no_fwd`                       | 1   | `ct_idu_rf_dp` | pipe5 向量源没有前递命中          |
| output | `fwd_dp_rf_pipe[6:7]_srcv[0:2]_vreg_fr/vr[0:1]_data` | 64  | `ct_idu_rf_dp` | VFPU 源向量/浮点前递数据          |
| output | `fwd_dp_rf_pipe[6:7]_srcv[0:2]_no_fwd`               | 1   | `ct_idu_rf_dp` | VFPU 源没有前递命中             |
| output | `fwd_dp_rf_pipe[6:7]_srcvm_vreg_vr[0:1]_data`        | 64  | `ct_idu_rf_dp` | VFPU mask 源前递数据          |
| output | `fwd_dp_rf_pipe[6:7]_srcvm_no_fwd`                   | 1   | `ct_idu_rf_dp` | VFPU mask 源没有前递命中        |

## 5. 前递叶子模块

### 5.1 `ct_idu_rf_fwd_preg`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg` | 7 | IU EX1 | EX1 前递整数目的寄存器 |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg_data` | 64 | IU EX1 | EX1 前递整数数据 |
| input | `iu_idu_ex1_pipe[0:1]_fwd_preg_vld` | 1 | IU EX1 | EX1 前递有效 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg` | 7 | IU WB | IU 写回整数目的寄存器 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_data` | 64 | IU WB | IU 写回整数数据 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_vld` | 1 | IU WB | IU 写回有效 |
| input | `lsu_idu_da_pipe3_fwd_preg` | 7 | LSU DA | LSU DA 前递整数目的寄存器 |
| input | `lsu_idu_da_pipe3_fwd_preg_data` | 64 | LSU DA | LSU DA 前递整数数据 |
| input | `lsu_idu_da_pipe3_fwd_preg_vld` | 1 | LSU DA | LSU DA 前递有效 |
| input | `lsu_idu_wb_pipe3_wb_preg` | 7 | LSU WB | LSU 写回整数目的寄存器 |
| input | `lsu_idu_wb_pipe3_wb_preg_data` | 64 | LSU WB | LSU 写回整数数据 |
| input | `lsu_idu_wb_pipe3_wb_preg_vld` | 1 | LSU WB | LSU 写回有效 |
| input | `x_src_reg` | 7 | `ct_idu_rf_fwd` | 当前待比较源寄存器 |
| output | `x_src_data` | 64 | `ct_idu_rf_fwd` | 前递命中后的源数据 |
| output | `x_src_no_fwd` | 1 | `ct_idu_rf_fwd` | 没有前递命中 |

### 5.2 `ct_idu_rf_fwd_vreg`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `lsu_idu_da_pipe3_fwd_vreg` | 7 | LSU DA | LSU DA 前递向量目的寄存器 |
| input | `lsu_idu_da_pipe3_fwd_vreg_data` | 64 | LSU DA | LSU DA 前递向量数据 |
| input | `lsu_idu_da_pipe3_fwd_vreg_vld` | 1 | LSU DA | LSU DA 向量前递有效 |
| input | `lsu_idu_wb_pipe3_fwd_vreg` | 7 | LSU WB | LSU WB 向量目的寄存器 |
| input | `lsu_idu_wb_pipe3_wb_vreg_data` | 64 | LSU WB | LSU WB 向量写回数据 |
| input | `lsu_idu_wb_pipe3_fwd_vreg_vld` | 1 | LSU WB | LSU WB 向量前递有效 |
| input | `vfpu_idu_ex[3:4]_pipe[6:7]_fwd_vreg` | 7 | VFPU | VFPU EX3/EX4 前递向量目的寄存器 |
| input | `vfpu_idu_ex[3:4]_pipe[6:7]_fwd_vreg_data` | 64 | VFPU | VFPU EX3/EX4 前递向量数据 |
| input | `vfpu_idu_ex[3:4]_pipe[6:7]_fwd_vreg_vld` | 1 | VFPU | VFPU EX3/EX4 前递有效 |
| input | `vfpu_idu_ex5_pipe[6:7]_fwd_vreg` | 7 | VFPU EX5 | VFPU EX5 前递/写回向量目的寄存器 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_data` | 64 | VFPU EX5 | VFPU EX5 写回向量数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_fwd_vreg_vld` | 1 | VFPU EX5 | VFPU EX5 前递有效 |
| input | `x_srcv_reg` | 7 | `ct_idu_rf_fwd` | 当前待比较源向量寄存器 |
| output | `x_srcv_data` | 64 | `ct_idu_rf_fwd` | 前递命中后的向量源数据 |
| output | `x_srcv_no_fwd` | 1 | `ct_idu_rf_fwd` | 没有向量前递命中 |

## 6. Pipe 解码模块

### 6.1 `ct_idu_rf_pipe0_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe0_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe0 原始指令编码 |
| input | `pipe0_decd_expt_vld` | 1 | `ct_idu_rf_dp` | pipe0 异常有效，用于影响解码/选择 |
| output | `pipe0_decd_eu_sel` | 4 | `ct_idu_rf_dp` | pipe0 执行单元选择 |
| output | `pipe0_decd_func` | 5 | `ct_idu_rf_dp` | pipe0 ALU/特殊功能码 |
| output | `pipe0_decd_imm` | 6 | `ct_idu_rf_dp` | 小立即数字段 |
| output | `pipe0_decd_sel` | 21 | `ct_idu_rf_dp` | 结果选择控制 |
| output | `pipe0_decd_src1_imm` | 64 | `ct_idu_rf_dp` | 源 1 立即数扩展值 |

### 6.2 `ct_idu_rf_pipe1_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe1_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe1 原始指令编码 |
| output | `pipe1_decd_eu_sel` | 2 | `ct_idu_rf_dp` | pipe1 执行单元选择 |
| output | `pipe1_decd_func` | 5 | `ct_idu_rf_dp` | pipe1 ALU 功能码 |
| output | `pipe1_decd_imm` | 6 | `ct_idu_rf_dp` | 小立即数字段 |
| output | `pipe1_decd_mult_func` | 8 | `ct_idu_rf_dp` | 乘法功能码 |
| output | `pipe1_decd_sel` | 21 | `ct_idu_rf_dp` | 结果选择控制 |
| output | `pipe1_decd_src1_imm` | 64 | `ct_idu_rf_dp` | 源 1 立即数扩展值 |

### 6.3 `ct_idu_rf_pipe2_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe2_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe2 原始分支指令编码 |
| output | `pipe2_decd_func` | 8 | `ct_idu_rf_dp` | 分支功能码 |
| output | `pipe2_decd_offset` | 21 | `ct_idu_rf_dp` | 分支偏移 |
| output | `pipe2_decd_src1_imm` | 64 | `ct_idu_rf_dp` | 源 1 立即数扩展值 |

### 6.4 `ct_idu_rf_pipe3_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe3_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe3 load/atomic 指令编码 |
| output | `pipe3_decd_atomic` | 1 | `ct_idu_rf_dp` | atomic 指令标记 |
| output | `pipe3_decd_inst_fls` | 1 | `ct_idu_rf_dp` | 浮点/向量 load-store 标记 |
| output | `pipe3_decd_inst_ldr` | 1 | `ct_idu_rf_dp` | load 指令标记 |
| output | `pipe3_decd_inst_size` | 2 | `ct_idu_rf_dp` | 访存宽度 |
| output | `pipe3_decd_inst_type` | 2 | `ct_idu_rf_dp` | 访存类型 |
| output | `pipe3_decd_lsfifo` | 1 | `ct_idu_rf_dp` | 进入 load/store FIFO 标记 |
| output | `pipe3_decd_off_0_extend` | 1 | `ct_idu_rf_dp` | offset 0 扩展控制 |
| output | `pipe3_decd_offset` | 12 | `ct_idu_rf_dp` | 12 位访存偏移 |
| output | `pipe3_decd_offset_plus` | 13 | `ct_idu_rf_dp` | 偏移加一/扩展辅助字段 |
| output | `pipe3_decd_shift` | 4 | `ct_idu_rf_dp` | 地址 shift 控制 |
| output | `pipe3_decd_sign_extend` | 1 | `ct_idu_rf_dp` | load 符号扩展控制 |

### 6.5 `ct_idu_rf_pipe4_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe4_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe4 store/fence/TLB 指令编码 |
| input | `pipe4_decd_dst_preg` | 7 | `ct_idu_rf_dp` | pipe4 目的/辅助物理寄存器 |
| input | `cp0_lsu_fencei_broad_dis` | 1 | CP0 | 禁止 fence.i broadcast |
| input | `cp0_lsu_fencerw_broad_dis` | 1 | CP0 | 禁止 fence rw broadcast |
| input | `cp0_lsu_tlb_broad_dis` | 1 | CP0 | 禁止 TLB broadcast |
| output | `pipe4_decd_atomic` | 1 | `ct_idu_rf_dp` | atomic 指令标记 |
| output | `pipe4_decd_fence_mode` | 4 | `ct_idu_rf_dp` | fence 模式 |
| output | `pipe4_decd_icc` | 1 | `ct_idu_rf_dp` | cache/ICC 类操作 |
| output | `pipe4_decd_inst_fls` | 1 | `ct_idu_rf_dp` | 浮点/向量 load-store 标记 |
| output | `pipe4_decd_inst_flush` | 1 | `ct_idu_rf_dp` | flush 类 LSU 指令 |
| output | `pipe4_decd_inst_mode` | 2 | `ct_idu_rf_dp` | LSU 指令模式 |
| output | `pipe4_decd_inst_share` | 1 | `ct_idu_rf_dp` | share 属性 |
| output | `pipe4_decd_inst_size` | 2 | `ct_idu_rf_dp` | 访存宽度 |
| output | `pipe4_decd_inst_str` | 1 | `ct_idu_rf_dp` | store 指令标记 |
| output | `pipe4_decd_inst_type` | 2 | `ct_idu_rf_dp` | 访存类型 |
| output | `pipe4_decd_lsfifo` | 1 | `ct_idu_rf_dp` | 进入 load/store FIFO 标记 |
| output | `pipe4_decd_mmu_req` | 1 | `ct_idu_rf_dp` | MMU 请求类指令 |
| output | `pipe4_decd_off_0_extend` | 1 | `ct_idu_rf_dp` | offset 0 扩展控制 |
| output | `pipe4_decd_offset` | 12 | `ct_idu_rf_dp` | 12 位访存偏移 |
| output | `pipe4_decd_offset_plus` | 13 | `ct_idu_rf_dp` | 偏移加一/扩展辅助字段 |
| output | `pipe4_decd_shift` | 4 | `ct_idu_rf_dp` | 地址 shift 控制 |
| output | `pipe4_decd_st` | 1 | `ct_idu_rf_dp` | store 类指令 |
| output | `pipe4_decd_sync_fence` | 1 | `ct_idu_rf_dp` | 同步 fence |

### 6.6 `ct_idu_rf_pipe6_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe6_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe6 VFPU/VPU 指令编码 |
| input | `pipe6_decd_vsew` | 2 | `ct_idu_rf_dp` | 当前向量 SEW 编码输入 |
| output | `pipe6_decd_eu_sel` | 12 | `ct_idu_rf_dp` | pipe6 向量/浮点执行单元选择 |
| output | `pipe6_decd_func` | 20 | `ct_idu_rf_dp` | pipe6 VFPU 功能码 |
| output | `pipe6_decd_imm0` | 3 | `ct_idu_rf_dp` | pipe6 立即数字段 |
| output | `pipe6_decd_inst_type` | 6 | `ct_idu_rf_dp` | pipe6 指令类型 |
| output | `pipe6_decd_oper_size` | 3 | `ct_idu_rf_dp` | pipe6 操作元素宽度/操作大小 |
| output | `pipe6_decd_ready_stage` | 3 | `ct_idu_rf_dp` | pipe6 结果 ready stage |
| output | `pipe6_decd_vimm` | 5 | `ct_idu_rf_dp` | pipe6 向量立即数 |

### 6.7 `ct_idu_rf_pipe7_decd`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `pipe7_decd_opcode` | 32 | `ct_idu_rf_dp` | pipe7 VFPU/VPU 指令编码 |
| input | `pipe7_decd_vsew` | 2 | `ct_idu_rf_dp` | 当前向量 SEW 编码输入 |
| output | `pipe7_decd_eu_sel` | 12 | `ct_idu_rf_dp` | pipe7 向量/浮点执行单元选择 |
| output | `pipe7_decd_func` | 20 | `ct_idu_rf_dp` | pipe7 VFPU 功能码 |
| output | `pipe7_decd_imm0` | 3 | `ct_idu_rf_dp` | pipe7 立即数字段 |
| output | `pipe7_decd_inst_type` | 6 | `ct_idu_rf_dp` | pipe7 指令类型 |
| output | `pipe7_decd_oper_size` | 3 | `ct_idu_rf_dp` | pipe7 操作元素宽度/操作大小 |
| output | `pipe7_decd_ready_stage` | 3 | `ct_idu_rf_dp` | pipe7 结果 ready stage |
| output | `pipe7_decd_vimm` | 5 | `ct_idu_rf_dp` | pipe7 向量立即数 |

## 7. 物理寄存器文件模块

### 7.1 `ct_idu_rf_prf_pregfile`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | 整数 PRF 主时钟 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `rtu_yy_xx_dbgon` | 1 | RTU/HAD | 调试状态 |
| input | `dp_prf_rf_pipe[0:5]_src*_preg` | 7 | `ct_idu_rf_dp` | 整数 PRF 读地址 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_data` | 64 | IU WB | IU 写回数据 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_expand` | 96 | IU WB | IU 写回展开 valid/选择向量 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_vld` | 1 | IU WB | IU 写回有效 |
| input | `lsu_idu_wb_pipe3_wb_preg_data` | 64 | LSU WB | LSU 写回整数数据 |
| input | `lsu_idu_wb_pipe3_wb_preg_expand` | 96 | LSU WB | LSU 写回展开 valid/选择向量 |
| input | `lsu_idu_wb_pipe3_wb_preg_vld` | 1 | LSU WB | LSU 写回有效 |
| output | `prf_dp_rf_pipe0_src[0:1]_data` | 64 | `ct_idu_rf_dp` | pipe0 整数源读数据 |
| output | `prf_xx_rf_pipe1_src[0:1]_data` | 64 | `ct_idu_rf_dp` | pipe1 整数源读数据 |
| output | `prf_dp_rf_pipe[2:4]_src[0:1]_data` | 64 | `ct_idu_rf_dp` | pipe2/3/4 整数源读数据 |
| output | `prf_dp_rf_pipe5_src0_data` | 64 | `ct_idu_rf_dp` | pipe5 整数源读数据 |
| output | `idu_had_wb_data` | 64 | HAD | 调试写回观察数据 |
| output | `idu_had_wb_vld` | 1 | HAD | 调试写回观察有效 |

### 7.2 `ct_idu_rf_prf_fregfile`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | 浮点寄存器文件主时钟 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `dp_prf_rf_pipe5_srcv0_vreg` | 6 | `ct_idu_rf_dp` | pipe5 浮点/向量源读地址 |
| input | `dp_prf_rf_pipe[6:7]_srcv[0:2]_vreg` | 6 | `ct_idu_rf_dp` | VFPU 浮点源读地址 |
| input | `lsu_idu_wb_pipe3_wb_vreg_data` | 64 | LSU WB | LSU 浮点/向量写回数据 |
| input | `lsu_idu_wb_pipe3_wb_vreg_expand` | 64 | LSU WB | LSU 写回展开 valid/选择向量 |
| input | `lsu_idu_wb_pipe3_wb_vreg_vld` | 1 | LSU WB | LSU 写回有效 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_data` | 64 | VFPU WB | VFPU 写回数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_expand` | 64 | VFPU WB | VFPU 写回展开 valid/选择向量 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_vld` | 1 | VFPU WB | VFPU 写回有效 |
| output | `prf_dp_rf_pipe5_srcv0_vreg_data` | 64 | `ct_idu_rf_dp` | pipe5 浮点源读数据 |
| output | `prf_dp_rf_pipe[6:7]_srcv[0:2]_vreg_data` | 64 | `ct_idu_rf_dp` | VFPU 浮点源读数据 |

### 7.3 `ct_idu_rf_prf_vregfile`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_prf_rf_pipe5_srcv0_vreg` | 6 | `ct_idu_rf_dp` | pipe5 向量源读地址 |
| input | `dp_prf_rf_pipe[6:7]_srcv[0:2]_vreg` | 6 | `ct_idu_rf_dp` | VFPU 向量源读地址 |
| input | `dp_prf_rf_pipe[6:7]_srcvm_vreg` | 6 | `ct_idu_rf_dp` | VFPU mask 源读地址 |
| input | `lsu_idu_wb_pipe3_wb_vreg_data` | 64 | LSU WB | LSU 向量写回数据 |
| input | `lsu_idu_wb_pipe3_wb_vreg_expand` | 64 | LSU WB | LSU 写回展开 valid/选择向量 |
| input | `lsu_idu_wb_pipe3_wb_vreg_vld` | 1 | LSU WB | LSU 向量写回有效 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_data` | 64 | VFPU WB | VFPU 向量写回数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_expand` | 64 | VFPU WB | VFPU 写回展开 valid/选择向量 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_vld` | 1 | VFPU WB | VFPU 向量写回有效 |
| output | `prf_dp_rf_pipe5_srcv0_vreg_data` | 64 | `ct_idu_rf_dp` | pipe5 向量源读数据 |
| output | `prf_dp_rf_pipe[6:7]_srcv[0:2]_vreg_data` | 64 | `ct_idu_rf_dp` | VFPU 向量源读数据 |
| output | `prf_dp_rf_pipe[6:7]_srcvm_vreg_data` | 64 | `ct_idu_rf_dp` | VFPU mask 源读数据 |

### 7.4 `ct_idu_rf_prf_eregfile`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | EREG 文件主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `rtu_idu_pst_ereg_retired_released_wb` | 32 | RTU/PST | retired/released EREG 写回控制 |
| input | `rtu_idu_retire0_inst_vld` | 1 | RTU | retire0 指令有效 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_ereg` | 5 | VFPU WB | VFPU 写回 EREG 号 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_ereg_data` | 6 | VFPU WB | VFPU 写回 EREG 数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_ereg_vld` | 1 | VFPU WB | VFPU EREG 写回有效 |
| output | `idu_cp0_fesr_acc_updt_val` | 7 | CP0 | FESR accrued exception 更新值 |
| output | `idu_cp0_fesr_acc_updt_vld` | 1 | CP0 | FESR accrued exception 更新有效 |

## 8. Gated 寄存器单元

### 8.1 `ct_idu_rf_prf_gated_preg`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | `ct_idu_rf_prf_pregfile` | gated preg 单元时钟 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `iu_idu_ex2_pipe[0:1]_wb_preg_data` | 64 | IU WB | IU 写回数据 |
| input | `lsu_idu_wb_pipe3_wb_preg_data` | 64 | LSU WB | LSU 写回数据 |
| input | `x_wb_vld` | 3 | `ct_idu_rf_prf_pregfile` | 三路写回选择有效 |
| output | `x_reg_dout` | 64 | `ct_idu_rf_prf_pregfile` | 当前物理寄存器输出数据 |

### 8.2 `ct_idu_rf_prf_gated_vreg`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `vreg_top_clk` | 1 | `ct_idu_rf_prf_vregfile/fregfile` | gated vreg 单元时钟 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `lsu_idu_wb_pipe3_wb_vreg_data` | 64 | LSU WB | LSU 向量写回数据 |
| input | `vfpu_idu_ex5_pipe[6:7]_wb_vreg_data` | 64 | VFPU WB | VFPU 向量写回数据 |
| input | `x_wb_vld` | 3 | `ct_idu_rf_prf_vregfile/fregfile` | 三路写回选择有效 |
| output | `x_reg_dout` | 64 | `ct_idu_rf_prf_vregfile/fregfile` | 当前向量/浮点寄存器输出数据 |

### 8.3 `ct_idu_rf_prf_gated_ereg`

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `ereg_top_clk` | 1 | `ct_idu_rf_prf_eregfile` | gated ereg 单元时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式门控 |
| input | `vfpu_idu_ex5_pipe6_wb_ereg_data` | 6 | VFPU WB | pipe6 EREG 写回数据 |
| input | `vfpu_idu_ex5_pipe7_wb_ereg_data` | 6 | VFPU WB | pipe7 EREG 写回数据 |
| input | `x_retired_released_wb` | 1 | `ct_idu_rf_prf_eregfile` | retire/release 写回控制 |
| input | `x_wb_vld` | 2 | `ct_idu_rf_prf_eregfile` | pipe6/7 EREG 写回有效 |
| output | `x_acc_reg_dout` | 6 | `ct_idu_rf_prf_eregfile` | accrued exception 寄存器输出 |

## 9. 维护提示

- `ct_idu_rf_pipe6_decd`、`ct_idu_rf_pipe7_decd` 的 `vsew` 输入在端口上为 2 位，而 RF DP 对外给 IU 的 `vsew` 为 3 位；若后续补 RVV 1.0，需要统一检查 `vsew[2:0]`、`vlmul[2:0]`、`vta/vma/vill/vm` 等字段在 issue payload、RF decode、VFPU 接口中的传递。
- `ct_idu_rf_prf_fregfile` 与 `ct_idu_rf_prf_vregfile` 端口形态相近，但语义上分别服务 FR/VR 视图。修改 VRF 时需要同步检查前递网络中 `fr/vr0/vr1` 三种数据视图。
- RF 控制输出大量 `dup` 信号服务跨模块扇出和时序收敛，接口维护时应保持副本数量和下游连接一致。
