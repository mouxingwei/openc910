# ct_ifu_btb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_btb |
| 文件路径 | ifu/rtl/ct_ifu_btb.v |
| 功能描述 | 分支目标缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_btb_index | input | 10 | |
| addrgen_btb_tag | input | 10 | |
| addrgen_btb_target_pc | input | 20 | |
| addrgen_btb_update_vld | input | 1 | |
| cp0_ifu_btb_en | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibdp_btb_miss | input | 1 | |
| ifctrl_btb_inv | input | 1 | |
| ipctrl_btb_chgflw_vld | input | 1 | |
| ipctrl_btb_way_pred | input | 2 | |
| ipctrl_btb_way_pred_error | input | 1 | |
| ipdp_btb_index_pc | input | 39 | |
| ipdp_btb_target_pc | input | 20 | |
| pad_yy_icg_scan_en | input | 1 | |
| pcgen_btb_chgflw | input | 1 | |
| pcgen_btb_chgflw_higher_than_addrgen | input | 1 | |
| pcgen_btb_chgflw_higher_than_if | input | 1 | |
| pcgen_btb_chgflw_higher_than_ip | input | 1 | |
| pcgen_btb_chgflw_short | input | 1 | |
| pcgen_btb_index | input | 10 | |
| pcgen_btb_stall | input | 1 | |
| pcgen_btb_stall_short | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_ifctrl_inv_done | output | 1 | |
| btb_ifctrl_inv_on | output | 1 | |
| btb_ifdp_way0_pred | output | 2 | |
| btb_ifdp_way0_tag | output | 10 | |
| btb_ifdp_way0_target | output | 20 | |
| btb_ifdp_way0_vld | output | 1 | |
| btb_ifdp_way1_pred | output | 2 | |
| btb_ifdp_way1_tag | output | 10 | |
| btb_ifdp_way1_target | output | 20 | |
| btb_ifdp_way1_vld | output | 1 | |
| btb_ifdp_way2_pred | output | 2 | |
| btb_ifdp_way2_tag | output | 10 | |
| btb_ifdp_way2_target | output | 20 | |
| btb_ifdp_way2_vld | output | 1 | |
| btb_ifdp_way3_pred | output | 2 | |
| btb_ifdp_way3_tag | output | 10 | |
| btb_ifdp_way3_target | output | 20 | |
| btb_ifdp_way3_vld | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_index_pc_record_clk |
| data | out |
| gated_clk_cell | x_btb_dout_flop_clk |
| gated_clk_cell | x_btb_inv_reg_upd_clk |
| gated_clk_cell | x_refill_buf_updt_clk |
| ct_ifu_btb_tag_array | x_ct_ifu_btb_tag_array |
| ct_ifu_btb_data_array | x_ct_ifu_btb_data_array |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
