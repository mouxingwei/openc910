# ct_mmu_ptw 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_ptw |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_ptw.v |
| 功能描述 | Page Table Walker - 页表遍历器 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 28
- 输出端口数量: 26
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_ptw_grant | 1 | - |
| arb_ptw_mask | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_maee | 1 | - |
| cp0_mmu_mpp | 2 | - |
| cp0_mmu_mprv | 1 | - |
| cp0_mmu_mxr | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| dutlb_ptw_wfc | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_mmu_cnt_en | 1 | - |
| iutlb_ptw_wfc | 1 | - |
| jtlb_ptw_req | 1 | - |
| jtlb_ptw_type | 3 | - |
| jtlb_ptw_vpn | 27 | - |
| jtlb_xx_fifo | 12 | - |
| lsu_mmu_bus_error | 1 | - |
| lsu_mmu_data | 64 | - |
| lsu_mmu_data_vld | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pmp_mmu_flg3 | 4 | - |
| regs_ptw_cur_asid | 16 | - |
| regs_ptw_satp_ppn | 28 | - |
| sysmap_mmu_flg3 | 5 | - |
| sysmap_mmu_hit3 | 8 | - |
| tlboper_ptw_abort | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| mmu_hpcp_jtlb_miss | 1 | - |
| mmu_lsu_data_req | 1 | - |
| mmu_lsu_data_req_addr | 40 | - |
| mmu_lsu_data_req_size | 1 | - |
| mmu_pmp_fetch3 | 1 | - |
| mmu_pmp_pa3 | 28 | - |
| mmu_sysmap_pa3 | 28 | - |
| ptw_arb_bank_sel | 4 | - |
| ptw_arb_data_din | 42 | - |
| ptw_arb_fifo_din | 4 | - |
| ptw_arb_pgs | 3 | - |
| ptw_arb_req | 1 | - |
| ptw_arb_tag_din | 48 | - |
| ptw_arb_vpn | 27 | - |
| ptw_jtlb_dmiss | 1 | - |
| ptw_jtlb_imiss | 1 | - |
| ptw_jtlb_pmiss | 1 | - |
| ptw_jtlb_ref_acc_err | 1 | - |
| ptw_jtlb_ref_cmplt | 1 | - |
| ptw_jtlb_ref_data_vld | 1 | - |
| ptw_jtlb_ref_flg | 14 | - |
| ptw_jtlb_ref_pgflt | 1 | - |
| ptw_jtlb_ref_pgs | 3 | - |
| ptw_jtlb_ref_ppn | 28 | - |
| ptw_top_cur_st | 4 | - |
| ptw_top_imiss | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_ptw_gateclk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_ptw 模块实现了Page Table Walker - 页表遍历器的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
