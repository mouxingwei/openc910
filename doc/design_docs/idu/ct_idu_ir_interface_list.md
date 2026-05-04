# ct_idu_ir 模块接口列表

## 1. 说明

本文档依据 `C910_RTL_FACTORY/gen_rtl/idu/rtl` 下 `ct_idu_ir_*.v` 端口声明整理。由于 IR 阶段大量接口按 4 路指令重复，本文使用范围化写法压缩列表：

- `inst[0:3]` 表示 `inst0`、`inst1`、`inst2`、`inst3` 四组同构信号。
- `src[0:2]` 表示 `src0`、`src1`、`src2` 三组源操作数。
- `create[0:1]` 表示 issue queue 双 create 端口。
- 对端模块按信号前缀、模块实例连接和 IDU 阶段关系推断；少量跨顶层信号标记为 `ct_idu_top/全局`。

表格字段：

| 字段 | 含义 |
| --- | --- |
| IO 类型 | `input` 或 `output` |
| 信号/信号组 | RTL 端口名或范围化端口名 |
| 位宽 | 单个端口位宽 |
| 对端模块 | 输入来源或输出去向 |
| 信号功能 | 接口语义说明 |

## 2. `ct_idu_ir_ctrl`

IR 控制模块负责 IR 有效位、stall/pipedown、预分派、物理寄存器分配有效、HPCP 计数输出等控制。

### 2.1 时钟、复位与全局控制

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | IR 控制寄存器主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | IDU 本地时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式时钟门控旁路 |
| input | `cp0_idu_dlb_disable` | 1 | CP0 | 禁止 DLB 相关分派优化 |
| input | `cp0_idu_rob_fold_disable` | 1 | CP0 | 禁止 ROB fold 优化 |
| input | `hpcp_idu_cnt_en` | 1 | HPCP | 性能计数使能 |

### 2.2 ID/IS/RTU 流水控制输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `ctrl_id_pipedown_gateclk` | 1 | ID 控制 | ID 到 IR 下传门控时钟请求 |
| input | `ctrl_id_pipedown_inst[0:3]_vld` | 1 | ID 控制 | ID 下传到 IR 的 4 路指令有效 |
| input | `ctrl_is_stall` | 1 | IS 控制 | IS 阶段全局 stall |
| input | `ctrl_is_dis_type_stall` | 1 | IS 控制 | IS 分派类型冲突 stall |
| input | `ctrl_is_inst2_vld` | 1 | IS 控制 | IS 阶段 inst2 有效，用于类型 stall 判断 |
| input | `ctrl_is_inst3_vld` | 1 | IS 控制 | IS 阶段 inst3 有效，用于类型 stall 判断 |
| input | `ctrl_xx_is_inst0_sel` | 2 | IS 控制 | IS 阶段 inst0 选择信息 |
| input | `ctrl_xx_is_inst_sel` | 3 | IS 控制 | IS 阶段指令选择编码 |
| input | `rtu_idu_flush_fe` | 1 | RTU | 前端 flush |
| input | `rtu_idu_flush_is` | 1 | RTU | IS/后端 flush |
| input | `rtu_idu_flush_stall` | 1 | RTU | flush 期间阻塞 IR 下传 |
| input | `rtu_yy_xx_flush` | 1 | RTU/全局 | 全局 flush |
| input | `rtu_idu_srt_en` | 1 | RTU | SRT/重命名表恢复使能 |
| input | `iu_idu_mispred_stall` | 1 | IU | 分支误预测导致的前端停顿 |
| input | `iu_yy_xx_cancel` | 1 | IU/全局 | IU cancel 信号 |

### 2.3 `ir_dp` 指令属性输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_ctrl_ir_inst[0:3]_bar` | 1 | `ct_idu_ir_dp` | 当前 IR 指令是否为 barrier/branch 类控制指令 |
| input | `dp_ctrl_ir_inst[0:3]_ctrl_info` | 13 | `ct_idu_ir_dp` | 指令控制信息字段，用于分派类型和资源判断 |
| input | `dp_ctrl_ir_inst[0:3]_dst_vld` | 1 | `ct_idu_ir_dp` | 整数目的寄存器有效 |
| input | `dp_ctrl_ir_inst[0:3]_dst_x0` | 1 | `ct_idu_ir_dp` | 目的寄存器是否为 x0 |
| input | `dp_ctrl_ir_inst[0:3]_dste_vld` | 1 | `ct_idu_ir_dp` | 扩展目的寄存器有效 |
| input | `dp_ctrl_ir_inst[0:3]_dstf_vld` | 1 | `ct_idu_ir_dp` | 浮点目的寄存器有效 |
| input | `dp_ctrl_ir_inst[0:3]_dstv_vld` | 1 | `ct_idu_ir_dp` | 向量目的寄存器有效 |
| input | `dp_ctrl_ir_inst[0:3]_hpcp_type` | 7 | `ct_idu_ir_dp` | 性能计数指令类型 |
| input | `dp_ctrl_is_dis_inst[2:3]_ctrl_info` | 13 | IS 数据通路 | IS 分派中的 inst2/inst3 控制信息，用于跨阶段类型冲突判断 |

### 2.4 RTU 分配资源反馈输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `rtu_idu_alloc_preg[0:3]_vld` | 1 | RTU | 整数物理寄存器分配可用/有效反馈 |
| input | `rtu_idu_alloc_freg[0:3]_vld` | 1 | RTU | 浮点物理寄存器分配可用/有效反馈 |
| input | `rtu_idu_alloc_ereg[0:3]_vld` | 1 | RTU | 扩展物理寄存器分配可用/有效反馈 |
| input | `rtu_idu_alloc_vreg[0:3]_vld` | 1 | RTU | 向量物理寄存器分配可用/有效反馈 |

### 2.5 Issue Queue 计数输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `aiq0_ctrl_entry_cnt_updt_val` | 4 | AIQ0 | AIQ0 entry 计数更新值 |
| input | `aiq0_ctrl_entry_cnt_updt_vld` | 1 | AIQ0 | AIQ0 entry 计数更新有效 |
| input | `aiq1_ctrl_entry_cnt_updt_val` | 4 | AIQ1 | AIQ1 entry 计数更新值 |
| input | `aiq1_ctrl_entry_cnt_updt_vld` | 1 | AIQ1 | AIQ1 entry 计数更新有效 |
| input | `viq0_ctrl_entry_cnt_updt_val` | 4 | VIQ0 | VIQ0 entry 计数更新值 |
| input | `viq0_ctrl_entry_cnt_updt_vld` | 1 | VIQ0 | VIQ0 entry 计数更新有效 |
| input | `viq1_ctrl_entry_cnt_updt_val` | 4 | VIQ1 | VIQ1 entry 计数更新值 |
| input | `viq1_ctrl_entry_cnt_updt_vld` | 1 | VIQ1 | VIQ1 entry 计数更新有效 |

### 2.6 IR 流水控制输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `ctrl_dp_ir_inst0_vld` | 1 | `ct_idu_ir_dp` | 通知 IR DP inst0 当前有效 |
| output | `ctrl_ir_pipedown` | 1 | ID/IS 控制 | IR 阶段整体向后下传 |
| output | `ctrl_ir_pipedown_gateclk` | 1 | `ct_idu_ir_dp`/后级 | IR 下传门控时钟使能 |
| output | `ctrl_ir_pipedown_inst[0:3]_vld` | 1 | 后级 ID/IS | IR 4 路指令下传有效 |
| output | `ctrl_ir_stage_stall` | 1 | IDU top/ID 控制 | IR 本级资源或类型导致 stall |
| output | `ctrl_ir_stall` | 1 | `ct_idu_ir_dp`/RT/FRT/VRT | IR 阶段综合 stall |
| output | `ctrl_ir_type_stall_inst[2:3]_vld` | 1 | IS 控制 | IR 中 inst2/inst3 因类型冲突参与 stall |
| output | `ctrl_fence_ir_pipe_empty` | 1 | Fence/LSIQ | IR pipe empty 状态，用于 fence 判断 |
| output | `ctrl_lsiq_ir_bar_inst_vld` | 1 | LSIQ | IR 存在 barrier 类指令 |

### 2.7 预分派 create 输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `ctrl_ir_pre_dis_inst[0:3]_vld` | 1 | IS 预分派 | IR 4 路预分派指令有效 |
| output | `ctrl_ir_pre_dis_aiq0_create[0:1]_en` | 1 | AIQ0 | AIQ0 create 使能 |
| output | `ctrl_ir_pre_dis_aiq0_create[0:1]_sel` | 2 | AIQ0 | AIQ0 create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_aiq1_create[0:1]_en` | 1 | AIQ1 | AIQ1 create 使能 |
| output | `ctrl_ir_pre_dis_aiq1_create[0:1]_sel` | 2 | AIQ1 | AIQ1 create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_biq_create[0:1]_en` | 1 | BIQ | BIQ create 使能 |
| output | `ctrl_ir_pre_dis_biq_create[0:1]_sel` | 2 | BIQ | BIQ create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_lsiq_create[0:1]_en` | 1 | LSIQ | LSIQ create 使能 |
| output | `ctrl_ir_pre_dis_lsiq_create[0:1]_sel` | 2 | LSIQ | LSIQ create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_sdiq_create[0:1]_en` | 1 | SDIQ | SDIQ create 使能 |
| output | `ctrl_ir_pre_dis_sdiq_create[0:1]_sel` | 2 | SDIQ | SDIQ create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_viq0_create[0:1]_en` | 1 | VIQ0 | VIQ0 create 使能 |
| output | `ctrl_ir_pre_dis_viq0_create[0:1]_sel` | 2 | VIQ0 | VIQ0 create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_viq1_create[0:1]_en` | 1 | VIQ1 | VIQ1 create 使能 |
| output | `ctrl_ir_pre_dis_viq1_create[0:1]_sel` | 2 | VIQ1 | VIQ1 create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_vmb_create[0:1]_en` | 1 | VMB | VMB create 使能 |
| output | `ctrl_ir_pre_dis_vmb_create[0:1]_sel` | 2 | VMB | VMB create 选择 IR 指令 |
| output | `ctrl_ir_pre_dis_pipedown2` | 1 | IS/预分派 | 预分派第二拍/第二级下传控制 |

### 2.8 ROB/PST/重命名控制输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `ctrl_ir_pre_dis_rob_create0_sel` | 2 | ROB | ROB create0 选择 |
| output | `ctrl_ir_pre_dis_rob_create1_en` | 1 | ROB | ROB create1 使能 |
| output | `ctrl_ir_pre_dis_rob_create1_sel` | 3 | ROB | ROB create1 选择 |
| output | `ctrl_ir_pre_dis_rob_create2_en` | 1 | ROB | ROB create2 使能 |
| output | `ctrl_ir_pre_dis_rob_create2_sel` | 2 | ROB | ROB create2 选择 |
| output | `ctrl_ir_pre_dis_rob_create3_en` | 1 | ROB | ROB create3 使能 |
| output | `ctrl_ir_pre_dis_pst_create1_iid_sel` | 1 | PST/RTU | PST create1 IID 选择 |
| output | `ctrl_ir_pre_dis_pst_create2_iid_sel` | 3 | PST/RTU | PST create2 IID 选择 |
| output | `ctrl_ir_pre_dis_pst_create3_iid_sel` | 3 | PST/RTU | PST create3 IID 选择 |
| output | `ctrl_rt_inst[0:3]_vld` | 1 | `ct_idu_ir_rt/frt/vrt` | 4 路重命名表查询/更新有效 |

### 2.9 对 RTU/HPCP/Top 输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `idu_rtu_ir_preg[0:3]_alloc_vld` | 1 | RTU | IR 申请整数物理寄存器有效 |
| output | `idu_rtu_ir_preg_alloc_gateclk_vld` | 1 | RTU | 整数物理寄存器分配门控时钟有效 |
| output | `idu_rtu_ir_freg[0:3]_alloc_vld` | 1 | RTU | IR 申请浮点物理寄存器有效 |
| output | `idu_rtu_ir_freg_alloc_gateclk_vld` | 1 | RTU | 浮点物理寄存器分配门控时钟有效 |
| output | `idu_rtu_ir_ereg[0:3]_alloc_vld` | 1 | RTU | IR 申请扩展物理寄存器有效 |
| output | `idu_rtu_ir_ereg_alloc_gateclk_vld` | 1 | RTU | 扩展物理寄存器分配门控时钟有效 |
| output | `idu_rtu_ir_vreg[0:3]_alloc_vld` | 1 | RTU | IR 申请向量物理寄存器有效 |
| output | `idu_rtu_ir_vreg_alloc_gateclk_vld` | 1 | RTU | 向量物理寄存器分配门控时钟有效 |
| output | `idu_hpcp_ir_inst[0:3]_vld` | 1 | HPCP | IR 4 路性能计数有效 |
| output | `idu_hpcp_ir_inst[0:3]_type` | 7 | HPCP | IR 4 路性能计数类型 |
| output | `ctrl_top_ir_inst[0:3]_vld` | 1 | IDU top | IR 4 路有效状态 |
| output | `ctrl_top_ir_preg_not_vld` | 1 | IDU top/RTU | 整数物理寄存器不可分配状态 |
| output | `ctrl_top_ir_freg_not_vld` | 1 | IDU top/RTU | 浮点物理寄存器不可分配状态 |
| output | `ctrl_top_ir_ereg_not_vld` | 1 | IDU top/RTU | 扩展物理寄存器不可分配状态 |
| output | `ctrl_top_ir_vreg_not_vld` | 1 | IDU top/RTU | 向量物理寄存器不可分配状态 |
| output | `ctrl_top_ir_mispred_stall` | 1 | IDU top | 误预测相关 stall 状态 |

## 3. `ct_idu_ir_dp`

IR 数据通路模块保存 ID 下传指令数据，实例化 4 个 `ct_idu_ir_decd`，并与 RT/FRT/VRT 交换重命名查询结果。

### 3.1 时钟与控制输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | IR DP 主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式时钟门控旁路 |
| input | `ctrl_id_pipedown_gateclk` | 1 | ID 控制 | ID 下传门控时钟 |
| input | `ctrl_ir_stall` | 1 | `ct_idu_ir_ctrl` | IR stall，控制数据保持 |
| input | `ctrl_dp_ir_inst0_vld` | 1 | `ct_idu_ir_ctrl` | IR inst0 有效，用于 DP 局部控制 |

### 3.2 ID 阶段输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_id_pipedown_inst[0:3]_data` | 178 | ID DP | ID 下传的 4 路指令数据包 |
| input | `dp_id_pipedown_dep_info` | 17 | ID DP | ID 下传依赖信息 |

### 3.3 RT/FRT/VRT 重命名结果输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `rt_dp_inst[0:3]_src0_data` | 9 | `ct_idu_ir_rt` | 整数源 0 物理寄存器/ready 信息 |
| input | `rt_dp_inst[0:3]_src1_data` | 9 | `ct_idu_ir_rt` | 整数源 1 物理寄存器/ready 信息 |
| input | `rt_dp_inst[0:3]_src2_data` | 10 | `ct_idu_ir_rt` | 整数源 2 物理寄存器/ready 信息 |
| input | `rt_dp_inst[0:3]_rel_preg` | 7 | `ct_idu_ir_rt` | 整数旧物理寄存器释放号 |
| input | `rt_dp_inst01/02/03/12/13/23_src_match` | 3 | `ct_idu_ir_rt` | 同拍整数源相关性命中 |
| input | `frt_dp_inst[0:3]_srcf0_data` | 9 | `ct_idu_ir_frt` | 浮点源 0 物理寄存器/ready 信息 |
| input | `frt_dp_inst[0:3]_srcf1_data` | 9 | `ct_idu_ir_frt` | 浮点源 1 物理寄存器/ready 信息 |
| input | `frt_dp_inst[0:3]_srcf2_data` | 10 | `ct_idu_ir_frt` | 浮点源 2 物理寄存器/ready 信息 |
| input | `frt_dp_inst[0:3]_rel_freg` | 7 | `ct_idu_ir_frt` | 浮点旧物理寄存器释放号 |
| input | `frt_dp_inst[0:3]_rel_ereg` | 5 | `ct_idu_ir_frt` | 扩展旧物理寄存器释放号 |
| input | `frt_dp_inst01/02/03/12/13/23_srcf2_match` | 1 | `ct_idu_ir_frt` | 同拍浮点第三源相关性命中 |
| input | `vrt_dp_inst[0:3]_srcv0_data` | 9 | `ct_idu_ir_vrt` | 向量源 0 物理寄存器/ready 信息 |
| input | `vrt_dp_inst[0:3]_srcv1_data` | 9 | `ct_idu_ir_vrt` | 向量源 1 物理寄存器/ready 信息 |
| input | `vrt_dp_inst[0:3]_srcv2_data` | 10 | `ct_idu_ir_vrt` | 向量源 2 物理寄存器/ready 信息 |
| input | `vrt_dp_inst[0:3]_srcvm_data` | 9 | `ct_idu_ir_vrt` | 向量 mask 源物理寄存器/ready 信息 |
| input | `vrt_dp_inst[0:3]_rel_vreg` | 7 | `ct_idu_ir_vrt` | 向量旧物理寄存器释放号 |
| input | `vrt_dp_inst01/02/03/12/13/23_srcv2_match` | 1 | `ct_idu_ir_vrt` | 同拍向量第三源相关性命中 |

### 3.4 RTU 分配编号输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `rtu_idu_alloc_preg[0:3]` | 7 | RTU | RTU 分配给 4 路指令的整数物理寄存器号 |
| input | `rtu_idu_alloc_freg[0:3]` | 7 | RTU | RTU 分配给 4 路指令的浮点物理寄存器号 |
| input | `rtu_idu_alloc_ereg[0:3]` | 5 | RTU | RTU 分配给 4 路指令的扩展物理寄存器号 |
| input | `rtu_idu_alloc_vreg[0:3]` | 6 | RTU | RTU 分配给 4 路指令的向量物理寄存器号 |

### 3.5 给 IR 控制的输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `dp_ctrl_ir_inst[0:3]_dst_vld` | 1 | `ct_idu_ir_ctrl` | 整数目的有效 |
| output | `dp_ctrl_ir_inst[0:3]_dst_x0` | 1 | `ct_idu_ir_ctrl` | 目的为 x0 |
| output | `dp_ctrl_ir_inst[0:3]_dste_vld` | 1 | `ct_idu_ir_ctrl` | 扩展目的有效 |
| output | `dp_ctrl_ir_inst[0:3]_dstf_vld` | 1 | `ct_idu_ir_ctrl` | 浮点目的有效 |
| output | `dp_ctrl_ir_inst[0:3]_dstv_vld` | 1 | `ct_idu_ir_ctrl` | 向量目的有效 |
| output | `dp_ctrl_ir_inst[0:3]_bar` | 1 | `ct_idu_ir_ctrl` | barrier/control 类指令标志 |
| output | `dp_ctrl_ir_inst[0:3]_ctrl_info` | 13 | `ct_idu_ir_ctrl` | IR 指令控制信息 |
| output | `dp_ctrl_ir_inst[0:3]_hpcp_type` | 7 | `ct_idu_ir_ctrl` | 性能计数类型 |

### 3.6 给 RT/FRT/VRT 的输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `dp_rt_dep_info` | 17 | `ct_idu_ir_rt` | 整数依赖信息 |
| output | `dp_rt_inst[0:3]_dst_preg` | 7 | `ct_idu_ir_rt` | 新分配整数物理目的号 |
| output | `dp_rt_inst[0:3]_dst_reg` | 6 | `ct_idu_ir_rt` | 整数逻辑目的寄存器号 |
| output | `dp_rt_inst[0:3]_dst_vld` | 1 | `ct_idu_ir_rt` | 整数目的有效 |
| output | `dp_rt_inst[0:3]_src0_reg` | 6 | `ct_idu_ir_rt` | 整数源 0 逻辑寄存器号 |
| output | `dp_rt_inst[0:3]_src0_vld` | 1 | `ct_idu_ir_rt` | 整数源 0 有效 |
| output | `dp_rt_inst[0:3]_src1_reg` | 6 | `ct_idu_ir_rt` | 整数源 1 逻辑寄存器号 |
| output | `dp_rt_inst[0:3]_src1_vld` | 1 | `ct_idu_ir_rt` | 整数源 1 有效 |
| output | `dp_rt_inst[0:3]_src2_vld` | 1 | `ct_idu_ir_rt` | 整数源 2 有效 |
| output | `dp_rt_inst[0:3]_mla` | 1 | `ct_idu_ir_rt` | 整数 MLA/多源类指令标志 |
| output | `dp_rt_inst[0:3]_mov` | 1 | `ct_idu_ir_rt` | 整数 move 类指令标志 |
| output | `dp_frt_inst[0:3]_dst_freg` | 7 | `ct_idu_ir_frt` | 新分配浮点物理目的号 |
| output | `dp_frt_inst[0:3]_dst_ereg` | 5 | `ct_idu_ir_frt` | 新分配扩展物理目的号 |
| output | `dp_frt_inst[0:3]_dstf_reg` | 6 | `ct_idu_ir_frt` | 浮点逻辑目的寄存器号 |
| output | `dp_frt_inst[0:3]_dstf_vld` | 1 | `ct_idu_ir_frt` | 浮点目的有效 |
| output | `dp_frt_inst[0:3]_dste_vld` | 1 | `ct_idu_ir_frt` | 扩展目的有效 |
| output | `dp_frt_inst[0:3]_srcf[0:2]_reg` | 6 | `ct_idu_ir_frt` | 浮点源逻辑寄存器号 |
| output | `dp_frt_inst[0:3]_srcf[0:2]_vld` | 1 | `ct_idu_ir_frt` | 浮点源有效 |
| output | `dp_frt_inst[0:3]_vmla` | 1 | `ct_idu_ir_frt` | 浮点/向量乘加相关标志 |
| output | `dp_vrt_inst[0:3]_dst_vreg` | 6 | `ct_idu_ir_vrt` | 新分配向量物理目的号 |
| output | `dp_vrt_inst[0:3]_dstv_reg` | 6 | `ct_idu_ir_vrt` | 向量逻辑目的寄存器号 |
| output | `dp_vrt_inst[0:3]_dstv_vld` | 1 | `ct_idu_ir_vrt` | 向量目的有效 |
| output | `dp_vrt_inst[0:3]_srcv0_reg` | 6 | `ct_idu_ir_vrt` | 向量源 0 逻辑寄存器号 |
| output | `dp_vrt_inst[0:3]_srcv0_vld` | 1 | `ct_idu_ir_vrt` | 向量源 0 有效 |
| output | `dp_vrt_inst[0:3]_srcv1_reg` | 6 | `ct_idu_ir_vrt` | 向量源 1 逻辑寄存器号 |
| output | `dp_vrt_inst[0:3]_srcv1_vld` | 1 | `ct_idu_ir_vrt` | 向量源 1 有效 |
| output | `dp_vrt_inst[0:3]_srcv2_vld` | 1 | `ct_idu_ir_vrt` | 向量源 2 有效 |
| output | `dp_vrt_inst[0:3]_srcvm_vld` | 1 | `ct_idu_ir_vrt` | 向量 mask 源有效 |
| output | `dp_vrt_inst[0:3]_vmla` | 1 | `ct_idu_ir_vrt` | 向量乘加相关标志 |

### 3.7 后级/RTU 输出

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `dp_ir_pipedown_inst[0:3]_data` | 178 | 后级 ID/IS DP | IR 下传的 4 路指令数据包 |
| output | `dp_ir_pipedown_dep_info` | 17 | 后级 ID/IS DP | IR 下传依赖信息 |
| output | `idu_rtu_ir_inst[0:3]_data` | 多字段 | RTU | IR 指令重命名/释放/ROB 相关信息，RTL 中由分散字段拼接形成 |

## 4. `ct_idu_ir_decd`

单条指令轻量解码器，由 `ct_idu_ir_dp` 每路实例化一次。

### 4.1 输入接口

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `x_illegal` | 1 | `ct_idu_ir_dp` | 当前指令非法标志，用于屏蔽普通解码输出 |
| input | `x_opcode` | 32 | `ct_idu_ir_dp` | 当前指令 opcode |
| input | `x_type_alu` | 1 | `ct_idu_ir_dp` | 前级/数据包中的 ALU 类型标志 |
| input | `x_type_staddr` | 1 | `ct_idu_ir_dp` | store address 类型标志 |
| input | `x_type_vload` | 1 | `ct_idu_ir_dp` | vector load 类型标志 |
| input | `x_vsew` | 3 | `ct_idu_ir_dp` | 向量元素宽度编码 |

### 4.2 输出接口

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `x_alu_short` | 1 | `ct_idu_ir_dp` | 短 ALU 指令标志 |
| output | `x_bar` | 1 | `ct_idu_ir_dp` | barrier/branch 类标志 |
| output | `x_bar_type` | 4 | `ct_idu_ir_dp` | barrier/branch 子类型 |
| output | `x_csr` | 1 | `ct_idu_ir_dp` | CSR 指令标志 |
| output | `x_ecall` | 1 | `ct_idu_ir_dp` | ecall 指令标志 |
| output | `x_fp` | 1 | `ct_idu_ir_dp` | 浮点指令标志 |
| output | `x_load` | 1 | `ct_idu_ir_dp` | load 指令标志 |
| output | `x_store` | 1 | `ct_idu_ir_dp` | store 指令标志 |
| output | `x_mfvr` | 1 | `ct_idu_ir_dp` | vector/fp 到整数寄存器搬移类标志 |
| output | `x_mtvr` | 1 | `ct_idu_ir_dp` | 整数到 vector/fp 寄存器搬移类标志 |
| output | `x_pcall` | 1 | `ct_idu_ir_dp` | procedure call 标志 |
| output | `x_pcfifo` | 1 | `ct_idu_ir_dp` | PC FIFO 相关指令标志 |
| output | `x_rts` | 1 | `ct_idu_ir_dp` | return/RTS 标志 |
| output | `x_str` | 1 | `ct_idu_ir_dp` | string/特殊类指令标志 |
| output | `x_sync` | 1 | `ct_idu_ir_dp` | sync/fence 类标志 |
| output | `x_unit_stride` | 1 | `ct_idu_ir_dp` | 向量 unit-stride load/store 标志 |
| output | `x_vamo` | 1 | `ct_idu_ir_dp` | vector AMO/VMB 相关标志 |
| output | `x_vdiv` | 1 | `ct_idu_ir_dp` | 向量/浮点除法或开方类标志 |
| output | `x_vec` | 1 | `ct_idu_ir_dp` | 向量指令总标志 |
| output | `x_viq_srcv12_switch` | 1 | `ct_idu_ir_dp` | VIQ 源操作数 1/2 交换控制 |
| output | `x_vmla_short` | 1 | `ct_idu_ir_dp` | 短向量乘加/归约/置换类标志 |
| output | `x_vmla_type` | 3 | `ct_idu_ir_dp` | 向量乘加类型编码 |
| output | `x_vmul` | 1 | `ct_idu_ir_dp` | 向量乘法类标志 |
| output | `x_vmul_unsplit` | 1 | `ct_idu_ir_dp` | 向量乘法不可拆分/互锁提示 |
| output | `x_vsetvl` | 1 | `ct_idu_ir_dp` | `vsetvl` 配置指令标志 |
| output | `x_vsetvli` | 1 | `ct_idu_ir_dp` | `vsetvli` 配置指令标志 |

## 5. `ct_idu_ir_rt`

整数寄存器重命名/依赖表，接收 IR DP 的 4 路整数逻辑寄存器信息，输出物理寄存器映射、ready 和同拍相关性。

### 5.1 控制与恢复输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | RT 表主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式时钟门控旁路 |
| input | `ifu_xx_sync_reset` | 1 | IFU/全局 | 同步 reset 请求 |
| input | `ctrl_ir_stall` | 1 | `ct_idu_ir_ctrl` | IR stall，控制表项更新 |
| input | `ctrl_rt_inst[0:3]_vld` | 1 | `ct_idu_ir_ctrl` | 4 路 RT 查询/更新有效 |
| input | `rtu_idu_flush_fe` | 1 | RTU | 前端 flush |
| input | `rtu_idu_flush_is` | 1 | RTU | IS/后端 flush |
| input | `rtu_yy_xx_flush` | 1 | RTU | 全局 flush |
| input | `rtu_idu_rt_recover_preg` | 224 | RTU | 整数 rename table 恢复映像 |

### 5.2 IR DP 输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_rt_dep_info` | 17 | `ct_idu_ir_dp` | 整数依赖信息 |
| input | `dp_rt_inst[0:3]_dst_preg` | 7 | `ct_idu_ir_dp` | 新分配整数物理目的号 |
| input | `dp_rt_inst[0:3]_dst_reg` | 6 | `ct_idu_ir_dp` | 整数逻辑目的寄存器号 |
| input | `dp_rt_inst[0:3]_dst_vld` | 1 | `ct_idu_ir_dp` | 整数目的有效 |
| input | `dp_rt_inst[0:3]_src0_reg` | 6 | `ct_idu_ir_dp` | 整数源 0 逻辑寄存器号 |
| input | `dp_rt_inst[0:3]_src0_vld` | 1 | `ct_idu_ir_dp` | 整数源 0 有效 |
| input | `dp_rt_inst[0:3]_src1_reg` | 6 | `ct_idu_ir_dp` | 整数源 1 逻辑寄存器号 |
| input | `dp_rt_inst[0:3]_src1_vld` | 1 | `ct_idu_ir_dp` | 整数源 1 有效 |
| input | `dp_rt_inst[0:3]_src2_vld` | 1 | `ct_idu_ir_dp` | 整数源 2 有效 |
| input | `dp_rt_inst[0:3]_mla` | 1 | `ct_idu_ir_dp` | MLA/三源类指令标志 |
| input | `dp_rt_inst[0:3]_mov` | 1 | `ct_idu_ir_dp` | move 类指令标志；inst3 无 `mov` 输入 |

### 5.3 执行/RF ready 更新输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `ctrl_xx_rf_pipe0_preg_lch_vld_dupx` | 1 | RF 控制 | pipe0 整数源 latch ready 有效 |
| input | `ctrl_xx_rf_pipe1_preg_lch_vld_dupx` | 1 | RF 控制 | pipe1 整数源 latch ready 有效 |
| input | `dp_xx_rf_pipe0_dst_preg_dupx` | 7 | RF DP | pipe0 目的整数物理寄存器 |
| input | `dp_xx_rf_pipe1_dst_preg_dupx` | 7 | RF DP | pipe1 目的整数物理寄存器 |
| input | `iu_idu_div_inst_vld` | 1 | IU | DIV 指令有效，用于 ready 更新 |
| input | `iu_idu_div_preg_dupx` | 7 | IU | DIV 目的物理寄存器 |
| input | `iu_idu_ex2_pipe0_wb_preg_vld_dupx` | 1 | IU | pipe0 EX2/WB 整数写回有效 |
| input | `iu_idu_ex2_pipe0_wb_preg_dupx` | 7 | IU | pipe0 EX2/WB 写回物理寄存器号 |
| input | `iu_idu_ex2_pipe1_wb_preg_vld_dupx` | 1 | IU | pipe1 EX2/WB 整数写回有效 |
| input | `iu_idu_ex2_pipe1_wb_preg_dupx` | 7 | IU | pipe1 EX2/WB 写回物理寄存器号 |
| input | `iu_idu_ex2_pipe1_mult_inst_vld_dupx` | 1 | IU | pipe1 乘法指令有效 |
| input | `iu_idu_ex2_pipe1_preg_dupx` | 7 | IU | pipe1 乘法目的物理寄存器 |
| input | `lsu_idu_ag_pipe3_load_inst_vld` | 1 | LSU | LSU AG load 指令有效 |
| input | `lsu_idu_ag_pipe3_preg_dupx` | 7 | LSU | LSU AG 目的整数物理寄存器 |
| input | `lsu_idu_dc_pipe3_load_inst_vld_dupx` | 1 | LSU | LSU DC load 指令有效 |
| input | `lsu_idu_dc_pipe3_preg_dupx` | 7 | LSU | LSU DC 目的整数物理寄存器 |
| input | `lsu_idu_wb_pipe3_wb_preg_vld_dupx` | 1 | LSU | LSU WB 整数写回有效 |
| input | `lsu_idu_wb_pipe3_wb_preg_dupx` | 7 | LSU | LSU WB 整数写回物理寄存器号 |
| input | `vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx` | 1 | VFPU | pipe6 mfvr 写整数目的有效 |
| input | `vfpu_idu_ex1_pipe6_preg_dupx` | 7 | VFPU | pipe6 mfvr 整数目的物理寄存器 |
| input | `vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx` | 1 | VFPU | pipe7 mfvr 写整数目的有效 |
| input | `vfpu_idu_ex1_pipe7_preg_dupx` | 7 | VFPU | pipe7 mfvr 整数目的物理寄存器 |

### 5.4 输出到 IR DP

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `rt_dp_inst[0:3]_rel_preg` | 7 | `ct_idu_ir_dp` | 每路指令旧整数物理寄存器号 |
| output | `rt_dp_inst[0:3]_src0_data` | 9 | `ct_idu_ir_dp` | 源 0 物理号和 ready 信息 |
| output | `rt_dp_inst[0:3]_src1_data` | 9 | `ct_idu_ir_dp` | 源 1 物理号和 ready 信息 |
| output | `rt_dp_inst[0:3]_src2_data` | 10 | `ct_idu_ir_dp` | 源 2 物理号和 ready 信息 |
| output | `rt_dp_inst01_src_match` | 3 | `ct_idu_ir_dp` | inst1 源与 inst0 目的同拍命中 |
| output | `rt_dp_inst02_src_match` | 3 | `ct_idu_ir_dp` | inst2 源与 inst0 目的同拍命中 |
| output | `rt_dp_inst03_src_match` | 3 | `ct_idu_ir_dp` | inst3 源与 inst0 目的同拍命中 |
| output | `rt_dp_inst12_src_match` | 3 | `ct_idu_ir_dp` | inst2 源与 inst1 目的同拍命中 |
| output | `rt_dp_inst13_src_match` | 3 | `ct_idu_ir_dp` | inst3 源与 inst1 目的同拍命中 |
| output | `rt_dp_inst23_src_match` | 3 | `ct_idu_ir_dp` | inst3 源与 inst2 目的同拍命中 |

## 6. `ct_idu_ir_frt`

浮点/扩展寄存器重命名与依赖表，结构与 `ct_idu_ir_rt` 类似，但面向 freg/ereg 和 VFPU/LSU 向量浮点相关写回。

### 6.1 控制与恢复输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `forever_cpuclk` | 1 | 全局时钟 | FRT 表主时钟 |
| input | `cpurst_b` | 1 | 全局复位 | 低有效复位 |
| input | `cp0_idu_icg_en` | 1 | CP0 | 时钟门控使能 |
| input | `cp0_yy_clk_en` | 1 | CP0/全局 | 全局时钟使能 |
| input | `pad_yy_icg_scan_en` | 1 | PAD/DFT | 扫描模式时钟门控旁路 |
| input | `ifu_xx_sync_reset` | 1 | IFU/全局 | 同步 reset 请求 |
| input | `ctrl_ir_stall` | 1 | `ct_idu_ir_ctrl` | IR stall |
| input | `ctrl_rt_inst[0:3]_vld` | 1 | `ct_idu_ir_ctrl` | 4 路 FRT 查询/更新有效 |
| input | `rtu_idu_flush_fe` | 1 | RTU | 前端 flush |
| input | `rtu_idu_flush_is` | 1 | RTU | IS/后端 flush |
| input | `rtu_yy_xx_flush` | 1 | RTU | 全局 flush |
| input | `rtu_idu_rt_recover_freg` | 224 | RTU | 浮点 rename table 恢复映像 |

### 6.2 IR DP 输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_frt_inst[0:3]_dst_freg` | 7 | `ct_idu_ir_dp` | 新分配浮点物理目的号 |
| input | `dp_frt_inst[0:3]_dst_ereg` | 5 | `ct_idu_ir_dp` | 新分配扩展物理目的号 |
| input | `dp_frt_inst[0:3]_dstf_reg` | 6 | `ct_idu_ir_dp` | 浮点逻辑目的寄存器号 |
| input | `dp_frt_inst[0:3]_dstf_vld` | 1 | `ct_idu_ir_dp` | 浮点目的有效 |
| input | `dp_frt_inst[0:3]_dste_vld` | 1 | `ct_idu_ir_dp` | 扩展目的有效 |
| input | `dp_frt_inst[0:3]_srcf0_reg` | 6 | `ct_idu_ir_dp` | 浮点源 0 逻辑寄存器号 |
| input | `dp_frt_inst[0:3]_srcf0_vld` | 1 | `ct_idu_ir_dp` | 浮点源 0 有效 |
| input | `dp_frt_inst[0:3]_srcf1_reg` | 6 | `ct_idu_ir_dp` | 浮点源 1 逻辑寄存器号 |
| input | `dp_frt_inst[0:3]_srcf1_vld` | 1 | `ct_idu_ir_dp` | 浮点源 1 有效 |
| input | `dp_frt_inst[0:3]_srcf2_vld` | 1 | `ct_idu_ir_dp` | 浮点源 2 有效 |
| input | `dp_frt_inst[0:3]_vmla` | 1 | `ct_idu_ir_dp` | 浮点/向量乘加类标志 |

### 6.3 执行/RF ready 更新输入

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `ctrl_xx_rf_pipe6_vmla_lch_vld_dupx` | 1 | RF 控制 | pipe6 VMLA latch ready 更新 |
| input | `ctrl_xx_rf_pipe7_vmla_lch_vld_dupx` | 1 | RF 控制 | pipe7 VMLA latch ready 更新 |
| input | `dp_xx_rf_pipe6_dst_vreg_dupx` | 7 | RF DP | pipe6 目的向量/浮点物理号 |
| input | `dp_xx_rf_pipe7_dst_vreg_dupx` | 7 | RF DP | pipe7 目的向量/浮点物理号 |
| input | `lsu_idu_dc_pipe3_load_inst_vld_dupx` | 1 | LSU | LSU DC load 有效 |
| input | `lsu_idu_dc_pipe3_vreg_dupx` | 7 | LSU | LSU DC 目的向量/浮点物理号 |
| input | `lsu_idu_wb_pipe3_wb_freg_vld_dupx` | 1 | LSU | LSU WB 浮点写回有效 |
| input | `lsu_idu_wb_pipe3_wb_freg_dupx` | 7 | LSU | LSU WB 浮点写回物理号 |
| input | `vfpu_idu_ex1_pipe6_mfvr_inst_vld_dupx` | 1 | VFPU | pipe6 mfvr 读浮点/向量源有效 |
| input | `vfpu_idu_ex1_pipe6_vreg_dupx` | 7 | VFPU | pipe6 相关向量/浮点物理号 |
| input | `vfpu_idu_ex1_pipe7_mfvr_inst_vld_dupx` | 1 | VFPU | pipe7 mfvr 读浮点/向量源有效 |
| input | `vfpu_idu_ex1_pipe7_vreg_dupx` | 7 | VFPU | pipe7 相关向量/浮点物理号 |
| input | `vfpu_idu_ex5_pipe6_wb_vreg_vld_dupx` | 1 | VFPU | pipe6 EX5 向量/浮点写回有效 |
| input | `vfpu_idu_ex5_pipe6_wb_vreg_dupx` | 7 | VFPU | pipe6 EX5 写回物理号 |
| input | `vfpu_idu_ex5_pipe7_wb_vreg_vld_dupx` | 1 | VFPU | pipe7 EX5 向量/浮点写回有效 |
| input | `vfpu_idu_ex5_pipe7_wb_vreg_dupx` | 7 | VFPU | pipe7 EX5 写回物理号 |

### 6.4 输出到 IR DP

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `frt_dp_inst[0:3]_rel_freg` | 7 | `ct_idu_ir_dp` | 每路指令旧浮点物理寄存器号 |
| output | `frt_dp_inst[0:3]_rel_ereg` | 5 | `ct_idu_ir_dp` | 每路指令旧扩展物理寄存器号 |
| output | `frt_dp_inst[0:3]_srcf0_data` | 9 | `ct_idu_ir_dp` | 浮点源 0 物理号和 ready |
| output | `frt_dp_inst[0:3]_srcf1_data` | 9 | `ct_idu_ir_dp` | 浮点源 1 物理号和 ready |
| output | `frt_dp_inst[0:3]_srcf2_data` | 10 | `ct_idu_ir_dp` | 浮点源 2 物理号和 ready |
| output | `frt_dp_inst01_srcf2_match` | 1 | `ct_idu_ir_dp` | inst1 srcf2 与 inst0 目的同拍命中 |
| output | `frt_dp_inst02_srcf2_match` | 1 | `ct_idu_ir_dp` | inst2 srcf2 与 inst0 目的同拍命中 |
| output | `frt_dp_inst03_srcf2_match` | 1 | `ct_idu_ir_dp` | inst3 srcf2 与 inst0 目的同拍命中 |
| output | `frt_dp_inst12_srcf2_match` | 1 | `ct_idu_ir_dp` | inst2 srcf2 与 inst1 目的同拍命中 |
| output | `frt_dp_inst13_srcf2_match` | 1 | `ct_idu_ir_dp` | inst3 srcf2 与 inst1 目的同拍命中 |
| output | `frt_dp_inst23_srcf2_match` | 1 | `ct_idu_ir_dp` | inst3 srcf2 与 inst2 目的同拍命中 |

## 7. `ct_idu_ir_vrt`

向量寄存器重命名接口模块。当前 RTL 中输出多为固定值，但端口已预留完整 VRT 查询/释放接口。

### 7.1 输入接口

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| input | `dp_vrt_inst[0:3]_dst_vreg` | 6 | `ct_idu_ir_dp` | 新分配向量物理目的号 |
| input | `dp_vrt_inst[0:3]_dstv_reg` | 6 | `ct_idu_ir_dp` | 向量逻辑目的寄存器号 |
| input | `dp_vrt_inst[0:3]_dstv_vld` | 1 | `ct_idu_ir_dp` | 向量目的有效 |
| input | `dp_vrt_inst[0:3]_srcv0_reg` | 6 | `ct_idu_ir_dp` | 向量源 0 逻辑寄存器号 |
| input | `dp_vrt_inst[0:3]_srcv0_vld` | 1 | `ct_idu_ir_dp` | 向量源 0 有效 |
| input | `dp_vrt_inst[0:3]_srcv1_reg` | 6 | `ct_idu_ir_dp` | 向量源 1 逻辑寄存器号 |
| input | `dp_vrt_inst[0:3]_srcv1_vld` | 1 | `ct_idu_ir_dp` | 向量源 1 有效 |
| input | `dp_vrt_inst[0:3]_srcv2_vld` | 1 | `ct_idu_ir_dp` | 向量源 2 有效 |
| input | `dp_vrt_inst[0:3]_srcvm_vld` | 1 | `ct_idu_ir_dp` | 向量 mask 源有效 |
| input | `dp_vrt_inst[0:3]_vmla` | 1 | `ct_idu_ir_dp` | 向量乘加/第三源相关标志 |
| input | `rtu_idu_rt_recover_vreg` | 192 | RTU | 向量 rename table 恢复映像 |

### 7.2 输出接口

| IO 类型 | 信号/信号组 | 位宽 | 对端模块 | 信号功能 |
| --- | --- | --- | --- | --- |
| output | `vrt_dp_inst[0:3]_rel_vreg` | 7 | `ct_idu_ir_dp` | 每路指令旧向量物理寄存器号 |
| output | `vrt_dp_inst[0:3]_srcv0_data` | 9 | `ct_idu_ir_dp` | 向量源 0 物理号和 ready |
| output | `vrt_dp_inst[0:3]_srcv1_data` | 9 | `ct_idu_ir_dp` | 向量源 1 物理号和 ready |
| output | `vrt_dp_inst[0:3]_srcv2_data` | 10 | `ct_idu_ir_dp` | 向量源 2 物理号和 ready |
| output | `vrt_dp_inst[0:3]_srcvm_data` | 9 | `ct_idu_ir_dp` | 向量 mask 源物理号和 ready |
| output | `vrt_dp_inst01_srcv2_match` | 1 | `ct_idu_ir_dp` | inst1 srcv2 与 inst0 目的同拍命中 |
| output | `vrt_dp_inst02_srcv2_match` | 1 | `ct_idu_ir_dp` | inst2 srcv2 与 inst0 目的同拍命中 |
| output | `vrt_dp_inst03_srcv2_match` | 1 | `ct_idu_ir_dp` | inst3 srcv2 与 inst0 目的同拍命中 |
| output | `vrt_dp_inst12_srcv2_match` | 1 | `ct_idu_ir_dp` | inst2 srcv2 与 inst1 目的同拍命中 |
| output | `vrt_dp_inst13_srcv2_match` | 1 | `ct_idu_ir_dp` | inst3 srcv2 与 inst1 目的同拍命中 |
| output | `vrt_dp_inst23_srcv2_match` | 1 | `ct_idu_ir_dp` | inst3 srcv2 与 inst2 目的同拍命中 |

## 8. 接口维护建议

1. 若后续补 RVV 1.0，需要在本接口清单中拆出 `vsetivli`、`vta/vma/vill/vlmul[2:0]`、load/store `mew/mop/lumop/sumop/nf/vm` 等新增或扩展字段。
2. `ct_idu_ir_vrt` 当前接口完整但实现占位，若实现真实 VRT，应补充 VRT 表项与 RTU recover/commit/free 方向的接口。
3. 对 `ct_idu_ir_dp` 的 `idu_rtu_ir_*` 组合输出，建议后续结合 `ct_idu_top.v` 连接关系再生成 RTU 视角的逐字段接口表。

