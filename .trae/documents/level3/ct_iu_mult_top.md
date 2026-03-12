# ct_iu_mult 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_mult |
| 文件路径 | iu/rtl/ct_iu_mult.v |
| 功能描述 | 乘法单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_iu_rf_mult_gateclk_sel | input | 1 | |
| idu_iu_rf_mult_sel | input | 1 | |
| idu_iu_rf_pipe1_dst_preg | input | 7 | |
| idu_iu_rf_pipe1_mla_src2_preg | input | 7 | |
| idu_iu_rf_pipe1_mla_src2_vld | input | 1 | |
| idu_iu_rf_pipe1_mult_func | input | 8 | |
| idu_iu_rf_pipe1_src0 | input | 64 | |
| idu_iu_rf_pipe1_src1_no_imm | input | 64 | |
| idu_iu_rf_pipe1_src2 | input | 64 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| iu_idu_ex1_pipe1_mult_stall | output | 1 | |
| iu_idu_ex2_pipe1_mult_inst_vld_dup0 | output | 1 | |
| iu_idu_ex2_pipe1_mult_inst_vld_dup1 | output | 1 | |
| iu_idu_ex2_pipe1_mult_inst_vld_dup2 | output | 1 | |
| iu_idu_ex2_pipe1_mult_inst_vld_dup3 | output | 1 | |
| iu_idu_ex2_pipe1_mult_inst_vld_dup4 | output | 1 | |
| iu_idu_ex2_pipe1_preg_dup0 | output | 7 | |
| iu_idu_ex2_pipe1_preg_dup1 | output | 7 | |
| iu_idu_ex2_pipe1_preg_dup2 | output | 7 | |
| iu_idu_ex2_pipe1_preg_dup3 | output | 7 | |
| iu_idu_ex2_pipe1_preg_dup4 | output | 7 | |
| iu_idu_pipe1_mla_src2_no_fwd | output | 1 | |
| mult_rbus_ex3_data_vld | output | 1 | |
| mult_rbus_ex3_preg | output | 7 | |
| mult_rbus_ex4_data | output | 64 | |
| mult_rbus_ex4_data_vld | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_mult_gated_clk |
| gated_clk_cell | x_ex1_inst_gated_clk |
| gated_clk_cell | x_ex2_inst_gated_clk |
| gated_clk_cell | x_ex3_inst_gated_clk |
| gated_clk_cell | x_ex4_inst_gated_clk |
| multiplier_65x65_3_stage | x_ct_iu_mult_multiplier_65x65_3_stage |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
