# ct_ifu_ras 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ras |
| 文件路径 | ifu/rtl/ct_ifu_ras.v |
| 功能描述 | 返回地址栈 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_ras_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibctrl_ras_inst_pcall | input | 1 | |
| ibctrl_ras_pcall_vld | input | 1 | |
| ibctrl_ras_pcall_vld_for_gateclk | input | 1 | |
| ibctrl_ras_preturn_vld | input | 1 | |
| ibctrl_ras_preturn_vld_for_gateclk | input | 1 | |
| ibdp_ras_push_pc | input | 39 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_ifu_flush | input | 1 | |
| rtu_ifu_retire0_inc_pc | input | 39 | |
| rtu_ifu_retire0_mispred | input | 1 | |
| rtu_ifu_retire0_pcall | input | 1 | |
| rtu_ifu_retire0_preturn | input | 1 | |
| rtu_ifu_retire0_preturn | input | 1 | |
| rtu_ifu_retire0_pcall | input | 1 | |
| cpurst_b | input | 1 | |
| cpurst_b | input | 1 | |
| cp0_ifu_ras_en | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ras_ipdp_data_vld | output | 1 | |
| ras_ipdp_pc | output | 39 | |
| ras_l0_btb_pc | output | 39 | |
| ras_l0_btb_push_pc | output | 39 | |
| ras_l0_btb_ras_push | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_rtu_ptr_upd_clk |
| gated_clk_cell | x_top_ptr_upd_clk |
| gated_clk_cell | x_status_ptr_upd_clk |
| gated_clk_cell | x_rtu_entry0_upd_clk |
| gated_clk_cell | x_rtu_entry1_upd_clk |
| gated_clk_cell | x_rtu_entry2_upd_clk |
| gated_clk_cell | x_rtu_entry3_upd_clk |
| gated_clk_cell | x_rtu_entry4_upd_clk |
| gated_clk_cell | x_rtu_entry5_upd_clk |
| gated_clk_cell | x_rtu_fifo_ptr_upd_clk |
| gated_clk_cell | x_ras_entry0_upd_clk |
| gated_clk_cell | x_ras_entry1_upd_clk |
| gated_clk_cell | x_ras_entry2_upd_clk |
| gated_clk_cell | x_ras_entry3_upd_clk |
| gated_clk_cell | x_ras_entry4_upd_clk |
| gated_clk_cell | x_ras_entry5_upd_clk |
| gated_clk_cell | x_ras_entry6_upd_clk |
| gated_clk_cell | x_ras_entry7_upd_clk |
| gated_clk_cell | x_ras_entry8_upd_clk |
| gated_clk_cell | x_ras_entry9_upd_clk |
| gated_clk_cell | x_ras_entry10_upd_clk |
| gated_clk_cell | x_ras_entry11_upd_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
