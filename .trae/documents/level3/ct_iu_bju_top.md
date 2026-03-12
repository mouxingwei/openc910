# ct_iu_bju 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_bju |
| 文件路径 | iu/rtl/ct_iu_bju.v |
| 功能描述 | 跳转单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_iu_is_pcfifo_inst_num | input | 3 | |
| idu_iu_is_pcfifo_inst_vld | input | 1 | |
| idu_iu_rf_bju_gateclk_sel | input | 1 | |
| idu_iu_rf_bju_sel | input | 1 | |
| idu_iu_rf_pipe0_pid | input | 5 | |
| idu_iu_rf_pipe2_func | input | 8 | |
| idu_iu_rf_pipe2_iid | input | 7 | |
| idu_iu_rf_pipe2_length | input | 1 | |
| idu_iu_rf_pipe2_offset | input | 21 | |
| idu_iu_rf_pipe2_pcall | input | 1 | |
| idu_iu_rf_pipe2_pid | input | 5 | |
| idu_iu_rf_pipe2_rts | input | 1 | |
| idu_iu_rf_pipe2_src0 | input | 64 | |
| idu_iu_rf_pipe2_src1 | input | 64 | |
| idu_iu_rf_pipe2_vl | input | 8 | |
| idu_iu_rf_pipe2_vlmul | input | 2 | |
| idu_iu_rf_pipe2_vsew | input | 3 | |
| ifu_iu_pcfifo_create0_bht_pred | input | 1 | |
| ifu_iu_pcfifo_create0_chk_idx | input | 25 | |
| ifu_iu_pcfifo_create0_cur_pc | input | 40 | |
| ifu_iu_pcfifo_create0_dst_vld | input | 1 | |
| ifu_iu_pcfifo_create0_en | input | 1 | |
| ifu_iu_pcfifo_create0_gateclk_en | input | 1 | |
| ifu_iu_pcfifo_create0_jal | input | 1 | |
| ifu_iu_pcfifo_create0_jalr | input | 1 | |
| ifu_iu_pcfifo_create0_jmp_mispred | input | 1 | |
| ... | ... | ... | 共50个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bju_cbus_ex2_pipe2_abnormal | output | 1 | |
| bju_cbus_ex2_pipe2_bht_mispred | output | 1 | |
| bju_cbus_ex2_pipe2_iid | output | 7 | |
| bju_cbus_ex2_pipe2_jmp_mispred | output | 1 | |
| bju_cbus_ex2_pipe2_sel | output | 1 | |
| bju_special_pc | output | 40 | |
| bju_top_mispred_iid | output | 7 | |
| bju_top_pcfifo_full | output | 1 | |
| iu_idu_mispred_stall | output | 1 | |
| iu_idu_pcfifo_dis_inst0_pid | output | 5 | |
| iu_idu_pcfifo_dis_inst1_pid | output | 5 | |
| iu_idu_pcfifo_dis_inst2_pid | output | 5 | |
| iu_idu_pcfifo_dis_inst3_pid | output | 5 | |
| iu_ifu_bht_check_vld | output | 1 | |
| iu_ifu_bht_condbr_taken | output | 1 | |
| iu_ifu_bht_pred | output | 1 | |
| iu_ifu_chgflw_pc | output | 63 | |
| iu_ifu_chgflw_vl | output | 8 | |
| iu_ifu_chgflw_vld | output | 1 | |
| iu_ifu_chgflw_vlmul | output | 2 | |
| iu_ifu_chgflw_vsew | output | 3 | |
| iu_ifu_chk_idx | output | 25 | |
| iu_ifu_cur_pc | output | 39 | |
| iu_ifu_mispred_stall | output | 1 | |
| iu_ifu_pcfifo_full | output | 1 | |
| iu_rtu_pcfifo_pop0_data | output | 48 | |
| iu_rtu_pcfifo_pop1_data | output | 48 | |
| iu_rtu_pcfifo_pop2_data | output | 48 | |
| iu_yy_xx_cancel | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_iu_bju_pcfifo | x_ct_iu_bju_pcfifo |
| ct_rtu_compare_iid | x_ct_iu_bju_compare_iid_rf_older_ex1 |
| ct_rtu_compare_iid | x_ct_iu_bju_compare_iid_rf_older_mispred |
| gated_clk_cell | x_ex1_inst_gated_clk |
| Change | Flow |
| gated_clk_cell | x_mispred_gated_clk |
| ct_rtu_expand_32 | x_ct_rtu_expand_32_ex1_pipe2_pid |
| gated_clk_cell | x_ex2_inst_gated_clk |
| gated_clk_cell | x_ex3_inst_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
