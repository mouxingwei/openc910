# ct_ifu_ifdp 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ifdp |
| 文件名称 | ct_ifu_ifdp.v |
| 功能描述 | IF阶段数据通路模块 |

### 1.2 功能描述

IF阶段数据通路模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_ifdp_way0_pred | input | 2 | - |
| btb_ifdp_way0_tag | input | 10 | - |
| btb_ifdp_way0_target | input | 20 | - |
| btb_ifdp_way0_vld | input | 1 | - |
| btb_ifdp_way1_pred | input | 2 | - |
| btb_ifdp_way1_tag | input | 10 | - |
| btb_ifdp_way1_target | input | 20 | - |
| btb_ifdp_way1_vld | input | 1 | - |
| btb_ifdp_way2_pred | input | 2 | - |
| btb_ifdp_way2_tag | input | 10 | - |
| btb_ifdp_way2_target | input | 20 | - |
| btb_ifdp_way2_vld | input | 1 | - |
| btb_ifdp_way3_pred | input | 2 | - |
| btb_ifdp_way3_tag | input | 10 | - |
| btb_ifdp_way3_target | input | 20 | - |
| btb_ifdp_way3_vld | input | 1 | - |
| cp0_ifu_icache_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cp0_yy_priv_mode | input | 2 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_yy_xx_bkpta_base | input | 40 | - |
| had_yy_xx_bkpta_mask | input | 8 | - |
| had_yy_xx_bkpta_rc | input | 1 | - |
| had_yy_xx_bkptb_base | input | 40 | - |
| had_yy_xx_bkptb_mask | input | 8 | - |
| had_yy_xx_bkptb_rc | input | 1 | - |
| icache_if_ifdp_fifo | input | 1 | - |
| icache_if_ifdp_inst_data0 | input | 128 | - |
| icache_if_ifdp_inst_data1 | input | 128 | - |
| icache_if_ifdp_precode0 | input | 32 | - |
| icache_if_ifdp_precode1 | input | 32 | - |
| icache_if_ifdp_tag_data0 | input | 29 | - |
| icache_if_ifdp_tag_data1 | input | 29 | - |
| ifctrl_ifdp_cancel | input | 1 | - |
| ifctrl_ifdp_pipedown | input | 1 | - |
| ifctrl_ifdp_stall | input | 1 | - |
| ipctrl_ifdp_gateclk_en | input | 1 | - |
| ipctrl_ifdp_vpc_onehot_updt | input | 8 | - |
| ipctrl_ifdp_w0_bry0_hit_updt | input | 1 | - |
| ipctrl_ifdp_w0_bry1_hit_updt | input | 1 | - |
| ipctrl_ifdp_w0b0_br_ntake_updt | input | 8 | - |
| ipctrl_ifdp_w0b0_br_taken_updt | input | 8 | - |
| ipctrl_ifdp_w0b0_bry_updt_data | input | 8 | - |
| ipctrl_ifdp_w0b1_br_ntake_updt | input | 8 | - |
| ipctrl_ifdp_w0b1_br_taken_updt | input | 8 | - |
| ipctrl_ifdp_w0b1_bry_updt_data | input | 8 | - |
| ipctrl_ifdp_w1_bry0_hit_updt | input | 1 | - |
| ipctrl_ifdp_w1_bry1_hit_updt | input | 1 | - |

*注：共81个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifdp_debug_acc_err_vld | output | 1 | - |
| ifdp_debug_mmu_expt_vld | output | 1 | - |
| ifdp_ipctrl_expt_vld | output | 1 | - |
| ifdp_ipctrl_expt_vld_dup | output | 1 | - |
| ifdp_ipctrl_fifo | output | 1 | - |
| ifdp_ipctrl_pa | output | 28 | - |
| ifdp_ipctrl_refill_on | output | 1 | - |
| ifdp_ipctrl_tsize | output | 1 | - |
| ifdp_ipctrl_vpc_2_0_onehot | output | 8 | - |
| ifdp_ipctrl_vpc_bry_mask | output | 8 | - |
| ifdp_ipctrl_w0_bry0_hit | output | 1 | - |
| ifdp_ipctrl_w0_bry1_hit | output | 1 | - |
| ifdp_ipctrl_w0b0_br_ntake | output | 8 | - |
| ifdp_ipctrl_w0b0_br_taken | output | 8 | - |
| ifdp_ipctrl_w0b0_bry_data | output | 8 | - |
| ifdp_ipctrl_w0b1_br_ntake | output | 8 | - |
| ifdp_ipctrl_w0b1_br_taken | output | 8 | - |
| ifdp_ipctrl_w0b1_bry_data | output | 8 | - |
| ifdp_ipctrl_w1_bry0_hit | output | 1 | - |
| ifdp_ipctrl_w1_bry1_hit | output | 1 | - |
| ifdp_ipctrl_w1b0_br_ntake | output | 8 | - |
| ifdp_ipctrl_w1b0_br_taken | output | 8 | - |
| ifdp_ipctrl_w1b0_bry_data | output | 8 | - |
| ifdp_ipctrl_w1b1_br_ntake | output | 8 | - |
| ifdp_ipctrl_w1b1_br_taken | output | 8 | - |
| ifdp_ipctrl_w1b1_bry_data | output | 8 | - |
| ifdp_ipctrl_way0_15_8_hit | output | 1 | - |
| ifdp_ipctrl_way0_15_8_hit_dup | output | 1 | - |
| ifdp_ipctrl_way0_23_16_hit | output | 1 | - |
| ifdp_ipctrl_way0_23_16_hit_dup | output | 1 | - |
| ifdp_ipctrl_way0_28_24_hit | output | 1 | - |
| ifdp_ipctrl_way0_28_24_hit_dup | output | 1 | - |
| ifdp_ipctrl_way0_7_0_hit | output | 1 | - |
| ifdp_ipctrl_way0_7_0_hit_dup | output | 1 | - |
| ifdp_ipctrl_way1_15_8_hit | output | 1 | - |
| ifdp_ipctrl_way1_23_16_hit | output | 1 | - |
| ifdp_ipctrl_way1_28_24_hit | output | 1 | - |
| ifdp_ipctrl_way1_7_0_hit | output | 1 | - |
| ifdp_ipctrl_way_pred | output | 2 | - |
| ifdp_ipdp_acc_err | output | 1 | - |
| ifdp_ipdp_bkpta | output | 8 | - |
| ifdp_ipdp_bkptb | output | 8 | - |
| ifdp_ipdp_btb_way0_pred | output | 2 | - |
| ifdp_ipdp_btb_way0_tag | output | 10 | - |
| ifdp_ipdp_btb_way0_target | output | 20 | - |
| ifdp_ipdp_btb_way0_vld | output | 1 | - |
| ifdp_ipdp_btb_way1_pred | output | 2 | - |
| ifdp_ipdp_btb_way1_tag | output | 10 | - |
| ifdp_ipdp_btb_way1_target | output | 20 | - |
| ifdp_ipdp_btb_way1_vld | output | 1 | - |

*注：共133个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| btb_way0_pred | 2 | - |
| btb_way0_tag | 10 | - |
| btb_way0_target | 20 | - |
| btb_way0_vld | 1 | - |
| btb_way1_pred | 2 | - |
| btb_way1_tag | 10 | - |
| btb_way1_target | 20 | - |
| btb_way1_vld | 1 | - |
| btb_way2_pred | 2 | - |
| btb_way2_tag | 10 | - |
| btb_way2_target | 20 | - |
| btb_way2_vld | 1 | - |
| btb_way3_pred | 2 | - |
| btb_way3_tag | 10 | - |
| btb_way3_target | 20 | - |
| btb_way3_vld | 1 | - |
| cp0_ifu_icache_en_flop | 1 | - |
| if_vpc_2_0_onehot | 8 | - |
| ifdp_ipctrl_expt_vld_dup | 1 | - |
| ifdp_ipctrl_fifo | 1 | - |
| ifdp_ipctrl_pa | 28 | - |
| ifdp_ipctrl_refill_on | 1 | - |
| ifdp_ipctrl_vpc_2_0_onehot | 8 | - |
| ifdp_ipctrl_vpc_bry_mask | 8 | - |
| ifdp_ipctrl_w0_bry0_hit | 1 | - |
| ifdp_ipctrl_w0_bry1_hit | 1 | - |
| ifdp_ipctrl_w0b0_br_ntake | 8 | - |
| ifdp_ipctrl_w0b0_br_taken | 8 | - |
| ifdp_ipctrl_w0b0_bry_data | 8 | - |
| ifdp_ipctrl_w0b1_br_ntake | 8 | - |

*注：共133个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bkpta_base | 40 | - |
| bkpta_hit_0 | 1 | - |
| bkpta_hit_1 | 1 | - |
| bkpta_hit_2 | 1 | - |
| bkpta_hit_3 | 1 | - |
| bkpta_hit_4 | 1 | - |
| bkpta_hit_5 | 1 | - |
| bkpta_hit_6 | 1 | - |
| bkpta_hit_7 | 1 | - |
| bkpta_mask | 40 | - |
| bkptb_base | 40 | - |
| bkptb_hit_0 | 1 | - |
| bkptb_hit_1 | 1 | - |
| bkptb_hit_2 | 1 | - |
| bkptb_hit_3 | 1 | - |
| bkptb_hit_4 | 1 | - |
| bkptb_hit_5 | 1 | - |
| bkptb_hit_6 | 1 | - |
| bkptb_hit_7 | 1 | - |
| bkptb_mask | 40 | - |
| btb_ifdp_way0_pred | 2 | - |
| btb_ifdp_way0_tag | 10 | - |
| btb_ifdp_way0_target | 20 | - |
| btb_ifdp_way0_vld | 1 | - |
| btb_ifdp_way1_pred | 2 | - |
| btb_ifdp_way1_tag | 10 | - |
| btb_ifdp_way1_target | 20 | - |
| btb_ifdp_way1_vld | 1 | - |
| btb_ifdp_way2_pred | 2 | - |
| btb_ifdp_way2_tag | 10 | - |

*注：共253个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IF阶段数据通路模块
- 所属单元：取指单元(IFU)
- 接口数量：输入81个，输出133个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
