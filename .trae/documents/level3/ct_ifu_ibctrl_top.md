# ct_ifu_ibctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibctrl |
| 文件路径 | ifu/rtl/ct_ifu_ibctrl.v |
| 功能描述 | 指令缓冲控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_ibctrl_cancel | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibdp_ibctrl_chgflw_vl | input | 8 | |
| ibdp_ibctrl_chgflw_vlmul | input | 2 | |
| ibdp_ibctrl_chgflw_vsew | input | 3 | |
| ibdp_ibctrl_default_pc | input | 39 | |
| ibdp_ibctrl_hn_ind_br | input | 8 | |
| ibdp_ibctrl_hn_pcall | input | 8 | |
| ibdp_ibctrl_hn_preturn | input | 8 | |
| ibdp_ibctrl_l0_btb_mispred_pc | input | 39 | |
| ibdp_ibctrl_ras_chgflw_mask | input | 1 | |
| ibdp_ibctrl_ras_mistaken | input | 1 | |
| ibdp_ibctrl_ras_pc | input | 39 | |
| ibdp_ibctrl_vpc | input | 39 | |
| ibuf_ibctrl_empty | input | 1 | |
| ibuf_ibctrl_stall | input | 1 | |
| idu_ifu_id_bypass_stall | input | 1 | |
| idu_ifu_id_stall | input | 1 | |
| ind_btb_ibctrl_dout | input | 23 | |
| ind_btb_ibctrl_priv_mode | input | 2 | |
| ipctrl_ibctrl_expt_vld | input | 1 | |
| ipctrl_ibctrl_if_chgflw_vld | input | 1 | |
| ipctrl_ibctrl_ip_chgflw_vld | input | 1 | |
| ipctrl_ibctrl_l0_btb_hit | input | 1 | |
| ipctrl_ibctrl_l0_btb_mispred | input | 1 | |
| ipctrl_ibctrl_l0_btb_miss | input | 1 | |
| ipctrl_ibctrl_l0_btb_st_wait | input | 1 | |
| ... | ... | ... | 共52个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibctrl_debug_buf_stall | output | 1 | |
| ibctrl_debug_bypass_inst_vld | output | 1 | |
| ibctrl_debug_fifo_full_stall | output | 1 | |
| ibctrl_debug_fifo_stall | output | 1 | |
| ibctrl_debug_ib_expt_vld | output | 1 | |
| ibctrl_debug_ib_ip_stall | output | 1 | |
| ibctrl_debug_ib_vld | output | 1 | |
| ibctrl_debug_ibuf_empty | output | 1 | |
| ibctrl_debug_ibuf_full | output | 1 | |
| ibctrl_debug_ibuf_inst_vld | output | 1 | |
| ibctrl_debug_ind_btb_stall | output | 1 | |
| ibctrl_debug_lbuf_inst_vld | output | 1 | |
| ibctrl_debug_mispred_stall | output | 1 | |
| ibctrl_ibdp_buf_stall | output | 1 | |
| ibctrl_ibdp_bypass_inst_vld | output | 1 | |
| ibctrl_ibdp_cancel | output | 1 | |
| ibctrl_ibdp_chgflw | output | 1 | |
| ibctrl_ibdp_fifo_full_stall | output | 1 | |
| ibctrl_ibdp_fifo_stall | output | 1 | |
| ibctrl_ibdp_ibuf_inst_vld | output | 1 | |
| ibctrl_ibdp_if_chgflw_vld | output | 1 | |
| ibctrl_ibdp_ind_btb_rd_stall | output | 1 | |
| ibctrl_ibdp_ip_chgflw_vld | output | 1 | |
| ibctrl_ibdp_l0_btb_hit | output | 1 | |
| ibctrl_ibdp_l0_btb_mispred | output | 1 | |
| ibctrl_ibdp_l0_btb_miss | output | 1 | |
| ibctrl_ibdp_l0_btb_wait | output | 1 | |
| ibctrl_ibdp_lbuf_inst_vld | output | 1 | |
| ibctrl_ibdp_mispred_stall | output | 1 | |
| ibctrl_ibdp_self_stall | output | 1 | |
| ... | ... | ... | 共65个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| stall | valid |
| gated_clk_cell | x_ind_btb_rd_state_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
