# ct_vfpu_dp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_vfpu_dp |
| 文件路径 | vfpu/rtl/ct_vfpu_dp.v |
| 功能描述 | VFPU数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_vfpu_fxcr | input | 32 | |
| cp0_vfpu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_dp_ex2_pipe7_inst_vld | input | 1 | |
| ctrl_ex1_pipe6_eu_sel | input | 12 | |
| ctrl_ex1_pipe6_inst_vld | input | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld | input | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup0 | input | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup1 | input | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup2 | input | 1 | |
| ctrl_ex1_pipe6_mfvr_inst_vld_dup3 | input | 1 | |
| ctrl_ex1_pipe7_eu_sel | input | 12 | |
| ctrl_ex1_pipe7_mfvr_inst_vld | input | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup0 | input | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup1 | input | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup2 | input | 1 | |
| ctrl_ex1_pipe7_mfvr_inst_vld_dup3 | input | 1 | |
| ctrl_ex2_pipe6_inst_vld | input | 1 | |
| ctrl_ex2_pipe6_mfvr_inst_vld | input | 1 | |
| ctrl_ex2_pipe7_inst_vld | input | 1 | |
| ctrl_ex2_pipe7_mfvr_inst_vld | input | 1 | |
| ctrl_ex3_pipe6_inst_vld | input | 1 | |
| ctrl_ex3_pipe7_inst_vld | input | 1 | |
| ctrl_ex4_pipe6_inst_vld | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_vfpu_is_vdiv_gateclk_issue | input | 1 | |
| idu_vfpu_is_vdiv_issue | input | 1 | |
| idu_vfpu_rf_pipe6_dst_ereg | input | 5 | |
| idu_vfpu_rf_pipe6_dst_preg | input | 7 | |
| ... | ... | ... | 共101个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dp_ctrl_ex1_pipe6_data_vld_pre | output | 1 | |
| dp_ctrl_ex1_pipe7_data_vld_pre | output | 1 | |
| dp_ctrl_ex2_pipe6_data_vld_pre | output | 1 | |
| dp_ctrl_ex2_pipe7_data_vld_pre | output | 1 | |
| dp_ctrl_ex3_pipe6_data_vld_pre | output | 1 | |
| dp_ctrl_ex3_pipe6_fwd_vld_pre | output | 1 | |
| dp_ctrl_ex3_pipe7_data_vld_pre | output | 1 | |
| dp_ctrl_ex3_pipe7_fwd_vld_pre | output | 1 | |
| dp_ctrl_ex4_pipe6_fwd_vld_pre | output | 1 | |
| dp_ctrl_ex4_pipe7_fwd_vld_pre | output | 1 | |
| dp_ctrl_pipe6_vfdsu_inst_vld | output | 1 | |
| dp_ex1_pipe6_dst_vld_pre | output | 1 | |
| dp_ex1_pipe7_dst_vld_pre | output | 1 | |
| dp_ex3_pipe6_dst_vreg | output | 7 | |
| dp_ex3_pipe6_freg_data | output | 64 | |
| dp_ex3_pipe7_dst_vreg | output | 7 | |
| dp_ex3_pipe7_freg_data | output | 64 | |
| dp_ex4_pipe6_dst_ereg | output | 5 | |
| dp_ex4_pipe6_dst_vreg | output | 7 | |
| dp_ex4_pipe6_normal_dste_wb_vld | output | 1 | |
| dp_ex4_pipe6_normal_dstv_wb_vld | output | 1 | |
| dp_ex4_pipe7_dst_ereg | output | 5 | |
| dp_ex4_pipe7_dst_vreg | output | 7 | |
| dp_ex4_pipe7_dste_vld | output | 1 | |
| dp_ex4_pipe7_dstv_vld | output | 1 | |
| dp_ex5_pipe6_ereg_data_pre | output | 5 | |
| dp_ex5_pipe6_freg_data_pre | output | 64 | |
| dp_ex5_pipe7_ereg_data_pre | output | 5 | |
| dp_ex5_pipe7_freg_data_pre | output | 64 | |
| dp_rbus_pipe6_ex1_vreg | output | 7 | |
| ... | ... | ... | 共122个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_dp_ex1_pipe6_pipe_gated_clk |
| gated_clk_cell | x_dp_ex2_pipe6_gated_clk |
| gated_clk_cell | x_dp_ex3_pipe6_gated_clk |
| gated_clk_cell | x_dp_ex4_pipe6_gated_clk |
| gated_clk_cell | x_dp_ex1_pipe7_pipe_gated_clk |
| gated_clk_cell | x_dp_ex2_pipe7_gated_clk |
| gated_clk_cell | x_dp_ex3_pipe7_gated_clk |
| gated_clk_cell | x_dp_ex4_pipe7_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
