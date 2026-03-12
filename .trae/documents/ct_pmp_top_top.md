# ct_pmp_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_pmp_top |
| 文件路径 | pmp/rtl/ct_pmp_top.v |
| 功能描述 | 物理内存保护 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_pmp_icg_en | input | 1 | |
| cp0_pmp_mpp | input | 2 | |
| cp0_pmp_mprv | input | 1 | |
| cp0_pmp_reg_num | input | 5 | |
| cp0_pmp_wdata | input | 64 | |
| cp0_pmp_wreg | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| mmu_pmp_fetch3 | input | 1 | |
| mmu_pmp_pa0 | input | 28 | |
| mmu_pmp_pa1 | input | 28 | |
| mmu_pmp_pa2 | input | 28 | |
| mmu_pmp_pa3 | input | 28 | |
| mmu_pmp_pa4 | input | 28 | |
| pad_yy_icg_scan_en | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| pmp_cp0_data | output | 64 | |
| pmp_mmu_flg0 | output | 4 | |
| pmp_mmu_flg1 | output | 4 | |
| pmp_mmu_flg2 | output | 4 | |
| pmp_mmu_flg3 | output | 4 | |
| pmp_mmu_flg4 | output | 4 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_pmp_gated_clk |
| ct_pmp_regs | x_ct_pmp_regs |
| ct_pmp_acc | x_ct_pmp_acc0 |
| ct_pmp_acc | x_ct_pmp_acc1 |
| ct_pmp_acc | x_ct_pmp_acc2 |
| ct_pmp_acc | x_ct_pmp_acc3 |
| ct_pmp_acc | x_ct_pmp_acc4 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
