# ct_idu_id_ctrl 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_id_ctrl |
| 文件路径 | idu/rtl/ct_idu_id_ctrl.v |
| 功能描述 | 译码控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_ir_stage_stall | input | 1 | |
| ctrl_ir_stall | input | 1 | |
| dp_ctrl_id_inst0_fence | input | 1 | |
| dp_ctrl_id_inst0_normal | input | 1 | |
| dp_ctrl_id_inst0_split_long | input | 1 | |
| dp_ctrl_id_inst0_split_short | input | 1 | |
| dp_ctrl_id_inst1_fence | input | 1 | |
| dp_ctrl_id_inst1_normal | input | 1 | |
| dp_ctrl_id_inst1_split_long | input | 1 | |
| dp_ctrl_id_inst1_split_short | input | 1 | |
| dp_ctrl_id_inst2_fence | input | 1 | |
| dp_ctrl_id_inst2_normal | input | 1 | |
| dp_ctrl_id_inst2_split_long | input | 1 | |
| dp_ctrl_id_inst2_split_short | input | 1 | |
| fence_ctrl_id_stall | input | 1 | |
| fence_ctrl_inst0_vld | input | 1 | |
| fence_ctrl_inst1_vld | input | 1 | |
| fence_ctrl_inst2_vld | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_idu_debug_id_inst_en | input | 1 | |
| hpcp_idu_cnt_en | input | 1 | |
| ifu_idu_ib_inst0_vld | input | 1 | |
| ifu_idu_ib_inst1_vld | input | 1 | |
| ifu_idu_ib_inst2_vld | input | 1 | |
| ifu_idu_ib_pipedown_gateclk | input | 1 | |
| iu_yy_xx_cancel | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| ... | ... | ... | 共33个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ctrl_dp_id_debug_id_pipedown3 | output | 1 | |
| ctrl_dp_id_inst0_vld | output | 1 | |
| ctrl_dp_id_inst1_vld | output | 1 | |
| ctrl_dp_id_inst2_vld | output | 1 | |
| ctrl_dp_id_pipedown_1_inst | output | 1 | |
| ctrl_dp_id_pipedown_2_inst | output | 1 | |
| ctrl_dp_id_pipedown_3_inst | output | 1 | |
| ctrl_dp_id_stall | output | 1 | |
| ctrl_fence_id_inst_vld | output | 1 | |
| ctrl_fence_id_stall | output | 1 | |
| ctrl_id_pipedown_gateclk | output | 1 | |
| ctrl_id_pipedown_inst0_vld | output | 1 | |
| ctrl_id_pipedown_inst1_vld | output | 1 | |
| ctrl_id_pipedown_inst2_vld | output | 1 | |
| ctrl_id_pipedown_inst3_vld | output | 1 | |
| ctrl_split_long_id_inst_vld | output | 1 | |
| ctrl_split_long_id_stall | output | 1 | |
| ctrl_top_id_inst0_vld | output | 1 | |
| ctrl_top_id_inst1_vld | output | 1 | |
| ctrl_top_id_inst2_vld | output | 1 | |
| idu_had_id_inst0_vld | output | 1 | |
| idu_had_id_inst1_vld | output | 1 | |
| idu_had_id_inst2_vld | output | 1 | |
| idu_had_pipe_stall | output | 1 | |
| idu_hpcp_backend_stall | output | 1 | |
| idu_ifu_id_bypass_stall | output | 1 | |
| idu_ifu_id_stall | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_id_inst_gated_clk |
| gated_clk_cell | x_debug_id_inst_gated_clk |
| type | if |
| type | if |
| type | if |
| can | pipedown |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
