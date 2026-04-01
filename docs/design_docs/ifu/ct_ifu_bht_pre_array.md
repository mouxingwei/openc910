# ct_ifu_bht_pre_array 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_bht_pre_array |
| 文件名称 | ct_ifu_bht_pre_array.v |
| 功能描述 | BHT预测阵列模块 |

### 1.2 功能描述

BHT预测阵列模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_pre_array_clk_en | input | 1 | - |
| bht_pred_array_cen_b | input | 1 | - |
| bht_pred_array_din | input | 64 | - |
| bht_pred_array_gwen | input | 1 | - |
| bht_pred_array_index | input | 10 | - |
| bht_pred_bwen | input | 64 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_pre_data_out | output | 64 | - |

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bht_pre_array_clk_en | 1 | - |
| bht_pre_clk | 1 | - |
| bht_pre_data_out | 64 | - |
| bht_pre_en | 1 | - |
| bht_pred_array_cen_b | 1 | - |
| bht_pred_array_din | 64 | - |
| bht_pred_array_gwen | 1 | - |
| bht_pred_array_index | 10 | - |
| bht_pred_bwen | 64 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：BHT预测阵列模块
- 所属单元：取指单元(IFU)
- 接口数量：输入10个，输出1个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
