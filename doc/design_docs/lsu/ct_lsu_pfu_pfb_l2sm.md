# ct_lsu_pfu_pfb_l2sm 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_pfu_pfb_l2sm |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_pfu_pfb_l2sm.v |
| 功能描述 | Prefetch Unit - 预取单元 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 34
- 输出端口数量: 10
- 子模块实例数量: 2

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_pfu_mmu_dis | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_biu_pe_req | 1 | - |
| entry_biu_pe_req_grnt | 1 | - |
| entry_biu_pe_req_src | 2 | - |
| entry_clk | 1 | - |
| entry_create_dp_vld | 1 | - |
| entry_inst_new_va | 40 | - |
| entry_l1_pf_va | 40 | - |
| entry_l2_dist_strideh | 40 | - |
| entry_mmu_pe_req | 1 | - |
| entry_mmu_pe_req_grnt | 1 | - |
| entry_mmu_pe_req_src | 2 | - |
| entry_pf_inst_vld | 1 | - |
| entry_pop_vld | 1 | - |
| entry_reinit_vld | 1 | - |
| entry_stride_neg | 1 | - |
| entry_strideh | 40 | - |
| entry_tsm_is_judge | 1 | - |
| forever_cpuclk | 1 | - |
| ld_da_page_sec_ff | 1 | - |
| ld_da_page_share_ff | 1 | - |
| ld_da_ppn_ff | 28 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_pe_req_sel_l1 | 1 | - |
| pfu_get_page_sec | 1 | - |
| pfu_get_page_share | 1 | - |
| pfu_get_ppn | 28 | - |
| ... | ... | 还有 4 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_l2_biu_pe_req_set | 1 | - |
| entry_l2_cmp_va_vld | 1 | - |
| entry_l2_mmu_pe_req_set | 1 | - |
| entry_l2_page_sec | 1 | - |
| entry_l2_page_share | 1 | - |
| entry_l2_pf_addr | 40 | - |
| entry_l2_pf_va_sub_l1_pf_va | 40 | - |
| entry_l2_vpn | 28 | - |
| entry_l2sm_reinit_req | 1 | - |
| entry_l2sm_va_can_cmp | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_pfu_pfb_l2sm_pf_va_gated_clk, x_lsu_pfu_pfb_l2sm_pf_ppn_gated_clk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_pfu_pfb_l2sm 模块实现了Prefetch Unit - 预取单元的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
