# ct_mmu_regs 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_regs |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_regs.v |
| 功能描述 | MMU Registers - MMU寄存器 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 26
- 输出端口数量: 24
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_mmu_cskyee | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_mpp | 2 | - |
| cp0_mmu_mprv | 1 | - |
| cp0_mmu_reg_num | 2 | - |
| cp0_mmu_satp_sel | 1 | - |
| cp0_mmu_wdata | 64 | - |
| cp0_mmu_wreg | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| jtlb_regs_hit | 1 | - |
| jtlb_regs_hit_mult | 1 | - |
| jtlb_regs_tlbp_hit_index | 11 | - |
| jtlb_tlbr_asid | 16 | - |
| jtlb_tlbr_flg | 14 | - |
| jtlb_tlbr_g | 1 | - |
| jtlb_tlbr_pgs | 3 | - |
| jtlb_tlbr_ppn | 28 | - |
| jtlb_tlbr_vpn | 27 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_mmu_bad_vpn | 27 | - |
| rtu_mmu_expt_vld | 1 | - |
| tlboper_regs_cmplt | 1 | - |
| tlboper_regs_tlbp_cmplt | 1 | - |
| tlboper_regs_tlbr_cmplt | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| mmu_cp0_cmplt | 1 | - |
| mmu_cp0_data | 64 | - |
| mmu_cp0_satp_data | 64 | - |
| mmu_lsu_mmu_en | 1 | - |
| mmu_xx_mmu_en | 1 | - |
| regs_jtlb_cur_asid | 16 | - |
| regs_jtlb_cur_flg | 14 | - |
| regs_jtlb_cur_g | 1 | - |
| regs_jtlb_cur_ppn | 28 | - |
| regs_mmu_en | 1 | - |
| regs_ptw_cur_asid | 16 | - |
| regs_ptw_satp_ppn | 28 | - |
| regs_tlboper_cur_asid | 16 | - |
| regs_tlboper_cur_pgs | 3 | - |
| regs_tlboper_cur_vpn | 27 | - |
| regs_tlboper_inv_asid | 16 | - |
| regs_tlboper_invall | 1 | - |
| regs_tlboper_invasid | 1 | - |
| regs_tlboper_mir | 12 | - |
| regs_tlboper_tlbp | 1 | - |
| regs_tlboper_tlbr | 1 | - |
| regs_tlboper_tlbwi | 1 | - |
| regs_tlboper_tlbwr | 1 | - |
| regs_utlb_clr | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_mmu_regs_gateclk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_regs 模块实现了MMU Registers - MMU寄存器的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
