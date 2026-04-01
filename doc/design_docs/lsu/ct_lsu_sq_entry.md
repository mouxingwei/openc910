# ct_lsu_sq_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_sq_entry |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_sq_entry.v |
| 功能描述 | Store Queue - 存储队列 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 92
- 输出端口数量: 54
- 子模块实例数量: 11

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
| ld_da_lsid | 12 | - |
| ld_dc_addr0 | 40 | - |
| ld_dc_addr1_11to4 | 8 | - |
| ld_dc_bytes_vld | 16 | - |
| ld_dc_bytes_vld1 | 16 | - |
| ld_dc_chk_atomic_inst_vld | 1 | - |
| ld_dc_chk_ld_addr1_vld | 1 | - |
| ld_dc_chk_ld_bypass_vld | 1 | - |
| ld_dc_chk_ld_inst_vld | 1 | - |
| ld_dc_iid | 7 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_lsu_async_flush | 1 | - |
| rtu_lsu_commit0_iid_updt_val | 7 | - |
| rtu_lsu_commit1_iid_updt_val | 7 | - |
| rtu_lsu_commit2_iid_updt_val | 7 | - |
| rtu_yy_xx_commit0 | 1 | - |
| rtu_yy_xx_commit1 | 1 | - |
| rtu_yy_xx_commit2 | 1 | - |
| ... | ... | 还有 62 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| sq_entry_addr0_v | 40 | - |
| sq_entry_addr1_dep_discard_x | 1 | - |
| sq_entry_age_vec_surplus1_ptr_x | 1 | - |
| sq_entry_age_vec_zero_ptr_x | 1 | - |
| sq_entry_atomic_x | 1 | - |
| sq_entry_bkpta_data_x | 1 | - |
| sq_entry_bkptb_data_x | 1 | - |
| sq_entry_bytes_vld_v | 16 | - |
| sq_entry_cancel_acc_req_x | 1 | - |
| sq_entry_cancel_ahead_wb_x | 1 | - |
| sq_entry_cmit_data_vld_x | 1 | - |
| sq_entry_cmit_x | 1 | - |
| sq_entry_data_depd_wakeup_v | 12 | - |
| sq_entry_data_discard_req_short_x | 1 | - |
| sq_entry_data_discard_req_x | 1 | - |
| sq_entry_data_v | 64 | - |
| sq_entry_dcache_dirty_x | 1 | - |
| sq_entry_dcache_info_vld_x | 1 | - |
| sq_entry_dcache_share_x | 1 | - |
| sq_entry_dcache_valid_x | 1 | - |
| sq_entry_dcache_way_x | 1 | - |
| sq_entry_depd_set_x | 1 | - |
| sq_entry_depd_x | 1 | - |
| sq_entry_discard_req_x | 1 | - |
| sq_entry_fence_mode_v | 4 | - |
| sq_entry_fwd_bypass_req_x | 1 | - |
| sq_entry_fwd_req_x | 1 | - |
| sq_entry_icc_x | 1 | - |
| sq_entry_iid_v | 7 | - |
| sq_entry_inst_flush_x | 1 | - |
| ... | ... | 还有 24 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_sq_entry_gated_clk, x_lsu_sq_entry_create_gated_clk, x_lsu_sq_entry_create_da_gated_clk ... (5个) | - |
| write | port | - |
| ct_lsu_dcache_info_update | x_lsu_sq_entry_dcache_info_update | - |
| ct_rtu_compare_iid | x_lsu_sq_entry_compare_st_dc_iid, x_lsu_sq_entry_compare_ld_dc_iid | - |
| ld | bond | - |
| 8 | ld | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_sq_entry 模块实现了Store Queue - 存储队列的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
