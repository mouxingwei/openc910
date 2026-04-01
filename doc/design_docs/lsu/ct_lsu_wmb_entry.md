# ct_lsu_wmb_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_wmb_entry |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_wmb_entry.v |
| 功能描述 | Write Merge Buffer - 写合并缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 111
- 输出端口数量: 78
- 子模块实例数量: 11

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_vld | 1 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_vld | 1 | - |
| bus_arb_wmb_aw_grnt | 1 | - |
| bus_arb_wmb_w_grnt | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_dirty_din | 7 | - |
| dcache_dirty_gwen | 1 | - |
| dcache_dirty_wen | 7 | - |
| dcache_idx | 9 | - |
| dcache_snq_st_sel | 1 | - |
| dcache_tag_din | 52 | - |
| dcache_tag_gwen | 1 | - |
| dcache_tag_wen | 2 | - |
| forever_cpuclk | 1 | - |
| ld_dc_addr0 | 40 | - |
| ld_dc_addr1_11to4 | 8 | - |
| ld_dc_bytes_vld | 16 | - |
| ld_dc_chk_atomic_inst_vld | 1 | - |
| ld_dc_chk_ld_inst_vld | 1 | - |
| lm_state_is_ex_wait_lock | 1 | - |
| lm_state_is_idle | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_req_addr | 40 | - |
| pw_merge_stall | 1 | - |
| rb_biu_req_addr | 40 | - |
| rb_biu_req_unmask | 1 | - |
| ... | ... | 还有 81 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| wmb_entry_addr_v | 40 | - |
| wmb_entry_ar_pending_x | 1 | - |
| wmb_entry_atomic_and_vld_x | 1 | - |
| wmb_entry_atomic_x | 1 | - |
| wmb_entry_aw_pending_x | 1 | - |
| wmb_entry_biu_id_v | 5 | - |
| wmb_entry_bkpta_data_x | 1 | - |
| wmb_entry_bkptb_data_x | 1 | - |
| wmb_entry_bytes_vld_v | 16 | - |
| wmb_entry_cancel_acc_req_x | 1 | - |
| wmb_entry_data_biu_req_x | 1 | - |
| wmb_entry_data_ptr_after_write_shift_imme_x | 1 | - |
| wmb_entry_data_ptr_with_write_shift_imme_x | 1 | - |
| wmb_entry_data_req_wns_x | 1 | - |
| wmb_entry_data_req_x | 1 | - |
| wmb_entry_data_v | 128 | - |
| wmb_entry_dcache_inst_x | 1 | - |
| wmb_entry_dcache_way_x | 1 | - |
| wmb_entry_depd_x | 1 | - |
| wmb_entry_discard_req_x | 1 | - |
| wmb_entry_fwd_bytes_vld_v | 16 | - |
| wmb_entry_fwd_data_pe_gateclk_en_x | 1 | - |
| wmb_entry_fwd_data_pe_req_x | 1 | - |
| wmb_entry_fwd_req_x | 1 | - |
| wmb_entry_hit_sq_pop_dcache_line_x | 1 | - |
| wmb_entry_icc_and_vld_x | 1 | - |
| wmb_entry_icc_x | 1 | - |
| wmb_entry_iid_v | 7 | - |
| wmb_entry_inst_flush_x | 1 | - |
| wmb_entry_inst_is_dcache_x | 1 | - |
| ... | ... | 还有 48 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_wmb_entry_gated_clk, x_lsu_wmb_entry_create_up_gated_clk, x_lsu_wmb_entry_bytes_vld_gated_clk ... (8个) | - |
| write | port | - |
| ct_lsu_dcache_info_update | x_lsu_wmb_entry_dcache_info_update | - |
| 5 | ld | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_wmb_entry 模块实现了Write Merge Buffer - 写合并缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
