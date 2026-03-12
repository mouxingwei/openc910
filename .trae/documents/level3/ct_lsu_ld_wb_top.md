# ct_lsu_ld_wb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_wb |
| 文件路径 | lsu/rtl/ct_lsu_ld_wb.v |
| 功能描述 | 加载写回 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ld_clk | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_lsu_bus_trace_en | input | 1 | |
| had_lsu_dbg_en | input | 1 | |
| ld_da_addr | input | 40 | |
| ld_da_bkpta_data | input | 1 | |
| ld_da_bkptb_data | input | 1 | |
| ld_da_iid | input | 7 | |
| ld_da_inst_vfls | input | 1 | |
| ld_da_inst_vld | input | 1 | |
| ld_da_preg | input | 7 | |
| ld_da_preg_sign_sel | input | 4 | |
| ld_da_vreg | input | 6 | |
| ld_da_wb_cmplt_req | input | 1 | |
| ld_da_wb_data | input | 64 | |
| ld_da_wb_data_req | input | 1 | |
| ld_da_wb_data_req_gateclk_en | input | 1 | |
| ld_da_wb_expt_vec | input | 5 | |
| ld_da_wb_expt_vld | input | 1 | |
| ld_da_wb_mt_value | input | 40 | |
| ld_da_wb_no_spec_hit | input | 1 | |
| ld_da_wb_no_spec_mispred | input | 1 | |
| ld_da_wb_no_spec_miss | input | 1 | |
| ld_da_wb_spec_fail | input | 1 | |
| ld_da_wb_vreg_sign_sel | input | 2 | |
| pad_yy_icg_scan_en | input | 1 | |
| rb_ld_wb_bkpta_data | input | 1 | |
| ... | ... | ... | 共56个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ld_wb_data_vld | output | 1 | |
| ld_wb_inst_vld | output | 1 | |
| ld_wb_rb_cmplt_grnt | output | 1 | |
| ld_wb_rb_data_grnt | output | 1 | |
| ld_wb_wmb_data_grnt | output | 1 | |
| lsu_had_ld_addr | output | 40 | |
| lsu_had_ld_data | output | 64 | |
| lsu_had_ld_iid | output | 7 | |
| lsu_had_ld_req | output | 1 | |
| lsu_had_ld_type | output | 4 | |
| lsu_idu_wb_pipe3_fwd_vreg | output | 7 | |
| lsu_idu_wb_pipe3_fwd_vreg_vld | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_data | output | 64 | |
| lsu_idu_wb_pipe3_wb_preg_dup0 | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_dup1 | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_dup2 | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_dup3 | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_dup4 | output | 7 | |
| lsu_idu_wb_pipe3_wb_preg_expand | output | 96 | |
| lsu_idu_wb_pipe3_wb_preg_vld | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg_vld_dup0 | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg_vld_dup1 | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg_vld_dup2 | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg_vld_dup3 | output | 1 | |
| lsu_idu_wb_pipe3_wb_preg_vld_dup4 | output | 1 | |
| lsu_idu_wb_pipe3_wb_vreg_dup0 | output | 7 | |
| lsu_idu_wb_pipe3_wb_vreg_dup1 | output | 7 | |
| lsu_idu_wb_pipe3_wb_vreg_dup2 | output | 7 | |
| lsu_idu_wb_pipe3_wb_vreg_dup3 | output | 7 | |
| ... | ... | ... | 共63个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_rtu_expand_96 | x_lsu_ld_da_preg_expand |
| ct_rtu_expand_96 | x_lsu_wmb_ld_wb_preg_expand |
| ct_rtu_expand_96 | x_lsu_rb_ld_wb_preg_expand |
| ct_rtu_expand_64 | x_lsu_ld_da_vreg_expand |
| ct_rtu_expand_64 | x_lsu_wmb_ld_wb_vreg_expand |
| ct_rtu_expand_64 | x_lsu_rb_ld_wb_vreg_expand |
| gated_clk_cell | x_lsu_ld_wb_cmplt_gated_clk |
| gated_clk_cell | x_lsu_ld_wb_expt_gated_clk |
| gated_clk_cell | x_lsu_ld_wb_data_gated_clk |
| gated_clk_cell | x_lsu_ld_wb_preg_gated_clk |
| gated_clk_cell | x_lsu_ld_wb_vreg_gated_clk |
| gated_clk_cell | x_lsu_wb_dbg_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
