# ct_ifu_l0_btb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_l0_btb |
| 文件名称 | ct_ifu_l0_btb.v |
| 功能描述 | L0 BTB模块 |

### 1.2 功能描述

L0 BTB模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_l0_btb_update_entry | input | 16 | - |
| addrgen_l0_btb_update_vld | input | 1 | - |
| addrgen_l0_btb_update_vld_bit | input | 1 | - |
| addrgen_l0_btb_wen | input | 4 | - |
| cp0_ifu_btb_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_l0btb_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibdp_l0_btb_fifo_update_vld | input | 1 | - |
| ibdp_l0_btb_update_cnt_bit | input | 1 | - |
| ibdp_l0_btb_update_data | input | 37 | - |
| ibdp_l0_btb_update_entry | input | 16 | - |
| ibdp_l0_btb_update_ras_bit | input | 1 | - |
| ibdp_l0_btb_update_vld | input | 1 | - |
| ibdp_l0_btb_update_vld_bit | input | 1 | - |
| ibdp_l0_btb_wen | input | 4 | - |
| ifctrl_l0_btb_inv | input | 1 | - |
| ifctrl_l0_btb_stall | input | 1 | - |
| ipctrl_l0_btb_chgflw_vld | input | 1 | - |
| ipctrl_l0_btb_ip_vld | input | 1 | - |
| ipctrl_l0_btb_wait_next | input | 1 | - |
| ipdp_l0_btb_ras_pc | input | 39 | - |
| ipdp_l0_btb_ras_push | input | 1 | - |
| l0_btb_update_vld_for_gateclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_l0_btb_chgflw_mask | input | 1 | - |
| pcgen_l0_btb_chgflw_pc | input | 15 | - |
| pcgen_l0_btb_chgflw_vld | input | 1 | - |
| pcgen_l0_btb_if_pc | input | 39 | - |
| ras_l0_btb_pc | input | 39 | - |
| ras_l0_btb_push_pc | input | 39 | - |
| ras_l0_btb_ras_push | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| l0_btb_debug_cur_state | output | 2 | - |
| l0_btb_ibdp_entry_fifo | output | 16 | - |
| l0_btb_ifctrl_chgflw_pc | output | 39 | - |
| l0_btb_ifctrl_chgflw_way_pred | output | 2 | - |
| l0_btb_ifctrl_chglfw_vld | output | 1 | - |
| l0_btb_ifdp_chgflw_pc | output | 39 | - |
| l0_btb_ifdp_chgflw_way_pred | output | 2 | - |
| l0_btb_ifdp_counter | output | 1 | - |
| l0_btb_ifdp_entry_hit | output | 16 | - |
| l0_btb_ifdp_hit | output | 1 | - |
| l0_btb_ifdp_ras | output | 1 | - |
| l0_btb_ipctrl_st_wait | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| IDLE | 1 | 2'b01 | - |
| WAIT | 1 | 2'b10 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_fifo | 16 | - |
| entry_hit_flop | 16 | - |
| l0_btb_cur_state | 2 | - |
| l0_btb_entry_inv | 1 | - |
| l0_btb_next_state | 2 | - |
| l0_btb_rd_flop | 1 | - |
| l0_btb_update_cnt_bit | 1 | - |
| l0_btb_update_data | 37 | - |
| l0_btb_update_ras_bit | 1 | - |
| l0_btb_update_vld_bit | 1 | - |
| l0_btb_wen | 4 | - |
| ras_pc | 39 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_l0_btb_update_entry | 16 | - |
| addrgen_l0_btb_update_vld | 1 | - |
| addrgen_l0_btb_update_vld_bit | 1 | - |
| addrgen_l0_btb_wen | 4 | - |
| bypass_rd_hit | 1 | - |
| cp0_ifu_btb_en | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_l0btb_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry0_cnt | 1 | - |
| entry0_ras | 1 | - |
| entry0_rd_hit | 1 | - |
| entry0_tag | 15 | - |
| entry0_target | 20 | - |
| entry0_vld | 1 | - |
| entry0_way_pred | 2 | - |
| entry10_cnt | 1 | - |
| entry10_ras | 1 | - |
| entry10_rd_hit | 1 | - |
| entry10_tag | 15 | - |
| entry10_target | 20 | - |
| entry10_vld | 1 | - |
| entry10_way_pred | 2 | - |
| entry11_cnt | 1 | - |
| entry11_ras | 1 | - |
| entry11_rd_hit | 1 | - |
| entry11_tag | 15 | - |
| entry11_target | 20 | - |
| entry11_vld | 1 | - |

*注：共181个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：L0 BTB模块
- 所属单元：取指单元(IFU)
- 接口数量：输入34个，输出12个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
