# ct_ifu_pcgen 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_pcgen |
| 文件名称 | ct_ifu_pcgen.v |
| 功能描述 | PC生成模块，负责生成取指地址 |

### 1.2 功能描述

PC生成模块，负责生成取指地址。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_pcgen_pc | input | 39 | - |
| addrgen_pcgen_pcload | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_iwpe | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_ifu_pc | input | 39 | - |
| had_ifu_pcload | input | 1 | - |
| ibctrl_pcgen_ip_stall | input | 1 | - |
| ibctrl_pcgen_pc | input | 39 | - |
| ibctrl_pcgen_pcload | input | 1 | - |
| ibctrl_pcgen_pcload_vld | input | 1 | - |
| ibctrl_pcgen_way_pred | input | 2 | - |
| ifctrl_pcgen_chgflw_no_stall_mask | input | 1 | - |
| ifctrl_pcgen_chgflw_vld | input | 1 | - |
| ifctrl_pcgen_ins_icache_inv_done | input | 1 | - |
| ifctrl_pcgen_pcload_pc | input | 39 | - |
| ifctrl_pcgen_reissue_pcload | input | 1 | - |
| ifctrl_pcgen_stall | input | 1 | - |
| ifctrl_pcgen_stall_short | input | 1 | - |
| ifctrl_pcgen_way_pred | input | 2 | - |
| ipctrl_pcgen_branch_mistaken | input | 1 | - |
| ipctrl_pcgen_branch_taken | input | 1 | - |
| ipctrl_pcgen_chgflw_pc | input | 39 | - |
| ipctrl_pcgen_chgflw_pcload | input | 1 | - |
| ipctrl_pcgen_chgflw_way_pred | input | 2 | - |
| ipctrl_pcgen_chk_err_reissue | input | 1 | - |
| ipctrl_pcgen_h0_vld | input | 1 | - |
| ipctrl_pcgen_if_stall | input | 1 | - |
| ipctrl_pcgen_inner_way0 | input | 1 | - |
| ipctrl_pcgen_inner_way1 | input | 1 | - |
| ipctrl_pcgen_inner_way_pred | input | 2 | - |
| ipctrl_pcgen_reissue_pc | input | 39 | - |
| ipctrl_pcgen_reissue_pcload | input | 1 | - |
| ipctrl_pcgen_reissue_way_pred | input | 2 | - |
| ipctrl_pcgen_taken_pc | input | 39 | - |
| iu_ifu_chgflw_pc | input | 63 | - |
| iu_ifu_chgflw_vld | input | 1 | - |
| lbuf_pcgen_active | input | 1 | - |
| lbuf_pcgen_vld_mask | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| rtu_ifu_chgflw_pc | input | 39 | - |
| rtu_ifu_chgflw_vld | input | 1 | - |
| rtu_ifu_xx_dbgon | input | 1 | - |
| rtu_ifu_xx_expt_vld | input | 1 | - |
| vector_pcgen_pc | input | 39 | - |
| vector_pcgen_pcload | input | 1 | - |
| vector_pcgen_reset_on | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_mmu_abort | output | 1 | - |
| ifu_mmu_va | output | 63 | - |
| ifu_mmu_va_vld | output | 1 | - |
| ifu_rtu_cur_pc | output | 39 | - |
| ifu_rtu_cur_pc_load | output | 1 | - |
| pcgen_addrgen_cancel | output | 1 | - |
| pcgen_bht_chgflw | output | 1 | - |
| pcgen_bht_chgflw_short | output | 1 | - |
| pcgen_bht_ifpc | output | 7 | - |
| pcgen_bht_pcindex | output | 10 | - |
| pcgen_bht_seq_read | output | 1 | - |
| pcgen_btb_chgflw | output | 1 | - |
| pcgen_btb_chgflw_higher_than_addrgen | output | 1 | - |
| pcgen_btb_chgflw_higher_than_if | output | 1 | - |
| pcgen_btb_chgflw_higher_than_ip | output | 1 | - |
| pcgen_btb_chgflw_short | output | 1 | - |
| pcgen_btb_index | output | 10 | - |
| pcgen_btb_stall | output | 1 | - |
| pcgen_btb_stall_short | output | 1 | - |
| pcgen_debug_chgflw | output | 1 | - |
| pcgen_debug_pcbus | output | 14 | - |
| pcgen_ibctrl_bju_chgflw | output | 1 | - |
| pcgen_ibctrl_cancel | output | 1 | - |
| pcgen_ibctrl_ibuf_flush | output | 1 | - |
| pcgen_ibctrl_lbuf_flush | output | 1 | - |
| pcgen_icache_if_chgflw | output | 1 | - |
| pcgen_icache_if_chgflw_bank0 | output | 1 | - |
| pcgen_icache_if_chgflw_bank1 | output | 1 | - |
| pcgen_icache_if_chgflw_bank2 | output | 1 | - |
| pcgen_icache_if_chgflw_bank3 | output | 1 | - |
| pcgen_icache_if_chgflw_short | output | 1 | - |
| pcgen_icache_if_gateclk_en | output | 1 | - |
| pcgen_icache_if_index | output | 16 | - |
| pcgen_icache_if_seq_data_req | output | 1 | - |
| pcgen_icache_if_seq_data_req_short | output | 1 | - |
| pcgen_icache_if_seq_tag_req | output | 1 | - |
| pcgen_icache_if_way_pred | output | 2 | - |
| pcgen_ifctrl_cancel | output | 1 | - |
| pcgen_ifctrl_pc | output | 39 | - |
| pcgen_ifctrl_pipe_cancel | output | 1 | - |
| pcgen_ifctrl_reissue | output | 1 | - |
| pcgen_ifctrl_way_pred | output | 2 | - |
| pcgen_ifctrl_way_pred_stall | output | 1 | - |
| pcgen_ifdp_inc_pc | output | 39 | - |
| pcgen_ifdp_pc | output | 39 | - |
| pcgen_ifdp_way_pred | output | 2 | - |
| pcgen_ipb_chgflw | output | 1 | - |
| pcgen_ipctrl_cancel | output | 1 | - |
| pcgen_ipctrl_pipe_cancel | output | 1 | - |
| pcgen_l0_btb_chgflw_mask | output | 1 | - |

*注：共55个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| chgflw_way_pred | 2 | - |
| chgflw_way_pred_flop | 2 | - |
| dbg_dly_reg | 1 | - |
| if_bht_pc | 7 | - |
| if_pc | 39 | - |
| if_pc_high_spe | 24 | - |
| if_pc_high_spe_vld | 1 | - |
| ifctrl_pcgen_stall_flop | 1 | - |
| ifpc_bht_chgflw_pre | 7 | - |
| ifpc_chgflw_pre | 39 | - |
| ifu_rtu_cur_pc | 39 | - |
| ifu_rtu_cur_pc_load | 1 | - |
| inner_way_pred | 2 | - |
| pc_bus | 16 | - |
| pcgen_chgflw_flop | 1 | - |
| pcgen_ifctrl_way_pred_stall | 1 | - |
| way_pred_flop | 2 | - |
| way_predict | 2 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_pcgen_pc | 39 | - |
| addrgen_pcgen_pcload | 1 | - |
| chgflw_higher_than_btb | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_iwpe | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| dbg_cancel | 1 | - |
| dbg_dly_clk | 1 | - |
| dbg_dly_clk_en | 1 | - |
| forever_cpuclk | 1 | - |
| had_ifu_pc | 39 | - |
| had_ifu_pcload | 1 | - |
| ibctrl_pcgen_ip_stall | 1 | - |
| ibctrl_pcgen_pc | 39 | - |
| ibctrl_pcgen_pcload | 1 | - |
| ibctrl_pcgen_pcload_vld | 1 | - |
| ibctrl_pcgen_way_pred | 2 | - |
| ifctrl_pcgen_chgflw_no_stall_mask | 1 | - |
| ifctrl_pcgen_chgflw_vld | 1 | - |
| ifctrl_pcgen_ins_icache_inv_done | 1 | - |
| ifctrl_pcgen_pcload_pc | 39 | - |
| ifctrl_pcgen_reissue_pcload | 1 | - |
| ifctrl_pcgen_stall | 1 | - |
| ifctrl_pcgen_stall_short | 1 | - |
| ifctrl_pcgen_way_pred | 2 | - |
| ifu_mmu_abort | 1 | - |
| ifu_mmu_va | 63 | - |
| ifu_mmu_va_high | 24 | - |
| ifu_mmu_va_vld | 1 | - |

*注：共117个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：PC生成模块，负责生成取指地址
- 所属单元：取指单元(IFU)
- 接口数量：输入49个，输出55个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
