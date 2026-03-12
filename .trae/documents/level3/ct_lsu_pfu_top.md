# ct_lsu_pfu 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_pfu |
| 文件路径 | lsu/rtl/ct_lsu_pfu.v |
| 功能描述 | 预取单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| amr_wa_cancel | input | 1 | |
| bus_arb_pfu_ar_grnt | input | 1 | |
| bus_arb_pfu_ar_ready | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_dcache_pref_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_l2_pref_en | input | 1 | |
| cp0_lsu_l2_st_pref_en | input | 1 | |
| cp0_lsu_no_op_req | input | 1 | |
| cp0_lsu_pfu_mmu_dis | input | 1 | |
| cp0_lsu_timeout_cnt | input | 30 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_dcache_pref_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| icc_idle | input | 1 | |
| ld_da_iid | input | 7 | |
| ld_da_ldfifo_pc | input | 15 | |
| ld_da_page_sec_ff | input | 1 | |
| ld_da_page_share_ff | input | 1 | |
| ld_da_pfu_act_dp_vld | input | 1 | |
| ld_da_pfu_act_vld | input | 1 | |
| ld_da_pfu_biu_req_hit_idx | input | 1 | |
| ld_da_pfu_evict_cnt_vld | input | 1 | |
| ld_da_pfu_pf_inst_vld | input | 1 | |
| ld_da_pfu_va | input | 40 | |
| ld_da_ppfu_va | input | 40 | |
| ld_da_ppn_ff | input | 28 | |
| lfb_addr_full | input | 1 | |
| ... | ... | ... | 共69个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_mmu_va2 | output | 28 | |
| lsu_mmu_va2_vld | output | 1 | |
| pfu_biu_ar_addr | output | 40 | |
| pfu_biu_ar_bar | output | 2 | |
| pfu_biu_ar_burst | output | 2 | |
| pfu_biu_ar_cache | output | 4 | |
| pfu_biu_ar_domain | output | 2 | |
| pfu_biu_ar_dp_req | output | 1 | |
| pfu_biu_ar_id | output | 5 | |
| pfu_biu_ar_len | output | 2 | |
| pfu_biu_ar_lock | output | 1 | |
| pfu_biu_ar_prot | output | 3 | |
| pfu_biu_ar_req | output | 1 | |
| pfu_biu_ar_req_gateclk_en | output | 1 | |
| pfu_biu_ar_size | output | 3 | |
| pfu_biu_ar_snoop | output | 4 | |
| pfu_biu_ar_user | output | 3 | |
| pfu_biu_req_addr | output | 40 | |
| pfu_icc_ready | output | 1 | |
| pfu_lfb_create_dp_vld | output | 1 | |
| pfu_lfb_create_gateclk_en | output | 1 | |
| pfu_lfb_create_req | output | 1 | |
| pfu_lfb_create_vld | output | 1 | |
| pfu_lfb_id | output | 4 | |
| pfu_part_empty | output | 1 | |
| pfu_pfb_empty | output | 1 | |
| pfu_sdb_create_gateclk_en | output | 1 | |
| pfu_sdb_empty | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_pfu_mmu_pe_gated_clk |
| gated_clk_cell | x_lsu_pfu_biu_pe_gated_clk |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_0 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_1 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_2 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_3 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_4 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_5 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_6 |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_7 |
| ct_lsu_pfu_sdb_entry | x_ct_lsu_pfu_sdb_entry_0 |
| ct_lsu_pfu_sdb_entry | x_ct_lsu_pfu_sdb_entry_1 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_0 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_1 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_2 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_3 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_4 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_5 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_6 |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_7 |
| ct_lsu_pfu_gsdb | x_ct_lsu_pfu_gsdb |
| ct_lsu_pfu_gpfb | x_ct_lsu_pfu_gpfb |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
