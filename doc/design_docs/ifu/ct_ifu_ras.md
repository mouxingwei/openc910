# ct_ifu_ras 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ras |
| 文件名称 | ct_ifu_ras.v |
| 功能描述 | 返回地址栈模块 |

### 1.2 功能描述

返回地址栈模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_ras_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cp0_yy_priv_mode | input | 2 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibctrl_ras_inst_pcall | input | 1 | - |
| ibctrl_ras_pcall_vld | input | 1 | - |
| ibctrl_ras_pcall_vld_for_gateclk | input | 1 | - |
| ibctrl_ras_preturn_vld | input | 1 | - |
| ibctrl_ras_preturn_vld_for_gateclk | input | 1 | - |
| ibdp_ras_push_pc | input | 39 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| rtu_ifu_flush | input | 1 | - |
| rtu_ifu_retire0_inc_pc | input | 39 | - |
| rtu_ifu_retire0_mispred | input | 1 | - |
| rtu_ifu_retire0_pcall | input | 1 | - |
| rtu_ifu_retire0_preturn | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ras_ipdp_data_vld | output | 1 | - |
| ras_ipdp_pc | output | 39 | - |
| ras_l0_btb_pc | output | 39 | - |
| ras_l0_btb_push_pc | output | 39 | - |
| ras_l0_btb_ras_push | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ras_entry0_filled | 1 | - |
| ras_entry0_pc | 39 | - |
| ras_entry0_priv_mode | 2 | - |
| ras_entry10_filled | 1 | - |
| ras_entry10_pc | 39 | - |
| ras_entry10_priv_mode | 2 | - |
| ras_entry11_filled | 1 | - |
| ras_entry11_pc | 39 | - |
| ras_entry11_priv_mode | 2 | - |
| ras_entry1_filled | 1 | - |
| ras_entry1_pc | 39 | - |
| ras_entry1_priv_mode | 2 | - |
| ras_entry2_filled | 1 | - |
| ras_entry2_pc | 39 | - |
| ras_entry2_priv_mode | 2 | - |
| ras_entry3_filled | 1 | - |
| ras_entry3_pc | 39 | - |
| ras_entry3_priv_mode | 2 | - |
| ras_entry4_filled | 1 | - |
| ras_entry4_pc | 39 | - |
| ras_entry4_priv_mode | 2 | - |
| ras_entry5_filled | 1 | - |
| ras_entry5_pc | 39 | - |
| ras_entry5_priv_mode | 2 | - |
| ras_entry6_filled | 1 | - |
| ras_entry6_pc | 39 | - |
| ras_entry6_priv_mode | 2 | - |
| ras_entry7_filled | 1 | - |
| ras_entry7_pc | 39 | - |
| ras_entry7_priv_mode | 2 | - |

*注：共63个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_ras_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| entry0_push | 1 | - |
| entry10_push | 1 | - |
| entry11_push | 1 | - |
| entry1_push | 1 | - |
| entry2_push | 1 | - |
| entry3_push | 1 | - |
| entry4_push | 1 | - |
| entry5_push | 1 | - |
| entry6_push | 1 | - |
| entry7_push | 1 | - |
| entry8_push | 1 | - |
| entry9_push | 1 | - |
| forever_cpuclk | 1 | - |
| ibctrl_ras_inst_pcall | 1 | - |
| ibctrl_ras_pcall_vld | 1 | - |
| ibctrl_ras_pcall_vld_for_gateclk | 1 | - |
| ibctrl_ras_preturn_vld | 1 | - |
| ibctrl_ras_preturn_vld_for_gateclk | 1 | - |
| ibdp_ras_push_pc | 39 | - |
| pad_yy_icg_scan_en | 1 | - |
| ras_empty | 1 | - |
| ras_entry0_upd_clk | 1 | - |
| ras_entry0_upd_clk_en | 1 | - |
| ras_entry10_upd_clk | 1 | - |
| ras_entry10_upd_clk_en | 1 | - |

*注：共112个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：返回地址栈模块
- 所属单元：取指单元(IFU)
- 接口数量：输入18个，输出5个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
