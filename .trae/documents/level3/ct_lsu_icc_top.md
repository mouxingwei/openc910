# ct_lsu_icc 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_icc |
| 文件路径 | lsu/rtl/ct_lsu_icc.v |
| 功能描述 | ICC控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_dcache_clr | input | 1 | |
| cp0_lsu_dcache_inv | input | 1 | |
| cp0_lsu_dcache_read_index | input | 17 | |
| cp0_lsu_dcache_read_ld_tag | input | 1 | |
| cp0_lsu_dcache_read_req | input | 1 | |
| cp0_lsu_dcache_read_st_tag | input | 1 | |
| cp0_lsu_dcache_read_way | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_icc_ld_grnt | input | 1 | |
| forever_cpuclk | input | 1 | |
| ld_da_icc_read_data | input | 128 | |
| ld_da_snq_borrow_icc | input | 1 | |
| lfb_empty | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pfu_icc_ready | input | 1 | |
| rb_empty | input | 1 | |
| snq_empty | input | 1 | |
| sq_empty | input | 1 | |
| sq_icc_clr | input | 1 | |
| sq_icc_inv | input | 1 | |
| sq_icc_req | input | 1 | |
| st_da_borrow_icc_vld | input | 1 | |
| st_da_icc_dirty_info | input | 3 | |
| st_da_icc_tag_info | input | 26 | |
| vb_empty | input | 1 | |
| vb_icc_create_grnt | input | 1 | |
| wmb_empty | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| icc_dcache_arb_data_way | output | 1 | |
| icc_dcache_arb_ld_borrow_req | output | 1 | |
| icc_dcache_arb_ld_data_gateclk_en | output | 8 | |
| icc_dcache_arb_ld_data_high_idx | output | 11 | |
| icc_dcache_arb_ld_data_low_idx | output | 11 | |
| icc_dcache_arb_ld_data_req | output | 8 | |
| icc_dcache_arb_ld_req | output | 1 | |
| icc_dcache_arb_ld_tag_gateclk_en | output | 1 | |
| icc_dcache_arb_ld_tag_idx | output | 9 | |
| icc_dcache_arb_ld_tag_read | output | 1 | |
| icc_dcache_arb_ld_tag_req | output | 1 | |
| icc_dcache_arb_st_borrow_req | output | 1 | |
| icc_dcache_arb_st_dirty_din | output | 7 | |
| icc_dcache_arb_st_dirty_gateclk_en | output | 1 | |
| icc_dcache_arb_st_dirty_gwen | output | 1 | |
| icc_dcache_arb_st_dirty_idx | output | 9 | |
| icc_dcache_arb_st_dirty_req | output | 1 | |
| icc_dcache_arb_st_dirty_wen | output | 7 | |
| icc_dcache_arb_st_req | output | 1 | |
| icc_dcache_arb_st_tag_gateclk_en | output | 1 | |
| icc_dcache_arb_st_tag_idx | output | 9 | |
| icc_dcache_arb_st_tag_req | output | 1 | |
| icc_dcache_arb_way | output | 1 | |
| icc_idle | output | 1 | |
| icc_snq_create_permit | output | 1 | |
| icc_sq_grnt | output | 1 | |
| icc_vb_addr_tto6 | output | 34 | |
| icc_vb_create_dp_vld | output | 1 | |
| icc_vb_create_gateclk_en | output | 1 | |
| icc_vb_create_req | output | 1 | |
| ... | ... | ... | 共37个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_icc_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
