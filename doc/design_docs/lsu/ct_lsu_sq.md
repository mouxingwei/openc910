# ct_lsu_sq 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_sq |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_sq.v |
| 功能描述 | Store Queue - 存储队列 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 97
- 输出端口数量: 69
- 子模块实例数量: 21

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| dcache_dirty_din | 7 | - |
| dcache_dirty_gwen | 1 | - |
| dcache_dirty_wen | 7 | - |
| dcache_idx | 9 | - |
| dcache_tag_din | 52 | - |
| dcache_tag_gwen | 1 | - |
| dcache_tag_wen | 2 | - |
| forever_cpuclk | 1 | - |
| had_lsu_bus_trace_en | 1 | - |
| had_lsu_dbg_en | 1 | - |
| icc_idle | 1 | - |
| icc_sq_grnt | 1 | - |
| ld_da_lsid | 12 | - |
| ld_da_sq_data_discard_vld | 1 | - |
| ld_da_sq_fwd_id | 12 | - |
| ld_da_sq_fwd_multi_vld | 1 | - |
| ld_da_sq_global_discard_vld | 1 | - |
| ld_dc_addr0 | 40 | - |
| ld_dc_addr1_11to4 | 8 | - |
| ld_dc_bytes_vld | 16 | - |
| ld_dc_bytes_vld1 | 16 | - |
| ld_dc_chk_atomic_inst_vld | 1 | - |
| ld_dc_chk_ld_addr1_vld | 1 | - |
| ld_dc_chk_ld_bypass_vld | 1 | - |
| ld_dc_chk_ld_inst_vld | 1 | - |
| ld_dc_iid | 7 | - |
| ... | ... | 还有 67 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_had_sq_not_empty | 1 | - |
| lsu_had_st_addr | 40 | - |
| lsu_had_st_data | 64 | - |
| lsu_had_st_iid | 7 | - |
| lsu_had_st_req | 1 | - |
| lsu_had_st_type | 4 | - |
| lsu_idu_sq_not_full | 1 | - |
| lsu_rtu_all_commit_data_vld | 1 | - |
| sq_data_depd_wakeup | 12 | - |
| sq_empty | 1 | - |
| sq_global_depd_wakeup | 12 | - |
| sq_icc_clr | 1 | - |
| sq_icc_inv | 1 | - |
| sq_icc_req | 1 | - |
| sq_ld_da_fwd_data | 64 | - |
| sq_ld_da_fwd_data_pe | 64 | - |
| sq_ld_dc_addr1_dep_discard | 1 | - |
| sq_ld_dc_cancel_acc_req | 1 | - |
| sq_ld_dc_cancel_ahead_wb | 1 | - |
| sq_ld_dc_data_discard_req | 1 | - |
| sq_ld_dc_fwd_bypass_multi | 1 | - |
| sq_ld_dc_fwd_bypass_req | 1 | - |
| sq_ld_dc_fwd_id | 12 | - |
| sq_ld_dc_fwd_multi | 1 | - |
| sq_ld_dc_fwd_multi_mask | 1 | - |
| sq_ld_dc_fwd_req | 1 | - |
| sq_ld_dc_has_fwd_req | 1 | - |
| sq_ld_dc_newest_fwd_data_vld_req | 1 | - |
| sq_ld_dc_other_discard_req | 1 | - |
| sq_pfu_pop_synci_inst | 1 | - |
| ... | ... | 还有 39 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_sq_gated_clk, x_lsu_sq_create_pop_gated_clk, x_lsu_sq_wakeup_queue_gated_clk ... (6个) | - |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_0, x_ct_lsu_sq_entry_1, x_ct_lsu_sq_entry_2 ... (12个) | - |
| ct_lsu_rot_data | x_lsu_sq_data_rot_to_mem_format | - |
| write | port | - |
| ct_lsu_dcache_info_update | x_lsu_wmb_ce_dcache_info_update | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_sq 模块实现了Store Queue - 存储队列的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
