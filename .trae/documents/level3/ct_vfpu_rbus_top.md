# ct_vfpu_rbus 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_vfpu_rbus |
| 文件路径 | vfpu/rtl/ct_vfpu_rbus.v |
| 功能描述 | VFPU R总线 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_vfpu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ex1_pipe6_data_vld | input | 1 | |
| ctrl_ex1_pipe6_data_vld_dup0 | input | 1 | |
| ctrl_ex1_pipe6_data_vld_dup1 | input | 1 | |
| ctrl_ex1_pipe6_data_vld_dup2 | input | 1 | |
| ctrl_ex1_pipe7_data_vld | input | 1 | |
| ctrl_ex1_pipe7_data_vld_dup0 | input | 1 | |
| ctrl_ex1_pipe7_data_vld_dup1 | input | 1 | |
| ctrl_ex1_pipe7_data_vld_dup2 | input | 1 | |
| ctrl_ex2_pipe6_data_vld | input | 1 | |
| ctrl_ex2_pipe6_data_vld_dup0 | input | 1 | |
| ctrl_ex2_pipe6_data_vld_dup1 | input | 1 | |
| ctrl_ex2_pipe6_data_vld_dup2 | input | 1 | |
| ctrl_ex2_pipe7_data_vld | input | 1 | |
| ctrl_ex2_pipe7_data_vld_dup0 | input | 1 | |
| ctrl_ex2_pipe7_data_vld_dup1 | input | 1 | |
| ctrl_ex2_pipe7_data_vld_dup2 | input | 1 | |
| ctrl_ex3_pipe6_data_vld | input | 1 | |
| ctrl_ex3_pipe6_data_vld_dup0 | input | 1 | |
| ctrl_ex3_pipe6_data_vld_dup1 | input | 1 | |
| ctrl_ex3_pipe6_data_vld_dup2 | input | 1 | |
| ctrl_ex3_pipe6_fwd_vld | input | 1 | |
| ctrl_ex3_pipe7_data_vld | input | 1 | |
| ctrl_ex3_pipe7_data_vld_dup0 | input | 1 | |
| ctrl_ex3_pipe7_data_vld_dup1 | input | 1 | |
| ctrl_ex3_pipe7_data_vld_dup2 | input | 1 | |
| ctrl_ex3_pipe7_fwd_vld | input | 1 | |
| ctrl_ex4_pipe6_fwd_vld | input | 1 | |
| ... | ... | ... | 共113个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| vfpu_idu_ex1_pipe6_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex1_pipe6_data_vld_dup1 | output | 1 | |
| vfpu_idu_ex1_pipe6_data_vld_dup2 | output | 1 | |
| vfpu_idu_ex1_pipe6_data_vld_dup3 | output | 1 | |
| vfpu_idu_ex1_pipe6_fmla_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex1_pipe6_fmla_data_vld_dup1 | output | 1 | |
| vfpu_idu_ex1_pipe6_fmla_data_vld_dup2 | output | 1 | |
| vfpu_idu_ex1_pipe6_fmla_data_vld_dup3 | output | 1 | |
| vfpu_idu_ex1_pipe6_vreg_dup0 | output | 7 | |
| vfpu_idu_ex1_pipe6_vreg_dup1 | output | 7 | |
| vfpu_idu_ex1_pipe6_vreg_dup2 | output | 7 | |
| vfpu_idu_ex1_pipe6_vreg_dup3 | output | 7 | |
| vfpu_idu_ex1_pipe7_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex1_pipe7_data_vld_dup1 | output | 1 | |
| vfpu_idu_ex1_pipe7_data_vld_dup2 | output | 1 | |
| vfpu_idu_ex1_pipe7_data_vld_dup3 | output | 1 | |
| vfpu_idu_ex1_pipe7_fmla_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex1_pipe7_fmla_data_vld_dup1 | output | 1 | |
| vfpu_idu_ex1_pipe7_fmla_data_vld_dup2 | output | 1 | |
| vfpu_idu_ex1_pipe7_fmla_data_vld_dup3 | output | 1 | |
| vfpu_idu_ex1_pipe7_vreg_dup0 | output | 7 | |
| vfpu_idu_ex1_pipe7_vreg_dup1 | output | 7 | |
| vfpu_idu_ex1_pipe7_vreg_dup2 | output | 7 | |
| vfpu_idu_ex1_pipe7_vreg_dup3 | output | 7 | |
| vfpu_idu_ex2_pipe6_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex2_pipe6_data_vld_dup1 | output | 1 | |
| vfpu_idu_ex2_pipe6_data_vld_dup2 | output | 1 | |
| vfpu_idu_ex2_pipe6_data_vld_dup3 | output | 1 | |
| vfpu_idu_ex2_pipe6_fmla_data_vld_dup0 | output | 1 | |
| vfpu_idu_ex2_pipe6_fmla_data_vld_dup1 | output | 1 | |
| ... | ... | ... | 共140个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_rtu_expand_64 | x_ct_rtu_expand_64_rbus_pipe6_vreg |
| gated_clk_cell | x_rbus_ex5_pipe6_vreg_gated_clk |
| gated_clk_cell | x_rbus_ex5_pipe6_ereg_gated_clk |
| ct_rtu_expand_64 | x_ct_rtu_expand_64_rbus_pipe7_vreg |
| gated_clk_cell | x_rbus_ex5_pipe7_vreg_gated_clk |
| gated_clk_cell | x_rbus_ex5_pipe7_ereg_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
