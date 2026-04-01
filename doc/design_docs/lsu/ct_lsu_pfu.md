# ct_lsu_pfu 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_pfu |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_pfu.v |
| 功能描述 | Prefetch Unit - 预取单元 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 69
- 输出端口数量: 28
- 子模块实例数量: 22

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| amr_wa_cancel | 1 | - |
| bus_arb_pfu_ar_grnt | 1 | - |
| bus_arb_pfu_ar_ready | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_dcache_pref_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_l2_pref_en | 1 | - |
| cp0_lsu_l2_st_pref_en | 1 | - |
| cp0_lsu_no_op_req | 1 | - |
| cp0_lsu_pfu_mmu_dis | 1 | - |
| cp0_lsu_timeout_cnt | 30 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_dcache_pref_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| icc_idle | 1 | - |
| ld_da_iid | 7 | - |
| ld_da_ldfifo_pc | 15 | - |
| ld_da_page_sec_ff | 1 | - |
| ld_da_page_share_ff | 1 | - |
| ld_da_pfu_act_dp_vld | 1 | - |
| ld_da_pfu_act_vld | 1 | - |
| ld_da_pfu_biu_req_hit_idx | 1 | - |
| ld_da_pfu_evict_cnt_vld | 1 | - |
| ld_da_pfu_pf_inst_vld | 1 | - |
| ld_da_pfu_va | 40 | - |
| ld_da_ppfu_va | 40 | - |
| ld_da_ppn_ff | 28 | - |
| lfb_addr_full | 1 | - |
| ... | ... | 还有 39 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_mmu_va2 | 28 | - |
| lsu_mmu_va2_vld | 1 | - |
| pfu_biu_ar_addr | 40 | - |
| pfu_biu_ar_bar | 2 | - |
| pfu_biu_ar_burst | 2 | - |
| pfu_biu_ar_cache | 4 | - |
| pfu_biu_ar_domain | 2 | - |
| pfu_biu_ar_dp_req | 1 | - |
| pfu_biu_ar_id | 5 | - |
| pfu_biu_ar_len | 2 | - |
| pfu_biu_ar_lock | 1 | - |
| pfu_biu_ar_prot | 3 | - |
| pfu_biu_ar_req | 1 | - |
| pfu_biu_ar_req_gateclk_en | 1 | - |
| pfu_biu_ar_size | 3 | - |
| pfu_biu_ar_snoop | 4 | - |
| pfu_biu_ar_user | 3 | - |
| pfu_biu_req_addr | 40 | - |
| pfu_icc_ready | 1 | - |
| pfu_lfb_create_dp_vld | 1 | - |
| pfu_lfb_create_gateclk_en | 1 | - |
| pfu_lfb_create_req | 1 | - |
| pfu_lfb_create_vld | 1 | - |
| pfu_lfb_id | 4 | - |
| pfu_part_empty | 1 | - |
| pfu_pfb_empty | 1 | - |
| pfu_sdb_create_gateclk_en | 1 | - |
| pfu_sdb_empty | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_pfu_mmu_pe_gated_clk, x_lsu_pfu_biu_pe_gated_clk | - |
| ct_lsu_pfu_pmb_entry | x_ct_lsu_pfu_pmb_entry_0, x_ct_lsu_pfu_pmb_entry_1, x_ct_lsu_pfu_pmb_entry_2 ... (8个) | - |
| ct_lsu_pfu_sdb_entry | x_ct_lsu_pfu_sdb_entry_0, x_ct_lsu_pfu_sdb_entry_1 | - |
| ct_lsu_pfu_pfb_entry | x_ct_lsu_pfu_pfb_entry_0, x_ct_lsu_pfu_pfb_entry_1, x_ct_lsu_pfu_pfb_entry_2 ... (8个) | - |
| ct_lsu_pfu_gsdb | x_ct_lsu_pfu_gsdb | - |
| ct_lsu_pfu_gpfb | x_ct_lsu_pfu_gpfb | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_pfu 模块实现了Prefetch Unit - 预取单元的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
