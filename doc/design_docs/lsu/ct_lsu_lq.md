# ct_lsu_lq 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_lq |
| 文件路径 | gen_rtl\lsu\rtl\ct_lsu_lq.v |
| 功能描述 | Load Queue - 加载队列 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 32
- 输出端口数量: 6
- 子模块实例数量: 17

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_corr_dis | 1 | - |
| cp0_lsu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| ld_dc_addr0 | 40 | - |
| ld_dc_addr1 | 40 | - |
| ld_dc_bytes_vld | 16 | - |
| ld_dc_bytes_vld1 | 16 | - |
| ld_dc_chk_ld_addr1_vld | 1 | - |
| ld_dc_iid | 7 | - |
| ld_dc_inst_chk_vld | 1 | - |
| ld_dc_lq_create1_dp_vld | 1 | - |
| ld_dc_lq_create1_gateclk_en | 1 | - |
| ld_dc_lq_create1_vld | 1 | - |
| ld_dc_lq_create_dp_vld | 1 | - |
| ld_dc_lq_create_gateclk_en | 1 | - |
| ld_dc_lq_create_vld | 1 | - |
| ld_dc_secd | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| rtu_yy_xx_commit0 | 1 | - |
| rtu_yy_xx_commit0_iid | 7 | - |
| rtu_yy_xx_commit1 | 1 | - |
| rtu_yy_xx_commit1_iid | 7 | - |
| rtu_yy_xx_commit2 | 1 | - |
| rtu_yy_xx_commit2_iid | 7 | - |
| rtu_yy_xx_flush | 1 | - |
| st_dc_addr0 | 40 | - |
| st_dc_bytes_vld | 16 | - |
| st_dc_chk_st_inst_vld | 1 | - |
| ... | ... | 还有 2 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| lq_ld_dc_full | 1 | - |
| lq_ld_dc_inst_hit | 1 | - |
| lq_ld_dc_less2 | 1 | - |
| lq_ld_dc_spec_fail | 1 | - |
| lq_st_dc_spec_fail | 1 | - |
| lsu_idu_lq_not_full | 1 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_lsu_lq_gated_clk | - |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_0, x_ct_lsu_lq_entry_1, x_ct_lsu_lq_entry_2 ... (16个) | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_lsu_lq 模块实现了Load Queue - 加载队列的功能，是 LSU 流水线的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
