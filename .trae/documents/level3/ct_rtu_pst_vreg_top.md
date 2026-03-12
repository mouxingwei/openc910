# ct_rtu_pst_vreg 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_pst_vreg |
| 文件路径 | rtu/rtl/ct_rtu_pst_vreg.v |
| 功能描述 | 向量寄存器状态表 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_rtu_ir_xreg0_alloc_vld | input | 1 | |
| idu_rtu_ir_xreg1_alloc_vld | input | 1 | |
| idu_rtu_ir_xreg2_alloc_vld | input | 1 | |
| idu_rtu_ir_xreg3_alloc_vld | input | 1 | |
| idu_rtu_ir_xreg_alloc_gateclk_vld | input | 1 | |
| idu_rtu_pst_dis_inst0_dstv_reg | input | 5 | |
| idu_rtu_pst_dis_inst0_rel_vreg | input | 6 | |
| idu_rtu_pst_dis_inst0_vreg | input | 6 | |
| idu_rtu_pst_dis_inst0_vreg_iid | input | 7 | |
| idu_rtu_pst_dis_inst0_xreg_vld | input | 1 | |
| idu_rtu_pst_dis_inst1_dstv_reg | input | 5 | |
| idu_rtu_pst_dis_inst1_rel_vreg | input | 6 | |
| idu_rtu_pst_dis_inst1_vreg | input | 6 | |
| idu_rtu_pst_dis_inst1_vreg_iid | input | 7 | |
| idu_rtu_pst_dis_inst1_xreg_vld | input | 1 | |
| idu_rtu_pst_dis_inst2_dstv_reg | input | 5 | |
| idu_rtu_pst_dis_inst2_rel_vreg | input | 6 | |
| idu_rtu_pst_dis_inst2_vreg | input | 6 | |
| idu_rtu_pst_dis_inst2_vreg_iid | input | 7 | |
| idu_rtu_pst_dis_inst2_xreg_vld | input | 1 | |
| idu_rtu_pst_dis_inst3_dstv_reg | input | 5 | |
| idu_rtu_pst_dis_inst3_rel_vreg | input | 6 | |
| idu_rtu_pst_dis_inst3_vreg | input | 6 | |
| idu_rtu_pst_dis_inst3_vreg_iid | input | 7 | |
| idu_rtu_pst_dis_inst3_xreg_vld | input | 1 | |
| idu_rtu_pst_xreg_dealloc_mask | input | 64 | |
| ... | ... | ... | 共49个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| pst_retired_xreg_wb | output | 1 | |
| rtu_idu_alloc_xreg0 | output | 6 | |
| rtu_idu_alloc_xreg0_vld | output | 1 | |
| rtu_idu_alloc_xreg1 | output | 6 | |
| rtu_idu_alloc_xreg1_vld | output | 1 | |
| rtu_idu_alloc_xreg2 | output | 6 | |
| rtu_idu_alloc_xreg2_vld | output | 1 | |
| rtu_idu_alloc_xreg3 | output | 6 | |
| rtu_idu_alloc_xreg3_vld | output | 1 | |
| rtu_idu_rt_recover_xreg | output | 192 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_vreg_gated_clk |
| Physical | Regsiters |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg0 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg1 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg2 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg3 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg4 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg5 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg6 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg7 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg8 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg9 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg10 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg11 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg12 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg13 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg14 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg15 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg16 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg17 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg18 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg19 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg20 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg21 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg22 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg23 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg24 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg25 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg26 |
| ct_rtu_pst_vreg_entry | x_ct_rtu_pst_entry_vreg27 |
| ... | 共108个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
