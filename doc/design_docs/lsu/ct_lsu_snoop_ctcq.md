# ct_lsu_snoop_ctcq 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_snoop_ctcq |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_snoop_ctcq.v |
| 功能描述 | Snoop - 缓存一致性监听 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 14
- 输出端口数量: 19
- 子模块实例数量: 8

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_ctcq_ctc_2nd_trans | 1 | - |
| arb_ctcq_ctc_asid_va | 24 | - |
| arb_ctcq_ctc_type | 6 | - |
| arb_ctcq_ctc_va_pa | 36 | - |
| arb_ctcq_entry_oldest_index | 6 | - |
| biu_ctcq_cr_ready | 1 | - |
| cp0_lsu_ctc_flush_dis | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cpurst_b | 1 | - |
| ctc_req_create_en | 1 | - |
| ifu_lsu_icache_inv_done | 1 | - |
| lsu_snoop_clk | 1 | - |
| mmu_lsu_tlb_inv_done | 1 | - |
| pad_yy_icg_scan_en | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ctcq_biu_2_cmplt | 1 | - |
| ctcq_biu_cr_resp | 5 | - |
| ctcq_biu_cr_valid | 1 | - |
| cur_ctcq_entry_empty | 1 | - |
| lsu_ctcq_not_empty | 1 | - |
| lsu_had_ctcq_entry_2_cmplt | 6 | - |
| lsu_had_ctcq_entry_cmplt | 6 | - |
| lsu_had_ctcq_entry_vld | 6 | - |
| lsu_ifu_icache_all_inv | 1 | - |
| lsu_ifu_icache_index | 6 | - |
| lsu_ifu_icache_line_inv | 1 | - |
| lsu_ifu_icache_ptag | 28 | - |
| lsu_mmu_tlb_all_inv | 1 | - |
| lsu_mmu_tlb_asid | 16 | - |
| lsu_mmu_tlb_asid_all_inv | 1 | - |
| lsu_mmu_tlb_va | 27 | - |
| lsu_mmu_tlb_va_all_inv | 1 | - |
| lsu_mmu_tlb_va_asid_inv | 1 | - |
| lsu_rtu_ctc_flush_vld | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_ctcq_crt_gated_cell, x_ctcq_pe_gated_cell | - |
| ct_lsu_snoop_ctcq_entry | x_ct_lsu_snoop_ctcq_entry_0, x_ct_lsu_snoop_ctcq_entry_1, x_ct_lsu_snoop_ctcq_entry_2 ... (6个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_snoop_ctcq 模块实现了Snoop - 缓存一致性监听的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
