# ct_lsu_snoop_snq 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_snoop_snq |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_snoop_snq.v |
| 功能描述 | Snoop - 缓存一致性监听 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 45
- 输出端口数量: 62
- 子模块实例数量: 25

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| arb_snq_entry_oldest_index | 6 | - |
| arb_snq_snoop_addr | 40 | - |
| arb_snq_snoop_depd | 10 | - |
| arb_snq_snoop_prot | 3 | - |
| arb_snq_snoop_type | 4 | - |
| biu_lsu_ac_req | 1 | - |
| biu_lsu_ctc_req | 1 | - |
| biu_sdb_cd_ready | 1 | - |
| biu_snq_cr_ready | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_snq_ld_grnt | 1 | - |
| dcache_arb_snq_st_grnt | 1 | - |
| forever_cpuclk | 1 | - |
| ld_da_snq_borrow_sndb | 1 | - |
| ld_da_vb_snq_data_reissue | 1 | - |
| lfb_snq_bypass_data_id | 2 | - |
| lfb_snq_bypass_hit | 1 | - |
| lfb_snq_bypass_share | 1 | - |
| lfb_vb_addr_tto6 | 34 | - |
| lsu_snoop_clk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| sdb_data_vld | 3 | - |
| sdb_entry_avail | 3 | - |
| sdb_entry_data_0 | 128 | - |
| sdb_entry_data_1 | 128 | - |
| sdb_entry_data_2 | 128 | - |
| sdb_vld | 3 | - |
| snoop_req_create_en | 1 | - |
| st_da_snq_borrow_snq | 6 | - |
| ... | ... | 还有 15 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cur_snq_entry_empty | 1 | - |
| lsu_had_cdr_state | 2 | - |
| lsu_had_sdb_entry_vld | 3 | - |
| lsu_had_snoop_data_req | 1 | - |
| lsu_had_snoop_tag_req | 1 | - |
| lsu_had_snq_entry_issued | 6 | - |
| lsu_had_snq_entry_vld | 6 | - |
| lsu_sdb_not_empty | 1 | - |
| lsu_snq_not_empty | 1 | - |
| sdb_biu_cd_data | 128 | - |
| sdb_biu_cd_last | 1 | - |
| sdb_biu_cd_valid | 1 | - |
| sdb_create_data_order | 2 | - |
| sdb_create_en | 3 | - |
| sdb_entry_data_index | 4 | - |
| sdb_inv_en | 3 | - |
| snq_biu_cr_resp | 5 | - |
| snq_biu_cr_valid | 1 | - |
| snq_bypass_addr_tto6 | 34 | - |
| snq_can_create_snq_uncheck | 1 | - |
| snq_create_addr | 40 | - |
| snq_create_lfb_vb_req_hit_idx | 1 | - |
| snq_create_wmb_read_req_hit_idx | 1 | - |
| snq_create_wmb_write_req_hit_idx | 1 | - |
| snq_dcache_arb_borrow_addr | 40 | - |
| snq_dcache_arb_data_way | 1 | - |
| snq_dcache_arb_ld_borrow_req | 1 | - |
| snq_dcache_arb_ld_borrow_req_gate | 1 | - |
| snq_dcache_arb_ld_data_gateclk_en | 8 | - |
| snq_dcache_arb_ld_data_idx | 11 | - |
| ... | ... | 还有 32 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_snq_create_gated_cell, x_lsu_sdb_idfifo_gated_clk, x_snq_sdb_gated_cell ... (5个) | - |
| to | launch | - |
| SNPT | FSM | - |
| data | and, and, and ... (5个) | - |
| tag | state, and | - |
| buffer | maintance | - |
| pop | pointer | - |
| ct_lsu_idfifo_entry | x_ct_lsu_sdb_idfifo_0, x_ct_lsu_sdb_idfifo_1, x_ct_lsu_sdb_idfifo_2 | - |
| ct_lsu_snoop_snq_entry | x_ct_lsu_snoop_snq_entry_0, x_ct_lsu_snoop_snq_entry_1, x_ct_lsu_snoop_snq_entry_2 ... (6个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_snoop_snq 模块实现了Snoop - 缓存一致性监听的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
