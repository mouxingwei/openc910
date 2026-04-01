# ct_ifu_pcfifo_if 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_pcfifo_if |
| 文件名称 | ct_ifu_pcfifo_if.v |
| 功能描述 | PC FIFO接口模块 |

### 1.2 功能描述

PC FIFO接口模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibctrl_pcfifo_if_create_vld | input | 1 | - |
| ibctrl_pcfifo_if_ind_btb_miss | input | 1 | - |
| ibctrl_pcfifo_if_ind_target_pc | input | 39 | - |
| ibctrl_pcfifo_if_ras_target_pc | input | 39 | - |
| ibctrl_pcfifo_if_ras_vld | input | 1 | - |
| ibdp_pcfifo_if_bht_pre_result | input | 2 | - |
| ibdp_pcfifo_if_bht_sel_result | input | 2 | - |
| ibdp_pcfifo_if_h0_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h0_vld | input | 1 | - |
| ibdp_pcfifo_if_h1_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h2_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h3_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h4_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h5_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h6_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h7_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_h8_cur_pc | input | 39 | - |
| ibdp_pcfifo_if_hn_con_br | input | 8 | - |
| ibdp_pcfifo_if_hn_dst_vld | input | 8 | - |
| ibdp_pcfifo_if_hn_jal | input | 8 | - |
| ibdp_pcfifo_if_hn_jalr | input | 8 | - |
| ibdp_pcfifo_if_hn_pc_oper | input | 8 | - |
| ibdp_pcfifo_if_ind_br_offset | input | 21 | - |
| ibdp_pcfifo_if_vghr | input | 22 | - |
| lbuf_pcfifo_if_create_select | input | 1 | - |
| lbuf_pcfifo_if_inst_bht_pre_result | input | 2 | - |
| lbuf_pcfifo_if_inst_bht_sel_result | input | 2 | - |
| lbuf_pcfifo_if_inst_cur_pc | input | 39 | - |
| lbuf_pcfifo_if_inst_pc_oper | input | 1 | - |
| lbuf_pcfifo_if_inst_target_pc | input | 39 | - |
| lbuf_pcfifo_if_inst_vghr | input | 22 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_iu_pcfifo_create0_bht_pred | output | 1 | - |
| ifu_iu_pcfifo_create0_chk_idx | output | 25 | - |
| ifu_iu_pcfifo_create0_cur_pc | output | 40 | - |
| ifu_iu_pcfifo_create0_dst_vld | output | 1 | - |
| ifu_iu_pcfifo_create0_en | output | 1 | - |
| ifu_iu_pcfifo_create0_gateclk_en | output | 1 | - |
| ifu_iu_pcfifo_create0_jal | output | 1 | - |
| ifu_iu_pcfifo_create0_jalr | output | 1 | - |
| ifu_iu_pcfifo_create0_jmp_mispred | output | 1 | - |
| ifu_iu_pcfifo_create0_tar_pc | output | 40 | - |
| ifu_iu_pcfifo_create1_bht_pred | output | 1 | - |
| ifu_iu_pcfifo_create1_chk_idx | output | 25 | - |
| ifu_iu_pcfifo_create1_cur_pc | output | 40 | - |
| ifu_iu_pcfifo_create1_dst_vld | output | 1 | - |
| ifu_iu_pcfifo_create1_en | output | 1 | - |
| ifu_iu_pcfifo_create1_gateclk_en | output | 1 | - |
| ifu_iu_pcfifo_create1_jal | output | 1 | - |
| ifu_iu_pcfifo_create1_jalr | output | 1 | - |
| ifu_iu_pcfifo_create1_jmp_mispred | output | 1 | - |
| ifu_iu_pcfifo_create1_tar_pc | output | 40 | - |
| pcfifo_if_ibctrl_more_than_two | output | 1 | - |
| pcfifo_if_ibdp_over_mask | output | 8 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| hn_pc_mask_head | 8 | - |
| hn_pc_mask_tail | 8 | - |
| inst0_con_br | 1 | - |
| inst0_cur_pc | 39 | - |
| inst0_dst_vld | 1 | - |
| inst0_jal | 1 | - |
| inst0_jalr | 1 | - |
| inst0_vld | 1 | - |
| inst1_cur_pc | 39 | - |
| inst1_dst_vld | 1 | - |
| inst1_jal | 1 | - |
| inst1_jalr | 1 | - |
| inst1_vld | 1 | - |
| over_mask | 8 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| h1_con_br | 1 | - |
| h1_cur_pc | 39 | - |
| h1_dst_vld | 1 | - |
| h1_jal | 1 | - |
| h1_jalr | 1 | - |
| h2_con_br | 1 | - |
| h2_cur_pc | 39 | - |
| h2_dst_vld | 1 | - |
| h2_jal | 1 | - |
| h2_jalr | 1 | - |
| h3_con_br | 1 | - |
| h3_cur_pc | 39 | - |
| h3_dst_vld | 1 | - |
| h3_jal | 1 | - |
| h3_jalr | 1 | - |
| h4_con_br | 1 | - |
| h4_cur_pc | 39 | - |
| h4_dst_vld | 1 | - |
| h4_jal | 1 | - |
| h4_jalr | 1 | - |
| h5_con_br | 1 | - |
| h5_cur_pc | 39 | - |
| h5_dst_vld | 1 | - |
| h5_jal | 1 | - |
| h5_jalr | 1 | - |
| h6_con_br | 1 | - |
| h6_cur_pc | 39 | - |
| h6_dst_vld | 1 | - |
| h6_jal | 1 | - |
| h6_jalr | 1 | - |

*注：共105个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：PC FIFO接口模块
- 所属单元：取指单元(IFU)
- 接口数量：输入31个，输出22个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
