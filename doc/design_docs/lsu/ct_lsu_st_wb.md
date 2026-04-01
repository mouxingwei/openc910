# ct_lsu_st_wb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_wb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_st_wb.v |
| 功能描述 | Store Write Back - 存储写回阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 25
- 输出端口数量: 15
- 子模块实例数量: 2

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_st_clk | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_yy_xx_flush | 1 | - |
| st_da_bkpta_data | 1 | - |
| st_da_bkptb_data | 1 | - |
| st_da_iid | 7 | - |
| st_da_inst_vld | 1 | - |
| st_da_wb_cmplt_req | 1 | - |
| st_da_wb_expt_vec | 5 | - |
| st_da_wb_expt_vld | 1 | - |
| st_da_wb_mt_value | 40 | - |
| st_da_wb_no_spec_hit | 1 | - |
| st_da_wb_no_spec_mispred | 1 | - |
| st_da_wb_no_spec_miss | 1 | - |
| st_da_wb_spec_fail | 1 | - |
| wmb_st_wb_bkpta_data | 1 | - |
| wmb_st_wb_bkptb_data | 1 | - |
| wmb_st_wb_cmplt_req | 1 | - |
| wmb_st_wb_iid | 7 | - |
| wmb_st_wb_inst_flush | 1 | - |
| wmb_st_wb_spec_fail | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_rtu_wb_pipe4_abnormal | 1 | - |
| lsu_rtu_wb_pipe4_bkpta_data | 1 | - |
| lsu_rtu_wb_pipe4_bkptb_data | 1 | - |
| lsu_rtu_wb_pipe4_cmplt | 1 | - |
| lsu_rtu_wb_pipe4_expt_vec | 5 | - |
| lsu_rtu_wb_pipe4_expt_vld | 1 | - |
| lsu_rtu_wb_pipe4_flush | 1 | - |
| lsu_rtu_wb_pipe4_iid | 7 | - |
| lsu_rtu_wb_pipe4_mtval | 40 | - |
| lsu_rtu_wb_pipe4_no_spec_hit | 1 | - |
| lsu_rtu_wb_pipe4_no_spec_mispred | 1 | - |
| lsu_rtu_wb_pipe4_no_spec_miss | 1 | - |
| lsu_rtu_wb_pipe4_spec_fail | 1 | - |
| st_wb_inst_vld | 1 | - |
| st_wb_wmb_cmplt_grnt | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_st_wb_cmplt_gated_clk, x_lsu_st_wb_expt_gated_clk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_st_wb 模块实现了Store Write Back - 存储写回阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
