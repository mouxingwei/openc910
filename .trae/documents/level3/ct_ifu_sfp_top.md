# ct_ifu_sfp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_sfp |
| 文件路径 | ifu/rtl/ct_ifu_sfp.v |
| 功能描述 | 简单跳转预测 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_nsfe | input | 1 | |
| cp0_ifu_vsetvli_pred_disable | input | 1 | |
| cp0_ifu_vsetvli_pred_mode | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pcgen_sfp_pc | input | 17 | |
| rtu_ifu_chgflw_vld | input | 1 | |
| rtu_ifu_retire_inst0_cur_pc | input | 39 | |
| rtu_ifu_retire_inst0_load | input | 1 | |
| rtu_ifu_retire_inst0_no_spec_hit | input | 1 | |
| rtu_ifu_retire_inst0_no_spec_mispred | input | 1 | |
| rtu_ifu_retire_inst0_no_spec_miss | input | 1 | |
| rtu_ifu_retire_inst0_store | input | 1 | |
| rtu_ifu_retire_inst0_vl_hit | input | 1 | |
| rtu_ifu_retire_inst0_vl_mispred | input | 1 | |
| rtu_ifu_retire_inst0_vl_miss | input | 1 | |
| rtu_ifu_retire_inst0_vl_pred | input | 1 | |
| rtu_ifu_retire_inst1_cur_pc | input | 39 | |
| rtu_ifu_retire_inst1_load | input | 1 | |
| rtu_ifu_retire_inst1_no_spec_hit | input | 1 | |
| rtu_ifu_retire_inst1_no_spec_mispred | input | 1 | |
| rtu_ifu_retire_inst1_no_spec_miss | input | 1 | |
| rtu_ifu_retire_inst1_store | input | 1 | |
| rtu_ifu_retire_inst1_vl_pred | input | 1 | |
| rtu_ifu_retire_inst2_cur_pc | input | 39 | |
| rtu_ifu_retire_inst2_load | input | 1 | |
| rtu_ifu_retire_inst2_no_spec_hit | input | 1 | |
| ... | ... | ... | 共49个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| sfp_ifdp_hit_pc_lo | output | 3 | |
| sfp_ifdp_hit_type | output | 4 | |
| sfp_ifdp_pc_hit | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| read | sp |
| gated_clk_cell | x_sfp_wr_buf_clk |
| gated_clk_cell | x_sfp_sf_pc_clk |
| st | mispred |
| vl | hit |
| vl | miss |
| gated_clk_cell | x_sfp_fifo_clk |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_0 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_1 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_2 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_3 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_4 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_5 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_6 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_7 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_8 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_9 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_10 |
| ct_ifu_sfp_entry | x_ct_ifu_sfp_entry_11 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
