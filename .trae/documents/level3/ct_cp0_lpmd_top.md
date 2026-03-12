# ct_cp0_lpmd 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_cp0_lpmd |
| 文件路径 | cp0/rtl/ct_cp0_lpmd.v |
| 功能描述 | 低功耗管理 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_yy_xx_no_op | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_cp0_xx_dbg | input | 1 | |
| ifu_yy_xx_no_op | input | 1 | |
| inst_lpmd_ex1_ex2 | input | 1 | |
| lsu_yy_xx_no_op | input | 1 | |
| mmu_yy_xx_no_op | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| regs_lpmd_int_vld | input | 1 | |
| regs_xx_icg_en | input | 1 | |
| rtu_yy_xx_dbgon | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_biu_lpmd_b | output | 2 | |
| cp0_had_lpmd_b | output | 2 | |
| cp0_ifu_no_op_req | output | 1 | |
| cp0_lsu_no_op_req | output | 1 | |
| cp0_mmu_no_op_req | output | 1 | |
| cp0_yy_clk_en | output | 1 | |
| lpmd_cmplt | output | 1 | |
| lpmd_top_cur_state | output | 2 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lpmd_gated_clk |
| lpmd | instruction |
| power | mode |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
