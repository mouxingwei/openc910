# ct_iu_alu 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_alu |
| 文件路径 | iu/rtl/ct_iu_alu.v |
| 功能描述 | 算术逻辑单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_idu_wbbr_data | input | 64 | |
| had_idu_wbbr_vld | input | 1 | |
| idu_iu_rf_pipex_alu_short | input | 1 | |
| idu_iu_rf_pipex_dst_preg | input | 7 | |
| idu_iu_rf_pipex_dst_vld | input | 1 | |
| idu_iu_rf_pipex_dst_vreg | input | 7 | |
| idu_iu_rf_pipex_dstv_vld | input | 1 | |
| idu_iu_rf_pipex_func | input | 5 | |
| idu_iu_rf_pipex_gateclk_sel | input | 1 | |
| idu_iu_rf_pipex_imm | input | 6 | |
| idu_iu_rf_pipex_rslt_sel | input | 21 | |
| idu_iu_rf_pipex_sel | input | 1 | |
| idu_iu_rf_pipex_src0 | input | 64 | |
| idu_iu_rf_pipex_src1 | input | 64 | |
| idu_iu_rf_pipex_src2 | input | 64 | |
| idu_iu_rf_pipex_vl | input | 8 | |
| idu_iu_rf_pipex_vlmul | input | 2 | |
| idu_iu_rf_pipex_vsew | input | 3 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| alu_rbus_ex1_pipex_data | output | 64 | |
| alu_rbus_ex1_pipex_data_vld | output | 1 | |
| alu_rbus_ex1_pipex_fwd_data | output | 64 | |
| alu_rbus_ex1_pipex_fwd_vld | output | 1 | |
| alu_rbus_ex1_pipex_preg | output | 7 | |
| iu_vfpu_ex1_pipex_mtvr_inst | output | 5 | |
| iu_vfpu_ex1_pipex_mtvr_vl | output | 8 | |
| iu_vfpu_ex1_pipex_mtvr_vld | output | 1 | |
| iu_vfpu_ex1_pipex_mtvr_vlmul | output | 2 | |
| iu_vfpu_ex1_pipex_mtvr_vreg | output | 7 | |
| iu_vfpu_ex1_pipex_mtvr_vsew | output | 3 | |
| iu_vfpu_ex2_pipex_mtvr_src0 | output | 64 | |
| iu_vfpu_ex2_pipex_mtvr_vld | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ctrl_gated_clk |
| gated_clk_cell | x_ex1_inst_gated_clk |
| gated_clk_cell | x_ex2_inst_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
