# ct_lsu_ld_ag 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_ag |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_ld_ag.v |
| 功能描述 | Load Address Generation - 加载地址生成阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 59
- 输出端口数量: 82
- 子模块实例数量: 5

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_cb_aclr_dis | 1 | - |
| cp0_lsu_da_fwd_dis | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_mm | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_ld_clk | 1 | - |
| dcache_arb_ag_ld_sel | 1 | - |
| dcache_arb_ld_ag_addr | 40 | - |
| dcache_arb_ld_ag_borrow_addr_vld | 1 | - |
| forever_cpuclk | 1 | - |
| idu_lsu_rf_pipe3_already_da | 1 | - |
| idu_lsu_rf_pipe3_atomic | 1 | - |
| idu_lsu_rf_pipe3_bkpta_data | 1 | - |
| idu_lsu_rf_pipe3_bkptb_data | 1 | - |
| idu_lsu_rf_pipe3_gateclk_sel | 1 | - |
| idu_lsu_rf_pipe3_iid | 7 | - |
| idu_lsu_rf_pipe3_inst_fls | 1 | - |
| idu_lsu_rf_pipe3_inst_ldr | 1 | - |
| idu_lsu_rf_pipe3_inst_size | 2 | - |
| idu_lsu_rf_pipe3_inst_type | 2 | - |
| idu_lsu_rf_pipe3_lch_entry | 12 | - |
| idu_lsu_rf_pipe3_lsfifo | 1 | - |
| idu_lsu_rf_pipe3_no_spec | 1 | - |
| idu_lsu_rf_pipe3_no_spec_exist | 1 | - |
| idu_lsu_rf_pipe3_off_0_extend | 1 | - |
| idu_lsu_rf_pipe3_offset | 12 | - |
| idu_lsu_rf_pipe3_offset_plus | 13 | - |
| idu_lsu_rf_pipe3_oldest | 1 | - |
| ... | ... | 还有 29 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ag_dcache_arb_ld_data_gateclk_en | 8 | - |
| ag_dcache_arb_ld_data_high_idx | 11 | - |
| ag_dcache_arb_ld_data_low_idx | 11 | - |
| ag_dcache_arb_ld_data_req | 8 | - |
| ag_dcache_arb_ld_tag_gateclk_en | 1 | - |
| ag_dcache_arb_ld_tag_idx | 9 | - |
| ag_dcache_arb_ld_tag_req | 1 | - |
| ld_ag_addr1_to4 | 36 | - |
| ld_ag_ahead_predict | 1 | - |
| ld_ag_already_da | 1 | - |
| ld_ag_atomic | 1 | - |
| ld_ag_boundary | 1 | - |
| ld_ag_dc_access_size | 3 | - |
| ld_ag_dc_acclr_en | 1 | - |
| ld_ag_dc_addr0 | 40 | - |
| ld_ag_dc_bytes_vld | 16 | - |
| ld_ag_dc_bytes_vld1 | 16 | - |
| ld_ag_dc_fwd_bypass_en | 1 | - |
| ld_ag_dc_inst_vld | 1 | - |
| ld_ag_dc_load_ahead_inst_vld | 1 | - |
| ld_ag_dc_load_inst_vld | 1 | - |
| ld_ag_dc_mmu_req | 1 | - |
| ld_ag_dc_rot_sel | 4 | - |
| ld_ag_dc_vload_ahead_inst_vld | 1 | - |
| ld_ag_dc_vload_inst_vld | 1 | - |
| ld_ag_expt_access_fault_with_page | 1 | - |
| ld_ag_expt_ldamo_not_ca | 1 | - |
| ld_ag_expt_misalign_no_page | 1 | - |
| ld_ag_expt_misalign_with_page | 1 | - |
| ld_ag_expt_page_fault | 1 | - |
| ... | ... | 还有 52 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_ld_ag_gated_clk | - |
| biu | req_size | - |
| a | first | - |
| ct_rtu_compare_iid | x_lsu_rf_compare_ld_ag_iid, x_lsu_ld_ag_compare_st_ag_iid | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_ld_ag 模块实现了Load Address Generation - 加载地址生成阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
