# ct_lsu_lfb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_lfb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_lfb.v |
| 功能描述 | Line Fill Buffer - 行填充缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 53
- 输出端口数量: 59
- 子模块实例数量: 17

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_r_data | 128 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_last | 1 | - |
| biu_lsu_r_resp | 4 | - |
| biu_lsu_r_vld | 1 | - |
| bus_arb_pfu_ar_sel | 1 | - |
| bus_arb_rb_ar_sel | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_lfb_ld_grnt | 1 | - |
| ld_da_idx | 8 | - |
| ld_da_lfb_discard_grnt | 1 | - |
| ld_da_lfb_set_wakeup_queue | 1 | - |
| ld_da_lfb_wakeup_queue_next | 13 | - |
| lm_already_snoop | 1 | - |
| lm_lfb_depd_wakeup | 1 | - |
| lm_state_is_amo_lock | 1 | - |
| lsu_special_clk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_req_addr | 40 | - |
| pfu_lfb_create_dp_vld | 1 | - |
| pfu_lfb_create_gateclk_en | 1 | - |
| pfu_lfb_create_req | 1 | - |
| pfu_lfb_create_vld | 1 | - |
| pfu_lfb_id | 4 | - |
| rb_biu_req_addr | 40 | - |
| rb_lfb_addr_tto4 | 36 | - |
| rb_lfb_atomic | 1 | - |
| ... | ... | 还有 23 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ld_hit_prefetch | 1 | - |
| lfb_addr_full | 1 | - |
| lfb_addr_less2 | 1 | - |
| lfb_dcache_arb_ld_data_gateclk_en | 8 | - |
| lfb_dcache_arb_ld_data_high_din | 128 | - |
| lfb_dcache_arb_ld_data_idx | 11 | - |
| lfb_dcache_arb_ld_data_low_din | 128 | - |
| lfb_dcache_arb_ld_req | 1 | - |
| lfb_dcache_arb_ld_tag_din | 54 | - |
| lfb_dcache_arb_ld_tag_gateclk_en | 1 | - |
| lfb_dcache_arb_ld_tag_idx | 9 | - |
| lfb_dcache_arb_ld_tag_req | 1 | - |
| lfb_dcache_arb_ld_tag_wen | 2 | - |
| lfb_dcache_arb_serial_req | 1 | - |
| lfb_dcache_arb_st_dirty_din | 7 | - |
| lfb_dcache_arb_st_dirty_gateclk_en | 1 | - |
| lfb_dcache_arb_st_dirty_idx | 9 | - |
| lfb_dcache_arb_st_dirty_req | 1 | - |
| lfb_dcache_arb_st_dirty_wen | 7 | - |
| lfb_dcache_arb_st_req | 1 | - |
| lfb_dcache_arb_st_tag_din | 52 | - |
| lfb_dcache_arb_st_tag_gateclk_en | 1 | - |
| lfb_dcache_arb_st_tag_idx | 9 | - |
| lfb_dcache_arb_st_tag_req | 1 | - |
| lfb_dcache_arb_st_tag_wen | 2 | - |
| lfb_depd_wakeup | 12 | - |
| lfb_empty | 1 | - |
| lfb_ld_da_hit_idx | 1 | - |
| lfb_mcic_wakeup | 1 | - |
| lfb_pfu_biu_req_hit_idx | 1 | - |
| ... | ... | 还有 29 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_lfb_gated_clk, x_lsu_lfb_vb_pe_clk, x_lsu_lfb_lf_sm_clk ... (5个) | - |
| ct_lsu_lfb_addr_entry | x_ct_lsu_lfb_addr_entry_0, x_ct_lsu_lfb_addr_entry_1, x_ct_lsu_lfb_addr_entry_2 ... (8个) | - |
| ct_lsu_lfb_data_entry | x_ct_lsu_lfb_data_entry_0, x_ct_lsu_lfb_data_entry_1 | - |
| ct_rtu_encode_8 | x_lsu_lfb_create_ptr_encode, x_lsu_lfb_vb_pe_req_ptr_encode | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_lfb 模块实现了Line Fill Buffer - 行填充缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
