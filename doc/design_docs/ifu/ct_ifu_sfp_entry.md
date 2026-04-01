# ct_ifu_sfp_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_sfp_entry |
| 文件名称 | ct_ifu_sfp_entry.v |
| 功能描述 | SFP表项模块 |

### 1.2 功能描述

SFP表项模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_nsfe | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| entry_bar_pc_updt_bit | input | 1 | - |
| entry_clk_en_x | input | 1 | - |
| entry_cnt_updt_bit | input | 1 | - |
| entry_sf_pc_updt_bit | input | 1 | - |
| entry_write_data | input | 25 | - |
| entry_write_en_x | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| rtu_ifu_chgflw_vld | input | 1 | - |
| sfp_vl_pred_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| entry_bar_pc_v | output | 12 | - |
| entry_cnt_v | output | 2 | - |
| entry_hi_pc_v | output | 8 | - |
| entry_sf_pc_v | output | 12 | - |
| entry_type_x | output | 1 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_bar_pc_v | 12 | - |
| entry_cnt_pre | 2 | - |
| entry_cnt_v | 2 | - |
| entry_hi_pc_v | 8 | - |
| entry_miss_state | 1 | - |
| entry_sf_pc_v | 12 | - |
| entry_type_x | 1 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cnt_add | 2 | - |
| cnt_sub | 2 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_nsfe | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_bar_pc_updt_bit | 1 | - |
| entry_bar_pc_updt_en | 1 | - |
| entry_clk_en_x | 1 | - |
| entry_cnt_updt_bit | 1 | - |
| entry_cnt_updt_en | 1 | - |
| entry_sf_pc_updt_bit | 1 | - |
| entry_sf_pc_updt_en | 1 | - |
| entry_write_data | 25 | - |
| entry_write_en_x | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_ifu_chgflw_vld | 1 | - |
| sfp_entry_clk | 1 | - |
| sfp_entry_clk_en | 1 | - |
| sfp_vl_pred_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：SFP表项模块
- 所属单元：取指单元(IFU)
- 接口数量：输入14个，输出5个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
