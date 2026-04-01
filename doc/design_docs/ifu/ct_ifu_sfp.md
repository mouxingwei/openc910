# ct_ifu_sfp 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_sfp |
| 文件名称 | ct_ifu_sfp.v |
| 功能描述 | 顺序取指预测模块 |

### 1.2 功能描述

顺序取指预测模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_nsfe | input | 1 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| cp0_ifu_vsetvli_pred_mode | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_sfp_pc | input | 17 | - |
| rtu_ifu_chgflw_vld | input | 1 | - |
| rtu_ifu_retire_inst0_cur_pc | input | 39 | - |
| rtu_ifu_retire_inst0_load | input | 1 | - |
| rtu_ifu_retire_inst0_no_spec_hit | input | 1 | - |
| rtu_ifu_retire_inst0_no_spec_mispred | input | 1 | - |
| rtu_ifu_retire_inst0_no_spec_miss | input | 1 | - |
| rtu_ifu_retire_inst0_store | input | 1 | - |
| rtu_ifu_retire_inst0_vl_hit | input | 1 | - |
| rtu_ifu_retire_inst0_vl_mispred | input | 1 | - |
| rtu_ifu_retire_inst0_vl_miss | input | 1 | - |
| rtu_ifu_retire_inst0_vl_pred | input | 1 | - |
| rtu_ifu_retire_inst1_cur_pc | input | 39 | - |
| rtu_ifu_retire_inst1_load | input | 1 | - |
| rtu_ifu_retire_inst1_no_spec_hit | input | 1 | - |
| rtu_ifu_retire_inst1_no_spec_mispred | input | 1 | - |
| rtu_ifu_retire_inst1_no_spec_miss | input | 1 | - |
| rtu_ifu_retire_inst1_store | input | 1 | - |
| rtu_ifu_retire_inst1_vl_pred | input | 1 | - |
| rtu_ifu_retire_inst2_cur_pc | input | 39 | - |
| rtu_ifu_retire_inst2_load | input | 1 | - |
| rtu_ifu_retire_inst2_no_spec_hit | input | 1 | - |
| rtu_ifu_retire_inst2_no_spec_mispred | input | 1 | - |
| rtu_ifu_retire_inst2_no_spec_miss | input | 1 | - |
| rtu_ifu_retire_inst2_store | input | 1 | - |
| rtu_ifu_retire_inst2_vl_pred | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| sfp_ifdp_hit_pc_lo | output | 3 | - |
| sfp_ifdp_hit_type | output | 4 | - |
| sfp_ifdp_pc_hit | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| SF_RD | 1 | 2'b01 | - |
| BAR_RD | 1 | 2'b10 | - |
| SF | 1 | 0 | - |
| BAR | 1 | 1 | - |
| VL | 1 | 2 | - |
| VL_RAW | 1 | 3 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_write_en | 12 | - |
| sfp_bar_pc_lo | 3 | - |
| sfp_entry_fifo | 12 | - |
| sfp_fp_pc_lo | 3 | - |
| sfp_rd_cur_state | 2 | - |
| sfp_rd_next_state | 2 | - |
| sfp_sf_pc_record | 17 | - |
| sfp_wr_buf_inst_type | 3 | - |
| sfp_wr_buf_updt_pc | 20 | - |
| sfp_wr_buf_updt_type | 3 | - |
| wr_buf_inst_type_record | 3 | - |
| wr_buf_updt_pc_record | 20 | - |
| wr_buf_updt_type_record | 3 | - |
| wr_buf_updt_vld | 1 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_nsfe | 1 | - |
| cp0_ifu_vsetvli_pred_disable | 1 | - |
| cp0_ifu_vsetvli_pred_mode | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_bar_pc_0 | 12 | - |
| entry_bar_pc_1 | 12 | - |
| entry_bar_pc_10 | 12 | - |
| entry_bar_pc_11 | 12 | - |
| entry_bar_pc_2 | 12 | - |
| entry_bar_pc_3 | 12 | - |
| entry_bar_pc_4 | 12 | - |
| entry_bar_pc_5 | 12 | - |
| entry_bar_pc_6 | 12 | - |
| entry_bar_pc_7 | 12 | - |
| entry_bar_pc_8 | 12 | - |
| entry_bar_pc_9 | 12 | - |
| entry_bar_pc_updt_bit | 1 | - |
| entry_clk_en | 12 | - |
| entry_cnt_0 | 2 | - |
| entry_cnt_1 | 2 | - |
| entry_cnt_10 | 2 | - |
| entry_cnt_11 | 2 | - |
| entry_cnt_2 | 2 | - |
| entry_cnt_3 | 2 | - |
| entry_cnt_4 | 2 | - |
| entry_cnt_5 | 2 | - |
| entry_cnt_6 | 2 | - |
| entry_cnt_7 | 2 | - |

*注：共124个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：顺序取指预测模块
- 所属单元：取指单元(IFU)
- 接口数量：输入34个，输出3个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
