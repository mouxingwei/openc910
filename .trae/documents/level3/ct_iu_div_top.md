# ct_iu_div 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_div |
| 文件路径 | iu/rtl/ct_iu_div.v |
| 功能描述 | 除法单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_iu_div_entry_disable | input | 1 | |
| cp0_iu_div_entry_disable_clr | input | 1 | |
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_iu_is_div_gateclk_issue | input | 1 | |
| idu_iu_is_div_issue | input | 1 | |
| idu_iu_rf_div_gateclk_sel | input | 1 | |
| idu_iu_rf_div_sel | input | 1 | |
| idu_iu_rf_pipe0_dst_preg | input | 7 | |
| idu_iu_rf_pipe0_func | input | 5 | |
| idu_iu_rf_pipe0_iid | input | 7 | |
| idu_iu_rf_pipe0_src0 | input | 64 | |
| idu_iu_rf_pipe0_src1_no_imm | input | 64 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| div_rbus_data | output | 64 | |
| div_rbus_pipe0_data_vld | output | 1 | |
| div_rbus_preg | output | 7 | |
| div_top_div_no_idle | output | 1 | |
| div_top_div_wf_wb | output | 1 | |
| iu_idu_div_busy | output | 1 | |
| iu_idu_div_inst_vld | output | 1 | |
| iu_idu_div_preg_dup0 | output | 7 | |
| iu_idu_div_preg_dup1 | output | 7 | |
| iu_idu_div_preg_dup2 | output | 7 | |
| iu_idu_div_preg_dup3 | output | 7 | |
| iu_idu_div_preg_dup4 | output | 7 | |
| iu_idu_div_wb_stall | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_div_gated_clk |
| gated_clk_cell | x_ex1_inst_gated_clk |
| gated_clk_cell | x_ex2_inst_gated_clk |
| inst | launch |
| ct_iu_div_srt_radix16 | x_ct_iu_div_srt_radix16 |
| ct_iu_div_entry | x_ct_iu_div_entry |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
