# ct_ifu_addrgen 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_addrgen |
| 文件路径 | ifu/rtl/ct_ifu_addrgen.v |
| 功能描述 | IFU地址生成 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibdp_addrgen_branch_base | input | 39 | |
| ibdp_addrgen_branch_offset | input | 21 | |
| ibdp_addrgen_branch_result | input | 39 | |
| ibdp_addrgen_branch_valid | input | 1 | |
| ibdp_addrgen_branch_vl | input | 8 | |
| ibdp_addrgen_branch_vlmul | input | 2 | |
| ibdp_addrgen_branch_vsew | input | 3 | |
| ibdp_addrgen_btb_index_pc | input | 39 | |
| ibdp_addrgen_l0_btb_hit | input | 1 | |
| ibdp_addrgen_l0_btb_hit_entry | input | 16 | |
| lbuf_addrgen_active_state | input | 1 | |
| lbuf_addrgen_cache_state | input | 1 | |
| lbuf_addrgen_chgflw_mask | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pcgen_addrgen_cancel | input | 1 | |
| cpurst_b | input | 1 | |
| cpurst_b | input | 1 | |
| pcgen_addrgen_cancel | input | 1 | |
| cpurst_b | input | 1 | |
| cpurst_b | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_btb_index | output | 10 | |
| addrgen_btb_tag | output | 10 | |
| addrgen_btb_target_pc | output | 20 | |
| addrgen_btb_update_vld | output | 1 | |
| addrgen_ibctrl_cancel | output | 1 | |
| addrgen_ipdp_chgflw_vl | output | 8 | |
| addrgen_ipdp_chgflw_vlmul | output | 2 | |
| addrgen_ipdp_chgflw_vsew | output | 3 | |
| addrgen_l0_btb_update_entry | output | 16 | |
| addrgen_l0_btb_update_vld | output | 1 | |
| addrgen_l0_btb_update_vld_bit | output | 1 | |
| addrgen_l0_btb_wen | output | 4 | |
| addrgen_pcgen_pc | output | 39 | |
| addrgen_pcgen_pcload | output | 1 | |
| addrgen_xx_pcload | output | 1 | |
| ifu_hpcp_btb_inst | output | 1 | |
| ifu_hpcp_btb_mispred | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_addrgen_flop_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
