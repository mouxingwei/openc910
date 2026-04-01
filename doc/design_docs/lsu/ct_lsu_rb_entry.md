# ct_lsu_rb_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_rb_entry |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_rb_entry.v |
| 功能描述 | Replay Buffer - 重放缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 100
- 输出端口数量: 48
- 子模块实例数量: 4

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_vld | 1 | - |
| biu_lsu_r_data_mask | 128 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_vld | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| ld_da_addr | 40 | - |
| ld_da_bkpta_data | 1 | - |
| ld_da_bkptb_data | 1 | - |
| ld_da_boundary_after_mask | 1 | - |
| ld_da_bytes_vld | 16 | - |
| ld_da_data_ori | 64 | - |
| ld_da_data_rot_sel | 8 | - |
| ld_da_dcache_hit | 1 | - |
| ld_da_idx | 8 | - |
| ld_da_iid | 7 | - |
| ld_da_inst_size | 3 | - |
| ld_da_inst_vfls | 1 | - |
| ld_da_mcic_borrow_mmu | 1 | - |
| ld_da_page_buf | 1 | - |
| ld_da_page_ca | 1 | - |
| ld_da_page_sec | 1 | - |
| ld_da_page_share | 1 | - |
| ld_da_page_so | 1 | - |
| ld_da_preg | 7 | - |
| ld_da_rb_atomic | 1 | - |
| ld_da_rb_cmit | 1 | - |
| ... | ... | 还有 70 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| rb_entry_addr_v | 40 | - |
| rb_entry_atomic_next_resp_x | 1 | - |
| rb_entry_atomic_x | 1 | - |
| rb_entry_biu_pe_req_gateclk_en_x | 1 | - |
| rb_entry_biu_pe_req_x | 1 | - |
| rb_entry_biu_req_x | 1 | - |
| rb_entry_bkpta_data_x | 1 | - |
| rb_entry_bkptb_data_x | 1 | - |
| rb_entry_boundary_wakeup_x | 1 | - |
| rb_entry_bus_err_x | 1 | - |
| rb_entry_cmit_data_vld_x | 1 | - |
| rb_entry_create_lfb_x | 1 | - |
| rb_entry_data_v | 64 | - |
| rb_entry_depd_x | 1 | - |
| rb_entry_discard_vld_x | 1 | - |
| rb_entry_fence_ld_vld_x | 1 | - |
| rb_entry_fence_x | 1 | - |
| rb_entry_flush_clear_x | 1 | - |
| rb_entry_iid_v | 7 | - |
| rb_entry_inst_size_v | 3 | - |
| rb_entry_inst_vfls_x | 1 | - |
| rb_entry_ld_da_hit_idx_x | 1 | - |
| rb_entry_ldamo_x | 1 | - |
| rb_entry_mcic_req_x | 1 | - |
| rb_entry_merge_fail_x | 1 | - |
| rb_entry_page_buf_x | 1 | - |
| rb_entry_page_ca_x | 1 | - |
| rb_entry_page_sec_x | 1 | - |
| rb_entry_page_share_x | 1 | - |
| rb_entry_page_so_x | 1 | - |
| ... | ... | 还有 18 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_rb_entry_gated_clk, x_lsu_rb_entry_create_up_gated_clk, x_lsu_rb_entry_data_gated_clk ... (4个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_rb_entry 模块实现了Replay Buffer - 重放缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
