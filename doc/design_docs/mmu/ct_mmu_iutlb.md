# ct_mmu_iutlb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_iutlb |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_iutlb.v |
| 功能描述 | Instruction Micro TLB - 指令微TLB |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 28
- 输出端口数量: 16
- 子模块实例数量: 37

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_iutlb_grant | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_no_op_req | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_mmu_cnt_en | 1 | - |
| ifu_mmu_abort | 1 | - |
| ifu_mmu_va | 63 | - |
| ifu_mmu_va_vld | 1 | - |
| jtlb_iutlb_acc_err | 1 | - |
| jtlb_iutlb_pgflt | 1 | - |
| jtlb_iutlb_ref_cmplt | 1 | - |
| jtlb_iutlb_ref_pavld | 1 | - |
| jtlb_utlb_ref_flg | 14 | - |
| jtlb_utlb_ref_pgs | 3 | - |
| jtlb_utlb_ref_ppn | 28 | - |
| jtlb_utlb_ref_vpn | 27 | - |
| lsu_mmu_tlb_va | 27 | - |
| pad_yy_icg_scan_en | 1 | - |
| pmp_mmu_flg2 | 4 | - |
| regs_mmu_en | 1 | - |
| regs_utlb_clr | 1 | - |
| sysmap_mmu_flg2 | 5 | - |
| tlboper_utlb_clr | 1 | - |
| tlboper_utlb_inv_va_req | 1 | - |
| utlb_clk | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| iutlb_arb_cmplt | 1 | - |
| iutlb_arb_req | 1 | - |
| iutlb_arb_vpn | 27 | - |
| iutlb_ptw_wfc | 1 | - |
| iutlb_top_ref_cur_st | 2 | - |
| iutlb_top_scd_updt | 1 | - |
| mmu_hpcp_iutlb_miss | 1 | - |
| mmu_ifu_buf | 1 | - |
| mmu_ifu_ca | 1 | - |
| mmu_ifu_deny | 1 | - |
| mmu_ifu_pa | 28 | - |
| mmu_ifu_pavld | 1 | - |
| mmu_ifu_pgflt | 1 | - |
| mmu_ifu_sec | 1 | - |
| mmu_pmp_pa2 | 28 | - |
| mmu_sysmap_pa2 | 28 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_iutlb_gateclk, x_iutlb_plru_gateclk, x_iutlb_pabuf_gateclk | - |
| ct_mmu_iplru | x_ct_mmu_iplru | - |
| L0 | uTLB | - |
| ct_mmu_iutlb_fst_entry | x_ct_mmu_iutlb_entry0, x_ct_mmu_iutlb_entry8, x_ct_mmu_iutlb_entry16 ... (4个) | - |
| ct_mmu_iutlb_entry | x_ct_mmu_iutlb_entry1, x_ct_mmu_iutlb_entry2, x_ct_mmu_iutlb_entry3 ... (28个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_iutlb 模块实现了Instruction Micro TLB - 指令微TLB的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
