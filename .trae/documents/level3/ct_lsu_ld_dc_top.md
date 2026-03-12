# ct_lsu_ld_dc 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_dc |
| 文件路径 | lsu/rtl/ct_lsu_ld_dc.v |
| 功能描述 | 加载数据Cache |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cb_ld_dc_addr_hit | input | 1 | |
| cp0_lsu_da_fwd_dis | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ld_clk | input | 1 | |
| dcache_arb_ld_dc_borrow_db | input | 3 | |
| dcache_arb_ld_dc_borrow_icc | input | 1 | |
| dcache_arb_ld_dc_borrow_mmu | input | 1 | |
| dcache_arb_ld_dc_borrow_sndb | input | 1 | |
| dcache_arb_ld_dc_borrow_vb | input | 1 | |
| dcache_arb_ld_dc_borrow_vld | input | 1 | |
| dcache_arb_ld_dc_borrow_vld_gate | input | 1 | |
| dcache_arb_ld_dc_settle_way | input | 1 | |
| dcache_idx | input | 9 | |
| dcache_lsu_ld_tag_dout | input | 54 | |
| forever_cpuclk | input | 1 | |
| had_yy_xx_bkpta_base | input | 40 | |
| had_yy_xx_bkpta_mask | input | 8 | |
| had_yy_xx_bkpta_rc | input | 1 | |
| had_yy_xx_bkptb_base | input | 40 | |
| had_yy_xx_bkptb_mask | input | 8 | |
| had_yy_xx_bkptb_rc | input | 1 | |
| icc_dcache_arb_ld_tag_read | input | 1 | |
| ld_ag_addr1_to4 | input | 36 | |
| ld_ag_ahead_predict | input | 1 | |
| ld_ag_already_da | input | 1 | |
| ld_ag_atomic | input | 1 | |
| ld_ag_boundary | input | 1 | |
| ... | ... | ... | 共104个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ld_dc_addr0 | output | 40 | |
| ld_dc_addr1 | output | 40 | |
| ld_dc_addr1_11to4 | output | 8 | |
| ld_dc_ahead_predict | output | 1 | |
| ld_dc_ahead_preg_wb_vld | output | 1 | |
| ld_dc_ahead_vreg_wb_vld | output | 1 | |
| ld_dc_already_da | output | 1 | |
| ld_dc_atomic | output | 1 | |
| ld_dc_bkpta_data | output | 1 | |
| ld_dc_bkptb_data | output | 1 | |
| ld_dc_borrow_db | output | 3 | |
| ld_dc_borrow_icc | output | 1 | |
| ld_dc_borrow_icc_tag | output | 1 | |
| ld_dc_borrow_mmu | output | 1 | |
| ld_dc_borrow_sndb | output | 1 | |
| ld_dc_borrow_vb | output | 1 | |
| ld_dc_borrow_vld | output | 1 | |
| ld_dc_boundary | output | 1 | |
| ld_dc_bytes_vld | output | 16 | |
| ld_dc_bytes_vld1 | output | 16 | |
| ld_dc_cb_addr_create_gateclk_en | output | 1 | |
| ld_dc_cb_addr_create_vld | output | 1 | |
| ld_dc_cb_addr_tto4 | output | 36 | |
| ld_dc_chk_atomic_inst_vld | output | 1 | |
| ld_dc_chk_ld_addr1_vld | output | 1 | |
| ld_dc_chk_ld_bypass_vld | output | 1 | |
| ld_dc_chk_ld_inst_vld | output | 1 | |
| ld_dc_da_bytes_vld | output | 16 | |
| ld_dc_da_bytes_vld1 | output | 16 | |
| ld_dc_da_cb_addr_create | output | 1 | |
| ... | ... | ... | 共114个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_ld_dc_gated_clk |
| gated_clk_cell | x_lsu_ld_dc_inst_gated_clk |
| gated_clk_cell | x_lsu_ld_dc_borrow_gated_clk |
| lsiq | signal |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
