# ct_ifu_lbuf 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_lbuf |
| 文件名称 | ct_ifu_lbuf.v |
| 功能描述 | 循环缓冲模块 |

### 1.2 功能描述

循环缓冲模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_lbuf_pre_ntaken_result | input | 32 | - |
| bht_lbuf_pre_taken_result | input | 32 | - |
| bht_lbuf_vghr | input | 22 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_lbuf_en | input | 1 | - |
| cp0_ifu_vl | input | 8 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| cp0_ifu_vsetvli_pred_mode | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibctrl_lbuf_bju_mispred | input | 1 | - |
| ibctrl_lbuf_create_vld | input | 1 | - |
| ibctrl_lbuf_flush | input | 1 | - |
| ibctrl_lbuf_retire_vld | input | 1 | - |
| ibdp_lbuf_bht_sel_array_result | input | 2 | - |
| ibdp_lbuf_con_br_cur_pc | input | 39 | - |
| ibdp_lbuf_con_br_half_num | input | 4 | - |
| ibdp_lbuf_con_br_inst_32 | input | 1 | - |
| ibdp_lbuf_con_br_offset | input | 21 | - |
| ibdp_lbuf_con_br_taken | input | 1 | - |
| ibdp_lbuf_con_br_vl | input | 8 | - |
| ibdp_lbuf_con_br_vlmul | input | 2 | - |
| ibdp_lbuf_con_br_vsew | input | 3 | - |
| ibdp_lbuf_h0_32_start | input | 1 | - |
| ibdp_lbuf_h0_bkpta | input | 1 | - |
| ibdp_lbuf_h0_bkptb | input | 1 | - |
| ibdp_lbuf_h0_con_br | input | 1 | - |
| ibdp_lbuf_h0_data | input | 16 | - |
| ibdp_lbuf_h0_fence | input | 1 | - |
| ibdp_lbuf_h0_split0_type | input | 3 | - |
| ibdp_lbuf_h0_split1_type | input | 3 | - |
| ibdp_lbuf_h0_vl | input | 8 | - |
| ibdp_lbuf_h0_vld | input | 1 | - |
| ibdp_lbuf_h0_vlmul | input | 2 | - |
| ibdp_lbuf_h0_vsetvli | input | 1 | - |
| ibdp_lbuf_h0_vsew | input | 3 | - |
| ibdp_lbuf_h1_data | input | 16 | - |
| ibdp_lbuf_h1_split0_type | input | 3 | - |
| ibdp_lbuf_h1_split1_type | input | 3 | - |
| ibdp_lbuf_h1_vl | input | 8 | - |
| ibdp_lbuf_h1_vlmul | input | 2 | - |
| ibdp_lbuf_h1_vsew | input | 3 | - |
| ibdp_lbuf_h2_data | input | 16 | - |
| ibdp_lbuf_h2_split0_type | input | 3 | - |
| ibdp_lbuf_h2_split1_type | input | 3 | - |
| ibdp_lbuf_h2_vl | input | 8 | - |
| ibdp_lbuf_h2_vlmul | input | 2 | - |
| ibdp_lbuf_h2_vsew | input | 3 | - |
| ibdp_lbuf_h3_data | input | 16 | - |

*注：共106个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lbuf_addrgen_active_state | output | 1 | - |
| lbuf_addrgen_cache_state | output | 1 | - |
| lbuf_addrgen_chgflw_mask | output | 1 | - |
| lbuf_bht_active_state | output | 1 | - |
| lbuf_bht_con_br_taken | output | 1 | - |
| lbuf_bht_con_br_vld | output | 1 | - |
| lbuf_debug_st | output | 6 | - |
| lbuf_ibctrl_active_idle_flush | output | 1 | - |
| lbuf_ibctrl_chgflw_pc | output | 39 | - |
| lbuf_ibctrl_chgflw_pred | output | 2 | - |
| lbuf_ibctrl_chgflw_vl | output | 8 | - |
| lbuf_ibctrl_chgflw_vld | output | 1 | - |
| lbuf_ibctrl_chgflw_vlmul | output | 2 | - |
| lbuf_ibctrl_chgflw_vsew | output | 3 | - |
| lbuf_ibctrl_lbuf_active | output | 1 | - |
| lbuf_ibctrl_stall | output | 1 | - |
| lbuf_ibdp_inst0 | output | 32 | - |
| lbuf_ibdp_inst0_bkpta | output | 1 | - |
| lbuf_ibdp_inst0_bkptb | output | 1 | - |
| lbuf_ibdp_inst0_fence | output | 1 | - |
| lbuf_ibdp_inst0_pc | output | 15 | - |
| lbuf_ibdp_inst0_split0 | output | 1 | - |
| lbuf_ibdp_inst0_split1 | output | 1 | - |
| lbuf_ibdp_inst0_valid | output | 1 | - |
| lbuf_ibdp_inst0_vl | output | 8 | - |
| lbuf_ibdp_inst0_vlmul | output | 2 | - |
| lbuf_ibdp_inst0_vsew | output | 3 | - |
| lbuf_ibdp_inst1 | output | 32 | - |
| lbuf_ibdp_inst1_bkpta | output | 1 | - |
| lbuf_ibdp_inst1_bkptb | output | 1 | - |
| lbuf_ibdp_inst1_fence | output | 1 | - |
| lbuf_ibdp_inst1_pc | output | 15 | - |
| lbuf_ibdp_inst1_split0 | output | 1 | - |
| lbuf_ibdp_inst1_split1 | output | 1 | - |
| lbuf_ibdp_inst1_valid | output | 1 | - |
| lbuf_ibdp_inst1_vl | output | 8 | - |
| lbuf_ibdp_inst1_vlmul | output | 2 | - |
| lbuf_ibdp_inst1_vsew | output | 3 | - |
| lbuf_ibdp_inst2 | output | 32 | - |
| lbuf_ibdp_inst2_bkpta | output | 1 | - |
| lbuf_ibdp_inst2_bkptb | output | 1 | - |
| lbuf_ibdp_inst2_fence | output | 1 | - |
| lbuf_ibdp_inst2_pc | output | 15 | - |
| lbuf_ibdp_inst2_split0 | output | 1 | - |
| lbuf_ibdp_inst2_split1 | output | 1 | - |
| lbuf_ibdp_inst2_valid | output | 1 | - |
| lbuf_ibdp_inst2_vl | output | 8 | - |
| lbuf_ibdp_inst2_vlmul | output | 2 | - |
| lbuf_ibdp_inst2_vsew | output | 3 | - |
| lbuf_ipdp_lbuf_active | output | 1 | - |

*注：共63个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| ENTRY_NUM | 1 | 16 | - |
| IDLE | 1 | 6'b000000 | - |
| FILL | 1 | 6'b000001 | - |
| FRONT_BRANCH | 1 | 6'b000010 | - |
| CACHE | 1 | 6'b000100 | - |
| ACTIVE | 1 | 6'b001000 | - |
| FRONT_FILL | 1 | 6'b010000 | - |
| FRONT_CACHE | 1 | 6'b100000 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| active_ctc_record | 1 | - |
| active_front_fill_chgflw_vld | 1 | - |
| active_idle_chgflw_vld | 1 | - |
| back_br_bht_pre_result | 2 | - |
| back_br_sel_array_result | 2 | - |
| back_entry_cur_pc | 39 | - |
| back_entry_inst_32 | 1 | - |
| back_entry_start_num | 4 | - |
| back_entry_target_pc | 39 | - |
| back_entry_vld | 1 | - |
| back_update_pre_cur_pc | 39 | - |
| back_update_pre_inst_32 | 1 | - |
| back_update_pre_tar_pc | 39 | - |
| back_update_pre_vld_flop | 1 | - |
| create_pointer_pre | 16 | - |
| front_br_bht_pre_result | 2 | - |
| front_br_body_num | 4 | - |
| front_br_body_num_pre | 4 | - |
| front_br_body_num_record | 4 | - |
| front_br_sel_array_result | 2 | - |
| front_entry_body_filled | 1 | - |
| front_entry_cur_pc | 39 | - |
| front_entry_inst_32 | 1 | - |
| front_entry_next_pointer | 16 | - |
| front_entry_target_pc | 39 | - |
| front_entry_update_pointer | 16 | - |
| front_entry_vld | 1 | - |
| front_update_pointer | 16 | - |
| front_update_pre_br_taken | 1 | - |
| front_update_pre_cur_pc | 39 | - |

*注：共129个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| active_front_fill_chgflw_gateclk_en | 1 | - |
| active_front_fill_chgflw_pc_pre | 39 | - |
| active_front_fill_chgflw_vld_pre | 1 | - |
| active_front_fill_vl_pre | 8 | - |
| active_front_fill_vlmul_pre | 2 | - |
| active_front_fill_vsew_pre | 3 | - |
| active_idle_chgflw_gateclk_en | 1 | - |
| active_idle_chgflw_pc_pre | 39 | - |
| active_idle_chgflw_vld_pre | 1 | - |
| active_idle_vl_pre | 8 | - |
| active_idle_vlmul_pre | 2 | - |
| active_idle_vsew_pre | 3 | - |
| active_state_enter | 1 | - |
| back_br_bht_result | 1 | - |
| back_br_check | 1 | - |
| back_br_hit_filled_new_entry | 1 | - |
| back_br_hit_filled_old_entry | 1 | - |
| back_br_hit_lbuf_end | 1 | - |
| back_br_hit_not_jump_lbuf_end | 1 | - |
| back_br_hit_record_fifo_fill | 1 | - |
| back_br_hit_record_fifo_unfill | 1 | - |
| back_br_hit_unfill_new_entry | 1 | - |
| back_br_hit_unfill_old_entry | 1 | - |
| back_br_inst_32 | 1 | - |
| back_br_not_loop_end | 1 | - |
| back_br_offset | 4 | - |
| back_br_offset_less_15 | 1 | - |
| back_br_offset_less_16 | 1 | - |
| back_br_pc | 39 | - |
| back_br_sel_array_clk | 1 | - |

*注：共722个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：循环缓冲模块
- 所属单元：取指单元(IFU)
- 接口数量：输入106个，输出63个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
