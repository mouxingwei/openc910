# ct_lsu_rb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_rb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_rb.v |
| 功能描述 | Replay Buffer - 重放缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 101
- 输出端口数量: 75
- 子模块实例数量: 18

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_vld | 1 | - |
| biu_lsu_r_data | 128 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_resp | 4 | - |
| biu_lsu_r_vld | 1 | - |
| bus_arb_rb_ar_grnt | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
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
| ld_da_old | 1 | - |
| ld_da_page_buf | 1 | - |
| ld_da_page_ca | 1 | - |
| ld_da_page_sec | 1 | - |
| ... | ... | 还有 71 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_had_rb_entry_fence | 8 | - |
| lsu_had_rb_entry_state_0 | 4 | - |
| lsu_had_rb_entry_state_1 | 4 | - |
| lsu_had_rb_entry_state_2 | 4 | - |
| lsu_had_rb_entry_state_3 | 4 | - |
| lsu_had_rb_entry_state_4 | 4 | - |
| lsu_had_rb_entry_state_5 | 4 | - |
| lsu_had_rb_entry_state_6 | 4 | - |
| lsu_had_rb_entry_state_7 | 4 | - |
| lsu_has_fence | 1 | - |
| lsu_idu_no_fence | 1 | - |
| lsu_idu_rb_not_full | 1 | - |
| lsu_rtu_all_commit_ld_data_vld | 1 | - |
| rb_biu_ar_addr | 40 | - |
| rb_biu_ar_bar | 2 | - |
| rb_biu_ar_burst | 2 | - |
| rb_biu_ar_cache | 4 | - |
| rb_biu_ar_domain | 2 | - |
| rb_biu_ar_dp_req | 1 | - |
| rb_biu_ar_id | 5 | - |
| rb_biu_ar_len | 2 | - |
| rb_biu_ar_lock | 1 | - |
| rb_biu_ar_prot | 3 | - |
| rb_biu_ar_req | 1 | - |
| rb_biu_ar_req_gateclk_en | 1 | - |
| rb_biu_ar_size | 3 | - |
| rb_biu_ar_snoop | 4 | - |
| rb_biu_ar_user | 3 | - |
| rb_biu_req_addr | 40 | - |
| rb_biu_req_unmask | 1 | - |
| ... | ... | 还有 45 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_rb_pe_gated_clk, x_lsu_rb_data_ptr_gated_clk | - |
| ct_lsu_idfifo_8 | x_ct_lsu_rb_idfifo_nc, x_ct_lsu_rb_idfifo_so | - |
| ct_rtu_encode_8 | x_lsu_rb_idfifo_so_req_ptr_encode | - |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_0, x_ct_lsu_rb_entry_1, x_ct_lsu_rb_entry_2 ... (8个) | - |
| cache | line | - |
| is | off | - |
| ct_lsu_rot_data | x_lsu_rb_wb_data_rot | - |
| ecc | err | - |
| other | module | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_rb 模块实现了Replay Buffer - 重放缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
