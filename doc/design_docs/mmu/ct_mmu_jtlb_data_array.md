# ct_mmu_jtlb_data_array 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_jtlb_data_array |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_jtlb_data_array.v |
| 功能描述 | Joint TLB - 联合TLB |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 8
- 输出端口数量: 2
- 子模块实例数量: 3

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_mmu_icg_en | 1 | - |
| forever_cpuclk | 1 | - |
| jtlb_data_cen0 | 1 | - |
| jtlb_data_cen1 | 1 | - |
| jtlb_data_din | 84 | - |
| jtlb_data_idx | 8 | - |
| jtlb_data_wen | 4 | - |
| pad_yy_icg_scan_en | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| jtlb_data_dout0 | 84 | - |
| jtlb_data_dout1 | 84 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_jtlb_data_gateclk | - |
| ct_spsram_256x84 | x_ct_spsram_256x84_bank1, x_ct_spsram_256x84_bank0 | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_jtlb_data_array 模块实现了Joint TLB - 联合TLB的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
