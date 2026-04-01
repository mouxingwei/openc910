# ct_lsu_st_da 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_da |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_st_da.v |
| 功能描述 | Store Data Alignment - 存储数据对齐阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 84
- 输出端口数量: 96
- 子模块实例数量: 8

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| amr_wa_cancel | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_l2_st_pref_en | 1 | - |
| cp0_lsu_nsfe | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_st_clk | 1 | - |
| dcache_dirty_din | 7 | - |
| dcache_dirty_gwen | 1 | - |
| dcache_dirty_wen | 7 | - |
| dcache_idx | 9 | - |
| dcache_tag_din | 52 | - |
| dcache_tag_gwen | 1 | - |
| dcache_tag_wen | 2 | - |
| forever_cpuclk | 1 | - |
| ld_da_st_da_hit_idx | 1 | - |
| lfb_st_da_hit_idx | 1 | - |
| lm_st_da_hit_idx | 1 | - |
| lsu_has_fence | 1 | - |
| mmu_lsu_access_fault1 | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_req_addr | 40 | - |
| rb_st_da_full | 1 | - |
| rb_st_da_hit_idx | 1 | - |
| rtu_yy_xx_commit0 | 1 | - |
| rtu_yy_xx_commit0_iid | 7 | - |
| rtu_yy_xx_commit1 | 1 | - |
| rtu_yy_xx_commit1_iid | 7 | - |
| rtu_yy_xx_commit2 | 1 | - |
| ... | ... | 还有 54 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_hpcp_st_cache_access | 1 | - |
| lsu_hpcp_st_cache_miss | 1 | - |
| lsu_hpcp_st_unalign_inst | 1 | - |
| lsu_rtu_da_pipe4_split_spec_fail_iid | 7 | - |
| lsu_rtu_da_pipe4_split_spec_fail_vld | 1 | - |
| st_da_addr | 40 | - |
| st_da_bkpta_data | 1 | - |
| st_da_bkptb_data | 1 | - |
| st_da_borrow_icc_vld | 1 | - |
| st_da_borrow_vld | 1 | - |
| st_da_dcache_dirty | 1 | - |
| st_da_dcache_hit | 1 | - |
| st_da_dcache_miss | 1 | - |
| st_da_dcache_replace_dirty | 1 | - |
| st_da_dcache_replace_valid | 1 | - |
| st_da_dcache_replace_way | 1 | - |
| st_da_dcache_way | 1 | - |
| st_da_ecc_wakeup | 12 | - |
| st_da_fence_inst | 1 | - |
| st_da_fence_mode | 4 | - |
| st_da_icc_dirty_info | 3 | - |
| st_da_icc_tag_info | 26 | - |
| st_da_idu_already_da | 12 | - |
| st_da_idu_bkpta_data | 12 | - |
| st_da_idu_bkptb_data | 12 | - |
| st_da_idu_boundary_gateclk_en | 12 | - |
| st_da_idu_pop_entry | 12 | - |
| st_da_idu_pop_vld | 1 | - |
| st_da_idu_rb_full | 12 | - |
| st_da_idu_secd | 12 | - |
| ... | ... | 还有 66 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_st_da_gated_clk, x_lsu_st_da_inst_gated_clk, x_lsu_st_da_borrow_gated_clk ... (6个) | - |
| vb | rcl | - |
| ct_lsu_dcache_info_update | x_lsu_st_da_dcache_info_update | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_st_da 模块实现了Store Data Alignment - 存储数据对齐阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
