# ct_lsu_st_ag 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_ag |
| 文件路径 | lsu/rtl/ct_lsu_st_ag.v |
| 功能描述 | 存储地址生成 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_mm | input | 1 | |
| cp0_lsu_tvm | input | 1 | |
| cp0_lsu_ucme | input | 1 | |
| cp0_lsu_wa | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cp0_yy_virtual_mode | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_st_clk | input | 1 | |
| dcache_arb_ag_st_sel | input | 1 | |
| dcache_arb_st_ag_addr | input | 40 | |
| dcache_arb_st_ag_borrow_addr_vld | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_lsu_rf_pipe4_already_da | input | 1 | |
| idu_lsu_rf_pipe4_atomic | input | 1 | |
| idu_lsu_rf_pipe4_bkpta_data | input | 1 | |
| idu_lsu_rf_pipe4_bkptb_data | input | 1 | |
| idu_lsu_rf_pipe4_fence_mode | input | 4 | |
| idu_lsu_rf_pipe4_gateclk_sel | input | 1 | |
| idu_lsu_rf_pipe4_icc | input | 1 | |
| idu_lsu_rf_pipe4_iid | input | 7 | |
| idu_lsu_rf_pipe4_inst_code | input | 32 | |
| idu_lsu_rf_pipe4_inst_fls | input | 1 | |
| idu_lsu_rf_pipe4_inst_flush | input | 1 | |
| idu_lsu_rf_pipe4_inst_mode | input | 2 | |
| idu_lsu_rf_pipe4_inst_share | input | 1 | |
| idu_lsu_rf_pipe4_inst_size | input | 2 | |
| idu_lsu_rf_pipe4_inst_str | input | 1 | |
| ... | ... | ... | 共75个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ag_dcache_arb_st_dirty_gateclk_en | output | 1 | |
| ag_dcache_arb_st_dirty_idx | output | 9 | |
| ag_dcache_arb_st_dirty_req | output | 1 | |
| ag_dcache_arb_st_tag_gateclk_en | output | 1 | |
| ag_dcache_arb_st_tag_idx | output | 9 | |
| ag_dcache_arb_st_tag_req | output | 1 | |
| lsu_hpcp_st_cross_4k_stall | output | 1 | |
| lsu_hpcp_st_other_stall | output | 1 | |
| lsu_idu_st_ag_wait_old | output | 12 | |
| lsu_idu_st_ag_wait_old_gateclk_en | output | 1 | |
| lsu_mmu_abort1 | output | 1 | |
| lsu_mmu_id1 | output | 7 | |
| lsu_mmu_st_inst1 | output | 1 | |
| lsu_mmu_stamo_pa | output | 28 | |
| lsu_mmu_stamo_vld | output | 1 | |
| lsu_mmu_va1 | output | 64 | |
| lsu_mmu_va1_vld | output | 1 | |
| st_ag_already_da | output | 1 | |
| st_ag_atomic | output | 1 | |
| st_ag_boundary | output | 1 | |
| st_ag_dc_access_size | output | 3 | |
| st_ag_dc_addr0 | output | 40 | |
| st_ag_dc_bytes_vld | output | 16 | |
| st_ag_dc_inst_vld | output | 1 | |
| st_ag_dc_mmu_req | output | 1 | |
| st_ag_dc_page_share | output | 1 | |
| st_ag_dc_rot_sel | output | 4 | |
| st_ag_expt_access_fault_with_page | output | 1 | |
| st_ag_expt_illegal_inst | output | 1 | |
| st_ag_expt_misalign_no_page | output | 1 | |
| ... | ... | ... | 共66个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_st_ag_gated_clk |
| biu | req_size |
| a | first |
| ct_rtu_compare_iid | x_lsu_rf_compare_st_ag_iid |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
