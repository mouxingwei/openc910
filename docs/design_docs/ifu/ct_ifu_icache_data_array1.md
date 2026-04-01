# ct_ifu_icache_data_array1 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_icache_data_array1 |
| 文件名称 | ct_ifu_icache_data_array1.v |
| 功能描述 | ICache数据阵列1模块 |

### 1.2 功能描述

ICache数据阵列1模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_yy_clk_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ifu_icache_data_array1_bank0_cen_b | input | 1 | - |
| ifu_icache_data_array1_bank0_clk_en | input | 1 | - |
| ifu_icache_data_array1_bank1_cen_b | input | 1 | - |
| ifu_icache_data_array1_bank1_clk_en | input | 1 | - |
| ifu_icache_data_array1_bank2_cen_b | input | 1 | - |
| ifu_icache_data_array1_bank2_clk_en | input | 1 | - |
| ifu_icache_data_array1_bank3_cen_b | input | 1 | - |
| ifu_icache_data_array1_bank3_clk_en | input | 1 | - |
| ifu_icache_data_array1_din | input | 128 | - |
| ifu_icache_data_array1_wen_b | input | 1 | - |
| ifu_icache_index | input | 16 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| icache_ifu_data_array1_dout | output | 128 | - |

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
| cp0_yy_clk_en | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| data_clk_bank0 | 1 | - |
| data_clk_bank1 | 1 | - |
| data_clk_bank2 | 1 | - |
| data_clk_bank3 | 1 | - |
| data_local_en_bank0 | 1 | - |
| data_local_en_bank1 | 1 | - |
| data_local_en_bank2 | 1 | - |
| data_local_en_bank3 | 1 | - |
| forever_cpuclk | 1 | - |
| icache_ifu_data_array1_bank0_dout | 32 | - |
| icache_ifu_data_array1_bank1_dout | 32 | - |
| icache_ifu_data_array1_bank2_dout | 32 | - |
| icache_ifu_data_array1_bank3_dout | 32 | - |
| icache_ifu_data_array1_dout | 128 | - |
| ifu_icache_data_array1_bank0_bwen | 32 | - |
| ifu_icache_data_array1_bank0_cen_b | 1 | - |
| ifu_icache_data_array1_bank0_clk_en | 1 | - |
| ifu_icache_data_array1_bank0_din | 32 | - |
| ifu_icache_data_array1_bank1_bwen | 32 | - |
| ifu_icache_data_array1_bank1_cen_b | 1 | - |
| ifu_icache_data_array1_bank1_clk_en | 1 | - |
| ifu_icache_data_array1_bank1_din | 32 | - |
| ifu_icache_data_array1_bank2_bwen | 32 | - |
| ifu_icache_data_array1_bank2_cen_b | 1 | - |
| ifu_icache_data_array1_bank2_clk_en | 1 | - |
| ifu_icache_data_array1_bank2_din | 32 | - |
| ifu_icache_data_array1_bank3_bwen | 32 | - |
| ifu_icache_data_array1_bank3_cen_b | 1 | - |

*注：共36个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：ICache数据阵列1模块
- 所属单元：取指单元(IFU)
- 接口数量：输入15个，输出1个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
