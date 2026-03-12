# ct_idu_is_viq0 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_viq0 |
| 文件路径 | idu/rtl/ct_idu_is_viq0.v |
| 功能描述 | 发射队列VIQ0 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_iq_bypass_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_dp_is_dis_viq0_create0_sel | input | 2 | |
| ctrl_dp_is_dis_viq0_create1_sel | input | 2 | |
| ctrl_dp_is_dis_viq1_create0_sel | input | 2 | |
| ctrl_dp_is_dis_viq1_create1_sel | input | 2 | |
| ctrl_viq0_create0_dp_en | input | 1 | |
| ctrl_viq0_create0_en | input | 1 | |
| ctrl_viq0_create0_gateclk_en | input | 1 | |
| ctrl_viq0_create1_dp_en | input | 1 | |
| ctrl_viq0_create1_en | input | 1 | |
| ctrl_viq0_create1_gateclk_en | input | 1 | |
| ctrl_viq0_rf_lch_fail_vld | input | 1 | |
| ctrl_viq0_rf_pipe6_vmla_vreg_fwd_vld | input | 8 | |
| ctrl_viq0_rf_pipe7_vmla_vreg_fwd_vld | input | 8 | |
| ctrl_viq0_rf_pop_dlb_vld | input | 1 | |
| ctrl_viq0_rf_pop_vld | input | 1 | |
| ctrl_viq0_stall | input | 1 | |
| ctrl_viq1_create0_dp_en | input | 1 | |
| ctrl_viq1_create0_gateclk_en | input | 1 | |
| ctrl_viq1_create1_dp_en | input | 1 | |
| ctrl_viq1_create1_gateclk_en | input | 1 | |
| ctrl_xx_rf_pipe6_vmla_lch_vld_dupx | input | 1 | |
| ctrl_xx_rf_pipe7_vmla_lch_vld_dupx | input | 1 | |
| dp_viq0_bypass_data | input | 151 | |
| dp_viq0_create0_data | input | 151 | |
| dp_viq0_create1_data | input | 151 | |
| dp_viq0_create_srcv0_rdy_for_bypass | input | 1 | |
| ... | ... | ... | 共77个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| viq0_ctrl_1_left_updt | output | 1 | |
| viq0_ctrl_empty | output | 1 | |
| viq0_ctrl_entry_cnt_updt_val | output | 4 | |
| viq0_ctrl_entry_cnt_updt_vld | output | 1 | |
| viq0_ctrl_full | output | 1 | |
| viq0_ctrl_full_updt | output | 1 | |
| viq0_ctrl_full_updt_clk_en | output | 1 | |
| viq0_dp_issue_entry | output | 8 | |
| viq0_dp_issue_read_data | output | 151 | |
| viq0_top_viq0_entry_cnt | output | 4 | |
| viq0_viq_create0_entry | output | 8 | |
| viq0_viq_create1_entry | output | 8 | |
| viq0_xx_gateclk_issue_en | output | 1 | |
| viq0_xx_issue_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_cnt_gated_clk |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry0 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry1 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry2 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry3 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry4 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry5 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry6 |
| ct_idu_is_viq0_entry | x_ct_idu_is_viq0_entry7 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
