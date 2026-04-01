# ct_mmu_top 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_top |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_top.v |
| 功能描述 | MMU Top - 内存管理单元顶层模块 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 56
- 输出端口数量: 55
- 子模块实例数量: 13

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_mmu_smp_disable | 1 | - |
| cp0_mmu_cskyee | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_maee | 1 | - |
| cp0_mmu_mpp | 2 | - |
| cp0_mmu_mprv | 1 | - |
| cp0_mmu_mxr | 1 | - |
| cp0_mmu_no_op_req | 1 | - |
| cp0_mmu_ptw_en | 1 | - |
| cp0_mmu_reg_num | 2 | - |
| cp0_mmu_satp_sel | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_mmu_tlb_all_inv | 1 | - |
| cp0_mmu_wdata | 64 | - |
| cp0_mmu_wreg | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_mmu_cnt_en | 1 | - |
| ifu_mmu_abort | 1 | - |
| ifu_mmu_va | 63 | - |
| ifu_mmu_va_vld | 1 | - |
| lsu_mmu_abort0 | 1 | - |
| lsu_mmu_abort1 | 1 | - |
| lsu_mmu_bus_error | 1 | - |
| lsu_mmu_data | 64 | - |
| lsu_mmu_data_vld | 1 | - |
| lsu_mmu_id0 | 7 | - |
| lsu_mmu_id1 | 7 | - |
| lsu_mmu_st_inst0 | 1 | - |
| ... | ... | 还有 26 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| mmu_cp0_cmplt | 1 | - |
| mmu_cp0_data | 64 | - |
| mmu_cp0_satp_data | 64 | - |
| mmu_cp0_tlb_done | 1 | - |
| mmu_had_debug_info | 34 | - |
| mmu_hpcp_dutlb_miss | 1 | - |
| mmu_hpcp_iutlb_miss | 1 | - |
| mmu_hpcp_jtlb_miss | 1 | - |
| mmu_ifu_buf | 1 | - |
| mmu_ifu_ca | 1 | - |
| mmu_ifu_deny | 1 | - |
| mmu_ifu_pa | 28 | - |
| mmu_ifu_pavld | 1 | - |
| mmu_ifu_pgflt | 1 | - |
| mmu_ifu_sec | 1 | - |
| mmu_lsu_access_fault0 | 1 | - |
| mmu_lsu_access_fault1 | 1 | - |
| mmu_lsu_buf0 | 1 | - |
| mmu_lsu_buf1 | 1 | - |
| mmu_lsu_ca0 | 1 | - |
| mmu_lsu_ca1 | 1 | - |
| mmu_lsu_data_req | 1 | - |
| mmu_lsu_data_req_addr | 40 | - |
| mmu_lsu_data_req_size | 1 | - |
| mmu_lsu_mmu_en | 1 | - |
| mmu_lsu_pa0 | 28 | - |
| mmu_lsu_pa0_vld | 1 | - |
| mmu_lsu_pa1 | 28 | - |
| mmu_lsu_pa1_vld | 1 | - |
| mmu_lsu_pa2 | 28 | - |
| ... | ... | 还有 25 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_utlb_gateclk | - |
| ct_mmu_iutlb | x_ct_mmu_iutlb | - |
| ct_mmu_dutlb | x_ct_mmu_dutlb | - |
| ct_mmu_regs | x_ct_mmu_regs | - |
| ct_mmu_tlboper | x_ct_mmu_tlboper | - |
| ct_mmu_arb | x_ct_mmu_arb | - |
| ct_mmu_jtlb | x_ct_mmu_jtlb | - |
| ct_mmu_ptw | x_ct_mmu_ptw | - |
| ct_mmu_sysmap | x_ct_mmu_sysmap_0, x_ct_mmu_sysmap_1, x_ct_mmu_sysmap_2 ... (5个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_top 模块实现了MMU Top - 内存管理单元顶层模块的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
