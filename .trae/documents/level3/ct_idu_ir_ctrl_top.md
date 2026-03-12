# ct_idu_ir_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_ir_ctrl |
| 文件路径 | idu/rtl/ct_idu_ir_ctrl.v |
| 功能描述 | 寄存器重命名控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_ctrl_entry_cnt_updt_val | input | 4 | |
| aiq0_ctrl_entry_cnt_updt_vld | input | 1 | |
| aiq1_ctrl_entry_cnt_updt_val | input | 4 | |
| aiq1_ctrl_entry_cnt_updt_vld | input | 1 | |
| cp0_idu_dlb_disable | input | 1 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_idu_rob_fold_disable | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_id_pipedown_gateclk | input | 1 | |
| ctrl_id_pipedown_inst0_vld | input | 1 | |
| ctrl_id_pipedown_inst1_vld | input | 1 | |
| ctrl_id_pipedown_inst2_vld | input | 1 | |
| ctrl_id_pipedown_inst3_vld | input | 1 | |
| ctrl_is_dis_type_stall | input | 1 | |
| ctrl_is_inst2_vld | input | 1 | |
| ctrl_is_inst3_vld | input | 1 | |
| ctrl_is_stall | input | 1 | |
| ctrl_xx_is_inst0_sel | input | 2 | |
| ctrl_xx_is_inst_sel | input | 3 | |
| dp_ctrl_ir_inst0_bar | input | 1 | |
| dp_ctrl_ir_inst0_ctrl_info | input | 13 | |
| dp_ctrl_ir_inst0_dst_vld | input | 1 | |
| dp_ctrl_ir_inst0_dst_x0 | input | 1 | |
| dp_ctrl_ir_inst0_dste_vld | input | 1 | |
| dp_ctrl_ir_inst0_dstf_vld | input | 1 | |
| dp_ctrl_ir_inst0_dstv_vld | input | 1 | |
| dp_ctrl_ir_inst0_hpcp_type | input | 7 | |
| dp_ctrl_ir_inst1_bar | input | 1 | |
| dp_ctrl_ir_inst1_ctrl_info | input | 13 | |
| ... | ... | ... | 共84个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_dp_ir_inst0_vld | output | 1 | |
| ctrl_fence_ir_pipe_empty | output | 1 | |
| ctrl_ir_pipedown | output | 1 | |
| ctrl_ir_pipedown_gateclk | output | 1 | |
| ctrl_ir_pipedown_inst0_vld | output | 1 | |
| ctrl_ir_pipedown_inst1_vld | output | 1 | |
| ctrl_ir_pipedown_inst2_vld | output | 1 | |
| ctrl_ir_pipedown_inst3_vld | output | 1 | |
| ctrl_ir_pre_dis_aiq0_create0_en | output | 1 | |
| ctrl_ir_pre_dis_aiq0_create0_sel | output | 2 | |
| ctrl_ir_pre_dis_aiq0_create1_en | output | 1 | |
| ctrl_ir_pre_dis_aiq0_create1_sel | output | 2 | |
| ctrl_ir_pre_dis_aiq1_create0_en | output | 1 | |
| ctrl_ir_pre_dis_aiq1_create0_sel | output | 2 | |
| ctrl_ir_pre_dis_aiq1_create1_en | output | 1 | |
| ctrl_ir_pre_dis_aiq1_create1_sel | output | 2 | |
| ctrl_ir_pre_dis_biq_create0_en | output | 1 | |
| ctrl_ir_pre_dis_biq_create0_sel | output | 2 | |
| ctrl_ir_pre_dis_biq_create1_en | output | 1 | |
| ctrl_ir_pre_dis_biq_create1_sel | output | 2 | |
| ctrl_ir_pre_dis_inst0_vld | output | 1 | |
| ctrl_ir_pre_dis_inst1_vld | output | 1 | |
| ctrl_ir_pre_dis_inst2_vld | output | 1 | |
| ctrl_ir_pre_dis_inst3_vld | output | 1 | |
| ctrl_ir_pre_dis_lsiq_create0_en | output | 1 | |
| ctrl_ir_pre_dis_lsiq_create0_sel | output | 2 | |
| ctrl_ir_pre_dis_lsiq_create1_en | output | 1 | |
| ctrl_ir_pre_dis_lsiq_create1_sel | output | 2 | |
| ctrl_ir_pre_dis_pipedown2 | output | 1 | |
| ctrl_ir_pre_dis_pst_create1_iid_sel | output | 1 | |
| ... | ... | ... | 共100个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ir_inst_gated_clk |
| stall | signal |
| Load | Balance |
| gated_clk_cell | x_dlb_gated_clk |
| Load | Balance |
| gated_clk_cell | x_hpcp_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
