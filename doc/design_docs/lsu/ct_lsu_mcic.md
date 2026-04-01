# ct_lsu_mcic 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_mcic |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_mcic.v |
| 功能描述 | Multi-Core Interconnect Control - 多核互连控制 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 23
- 输出端口数量: 13
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_lsu_r_data | 128 | - |
| biu_lsu_r_id | 5 | - |
| biu_lsu_r_resp | 4 | - |
| biu_lsu_r_vld | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dcache_arb_mcic_ld_grnt | 1 | - |
| forever_cpuclk | 1 | - |
| ld_da_dcache_hit | 1 | - |
| ld_da_mcic_borrow_mmu_req | 1 | - |
| ld_da_mcic_bypass_data | 64 | - |
| ld_da_mcic_data_err | 1 | - |
| ld_da_mcic_rb_full | 1 | - |
| ld_da_mcic_wakeup | 1 | - |
| lfb_mcic_wakeup | 1 | - |
| mmu_lsu_data_req | 1 | - |
| mmu_lsu_data_req_addr | 40 | - |
| pad_yy_icg_scan_en | 1 | - |
| rb_mcic_ar_id | 5 | - |
| rb_mcic_biu_req_success | 1 | - |
| rb_mcic_ecc_err | 1 | - |
| rb_mcic_not_full | 1 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lsu_had_mcic_data_req | 1 | - |
| lsu_had_mcic_frz | 1 | - |
| lsu_mmu_bus_error | 1 | - |
| lsu_mmu_data | 64 | - |
| lsu_mmu_data_vld | 1 | - |
| mcic_dcache_arb_ld_data_gateclk_en | 8 | - |
| mcic_dcache_arb_ld_data_high_idx | 11 | - |
| mcic_dcache_arb_ld_data_low_idx | 11 | - |
| mcic_dcache_arb_ld_data_req | 8 | - |
| mcic_dcache_arb_ld_req | 1 | - |
| mcic_dcache_arb_ld_tag_gateclk_en | 1 | - |
| mcic_dcache_arb_ld_tag_idx | 9 | - |
| mcic_dcache_arb_req_addr | 40 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_mcic_gated_clk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_mcic 模块实现了Multi-Core Interconnect Control - 多核互连控制的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
