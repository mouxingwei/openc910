# ct_idu_id_decd 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_id_decd |
| 文件路径 | idu/rtl/ct_idu_id_decd.v |
| 功能描述 | 指令译码 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_cskyee | input | 1 | |
| cp0_idu_frm | input | 3 | |
| cp0_idu_fs | input | 2 | |
| cp0_idu_vill | input | 1 | |
| cp0_idu_vs | input | 2 | |
| cp0_idu_vstart | input | 7 | |
| cp0_idu_zero_delay_move_disable | input | 1 | |
| cp0_yy_hyper | input | 1 | |
| x_inst | input | 32 | |
| x_vl | input | 8 | |
| x_vlmul | input | 2 | |
| x_vsew | input | 2 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| x_dst_reg | output | 5 | |
| x_dst_vld | output | 1 | |
| x_dst_x0 | output | 1 | |
| x_dste_vld | output | 1 | |
| x_dstf_reg | output | 5 | |
| x_dstf_vld | output | 1 | |
| x_dstv_reg | output | 5 | |
| x_dstv_vld | output | 1 | |
| x_fence_type | output | 3 | |
| x_fmla | output | 1 | |
| x_fmov | output | 1 | |
| x_illegal | output | 1 | |
| x_inst_type | output | 10 | |
| x_length | output | 1 | |
| x_mla | output | 1 | |
| x_mov | output | 1 | |
| x_split_long_type | output | 10 | |
| x_split_short_type | output | 7 | |
| x_src0_reg | output | 5 | |
| x_src0_vld | output | 1 | |
| x_src1_reg | output | 5 | |
| x_src1_vld | output | 1 | |
| x_src2_vld | output | 1 | |
| x_srcf0_reg | output | 5 | |
| x_srcf0_vld | output | 1 | |
| x_srcf1_reg | output | 5 | |
| x_srcf1_vld | output | 1 | |
| x_srcf2_reg | output | 5 | |
| x_srcf2_vld | output | 1 | |
| x_srcv0_reg | output | 5 | |
| ... | ... | ... | 共37个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_idu_id_decd_special | x_ct_idu_id_decd_special |
| pseudo | fmv |
| Full | Decoder |
| Full | Decoder |
| all | case |
| all | case |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
