# ct_lsu_st_dc 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_dc |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_st_dc.v |
| 功能描述 | Store Data Cache - 存储数据缓存访问阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 81
- 输出端口数量: 77
- 子模块实例数量: 4

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_l2_st_pref_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_st_clk | 1 | - |
| dcache_arb_st_dc_borrow_icc | 1 | - |
| dcache_arb_st_dc_borrow_snq | 1 | - |
| dcache_arb_st_dc_borrow_snq_id | 6 | - |
| dcache_arb_st_dc_borrow_vld | 1 | - |
| dcache_arb_st_dc_borrow_vld_gate | 1 | - |
| dcache_arb_st_dc_dcache_replace | 1 | - |
| dcache_arb_st_dc_dcache_sw | 1 | - |
| dcache_dirty_gwen | 1 | - |
| dcache_idx | 9 | - |
| dcache_lsu_st_dirty_dout | 7 | - |
| dcache_lsu_st_tag_dout | 52 | - |
| forever_cpuclk | 1 | - |
| had_yy_xx_bkpta_base | 40 | - |
| had_yy_xx_bkpta_mask | 8 | - |
| had_yy_xx_bkpta_rc | 1 | - |
| had_yy_xx_bkptb_base | 40 | - |
| had_yy_xx_bkptb_mask | 8 | - |
| had_yy_xx_bkptb_rc | 1 | - |
| lq_st_dc_spec_fail | 1 | - |
| mmu_lsu_mmu_en | 1 | - |
| mmu_lsu_tlb_busy | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_lsu_commit0_iid_updt_val | 7 | - |
| rtu_lsu_commit1_iid_updt_val | 7 | - |
| ... | ... | 还有 51 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_idu_dc_sdiq_entry | 12 | - |
| lsu_idu_dc_staddr1_vld | 1 | - |
| lsu_idu_dc_staddr_unalign | 1 | - |
| lsu_idu_dc_staddr_vld | 1 | - |
| lsu_mmu_vabuf1 | 28 | - |
| st_dc_addr0 | 40 | - |
| st_dc_already_da | 1 | - |
| st_dc_atomic | 1 | - |
| st_dc_bkpta_data | 1 | - |
| st_dc_bkptb_data | 1 | - |
| st_dc_borrow_dcache_replace | 1 | - |
| st_dc_borrow_dcache_sw | 1 | - |
| st_dc_borrow_icc | 1 | - |
| st_dc_borrow_snq | 1 | - |
| st_dc_borrow_snq_id | 6 | - |
| st_dc_borrow_vld | 1 | - |
| st_dc_boundary | 1 | - |
| st_dc_boundary_first | 1 | - |
| st_dc_bytes_vld | 16 | - |
| st_dc_chk_st_inst_vld | 1 | - |
| st_dc_chk_statomic_inst_vld | 1 | - |
| st_dc_cmit0_iid_crt_hit | 1 | - |
| st_dc_cmit1_iid_crt_hit | 1 | - |
| st_dc_cmit2_iid_crt_hit | 1 | - |
| st_dc_da_dcache_dirty_array | 7 | - |
| st_dc_da_dcache_tag_array | 52 | - |
| st_dc_da_expt_vld_gate_en | 1 | - |
| st_dc_da_inst_vld | 1 | - |
| st_dc_da_page_buf | 1 | - |
| st_dc_da_page_ca | 1 | - |
| ... | ... | 还有 47 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_st_dc_gated_clk, x_lsu_st_dc_inst_gated_clk, x_lsu_st_dc_borrow_gated_clk ... (4个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_st_dc 模块实现了Store Data Cache - 存储数据缓存访问阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
