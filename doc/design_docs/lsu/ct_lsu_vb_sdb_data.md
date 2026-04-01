# ct_lsu_vb_sdb_data 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_vb_sdb_data |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_vb_sdb_data.v |
| 功能描述 | Victim Buffer - 驱逐缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 26
- 输出端口数量: 22
- 子模块实例数量: 4

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| ld_da_data256 | 256 | - |
| ld_da_vb_borrow_vb | 3 | - |
| pad_yy_icg_scan_en | 1 | - |
| sdb_create_data_order | 2 | - |
| sdb_create_en | 3 | - |
| sdb_entry_data_index | 4 | - |
| sdb_inv_en | 3 | - |
| snq_data_bypass_hit | 3 | - |
| snq_vb_bypass_invalid | 3 | - |
| snq_vb_bypass_readonce | 1 | - |
| snq_vb_bypass_start | 3 | - |
| vb_data_entry_biu_req_success | 3 | - |
| vb_data_entry_create_dp_vld | 3 | - |
| vb_data_entry_create_gateclk_en | 3 | - |
| vb_data_entry_create_vld | 3 | - |
| vb_data_entry_wd_sm_grnt | 3 | - |
| vb_rcl_sm_addr_id | 2 | - |
| vb_rcl_sm_data_dcache_dirty | 1 | - |
| vb_rcl_sm_data_set_data_done | 3 | - |
| vb_rcl_sm_inv | 1 | - |
| vb_rcl_sm_lfb_create | 1 | - |
| vb_wd_sm_data_bias | 4 | - |
| vb_wd_sm_data_pop_req | 3 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| sdb_data_vld | 3 | - |
| sdb_entry_avail | 3 | - |
| sdb_entry_data_0 | 128 | - |
| sdb_entry_data_1 | 128 | - |
| sdb_entry_data_2 | 128 | - |
| sdb_vld | 3 | - |
| vb_data_entry_addr_id_0 | 2 | - |
| vb_data_entry_addr_id_1 | 2 | - |
| vb_data_entry_addr_id_2 | 2 | - |
| vb_data_entry_biu_req | 3 | - |
| vb_data_entry_bypass_pop | 3 | - |
| vb_data_entry_dirty | 3 | - |
| vb_data_entry_inv | 3 | - |
| vb_data_entry_lfb_create | 3 | - |
| vb_data_entry_normal_pop | 3 | - |
| vb_data_entry_req_success | 3 | - |
| vb_data_entry_vld | 3 | - |
| vb_data_entry_wd_sm_req | 3 | - |
| vb_data_entry_write_data128_0 | 128 | - |
| vb_data_entry_write_data128_1 | 128 | - |
| vb_data_entry_write_data128_2 | 128 | - |
| vb_sdb_data_entry_vld | 3 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| data | entry | - |
| ct_lsu_vb_sdb_data_entry | x_ct_lsu_vb_sdb_data_entry_0, x_ct_lsu_vb_sdb_data_entry_1, x_ct_lsu_vb_sdb_data_entry_2 | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_vb_sdb_data 模块实现了Victim Buffer - 驱逐缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
