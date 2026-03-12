# ct_lsu_cache_buffer 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_cache_buffer |
| 文件路径 | lsu/rtl/ct_lsu_cache_buffer.v |
| 功能描述 | Cache缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_cb_aclr_dis | input | 1 | |
| cp0_lsu_dcache_en | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_lsu_no_op_req | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| dcache_idx | input | 9 | |
| forever_cpuclk | input | 1 | |
| icc_idle | input | 1 | |
| ld_da_cb_data | input | 128 | |
| ld_da_cb_data_vld | input | 1 | |
| ld_da_cb_ecc_cancel | input | 1 | |
| ld_da_cb_ld_inst_vld | input | 1 | |
| ld_dc_addr1 | input | 40 | |
| ld_dc_cb_addr_create_gateclk_en | input | 1 | |
| ld_dc_cb_addr_create_vld | input | 1 | |
| ld_dc_cb_addr_tto4 | input | 36 | |
| lsu_dcache_ld_xx_gwen | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cb_ld_da_data | output | 128 | |
| cb_ld_da_data_vld | output | 1 | |
| cb_ld_dc_addr_hit | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_cb_addr_gated_clk |
| gated_clk_cell | x_lsu_cb_data_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
