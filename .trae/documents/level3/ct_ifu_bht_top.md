# ct_ifu_bht 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_bht |
| 文件路径 | ifu/rtl/ct_ifu_bht.v |
| 功能描述 | 分支历史表 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_bht_en | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ifctrl_bht_inv | input | 1 | |
| ifctrl_bht_pipedown | input | 1 | |
| ifctrl_bht_stall | input | 1 | |
| ipctrl_bht_con_br_gateclk_en | input | 1 | |
| ipctrl_bht_con_br_taken | input | 1 | |
| ipctrl_bht_con_br_vld | input | 1 | |
| ipctrl_bht_more_br | input | 1 | |
| ipctrl_bht_vld | input | 1 | |
| ipdp_bht_h0_con_br | input | 1 | |
| ipdp_bht_vpc | input | 39 | |
| iu_ifu_bht_check_vld | input | 1 | |
| iu_ifu_bht_condbr_taken | input | 1 | |
| iu_ifu_bht_pred | input | 1 | |
| iu_ifu_chgflw_vld | input | 1 | |
| iu_ifu_chk_idx | input | 25 | |
| iu_ifu_cur_pc | input | 39 | |
| lbuf_bht_active_state | input | 1 | |
| lbuf_bht_con_br_taken | input | 1 | |
| lbuf_bht_con_br_vld | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pcgen_bht_chgflw | input | 1 | |
| pcgen_bht_chgflw_short | input | 1 | |
| pcgen_bht_ifpc | input | 7 | |
| pcgen_bht_pcindex | input | 10 | |
| pcgen_bht_seq_read | input | 1 | |
| ... | ... | ... | 共37个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_ifctrl_inv_done | output | 1 | |
| bht_ifctrl_inv_on | output | 1 | |
| bht_ind_btb_rtu_ghr | output | 8 | |
| bht_ind_btb_vghr | output | 8 | |
| bht_ipdp_pre_array_data_ntake | output | 32 | |
| bht_ipdp_pre_array_data_taken | output | 32 | |
| bht_ipdp_pre_offset_onehot | output | 16 | |
| bht_ipdp_sel_array_result | output | 2 | |
| bht_ipdp_vghr | output | 22 | |
| bht_lbuf_pre_ntaken_result | output | 32 | |
| bht_lbuf_pre_taken_result | output | 32 | |
| bht_lbuf_vghr | output | 22 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_bht_ghr_updt_clk |
| gated_clk_cell | x_sel_reg_clk |
| gated_clk_cell | x_pre_reg_clk |
| read | request |
| gated_clk_cell | x_wr_buf_clk |
| gated_clk_cell | x_bht_pipe_clk |
| gated_clk_cell | x_bht_flop_clk |
| gated_clk_cell | x_bht_inv_cnt_clk |
| ct_ifu_bht_pre_array | x_ct_ifu_bht_pre_array |
| ct_ifu_bht_sel_array | x_ct_ifu_bht_sel_array |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
