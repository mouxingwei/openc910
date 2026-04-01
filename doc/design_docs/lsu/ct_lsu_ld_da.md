# ct_lsu_ld_da 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_ld_da |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_ld_da.v |
| 功能描述 | Load Data Alignment - 加载数据对齐阶段 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 120
- 输出端口数量: 129
- 子模块实例数量: 13

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cb_ld_da_data | 128 | - |
| cb_ld_da_data_vld | 1 | - |
| cp0_lsu_dcache_en | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_lsu_l2_pref_en | 1 | - |
| cp0_lsu_nsfe | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_dcache_pref_en | 1 | - |
| cpurst_b | 1 | - |
| ctrl_ld_clk | 1 | - |
| dcache_lsu_ld_data_bank0_dout | 32 | - |
| dcache_lsu_ld_data_bank1_dout | 32 | - |
| dcache_lsu_ld_data_bank2_dout | 32 | - |
| dcache_lsu_ld_data_bank3_dout | 32 | - |
| dcache_lsu_ld_data_bank4_dout | 32 | - |
| dcache_lsu_ld_data_bank5_dout | 32 | - |
| dcache_lsu_ld_data_bank6_dout | 32 | - |
| dcache_lsu_ld_data_bank7_dout | 32 | - |
| forever_cpuclk | 1 | - |
| ld_dc_addr0 | 40 | - |
| ld_dc_ahead_predict | 1 | - |
| ld_dc_ahead_preg_wb_vld | 1 | - |
| ld_dc_ahead_vreg_wb_vld | 1 | - |
| ld_dc_already_da | 1 | - |
| ld_dc_atomic | 1 | - |
| ld_dc_bkpta_data | 1 | - |
| ld_dc_bkptb_data | 1 | - |
| ld_dc_borrow_db | 3 | - |
| ld_dc_borrow_icc | 1 | - |
| ld_dc_borrow_icc_tag | 1 | - |
| ... | ... | 还有 90 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ld_da_addr | 40 | - |
| ld_da_bkpta_data | 1 | - |
| ld_da_bkptb_data | 1 | - |
| ld_da_borrow_vld | 1 | - |
| ld_da_boundary_after_mask | 1 | - |
| ld_da_bytes_vld | 16 | - |
| ld_da_cb_data | 128 | - |
| ld_da_cb_data_vld | 1 | - |
| ld_da_cb_ecc_cancel | 1 | - |
| ld_da_cb_ld_inst_vld | 1 | - |
| ld_da_data256 | 256 | - |
| ld_da_data_ori | 64 | - |
| ld_da_data_rot_sel | 8 | - |
| ld_da_dcache_hit | 1 | - |
| ld_da_ecc_wakeup | 12 | - |
| ld_da_fwd_ecc_stall | 1 | - |
| ld_da_icc_read_data | 128 | - |
| ld_da_idu_already_da | 12 | - |
| ld_da_idu_bkpta_data | 12 | - |
| ld_da_idu_bkptb_data | 12 | - |
| ld_da_idu_boundary_gateclk_en | 12 | - |
| ld_da_idu_pop_entry | 12 | - |
| ld_da_idu_pop_vld | 1 | - |
| ld_da_idu_rb_full | 12 | - |
| ld_da_idu_secd | 12 | - |
| ld_da_idu_spec_fail | 12 | - |
| ld_da_idu_wait_fence | 12 | - |
| ld_da_idx | 8 | - |
| ld_da_iid | 7 | - |
| ld_da_inst_size | 3 | - |
| ... | ... | 还有 99 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_ld_da_gated_clk, x_lsu_ld_da_inst_gated_clk, x_lsu_ld_da_borrow_gated_clk ... (11个) | - |
| ct_lsu_rot_data | x_lsu_ld_da_data_rot, x_lsu_ld_da_ahead_preg_data_rot | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_ld_da 模块实现了Load Data Alignment - 加载数据对齐阶段的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
