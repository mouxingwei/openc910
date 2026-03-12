# ct_mmu_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_top |
| 文件路径 | mmu/rtl/ct_mmu_top.v |
| 功能描述 | 内存管理单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_mmu_smp_disable | input | 1 | |
| cp0_mmu_cskyee | input | 1 | |
| cp0_mmu_icg_en | input | 1 | |
| cp0_mmu_maee | input | 1 | |
| cp0_mmu_mpp | input | 2 | |
| cp0_mmu_mprv | input | 1 | |
| cp0_mmu_mxr | input | 1 | |
| cp0_mmu_no_op_req | input | 1 | |
| cp0_mmu_ptw_en | input | 1 | |
| cp0_mmu_reg_num | input | 2 | |
| cp0_mmu_satp_sel | input | 1 | |
| cp0_mmu_sum | input | 1 | |
| cp0_mmu_tlb_all_inv | input | 1 | |
| cp0_mmu_wdata | input | 64 | |
| cp0_mmu_wreg | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| hpcp_mmu_cnt_en | input | 1 | |
| ifu_mmu_abort | input | 1 | |
| ... | ... | ... | 共56个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| mmu_cp0_cmplt | output | 1 | |
| mmu_cp0_data | output | 64 | |
| mmu_cp0_satp_data | output | 64 | |
| mmu_cp0_tlb_done | output | 1 | |
| mmu_had_debug_info | output | 34 | |
| mmu_hpcp_dutlb_miss | output | 1 | |
| mmu_hpcp_iutlb_miss | output | 1 | |
| mmu_hpcp_jtlb_miss | output | 1 | |
| mmu_ifu_buf | output | 1 | |
| mmu_ifu_ca | output | 1 | |
| mmu_ifu_deny | output | 1 | |
| mmu_ifu_pa | output | 28 | |
| mmu_ifu_pavld | output | 1 | |
| mmu_ifu_pgflt | output | 1 | |
| mmu_ifu_sec | output | 1 | |
| mmu_lsu_access_fault0 | output | 1 | |
| mmu_lsu_access_fault1 | output | 1 | |
| mmu_lsu_buf0 | output | 1 | |
| mmu_lsu_buf1 | output | 1 | |
| mmu_lsu_ca0 | output | 1 | |
| ... | ... | ... | 共55个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_utlb_gateclk |
| ct_mmu_iutlb | x_ct_mmu_iutlb |
| ct_mmu_dutlb | x_ct_mmu_dutlb |
| ct_mmu_regs | x_ct_mmu_regs |
| ct_mmu_tlboper | x_ct_mmu_tlboper |
| ct_mmu_arb | x_ct_mmu_arb |
| ct_mmu_jtlb | x_ct_mmu_jtlb |
| ct_mmu_ptw | x_ct_mmu_ptw |
| ct_mmu_sysmap | x_ct_mmu_sysmap_0 |
| ct_mmu_sysmap | x_ct_mmu_sysmap_1 |
| ct_mmu_sysmap | x_ct_mmu_sysmap_2 |
| ct_mmu_sysmap | x_ct_mmu_sysmap_3 |
| ct_mmu_sysmap | x_ct_mmu_sysmap_4 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
