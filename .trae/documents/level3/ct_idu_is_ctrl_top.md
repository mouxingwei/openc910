# ct_idu_is_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_ctrl |
| 文件路径 | idu/rtl/ct_idu_is_ctrl.v |
| 功能描述 | 发射控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_ctrl_1_left_updt | input | 1 | |
| aiq0_ctrl_empty | input | 1 | |
| aiq0_ctrl_full | input | 1 | |
| aiq0_ctrl_full_updt | input | 1 | |
| aiq0_ctrl_full_updt_clk_en | input | 1 | |
| aiq1_ctrl_1_left_updt | input | 1 | |
| aiq1_ctrl_empty | input | 1 | |
| aiq1_ctrl_full | input | 1 | |
| aiq1_ctrl_full_updt | input | 1 | |
| aiq1_ctrl_full_updt_clk_en | input | 1 | |
| biq_ctrl_1_left_updt | input | 1 | |
| biq_ctrl_empty | input | 1 | |
| biq_ctrl_full | input | 1 | |
| biq_ctrl_full_updt | input | 1 | |
| biq_ctrl_full_updt_clk_en | input | 1 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ir_pipedown_gateclk | input | 1 | |
| ctrl_ir_pipedown_inst0_vld | input | 1 | |
| ctrl_ir_pipedown_inst1_vld | input | 1 | |
| ctrl_ir_pipedown_inst2_vld | input | 1 | |
| ctrl_ir_pipedown_inst3_vld | input | 1 | |
| ctrl_ir_pre_dis_aiq0_create0_en | input | 1 | |
| ctrl_ir_pre_dis_aiq0_create0_sel | input | 2 | |
| ctrl_ir_pre_dis_aiq0_create1_en | input | 1 | |
| ctrl_ir_pre_dis_aiq0_create1_sel | input | 2 | |
| ctrl_ir_pre_dis_aiq1_create0_en | input | 1 | |
| ctrl_ir_pre_dis_aiq1_create0_sel | input | 2 | |
| ctrl_ir_pre_dis_aiq1_create1_en | input | 1 | |
| ... | ... | ... | 共127个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_aiq0_create0_dp_en | output | 1 | |
| ctrl_aiq0_create0_en | output | 1 | |
| ctrl_aiq0_create0_gateclk_en | output | 1 | |
| ctrl_aiq0_create1_dp_en | output | 1 | |
| ctrl_aiq0_create1_en | output | 1 | |
| ctrl_aiq0_create1_gateclk_en | output | 1 | |
| ctrl_aiq1_create0_dp_en | output | 1 | |
| ctrl_aiq1_create0_en | output | 1 | |
| ctrl_aiq1_create0_gateclk_en | output | 1 | |
| ctrl_aiq1_create1_dp_en | output | 1 | |
| ctrl_aiq1_create1_en | output | 1 | |
| ctrl_aiq1_create1_gateclk_en | output | 1 | |
| ctrl_biq_create0_dp_en | output | 1 | |
| ctrl_biq_create0_en | output | 1 | |
| ctrl_biq_create0_gateclk_en | output | 1 | |
| ctrl_biq_create1_dp_en | output | 1 | |
| ctrl_biq_create1_en | output | 1 | |
| ctrl_biq_create1_gateclk_en | output | 1 | |
| ctrl_dp_dis_inst0_ereg_vld | output | 1 | |
| ctrl_dp_dis_inst0_freg_vld | output | 1 | |
| ctrl_dp_dis_inst0_preg_vld | output | 1 | |
| ctrl_dp_dis_inst0_vreg_vld | output | 1 | |
| ctrl_dp_dis_inst1_ereg_vld | output | 1 | |
| ctrl_dp_dis_inst1_freg_vld | output | 1 | |
| ctrl_dp_dis_inst1_preg_vld | output | 1 | |
| ctrl_dp_dis_inst1_vreg_vld | output | 1 | |
| ctrl_dp_dis_inst2_ereg_vld | output | 1 | |
| ctrl_dp_dis_inst2_freg_vld | output | 1 | |
| ctrl_dp_dis_inst2_preg_vld | output | 1 | |
| ctrl_dp_dis_inst2_vreg_vld | output | 1 | |
| ... | ... | ... | 共137个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_is_inst_gated_clk |
| Queue | 0 |
| Queue | 0 |
| Queue | 1 |
| Queue | 1 |
| Issue | Queue |
| Issue | Queue |
| Issue | Queue |
| Issue | Queue |
| Issue | Queue |
| Issue | Queue |
| Queue | 0 |
| Queue | 0 |
| Queue | 1 |
| Queue | 1 |
| gated_clk_cell | x_queue_full_gated_clk |
| rob | full |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
