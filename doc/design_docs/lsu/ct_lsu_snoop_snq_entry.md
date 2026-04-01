# ct_lsu_snoop_snq_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_snoop_snq_entry |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_snoop_snq_entry.v |
| 功能描述 | Snoop - 缓存一致性监听 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 34
- 输出端口数量: 26
- 子模块实例数量: 10

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_snq_entry_oldest_index_x | 1 | - |
| biu_snq_cr_resp_acept_x | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_snq_snoop_tag_grnt | 1 | - |
| dcache_snq_snpdt_grnt | 1 | - |
| dcache_snq_tag_resp_dirty | 1 | - |
| dcache_snq_tag_resp_share | 1 | - |
| dcache_snq_tag_resp_valid | 1 | - |
| dcache_snq_tag_resp_way | 1 | - |
| lfb_bypass_vld_x | 1 | - |
| lfb_snq_bypass_data_id | 2 | - |
| lfb_snq_bypass_share | 1 | - |
| lfb_vb_addr_tto6 | 34 | - |
| lsu_snoop_clk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| snpdt_snq_cmplt_x | 1 | - |
| snq_create_addr | 40 | - |
| snq_create_depd | 10 | - |
| snq_create_en_x | 1 | - |
| snq_create_type | 4 | - |
| snq_depd_remove | 10 | - |
| snq_resp_create_en_x | 1 | - |
| snq_snoop_tag_start_x | 1 | - |
| st_da_snq_ecc_err | 1 | - |
| vb_bypass_vld_x | 1 | - |
| vb_snq_bypass_db_id | 3 | - |
| vb_snq_start_wait_x | 1 | - |
| vb_snq_wait_remove | 2 | - |
| vb_snq_wait_vb_id | 2 | - |
| ... | ... | 还有 4 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| snpt_snpdt_start_x | 1 | - |
| snq_cr_resp_valid_x | 1 | - |
| snq_entry_bypass_db_id_v | 3 | - |
| snq_entry_depd_vb_id_v | 2 | - |
| snq_entry_lfb_bypass_chg_tag_data0_x | 1 | - |
| snq_entry_lfb_bypass_chg_tag_data1_x | 1 | - |
| snq_entry_lfb_bypass_invalid_data0_x | 1 | - |
| snq_entry_lfb_bypass_invalid_data1_x | 1 | - |
| snq_entry_lfb_vb_req_hit_idx_x | 1 | - |
| snq_entry_vb_bypass_invalid_x | 1 | - |
| snq_entry_vb_bypass_readonce_x | 1 | - |
| snq_entry_vb_bypass_start_x | 1 | - |
| snq_entry_wmb_read_req_hit_idx_x | 1 | - |
| snq_entry_wmb_write_req_hit_idx_x | 1 | - |
| snq_entryx_addr | 36 | - |
| snq_entryx_cr_resp | 5 | - |
| snq_issued_x | 1 | - |
| snq_need_chg_tag_i_x | 1 | - |
| snq_need_chg_tag_s_x | 1 | - |
| snq_need_chg_tag_x | 1 | - |
| snq_need_read_data_x | 1 | - |
| snq_rd_tag_rdy_x | 1 | - |
| snq_snoop_tag_req_x | 1 | - |
| snq_tag_req_for_inv_x | 1 | - |
| snq_vld_x | 1 | - |
| snq_way_x | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| data | and, and, and | - |
| tag | state | - |
| SNPT | FSM | - |
| SDT | FSM | - |
| gated_clk_cell | x_snq_ctrl_gated_cell, x_snq_depd_gated_cell, x_snq_entry_gated_cell ... (4个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_snoop_snq_entry 模块实现了Snoop - 缓存一致性监听的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
