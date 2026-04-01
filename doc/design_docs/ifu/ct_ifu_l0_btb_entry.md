# ct_ifu_l0_btb_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_l0_btb_entry |
| 文件名称 | ct_ifu_l0_btb_entry.v |
| 功能描述 | L0 BTB表项模块 |

### 1.2 功能描述

L0 BTB表项模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_btb_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_l0btb_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| entry_inv | input | 1 | - |
| entry_update | input | 1 | - |
| entry_update_cnt | input | 1 | - |
| entry_update_data | input | 37 | - |
| entry_update_ras | input | 1 | - |
| entry_update_vld | input | 1 | - |
| entry_wen | input | 4 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| entry_cnt | output | 1 | - |
| entry_ras | output | 1 | - |
| entry_tag | output | 15 | - |
| entry_target | output | 20 | - |
| entry_vld | output | 1 | - |
| entry_way_pred | output | 2 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_cnt | 1 | - |
| entry_ras | 1 | - |
| entry_tag | 15 | - |
| entry_target | 20 | - |
| entry_vld | 1 | - |
| entry_way_pred | 2 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_btb_en | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_l0btb_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_clk | 1 | - |
| entry_clk_en | 1 | - |
| entry_inv | 1 | - |
| entry_update | 1 | - |
| entry_update_cnt | 1 | - |
| entry_update_data | 37 | - |
| entry_update_en | 1 | - |
| entry_update_ras | 1 | - |
| entry_update_vld | 1 | - |
| entry_wen | 4 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：L0 BTB表项模块
- 所属单元：取指单元(IFU)
- 接口数量：输入14个，输出6个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
