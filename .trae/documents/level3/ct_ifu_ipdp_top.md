# ct_ifu_ipdp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipdp |
| 文件路径 | ifu/rtl/ct_ifu_ipdp.v |
| 功能描述 | 预取数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_ipdp_chgflw_vl | input | 8 | |
| addrgen_ipdp_chgflw_vlmul | input | 2 | |
| addrgen_ipdp_chgflw_vsew | input | 3 | |
| addrgen_xx_pcload | input | 1 | |
| bht_ipdp_pre_array_data_ntake | input | 32 | |
| bht_ipdp_pre_array_data_taken | input | 32 | |
| bht_ipdp_pre_offset_onehot | input | 16 | |
| bht_ipdp_sel_array_result | input | 2 | |
| bht_ipdp_vghr | input | 22 | |
| cp0_idu_cskyee | input | 1 | |
| cp0_idu_frm | input | 3 | |
| cp0_idu_fs | input | 2 | |
| cp0_ifu_btb_en | input | 1 | |
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_vl | input | 8 | |
| cp0_ifu_vlmul | input | 2 | |
| cp0_ifu_vsetvli_pred_disable | input | 1 | |
| cp0_ifu_vsew | input | 3 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_ifu_ir | input | 32 | |
| had_ifu_ir_vld | input | 1 | |
| ibctrl_ipdp_chgflw_vl | input | 8 | |
| ibctrl_ipdp_chgflw_vlmul | input | 2 | |
| ibctrl_ipdp_chgflw_vsew | input | 3 | |
| ibctrl_ipdp_pcload | input | 1 | |
| ifdp_ipdp_acc_err | input | 1 | |
| ifdp_ipdp_bkpta | input | 8 | |
| ifdp_ipdp_bkptb | input | 8 | |
| ... | ... | ... | 共156个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ipdp_bht_h0_con_br | output | 1 | |
| ipdp_bht_vpc | output | 39 | |
| ipdp_btb_index_pc | output | 39 | |
| ipdp_btb_target_pc | output | 20 | |
| ipdp_ibdp_bht_pre_result | output | 2 | |
| ipdp_ibdp_bht_result | output | 1 | |
| ipdp_ibdp_bht_sel_result | output | 2 | |
| ipdp_ibdp_branch_base | output | 39 | |
| ipdp_ibdp_branch_btb_miss | output | 1 | |
| ipdp_ibdp_branch_offset | output | 21 | |
| ipdp_ibdp_branch_result | output | 39 | |
| ipdp_ibdp_branch_vl | output | 8 | |
| ipdp_ibdp_branch_vlmul | output | 2 | |
| ipdp_ibdp_branch_vsew | output | 3 | |
| ipdp_ibdp_branch_way_pred | output | 2 | |
| ipdp_ibdp_btb_index_pc | output | 39 | |
| ipdp_ibdp_chgflw_mask | output | 8 | |
| ipdp_ibdp_chgflw_num | output | 4 | |
| ipdp_ibdp_chgflw_num_vld | output | 1 | |
| ipdp_ibdp_chgflw_vl | output | 8 | |
| ipdp_ibdp_chgflw_vlmul | output | 2 | |
| ipdp_ibdp_chgflw_vsew | output | 3 | |
| ipdp_ibdp_con_br_cur_pc | output | 39 | |
| ipdp_ibdp_con_br_half_num | output | 4 | |
| ipdp_ibdp_con_br_inst_32 | output | 1 | |
| ipdp_ibdp_con_br_num | output | 4 | |
| ipdp_ibdp_con_br_num_vld | output | 1 | |
| ipdp_ibdp_con_br_offset | output | 21 | |
| ipdp_ibdp_h0_bkpta | output | 1 | |
| ipdp_ibdp_h0_bkptb | output | 1 | |
| ... | ... | ... | 共187个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_ifu_ipdecode | x_ct_ifu_ipdecode0 |
| ct_ifu_ipdecode | x_ct_ifu_ipdecode1 |
| ct_ifu_decd_normal | x_had_decd_normal |
| ct_idu_id_decd_special | x_had_decd_special |
| gated_clk_cell | x_h0_updt_clk |
| gated_clk_cell | x_ip_ib_pipe_clk |
| gated_clk_cell | x_ip_ib_pipe_h0_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
