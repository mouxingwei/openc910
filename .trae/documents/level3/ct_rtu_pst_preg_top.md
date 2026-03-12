# ct_rtu_pst_preg 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_pst_preg |
| 文件路径 | rtu/rtl/ct_rtu_pst_preg.v |
| 功能描述 | 物理寄存器状态表 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_rtu_ir_preg0_alloc_vld | input | 1 | |
| idu_rtu_ir_preg1_alloc_vld | input | 1 | |
| idu_rtu_ir_preg2_alloc_vld | input | 1 | |
| idu_rtu_ir_preg3_alloc_vld | input | 1 | |
| idu_rtu_ir_preg_alloc_gateclk_vld | input | 1 | |
| idu_rtu_pst_dis_inst0_dst_reg | input | 5 | |
| idu_rtu_pst_dis_inst0_preg | input | 7 | |
| idu_rtu_pst_dis_inst0_preg_iid | input | 7 | |
| idu_rtu_pst_dis_inst0_preg_vld | input | 1 | |
| idu_rtu_pst_dis_inst0_rel_preg | input | 7 | |
| idu_rtu_pst_dis_inst1_dst_reg | input | 5 | |
| idu_rtu_pst_dis_inst1_preg | input | 7 | |
| idu_rtu_pst_dis_inst1_preg_iid | input | 7 | |
| idu_rtu_pst_dis_inst1_preg_vld | input | 1 | |
| idu_rtu_pst_dis_inst1_rel_preg | input | 7 | |
| idu_rtu_pst_dis_inst2_dst_reg | input | 5 | |
| idu_rtu_pst_dis_inst2_preg | input | 7 | |
| idu_rtu_pst_dis_inst2_preg_iid | input | 7 | |
| idu_rtu_pst_dis_inst2_preg_vld | input | 1 | |
| idu_rtu_pst_dis_inst2_rel_preg | input | 7 | |
| idu_rtu_pst_dis_inst3_dst_reg | input | 5 | |
| idu_rtu_pst_dis_inst3_preg | input | 7 | |
| idu_rtu_pst_dis_inst3_preg_iid | input | 7 | |
| idu_rtu_pst_dis_inst3_preg_vld | input | 1 | |
| idu_rtu_pst_dis_inst3_rel_preg | input | 7 | |
| idu_rtu_pst_preg_dealloc_mask | input | 96 | |
| ... | ... | ... | 共52个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| pst_retire_retired_reg_wb | output | 1 | |
| pst_top_retired_reg_wb | output | 3 | |
| rtu_had_inst_not_wb | output | 1 | |
| rtu_idu_alloc_preg0 | output | 7 | |
| rtu_idu_alloc_preg0_vld | output | 1 | |
| rtu_idu_alloc_preg1 | output | 7 | |
| rtu_idu_alloc_preg1_vld | output | 1 | |
| rtu_idu_alloc_preg2 | output | 7 | |
| rtu_idu_alloc_preg2_vld | output | 1 | |
| rtu_idu_alloc_preg3 | output | 7 | |
| rtu_idu_alloc_preg3_vld | output | 1 | |
| rtu_idu_pst_empty | output | 1 | |
| rtu_idu_rt_recover_preg | output | 224 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| Physical | Regsiters |
| Physical | Regsiters |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg1 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg2 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg3 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg4 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg5 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg6 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg7 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg8 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg9 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg10 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg11 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg12 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg13 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg14 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg15 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg16 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg17 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg18 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg19 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg20 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg21 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg22 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg23 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg24 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg25 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg26 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg27 |
| ct_rtu_pst_preg_entry | x_ct_rtu_pst_entry_preg28 |
| ... | 共138个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
