# ct_idu_is_aiq0 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_aiq0 |
| 文件路径 | idu/rtl/ct_idu_is_aiq0.v |
| 功能描述 | 发射队列AIQ0 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq1_aiq_create0_entry | input | 8 | |
| aiq1_aiq_create1_entry | input | 8 | |
| biq_aiq_create0_entry | input | 12 | |
| biq_aiq_create1_entry | input | 12 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_iq_bypass_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_aiq0_create0_dp_en | input | 1 | |
| ctrl_aiq0_create0_en | input | 1 | |
| ctrl_aiq0_create0_gateclk_en | input | 1 | |
| ctrl_aiq0_create1_dp_en | input | 1 | |
| ctrl_aiq0_create1_en | input | 1 | |
| ctrl_aiq0_create1_gateclk_en | input | 1 | |
| ctrl_aiq0_rf_lch_fail_vld | input | 1 | |
| ctrl_aiq0_rf_pipe0_alu_reg_fwd_vld | input | 24 | |
| ctrl_aiq0_rf_pipe1_alu_reg_fwd_vld | input | 24 | |
| ctrl_aiq0_rf_pop_dlb_vld | input | 1 | |
| ctrl_aiq0_rf_pop_vld | input | 1 | |
| ctrl_aiq0_stall | input | 1 | |
| ctrl_aiq1_create0_dp_en | input | 1 | |
| ctrl_aiq1_create0_gateclk_en | input | 1 | |
| ctrl_aiq1_create1_dp_en | input | 1 | |
| ctrl_aiq1_create1_gateclk_en | input | 1 | |
| ctrl_biq_create0_dp_en | input | 1 | |
| ctrl_biq_create0_gateclk_en | input | 1 | |
| ctrl_biq_create1_dp_en | input | 1 | |
| ctrl_biq_create1_gateclk_en | input | 1 | |
| ctrl_dp_is_dis_aiq0_create0_sel | input | 2 | |
| ctrl_dp_is_dis_aiq0_create1_sel | input | 2 | |
| ... | ... | ... | 共102个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_aiq_create0_entry | output | 8 | |
| aiq0_aiq_create1_entry | output | 8 | |
| aiq0_ctrl_1_left_updt | output | 1 | |
| aiq0_ctrl_empty | output | 1 | |
| aiq0_ctrl_entry_cnt_updt_val | output | 4 | |
| aiq0_ctrl_entry_cnt_updt_vld | output | 1 | |
| aiq0_ctrl_full | output | 1 | |
| aiq0_ctrl_full_updt | output | 1 | |
| aiq0_ctrl_full_updt_clk_en | output | 1 | |
| aiq0_dp_issue_entry | output | 8 | |
| aiq0_dp_issue_read_data | output | 227 | |
| aiq0_top_aiq0_entry_cnt | output | 4 | |
| aiq0_xx_gateclk_issue_en | output | 1 | |
| aiq0_xx_issue_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_cnt_gated_clk |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry0 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry1 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry2 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry3 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry4 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry5 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry6 |
| ct_idu_is_aiq0_entry | x_ct_idu_is_aiq0_entry7 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
