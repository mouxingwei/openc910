# ct_ifu_pcgen 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_pcgen |
| 文件路径 | ifu/rtl/ct_ifu_pcgen.v |
| 功能描述 | PC生成 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_pcgen_pc | input | 39 | |
| addrgen_pcgen_pcload | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_iwpe | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_ifu_pc | input | 39 | |
| had_ifu_pcload | input | 1 | |
| ibctrl_pcgen_ip_stall | input | 1 | |
| ibctrl_pcgen_pc | input | 39 | |
| ibctrl_pcgen_pcload | input | 1 | |
| ibctrl_pcgen_pcload_vld | input | 1 | |
| ibctrl_pcgen_way_pred | input | 2 | |
| ifctrl_pcgen_chgflw_no_stall_mask | input | 1 | |
| ifctrl_pcgen_chgflw_vld | input | 1 | |
| ifctrl_pcgen_ins_icache_inv_done | input | 1 | |
| ifctrl_pcgen_pcload_pc | input | 39 | |
| ifctrl_pcgen_reissue_pcload | input | 1 | |
| ifctrl_pcgen_stall | input | 1 | |
| ifctrl_pcgen_stall_short | input | 1 | |
| ifctrl_pcgen_way_pred | input | 2 | |
| ipctrl_pcgen_branch_mistaken | input | 1 | |
| ipctrl_pcgen_branch_taken | input | 1 | |
| ipctrl_pcgen_chgflw_pc | input | 39 | |
| ipctrl_pcgen_chgflw_pcload | input | 1 | |
| ipctrl_pcgen_chgflw_way_pred | input | 2 | |
| ipctrl_pcgen_chk_err_reissue | input | 1 | |
| ipctrl_pcgen_h0_vld | input | 1 | |
| ipctrl_pcgen_if_stall | input | 1 | |
| ... | ... | ... | 共93个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_mmu_abort | output | 1 | |
| ifu_mmu_va | output | 63 | |
| ifu_mmu_va_vld | output | 1 | |
| ifu_rtu_cur_pc | output | 39 | |
| ifu_rtu_cur_pc_load | output | 1 | |
| pcgen_addrgen_cancel | output | 1 | |
| pcgen_bht_chgflw | output | 1 | |
| pcgen_bht_chgflw_short | output | 1 | |
| pcgen_bht_ifpc | output | 7 | |
| pcgen_bht_pcindex | output | 10 | |
| pcgen_bht_seq_read | output | 1 | |
| pcgen_btb_chgflw | output | 1 | |
| pcgen_btb_chgflw_higher_than_addrgen | output | 1 | |
| pcgen_btb_chgflw_higher_than_if | output | 1 | |
| pcgen_btb_chgflw_higher_than_ip | output | 1 | |
| pcgen_btb_chgflw_short | output | 1 | |
| pcgen_btb_index | output | 10 | |
| pcgen_btb_stall | output | 1 | |
| pcgen_btb_stall_short | output | 1 | |
| pcgen_debug_chgflw | output | 1 | |
| pcgen_debug_pcbus | output | 14 | |
| pcgen_ibctrl_bju_chgflw | output | 1 | |
| pcgen_ibctrl_cancel | output | 1 | |
| pcgen_ibctrl_ibuf_flush | output | 1 | |
| pcgen_ibctrl_lbuf_flush | output | 1 | |
| pcgen_icache_if_chgflw | output | 1 | |
| pcgen_icache_if_chgflw_bank0 | output | 1 | |
| pcgen_icache_if_chgflw_bank1 | output | 1 | |
| pcgen_icache_if_chgflw_bank2 | output | 1 | |
| pcgen_icache_if_chgflw_bank3 | output | 1 | |
| ... | ... | ... | 共55个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ib | stage |
| Change | Flow |
| gated_clk_cell | x_dbg_dly_clk |
| gated_clk_cell | x_rtu_pcload_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
