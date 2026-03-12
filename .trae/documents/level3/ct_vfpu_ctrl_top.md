# ct_vfpu_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_vfpu_ctrl |
| 文件路径 | vfpu/rtl/ct_vfpu_ctrl.v |
| 功能描述 | VFPU控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_vfpu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dp_ctrl_ex1_pipe6_data_vld_pre | input | 1 | |
| dp_ctrl_ex1_pipe7_data_vld_pre | input | 1 | |
| dp_ctrl_ex2_pipe6_data_vld_pre | input | 1 | |
| dp_ctrl_ex2_pipe7_data_vld_pre | input | 1 | |
| dp_ctrl_ex3_pipe6_data_vld_pre | input | 1 | |
| dp_ctrl_ex3_pipe6_fwd_vld_pre | input | 1 | |
| dp_ctrl_ex3_pipe7_data_vld_pre | input | 1 | |
| dp_ctrl_ex3_pipe7_fwd_vld_pre | input | 1 | |
| dp_ctrl_ex4_pipe6_fwd_vld_pre | input | 1 | |
| dp_ctrl_ex4_pipe7_fwd_vld_pre | input | 1 | |
| dp_ctrl_pipe6_vfdsu_inst_vld | input | 1 | |
| dp_ex1_pipe6_dst_vld_pre | input | 1 | |
| dp_ex1_pipe7_dst_vld_pre | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_vfpu_rf_pipe6_eu_sel | input | 12 | |
| idu_vfpu_rf_pipe6_gateclk_sel | input | 1 | |
| idu_vfpu_rf_pipe6_sel | input | 1 | |
| idu_vfpu_rf_pipe7_eu_sel | input | 12 | |
| idu_vfpu_rf_pipe7_gateclk_sel | input | 1 | |
| idu_vfpu_rf_pipe7_sel | input | 1 | |
| iu_vfpu_ex1_pipe0_mtvr_inst | input | 5 | |
| iu_vfpu_ex1_pipe0_mtvr_vld | input | 1 | |
| iu_vfpu_ex1_pipe1_mtvr_inst | input | 5 | |
| iu_vfpu_ex1_pipe1_mtvr_vld | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pipe6_dp_vfdsu_inst_vld | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |
| ... | ... | ... | 共31个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_dp_ex2_pipe7_inst_vld | output | 1 | |
| ctrl_ex1_pipe6_data_vld | output | 1 | |
| ctrl_ex1_pipe6_data_vld_dup0 | output | 1 | |
| ctrl_ex1_pipe6_data_vld_dup1 | output | 1 | |
| ctrl_ex1_pipe6_data_vld_dup2 | output | 1 | |
| ctrl_ex1_pipe6_eu_sel | output | 12 | |
| ctrl_ex1_pipe6_inst_vld | output | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld | output | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup0 | output | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup1 | output | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup2 | output | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup3 | output | 1 | |
| ctrl_ex1_pipe7_data_vld | output | 1 | |
| ctrl_ex1_pipe7_data_vld_dup0 | output | 1 | |
| ctrl_ex1_pipe7_data_vld_dup1 | output | 1 | |
| ctrl_ex1_pipe7_data_vld_dup2 | output | 1 | |
| ctrl_ex1_pipe7_eu_sel | output | 12 | |
| ctrl_ex1_pipe7_mfvr_inst_vld | output | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup0 | output | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup1 | output | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup2 | output | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup3 | output | 1 | |
| ctrl_ex2_pipe6_data_vld | output | 1 | |
| ctrl_ex2_pipe6_data_vld_dup0 | output | 1 | |
| ctrl_ex2_pipe6_data_vld_dup1 | output | 1 | |
| ctrl_ex2_pipe6_data_vld_dup2 | output | 1 | |
| ctrl_ex2_pipe6_inst_vld | output | 1 | |
| ctrl_ex2_pipe6_mfvr_inst_vld | output | 1 | |
| ctrl_ex2_pipe7_data_vld | output | 1 | |
| ctrl_ex2_pipe7_data_vld_dup0 | output | 1 | |
| ... | ... | ... | 共54个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ctrl_ex1_pipe6_gated_clk |
| gated_clk_cell | x_ctrl_ex2_pipe6_gated_clk |
| gated_clk_cell | x_ctrl_ex3_pipe6_gated_clk |
| gated_clk_cell | x_ctrl_ex4_pipe6_gated_clk |
| gated_clk_cell | x_ctrl_ex5_pipe6_gated_clk |
| gated_clk_cell | x_ctrl_ex1_pipe7_gated_clk |
| gated_clk_cell | x_ctrl_ex2_pipe7_gated_clk |
| gated_clk_cell | x_ctrl_ex3_pipe7_gated_clk |
| gated_clk_cell | x_ctrl_ex4_pipe7_gated_clk |
| gated_clk_cell | x_ctrl_ex5_pipe7_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
