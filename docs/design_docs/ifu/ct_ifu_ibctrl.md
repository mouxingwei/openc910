# ct_ifu_ibctrl 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibctrl |
| 文件名称 | ct_ifu_ibctrl.v |
| 功能描述 | IB阶段控制模块，负责指令缓冲阶段的控制 |

### 1.2 功能描述

IB阶段控制模块，负责指令缓冲阶段的控制。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_ibctrl_cancel | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibdp_ibctrl_chgflw_vl | input | 8 | - |
| ibdp_ibctrl_chgflw_vlmul | input | 2 | - |
| ibdp_ibctrl_chgflw_vsew | input | 3 | - |
| ibdp_ibctrl_default_pc | input | 39 | - |
| ibdp_ibctrl_hn_ind_br | input | 8 | - |
| ibdp_ibctrl_hn_pcall | input | 8 | - |
| ibdp_ibctrl_hn_preturn | input | 8 | - |
| ibdp_ibctrl_l0_btb_mispred_pc | input | 39 | - |
| ibdp_ibctrl_ras_chgflw_mask | input | 1 | - |
| ibdp_ibctrl_ras_mistaken | input | 1 | - |
| ibdp_ibctrl_ras_pc | input | 39 | - |
| ibdp_ibctrl_vpc | input | 39 | - |
| ibuf_ibctrl_empty | input | 1 | - |
| ibuf_ibctrl_stall | input | 1 | - |
| idu_ifu_id_bypass_stall | input | 1 | - |
| idu_ifu_id_stall | input | 1 | - |
| ind_btb_ibctrl_dout | input | 23 | - |
| ind_btb_ibctrl_priv_mode | input | 2 | - |
| ipctrl_ibctrl_expt_vld | input | 1 | - |
| ipctrl_ibctrl_if_chgflw_vld | input | 1 | - |
| ipctrl_ibctrl_ip_chgflw_vld | input | 1 | - |
| ipctrl_ibctrl_l0_btb_hit | input | 1 | - |
| ipctrl_ibctrl_l0_btb_mispred | input | 1 | - |
| ipctrl_ibctrl_l0_btb_miss | input | 1 | - |
| ipctrl_ibctrl_l0_btb_st_wait | input | 1 | - |
| ipctrl_ibctrl_vld | input | 1 | - |
| ipdp_ibdp_vl_reg | input | 8 | - |
| ipdp_ibdp_vlmul_reg | input | 2 | - |
| ipdp_ibdp_vsew_reg | input | 3 | - |
| iu_ifu_chgflw_vld | input | 1 | - |
| iu_ifu_mispred_stall | input | 1 | - |
| iu_ifu_pcfifo_full | input | 1 | - |
| lbuf_ibctrl_active_idle_flush | input | 1 | - |
| lbuf_ibctrl_chgflw_pc | input | 39 | - |
| lbuf_ibctrl_chgflw_pred | input | 2 | - |
| lbuf_ibctrl_chgflw_vl | input | 8 | - |
| lbuf_ibctrl_chgflw_vld | input | 1 | - |
| lbuf_ibctrl_chgflw_vlmul | input | 2 | - |
| lbuf_ibctrl_chgflw_vsew | input | 3 | - |
| lbuf_ibctrl_lbuf_active | input | 1 | - |
| lbuf_ibctrl_stall | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcfifo_if_ibctrl_more_than_two | input | 1 | - |
| pcgen_ibctrl_bju_chgflw | input | 1 | - |
| pcgen_ibctrl_cancel | input | 1 | - |

*注：共52个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibctrl_debug_buf_stall | output | 1 | - |
| ibctrl_debug_bypass_inst_vld | output | 1 | - |
| ibctrl_debug_fifo_full_stall | output | 1 | - |
| ibctrl_debug_fifo_stall | output | 1 | - |
| ibctrl_debug_ib_expt_vld | output | 1 | - |
| ibctrl_debug_ib_ip_stall | output | 1 | - |
| ibctrl_debug_ib_vld | output | 1 | - |
| ibctrl_debug_ibuf_empty | output | 1 | - |
| ibctrl_debug_ibuf_full | output | 1 | - |
| ibctrl_debug_ibuf_inst_vld | output | 1 | - |
| ibctrl_debug_ind_btb_stall | output | 1 | - |
| ibctrl_debug_lbuf_inst_vld | output | 1 | - |
| ibctrl_debug_mispred_stall | output | 1 | - |
| ibctrl_ibdp_buf_stall | output | 1 | - |
| ibctrl_ibdp_bypass_inst_vld | output | 1 | - |
| ibctrl_ibdp_cancel | output | 1 | - |
| ibctrl_ibdp_chgflw | output | 1 | - |
| ibctrl_ibdp_fifo_full_stall | output | 1 | - |
| ibctrl_ibdp_fifo_stall | output | 1 | - |
| ibctrl_ibdp_ibuf_inst_vld | output | 1 | - |
| ibctrl_ibdp_if_chgflw_vld | output | 1 | - |
| ibctrl_ibdp_ind_btb_rd_stall | output | 1 | - |
| ibctrl_ibdp_ip_chgflw_vld | output | 1 | - |
| ibctrl_ibdp_l0_btb_hit | output | 1 | - |
| ibctrl_ibdp_l0_btb_mispred | output | 1 | - |
| ibctrl_ibdp_l0_btb_miss | output | 1 | - |
| ibctrl_ibdp_l0_btb_wait | output | 1 | - |
| ibctrl_ibdp_lbuf_inst_vld | output | 1 | - |
| ibctrl_ibdp_mispred_stall | output | 1 | - |
| ibctrl_ibdp_self_stall | output | 1 | - |
| ibctrl_ibuf_bypass_not_select | output | 1 | - |
| ibctrl_ibuf_create_vld | output | 1 | - |
| ibctrl_ibuf_data_vld | output | 1 | - |
| ibctrl_ibuf_flush | output | 1 | - |
| ibctrl_ibuf_merge_vld | output | 1 | - |
| ibctrl_ibuf_retire_vld | output | 1 | - |
| ibctrl_ind_btb_check_vld | output | 1 | - |
| ibctrl_ind_btb_fifo_stall | output | 1 | - |
| ibctrl_ind_btb_path | output | 8 | - |
| ibctrl_ipctrl_low_power_stall | output | 1 | - |
| ibctrl_ipctrl_stall | output | 1 | - |
| ibctrl_ipdp_chgflw_vl | output | 8 | - |
| ibctrl_ipdp_chgflw_vlmul | output | 2 | - |
| ibctrl_ipdp_chgflw_vsew | output | 3 | - |
| ibctrl_ipdp_pcload | output | 1 | - |
| ibctrl_lbuf_bju_mispred | output | 1 | - |
| ibctrl_lbuf_create_vld | output | 1 | - |
| ibctrl_lbuf_flush | output | 1 | - |
| ibctrl_lbuf_retire_vld | output | 1 | - |
| ibctrl_pcfifo_if_create_vld | output | 1 | - |

*注：共65个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| chgflw_pc | 39 | - |
| chgflw_vl | 8 | - |
| chgflw_vlmul | 2 | - |
| chgflw_vsew | 3 | - |
| ind_btb_rd_state | 1 | - |
| way_pred | 2 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_ibctrl_cancel | 1 | - |
| buf_create_vld | 1 | - |
| buf_stall | 1 | - |
| bypass_inst_vld | 1 | - |
| chgflw_vld | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| fifo_create_vld | 1 | - |
| fifo_full_stall | 1 | - |
| fifo_stall | 1 | - |
| forever_cpuclk | 1 | - |
| hn_ind_br | 8 | - |
| hn_mispred_stall | 8 | - |
| hn_pcall | 8 | - |
| hn_preturn | 8 | - |
| ib_addr_cancel | 1 | - |
| ib_cancel | 1 | - |
| ib_chgflw_self_stall | 1 | - |
| ib_data_vld | 1 | - |
| ib_expt_low_power_stall | 1 | - |
| ib_expt_vld | 1 | - |
| ib_vpc | 39 | - |
| ibctrl_debug_buf_stall | 1 | - |
| ibctrl_debug_bypass_inst_vld | 1 | - |
| ibctrl_debug_fifo_full_stall | 1 | - |
| ibctrl_debug_fifo_stall | 1 | - |
| ibctrl_debug_ib_expt_vld | 1 | - |
| ibctrl_debug_ib_ip_stall | 1 | - |
| ibctrl_debug_ib_vld | 1 | - |

*注：共166个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IB阶段控制模块，负责指令缓冲阶段的控制
- 所属单元：取指单元(IFU)
- 接口数量：输入52个，输出65个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
