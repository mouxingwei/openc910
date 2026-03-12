# ct_ifu_l0_btb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_l0_btb |
| 文件路径 | ifu/rtl/ct_ifu_l0_btb.v |
| 功能描述 | L0 BTB |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_l0_btb_update_entry | input | 16 | |
| addrgen_l0_btb_update_vld | input | 1 | |
| addrgen_l0_btb_update_vld_bit | input | 1 | |
| addrgen_l0_btb_wen | input | 4 | |
| cp0_ifu_btb_en | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_l0btb_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibdp_l0_btb_fifo_update_vld | input | 1 | |
| ibdp_l0_btb_update_cnt_bit | input | 1 | |
| ibdp_l0_btb_update_data | input | 37 | |
| ibdp_l0_btb_update_entry | input | 16 | |
| ibdp_l0_btb_update_ras_bit | input | 1 | |
| ibdp_l0_btb_update_vld | input | 1 | |
| ibdp_l0_btb_update_vld_bit | input | 1 | |
| ibdp_l0_btb_wen | input | 4 | |
| ifctrl_l0_btb_inv | input | 1 | |
| ifctrl_l0_btb_stall | input | 1 | |
| ipctrl_l0_btb_chgflw_vld | input | 1 | |
| ipctrl_l0_btb_ip_vld | input | 1 | |
| ipctrl_l0_btb_wait_next | input | 1 | |
| ipdp_l0_btb_ras_pc | input | 39 | |
| ipdp_l0_btb_ras_push | input | 1 | |
| l0_btb_update_vld_for_gateclk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pcgen_l0_btb_chgflw_mask | input | 1 | |
| pcgen_l0_btb_chgflw_pc | input | 15 | |
| pcgen_l0_btb_chgflw_vld | input | 1 | |
| ... | ... | ... | 共40个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| l0_btb_debug_cur_state | output | 2 | |
| l0_btb_ibdp_entry_fifo | output | 16 | |
| l0_btb_ifctrl_chgflw_pc | output | 39 | |
| l0_btb_ifctrl_chgflw_way_pred | output | 2 | |
| l0_btb_ifctrl_chglfw_vld | output | 1 | |
| l0_btb_ifdp_chgflw_pc | output | 39 | |
| l0_btb_ifdp_chgflw_way_pred | output | 2 | |
| l0_btb_ifdp_counter | output | 1 | |
| l0_btb_ifdp_entry_hit | output | 16 | |
| l0_btb_ifdp_hit | output | 1 | |
| l0_btb_ifdp_ras | output | 1 | |
| l0_btb_ipctrl_st_wait | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_l0_btb_pipe_clk |
| gated_clk_cell | x_l0_btb_clk |
| gated_clk_cell | x_l0_btb_create_clk |
| gated_clk_cell | x_l0_btb_inv_reg_upd_clk |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_0 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_1 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_2 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_3 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_4 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_5 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_6 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_7 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_8 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_9 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_10 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_11 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_12 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_13 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_14 |
| ct_ifu_l0_btb_entry | x_l0_btb_entry_15 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
