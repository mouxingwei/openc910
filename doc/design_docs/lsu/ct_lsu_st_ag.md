# ct_lsu_st_ag 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_ag |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_st_ag.v |
| 功能描述 | Store Address Generation - 存储地址生成阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 75
- 输出端口数量: 66
- 子模块实例数量: 4

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_mm | 1 | - |
| cp0_lsu_tvm | 1 | - |
| cp0_lsu_ucme | 1 | - |
| cp0_lsu_wa | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cp0_yy_virtual_mode | 1 | - |
| cpurst_b | 1 | - |
| ctrl_st_clk | 1 | - |
| dcache_arb_ag_st_sel | 1 | - |
| dcache_arb_st_ag_addr | 40 | - |
| dcache_arb_st_ag_borrow_addr_vld | 1 | - |
| forever_cpuclk | 1 | - |
| idu_lsu_rf_pipe4_already_da | 1 | - |
| idu_lsu_rf_pipe4_atomic | 1 | - |
| idu_lsu_rf_pipe4_bkpta_data | 1 | - |
| idu_lsu_rf_pipe4_bkptb_data | 1 | - |
| idu_lsu_rf_pipe4_fence_mode | 4 | - |
| idu_lsu_rf_pipe4_gateclk_sel | 1 | - |
| idu_lsu_rf_pipe4_icc | 1 | - |
| idu_lsu_rf_pipe4_iid | 7 | - |
| idu_lsu_rf_pipe4_inst_code | 32 | - |
| idu_lsu_rf_pipe4_inst_fls | 1 | - |
| idu_lsu_rf_pipe4_inst_flush | 1 | - |
| idu_lsu_rf_pipe4_inst_mode | 2 | - |
| idu_lsu_rf_pipe4_inst_share | 1 | - |
| idu_lsu_rf_pipe4_inst_size | 2 | - |
| idu_lsu_rf_pipe4_inst_str | 1 | - |
| ... | ... | 还有 45 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ag_dcache_arb_st_dirty_gateclk_en | 1 | - |
| ag_dcache_arb_st_dirty_idx | 9 | - |
| ag_dcache_arb_st_dirty_req | 1 | - |
| ag_dcache_arb_st_tag_gateclk_en | 1 | - |
| ag_dcache_arb_st_tag_idx | 9 | - |
| ag_dcache_arb_st_tag_req | 1 | - |
| lsu_hpcp_st_cross_4k_stall | 1 | - |
| lsu_hpcp_st_other_stall | 1 | - |
| lsu_idu_st_ag_wait_old | 12 | - |
| lsu_idu_st_ag_wait_old_gateclk_en | 1 | - |
| lsu_mmu_abort1 | 1 | - |
| lsu_mmu_id1 | 7 | - |
| lsu_mmu_st_inst1 | 1 | - |
| lsu_mmu_stamo_pa | 28 | - |
| lsu_mmu_stamo_vld | 1 | - |
| lsu_mmu_va1 | 64 | - |
| lsu_mmu_va1_vld | 1 | - |
| st_ag_already_da | 1 | - |
| st_ag_atomic | 1 | - |
| st_ag_boundary | 1 | - |
| st_ag_dc_access_size | 3 | - |
| st_ag_dc_addr0 | 40 | - |
| st_ag_dc_bytes_vld | 16 | - |
| st_ag_dc_inst_vld | 1 | - |
| st_ag_dc_mmu_req | 1 | - |
| st_ag_dc_page_share | 1 | - |
| st_ag_dc_rot_sel | 4 | - |
| st_ag_expt_access_fault_with_page | 1 | - |
| st_ag_expt_illegal_inst | 1 | - |
| st_ag_expt_misalign_no_page | 1 | - |
| ... | ... | 还有 36 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_st_ag_gated_clk | - |
| biu | req_size | - |
| a | first | - |
| ct_rtu_compare_iid | x_lsu_rf_compare_st_ag_iid | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_st_ag 模块实现了Store Address Generation - 存储地址生成阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
