# ct_idu_rf_dp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_dp |
| 文件路径 | idu/rtl/ct_idu_rf_dp.v |
| 功能描述 | 寄存器文件数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_dp_issue_entry | input | 8 | |
| aiq0_dp_issue_read_data | input | 227 | |
| aiq0_xx_gateclk_issue_en | input | 1 | |
| aiq0_xx_issue_en | input | 1 | |
| aiq1_dp_issue_entry | input | 8 | |
| aiq1_dp_issue_read_data | input | 214 | |
| aiq1_xx_gateclk_issue_en | input | 1 | |
| aiq1_xx_issue_en | input | 1 | |
| biq_dp_issue_entry | input | 12 | |
| biq_dp_issue_read_data | input | 82 | |
| biq_xx_gateclk_issue_en | input | 1 | |
| biq_xx_issue_en | input | 1 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_lsu_fencei_broad_dis | input | 1 | |
| cp0_lsu_fencerw_broad_dis | input | 1 | |
| cp0_lsu_tlb_broad_dis | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_dp_rf_pipe0_other_lch_fail | input | 1 | |
| ctrl_dp_rf_pipe3_other_lch_fail | input | 1 | |
| ctrl_dp_rf_pipe4_other_lch_fail | input | 1 | |
| ctrl_dp_rf_pipe5_other_lch_fail | input | 1 | |
| ctrl_dp_rf_pipe6_other_lch_fail | input | 1 | |
| ctrl_dp_rf_pipe7_other_lch_fail | input | 1 | |
| forever_cpuclk | input | 1 | |
| fwd_dp_rf_pipe0_src0_data | input | 64 | |
| fwd_dp_rf_pipe0_src0_no_fwd | input | 1 | |
| fwd_dp_rf_pipe0_src1_data | input | 64 | |
| fwd_dp_rf_pipe0_src1_no_fwd | input | 1 | |
| fwd_dp_rf_pipe1_src0_data | input | 64 | |
| ... | ... | ... | 共152个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dp_aiq0_rf_lch_entry | output | 8 | |
| dp_aiq0_rf_rdy_clr | output | 3 | |
| dp_aiq1_rf_lch_entry | output | 8 | |
| dp_aiq1_rf_rdy_clr | output | 3 | |
| dp_biq_rf_lch_entry | output | 12 | |
| dp_biq_rf_rdy_clr | output | 2 | |
| dp_ctrl_is_aiq0_issue_alu_short | output | 1 | |
| dp_ctrl_is_aiq0_issue_div | output | 1 | |
| dp_ctrl_is_aiq0_issue_dst_vld | output | 1 | |
| dp_ctrl_is_aiq0_issue_lch_preg | output | 1 | |
| dp_ctrl_is_aiq0_issue_lch_rdy | output | 108 | |
| dp_ctrl_is_aiq0_issue_special | output | 1 | |
| dp_ctrl_is_aiq1_issue_alu_short | output | 1 | |
| dp_ctrl_is_aiq1_issue_dst_vld | output | 1 | |
| dp_ctrl_is_aiq1_issue_lch_preg | output | 1 | |
| dp_ctrl_is_aiq1_issue_lch_rdy | output | 108 | |
| dp_ctrl_is_aiq1_issue_mla_lch_rdy | output | 8 | |
| dp_ctrl_is_aiq1_issue_mla_vld | output | 1 | |
| dp_ctrl_is_viq0_issue_dstv_vld | output | 1 | |
| dp_ctrl_is_viq0_issue_lch_rdy | output | 16 | |
| dp_ctrl_is_viq0_issue_vdiv | output | 1 | |
| dp_ctrl_is_viq0_issue_vmla_rf | output | 1 | |
| dp_ctrl_is_viq0_issue_vmla_short | output | 1 | |
| dp_ctrl_is_viq1_issue_dstv_vld | output | 1 | |
| dp_ctrl_is_viq1_issue_lch_rdy | output | 16 | |
| dp_ctrl_is_viq1_issue_vmla_rf | output | 1 | |
| dp_ctrl_is_viq1_issue_vmla_short | output | 1 | |
| dp_ctrl_rf_pipe0_eu_sel | output | 4 | |
| dp_ctrl_rf_pipe0_mtvr | output | 1 | |
| dp_ctrl_rf_pipe0_src2_vld | output | 1 | |
| ... | ... | ... | 共307个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_rf_pipe0_gated_clk |
| ct_idu_rf_pipe0_decd | x_ct_idu_rf_pipe0_decd |
| gated_clk_cell | x_rf_pipe1_gated_clk |
| ct_idu_rf_pipe1_decd | x_ct_idu_rf_pipe1_decd |
| gated_clk_cell | x_rf_pipe2_gated_clk |
| ct_idu_rf_pipe2_decd | x_ct_idu_rf_pipe2_decd |
| gated_clk_cell | x_rf_pipe3_gated_clk |
| gated_clk_cell | x_rf_pipe03_gated_clk |
| ct_idu_rf_pipe3_decd | x_ct_idu_rf_pipe3_decd |
| gated_clk_cell | x_rf_pipe4_gated_clk |
| ct_idu_rf_pipe4_decd | x_ct_idu_rf_pipe4_decd |
| gated_clk_cell | x_rf_pipe5_gated_clk |
| gated_clk_cell | x_rf_pipe15_gated_clk |
| gated_clk_cell | x_rf_pipe6_gated_clk |
| gated_clk_cell | x_rf_pipe36_gated_clk |
| ct_idu_rf_pipe6_decd | x_ct_idu_rf_pipe6_decd |
| gated_clk_cell | x_rf_pipe7_gated_clk |
| gated_clk_cell | x_rf_pipe47_gated_clk |
| ct_idu_rf_pipe7_decd | x_ct_idu_rf_pipe7_decd |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
