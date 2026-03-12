# ct_idu_is_lsiq 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_lsiq |
| 文件路径 | idu/rtl/ct_idu_is_lsiq.v |
| 功能描述 | 发射队列LSIQ |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_iq_bypass_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_lsiq_create0_dp_en | input | 1 | |
| ctrl_lsiq_create0_en | input | 1 | |
| ctrl_lsiq_create0_gateclk_en | input | 1 | |
| ctrl_lsiq_create1_dp_en | input | 1 | |
| ctrl_lsiq_create1_en | input | 1 | |
| ctrl_lsiq_create1_gateclk_en | input | 1 | |
| ctrl_lsiq_ir_bar_inst_vld | input | 1 | |
| ctrl_lsiq_is_bar_inst_vld | input | 1 | |
| ctrl_lsiq_rf_pipe0_alu_reg_fwd_vld | input | 24 | |
| ctrl_lsiq_rf_pipe1_alu_reg_fwd_vld | input | 24 | |
| ctrl_lsiq_rf_pipe3_lch_fail_vld | input | 1 | |
| ctrl_lsiq_rf_pipe4_lch_fail_vld | input | 1 | |
| ctrl_xx_rf_pipe0_preg_lch_vld_dupx | input | 1 | |
| ctrl_xx_rf_pipe1_preg_lch_vld_dupx | input | 1 | |
| dp_lsiq_bypass_data | input | 163 | |
| dp_lsiq_create0_bar | input | 1 | |
| dp_lsiq_create0_data | input | 163 | |
| dp_lsiq_create0_load | input | 1 | |
| dp_lsiq_create0_no_spec | input | 1 | |
| dp_lsiq_create0_src0_rdy_for_bypass | input | 1 | |
| dp_lsiq_create0_src1_rdy_for_bypass | input | 1 | |
| dp_lsiq_create0_srcvm_rdy_for_bypass | input | 1 | |
| dp_lsiq_create0_store | input | 1 | |
| dp_lsiq_create1_bar | input | 1 | |
| dp_lsiq_create1_data | input | 163 | |
| dp_lsiq_create1_load | input | 1 | |
| ... | ... | ... | 共101个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsiq_aiq_create0_entry | output | 12 | |
| lsiq_aiq_create1_entry | output | 12 | |
| lsiq_ctrl_1_left_updt | output | 1 | |
| lsiq_ctrl_empty | output | 1 | |
| lsiq_ctrl_full | output | 1 | |
| lsiq_ctrl_full_updt | output | 1 | |
| lsiq_ctrl_full_updt_clk_en | output | 1 | |
| lsiq_dp_create_bypass_oldest | output | 1 | |
| lsiq_dp_no_spec_store_vld | output | 1 | |
| lsiq_dp_pipe3_issue_entry | output | 12 | |
| lsiq_dp_pipe3_issue_read_data | output | 163 | |
| lsiq_dp_pipe4_issue_entry | output | 12 | |
| lsiq_dp_pipe4_issue_read_data | output | 163 | |
| lsiq_top_frz_entry_vld | output | 1 | |
| lsiq_top_lsiq_entry_cnt | output | 4 | |
| lsiq_xx_gateclk_issue_en | output | 1 | |
| lsiq_xx_pipe3_issue_en | output | 1 | |
| lsiq_xx_pipe4_issue_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lq_full_gated_clk |
| gated_clk_cell | x_sq_full_gated_clk |
| gated_clk_cell | x_rb_full_gated_clk |
| gated_clk_cell | x_tlb_busy_gated_clk |
| gated_clk_cell | x_wait_old_gated_clk |
| gated_clk_cell | x_wait_fence_gated_clk |
| gated_clk_cell | x_bar_gated_clk |
| gated_clk_cell | x_cnt_gated_clk |
| same | type |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry0 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry1 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry2 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry3 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry4 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry5 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry6 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry7 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry8 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry9 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry10 |
| ct_idu_is_lsiq_entry | x_ct_idu_is_lsiq_entry11 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
