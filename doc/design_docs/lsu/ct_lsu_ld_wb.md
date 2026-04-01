# ct_lsu_ld_wb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_wb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_ld_wb.v |
| 功能描述 | Load Write Back - 加载写回阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 56
- 输出端口数量: 63
- 子模块实例数量: 12

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_ld_clk | 1 | - |
| forever_cpuclk | 1 | - |
| had_lsu_bus_trace_en | 1 | - |
| had_lsu_dbg_en | 1 | - |
| ld_da_addr | 40 | - |
| ld_da_bkpta_data | 1 | - |
| ld_da_bkptb_data | 1 | - |
| ld_da_iid | 7 | - |
| ld_da_inst_vfls | 1 | - |
| ld_da_inst_vld | 1 | - |
| ld_da_preg | 7 | - |
| ld_da_preg_sign_sel | 4 | - |
| ld_da_vreg | 6 | - |
| ld_da_wb_cmplt_req | 1 | - |
| ld_da_wb_data | 64 | - |
| ld_da_wb_data_req | 1 | - |
| ld_da_wb_data_req_gateclk_en | 1 | - |
| ld_da_wb_expt_vec | 5 | - |
| ld_da_wb_expt_vld | 1 | - |
| ld_da_wb_mt_value | 40 | - |
| ld_da_wb_no_spec_hit | 1 | - |
| ld_da_wb_no_spec_mispred | 1 | - |
| ld_da_wb_no_spec_miss | 1 | - |
| ld_da_wb_spec_fail | 1 | - |
| ld_da_wb_vreg_sign_sel | 2 | - |
| pad_yy_icg_scan_en | 1 | - |
| rb_ld_wb_bkpta_data | 1 | - |
| ... | ... | 还有 26 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ld_wb_data_vld | 1 | - |
| ld_wb_inst_vld | 1 | - |
| ld_wb_rb_cmplt_grnt | 1 | - |
| ld_wb_rb_data_grnt | 1 | - |
| ld_wb_wmb_data_grnt | 1 | - |
| lsu_had_ld_addr | 40 | - |
| lsu_had_ld_data | 64 | - |
| lsu_had_ld_iid | 7 | - |
| lsu_had_ld_req | 1 | - |
| lsu_had_ld_type | 4 | - |
| lsu_idu_wb_pipe3_fwd_vreg | 7 | - |
| lsu_idu_wb_pipe3_fwd_vreg_vld | 1 | - |
| lsu_idu_wb_pipe3_wb_preg | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_data | 64 | - |
| lsu_idu_wb_pipe3_wb_preg_dup0 | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_dup1 | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_dup2 | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_dup3 | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_dup4 | 7 | - |
| lsu_idu_wb_pipe3_wb_preg_expand | 96 | - |
| lsu_idu_wb_pipe3_wb_preg_vld | 1 | - |
| lsu_idu_wb_pipe3_wb_preg_vld_dup0 | 1 | - |
| lsu_idu_wb_pipe3_wb_preg_vld_dup1 | 1 | - |
| lsu_idu_wb_pipe3_wb_preg_vld_dup2 | 1 | - |
| lsu_idu_wb_pipe3_wb_preg_vld_dup3 | 1 | - |
| lsu_idu_wb_pipe3_wb_preg_vld_dup4 | 1 | - |
| lsu_idu_wb_pipe3_wb_vreg_dup0 | 7 | - |
| lsu_idu_wb_pipe3_wb_vreg_dup1 | 7 | - |
| lsu_idu_wb_pipe3_wb_vreg_dup2 | 7 | - |
| lsu_idu_wb_pipe3_wb_vreg_dup3 | 7 | - |
| ... | ... | 还有 33 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| ct_rtu_expand_96 | x_lsu_ld_da_preg_expand, x_lsu_wmb_ld_wb_preg_expand, x_lsu_rb_ld_wb_preg_expand | - |
| ct_rtu_expand_64 | x_lsu_ld_da_vreg_expand, x_lsu_wmb_ld_wb_vreg_expand, x_lsu_rb_ld_wb_vreg_expand | - |
| gated_clk_cell | x_lsu_ld_wb_cmplt_gated_clk, x_lsu_ld_wb_expt_gated_clk, x_lsu_ld_wb_data_gated_clk ... (6个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_ld_wb 模块实现了Load Write Back - 加载写回阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
