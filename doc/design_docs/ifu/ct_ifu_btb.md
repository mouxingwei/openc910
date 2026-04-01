# ct_ifu_btb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_btb |
| 文件名称 | ct_ifu_btb.v |
| 功能描述 | 分支目标缓冲模块 |

### 1.2 功能描述

分支目标缓冲模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_btb_index | input | 10 | - |
| addrgen_btb_tag | input | 10 | - |
| addrgen_btb_target_pc | input | 20 | - |
| addrgen_btb_update_vld | input | 1 | - |
| cp0_ifu_btb_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibdp_btb_miss | input | 1 | - |
| ifctrl_btb_inv | input | 1 | - |
| ipctrl_btb_chgflw_vld | input | 1 | - |
| ipctrl_btb_way_pred | input | 2 | - |
| ipctrl_btb_way_pred_error | input | 1 | - |
| ipdp_btb_index_pc | input | 39 | - |
| ipdp_btb_target_pc | input | 20 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_btb_chgflw | input | 1 | - |
| pcgen_btb_chgflw_higher_than_addrgen | input | 1 | - |
| pcgen_btb_chgflw_higher_than_if | input | 1 | - |
| pcgen_btb_chgflw_higher_than_ip | input | 1 | - |
| pcgen_btb_chgflw_short | input | 1 | - |
| pcgen_btb_index | input | 10 | - |
| pcgen_btb_stall | input | 1 | - |
| pcgen_btb_stall_short | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| btb_ifctrl_inv_done | output | 1 | - |
| btb_ifctrl_inv_on | output | 1 | - |
| btb_ifdp_way0_pred | output | 2 | - |
| btb_ifdp_way0_tag | output | 10 | - |
| btb_ifdp_way0_target | output | 20 | - |
| btb_ifdp_way0_vld | output | 1 | - |
| btb_ifdp_way1_pred | output | 2 | - |
| btb_ifdp_way1_tag | output | 10 | - |
| btb_ifdp_way1_target | output | 20 | - |
| btb_ifdp_way1_vld | output | 1 | - |
| btb_ifdp_way2_pred | output | 2 | - |
| btb_ifdp_way2_tag | output | 10 | - |
| btb_ifdp_way2_target | output | 20 | - |
| btb_ifdp_way2_vld | output | 1 | - |
| btb_ifdp_way3_pred | output | 2 | - |
| btb_ifdp_way3_tag | output | 10 | - |
| btb_ifdp_way3_target | output | 20 | - |
| btb_ifdp_way3_vld | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| INV_CNT_VAL | 1 | 10'b0111111111 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| after_addrgen_btb_chgflw_first | 1 | - |
| after_addrgen_btb_chgflw_second | 1 | - |
| btb_data_dout_reg | 88 | - |
| btb_data_wen | 4 | - |
| btb_index | 10 | - |
| btb_index_flop | 10 | - |
| btb_index_pc_record | 39 | - |
| btb_inv_on_reg | 1 | - |
| btb_inval_cnt | 10 | - |
| btb_rd_flop | 1 | - |
| btb_tag_dout_reg | 44 | - |
| btb_tag_wen | 4 | - |
| btb_target_pc_record | 20 | - |
| refill_buf_index | 10 | - |
| refill_buf_tag | 10 | - |
| refill_buf_target_pc | 20 | - |
| refill_buf_valid | 1 | - |
| refill_buf_way_pred | 2 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_btb_index | 10 | - |
| addrgen_btb_tag | 10 | - |
| addrgen_btb_target_pc | 20 | - |
| addrgen_btb_update_vld | 1 | - |
| btb_buf_tag_data | 10 | - |
| btb_buf_target_pc | 20 | - |
| btb_buf_valid | 1 | - |
| btb_buf_way_pred | 2 | - |
| btb_data_cen_b | 1 | - |
| btb_data_clk_en | 1 | - |
| btb_data_din | 44 | - |
| btb_data_dout | 88 | - |
| btb_data_rd | 1 | - |
| btb_dout_flop_clk | 1 | - |
| btb_dout_flop_clk_en | 1 | - |
| btb_ifctrl_inv_done | 1 | - |
| btb_ifctrl_inv_on | 1 | - |
| btb_ifdp_way0_pred | 2 | - |
| btb_ifdp_way0_tag | 10 | - |
| btb_ifdp_way0_target | 20 | - |
| btb_ifdp_way0_vld | 1 | - |
| btb_ifdp_way1_pred | 2 | - |
| btb_ifdp_way1_tag | 10 | - |
| btb_ifdp_way1_target | 20 | - |
| btb_ifdp_way1_vld | 1 | - |
| btb_ifdp_way2_pred | 2 | - |
| btb_ifdp_way2_tag | 10 | - |
| btb_ifdp_way2_target | 20 | - |
| btb_ifdp_way2_vld | 1 | - |
| btb_ifdp_way3_pred | 2 | - |

*注：共91个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：分支目标缓冲模块
- 所属单元：取指单元(IFU)
- 接口数量：输入25个，输出18个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
