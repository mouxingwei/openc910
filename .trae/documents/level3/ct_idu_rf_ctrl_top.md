# ct_idu_rf_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_ctrl |
| 文件路径 | idu/rtl/ct_idu_rf_ctrl.v |
| 功能描述 | 寄存器文件控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_xx_gateclk_issue_en | input | 1 | |
| aiq0_xx_issue_en | input | 1 | |
| aiq1_xx_gateclk_issue_en | input | 1 | |
| aiq1_xx_issue_en | input | 1 | |
| biq_xx_gateclk_issue_en | input | 1 | |
| biq_xx_issue_en | input | 1 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dp_ctrl_is_aiq0_issue_alu_short | input | 1 | |
| dp_ctrl_is_aiq0_issue_div | input | 1 | |
| dp_ctrl_is_aiq0_issue_dst_vld | input | 1 | |
| dp_ctrl_is_aiq0_issue_lch_preg | input | 1 | |
| dp_ctrl_is_aiq0_issue_lch_rdy | input | 108 | |
| dp_ctrl_is_aiq0_issue_special | input | 1 | |
| dp_ctrl_is_aiq1_issue_alu_short | input | 1 | |
| dp_ctrl_is_aiq1_issue_dst_vld | input | 1 | |
| dp_ctrl_is_aiq1_issue_lch_preg | input | 1 | |
| dp_ctrl_is_aiq1_issue_lch_rdy | input | 108 | |
| dp_ctrl_is_aiq1_issue_mla_lch_rdy | input | 8 | |
| dp_ctrl_is_aiq1_issue_mla_vld | input | 1 | |
| dp_ctrl_is_viq0_issue_dstv_vld | input | 1 | |
| dp_ctrl_is_viq0_issue_lch_rdy | input | 16 | |
| dp_ctrl_is_viq0_issue_vdiv | input | 1 | |
| dp_ctrl_is_viq0_issue_vmla_rf | input | 1 | |
| dp_ctrl_is_viq0_issue_vmla_short | input | 1 | |
| dp_ctrl_is_viq1_issue_dstv_vld | input | 1 | |
| dp_ctrl_is_viq1_issue_lch_rdy | input | 16 | |
| dp_ctrl_is_viq1_issue_vmla_rf | input | 1 | |
| dp_ctrl_is_viq1_issue_vmla_short | input | 1 | |
| ... | ... | ... | 共73个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_aiq0_rf_lch_fail_vld | output | 1 | |
| ctrl_aiq0_rf_pipe0_alu_reg_fwd_vld | output | 24 | |
| ctrl_aiq0_rf_pipe1_alu_reg_fwd_vld | output | 24 | |
| ctrl_aiq0_rf_pop_dlb_vld | output | 1 | |
| ctrl_aiq0_rf_pop_vld | output | 1 | |
| ctrl_aiq0_stall | output | 1 | |
| ctrl_aiq1_rf_lch_fail_vld | output | 1 | |
| ctrl_aiq1_rf_pipe0_alu_reg_fwd_vld | output | 24 | |
| ctrl_aiq1_rf_pipe1_alu_reg_fwd_vld | output | 24 | |
| ctrl_aiq1_rf_pipe1_mla_reg_lch_vld | output | 8 | |
| ctrl_aiq1_rf_pop_dlb_vld | output | 1 | |
| ctrl_aiq1_rf_pop_vld | output | 1 | |
| ctrl_aiq1_stall | output | 1 | |
| ctrl_biq_rf_lch_fail_vld | output | 1 | |
| ctrl_biq_rf_pipe0_alu_reg_fwd_vld | output | 24 | |
| ctrl_biq_rf_pipe1_alu_reg_fwd_vld | output | 24 | |
| ctrl_biq_rf_pop_vld | output | 1 | |
| ctrl_dp_rf_pipe0_other_lch_fail | output | 1 | |
| ctrl_dp_rf_pipe3_other_lch_fail | output | 1 | |
| ctrl_dp_rf_pipe4_other_lch_fail | output | 1 | |
| ctrl_dp_rf_pipe5_other_lch_fail | output | 1 | |
| ctrl_dp_rf_pipe6_other_lch_fail | output | 1 | |
| ctrl_dp_rf_pipe7_other_lch_fail | output | 1 | |
| ctrl_lsiq_rf_pipe0_alu_reg_fwd_vld | output | 24 | |
| ctrl_lsiq_rf_pipe1_alu_reg_fwd_vld | output | 24 | |
| ctrl_lsiq_rf_pipe3_lch_fail_vld | output | 1 | |
| ctrl_lsiq_rf_pipe4_lch_fail_vld | output | 1 | |
| ctrl_sdiq_rf_lch_fail_vld | output | 1 | |
| ctrl_sdiq_rf_pipe0_alu_reg_fwd_vld | output | 12 | |
| ctrl_sdiq_rf_pipe1_alu_reg_fwd_vld | output | 12 | |
| ... | ... | ... | 共111个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_rf_inst_gated_clk |
| gated_clk_cell | x_rf_inst0_gated_clk |
| gated_clk_cell | x_rf_inst1_gated_clk |
| gated_clk_cell | x_rf_inst6_gated_clk |
| gated_clk_cell | x_rf_inst7_gated_clk |
| gated_clk_cell | x_hpcp_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
