# ct_mmu_iplru 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_mmu_iplru |
| 文件路径 | gen_rtl\mmu\rtl\ct_mmu_iplru.v |
| 功能描述 | Instruction PLRU - 指令伪LRU替换算法 |

### 1.2 功能描述

you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

### 1.3 设计特点

- 输入端口数量: 40
- 输出端口数量: 1
- 子模块实例数量: 1

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_mmu_icg_en | 1 | - |
| cpurst_b | 1 | - |
| entry0_vld | 1 | - |
| entry10_vld | 1 | - |
| entry11_vld | 1 | - |
| entry12_vld | 1 | - |
| entry13_vld | 1 | - |
| entry14_vld | 1 | - |
| entry15_vld | 1 | - |
| entry16_vld | 1 | - |
| entry17_vld | 1 | - |
| entry18_vld | 1 | - |
| entry19_vld | 1 | - |
| entry1_vld | 1 | - |
| entry20_vld | 1 | - |
| entry21_vld | 1 | - |
| entry22_vld | 1 | - |
| entry23_vld | 1 | - |
| entry24_vld | 1 | - |
| entry25_vld | 1 | - |
| entry26_vld | 1 | - |
| entry27_vld | 1 | - |
| entry28_vld | 1 | - |
| entry29_vld | 1 | - |
| entry2_vld | 1 | - |
| entry30_vld | 1 | - |
| entry31_vld | 1 | - |
| entry3_vld | 1 | - |
| entry4_vld | 1 | - |
| entry5_vld | 1 | - |
| ... | ... | 还有 10 个端口 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| plru_iutlb_ref_num | 32 | - |

## 3. 子模块实例

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| gated_clk_cell | x_iplru_gateclk | - |

## 4. 模块实现方案

### 4.1 实现概述

ct_mmu_iplru 模块实现了Instruction PLRU - 指令伪LRU替换算法的功能，是 MMU 内存管理单元的重要组成部分。

### 4.2 关键逻辑

（详细逻辑需要进一步分析源代码）

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本，基于 RTL 自动生成 |
