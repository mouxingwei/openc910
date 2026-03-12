# ct_ifu_ifdp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ifdp |
| 文件路径 | ifu/rtl/ct_ifu_ifdp.v |
| 功能描述 | 取指数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_ifdp_way0_pred | input | 2 | |
| btb_ifdp_way0_tag | input | 10 | |
| btb_ifdp_way0_target | input | 20 | |
| btb_ifdp_way0_vld | input | 1 | |
| btb_ifdp_way1_pred | input | 2 | |
| btb_ifdp_way1_tag | input | 10 | |
| btb_ifdp_way1_target | input | 20 | |
| btb_ifdp_way1_vld | input | 1 | |
| btb_ifdp_way2_pred | input | 2 | |
| btb_ifdp_way2_tag | input | 10 | |
| btb_ifdp_way2_target | input | 20 | |
| btb_ifdp_way2_vld | input | 1 | |
| btb_ifdp_way3_pred | input | 2 | |
| btb_ifdp_way3_tag | input | 10 | |
| btb_ifdp_way3_target | input | 20 | |
| btb_ifdp_way3_vld | input | 1 | |
| cp0_ifu_icache_en | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_yy_xx_bkpta_base | input | 40 | |
| had_yy_xx_bkpta_mask | input | 8 | |
| had_yy_xx_bkpta_rc | input | 1 | |
| had_yy_xx_bkptb_base | input | 40 | |
| had_yy_xx_bkptb_mask | input | 8 | |
| had_yy_xx_bkptb_rc | input | 1 | |
| icache_if_ifdp_fifo | input | 1 | |
| icache_if_ifdp_inst_data0 | input | 128 | |
| ... | ... | ... | 共81个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifdp_debug_acc_err_vld | output | 1 | |
| ifdp_debug_mmu_expt_vld | output | 1 | |
| ifdp_ipctrl_expt_vld | output | 1 | |
| ifdp_ipctrl_expt_vld_dup | output | 1 | |
| ifdp_ipctrl_fifo | output | 1 | |
| ifdp_ipctrl_pa | output | 28 | |
| ifdp_ipctrl_refill_on | output | 1 | |
| ifdp_ipctrl_tsize | output | 1 | |
| ifdp_ipctrl_vpc_2_0_onehot | output | 8 | |
| ifdp_ipctrl_vpc_bry_mask | output | 8 | |
| ifdp_ipctrl_w0_bry0_hit | output | 1 | |
| ifdp_ipctrl_w0_bry1_hit | output | 1 | |
| ifdp_ipctrl_w0b0_br_ntake | output | 8 | |
| ifdp_ipctrl_w0b0_br_taken | output | 8 | |
| ifdp_ipctrl_w0b0_bry_data | output | 8 | |
| ifdp_ipctrl_w0b1_br_ntake | output | 8 | |
| ifdp_ipctrl_w0b1_br_taken | output | 8 | |
| ifdp_ipctrl_w0b1_bry_data | output | 8 | |
| ifdp_ipctrl_w1_bry0_hit | output | 1 | |
| ifdp_ipctrl_w1_bry1_hit | output | 1 | |
| ifdp_ipctrl_w1b0_br_ntake | output | 8 | |
| ifdp_ipctrl_w1b0_br_taken | output | 8 | |
| ifdp_ipctrl_w1b0_bry_data | output | 8 | |
| ifdp_ipctrl_w1b1_br_ntake | output | 8 | |
| ifdp_ipctrl_w1b1_br_taken | output | 8 | |
| ifdp_ipctrl_w1b1_bry_data | output | 8 | |
| ifdp_ipctrl_way0_15_8_hit | output | 1 | |
| ifdp_ipctrl_way0_15_8_hit_dup | output | 1 | |
| ifdp_ipctrl_way0_23_16_hit | output | 1 | |
| ifdp_ipctrl_way0_23_16_hit_dup | output | 1 | |
| ... | ... | ... | 共133个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ifdp_clk |
| Physical | Tag |
| gated_clk_cell | x_icache_flop_clk |
| gated_clk_cell | x_ifdp_spe_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
