# ct_lsu_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ctrl |
| 文件路径 | lsu/rtl/ct_lsu_ctrl.v |
| 功能描述 | LSU控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_dcache_pref_dist | input | 2 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_l2_pref_dist | input | 2 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_ld_dc_borrow_vld_gate | input | 1 | |
| dcache_arb_st_dc_borrow_vld_gate | input | 1 | |
| forever_cpuclk | input | 1 | |
| hpcp_lsu_cnt_en | input | 1 | |
| icc_vb_create_gateclk_en | input | 1 | |
| idu_lsu_rf_pipe3_gateclk_sel | input | 1 | |
| idu_lsu_rf_pipe3_sel | input | 1 | |
| idu_lsu_rf_pipe4_gateclk_sel | input | 1 | |
| idu_lsu_rf_pipe4_sel | input | 1 | |
| idu_lsu_rf_pipe5_gateclk_sel | input | 1 | |
| idu_lsu_vmb_create0_gateclk_en | input | 1 | |
| idu_lsu_vmb_create1_gateclk_en | input | 1 | |
| ld_ag_inst_vld | input | 1 | |
| ld_ag_stall_ori | input | 1 | |
| ld_ag_stall_restart_entry | input | 12 | |
| ld_da_borrow_vld | input | 1 | |
| ld_da_ecc_wakeup | input | 12 | |
| ld_da_idu_already_da | input | 12 | |
| ld_da_idu_bkpta_data | input | 12 | |
| ld_da_idu_bkptb_data | input | 12 | |
| ld_da_idu_boundary_gateclk_en | input | 12 | |
| ld_da_idu_pop_entry | input | 12 | |
| ld_da_idu_pop_vld | input | 1 | |
| ld_da_idu_rb_full | input | 12 | |
| ld_da_idu_secd | input | 12 | |
| ... | ... | ... | 共158个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_ld_clk | output | 1 | |
| ctrl_st_clk | output | 1 | |
| lsu_had_debug_info | output | 184 | |
| lsu_had_no_op | output | 1 | |
| lsu_hpcp_cache_read_access | output | 1 | |
| lsu_hpcp_cache_read_miss | output | 1 | |
| lsu_hpcp_cache_write_access | output | 1 | |
| lsu_hpcp_cache_write_miss | output | 1 | |
| lsu_hpcp_fence_stall | output | 1 | |
| lsu_hpcp_ld_stall_cross_4k | output | 1 | |
| lsu_hpcp_ld_stall_other | output | 1 | |
| lsu_hpcp_replay_data_discard | output | 1 | |
| lsu_hpcp_replay_discard_sq | output | 1 | |
| lsu_hpcp_st_stall_cross_4k | output | 1 | |
| lsu_hpcp_st_stall_other | output | 1 | |
| lsu_hpcp_unalign_inst | output | 2 | |
| lsu_idu_already_da | output | 12 | |
| lsu_idu_bkpta_data | output | 12 | |
| lsu_idu_bkptb_data | output | 12 | |
| lsu_idu_lq_full | output | 12 | |
| lsu_idu_lq_full_gateclk_en | output | 1 | |
| lsu_idu_lsiq_pop0_vld | output | 1 | |
| lsu_idu_lsiq_pop1_vld | output | 1 | |
| lsu_idu_lsiq_pop_entry | output | 12 | |
| lsu_idu_lsiq_pop_vld | output | 1 | |
| lsu_idu_rb_full | output | 12 | |
| lsu_idu_rb_full_gateclk_en | output | 1 | |
| lsu_idu_secd | output | 12 | |
| lsu_idu_spec_fail | output | 12 | |
| lsu_idu_sq_full | output | 12 | |
| ... | ... | ... | 共44个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_special_clk |
| gated_clk_cell | x_lsu_ctrl_ld_clk |
| gated_clk_cell | x_lsu_ctrl_st_clk |
| gated_clk_cell | x_cp0_lsu_gated_clk |
| gated_clk_cell | x_lsu_hpcp_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
