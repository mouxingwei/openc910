# ct_lsu_pfu_gpfb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_pfu_gpfb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_pfu_gpfb.v |
| 功能描述 | Prefetch Unit - 预取单元 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 34
- 输出端口数量: 14
- 子模块实例数量: 5

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_pfu_mmu_dis | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| ld_da_page_sec_ff | 1 | - |
| ld_da_page_share_ff | 1 | - |
| ld_da_pfu_act_vld | 1 | - |
| ld_da_pfu_pf_inst_vld | 1 | - |
| ld_da_pfu_va | 40 | - |
| ld_da_ppn_ff | 28 | - |
| lsu_pfu_l1_dist_sel | 4 | - |
| lsu_pfu_l2_dist_sel | 4 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_pe_req_sel_l1 | 1 | - |
| pfu_dcache_pref_en | 1 | - |
| pfu_get_page_sec | 1 | - |
| pfu_get_page_share | 1 | - |
| pfu_get_ppn | 28 | - |
| pfu_get_ppn_err | 1 | - |
| pfu_get_ppn_vld | 1 | - |
| pfu_gpfb_biu_pe_req_grnt | 1 | - |
| pfu_gpfb_from_lfb_dcache_hit | 1 | - |
| pfu_gpfb_from_lfb_dcache_miss | 1 | - |
| pfu_gpfb_mmu_pe_req_grnt | 1 | - |
| pfu_gsdb_gpfb_create_vld | 1 | - |
| pfu_gsdb_gpfb_pop_req | 1 | - |
| pfu_gsdb_stride | 11 | - |
| pfu_gsdb_stride_neg | 1 | - |
| ... | ... | 还有 4 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pfu_gpfb_biu_pe_req | 1 | - |
| pfu_gpfb_biu_pe_req_src | 2 | - |
| pfu_gpfb_l1_page_sec | 1 | - |
| pfu_gpfb_l1_page_share | 1 | - |
| pfu_gpfb_l1_pf_addr | 40 | - |
| pfu_gpfb_l1_vpn | 28 | - |
| pfu_gpfb_l2_page_sec | 1 | - |
| pfu_gpfb_l2_page_share | 1 | - |
| pfu_gpfb_l2_pf_addr | 40 | - |
| pfu_gpfb_l2_vpn | 28 | - |
| pfu_gpfb_mmu_pe_req | 1 | - |
| pfu_gpfb_mmu_pe_req_src | 2 | - |
| pfu_gpfb_priv_mode | 2 | - |
| pfu_gpfb_vld | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_pfu_gpfb_gated_clk, x_lsu_pfu_gpfb_create_gated_clk | - |
| ct_lsu_pfu_pfb_tsm | x_ct_lsu_pfu_gpfb_tsm | - |
| ct_lsu_pfu_pfb_l1sm | x_ct_lsu_pfu_gpfb_l1sm | - |
| ct_lsu_pfu_pfb_l2sm | x_ct_lsu_pfu_gpfb_l2sm | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_pfu_gpfb 模块实现了Prefetch Unit - 预取单元的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
