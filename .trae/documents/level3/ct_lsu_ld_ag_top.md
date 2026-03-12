# ct_lsu_ld_ag 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_ag |
| 文件路径 | lsu/rtl/ct_lsu_ld_ag.v |
| 功能描述 | 加载地址生成 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_cb_aclr_dis | input | 1 | |
| cp0_lsu_da_fwd_dis | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_mm | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ld_clk | input | 1 | |
| dcache_arb_ag_ld_sel | input | 1 | |
| dcache_arb_ld_ag_addr | input | 40 | |
| dcache_arb_ld_ag_borrow_addr_vld | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_lsu_rf_pipe3_already_da | input | 1 | |
| idu_lsu_rf_pipe3_atomic | input | 1 | |
| idu_lsu_rf_pipe3_bkpta_data | input | 1 | |
| idu_lsu_rf_pipe3_bkptb_data | input | 1 | |
| idu_lsu_rf_pipe3_gateclk_sel | input | 1 | |
| idu_lsu_rf_pipe3_iid | input | 7 | |
| idu_lsu_rf_pipe3_inst_fls | input | 1 | |
| idu_lsu_rf_pipe3_inst_ldr | input | 1 | |
| idu_lsu_rf_pipe3_inst_size | input | 2 | |
| idu_lsu_rf_pipe3_inst_type | input | 2 | |
| idu_lsu_rf_pipe3_lch_entry | input | 12 | |
| idu_lsu_rf_pipe3_lsfifo | input | 1 | |
| idu_lsu_rf_pipe3_no_spec | input | 1 | |
| idu_lsu_rf_pipe3_no_spec_exist | input | 1 | |
| idu_lsu_rf_pipe3_off_0_extend | input | 1 | |
| idu_lsu_rf_pipe3_offset | input | 12 | |
| idu_lsu_rf_pipe3_offset_plus | input | 13 | |
| idu_lsu_rf_pipe3_oldest | input | 1 | |
| ... | ... | ... | 共59个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ag_dcache_arb_ld_data_gateclk_en | output | 8 | |
| ag_dcache_arb_ld_data_high_idx | output | 11 | |
| ag_dcache_arb_ld_data_low_idx | output | 11 | |
| ag_dcache_arb_ld_data_req | output | 8 | |
| ag_dcache_arb_ld_tag_gateclk_en | output | 1 | |
| ag_dcache_arb_ld_tag_idx | output | 9 | |
| ag_dcache_arb_ld_tag_req | output | 1 | |
| ld_ag_addr1_to4 | output | 36 | |
| ld_ag_ahead_predict | output | 1 | |
| ld_ag_already_da | output | 1 | |
| ld_ag_atomic | output | 1 | |
| ld_ag_boundary | output | 1 | |
| ld_ag_dc_access_size | output | 3 | |
| ld_ag_dc_acclr_en | output | 1 | |
| ld_ag_dc_addr0 | output | 40 | |
| ld_ag_dc_bytes_vld | output | 16 | |
| ld_ag_dc_bytes_vld1 | output | 16 | |
| ld_ag_dc_fwd_bypass_en | output | 1 | |
| ld_ag_dc_inst_vld | output | 1 | |
| ld_ag_dc_load_ahead_inst_vld | output | 1 | |
| ld_ag_dc_load_inst_vld | output | 1 | |
| ld_ag_dc_mmu_req | output | 1 | |
| ld_ag_dc_rot_sel | output | 4 | |
| ld_ag_dc_vload_ahead_inst_vld | output | 1 | |
| ld_ag_dc_vload_inst_vld | output | 1 | |
| ld_ag_expt_access_fault_with_page | output | 1 | |
| ld_ag_expt_ldamo_not_ca | output | 1 | |
| ld_ag_expt_misalign_no_page | output | 1 | |
| ld_ag_expt_misalign_with_page | output | 1 | |
| ld_ag_expt_page_fault | output | 1 | |
| ... | ... | ... | 共82个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_ld_ag_gated_clk |
| biu | req_size |
| a | first |
| ct_rtu_compare_iid | x_lsu_rf_compare_ld_ag_iid |
| ct_rtu_compare_iid | x_lsu_ld_ag_compare_st_ag_iid |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
