# ct_mmu_dutlb_read 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_dutlb_read |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_dutlb_read.v |
| 功能描述 | Data Micro TLB - 数据微TLB |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 97
- 输出端口数量: 21
- 子模块实例数量: 2

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_mmu_smp_disable | 1 | - |
| cp0_mach_mode | 1 | - |
| cp0_mmu_icg_en | 1 | - |
| cp0_mmu_mxr | 1 | - |
| cp0_mmu_sum | 1 | - |
| cp0_supv_mode | 1 | - |
| cp0_user_mode | 1 | - |
| cpurst_b | 1 | - |
| dplru_clk | 1 | - |
| dutlb_clk | 1 | - |
| dutlb_expt_for_taken | 1 | - |
| dutlb_off_hit | 1 | - |
| dutlb_ori_read_x | 1 | - |
| dutlb_read_type_x | 1 | - |
| dutlb_ref_acflt | 1 | - |
| dutlb_ref_pgflt | 1 | - |
| dutlb_refill_on_x | 1 | - |
| entry0_flg | 14 | - |
| entry0_hit_x | 1 | - |
| entry0_ppn | 28 | - |
| entry0_vld | 1 | - |
| entry10_flg | 14 | - |
| entry10_hit_x | 1 | - |
| entry10_ppn | 28 | - |
| entry10_vld | 1 | - |
| entry11_flg | 14 | - |
| entry11_hit_x | 1 | - |
| entry11_ppn | 28 | - |
| entry11_vld | 1 | - |
| entry12_flg | 14 | - |
| ... | ... | 还有 67 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| dutlb_acc_flt_x | 1 | - |
| dutlb_inst_id_match_x | 1 | - |
| dutlb_inst_id_older_x | 1 | - |
| dutlb_miss_vld_short_x | 1 | - |
| dutlb_miss_vld_x | 1 | - |
| dutlb_plru_read_hit_vld_x | 1 | - |
| dutlb_plru_read_hit_x | 16 | - |
| dutlb_va_chg_x | 1 | - |
| mmu_lsu_access_fault_x | 1 | - |
| mmu_lsu_buf_x | 1 | - |
| mmu_lsu_ca_x | 1 | - |
| mmu_lsu_pa_vld_x | 1 | - |
| mmu_lsu_pa_x | 28 | - |
| mmu_lsu_page_fault_x | 1 | - |
| mmu_lsu_sec_x | 1 | - |
| mmu_lsu_sh_x | 1 | - |
| mmu_lsu_so_x | 1 | - |
| mmu_lsu_stall_x | 1 | - |
| mmu_pmp_pa_x | 28 | - |
| mmu_sysmap_pa_x | 28 | - |
| utlb_req_vpn_x | 27 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| ct_rtu_compare_iid | x_mmu_dutlb_read_compare_req_iid | - |
| gated_clk_cell | x_dutlb_pabuf_gateclk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_dutlb_read 模块实现了Data Micro TLB - 数据微TLB的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
