# ct_lsu_wmb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_wmb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_wmb.v |
| 功能描述 | Write Merge Buffer - 写合并缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 117
- 输出端口数量: 121
- 子模块实例数量: 26

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| amr_l2_mem_set | 1 | - |
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_resp | 2 | - |
| biu_lsu_b_vld | 1 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_vld | 1 | - |
| bus_arb_wmb_ar_grnt | 1 | - |
| bus_arb_wmb_aw_grnt | 1 | - |
| bus_arb_wmb_w_grnt | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_no_op_req | 1 | - |
| cp0_lsu_wr_burst_dis | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_wmb_ld_grnt | 1 | - |
| dcache_dirty_din | 7 | - |
| dcache_dirty_gwen | 1 | - |
| dcache_dirty_wen | 7 | - |
| dcache_idx | 9 | - |
| dcache_snq_st_sel | 1 | - |
| dcache_tag_din | 52 | - |
| dcache_tag_gwen | 1 | - |
| dcache_tag_wen | 2 | - |
| dcache_vb_snq_gwen | 1 | - |
| forever_cpuclk | 1 | - |
| icc_wmb_write_imme | 1 | - |
| ld_ag_inst_vld | 1 | - |
| ld_da_fwd_ecc_stall | 1 | - |
| ld_da_lsid | 12 | - |
| ld_da_wmb_discard_vld | 1 | - |
| ... | ... | 还有 87 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_had_wmb_ar_pending | 1 | - |
| lsu_had_wmb_aw_pending | 1 | - |
| lsu_had_wmb_create_ptr | 8 | - |
| lsu_had_wmb_data_ptr | 8 | - |
| lsu_had_wmb_entry_vld | 8 | - |
| lsu_had_wmb_read_ptr | 8 | - |
| lsu_had_wmb_w_pending | 1 | - |
| lsu_had_wmb_write_imme | 1 | - |
| lsu_had_wmb_write_ptr | 8 | - |
| wmb_biu_ar_addr | 40 | - |
| wmb_biu_ar_bar | 2 | - |
| wmb_biu_ar_burst | 2 | - |
| wmb_biu_ar_cache | 4 | - |
| wmb_biu_ar_domain | 2 | - |
| wmb_biu_ar_dp_req | 1 | - |
| wmb_biu_ar_id | 5 | - |
| wmb_biu_ar_len | 2 | - |
| wmb_biu_ar_lock | 1 | - |
| wmb_biu_ar_prot | 3 | - |
| wmb_biu_ar_req | 1 | - |
| wmb_biu_ar_req_gateclk_en | 1 | - |
| wmb_biu_ar_size | 3 | - |
| wmb_biu_ar_snoop | 4 | - |
| wmb_biu_ar_user | 3 | - |
| wmb_biu_aw_addr | 40 | - |
| wmb_biu_aw_bar | 2 | - |
| wmb_biu_aw_burst | 2 | - |
| wmb_biu_aw_cache | 4 | - |
| wmb_biu_aw_domain | 2 | - |
| wmb_biu_aw_dp_req | 1 | - |
| ... | ... | 还有 91 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_wmb_gated_clk, x_lsu_wmb_create_ptr_gated_clk, x_lsu_wmb_read_ptr_gated_clk ... (10个) | - |
| ct_lsu_idfifo_8 | x_ct_lsu_wmb_idfifo_nc, x_ct_lsu_wmb_idfifo_so | - |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_0, x_ct_lsu_wmb_entry_1, x_ct_lsu_wmb_entry_2 ... (8个) | - |
| ct_rtu_encode_8 | x_lsu_wmb_read_ptr_encode, x_lsu_wmb_write_ptr_encode, x_lsu_wmb_write_ptr_next3_encode | - |
| write | leisure | - |
| ar | channel | - |
| aw | channel | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_wmb 模块实现了Write Merge Buffer - 写合并缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
