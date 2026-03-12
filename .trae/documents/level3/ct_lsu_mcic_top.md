# ct_lsu_mcic 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_mcic |
| 文件路径 | lsu/rtl/ct_lsu_mcic.v |
| 功能描述 | MCIC控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_r_data | input | 128 | |
| biu_lsu_r_id | input | 5 | |
| biu_lsu_r_resp | input | 4 | |
| biu_lsu_r_vld | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_arb_mcic_ld_grnt | input | 1 | |
| forever_cpuclk | input | 1 | |
| ld_da_dcache_hit | input | 1 | |
| ld_da_mcic_borrow_mmu_req | input | 1 | |
| ld_da_mcic_bypass_data | input | 64 | |
| ld_da_mcic_data_err | input | 1 | |
| ld_da_mcic_rb_full | input | 1 | |
| ld_da_mcic_wakeup | input | 1 | |
| lfb_mcic_wakeup | input | 1 | |
| mmu_lsu_data_req | input | 1 | |
| mmu_lsu_data_req_addr | input | 40 | |
| pad_yy_icg_scan_en | input | 1 | |
| rb_mcic_ar_id | input | 5 | |
| rb_mcic_biu_req_success | input | 1 | |
| rb_mcic_ecc_err | input | 1 | |
| rb_mcic_not_full | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lsu_had_mcic_data_req | output | 1 | |
| lsu_had_mcic_frz | output | 1 | |
| lsu_mmu_bus_error | output | 1 | |
| lsu_mmu_data | output | 64 | |
| lsu_mmu_data_vld | output | 1 | |
| mcic_dcache_arb_ld_data_gateclk_en | output | 8 | |
| mcic_dcache_arb_ld_data_high_idx | output | 11 | |
| mcic_dcache_arb_ld_data_low_idx | output | 11 | |
| mcic_dcache_arb_ld_data_req | output | 8 | |
| mcic_dcache_arb_ld_req | output | 1 | |
| mcic_dcache_arb_ld_tag_gateclk_en | output | 1 | |
| mcic_dcache_arb_ld_tag_idx | output | 9 | |
| mcic_dcache_arb_req_addr | output | 40 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_mcic_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
