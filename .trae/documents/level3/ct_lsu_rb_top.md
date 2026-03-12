# ct_lsu_rb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_rb |
| 文件路径 | lsu/rtl/ct_lsu_rb.v |
| 功能描述 | 读缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_b_id | input | 5 | |
| biu_lsu_b_vld | input | 1 | |
| biu_lsu_r_data | input | 128 | |
| biu_lsu_r_id | input | 5 | |
| biu_lsu_r_resp | input | 4 | |
| biu_lsu_r_vld | input | 1 | |
| bus_arb_rb_ar_grnt | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ld_da_addr | input | 40 | |
| ld_da_bkpta_data | input | 1 | |
| ld_da_bkptb_data | input | 1 | |
| ld_da_boundary_after_mask | input | 1 | |
| ld_da_bytes_vld | input | 16 | |
| ld_da_data_ori | input | 64 | |
| ld_da_data_rot_sel | input | 8 | |
| ld_da_dcache_hit | input | 1 | |
| ld_da_idx | input | 8 | |
| ld_da_iid | input | 7 | |
| ld_da_inst_size | input | 3 | |
| ld_da_inst_vfls | input | 1 | |
| ld_da_mcic_borrow_mmu | input | 1 | |
| ld_da_old | input | 1 | |
| ld_da_page_buf | input | 1 | |
| ld_da_page_ca | input | 1 | |
| ld_da_page_sec | input | 1 | |
| ... | ... | ... | 共101个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_had_rb_entry_fence | output | 8 | |
| lsu_had_rb_entry_state_0 | output | 4 | |
| lsu_had_rb_entry_state_1 | output | 4 | |
| lsu_had_rb_entry_state_2 | output | 4 | |
| lsu_had_rb_entry_state_3 | output | 4 | |
| lsu_had_rb_entry_state_4 | output | 4 | |
| lsu_had_rb_entry_state_5 | output | 4 | |
| lsu_had_rb_entry_state_6 | output | 4 | |
| lsu_had_rb_entry_state_7 | output | 4 | |
| lsu_has_fence | output | 1 | |
| lsu_idu_no_fence | output | 1 | |
| lsu_idu_rb_not_full | output | 1 | |
| lsu_rtu_all_commit_ld_data_vld | output | 1 | |
| rb_biu_ar_addr | output | 40 | |
| rb_biu_ar_bar | output | 2 | |
| rb_biu_ar_burst | output | 2 | |
| rb_biu_ar_cache | output | 4 | |
| rb_biu_ar_domain | output | 2 | |
| rb_biu_ar_dp_req | output | 1 | |
| rb_biu_ar_id | output | 5 | |
| rb_biu_ar_len | output | 2 | |
| rb_biu_ar_lock | output | 1 | |
| rb_biu_ar_prot | output | 3 | |
| rb_biu_ar_req | output | 1 | |
| rb_biu_ar_req_gateclk_en | output | 1 | |
| rb_biu_ar_size | output | 3 | |
| rb_biu_ar_snoop | output | 4 | |
| rb_biu_ar_user | output | 3 | |
| rb_biu_req_addr | output | 40 | |
| rb_biu_req_unmask | output | 1 | |
| ... | ... | ... | 共75个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_rb_pe_gated_clk |
| gated_clk_cell | x_lsu_rb_data_ptr_gated_clk |
| ct_lsu_idfifo_8 | x_ct_lsu_rb_idfifo_nc |
| ct_lsu_idfifo_8 | x_ct_lsu_rb_idfifo_so |
| ct_rtu_encode_8 | x_lsu_rb_idfifo_so_req_ptr_encode |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_0 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_1 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_2 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_3 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_4 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_5 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_6 |
| ct_lsu_rb_entry | x_ct_lsu_rb_entry_7 |
| cache | line |
| is | off |
| ct_lsu_rot_data | x_lsu_rb_wb_data_rot |
| ecc | err |
| other | module |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
