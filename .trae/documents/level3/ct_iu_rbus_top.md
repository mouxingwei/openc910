# ct_iu_rbus 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_rbus |
| 文件路径 | iu/rtl/ct_iu_rbus.v |
| 功能描述 | R总线接口 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| alu_rbus_ex1_pipe0_data | input | 64 | |
| alu_rbus_ex1_pipe0_data_vld | input | 1 | |
| alu_rbus_ex1_pipe0_fwd_data | input | 64 | |
| alu_rbus_ex1_pipe0_fwd_vld | input | 1 | |
| alu_rbus_ex1_pipe0_preg | input | 7 | |
| alu_rbus_ex1_pipe1_data | input | 64 | |
| alu_rbus_ex1_pipe1_data_vld | input | 1 | |
| alu_rbus_ex1_pipe1_fwd_data | input | 64 | |
| alu_rbus_ex1_pipe1_fwd_vld | input | 1 | |
| alu_rbus_ex1_pipe1_preg | input | 7 | |
| cp0_iu_ex3_rslt_data | input | 64 | |
| cp0_iu_ex3_rslt_preg | input | 7 | |
| cp0_iu_ex3_rslt_vld | input | 1 | |
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| div_rbus_data | input | 64 | |
| div_rbus_pipe0_data_vld | input | 1 | |
| div_rbus_preg | input | 7 | |
| forever_cpuclk | input | 1 | |
| had_idu_wbbr_data | input | 64 | |
| had_idu_wbbr_vld | input | 1 | |
| mult_rbus_ex3_data_vld | input | 1 | |
| mult_rbus_ex3_preg | input | 7 | |
| mult_rbus_ex4_data | input | 64 | |
| mult_rbus_ex4_data_vld | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |
| special_rbus_ex1_data | input | 64 | |
| special_rbus_ex1_data_vld | input | 1 | |
| ... | ... | ... | 共37个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| iu_idu_ex1_pipe0_fwd_preg | output | 7 | |
| iu_idu_ex1_pipe0_fwd_preg_data | output | 64 | |
| iu_idu_ex1_pipe0_fwd_preg_vld | output | 1 | |
| iu_idu_ex1_pipe1_fwd_preg | output | 7 | |
| iu_idu_ex1_pipe1_fwd_preg_data | output | 64 | |
| iu_idu_ex1_pipe1_fwd_preg_vld | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_data | output | 64 | |
| iu_idu_ex2_pipe0_wb_preg_dup0 | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dup1 | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dup2 | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dup3 | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dup4 | output | 7 | |
| iu_idu_ex2_pipe0_wb_preg_expand | output | 96 | |
| iu_idu_ex2_pipe0_wb_preg_vld | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dup0 | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dup1 | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dup2 | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dup3 | output | 1 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dup4 | output | 1 | |
| iu_idu_ex2_pipe1_wb_preg | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_data | output | 64 | |
| iu_idu_ex2_pipe1_wb_preg_dup0 | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_dup1 | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_dup2 | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_dup3 | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_dup4 | output | 7 | |
| iu_idu_ex2_pipe1_wb_preg_expand | output | 96 | |
| iu_idu_ex2_pipe1_wb_preg_vld | output | 1 | |
| iu_idu_ex2_pipe1_wb_preg_vld_dup0 | output | 1 | |
| ... | ... | ... | 共38个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_rslt_vld_gated_clk |
| ct_rtu_expand_96 | x_ct_rtu_expand_96_rbus_pipe0_rslt_preg |
| gated_clk_cell | x_pipe0_data_gated_clk |
| ct_rtu_expand_96 | x_ct_rtu_expand_96_rbus_pipe1_rslt_preg |
| gated_clk_cell | x_pipe1_data_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
