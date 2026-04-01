# ct_ifu_bht 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_bht |
| 文件名称 | ct_ifu_bht.v |
| 功能描述 | 分支历史表模块 |

### 1.2 功能描述

分支历史表模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_bht_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ifctrl_bht_inv | input | 1 | - |
| ifctrl_bht_pipedown | input | 1 | - |
| ifctrl_bht_stall | input | 1 | - |
| ipctrl_bht_con_br_gateclk_en | input | 1 | - |
| ipctrl_bht_con_br_taken | input | 1 | - |
| ipctrl_bht_con_br_vld | input | 1 | - |
| ipctrl_bht_more_br | input | 1 | - |
| ipctrl_bht_vld | input | 1 | - |
| ipdp_bht_h0_con_br | input | 1 | - |
| ipdp_bht_vpc | input | 39 | - |
| iu_ifu_bht_check_vld | input | 1 | - |
| iu_ifu_bht_condbr_taken | input | 1 | - |
| iu_ifu_bht_pred | input | 1 | - |
| iu_ifu_chgflw_vld | input | 1 | - |
| iu_ifu_chk_idx | input | 25 | - |
| iu_ifu_cur_pc | input | 39 | - |
| lbuf_bht_active_state | input | 1 | - |
| lbuf_bht_con_br_taken | input | 1 | - |
| lbuf_bht_con_br_vld | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_bht_chgflw | input | 1 | - |
| pcgen_bht_chgflw_short | input | 1 | - |
| pcgen_bht_ifpc | input | 7 | - |
| pcgen_bht_pcindex | input | 10 | - |
| pcgen_bht_seq_read | input | 1 | - |
| rtu_ifu_flush | input | 1 | - |
| rtu_ifu_retire0_condbr | input | 1 | - |
| rtu_ifu_retire0_condbr_taken | input | 1 | - |
| rtu_ifu_retire1_condbr | input | 1 | - |
| rtu_ifu_retire1_condbr_taken | input | 1 | - |
| rtu_ifu_retire2_condbr | input | 1 | - |
| rtu_ifu_retire2_condbr_taken | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_ifctrl_inv_done | output | 1 | - |
| bht_ifctrl_inv_on | output | 1 | - |
| bht_ind_btb_rtu_ghr | output | 8 | - |
| bht_ind_btb_vghr | output | 8 | - |
| bht_ipdp_pre_array_data_ntake | output | 32 | - |
| bht_ipdp_pre_array_data_taken | output | 32 | - |
| bht_ipdp_pre_offset_onehot | output | 16 | - |
| bht_ipdp_sel_array_result | output | 2 | - |
| bht_ipdp_vghr | output | 22 | - |
| bht_lbuf_pre_ntaken_result | output | 32 | - |
| bht_lbuf_pre_taken_result | output | 32 | - |
| bht_lbuf_vghr | output | 22 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| after_bju_mispred | 1 | - |
| after_rtu_ifu_flush | 1 | - |
| bht_inv_on_reg | 1 | - |
| bht_inv_on_reg_ff | 1 | - |
| bht_inval_cnt_pre | 10 | - |
| bht_ipdp_pre_array_data_ntake | 32 | - |
| bht_ipdp_pre_array_data_taken | 32 | - |
| bht_ipdp_pre_offset_onehot | 16 | - |
| bht_ipdp_sel_array_result | 2 | - |
| bht_ipdp_vghr | 22 | - |
| bht_pred_array_index | 10 | - |
| bht_pred_array_index_flop | 10 | - |
| bht_pred_array_rd_index | 10 | - |
| bht_sel_array_index | 7 | - |
| bht_sel_array_index_flop | 10 | - |
| bht_sel_data_reg | 16 | - |
| bht_wr_buf_pred_updt_sel_b | 32 | - |
| bht_wr_buf_sel_updt_sel_b | 8 | - |
| buf_full | 1 | - |
| create_ptr | 4 | - |
| cur_condbr_taken | 1 | - |
| cur_cur_pc | 10 | - |
| cur_ghr | 22 | - |
| cur_pred_rst | 2 | - |
| cur_sel_rst | 2 | - |
| entry0_data | 37 | - |
| entry0_sel_updt_data | 2 | - |
| entry0_vld | 1 | - |
| entry1_data | 37 | - |
| entry1_sel_updt_data | 2 | - |

*注：共63个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| after_inv_reg | 1 | - |
| bht_flop_clk | 1 | - |
| bht_flop_clk_en | 1 | - |
| bht_ghr_updt_clk | 1 | - |
| bht_ghr_updt_clk_en | 1 | - |
| bht_ifctrl_inv_done | 1 | - |
| bht_ifctrl_inv_on | 1 | - |
| bht_ind_btb_rtu_ghr | 8 | - |
| bht_ind_btb_vghr | 8 | - |
| bht_inv_cnt_clk | 1 | - |
| bht_inv_cnt_clk_en | 1 | - |
| bht_inval_cnt | 10 | - |
| bht_lbuf_pre_ntaken_result | 32 | - |
| bht_lbuf_pre_taken_result | 32 | - |
| bht_lbuf_vghr | 22 | - |
| bht_pipe_clk | 1 | - |
| bht_pipe_clk_en | 1 | - |
| bht_pre_array_clk_en | 1 | - |
| bht_pre_data_out | 64 | - |
| bht_pre_ntaken_data | 32 | - |
| bht_pre_taken_data | 32 | - |
| bht_pred_array_cen_b | 1 | - |
| bht_pred_array_din | 64 | - |
| bht_pred_array_gwen | 1 | - |
| bht_pred_array_rd | 1 | - |
| bht_pred_array_wen_b | 32 | - |
| bht_pred_array_wr | 1 | - |
| bht_pred_bwen | 64 | - |
| bht_sel_array_cen_b | 1 | - |
| bht_sel_array_clk_en | 1 | - |

*注：共135个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：分支历史表模块
- 所属单元：取指单元(IFU)
- 接口数量：输入37个，输出12个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
