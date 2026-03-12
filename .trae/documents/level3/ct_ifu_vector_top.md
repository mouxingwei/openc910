# ct_ifu_vector 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_vector |
| 文件路径 | ifu/rtl/ct_ifu_vector.v |
| 功能描述 | 向量处理 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_rst_inv_done | input | 1 | |
| cp0_ifu_rvbr | input | 40 | |
| cp0_ifu_vbr | input | 40 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_ifu_xx_dbgon | input | 1 | |
| rtu_ifu_xx_expt_vec | input | 6 | |
| rtu_ifu_xx_expt_vld | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_cp0_rst_inv_req | output | 1 | |
| ifu_xx_sync_reset | output | 1 | |
| vector_debug_cur_st | output | 10 | |
| vector_debug_reset_on | output | 1 | |
| vector_ifctrl_reset_on | output | 1 | |
| vector_ifctrl_sm_on | output | 1 | |
| vector_ifctrl_sm_start | output | 1 | |
| vector_pcgen_pc | output | 39 | |
| vector_pcgen_pcload | output | 1 | |
| vector_pcgen_reset_on | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_vec_sm_clk |
| gated_clk_cell | x_vector_pc_update_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
