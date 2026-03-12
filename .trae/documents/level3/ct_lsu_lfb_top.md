# ct_lsu_lfb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_lfb |
| 文件路径 | lsu/rtl/ct_lsu_lfb.v |
| 功能描述 | 填充缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_r_data | input | 128 | |
| biu_lsu_r_id | input | 5 | |
| biu_lsu_r_last | input | 1 | |
| biu_lsu_r_resp | input | 4 | |
| biu_lsu_r_vld | input | 1 | |
| bus_arb_pfu_ar_sel | input | 1 | |
| bus_arb_rb_ar_sel | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_lfb_ld_grnt | input | 1 | |
| ld_da_idx | input | 8 | |
| ld_da_lfb_discard_grnt | input | 1 | |
| ld_da_lfb_set_wakeup_queue | input | 1 | |
| ld_da_lfb_wakeup_queue_next | input | 13 | |
| lm_already_snoop | input | 1 | |
| lm_lfb_depd_wakeup | input | 1 | |
| lm_state_is_amo_lock | input | 1 | |
| lsu_special_clk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pfu_biu_req_addr | input | 40 | |
| pfu_lfb_create_dp_vld | input | 1 | |
| pfu_lfb_create_gateclk_en | input | 1 | |
| pfu_lfb_create_req | input | 1 | |
| pfu_lfb_create_vld | input | 1 | |
| pfu_lfb_id | input | 4 | |
| rb_biu_req_addr | input | 40 | |
| rb_lfb_addr_tto4 | input | 36 | |
| rb_lfb_atomic | input | 1 | |
| ... | ... | ... | 共53个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ld_hit_prefetch | output | 1 | |
| lfb_addr_full | output | 1 | |
| lfb_addr_less2 | output | 1 | |
| lfb_dcache_arb_ld_data_gateclk_en | output | 8 | |
| lfb_dcache_arb_ld_data_high_din | output | 128 | |
| lfb_dcache_arb_ld_data_idx | output | 11 | |
| lfb_dcache_arb_ld_data_low_din | output | 128 | |
| lfb_dcache_arb_ld_req | output | 1 | |
| lfb_dcache_arb_ld_tag_din | output | 54 | |
| lfb_dcache_arb_ld_tag_gateclk_en | output | 1 | |
| lfb_dcache_arb_ld_tag_idx | output | 9 | |
| lfb_dcache_arb_ld_tag_req | output | 1 | |
| lfb_dcache_arb_ld_tag_wen | output | 2 | |
| lfb_dcache_arb_serial_req | output | 1 | |
| lfb_dcache_arb_st_dirty_din | output | 7 | |
| lfb_dcache_arb_st_dirty_gateclk_en | output | 1 | |
| lfb_dcache_arb_st_dirty_idx | output | 9 | |
| lfb_dcache_arb_st_dirty_req | output | 1 | |
| lfb_dcache_arb_st_dirty_wen | output | 7 | |
| lfb_dcache_arb_st_req | output | 1 | |
| lfb_dcache_arb_st_tag_din | output | 52 | |
| lfb_dcache_arb_st_tag_gateclk_en | output | 1 | |
| lfb_dcache_arb_st_tag_idx | output | 9 | |
| lfb_dcache_arb_st_tag_req | output | 1 | |
| lfb_dcache_arb_st_tag_wen | output | 2 | |
| lfb_depd_wakeup | output | 12 | |
| lfb_empty | output | 1 | |
| lfb_ld_da_hit_idx | output | 1 | |
| lfb_mcic_wakeup | output | 1 | |
| lfb_pfu_biu_req_hit_idx | output | 1 | |
| ... | ... | ... | 共59个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_lfb_gated_clk |
| gated_clk_cell | x_lsu_lfb_vb_pe_clk |
| gated_clk_cell | x_lsu_lfb_lf_sm_clk |
| gated_clk_cell | x_lsu_lfb_lf_sm_req_clk |
| gated_clk_cell | x_lsu_lfb_wakeup_queue_gated_clk |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_0 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_1 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_2 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_3 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_4 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_5 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_6 |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_7 |
| ct_lsu_lfb_data_entry | x_ct_lsu_lfb_data_entry_0 |
| ct_lsu_lfb_data_entry | x_ct_lsu_lfb_data_entry_1 |
| ct_rtu_encode_8 | x_lsu_lfb_create_ptr_encode |
| ct_rtu_encode_8 | x_lsu_lfb_vb_pe_req_ptr_encode |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
