# ct_mmu_jtlb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_jtlb |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_jtlb.v |
| 功能描述 | Joint TLB - 联合TLB |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 47
- 输出端口数量: 51
- 子模块实例数量: 6

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_jtlb_acc_type | 3 | - |
| arb_jtlb_bank_sel | 4 | - |
| arb_jtlb_cmp_with_va | 1 | - |
| arb_jtlb_data_din | 42 | - |
| arb_jtlb_fifo_din | 4 | - |
| arb_jtlb_fifo_write | 1 | - |
| arb_jtlb_idx | 9 | - |
| arb_jtlb_req | 1 | - |
| arb_jtlb_tag_din | 48 | - |
| arb_jtlb_vpn | 27 | - |
| arb_jtlb_write | 1 | - |
| arb_top_cur_st | 2 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_maee | 1 | - |
| cp0_mmu_mpp | 2 | - |
| cp0_mmu_mprv | 1 | - |
| cp0_mmu_mxr | 1 | - |
| cp0_mmu_ptw_en | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| dutlb_xx_mmu_off | 1 | - |
| forever_cpuclk | 1 | - |
| lsu_mmu_va2 | 28 | - |
| lsu_mmu_va2_vld | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pmp_mmu_flg4 | 4 | - |
| ptw_arb_vpn | 27 | - |
| ptw_jtlb_dmiss | 1 | - |
| ptw_jtlb_imiss | 1 | - |
| ... | ... | 还有 17 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| jtlb_arb_cmp_va | 1 | - |
| jtlb_arb_par_clr | 1 | - |
| jtlb_arb_pfu_cmplt | 1 | - |
| jtlb_arb_pfu_vpn | 27 | - |
| jtlb_arb_sel_1g | 1 | - |
| jtlb_arb_sel_2m | 1 | - |
| jtlb_arb_sel_4k | 1 | - |
| jtlb_arb_tc_miss | 1 | - |
| jtlb_arb_type | 3 | - |
| jtlb_arb_vpn | 27 | - |
| jtlb_dutlb_acc_err | 1 | - |
| jtlb_dutlb_pgflt | 1 | - |
| jtlb_dutlb_ref_cmplt | 1 | - |
| jtlb_dutlb_ref_pavld | 1 | - |
| jtlb_iutlb_acc_err | 1 | - |
| jtlb_iutlb_pgflt | 1 | - |
| jtlb_iutlb_ref_cmplt | 1 | - |
| jtlb_iutlb_ref_pavld | 1 | - |
| jtlb_ptw_req | 1 | - |
| jtlb_ptw_type | 3 | - |
| jtlb_ptw_vpn | 27 | - |
| jtlb_regs_hit | 1 | - |
| jtlb_regs_hit_mult | 1 | - |
| jtlb_regs_tlbp_hit_index | 11 | - |
| jtlb_tlboper_asid_hit | 1 | - |
| jtlb_tlboper_cmplt | 1 | - |
| jtlb_tlboper_fifo | 4 | - |
| jtlb_tlboper_read_idle | 1 | - |
| jtlb_tlboper_sel | 4 | - |
| jtlb_tlboper_va_hit | 1 | - |
| ... | ... | 还有 21 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_jtlb_gateclk | - |
| RB | stage | - |
| ct_mmu_jtlb_tag_array | x_ct_mmu_jtlb_tag_array | - |
| ct_mmu_jtlb_data_array | x_ct_mmu_jtlb_data_array | - |
| TA | stage | - |
| TC | stage | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_jtlb 模块实现了Joint TLB - 联合TLB的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
