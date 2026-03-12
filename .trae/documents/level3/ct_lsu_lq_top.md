# ct_lsu_lq 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_lq |
| 文件路径 | lsu/rtl/ct_lsu_lq.v |
| 功能描述 | 加载队列 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_lsu_corr_dis | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ld_dc_addr0 | input | 40 | |
| ld_dc_addr1 | input | 40 | |
| ld_dc_bytes_vld | input | 16 | |
| ld_dc_bytes_vld1 | input | 16 | |
| ld_dc_chk_ld_addr1_vld | input | 1 | |
| ld_dc_iid | input | 7 | |
| ld_dc_inst_chk_vld | input | 1 | |
| ld_dc_lq_create1_dp_vld | input | 1 | |
| ld_dc_lq_create1_gateclk_en | input | 1 | |
| ld_dc_lq_create1_vld | input | 1 | |
| ld_dc_lq_create_dp_vld | input | 1 | |
| ld_dc_lq_create_gateclk_en | input | 1 | |
| ld_dc_lq_create_vld | input | 1 | |
| ld_dc_secd | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_commit0 | input | 1 | |
| rtu_yy_xx_commit0_iid | input | 7 | |
| rtu_yy_xx_commit1 | input | 1 | |
| rtu_yy_xx_commit1_iid | input | 7 | |
| rtu_yy_xx_commit2 | input | 1 | |
| rtu_yy_xx_commit2_iid | input | 7 | |
| rtu_yy_xx_flush | input | 1 | |
| st_dc_addr0 | input | 40 | |
| st_dc_bytes_vld | input | 16 | |
| st_dc_chk_st_inst_vld | input | 1 | |
| ... | ... | ... | 共32个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lq_ld_dc_full | output | 1 | |
| lq_ld_dc_inst_hit | output | 1 | |
| lq_ld_dc_less2 | output | 1 | |
| lq_ld_dc_spec_fail | output | 1 | |
| lq_st_dc_spec_fail | output | 1 | |
| lsu_idu_lq_not_full | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_lq_gated_clk |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_0 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_1 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_2 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_3 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_4 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_5 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_6 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_7 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_8 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_9 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_10 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_11 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_12 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_13 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_14 |
| ct_lsu_lq_entry | x_ct_lsu_lq_entry_15 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
