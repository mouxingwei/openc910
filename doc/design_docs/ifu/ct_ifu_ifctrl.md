# ct_ifu_ifctrl 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ifctrl |
| 文件名称 | ct_ifu_ifctrl.v |
| 功能描述 | IF阶段控制模块，负责取指阶段的控制逻辑 |

### 1.2 功能描述

IF阶段控制模块，负责取指阶段的控制逻辑。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_ifctrl_inv_done | input | 1 | - |
| bht_ifctrl_inv_on | input | 1 | - |
| btb_ifctrl_inv_done | input | 1 | - |
| btb_ifctrl_inv_on | input | 1 | - |
| cp0_ifu_bht_inv | input | 1 | - |
| cp0_ifu_btb_inv | input | 1 | - |
| cp0_ifu_icache_inv | input | 1 | - |
| cp0_ifu_icache_read_index | input | 17 | - |
| cp0_ifu_icache_read_req | input | 1 | - |
| cp0_ifu_icache_read_tag | input | 1 | - |
| cp0_ifu_icache_read_way | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_ind_btb_inv | input | 1 | - |
| cp0_ifu_no_op_req | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| hpcp_ifu_cnt_en | input | 1 | - |
| icache_if_ifctrl_inst_data0 | input | 128 | - |
| icache_if_ifctrl_inst_data1 | input | 128 | - |
| icache_if_ifctrl_tag_data0 | input | 29 | - |
| icache_if_ifctrl_tag_data1 | input | 29 | - |
| ind_btb_ifctrl_inv_done | input | 1 | - |
| ind_btb_ifctrl_inv_on | input | 1 | - |
| ipb_ifctrl_prefetch_idle | input | 1 | - |
| ipctrl_ifctrl_bht_stall | input | 1 | - |
| ipctrl_ifctrl_stall | input | 1 | - |
| ipctrl_ifctrl_stall_short | input | 1 | - |
| l0_btb_ifctrl_chgflw_pc | input | 39 | - |
| l0_btb_ifctrl_chgflw_way_pred | input | 2 | - |
| l0_btb_ifctrl_chglfw_vld | input | 1 | - |
| l1_refill_ifctrl_ctc | input | 1 | - |
| l1_refill_ifctrl_idle | input | 1 | - |
| l1_refill_ifctrl_pc | input | 39 | - |
| l1_refill_ifctrl_refill_on | input | 1 | - |
| l1_refill_ifctrl_reissue | input | 1 | - |
| l1_refill_ifctrl_start | input | 1 | - |
| l1_refill_ifctrl_start_for_gateclk | input | 1 | - |
| l1_refill_ifctrl_trans_cmplt | input | 1 | - |
| l1_refill_inv_wfd_back | input | 1 | - |
| lsu_ifu_icache_all_inv | input | 1 | - |
| lsu_ifu_icache_index | input | 6 | - |
| lsu_ifu_icache_line_inv | input | 1 | - |
| lsu_ifu_icache_ptag | input | 28 | - |
| mmu_ifu_pavld | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_ifctrl_cancel | input | 1 | - |
| pcgen_ifctrl_pc | input | 39 | - |
| pcgen_ifctrl_pipe_cancel | input | 1 | - |
| pcgen_ifctrl_reissue | input | 1 | - |

*注：共56个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifctrl_bht_inv | output | 1 | - |
| ifctrl_bht_pipedown | output | 1 | - |
| ifctrl_bht_stall | output | 1 | - |
| ifctrl_btb_inv | output | 1 | - |
| ifctrl_debug_if_pc_vld | output | 1 | - |
| ifctrl_debug_if_stall | output | 1 | - |
| ifctrl_debug_if_vld | output | 1 | - |
| ifctrl_debug_inv_st | output | 4 | - |
| ifctrl_debug_lsu_all_inv | output | 1 | - |
| ifctrl_debug_lsu_line_inv | output | 1 | - |
| ifctrl_debug_mmu_pavld | output | 1 | - |
| ifctrl_debug_way_pred_stall | output | 1 | - |
| ifctrl_icache_if_index | output | 39 | - |
| ifctrl_icache_if_inv_fifo | output | 1 | - |
| ifctrl_icache_if_inv_on | output | 1 | - |
| ifctrl_icache_if_read_req_data0 | output | 1 | - |
| ifctrl_icache_if_read_req_data1 | output | 1 | - |
| ifctrl_icache_if_read_req_index | output | 39 | - |
| ifctrl_icache_if_read_req_tag | output | 1 | - |
| ifctrl_icache_if_reset_req | output | 1 | - |
| ifctrl_icache_if_tag_req | output | 1 | - |
| ifctrl_icache_if_tag_wen | output | 3 | - |
| ifctrl_ifdp_cancel | output | 1 | - |
| ifctrl_ifdp_pipedown | output | 1 | - |
| ifctrl_ifdp_stall | output | 1 | - |
| ifctrl_ind_btb_inv | output | 1 | - |
| ifctrl_ipb_inv_on | output | 1 | - |
| ifctrl_ipctrl_if_pcload | output | 1 | - |
| ifctrl_ipctrl_vld | output | 1 | - |
| ifctrl_l0_btb_inv | output | 1 | - |
| ifctrl_l0_btb_stall | output | 1 | - |
| ifctrl_l1_refill_ins_inv | output | 1 | - |
| ifctrl_l1_refill_ins_inv_dn | output | 1 | - |
| ifctrl_l1_refill_inv_busy | output | 1 | - |
| ifctrl_l1_refill_inv_on | output | 1 | - |
| ifctrl_lbuf_ins_inv_on | output | 1 | - |
| ifctrl_lbuf_inv_req | output | 1 | - |
| ifctrl_pcgen_chgflw_no_stall_mask | output | 1 | - |
| ifctrl_pcgen_chgflw_vld | output | 1 | - |
| ifctrl_pcgen_ins_icache_inv_done | output | 1 | - |
| ifctrl_pcgen_pcload_pc | output | 39 | - |
| ifctrl_pcgen_reissue_pcload | output | 1 | - |
| ifctrl_pcgen_stall | output | 1 | - |
| ifctrl_pcgen_stall_short | output | 1 | - |
| ifctrl_pcgen_way_pred | output | 2 | - |
| ifu_cp0_bht_inv_done | output | 1 | - |
| ifu_cp0_btb_inv_done | output | 1 | - |
| ifu_cp0_icache_inv_done | output | 1 | - |
| ifu_cp0_icache_read_data | output | 128 | - |
| ifu_cp0_icache_read_data_vld | output | 1 | - |

*注：共56个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| IDLE | 1 | 4'b0000 | - |
| READ_REQ | 1 | 4'b0010 | - |
| READ_RD | 1 | 4'b0011 | - |
| READ_ST | 1 | 4'b0100 | - |
| INV_ALL | 1 | 4'b0101 | - |
| INS_TAG_REQ | 1 | 4'b1001 | - |
| INS_TAG_RD | 1 | 4'b1010 | - |
| INS_CMP | 1 | 4'b1011 | - |
| INS_INV | 1 | 4'b1100 | - |
| INS_INV_ALL | 1 | 4'b1101 | - |
| CNT_REG_VAL | 1 | 5'b11111 | - |
| CNT_REG_VAL | 1 | 5'b01111 | - |
| CNT_REG_VAL | 1 | 5'b00111 | - |
| CNT_REG_VAL | 1 | 5'b00011 | - |
| INV_CNT_VAL | 1 | 13'b1111111111111 | - |
| INV_CNT_VAL | 1 | 13'b0111111111111 | - |
| INV_CNT_VAL | 1 | 13'b0011111111111 | - |
| INV_CNT_VAL | 1 | 13'b0001111111111 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addr_inv_count_reg | 5 | - |
| bht_inv_dn_ff | 1 | - |
| bht_inv_ff | 1 | - |
| btb_inv_dn_ff | 1 | - |
| btb_inv_ff | 1 | - |
| icache_if_ifctrl_inst_data0_reg | 128 | - |
| icache_if_ifctrl_inst_data1_reg | 128 | - |
| icache_if_ifctrl_tag_data0_reg | 29 | - |
| icache_if_ifctrl_tag_data1_reg | 29 | - |
| icache_inv_cnt | 13 | - |
| icache_inv_cur_state | 4 | - |
| icache_inv_fifo | 1 | - |
| icache_inv_next_state | 4 | - |
| icache_inv_tag_wen | 3 | - |
| ifctrl_ipctrl_if_pcload | 1 | - |
| ifctrl_ipctrl_vld | 1 | - |
| ifctrl_pcgen_reissue_pcload | 1 | - |
| ifu_hpcp_frontend_stall | 1 | - |
| ifu_no_op_flop | 1 | - |
| ind_btb_inv_dn_ff | 1 | - |
| ind_btb_inv_ff | 1 | - |
| ins_inv_ptag_flop | 28 | - |
| tag_cmp_result | 2 | - |
| tag_data0_reg | 29 | - |
| tag_data1_reg | 29 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| all_inv_req | 1 | - |
| bht_ifctrl_inv_done | 1 | - |
| bht_ifctrl_inv_on | 1 | - |
| bht_inv_dn | 1 | - |
| bht_inv_flop_clk | 1 | - |
| bht_inv_flop_clk_en | 1 | - |
| bht_inv_on | 1 | - |
| btb_ifctrl_inv_done | 1 | - |
| btb_ifctrl_inv_on | 1 | - |
| btb_inv_dn | 1 | - |
| btb_inv_flop_clk | 1 | - |
| btb_inv_flop_clk_en | 1 | - |
| btb_inv_on | 1 | - |
| cache_data_flop_clk | 1 | - |
| cache_data_flop_clk_en | 1 | - |
| cp0_ifu_bht_inv | 1 | - |
| cp0_ifu_btb_inv | 1 | - |
| cp0_ifu_icache_inv | 1 | - |
| cp0_ifu_icache_read_index | 17 | - |
| cp0_ifu_icache_read_req | 1 | - |
| cp0_ifu_icache_read_tag | 1 | - |
| cp0_ifu_icache_read_way | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_ind_btb_inv | 1 | - |
| cp0_ifu_no_op_req | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_clk | 1 | - |
| hpcp_clk_en | 1 | - |

*注：共175个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IF阶段控制模块，负责取指阶段的控制逻辑
- 所属单元：取指单元(IFU)
- 接口数量：输入56个，输出56个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
