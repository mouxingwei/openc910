# ct_lsu_dcache_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_dcache_top |
| 文件路径 | lsu/rtl/ct_lsu_dcache_top.v |
| 功能描述 | 数据Cache顶层 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_icg_en | input | 1 | |
| forever_cpuclk | input | 1 | |
| lsu_dcache_ld_data_gateclk_en | input | 8 | |
| lsu_dcache_ld_data_gwen_b | input | 8 | |
| lsu_dcache_ld_data_high_din | input | 128 | |
| lsu_dcache_ld_data_high_idx | input | 11 | |
| lsu_dcache_ld_data_low_din | input | 128 | |
| lsu_dcache_ld_data_low_idx | input | 11 | |
| lsu_dcache_ld_data_sel_b | input | 8 | |
| lsu_dcache_ld_data_wen_b | input | 32 | |
| lsu_dcache_ld_tag_din | input | 54 | |
| lsu_dcache_ld_tag_gateclk_en | input | 1 | |
| lsu_dcache_ld_tag_gwen_b | input | 1 | |
| lsu_dcache_ld_tag_idx | input | 9 | |
| lsu_dcache_ld_tag_sel_b | input | 1 | |
| lsu_dcache_ld_tag_wen_b | input | 2 | |
| lsu_dcache_st_dirty_din | input | 7 | |
| lsu_dcache_st_dirty_gateclk_en | input | 1 | |
| lsu_dcache_st_dirty_gwen_b | input | 1 | |
| lsu_dcache_st_dirty_idx | input | 9 | |
| lsu_dcache_st_dirty_sel_b | input | 1 | |
| lsu_dcache_st_dirty_wen_b | input | 7 | |
| lsu_dcache_st_tag_din | input | 52 | |
| lsu_dcache_st_tag_gateclk_en | input | 1 | |
| lsu_dcache_st_tag_gwen_b | input | 1 | |
| lsu_dcache_st_tag_idx | input | 9 | |
| lsu_dcache_st_tag_sel_b | input | 1 | |
| lsu_dcache_st_tag_wen_b | input | 2 | |
| pad_yy_icg_scan_en | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dcache_lsu_ld_data_bank0_dout | output | 32 | |
| dcache_lsu_ld_data_bank1_dout | output | 32 | |
| dcache_lsu_ld_data_bank2_dout | output | 32 | |
| dcache_lsu_ld_data_bank3_dout | output | 32 | |
| dcache_lsu_ld_data_bank4_dout | output | 32 | |
| dcache_lsu_ld_data_bank5_dout | output | 32 | |
| dcache_lsu_ld_data_bank6_dout | output | 32 | |
| dcache_lsu_ld_data_bank7_dout | output | 32 | |
| dcache_lsu_ld_tag_dout | output | 54 | |
| dcache_lsu_st_dirty_dout | output | 7 | |
| dcache_lsu_st_tag_dout | output | 52 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_lsu_dcache_ld_tag_array | x_ct_lsu_dcache_ld_tag_array |
| ct_lsu_dcache_tag_array | x_ct_lsu_dcache_st_tag_array |
| ct_lsu_dcache_dirty_array | x_ct_lsu_dcache_st_dirty_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank0_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank1_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank2_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank3_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank4_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank5_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank6_array |
| ct_lsu_dcache_data_array | x_ct_lsu_dcache_ld_data_bank7_array |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
