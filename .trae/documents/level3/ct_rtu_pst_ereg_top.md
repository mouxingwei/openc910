# ct_rtu_pst_ereg 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_pst_ereg |
| 文件路径 | rtu/rtl/ct_rtu_pst_ereg.v |
| 功能描述 | 异常寄存器状态表 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_rtu_ir_ereg0_alloc_vld | input | 1 | |
| idu_rtu_ir_ereg1_alloc_vld | input | 1 | |
| idu_rtu_ir_ereg2_alloc_vld | input | 1 | |
| idu_rtu_ir_ereg3_alloc_vld | input | 1 | |
| idu_rtu_ir_ereg_alloc_gateclk_vld | input | 1 | |
| idu_rtu_pst_dis_inst0_ereg | input | 5 | |
| idu_rtu_pst_dis_inst0_ereg_iid | input | 7 | |
| idu_rtu_pst_dis_inst0_ereg_vld | input | 1 | |
| idu_rtu_pst_dis_inst0_rel_ereg | input | 5 | |
| idu_rtu_pst_dis_inst1_ereg | input | 5 | |
| idu_rtu_pst_dis_inst1_ereg_iid | input | 7 | |
| idu_rtu_pst_dis_inst1_ereg_vld | input | 1 | |
| idu_rtu_pst_dis_inst1_rel_ereg | input | 5 | |
| idu_rtu_pst_dis_inst2_ereg | input | 5 | |
| idu_rtu_pst_dis_inst2_ereg_iid | input | 7 | |
| idu_rtu_pst_dis_inst2_ereg_vld | input | 1 | |
| idu_rtu_pst_dis_inst2_rel_ereg | input | 5 | |
| idu_rtu_pst_dis_inst3_ereg | input | 5 | |
| idu_rtu_pst_dis_inst3_ereg_iid | input | 7 | |
| idu_rtu_pst_dis_inst3_ereg_vld | input | 1 | |
| idu_rtu_pst_dis_inst3_rel_ereg | input | 5 | |
| ifu_xx_sync_reset | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| retire_pst_async_flush | input | 1 | |
| retire_pst_wb_retire_inst0_ereg_vld | input | 1 | |
| retire_pst_wb_retire_inst1_ereg_vld | input | 1 | |
| ... | ... | ... | 共39个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| pst_retired_ereg_wb | output | 1 | |
| rtu_idu_alloc_ereg0 | output | 5 | |
| rtu_idu_alloc_ereg0_vld | output | 1 | |
| rtu_idu_alloc_ereg1 | output | 5 | |
| rtu_idu_alloc_ereg1_vld | output | 1 | |
| rtu_idu_alloc_ereg2 | output | 5 | |
| rtu_idu_alloc_ereg2_vld | output | 1 | |
| rtu_idu_alloc_ereg3 | output | 5 | |
| rtu_idu_alloc_ereg3_vld | output | 1 | |
| rtu_idu_pst_ereg_retired_released_wb | output | 32 | |
| rtu_idu_rt_recover_ereg | output | 5 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ereg_gated_clk |
| Physical | Regsiters |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg0 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg1 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg2 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg3 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg4 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg5 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg6 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg7 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg8 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg9 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg10 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg11 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg12 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg13 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg14 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg15 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg16 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg17 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg18 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg19 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg20 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg21 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg22 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg23 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg24 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg25 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg26 |
| ct_rtu_pst_ereg_entry | x_ct_rtu_pst_entry_ereg27 |
| ... | 共47个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
