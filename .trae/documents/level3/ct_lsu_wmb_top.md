# ct_lsu_wmb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_wmb |
| 文件路径 | lsu/rtl/ct_lsu_wmb.v |
| 功能描述 | 写合并缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| amr_l2_mem_set | input | 1 | |
| biu_lsu_b_id | input | 5 | |
| biu_lsu_b_resp | input | 2 | |
| biu_lsu_b_vld | input | 1 | |
| biu_lsu_r_id | input | 5 | |
| biu_lsu_r_vld | input | 1 | |
| bus_arb_wmb_ar_grnt | input | 1 | |
| bus_arb_wmb_aw_grnt | input | 1 | |
| bus_arb_wmb_w_grnt | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_no_op_req | input | 1 | |
| cp0_lsu_wr_burst_dis | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_wmb_ld_grnt | input | 1 | |
| dcache_dirty_din | input | 7 | |
| dcache_dirty_gwen | input | 1 | |
| dcache_dirty_wen | input | 7 | |
| dcache_idx | input | 9 | |
| dcache_snq_st_sel | input | 1 | |
| dcache_tag_din | input | 52 | |
| dcache_tag_gwen | input | 1 | |
| dcache_tag_wen | input | 2 | |
| dcache_vb_snq_gwen | input | 1 | |
| forever_cpuclk | input | 1 | |
| icc_wmb_write_imme | input | 1 | |
| ld_ag_inst_vld | input | 1 | |
| ld_da_fwd_ecc_stall | input | 1 | |
| ld_da_lsid | input | 12 | |
| ld_da_wmb_discard_vld | input | 1 | |
| ... | ... | ... | 共117个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_had_wmb_ar_pending | output | 1 | |
| lsu_had_wmb_aw_pending | output | 1 | |
| lsu_had_wmb_create_ptr | output | 8 | |
| lsu_had_wmb_data_ptr | output | 8 | |
| lsu_had_wmb_entry_vld | output | 8 | |
| lsu_had_wmb_read_ptr | output | 8 | |
| lsu_had_wmb_w_pending | output | 1 | |
| lsu_had_wmb_write_imme | output | 1 | |
| lsu_had_wmb_write_ptr | output | 8 | |
| wmb_biu_ar_addr | output | 40 | |
| wmb_biu_ar_bar | output | 2 | |
| wmb_biu_ar_burst | output | 2 | |
| wmb_biu_ar_cache | output | 4 | |
| wmb_biu_ar_domain | output | 2 | |
| wmb_biu_ar_dp_req | output | 1 | |
| wmb_biu_ar_id | output | 5 | |
| wmb_biu_ar_len | output | 2 | |
| wmb_biu_ar_lock | output | 1 | |
| wmb_biu_ar_prot | output | 3 | |
| wmb_biu_ar_req | output | 1 | |
| wmb_biu_ar_req_gateclk_en | output | 1 | |
| wmb_biu_ar_size | output | 3 | |
| wmb_biu_ar_snoop | output | 4 | |
| wmb_biu_ar_user | output | 3 | |
| wmb_biu_aw_addr | output | 40 | |
| wmb_biu_aw_bar | output | 2 | |
| wmb_biu_aw_burst | output | 2 | |
| wmb_biu_aw_cache | output | 4 | |
| wmb_biu_aw_domain | output | 2 | |
| wmb_biu_aw_dp_req | output | 1 | |
| ... | ... | ... | 共121个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_wmb_gated_clk |
| gated_clk_cell | x_lsu_wmb_create_ptr_gated_clk |
| gated_clk_cell | x_lsu_wmb_read_ptr_gated_clk |
| gated_clk_cell | x_lsu_wmb_write_ptr_gated_clk |
| gated_clk_cell | x_lsu_wmb_data_ptr_gated_clk |
| gated_clk_cell | x_lsu_wmb_fwd_data_pe_gated_clk |
| gated_clk_cell | x_lsu_wmb_write_pop_gated_clk |
| gated_clk_cell | x_lsu_wmb_write_dcache_pop_gated_clk |
| gated_clk_cell | x_lsu_wmb_read_pop_gated_clk |
| gated_clk_cell | x_lsu_wmb_wakeup_queue_gated_clk |
| ct_lsu_idfifo_8 | x_ct_lsu_wmb_idfifo_nc |
| ct_lsu_idfifo_8 | x_ct_lsu_wmb_idfifo_so |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_0 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_1 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_2 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_3 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_4 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_5 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_6 |
| ct_lsu_wmb_entry | x_ct_lsu_wmb_entry_7 |
| ct_rtu_encode_8 | x_lsu_wmb_read_ptr_encode |
| ct_rtu_encode_8 | x_lsu_wmb_write_ptr_encode |
| ct_rtu_encode_8 | x_lsu_wmb_write_ptr_next3_encode |
| write | leisure |
| ar | channel |
| aw | channel |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
