# ct_lsu_ctrl 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ctrl |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_ctrl.v |
| 功能描述 | Control - 控制模块 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 158
- 输出端口数量: 44
- 子模块实例数量: 5

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_dcache_pref_dist | 2 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_l2_pref_dist | 2 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_ld_dc_borrow_vld_gate | 1 | - |
| dcache_arb_st_dc_borrow_vld_gate | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_lsu_cnt_en | 1 | - |
| icc_vb_create_gateclk_en | 1 | - |
| idu_lsu_rf_pipe3_gateclk_sel | 1 | - |
| idu_lsu_rf_pipe3_sel | 1 | - |
| idu_lsu_rf_pipe4_gateclk_sel | 1 | - |
| idu_lsu_rf_pipe4_sel | 1 | - |
| idu_lsu_rf_pipe5_gateclk_sel | 1 | - |
| idu_lsu_vmb_create0_gateclk_en | 1 | - |
| idu_lsu_vmb_create1_gateclk_en | 1 | - |
| ld_ag_inst_vld | 1 | - |
| ld_ag_stall_ori | 1 | - |
| ld_ag_stall_restart_entry | 12 | - |
| ld_da_borrow_vld | 1 | - |
| ld_da_ecc_wakeup | 12 | - |
| ld_da_idu_already_da | 12 | - |
| ld_da_idu_bkpta_data | 12 | - |
| ld_da_idu_bkptb_data | 12 | - |
| ld_da_idu_boundary_gateclk_en | 12 | - |
| ld_da_idu_pop_entry | 12 | - |
| ld_da_idu_pop_vld | 1 | - |
| ld_da_idu_rb_full | 12 | - |
| ld_da_idu_secd | 12 | - |
| ... | ... | 还有 128 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ctrl_ld_clk | 1 | - |
| ctrl_st_clk | 1 | - |
| lsu_had_debug_info | 184 | - |
| lsu_had_no_op | 1 | - |
| lsu_hpcp_cache_read_access | 1 | - |
| lsu_hpcp_cache_read_miss | 1 | - |
| lsu_hpcp_cache_write_access | 1 | - |
| lsu_hpcp_cache_write_miss | 1 | - |
| lsu_hpcp_fence_stall | 1 | - |
| lsu_hpcp_ld_stall_cross_4k | 1 | - |
| lsu_hpcp_ld_stall_other | 1 | - |
| lsu_hpcp_replay_data_discard | 1 | - |
| lsu_hpcp_replay_discard_sq | 1 | - |
| lsu_hpcp_st_stall_cross_4k | 1 | - |
| lsu_hpcp_st_stall_other | 1 | - |
| lsu_hpcp_unalign_inst | 2 | - |
| lsu_idu_already_da | 12 | - |
| lsu_idu_bkpta_data | 12 | - |
| lsu_idu_bkptb_data | 12 | - |
| lsu_idu_lq_full | 12 | - |
| lsu_idu_lq_full_gateclk_en | 1 | - |
| lsu_idu_lsiq_pop0_vld | 1 | - |
| lsu_idu_lsiq_pop1_vld | 1 | - |
| lsu_idu_lsiq_pop_entry | 12 | - |
| lsu_idu_lsiq_pop_vld | 1 | - |
| lsu_idu_rb_full | 12 | - |
| lsu_idu_rb_full_gateclk_en | 1 | - |
| lsu_idu_secd | 12 | - |
| lsu_idu_spec_fail | 12 | - |
| lsu_idu_sq_full | 12 | - |
| ... | ... | 还有 14 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_special_clk, x_lsu_ctrl_ld_clk, x_lsu_ctrl_st_clk ... (5个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_ctrl 模块实现了Control - 控制模块的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
