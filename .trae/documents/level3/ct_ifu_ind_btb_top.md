# ct_ifu_ind_btb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ind_btb |
| 文件路径 | ifu/rtl/ct_ifu_ind_btb.v |
| 功能描述 | 间接BTB |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_updt_clk |
| gated_clk_cell | x_rtu_path_reg_updt_clk |
| gated_clk_cell | x_path_reg_updt_clk |
| gated_clk_cell | x_dout_update_clk |
| gated_clk_cell | x_ind_btb_inv_reg_upd_clk |
| ct_ifu_ind_btb_array | x_ct_ifu_ind_btb_array |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
