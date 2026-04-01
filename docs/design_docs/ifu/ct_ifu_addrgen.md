# ct_ifu_addrgen 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_addrgen |
| 文件名称 | ct_ifu_addrgen.v |
| 功能描述 | 地址生成模块 |

### 1.2 功能描述

地址生成模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibdp_addrgen_branch_base | input | 39 | - |
| ibdp_addrgen_branch_offset | input | 21 | - |
| ibdp_addrgen_branch_result | input | 39 | - |
| ibdp_addrgen_branch_valid | input | 1 | - |
| ibdp_addrgen_branch_vl | input | 8 | - |
| ibdp_addrgen_branch_vlmul | input | 2 | - |
| ibdp_addrgen_branch_vsew | input | 3 | - |
| ibdp_addrgen_btb_index_pc | input | 39 | - |
| ibdp_addrgen_l0_btb_hit | input | 1 | - |
| ibdp_addrgen_l0_btb_hit_entry | input | 16 | - |
| lbuf_addrgen_active_state | input | 1 | - |
| lbuf_addrgen_cache_state | input | 1 | - |
| lbuf_addrgen_chgflw_mask | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_addrgen_cancel | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_btb_index | output | 10 | - |
| addrgen_btb_tag | output | 10 | - |
| addrgen_btb_target_pc | output | 20 | - |
| addrgen_btb_update_vld | output | 1 | - |
| addrgen_ibctrl_cancel | output | 1 | - |
| addrgen_ipdp_chgflw_vl | output | 8 | - |
| addrgen_ipdp_chgflw_vlmul | output | 2 | - |
| addrgen_ipdp_chgflw_vsew | output | 3 | - |
| addrgen_l0_btb_update_entry | output | 16 | - |
| addrgen_l0_btb_update_vld | output | 1 | - |
| addrgen_l0_btb_update_vld_bit | output | 1 | - |
| addrgen_l0_btb_wen | output | 4 | - |
| addrgen_pcgen_pc | output | 39 | - |
| addrgen_pcgen_pcload | output | 1 | - |
| addrgen_xx_pcload | output | 1 | - |
| ifu_hpcp_btb_inst | output | 1 | - |
| ifu_hpcp_btb_mispred | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_branch_index | 10 | - |
| addrgen_branch_tag | 10 | - |
| addrgen_branch_vl | 8 | - |
| addrgen_branch_vlmul | 2 | - |
| addrgen_branch_vsew | 3 | - |
| addrgen_btb_mispred | 1 | - |
| addrgen_cal_result_flop | 39 | - |
| addrgen_l0_btb_hit | 1 | - |
| addrgen_l0_btb_hit_entry | 16 | - |
| addrgen_vld | 1 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_btb_index | 10 | - |
| addrgen_btb_tag | 10 | - |
| addrgen_btb_target_pc | 20 | - |
| addrgen_btb_update_vld | 1 | - |
| addrgen_flop_clk | 1 | - |
| addrgen_flop_clk_en | 1 | - |
| addrgen_ibctrl_cancel | 1 | - |
| addrgen_ipdp_chgflw_vl | 8 | - |
| addrgen_ipdp_chgflw_vlmul | 2 | - |
| addrgen_ipdp_chgflw_vsew | 3 | - |
| addrgen_l0_btb_update_entry | 16 | - |
| addrgen_l0_btb_update_vld | 1 | - |
| addrgen_l0_btb_update_vld_bit | 1 | - |
| addrgen_l0_btb_wen | 4 | - |
| addrgen_pcgen_pc | 39 | - |
| addrgen_pcgen_pcload | 1 | - |
| addrgen_xx_pcload | 1 | - |
| branch_base | 39 | - |
| branch_cal_result | 39 | - |
| branch_index | 10 | - |
| branch_mispred | 1 | - |
| branch_offset | 39 | - |
| branch_pred_result | 39 | - |
| branch_tag | 10 | - |
| branch_vl | 8 | - |
| branch_vld | 1 | - |
| branch_vld_for_gateclk | 1 | - |
| branch_vlmul | 2 | - |
| branch_vsew | 3 | - |
| cp0_ifu_icg_en | 1 | - |

*注：共54个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：地址生成模块
- 所属单元：取指单元(IFU)
- 接口数量：输入19个，输出17个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
