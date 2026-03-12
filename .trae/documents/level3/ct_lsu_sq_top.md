# ct_lsu_sq 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_sq |
| 文件路径 | lsu/rtl/ct_lsu_sq.v |
| 功能描述 | 存储队列 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| dcache_dirty_din | input | 7 | |
| dcache_dirty_gwen | input | 1 | |
| dcache_dirty_wen | input | 7 | |
| dcache_idx | input | 9 | |
| dcache_tag_din | input | 52 | |
| dcache_tag_gwen | input | 1 | |
| dcache_tag_wen | input | 2 | |
| forever_cpuclk | input | 1 | |
| had_lsu_bus_trace_en | input | 1 | |
| had_lsu_dbg_en | input | 1 | |
| icc_idle | input | 1 | |
| icc_sq_grnt | input | 1 | |
| ld_da_lsid | input | 12 | |
| ld_da_sq_data_discard_vld | input | 1 | |
| ld_da_sq_fwd_id | input | 12 | |
| ld_da_sq_fwd_multi_vld | input | 1 | |
| ld_da_sq_global_discard_vld | input | 1 | |
| ld_dc_addr0 | input | 40 | |
| ld_dc_addr1_11to4 | input | 8 | |
| ld_dc_bytes_vld | input | 16 | |
| ld_dc_bytes_vld1 | input | 16 | |
| ld_dc_chk_atomic_inst_vld | input | 1 | |
| ld_dc_chk_ld_addr1_vld | input | 1 | |
| ld_dc_chk_ld_bypass_vld | input | 1 | |
| ld_dc_chk_ld_inst_vld | input | 1 | |
| ld_dc_iid | input | 7 | |
| ... | ... | ... | 共97个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_had_sq_not_empty | output | 1 | |
| lsu_had_st_addr | output | 40 | |
| lsu_had_st_data | output | 64 | |
| lsu_had_st_iid | output | 7 | |
| lsu_had_st_req | output | 1 | |
| lsu_had_st_type | output | 4 | |
| lsu_idu_sq_not_full | output | 1 | |
| lsu_rtu_all_commit_data_vld | output | 1 | |
| sq_data_depd_wakeup | output | 12 | |
| sq_empty | output | 1 | |
| sq_global_depd_wakeup | output | 12 | |
| sq_icc_clr | output | 1 | |
| sq_icc_inv | output | 1 | |
| sq_icc_req | output | 1 | |
| sq_ld_da_fwd_data | output | 64 | |
| sq_ld_da_fwd_data_pe | output | 64 | |
| sq_ld_dc_addr1_dep_discard | output | 1 | |
| sq_ld_dc_cancel_acc_req | output | 1 | |
| sq_ld_dc_cancel_ahead_wb | output | 1 | |
| sq_ld_dc_data_discard_req | output | 1 | |
| sq_ld_dc_fwd_bypass_multi | output | 1 | |
| sq_ld_dc_fwd_bypass_req | output | 1 | |
| sq_ld_dc_fwd_id | output | 12 | |
| sq_ld_dc_fwd_multi | output | 1 | |
| sq_ld_dc_fwd_multi_mask | output | 1 | |
| sq_ld_dc_fwd_req | output | 1 | |
| sq_ld_dc_has_fwd_req | output | 1 | |
| sq_ld_dc_newest_fwd_data_vld_req | output | 1 | |
| sq_ld_dc_other_discard_req | output | 1 | |
| sq_pfu_pop_synci_inst | output | 1 | |
| ... | ... | ... | 共69个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_sq_gated_clk |
| gated_clk_cell | x_lsu_sq_create_pop_gated_clk |
| gated_clk_cell | x_lsu_sq_wakeup_queue_gated_clk |
| gated_clk_cell | x_lsu_sq_fwd_data_pe_gated_clk |
| gated_clk_cell | x_lsu_sq_pop_gated_clk |
| gated_clk_cell | x_lsu_sq_dbg_gated_clk |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_0 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_1 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_2 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_3 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_4 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_5 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_6 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_7 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_8 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_9 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_10 |
| ct_lsu_sq_entry | x_ct_lsu_sq_entry_11 |
| ct_lsu_rot_data | x_lsu_sq_data_rot_to_mem_format |
| write | port |
| ct_lsu_dcache_info_update | x_lsu_wmb_ce_dcache_info_update |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
