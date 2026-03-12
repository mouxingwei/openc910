# ct_lsu_vb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_vb |
| 文件路径 | lsu/rtl/ct_lsu_vb.v |
| 功能描述 | 有效位缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_b_id | input | 5 | |
| biu_lsu_b_vld | input | 1 | |
| bus_arb_vb_aw_grnt | input | 1 | |
| bus_arb_vb_w_grnt | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_vb_ld_grnt | input | 1 | |
| dcache_arb_vb_st_grnt | input | 1 | |
| icc_vb_addr_tto6 | input | 34 | |
| icc_vb_create_dp_vld | input | 1 | |
| icc_vb_create_gateclk_en | input | 1 | |
| icc_vb_create_req | input | 1 | |
| icc_vb_create_vld | input | 1 | |
| icc_vb_inv | input | 1 | |
| ld_da_vb_snq_data_reissue | input | 1 | |
| lfb_vb_addr_tto6 | input | 34 | |
| lfb_vb_create_dp_vld | input | 1 | |
| lfb_vb_create_gateclk_en | input | 1 | |
| lfb_vb_create_req | input | 1 | |
| lfb_vb_create_vld | input | 1 | |
| lfb_vb_id | input | 3 | |
| lsu_special_clk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pfu_biu_req_addr | input | 40 | |
| rb_biu_req_addr | input | 40 | |
| snq_bypass_addr_tto6 | input | 34 | |
| snq_create_addr | input | 40 | |
| snq_depd_vb_id | input | 2 | |
| snq_vb_bypass_check | input | 1 | |
| ... | ... | ... | 共66个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_had_vb_addr_entry_vld | output | 2 | |
| lsu_had_vb_data_entry_vld | output | 3 | |
| lsu_had_vb_rcl_sm_state | output | 4 | |
| snq_data_bypass_hit | output | 3 | |
| vb_biu_aw_addr | output | 40 | |
| vb_biu_aw_bar | output | 2 | |
| vb_biu_aw_burst | output | 2 | |
| vb_biu_aw_cache | output | 4 | |
| vb_biu_aw_domain | output | 2 | |
| vb_biu_aw_dp_req | output | 1 | |
| vb_biu_aw_id | output | 5 | |
| vb_biu_aw_len | output | 2 | |
| vb_biu_aw_lock | output | 1 | |
| vb_biu_aw_prot | output | 3 | |
| vb_biu_aw_req | output | 1 | |
| vb_biu_aw_req_gateclk_en | output | 1 | |
| vb_biu_aw_size | output | 3 | |
| vb_biu_aw_snoop | output | 3 | |
| vb_biu_aw_unique | output | 1 | |
| vb_biu_aw_user | output | 1 | |
| vb_biu_w_data | output | 128 | |
| vb_biu_w_id | output | 5 | |
| vb_biu_w_last | output | 1 | |
| vb_biu_w_req | output | 1 | |
| vb_biu_w_strb | output | 16 | |
| vb_biu_w_vld | output | 1 | |
| vb_data_entry_biu_req_success | output | 3 | |
| vb_data_entry_create_dp_vld | output | 3 | |
| vb_data_entry_create_gateclk_en | output | 3 | |
| vb_data_entry_create_vld | output | 3 | |
| ... | ... | ... | 共88个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_vb_rcl_sm_clk |
| gated_clk_cell | x_lsu_vb_rcl_sm_create_clk |
| gated_clk_cell | x_lsu_vb_wd_sm_clk |
| ct_lsu_vb_addr_entry | x_ct_lsu_vb_addr_entry_0 |
| ct_lsu_vb_addr_entry | x_ct_lsu_vb_addr_entry_1 |
| icc | clear |
| ct_rtu_expand_8 | x_lsu_vb_source_id_0_expand |
| ct_rtu_expand_8 | x_lsu_vb_source_id_1_expand |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
