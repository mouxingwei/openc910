# ct_ifu_ipctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipctrl |
| 文件路径 | ifu/rtl/ct_ifu_ipctrl.v |
| 功能描述 | 预取控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_bht_en | input | 1 | |
| cp0_ifu_no_op_req | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_ifu_ir_vld | input | 1 | |
| ibctrl_ipctrl_low_power_stall | input | 1 | |
| ibctrl_ipctrl_stall | input | 1 | |
| ifctrl_ipctrl_if_pcload | input | 1 | |
| ifctrl_ipctrl_vld | input | 1 | |
| ifdp_ipctrl_expt_vld | input | 1 | |
| ifdp_ipctrl_expt_vld_dup | input | 1 | |
| ifdp_ipctrl_fifo | input | 1 | |
| ifdp_ipctrl_pa | input | 28 | |
| ifdp_ipctrl_refill_on | input | 1 | |
| ifdp_ipctrl_tsize | input | 1 | |
| ifdp_ipctrl_vpc_2_0_onehot | input | 8 | |
| ifdp_ipctrl_vpc_bry_mask | input | 8 | |
| ifdp_ipctrl_w0_bry0_hit | input | 1 | |
| ifdp_ipctrl_w0_bry1_hit | input | 1 | |
| ifdp_ipctrl_w0b0_br_ntake | input | 8 | |
| ifdp_ipctrl_w0b0_br_taken | input | 8 | |
| ifdp_ipctrl_w0b0_bry_data | input | 8 | |
| ifdp_ipctrl_w0b1_br_ntake | input | 8 | |
| ifdp_ipctrl_w0b1_br_taken | input | 8 | |
| ifdp_ipctrl_w0b1_bry_data | input | 8 | |
| ifdp_ipctrl_w1_bry0_hit | input | 1 | |
| ifdp_ipctrl_w1_bry1_hit | input | 1 | |
| ifdp_ipctrl_w1b0_br_ntake | input | 8 | |
| ifdp_ipctrl_w1b0_br_taken | input | 8 | |
| ifdp_ipctrl_w1b0_bry_data | input | 8 | |
| ... | ... | ... | 共87个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ipctrl_bht_con_br_gateclk_en | output | 1 | |
| ipctrl_bht_con_br_taken | output | 1 | |
| ipctrl_bht_con_br_vld | output | 1 | |
| ipctrl_bht_more_br | output | 1 | |
| ipctrl_bht_vld | output | 1 | |
| ipctrl_btb_chgflw_vld | output | 1 | |
| ipctrl_btb_way_pred | output | 2 | |
| ipctrl_btb_way_pred_error | output | 1 | |
| ipctrl_debug_bry_missigned_stall | output | 1 | |
| ipctrl_debug_h0_vld | output | 1 | |
| ipctrl_debug_ip_expt_vld | output | 1 | |
| ipctrl_debug_ip_if_stall | output | 1 | |
| ipctrl_debug_ip_vld | output | 1 | |
| ipctrl_debug_miss_under_refill_stall | output | 1 | |
| ipctrl_ibctrl_expt_vld | output | 1 | |
| ipctrl_ibctrl_if_chgflw_vld | output | 1 | |
| ipctrl_ibctrl_ip_chgflw_vld | output | 1 | |
| ipctrl_ibctrl_l0_btb_hit | output | 1 | |
| ipctrl_ibctrl_l0_btb_mispred | output | 1 | |
| ipctrl_ibctrl_l0_btb_miss | output | 1 | |
| ipctrl_ibctrl_l0_btb_st_wait | output | 1 | |
| ipctrl_ibctrl_vld | output | 1 | |
| ipctrl_ibdp_expt_vld | output | 1 | |
| ipctrl_ibdp_vld | output | 1 | |
| ipctrl_ifctrl_bht_stall | output | 1 | |
| ipctrl_ifctrl_stall | output | 1 | |
| ipctrl_ifctrl_stall_short | output | 1 | |
| ipctrl_ifdp_gateclk_en | output | 1 | |
| ipctrl_ifdp_vpc_onehot_updt | output | 8 | |
| ipctrl_ifdp_w0_bry0_hit_updt | output | 1 | |
| ... | ... | ... | 共94个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| parity | check |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
