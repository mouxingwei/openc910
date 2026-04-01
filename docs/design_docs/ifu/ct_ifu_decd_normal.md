# ct_ifu_decd_normal 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_decd_normal |
| 文件名称 | ct_ifu_decd_normal.v |
| 功能描述 | 正常译码模块 |

### 1.2 功能描述

正常译码模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_vl | input | 8 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| x_br | input | 1 | - |
| x_inst | input | 32 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| x_auipc | output | 1 | - |
| x_branch | output | 1 | - |
| x_chgflw | output | 1 | - |
| x_con_br | output | 1 | - |
| x_dst_vld | output | 1 | - |
| x_ind_br | output | 1 | - |
| x_jal | output | 1 | - |
| x_jalr | output | 1 | - |
| x_ld | output | 1 | - |
| x_offset | output | 21 | - |
| x_pc_oper | output | 1 | - |
| x_pcall | output | 1 | - |
| x_preturn | output | 1 | - |
| x_st | output | 1 | - |
| x_vlmax | output | 8 | - |
| x_vlmul | output | 2 | - |
| x_vsetvli | output | 1 | - |
| x_vsew | output | 3 | - |

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_vl | 8 | - |
| cp0_ifu_vsetvli_pred_disable | 1 | - |
| x_ab_br | 1 | - |
| x_auipc | 1 | - |
| x_br | 1 | - |
| x_branch | 1 | - |
| x_chgflw | 1 | - |
| x_con_br | 1 | - |
| x_dst_vld | 1 | - |
| x_ind_br | 1 | - |
| x_inst | 32 | - |
| x_jal | 1 | - |
| x_jalr | 1 | - |
| x_ld | 1 | - |
| x_offset | 21 | - |
| x_offset_12_ab_br | 21 | - |
| x_offset_12_ab_br_vld | 1 | - |
| x_offset_12_ind_br | 21 | - |
| x_offset_12_ind_br_vld | 1 | - |
| x_offset_13_con_br | 21 | - |
| x_offset_13_con_br_vld | 1 | - |
| x_offset_21_ab_br | 21 | - |
| x_offset_21_ab_br_vld | 1 | - |
| x_offset_9_con_br | 21 | - |
| x_offset_9_con_br_vld | 1 | - |
| x_pc_oper | 1 | - |
| x_pcall | 1 | - |
| x_preturn | 1 | - |
| x_st | 1 | - |
| x_vlmax | 8 | - |

*注：共33个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：正常译码模块
- 所属单元：取指单元(IFU)
- 接口数量：输入4个，输出18个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
