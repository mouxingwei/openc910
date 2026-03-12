# ct_idu_ir_dp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_ir_dp |
| 文件路径 | idu/rtl/ct_idu_ir_dp.v |
| 功能描述 | 寄存器重命名数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_dp_ir_inst0_vld | input | 1 | |
| ctrl_id_pipedown_gateclk | input | 1 | |
| ctrl_ir_stall | input | 1 | |
| dp_id_pipedown_dep_info | input | 17 | |
| dp_id_pipedown_inst0_data | input | 178 | |
| dp_id_pipedown_inst1_data | input | 178 | |
| dp_id_pipedown_inst2_data | input | 178 | |
| dp_id_pipedown_inst3_data | input | 178 | |
| forever_cpuclk | input | 1 | |
| frt_dp_inst01_srcf2_match | input | 1 | |
| frt_dp_inst02_srcf2_match | input | 1 | |
| frt_dp_inst03_srcf2_match | input | 1 | |
| frt_dp_inst0_rel_ereg | input | 5 | |
| frt_dp_inst0_rel_freg | input | 7 | |
| frt_dp_inst0_srcf0_data | input | 9 | |
| frt_dp_inst0_srcf1_data | input | 9 | |
| frt_dp_inst0_srcf2_data | input | 10 | |
| frt_dp_inst12_srcf2_match | input | 1 | |
| frt_dp_inst13_srcf2_match | input | 1 | |
| frt_dp_inst1_rel_ereg | input | 5 | |
| frt_dp_inst1_rel_freg | input | 7 | |
| frt_dp_inst1_srcf0_data | input | 9 | |
| frt_dp_inst1_srcf1_data | input | 9 | |
| frt_dp_inst1_srcf2_data | input | 10 | |
| frt_dp_inst23_srcf2_match | input | 1 | |
| frt_dp_inst2_rel_ereg | input | 5 | |
| frt_dp_inst2_rel_freg | input | 7 | |
| ... | ... | ... | 共103个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dp_ctrl_ir_inst0_bar | output | 1 | |
| dp_ctrl_ir_inst0_ctrl_info | output | 13 | |
| dp_ctrl_ir_inst0_dst_vld | output | 1 | |
| dp_ctrl_ir_inst0_dst_x0 | output | 1 | |
| dp_ctrl_ir_inst0_dste_vld | output | 1 | |
| dp_ctrl_ir_inst0_dstf_vld | output | 1 | |
| dp_ctrl_ir_inst0_dstv_vld | output | 1 | |
| dp_ctrl_ir_inst0_hpcp_type | output | 7 | |
| dp_ctrl_ir_inst1_bar | output | 1 | |
| dp_ctrl_ir_inst1_ctrl_info | output | 13 | |
| dp_ctrl_ir_inst1_dst_vld | output | 1 | |
| dp_ctrl_ir_inst1_dst_x0 | output | 1 | |
| dp_ctrl_ir_inst1_dste_vld | output | 1 | |
| dp_ctrl_ir_inst1_dstf_vld | output | 1 | |
| dp_ctrl_ir_inst1_dstv_vld | output | 1 | |
| dp_ctrl_ir_inst1_hpcp_type | output | 7 | |
| dp_ctrl_ir_inst2_bar | output | 1 | |
| dp_ctrl_ir_inst2_ctrl_info | output | 13 | |
| dp_ctrl_ir_inst2_dst_vld | output | 1 | |
| dp_ctrl_ir_inst2_dst_x0 | output | 1 | |
| dp_ctrl_ir_inst2_dste_vld | output | 1 | |
| dp_ctrl_ir_inst2_dstf_vld | output | 1 | |
| dp_ctrl_ir_inst2_dstv_vld | output | 1 | |
| dp_ctrl_ir_inst2_hpcp_type | output | 7 | |
| dp_ctrl_ir_inst3_bar | output | 1 | |
| dp_ctrl_ir_inst3_ctrl_info | output | 13 | |
| dp_ctrl_ir_inst3_dst_vld | output | 1 | |
| dp_ctrl_ir_inst3_dst_x0 | output | 1 | |
| dp_ctrl_ir_inst3_dste_vld | output | 1 | |
| dp_ctrl_ir_inst3_dstf_vld | output | 1 | |
| ... | ... | ... | 共173个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ir_inst_gated_clk |
| ct_idu_ir_decd | x_ct_idu_ir_decd0 |
| ct_idu_ir_decd | x_ct_idu_ir_decd1 |
| ct_idu_ir_decd | x_ct_idu_ir_decd2 |
| ct_idu_ir_decd | x_ct_idu_ir_decd3 |
| split | load |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
