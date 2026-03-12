# ct_vfpu_cbus 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_vfpu_cbus |
| 文件路径 | vfpu/rtl/ct_vfpu_cbus.v |
| 功能描述 | VFPU C总线 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_vfpu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_vfpu_rf_pipe6_gateclk_sel | input | 1 | |
| idu_vfpu_rf_pipe6_iid | input | 7 | |
| idu_vfpu_rf_pipe6_sel | input | 1 | |
| idu_vfpu_rf_pipe7_gateclk_sel | input | 1 | |
| idu_vfpu_rf_pipe7_iid | input | 7 | |
| idu_vfpu_rf_pipe7_sel | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| vfpu_rtu_pipe6_cmplt | output | 1 | |
| vfpu_rtu_pipe6_iid | output | 7 | |
| vfpu_rtu_pipe7_cmplt | output | 1 | |
| vfpu_rtu_pipe7_iid | output | 7 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_vfpu_inst_vld_gated_clk |
| gated_clk_cell | x_vfpu_pipe6_data_gated_clk |
| gated_clk_cell | x_vfpu_pipe7_data_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
