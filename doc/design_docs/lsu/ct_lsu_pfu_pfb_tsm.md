# ct_lsu_pfu_pfb_tsm 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_pfu_pfb_tsm |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_pfu_pfb_tsm.v |
| 功能描述 | Prefetch Unit - 预取单元 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 24
- 输出端口数量: 9
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| entry_act_vld | 1 | - |
| entry_biu_pe_req_grnt | 1 | - |
| entry_clk | 1 | - |
| entry_create_dp_vld | 1 | - |
| entry_create_vld | 1 | - |
| entry_from_lfb_dcache_hit | 1 | - |
| entry_from_lfb_dcache_miss | 1 | - |
| entry_l1_biu_pe_req_set | 1 | - |
| entry_l1_mmu_pe_req_set | 1 | - |
| entry_l2_biu_pe_req_set | 1 | - |
| entry_l2_mmu_pe_req_set | 1 | - |
| entry_mmu_pe_req_grnt | 1 | - |
| entry_pf_inst_vld | 1 | - |
| entry_pop_vld | 1 | - |
| entry_reinit_vld | 1 | - |
| entry_stride | 11 | - |
| entry_stride_neg | 1 | - |
| forever_cpuclk | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pipe_va | 40 | - |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_biu_pe_req | 1 | - |
| entry_biu_pe_req_src | 2 | - |
| entry_dcache_hit_pop_req | 1 | - |
| entry_inst_new_va | 40 | - |
| entry_mmu_pe_req | 1 | - |
| entry_mmu_pe_req_src | 2 | - |
| entry_priv_mode | 2 | - |
| entry_tsm_is_judge | 1 | - |
| entry_vld | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_pfu_pfb_tsm_pf_inst_vld_gated_clk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_pfu_pfb_tsm 模块实现了Prefetch Unit - 预取单元的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
