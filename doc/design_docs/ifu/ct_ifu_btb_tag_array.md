# ct_ifu_btb_tag_array 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_btb_tag_array |
| 文件名称 | ct_ifu_btb_tag_array.v |
| 功能描述 | BTB标签阵列模块 |

### 1.2 功能描述

BTB标签阵列模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_index | input | 10 | - |
| btb_tag_cen_b | input | 1 | - |
| btb_tag_clk_en | input | 1 | - |
| btb_tag_din | input | 22 | - |
| btb_tag_wen | input | 4 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_tag_dout | output | 44 | - |

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| btb_index | 10 | - |
| btb_tag_bwen_bank0 | 22 | - |
| btb_tag_bwen_bank1 | 22 | - |
| btb_tag_cen_b | 1 | - |
| btb_tag_clk | 1 | - |
| btb_tag_clk_en | 1 | - |
| btb_tag_din | 22 | - |
| btb_tag_dout | 44 | - |
| btb_tag_en | 1 | - |
| btb_tag_gwen_bank0 | 1 | - |
| btb_tag_gwen_bank1 | 1 | - |
| btb_tag_wen | 4 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：BTB标签阵列模块
- 所属单元：取指单元(IFU)
- 接口数量：输入9个，输出1个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
