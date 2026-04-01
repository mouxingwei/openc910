# ct_lsu_top 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_top |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_top.v |
| 功能描述 | LSU子模块 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 212
- 输出端口数量: 282
- 子模块实例数量: 32

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_ac_addr | 40 | - |
| biu_lsu_ac_prot | 3 | - |
| biu_lsu_ac_req | 1 | - |
| biu_lsu_ac_snoop | 4 | - |
| biu_lsu_ar_ready | 1 | - |
| biu_lsu_aw_vb_grnt | 1 | - |
| biu_lsu_aw_wmb_grnt | 1 | - |
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_resp | 2 | - |
| biu_lsu_b_vld | 1 | - |
| biu_lsu_cd_ready | 1 | - |
| biu_lsu_cr_ready | 1 | - |
| biu_lsu_r_data | 128 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_last | 1 | - |
| biu_lsu_r_resp | 4 | - |
| biu_lsu_r_vld | 1 | - |
| biu_lsu_w_vb_grnt | 1 | - |
| biu_lsu_w_wmb_grnt | 1 | - |
| cp0_lsu_amr | 1 | - |
| cp0_lsu_amr2 | 1 | - |
| cp0_lsu_cb_aclr_dis | 1 | - |
| cp0_lsu_corr_dis | 1 | - |
| cp0_lsu_ctc_flush_dis | 1 | - |
| cp0_lsu_da_fwd_dis | 1 | - |
| cp0_lsu_dcache_clr | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_dcache_inv | 1 | - |
| cp0_lsu_dcache_pref_dist | 2 | - |
| cp0_lsu_dcache_pref_en | 1 | - |
| ... | ... | 还有 182 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_biu_ac_empty | 1 | - |
| lsu_biu_ac_ready | 1 | - |
| lsu_biu_ar_addr | 40 | - |
| lsu_biu_ar_bar | 2 | - |
| lsu_biu_ar_burst | 2 | - |
| lsu_biu_ar_cache | 4 | - |
| lsu_biu_ar_domain | 2 | - |
| lsu_biu_ar_dp_req | 1 | - |
| lsu_biu_ar_id | 5 | - |
| lsu_biu_ar_len | 2 | - |
| lsu_biu_ar_lock | 1 | - |
| lsu_biu_ar_prot | 3 | - |
| lsu_biu_ar_req | 1 | - |
| lsu_biu_ar_req_gate | 1 | - |
| lsu_biu_ar_size | 3 | - |
| lsu_biu_ar_snoop | 4 | - |
| lsu_biu_ar_user | 3 | - |
| lsu_biu_aw_req_gate | 1 | - |
| lsu_biu_aw_st_addr | 40 | - |
| lsu_biu_aw_st_bar | 2 | - |
| lsu_biu_aw_st_burst | 2 | - |
| lsu_biu_aw_st_cache | 4 | - |
| lsu_biu_aw_st_domain | 2 | - |
| lsu_biu_aw_st_dp_req | 1 | - |
| lsu_biu_aw_st_id | 5 | - |
| lsu_biu_aw_st_len | 2 | - |
| lsu_biu_aw_st_lock | 1 | - |
| lsu_biu_aw_st_prot | 3 | - |
| lsu_biu_aw_st_req | 1 | - |
| lsu_biu_aw_st_size | 3 | - |
| ... | ... | 还有 252 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| ct_lsu_ld_ag | x_ct_lsu_ld_ag | - |
| ct_lsu_st_ag | x_ct_lsu_st_ag | - |
| ct_lsu_sd_ex1 | x_ct_lsu_sd_ex1 | - |
| ct_lsu_mcic | x_ct_lsu_mcic | - |
| ct_lsu_dcache_arb | x_ct_lsu_dcache_arb | - |
| ct_lsu_dcache_top | x_ct_lsu_dcache_top | - |
| ct_lsu_ld_dc | x_ct_lsu_ld_dc | - |
| ct_lsu_st_dc | x_ct_lsu_st_dc | - |
| ct_lsu_lq | x_ct_lsu_lq | - |
| ct_lsu_sq | x_ct_lsu_sq | - |
| ct_lsu_ld_da | x_ct_lsu_ld_da | - |
| ct_lsu_st_da | x_ct_lsu_st_da | - |
| ct_lsu_rb | x_ct_lsu_rb | - |
| ct_lsu_wmb | x_ct_lsu_wmb | - |
| ct_lsu_wmb_ce | x_ct_lsu_wmb_ce | - |
| ct_lsu_ld_wb | x_ct_lsu_ld_wb | - |
| ct_lsu_st_wb | x_ct_lsu_st_wb | - |
| ct_lsu_lfb | x_ct_lsu_lfb | - |
| ct_lsu_vb | x_ct_lsu_vb | - |
| ct_lsu_vb_sdb_data | x_ct_lsu_vb_sdb_data | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_top 模块实现了LSU子模块的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
