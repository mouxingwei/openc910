# ct_lsu_bus_arb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_bus_arb |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_bus_arb.v |
| 功能描述 | Replay Buffer - 重放缓冲 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 99
- 输出端口数量: 66
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_ar_ready | 1 | - |
| biu_lsu_aw_vb_grnt | 1 | - |
| biu_lsu_aw_wmb_grnt | 1 | - |
| biu_lsu_w_vb_grnt | 1 | - |
| biu_lsu_w_wmb_grnt | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pfu_biu_ar_addr | 40 | - |
| pfu_biu_ar_bar | 2 | - |
| pfu_biu_ar_burst | 2 | - |
| pfu_biu_ar_cache | 4 | - |
| pfu_biu_ar_domain | 2 | - |
| pfu_biu_ar_dp_req | 1 | - |
| pfu_biu_ar_id | 5 | - |
| pfu_biu_ar_len | 2 | - |
| pfu_biu_ar_lock | 1 | - |
| pfu_biu_ar_prot | 3 | - |
| pfu_biu_ar_req | 1 | - |
| pfu_biu_ar_req_gateclk_en | 1 | - |
| pfu_biu_ar_size | 3 | - |
| pfu_biu_ar_snoop | 4 | - |
| pfu_biu_ar_user | 3 | - |
| rb_biu_ar_addr | 40 | - |
| rb_biu_ar_bar | 2 | - |
| rb_biu_ar_burst | 2 | - |
| rb_biu_ar_cache | 4 | - |
| rb_biu_ar_domain | 2 | - |
| ... | ... | 还有 69 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bus_arb_pfu_ar_grnt | 1 | - |
| bus_arb_pfu_ar_ready | 1 | - |
| bus_arb_pfu_ar_sel | 1 | - |
| bus_arb_rb_ar_grnt | 1 | - |
| bus_arb_rb_ar_sel | 1 | - |
| bus_arb_vb_aw_grnt | 1 | - |
| bus_arb_vb_w_grnt | 1 | - |
| bus_arb_wmb_ar_grnt | 1 | - |
| bus_arb_wmb_aw_grnt | 1 | - |
| bus_arb_wmb_w_grnt | 1 | - |
| lsu_biu_ar_addr | 40 | - |
| lsu_biu_ar_bar | 2 | - |
| lsu_biu_ar_burst | 2 | - |
| lsu_biu_ar_cache | 4 | - |
| lsu_biu_ar_domain | 2 | - |
| lsu_biu_ar_dp_req | 1 | - |
| lsu_biu_ar_id | 5 | - |
| lsu_biu_ar_len | 2 | - |
| lsu_biu_ar_lock | 1 | - |
| lsu_biu_ar_prot | 3 | - |
| lsu_biu_ar_req | 1 | - |
| lsu_biu_ar_req_gate | 1 | - |
| lsu_biu_ar_size | 3 | - |
| lsu_biu_ar_snoop | 4 | - |
| lsu_biu_ar_user | 3 | - |
| lsu_biu_aw_req_gate | 1 | - |
| lsu_biu_aw_st_addr | 40 | - |
| lsu_biu_aw_st_bar | 2 | - |
| lsu_biu_aw_st_burst | 2 | - |
| lsu_biu_aw_st_cache | 4 | - |
| ... | ... | 还有 36 个端口 |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_bus_arb_mask_gated_clk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_bus_arb 模块实现了Replay Buffer - 重放缓冲的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
