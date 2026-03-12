# ct_idu_id_dp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_id_dp |
| 文件路径 | idu/rtl/ct_idu_id_dp.v |
| 功能描述 | 译码数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_cskyee | input | 1 | |
| cp0_idu_frm | input | 3 | |
| cp0_idu_fs | input | 2 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_vill | input | 1 | |
| cp0_idu_vs | input | 2 | |
| cp0_idu_vstart | input | 7 | |
| cp0_idu_zero_delay_move_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_hyper | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_dp_id_debug_id_pipedown3 | input | 1 | |
| ctrl_dp_id_inst0_vld | input | 1 | |
| ctrl_dp_id_inst1_vld | input | 1 | |
| ctrl_dp_id_inst2_vld | input | 1 | |
| ctrl_dp_id_pipedown_1_inst | input | 1 | |
| ctrl_dp_id_pipedown_2_inst | input | 1 | |
| ctrl_dp_id_pipedown_3_inst | input | 1 | |
| ctrl_dp_id_stall | input | 1 | |
| ctrl_split_long_id_inst_vld | input | 1 | |
| ctrl_split_long_id_stall | input | 1 | |
| fence_dp_inst0_data | input | 178 | |
| fence_dp_inst1_data | input | 178 | |
| fence_dp_inst2_data | input | 178 | |
| forever_cpuclk | input | 1 | |
| ifu_idu_ib_inst0_data | input | 73 | |
| ifu_idu_ib_inst1_data | input | 73 | |
| ifu_idu_ib_inst2_data | input | 73 | |
| ifu_idu_ib_pipedown_gateclk | input | 1 | |
| iu_yy_xx_cancel | input | 1 | |
| ... | ... | ... | 共32个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dp_ctrl_id_inst0_fence | output | 1 | |
| dp_ctrl_id_inst0_normal | output | 1 | |
| dp_ctrl_id_inst0_split_long | output | 1 | |
| dp_ctrl_id_inst0_split_short | output | 1 | |
| dp_ctrl_id_inst1_fence | output | 1 | |
| dp_ctrl_id_inst1_normal | output | 1 | |
| dp_ctrl_id_inst1_split_long | output | 1 | |
| dp_ctrl_id_inst1_split_short | output | 1 | |
| dp_ctrl_id_inst2_fence | output | 1 | |
| dp_ctrl_id_inst2_normal | output | 1 | |
| dp_ctrl_id_inst2_split_long | output | 1 | |
| dp_ctrl_id_inst2_split_short | output | 1 | |
| dp_fence_id_bkpta_inst | output | 1 | |
| dp_fence_id_bkptb_inst | output | 1 | |
| dp_fence_id_fence_type | output | 3 | |
| dp_fence_id_inst | output | 32 | |
| dp_fence_id_pc | output | 15 | |
| dp_fence_id_vl | output | 8 | |
| dp_fence_id_vl_pred | output | 1 | |
| dp_fence_id_vlmul | output | 2 | |
| dp_fence_id_vsew | output | 3 | |
| dp_id_pipedown_dep_info | output | 17 | |
| dp_id_pipedown_inst0_data | output | 178 | |
| dp_id_pipedown_inst1_data | output | 178 | |
| dp_id_pipedown_inst2_data | output | 178 | |
| dp_id_pipedown_inst3_data | output | 178 | |
| idu_had_id_inst0_info | output | 40 | |
| idu_had_id_inst1_info | output | 40 | |
| idu_had_id_inst2_info | output | 40 | |
| split_long_ctrl_id_stall | output | 1 | |
| ... | ... | ... | 共31个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_id_inst_gated_clk |
| gated_clk_cell | x_debug_id_inst_gated_clk |
| ct_idu_id_decd | x_ct_idu_id_decd0 |
| ct_idu_id_decd | x_ct_idu_id_decd1 |
| ct_idu_id_decd | x_ct_idu_id_decd2 |
| ct_idu_id_split_long | x_ct_idu_id_split_long |
| ct_idu_id_split_short | x_ct_idu_id_split_short0 |
| ct_idu_id_split_short | x_ct_idu_id_split_short1 |
| ct_idu_id_split_short | x_ct_idu_id_split_short2 |
| fence | if |
| fence | if |
| split | if |
| split | if |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
