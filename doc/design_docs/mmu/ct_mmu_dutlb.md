# ct_mmu_dutlb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_dutlb |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_dutlb.v |
| 功能描述 | Data Micro TLB - 数据微TLB |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 45
- 输出端口数量: 36
- 子模块实例数量: 23

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_dutlb_grant | 1 | - |
| biu_mmu_smp_disable | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_mpp | 2 | - |
| cp0_mmu_mprv | 1 | - |
| cp0_mmu_mxr | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_mmu_cnt_en | 1 | - |
| jtlb_dutlb_acc_err | 1 | - |
| jtlb_dutlb_pgflt | 1 | - |
| jtlb_dutlb_ref_cmplt | 1 | - |
| jtlb_dutlb_ref_pavld | 1 | - |
| jtlb_utlb_ref_flg | 14 | - |
| jtlb_utlb_ref_pgs | 3 | - |
| jtlb_utlb_ref_ppn | 28 | - |
| jtlb_utlb_ref_vpn | 27 | - |
| lsu_mmu_abort0 | 1 | - |
| lsu_mmu_abort1 | 1 | - |
| lsu_mmu_id0 | 7 | - |
| lsu_mmu_id1 | 7 | - |
| lsu_mmu_st_inst0 | 1 | - |
| lsu_mmu_st_inst1 | 1 | - |
| lsu_mmu_stamo_pa | 28 | - |
| lsu_mmu_stamo_vld | 1 | - |
| lsu_mmu_tlb_va | 27 | - |
| lsu_mmu_va0 | 64 | - |
| lsu_mmu_va0_vld | 1 | - |
| ... | ... | 还有 15 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| dutlb_arb_cmplt | 1 | - |
| dutlb_arb_load | 1 | - |
| dutlb_arb_req | 1 | - |
| dutlb_arb_vpn | 27 | - |
| dutlb_ptw_wfc | 1 | - |
| dutlb_top_ref_cur_st | 3 | - |
| dutlb_top_ref_type | 1 | - |
| dutlb_top_scd_updt | 1 | - |
| dutlb_xx_mmu_off | 1 | - |
| mmu_hpcp_dutlb_miss | 1 | - |
| mmu_lsu_access_fault0 | 1 | - |
| mmu_lsu_access_fault1 | 1 | - |
| mmu_lsu_buf0 | 1 | - |
| mmu_lsu_buf1 | 1 | - |
| mmu_lsu_ca0 | 1 | - |
| mmu_lsu_ca1 | 1 | - |
| mmu_lsu_pa0 | 28 | - |
| mmu_lsu_pa0_vld | 1 | - |
| mmu_lsu_pa1 | 28 | - |
| mmu_lsu_pa1_vld | 1 | - |
| mmu_lsu_page_fault0 | 1 | - |
| mmu_lsu_page_fault1 | 1 | - |
| mmu_lsu_sec0 | 1 | - |
| mmu_lsu_sec1 | 1 | - |
| mmu_lsu_sh0 | 1 | - |
| mmu_lsu_sh1 | 1 | - |
| mmu_lsu_so0 | 1 | - |
| mmu_lsu_so1 | 1 | - |
| mmu_lsu_stall0 | 1 | - |
| mmu_lsu_stall1 | 1 | - |
| ... | ... | 还有 6 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_dutlb_gateclk, x_dutlb_plru_gateclk | - |
| ct_mmu_dplru | x_ct_mmu_dplru | - |
| ct_rtu_compare_iid | x_mmu_dutlb_compare_req_iid | - |
| ct_mmu_dutlb_entry | x_ct_mmu_dutlb_entry0, x_ct_mmu_dutlb_entry1, x_ct_mmu_dutlb_entry2 ... (16个) | - |
| ct_mmu_dutlb_huge_entry | x_ct_mmu_dutlb_entry16 | - |
| ct_mmu_dutlb_read | x_ct_mmu_dutlb_read0, x_ct_mmu_dutlb_read1 | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_dutlb 模块实现了Data Micro TLB - 数据微TLB的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
