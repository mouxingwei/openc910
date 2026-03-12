# ct_clk_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_clk_top |
| 文件路径 | clk/rtl/ct_clk_top.v |
| 功能描述 | 时钟控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_xx_dbg_wakeup | input | 1 | |
| biu_xx_int_wakeup | input | 1 | |
| biu_xx_normal_work | input | 1 | |
| biu_xx_pmp_sel | input | 1 | |
| biu_xx_snoop_vld | input | 1 | |
| cp0_xx_core_icg_en | input | 1 | |
| had_xx_clk_en | input | 1 | |
| pll_core_clk | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| coreclk | output | 1 | |
| forever_coreclk | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| BUFGCE | core_clk_buf |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
