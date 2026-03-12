# ct_lsu_dcache_arb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_dcache_arb |
| 文件路径 | lsu/rtl/ct_lsu_dcache_arb.v |
| 功能描述 | 数据Cache仲裁 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ag_dcache_arb_ld_data_gateclk_en | input | 8 | |
| ag_dcache_arb_ld_data_high_idx | input | 11 | |
| ag_dcache_arb_ld_data_low_idx | input | 11 | |
| ag_dcache_arb_ld_data_req | input | 8 | |
| ag_dcache_arb_ld_tag_gateclk_en | input | 1 | |
| ag_dcache_arb_ld_tag_idx | input | 9 | |
| ag_dcache_arb_ld_tag_req | input | 1 | |
| ag_dcache_arb_st_dirty_gateclk_en | input | 1 | |
| ag_dcache_arb_st_dirty_idx | input | 9 | |
| ag_dcache_arb_st_dirty_req | input | 1 | |
| ag_dcache_arb_st_tag_gateclk_en | input | 1 | |
| ag_dcache_arb_st_tag_idx | input | 9 | |
| ag_dcache_arb_st_tag_req | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| icc_dcache_arb_data_way | input | 1 | |
| icc_dcache_arb_ld_borrow_req | input | 1 | |
| icc_dcache_arb_ld_data_gateclk_en | input | 8 | |
| icc_dcache_arb_ld_data_high_idx | input | 11 | |
| icc_dcache_arb_ld_data_low_idx | input | 11 | |
| icc_dcache_arb_ld_data_req | input | 8 | |
| icc_dcache_arb_ld_req | input | 1 | |
| icc_dcache_arb_ld_tag_gateclk_en | input | 1 | |
| icc_dcache_arb_ld_tag_idx | input | 9 | |
| icc_dcache_arb_ld_tag_read | input | 1 | |
| icc_dcache_arb_ld_tag_req | input | 1 | |
| icc_dcache_arb_st_borrow_req | input | 1 | |
| icc_dcache_arb_st_dirty_din | input | 7 | |
| icc_dcache_arb_st_dirty_gateclk_en | input | 1 | |
| ... | ... | ... | 共141个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dcache_arb_ag_ld_sel | output | 1 | |
| dcache_arb_ag_st_sel | output | 1 | |
| dcache_arb_icc_ld_grnt | output | 1 | |
| dcache_arb_ld_ag_addr | output | 40 | |
| dcache_arb_ld_ag_borrow_addr_vld | output | 1 | |
| dcache_arb_ld_dc_borrow_db | output | 3 | |
| dcache_arb_ld_dc_borrow_icc | output | 1 | |
| dcache_arb_ld_dc_borrow_mmu | output | 1 | |
| dcache_arb_ld_dc_borrow_sndb | output | 1 | |
| dcache_arb_ld_dc_borrow_vb | output | 1 | |
| dcache_arb_ld_dc_borrow_vld | output | 1 | |
| dcache_arb_ld_dc_borrow_vld_gate | output | 1 | |
| dcache_arb_ld_dc_settle_way | output | 1 | |
| dcache_arb_lfb_ld_grnt | output | 1 | |
| dcache_arb_mcic_ld_grnt | output | 1 | |
| dcache_arb_snq_ld_grnt | output | 1 | |
| dcache_arb_snq_st_grnt | output | 1 | |
| dcache_arb_st_ag_addr | output | 40 | |
| dcache_arb_st_ag_borrow_addr_vld | output | 1 | |
| dcache_arb_st_dc_borrow_icc | output | 1 | |
| dcache_arb_st_dc_borrow_snq | output | 1 | |
| dcache_arb_st_dc_borrow_snq_id | output | 6 | |
| dcache_arb_st_dc_borrow_vld | output | 1 | |
| dcache_arb_st_dc_borrow_vld_gate | output | 1 | |
| dcache_arb_st_dc_dcache_replace | output | 1 | |
| dcache_arb_st_dc_dcache_sw | output | 1 | |
| dcache_arb_vb_ld_grnt | output | 1 | |
| dcache_arb_vb_st_grnt | output | 1 | |
| dcache_arb_wmb_ld_grnt | output | 1 | |
| dcache_dirty_din | output | 7 | |
| ... | ... | ... | 共65个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_dcache_serial_clk_en |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
