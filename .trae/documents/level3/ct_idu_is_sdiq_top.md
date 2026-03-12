# ct_idu_is_sdiq 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_sdiq |
| 文件路径 | idu/rtl/ct_idu_is_sdiq.v |
| 功能描述 | 发射队列SDIQ |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_sdiq_create0_dp_en | input | 1 | |
| ctrl_sdiq_create0_en | input | 1 | |
| ctrl_sdiq_create0_gateclk_en | input | 1 | |
| ctrl_sdiq_create1_dp_en | input | 1 | |
| ctrl_sdiq_create1_en | input | 1 | |
| ctrl_sdiq_create1_gateclk_en | input | 1 | |
| ctrl_sdiq_rf_lch_fail_vld | input | 1 | |
| ctrl_sdiq_rf_pipe0_alu_reg_fwd_vld | input | 12 | |
| ctrl_sdiq_rf_pipe1_alu_reg_fwd_vld | input | 12 | |
| ctrl_sdiq_rf_staddr_rdy_set | input | 1 | |
| ctrl_xx_rf_pipe0_preg_lch_vld_dupx | input | 1 | |
| ctrl_xx_rf_pipe1_preg_lch_vld_dupx | input | 1 | |
| dp_sdiq_create0_data | input | 27 | |
| dp_sdiq_create1_data | input | 27 | |
| dp_sdiq_rf_lch_entry | input | 12 | |
| dp_sdiq_rf_rdy_clr | input | 2 | |
| dp_sdiq_rf_sdiq_entry | input | 12 | |
| dp_sdiq_rf_staddr1_vld | input | 1 | |
| dp_sdiq_rf_staddr_rdy_clr | input | 1 | |
| dp_sdiq_rf_stdata1_vld | input | 1 | |
| dp_xx_rf_pipe0_dst_preg_dupx | input | 7 | |
| dp_xx_rf_pipe1_dst_preg_dupx | input | 7 | |
| forever_cpuclk | input | 1 | |
| iu_idu_div_inst_vld | input | 1 | |
| iu_idu_div_preg_dupx | input | 7 | |
| iu_idu_ex2_pipe0_wb_preg_dupx | input | 7 | |
| iu_idu_ex2_pipe0_wb_preg_vld_dupx | input | 1 | |
| ... | ... | ... | 共77个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| idu_rtu_pst_freg_dealloc_mask | output | 64 | |
| idu_rtu_pst_preg_dealloc_mask | output | 96 | |
| idu_rtu_pst_vreg_dealloc_mask | output | 64 | |
| sdiq_aiq_create0_entry | output | 12 | |
| sdiq_aiq_create1_entry | output | 12 | |
| sdiq_ctrl_1_left_updt | output | 1 | |
| sdiq_ctrl_empty | output | 1 | |
| sdiq_ctrl_full | output | 1 | |
| sdiq_ctrl_full_updt | output | 1 | |
| sdiq_ctrl_full_updt_clk_en | output | 1 | |
| sdiq_dp_create0_entry | output | 12 | |
| sdiq_dp_create1_entry | output | 12 | |
| sdiq_dp_issue_entry | output | 12 | |
| sdiq_dp_issue_read_data | output | 27 | |
| sdiq_top_sdiq_entry_cnt | output | 4 | |
| sdiq_xx_gateclk_issue_en | output | 1 | |
| sdiq_xx_issue_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_cnt_gated_clk |
| gated_clk_cell | x_src_mask_gated_clk |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry0 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry1 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry2 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry3 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry4 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry5 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry6 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry7 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry8 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry9 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry10 |
| ct_idu_is_sdiq_entry | x_ct_idu_is_sdiq_entry11 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
