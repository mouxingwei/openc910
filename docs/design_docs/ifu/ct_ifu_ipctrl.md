# ct_ifu_ipctrl 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipctrl |
| 文件名称 | ct_ifu_ipctrl.v |
| 功能描述 | IP阶段控制模块 |

### 1.2 功能描述

IP阶段控制模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_bht_en | input | 1 | - |
| cp0_ifu_no_op_req | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_ifu_ir_vld | input | 1 | - |
| ibctrl_ipctrl_low_power_stall | input | 1 | - |
| ibctrl_ipctrl_stall | input | 1 | - |
| ifctrl_ipctrl_if_pcload | input | 1 | - |
| ifctrl_ipctrl_vld | input | 1 | - |
| ifdp_ipctrl_expt_vld | input | 1 | - |
| ifdp_ipctrl_expt_vld_dup | input | 1 | - |
| ifdp_ipctrl_fifo | input | 1 | - |
| ifdp_ipctrl_pa | input | 28 | - |
| ifdp_ipctrl_refill_on | input | 1 | - |
| ifdp_ipctrl_tsize | input | 1 | - |
| ifdp_ipctrl_vpc_2_0_onehot | input | 8 | - |
| ifdp_ipctrl_vpc_bry_mask | input | 8 | - |
| ifdp_ipctrl_w0_bry0_hit | input | 1 | - |
| ifdp_ipctrl_w0_bry1_hit | input | 1 | - |
| ifdp_ipctrl_w0b0_br_ntake | input | 8 | - |
| ifdp_ipctrl_w0b0_br_taken | input | 8 | - |
| ifdp_ipctrl_w0b0_bry_data | input | 8 | - |
| ifdp_ipctrl_w0b1_br_ntake | input | 8 | - |
| ifdp_ipctrl_w0b1_br_taken | input | 8 | - |
| ifdp_ipctrl_w0b1_bry_data | input | 8 | - |
| ifdp_ipctrl_w1_bry0_hit | input | 1 | - |
| ifdp_ipctrl_w1_bry1_hit | input | 1 | - |
| ifdp_ipctrl_w1b0_br_ntake | input | 8 | - |
| ifdp_ipctrl_w1b0_br_taken | input | 8 | - |
| ifdp_ipctrl_w1b0_bry_data | input | 8 | - |
| ifdp_ipctrl_w1b1_br_ntake | input | 8 | - |
| ifdp_ipctrl_w1b1_br_taken | input | 8 | - |
| ifdp_ipctrl_w1b1_bry_data | input | 8 | - |
| ifdp_ipctrl_way0_15_8_hit | input | 1 | - |
| ifdp_ipctrl_way0_15_8_hit_dup | input | 1 | - |
| ifdp_ipctrl_way0_23_16_hit | input | 1 | - |
| ifdp_ipctrl_way0_23_16_hit_dup | input | 1 | - |
| ifdp_ipctrl_way0_28_24_hit | input | 1 | - |
| ifdp_ipctrl_way0_28_24_hit_dup | input | 1 | - |
| ifdp_ipctrl_way0_7_0_hit | input | 1 | - |
| ifdp_ipctrl_way0_7_0_hit_dup | input | 1 | - |
| ifdp_ipctrl_way1_15_8_hit | input | 1 | - |
| ifdp_ipctrl_way1_23_16_hit | input | 1 | - |
| ifdp_ipctrl_way1_28_24_hit | input | 1 | - |
| ifdp_ipctrl_way1_7_0_hit | input | 1 | - |
| ifdp_ipctrl_way_pred | input | 2 | - |
| ipdp_ipctrl_bht_data | input | 2 | - |
| ipdp_ipctrl_bht_result | input | 1 | - |
| ipdp_ipctrl_btb_way0_pred | input | 2 | - |
| ipdp_ipctrl_btb_way0_target | input | 20 | - |

*注：共83个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ipctrl_bht_con_br_gateclk_en | output | 1 | - |
| ipctrl_bht_con_br_taken | output | 1 | - |
| ipctrl_bht_con_br_vld | output | 1 | - |
| ipctrl_bht_more_br | output | 1 | - |
| ipctrl_bht_vld | output | 1 | - |
| ipctrl_btb_chgflw_vld | output | 1 | - |
| ipctrl_btb_way_pred | output | 2 | - |
| ipctrl_btb_way_pred_error | output | 1 | - |
| ipctrl_debug_bry_missigned_stall | output | 1 | - |
| ipctrl_debug_h0_vld | output | 1 | - |
| ipctrl_debug_ip_expt_vld | output | 1 | - |
| ipctrl_debug_ip_if_stall | output | 1 | - |
| ipctrl_debug_ip_vld | output | 1 | - |
| ipctrl_debug_miss_under_refill_stall | output | 1 | - |
| ipctrl_ibctrl_expt_vld | output | 1 | - |
| ipctrl_ibctrl_if_chgflw_vld | output | 1 | - |
| ipctrl_ibctrl_ip_chgflw_vld | output | 1 | - |
| ipctrl_ibctrl_l0_btb_hit | output | 1 | - |
| ipctrl_ibctrl_l0_btb_mispred | output | 1 | - |
| ipctrl_ibctrl_l0_btb_miss | output | 1 | - |
| ipctrl_ibctrl_l0_btb_st_wait | output | 1 | - |
| ipctrl_ibctrl_vld | output | 1 | - |
| ipctrl_ibdp_expt_vld | output | 1 | - |
| ipctrl_ibdp_vld | output | 1 | - |
| ipctrl_ifctrl_bht_stall | output | 1 | - |
| ipctrl_ifctrl_stall | output | 1 | - |
| ipctrl_ifctrl_stall_short | output | 1 | - |
| ipctrl_ifdp_gateclk_en | output | 1 | - |
| ipctrl_ifdp_vpc_onehot_updt | output | 8 | - |
| ipctrl_ifdp_w0_bry0_hit_updt | output | 1 | - |
| ipctrl_ifdp_w0_bry1_hit_updt | output | 1 | - |
| ipctrl_ifdp_w0b0_br_ntake_updt | output | 8 | - |
| ipctrl_ifdp_w0b0_br_taken_updt | output | 8 | - |
| ipctrl_ifdp_w0b0_bry_updt_data | output | 8 | - |
| ipctrl_ifdp_w0b1_br_ntake_updt | output | 8 | - |
| ipctrl_ifdp_w0b1_br_taken_updt | output | 8 | - |
| ipctrl_ifdp_w0b1_bry_updt_data | output | 8 | - |
| ipctrl_ifdp_w1_bry0_hit_updt | output | 1 | - |
| ipctrl_ifdp_w1_bry1_hit_updt | output | 1 | - |
| ipctrl_ifdp_w1b0_br_ntake_updt | output | 8 | - |
| ipctrl_ifdp_w1b0_br_taken_updt | output | 8 | - |
| ipctrl_ifdp_w1b0_bry_updt_data | output | 8 | - |
| ipctrl_ifdp_w1b1_br_ntake_updt | output | 8 | - |
| ipctrl_ifdp_w1b1_br_taken_updt | output | 8 | - |
| ipctrl_ifdp_w1b1_bry_updt_data | output | 8 | - |
| ipctrl_ind_btb_con_br_vld | output | 1 | - |
| ipctrl_ipdp_bht_vld | output | 1 | - |
| ipctrl_ipdp_br_more_than_one_stall | output | 1 | - |
| ipctrl_ipdp_branch | output | 8 | - |
| ipctrl_ipdp_bry_data | output | 8 | - |

*注：共94个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| hit_cnt | 3 | - |
| ip_chgflw_mistaken_flop | 1 | - |
| ip_vpc_next | 3 | - |
| ipctrl_ibctrl_expt_vld | 1 | - |
| ipctrl_ibctrl_if_chgflw_vld | 1 | - |
| ipctrl_ibctrl_ip_chgflw_vld | 1 | - |
| ipctrl_ibctrl_l0_btb_hit | 1 | - |
| ipctrl_ibctrl_l0_btb_mispred | 1 | - |
| ipctrl_ibctrl_l0_btb_miss | 1 | - |
| ipctrl_ibctrl_l0_btb_st_wait | 1 | - |
| ipctrl_ibctrl_vld | 1 | - |
| l0_btb_hit_ntake_way0 | 1 | - |
| l0_btb_hit_ntake_way1 | 1 | - |
| l0_btb_hit_taken_way0 | 1 | - |
| l0_btb_hit_taken_way1 | 1 | - |
| vpc_onehot_masked_bry_update | 8 | - |
| w0b0_br_ntake_masked | 8 | - |
| w0b0_br_taken_masked | 8 | - |
| w0b0_bry_data_masked | 8 | - |
| w0b1_br_ntake_masked | 8 | - |
| w0b1_br_taken_masked | 8 | - |
| w0b1_bry_data_masked | 8 | - |
| w1b0_br_ntake_masked | 8 | - |
| w1b0_br_taken_masked | 8 | - |
| w1b0_bry_data_masked | 8 | - |
| w1b1_br_ntake_masked | 8 | - |
| w1b1_br_taken_masked | 8 | - |
| w1b1_bry_data_masked | 8 | - |
| way0_chgflw_pc_ntake | 20 | - |
| way0_chgflw_pc_taken | 20 | - |

*注：共36个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bht_data | 2 | - |
| bht_result | 1 | - |
| br_more_than_one_stall | 1 | - |
| branch_chgflw | 1 | - |
| branch_ntake | 1 | - |
| branch_taken | 1 | - |
| bry0_hit | 1 | - |
| bry1_hit | 1 | - |
| bry_data | 8 | - |
| bry_missigned_stall | 1 | - |
| bry_vld_32 | 8 | - |
| chgflw_pc | 39 | - |
| chgflw_pc_high | 19 | - |
| chgflw_pc_low | 20 | - |
| con_br_first_branch | 1 | - |
| con_br_more_than_one | 1 | - |
| con_br_vld | 1 | - |
| cp0_ifu_bht_en | 1 | - |
| cp0_ifu_no_op_req | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| h0_vld | 1 | - |
| had_ifu_ir_vld | 1 | - |
| hit_cnt_add | 3 | - |
| hit_cnt_sub | 3 | - |
| ibctrl_ipctrl_low_power_stall | 1 | - |
| ibctrl_ipctrl_stall | 1 | - |
| icache_chk_err_refill | 1 | - |
| icache_chk_err_refill_ff | 1 | - |
| icache_refill_reissue | 1 | - |

*注：共273个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IP阶段控制模块
- 所属单元：取指单元(IFU)
- 接口数量：输入83个，输出94个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
