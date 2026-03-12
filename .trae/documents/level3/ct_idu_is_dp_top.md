# ct_idu_is_dp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_is_dp |
| 文件路径 | idu/rtl/ct_idu_is_dp.v |
| 功能描述 | 发射数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| aiq0_aiq_create0_entry | input | 8 | |
| aiq0_aiq_create1_entry | input | 8 | |
| aiq1_aiq_create0_entry | input | 8 | |
| aiq1_aiq_create1_entry | input | 8 | |
| biq_aiq_create0_entry | input | 12 | |
| biq_aiq_create1_entry | input | 12 | |
| cp0_idu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| ctrl_aiq0_create0_dp_en | input | 1 | |
| ctrl_aiq0_create0_gateclk_en | input | 1 | |
| ctrl_aiq0_create1_dp_en | input | 1 | |
| ctrl_aiq0_create1_gateclk_en | input | 1 | |
| ctrl_aiq1_create0_dp_en | input | 1 | |
| ctrl_aiq1_create0_gateclk_en | input | 1 | |
| ctrl_aiq1_create1_dp_en | input | 1 | |
| ctrl_aiq1_create1_gateclk_en | input | 1 | |
| ctrl_biq_create0_dp_en | input | 1 | |
| ctrl_biq_create0_gateclk_en | input | 1 | |
| ctrl_biq_create1_dp_en | input | 1 | |
| ctrl_biq_create1_gateclk_en | input | 1 | |
| ctrl_dp_dis_inst0_ereg_vld | input | 1 | |
| ctrl_dp_dis_inst0_freg_vld | input | 1 | |
| ctrl_dp_dis_inst0_preg_vld | input | 1 | |
| ctrl_dp_dis_inst0_vreg_vld | input | 1 | |
| ctrl_dp_dis_inst1_ereg_vld | input | 1 | |
| ctrl_dp_dis_inst1_freg_vld | input | 1 | |
| ctrl_dp_dis_inst1_preg_vld | input | 1 | |
| ctrl_dp_dis_inst1_vreg_vld | input | 1 | |
| ctrl_dp_dis_inst2_ereg_vld | input | 1 | |
| ... | ... | ... | 共175个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| dp_aiq0_bypass_data | output | 227 | |
| dp_aiq0_create0_data | output | 227 | |
| dp_aiq0_create1_data | output | 227 | |
| dp_aiq0_create_div | output | 1 | |
| dp_aiq0_create_src0_rdy_for_bypass | output | 1 | |
| dp_aiq0_create_src1_rdy_for_bypass | output | 1 | |
| dp_aiq0_create_src2_rdy_for_bypass | output | 1 | |
| dp_aiq1_bypass_data | output | 214 | |
| dp_aiq1_create0_data | output | 214 | |
| dp_aiq1_create1_data | output | 214 | |
| dp_aiq1_create_alu | output | 1 | |
| dp_aiq1_create_src0_rdy_for_bypass | output | 1 | |
| dp_aiq1_create_src1_rdy_for_bypass | output | 1 | |
| dp_aiq1_create_src2_rdy_for_bypass | output | 1 | |
| dp_aiq_dis_inst0_src0_preg | output | 7 | |
| dp_aiq_dis_inst0_src1_preg | output | 7 | |
| dp_aiq_dis_inst0_src2_preg | output | 7 | |
| dp_aiq_dis_inst1_src0_preg | output | 7 | |
| dp_aiq_dis_inst1_src1_preg | output | 7 | |
| dp_aiq_dis_inst1_src2_preg | output | 7 | |
| dp_aiq_dis_inst2_src0_preg | output | 7 | |
| dp_aiq_dis_inst2_src1_preg | output | 7 | |
| dp_aiq_dis_inst2_src2_preg | output | 7 | |
| dp_aiq_dis_inst3_src0_preg | output | 7 | |
| dp_aiq_dis_inst3_src1_preg | output | 7 | |
| dp_aiq_dis_inst3_src2_preg | output | 7 | |
| dp_aiq_sdiq_create0_src_sel | output | 1 | |
| dp_aiq_sdiq_create1_src_sel | output | 1 | |
| dp_biq_bypass_data | output | 82 | |
| dp_biq_create0_data | output | 82 | |
| ... | ... | ... | 共158个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_idu_is_pipe_entry | x_ct_idu_is_dp_inst0 |
| ct_idu_is_pipe_entry | x_ct_idu_is_dp_inst1 |
| ct_idu_is_pipe_entry | x_ct_idu_is_dp_inst2 |
| ct_idu_is_pipe_entry | x_ct_idu_is_dp_inst3 |
| gated_clk_cell | x_is_inst_gated_clk |
| PCFIFO | ID |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
