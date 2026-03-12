# ct_ifu_lbuf 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_lbuf |
| 文件路径 | ifu/rtl/ct_ifu_lbuf.v |
| 功能描述 | 行缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_lbuf_pre_ntaken_result | input | 32 | |
| bht_lbuf_pre_taken_result | input | 32 | |
| bht_lbuf_vghr | input | 22 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_lbuf_en | input | 1 | |
| cp0_ifu_vl | input | 8 | |
| cp0_ifu_vsetvli_pred_disable | input | 1 | |
| cp0_ifu_vsetvli_pred_mode | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibctrl_lbuf_bju_mispred | input | 1 | |
| ibctrl_lbuf_create_vld | input | 1 | |
| ibctrl_lbuf_flush | input | 1 | |
| ibctrl_lbuf_retire_vld | input | 1 | |
| ibdp_lbuf_bht_sel_array_result | input | 2 | |
| ibdp_lbuf_con_br_cur_pc | input | 39 | |
| ibdp_lbuf_con_br_half_num | input | 4 | |
| ibdp_lbuf_con_br_inst_32 | input | 1 | |
| ibdp_lbuf_con_br_offset | input | 21 | |
| ibdp_lbuf_con_br_taken | input | 1 | |
| ibdp_lbuf_con_br_vl | input | 8 | |
| ibdp_lbuf_con_br_vlmul | input | 2 | |
| ibdp_lbuf_con_br_vsew | input | 3 | |
| ibdp_lbuf_h0_32_start | input | 1 | |
| ibdp_lbuf_h0_bkpta | input | 1 | |
| ibdp_lbuf_h0_bkptb | input | 1 | |
| ibdp_lbuf_h0_con_br | input | 1 | |
| ibdp_lbuf_h0_data | input | 16 | |
| ibdp_lbuf_h0_fence | input | 1 | |
| ... | ... | ... | 共106个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lbuf_addrgen_active_state | output | 1 | |
| lbuf_addrgen_cache_state | output | 1 | |
| lbuf_addrgen_chgflw_mask | output | 1 | |
| lbuf_bht_active_state | output | 1 | |
| lbuf_bht_con_br_taken | output | 1 | |
| lbuf_bht_con_br_vld | output | 1 | |
| lbuf_debug_st | output | 6 | |
| lbuf_ibctrl_active_idle_flush | output | 1 | |
| lbuf_ibctrl_chgflw_pc | output | 39 | |
| lbuf_ibctrl_chgflw_pred | output | 2 | |
| lbuf_ibctrl_chgflw_vl | output | 8 | |
| lbuf_ibctrl_chgflw_vld | output | 1 | |
| lbuf_ibctrl_chgflw_vlmul | output | 2 | |
| lbuf_ibctrl_chgflw_vsew | output | 3 | |
| lbuf_ibctrl_lbuf_active | output | 1 | |
| lbuf_ibctrl_stall | output | 1 | |
| lbuf_ibdp_inst0 | output | 32 | |
| lbuf_ibdp_inst0_bkpta | output | 1 | |
| lbuf_ibdp_inst0_bkptb | output | 1 | |
| lbuf_ibdp_inst0_fence | output | 1 | |
| lbuf_ibdp_inst0_pc | output | 15 | |
| lbuf_ibdp_inst0_split0 | output | 1 | |
| lbuf_ibdp_inst0_split1 | output | 1 | |
| lbuf_ibdp_inst0_valid | output | 1 | |
| lbuf_ibdp_inst0_vl | output | 8 | |
| lbuf_ibdp_inst0_vlmul | output | 2 | |
| lbuf_ibdp_inst0_vsew | output | 3 | |
| lbuf_ibdp_inst1 | output | 32 | |
| lbuf_ibdp_inst1_bkpta | output | 1 | |
| lbuf_ibdp_inst1_bkptb | output | 1 | |
| ... | ... | ... | 共63个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lbuf_sm_clk |
| Over | add |
| gated_clk_cell | x_lbuf_cur_entry_num_clk |
| gated_clk_cell | x_record_fifo_entry_clk |
| gated_clk_cell | x_record_fifo_bit_clk |
| gated_clk_cell | x_front_buffer_update_clk |
| gated_clk_cell | x_front_update_pre_clk |
| gated_clk_cell | x_front_br_body_num_update_clk |
| gated_clk_cell | x_back_buffer_update_clk |
| gated_clk_cell | x_back_update_pre_clk |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_0 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_1 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_2 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_3 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_4 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_5 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_6 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_7 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_8 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_9 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_10 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_11 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_12 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_13 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_14 |
| ct_ifu_lbuf_entry | x_ct_ifu_lbuf_entry_15 |
| gated_clk_cell | x_lbuf_create_pointer_update_clk |
| gated_clk_cell | x_lbuf_retire_pointer_update_clk |
| gated_clk_cell | x_lbuf_cur_pc_update_clk |
| gated_clk_cell | x_front_br_sel_array_clk |
| ... | 共33个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
