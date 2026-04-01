# ct_lsu_vb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_vb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_vb.v |
| 功能描述 | Victim Buffer - 驱逐缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 66
- 输出端口数量: 88
- 子模块实例数量: 8

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_b_id | 5 | - |
| biu_lsu_b_vld | 1 | - |
| bus_arb_vb_aw_grnt | 1 | - |
| bus_arb_vb_w_grnt | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_vb_ld_grnt | 1 | - |
| dcache_arb_vb_st_grnt | 1 | - |
| icc_vb_addr_tto6 | 34 | - |
| icc_vb_create_dp_vld | 1 | - |
| icc_vb_create_gateclk_en | 1 | - |
| icc_vb_create_req | 1 | - |
| icc_vb_create_vld | 1 | - |
| icc_vb_inv | 1 | - |
| ld_da_vb_snq_data_reissue | 1 | - |
| lfb_vb_addr_tto6 | 34 | - |
| lfb_vb_create_dp_vld | 1 | - |
| lfb_vb_create_gateclk_en | 1 | - |
| lfb_vb_create_req | 1 | - |
| lfb_vb_create_vld | 1 | - |
| lfb_vb_id | 3 | - |
| lsu_special_clk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_req_addr | 40 | - |
| rb_biu_req_addr | 40 | - |
| snq_bypass_addr_tto6 | 34 | - |
| snq_create_addr | 40 | - |
| snq_depd_vb_id | 2 | - |
| snq_vb_bypass_check | 1 | - |
| ... | ... | 还有 36 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_had_vb_addr_entry_vld | 2 | - |
| lsu_had_vb_data_entry_vld | 3 | - |
| lsu_had_vb_rcl_sm_state | 4 | - |
| snq_data_bypass_hit | 3 | - |
| vb_biu_aw_addr | 40 | - |
| vb_biu_aw_bar | 2 | - |
| vb_biu_aw_burst | 2 | - |
| vb_biu_aw_cache | 4 | - |
| vb_biu_aw_domain | 2 | - |
| vb_biu_aw_dp_req | 1 | - |
| vb_biu_aw_id | 5 | - |
| vb_biu_aw_len | 2 | - |
| vb_biu_aw_lock | 1 | - |
| vb_biu_aw_prot | 3 | - |
| vb_biu_aw_req | 1 | - |
| vb_biu_aw_req_gateclk_en | 1 | - |
| vb_biu_aw_size | 3 | - |
| vb_biu_aw_snoop | 3 | - |
| vb_biu_aw_unique | 1 | - |
| vb_biu_aw_user | 1 | - |
| vb_biu_w_data | 128 | - |
| vb_biu_w_id | 5 | - |
| vb_biu_w_last | 1 | - |
| vb_biu_w_req | 1 | - |
| vb_biu_w_strb | 16 | - |
| vb_biu_w_vld | 1 | - |
| vb_data_entry_biu_req_success | 3 | - |
| vb_data_entry_create_dp_vld | 3 | - |
| vb_data_entry_create_gateclk_en | 3 | - |
| vb_data_entry_create_vld | 3 | - |
| ... | ... | 还有 58 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_vb_rcl_sm_clk, x_lsu_vb_rcl_sm_create_clk, x_lsu_vb_wd_sm_clk | - |
| ct_lsu_vb_addr_entry | x_ct_lsu_vb_addr_entry_0, x_ct_lsu_vb_addr_entry_1 | - |
| icc | clear | - |
| ct_rtu_expand_8 | x_lsu_vb_source_id_0_expand, x_lsu_vb_source_id_1_expand | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_vb 模块实现了Victim Buffer - 驱逐缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
