# ct_idu_is_biq 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_biq |
| 文件路径 | idu/rtl/ct_idu_is_biq.v |
| 功能描述 | 发射队列BIQ |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_iq_bypass_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_biq_create0_dp_en | input | 1 | |
| ctrl_biq_create0_en | input | 1 | |
| ctrl_biq_create0_gateclk_en | input | 1 | |
| ctrl_biq_create1_dp_en | input | 1 | |
| ctrl_biq_create1_en | input | 1 | |
| ctrl_biq_create1_gateclk_en | input | 1 | |
| ctrl_biq_rf_lch_fail_vld | input | 1 | |
| ctrl_biq_rf_pipe0_alu_reg_fwd_vld | input | 24 | |
| ctrl_biq_rf_pipe1_alu_reg_fwd_vld | input | 24 | |
| ctrl_biq_rf_pop_vld | input | 1 | |
| ctrl_xx_rf_pipe0_preg_lch_vld_dupx | input | 1 | |
| ctrl_xx_rf_pipe1_preg_lch_vld_dupx | input | 1 | |
| dp_biq_bypass_data | input | 82 | |
| dp_biq_create0_data | input | 82 | |
| dp_biq_create1_data | input | 82 | |
| dp_biq_create_src0_rdy_for_bypass | input | 1 | |
| dp_biq_create_src1_rdy_for_bypass | input | 1 | |
| dp_biq_rf_lch_entry | input | 12 | |
| dp_biq_rf_rdy_clr | input | 2 | |
| dp_xx_rf_pipe0_dst_preg_dupx | input | 7 | |
| dp_xx_rf_pipe1_dst_preg_dupx | input | 7 | |
| forever_cpuclk | input | 1 | |
| iu_idu_div_inst_vld | input | 1 | |
| iu_idu_div_preg_dupx | input | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dupx | input | 7 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dupx | input | 1 | |
| ... | ... | ... | 共49个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biq_aiq_create0_entry | output | 12 | |
| biq_aiq_create1_entry | output | 12 | |
| biq_ctrl_1_left_updt | output | 1 | |
| biq_ctrl_empty | output | 1 | |
| biq_ctrl_full | output | 1 | |
| biq_ctrl_full_updt | output | 1 | |
| biq_ctrl_full_updt_clk_en | output | 1 | |
| biq_dp_issue_entry | output | 12 | |
| biq_dp_issue_read_data | output | 82 | |
| biq_top_biq_entry_cnt | output | 4 | |
| biq_xx_gateclk_issue_en | output | 1 | |
| biq_xx_issue_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_cnt_gated_clk |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry0 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry1 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry2 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry3 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry4 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry5 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry6 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry7 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry8 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry9 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry10 |
| ct_idu_is_biq_entry | x_ct_idu_is_biq_entry11 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
