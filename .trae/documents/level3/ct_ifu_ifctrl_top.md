# ct_ifu_ifctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ifctrl |
| 文件路径 | ifu/rtl/ct_ifu_ifctrl.v |
| 功能描述 | 取指控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_ifctrl_inv_done | input | 1 | |
| bht_ifctrl_inv_on | input | 1 | |
| btb_ifctrl_inv_done | input | 1 | |
| btb_ifctrl_inv_on | input | 1 | |
| cp0_ifu_bht_inv | input | 1 | |
| cp0_ifu_btb_inv | input | 1 | |
| cp0_ifu_icache_inv | input | 1 | |
| cp0_ifu_icache_read_index | input | 17 | |
| cp0_ifu_icache_read_req | input | 1 | |
| cp0_ifu_icache_read_tag | input | 1 | |
| cp0_ifu_icache_read_way | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_ind_btb_inv | input | 1 | |
| cp0_ifu_no_op_req | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| hpcp_ifu_cnt_en | input | 1 | |
| icache_if_ifctrl_inst_data0 | input | 128 | |
| icache_if_ifctrl_inst_data1 | input | 128 | |
| icache_if_ifctrl_tag_data0 | input | 29 | |
| icache_if_ifctrl_tag_data1 | input | 29 | |
| ind_btb_ifctrl_inv_done | input | 1 | |
| ind_btb_ifctrl_inv_on | input | 1 | |
| ipb_ifctrl_prefetch_idle | input | 1 | |
| ipctrl_ifctrl_bht_stall | input | 1 | |
| ipctrl_ifctrl_stall | input | 1 | |
| ipctrl_ifctrl_stall_short | input | 1 | |
| l0_btb_ifctrl_chgflw_pc | input | 39 | |
| l0_btb_ifctrl_chgflw_way_pred | input | 2 | |
| ... | ... | ... | 共56个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifctrl_bht_inv | output | 1 | |
| ifctrl_bht_pipedown | output | 1 | |
| ifctrl_bht_stall | output | 1 | |
| ifctrl_btb_inv | output | 1 | |
| ifctrl_debug_if_pc_vld | output | 1 | |
| ifctrl_debug_if_stall | output | 1 | |
| ifctrl_debug_if_vld | output | 1 | |
| ifctrl_debug_inv_st | output | 4 | |
| ifctrl_debug_lsu_all_inv | output | 1 | |
| ifctrl_debug_lsu_line_inv | output | 1 | |
| ifctrl_debug_mmu_pavld | output | 1 | |
| ifctrl_debug_way_pred_stall | output | 1 | |
| ifctrl_icache_if_index | output | 39 | |
| ifctrl_icache_if_inv_fifo | output | 1 | |
| ifctrl_icache_if_inv_on | output | 1 | |
| ifctrl_icache_if_read_req_data0 | output | 1 | |
| ifctrl_icache_if_read_req_data1 | output | 1 | |
| ifctrl_icache_if_read_req_index | output | 39 | |
| ifctrl_icache_if_read_req_tag | output | 1 | |
| ifctrl_icache_if_reset_req | output | 1 | |
| ifctrl_icache_if_tag_req | output | 1 | |
| ifctrl_icache_if_tag_wen | output | 3 | |
| ifctrl_ifdp_cancel | output | 1 | |
| ifctrl_ifdp_pipedown | output | 1 | |
| ifctrl_ifdp_stall | output | 1 | |
| ifctrl_ind_btb_inv | output | 1 | |
| ifctrl_ipb_inv_on | output | 1 | |
| ifctrl_ipctrl_if_pcload | output | 1 | |
| ifctrl_ipctrl_vld | output | 1 | |
| ifctrl_l0_btb_inv | output | 1 | |
| ... | ... | ... | 共56个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ifu_no_op_updt_clk |
| way_pred | stall |
| gated_clk_cell | x_hpcp_clk |
| gated_clk_cell | x_if_vld_clk |
| gated_clk_cell | x_ifctrl_reissue_clk |
| gated_clk_cell | x_icache_inv_clk |
| line | inv |
| line | inv |
| gated_clk_cell | x_cache_data_flop_clk |
| gated_clk_cell | x_ins_inv_ptag_flop_clk |
| gated_clk_cell | x_btb_inv_flop_clk |
| gated_clk_cell | x_bht_inv_flop_clk |
| gated_clk_cell | x_ibp_inv_flop_clk |
| gated_clk_cell | x_icache_read_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
