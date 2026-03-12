# ct_lsu_st_wb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_wb |
| 文件路径 | lsu/rtl/ct_lsu_st_wb.v |
| 功能描述 | 存储写回 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_st_clk | input | 1 | |
| forever_cpuclk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |
| st_da_bkpta_data | input | 1 | |
| st_da_bkptb_data | input | 1 | |
| st_da_iid | input | 7 | |
| st_da_inst_vld | input | 1 | |
| st_da_wb_cmplt_req | input | 1 | |
| st_da_wb_expt_vec | input | 5 | |
| st_da_wb_expt_vld | input | 1 | |
| st_da_wb_mt_value | input | 40 | |
| st_da_wb_no_spec_hit | input | 1 | |
| st_da_wb_no_spec_mispred | input | 1 | |
| st_da_wb_no_spec_miss | input | 1 | |
| st_da_wb_spec_fail | input | 1 | |
| wmb_st_wb_bkpta_data | input | 1 | |
| wmb_st_wb_bkptb_data | input | 1 | |
| wmb_st_wb_cmplt_req | input | 1 | |
| wmb_st_wb_iid | input | 7 | |
| wmb_st_wb_inst_flush | input | 1 | |
| wmb_st_wb_spec_fail | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_rtu_wb_pipe4_abnormal | output | 1 | |
| lsu_rtu_wb_pipe4_bkpta_data | output | 1 | |
| lsu_rtu_wb_pipe4_bkptb_data | output | 1 | |
| lsu_rtu_wb_pipe4_cmplt | output | 1 | |
| lsu_rtu_wb_pipe4_expt_vec | output | 5 | |
| lsu_rtu_wb_pipe4_expt_vld | output | 1 | |
| lsu_rtu_wb_pipe4_flush | output | 1 | |
| lsu_rtu_wb_pipe4_iid | output | 7 | |
| lsu_rtu_wb_pipe4_mtval | output | 40 | |
| lsu_rtu_wb_pipe4_no_spec_hit | output | 1 | |
| lsu_rtu_wb_pipe4_no_spec_mispred | output | 1 | |
| lsu_rtu_wb_pipe4_no_spec_miss | output | 1 | |
| lsu_rtu_wb_pipe4_spec_fail | output | 1 | |
| st_wb_inst_vld | output | 1 | |
| st_wb_wmb_cmplt_grnt | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_st_wb_cmplt_gated_clk |
| gated_clk_cell | x_lsu_st_wb_expt_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
