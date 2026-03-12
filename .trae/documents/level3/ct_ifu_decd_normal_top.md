# ct_ifu_decd_normal 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_decd_normal |
| 文件路径 | ifu/rtl/ct_ifu_decd_normal.v |
| 功能描述 | 正常译码 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_vl | input | 8 | |
| cp0_ifu_vsetvli_pred_disable | input | 1 | |
| x_br | input | 1 | |
| x_inst | input | 32 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| x_auipc | output | 1 | |
| x_branch | output | 1 | |
| x_chgflw | output | 1 | |
| x_con_br | output | 1 | |
| x_dst_vld | output | 1 | |
| x_ind_br | output | 1 | |
| x_jal | output | 1 | |
| x_jalr | output | 1 | |
| x_ld | output | 1 | |
| x_offset | output | 21 | |
| x_pc_oper | output | 1 | |
| x_pcall | output | 1 | |
| x_preturn | output | 1 | |
| x_st | output | 1 | |
| x_vlmax | output | 8 | |
| x_vlmul | output | 2 | |
| x_vsetvli | output | 1 | |
| x_vsew | output | 3 | |

## 3. 子模块列表

无子模块

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
