# ct_lsu_st_dc 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_st_dc |
| 文件路径 | lsu/rtl/ct_lsu_st_dc.v |
| 功能描述 | 存储数据Cache |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_l2_st_pref_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_st_clk | input | 1 | |
| dcache_arb_st_dc_borrow_icc | input | 1 | |
| dcache_arb_st_dc_borrow_snq | input | 1 | |
| dcache_arb_st_dc_borrow_snq_id | input | 6 | |
| dcache_arb_st_dc_borrow_vld | input | 1 | |
| dcache_arb_st_dc_borrow_vld_gate | input | 1 | |
| dcache_arb_st_dc_dcache_replace | input | 1 | |
| dcache_arb_st_dc_dcache_sw | input | 1 | |
| dcache_dirty_gwen | input | 1 | |
| dcache_idx | input | 9 | |
| dcache_lsu_st_dirty_dout | input | 7 | |
| dcache_lsu_st_tag_dout | input | 52 | |
| forever_cpuclk | input | 1 | |
| had_yy_xx_bkpta_base | input | 40 | |
| had_yy_xx_bkpta_mask | input | 8 | |
| had_yy_xx_bkpta_rc | input | 1 | |
| had_yy_xx_bkptb_base | input | 40 | |
| had_yy_xx_bkptb_mask | input | 8 | |
| had_yy_xx_bkptb_rc | input | 1 | |
| lq_st_dc_spec_fail | input | 1 | |
| mmu_lsu_mmu_en | input | 1 | |
| mmu_lsu_tlb_busy | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_lsu_commit0_iid_updt_val | input | 7 | |
| rtu_lsu_commit1_iid_updt_val | input | 7 | |
| ... | ... | ... | 共81个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_idu_dc_sdiq_entry | output | 12 | |
| lsu_idu_dc_staddr1_vld | output | 1 | |
| lsu_idu_dc_staddr_unalign | output | 1 | |
| lsu_idu_dc_staddr_vld | output | 1 | |
| lsu_mmu_vabuf1 | output | 28 | |
| st_dc_addr0 | output | 40 | |
| st_dc_already_da | output | 1 | |
| st_dc_atomic | output | 1 | |
| st_dc_bkpta_data | output | 1 | |
| st_dc_bkptb_data | output | 1 | |
| st_dc_borrow_dcache_replace | output | 1 | |
| st_dc_borrow_dcache_sw | output | 1 | |
| st_dc_borrow_icc | output | 1 | |
| st_dc_borrow_snq | output | 1 | |
| st_dc_borrow_snq_id | output | 6 | |
| st_dc_borrow_vld | output | 1 | |
| st_dc_boundary | output | 1 | |
| st_dc_boundary_first | output | 1 | |
| st_dc_bytes_vld | output | 16 | |
| st_dc_chk_st_inst_vld | output | 1 | |
| st_dc_chk_statomic_inst_vld | output | 1 | |
| st_dc_cmit0_iid_crt_hit | output | 1 | |
| st_dc_cmit1_iid_crt_hit | output | 1 | |
| st_dc_cmit2_iid_crt_hit | output | 1 | |
| st_dc_da_dcache_dirty_array | output | 7 | |
| st_dc_da_dcache_tag_array | output | 52 | |
| st_dc_da_expt_vld_gate_en | output | 1 | |
| st_dc_da_inst_vld | output | 1 | |
| st_dc_da_page_buf | output | 1 | |
| st_dc_da_page_ca | output | 1 | |
| ... | ... | ... | 共77个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_st_dc_gated_clk |
| gated_clk_cell | x_lsu_st_dc_inst_gated_clk |
| gated_clk_cell | x_lsu_st_dc_borrow_gated_clk |
| gated_clk_cell | x_lsu_st_dc_expt_illegal_inst_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
