# ct_ifu_icache_predecd_array1 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_icache_predecd_array1 |
| 文件名称 | ct_ifu_icache_predecd_array1.v |
| 功能描述 | ICache预译码阵列1模块 |

### 1.2 功能描述

ICache预译码阵列1模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ifu_icache_data_array1_wen_b | input | 1 | - |
| ifu_icache_index | input | 16 | - |
| ifu_icache_predecd_array1_cen_b | input | 1 | - |
| ifu_icache_predecd_array1_clk_en | input | 1 | - |
| ifu_icache_predecd_array1_din | input | 32 | - |
| ifu_icache_predecd_array1_wen_b | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| icache_ifu_predecd_array1_dout | output | 32 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| WIDTH | 1 | 15 | - |
| WIDTH | 1 | 14 | - |
| WIDTH | 1 | 13 | - |
| WIDTH | 1 | 12 | - |

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| forever_cpuclk | 1 | - |
| icache_ifu_predecd_array1_dout | 32 | - |
| ifu_icache_data_array1_wen_b | 1 | - |
| ifu_icache_index | 16 | - |
| ifu_icache_predecd_array1_bwen | 32 | - |
| ifu_icache_predecd_array1_cen_b | 1 | - |
| ifu_icache_predecd_array1_clk_en | 1 | - |
| ifu_icache_predecd_array1_din | 32 | - |
| ifu_icache_predecd_array1_wen_b | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| predecd_clk | 1 | - |
| predecd_local_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：ICache预译码阵列1模块
- 所属单元：取指单元(IFU)
- 接口数量：输入10个，输出1个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
