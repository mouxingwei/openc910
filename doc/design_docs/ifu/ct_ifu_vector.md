# ct_ifu_vector 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_vector |
| 文件名称 | ct_ifu_vector.v |
| 功能描述 | 向量模块 |

### 1.2 功能描述

向量模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_rst_inv_done | input | 1 | - |
| cp0_ifu_rvbr | input | 40 | - |
| cp0_ifu_vbr | input | 40 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| rtu_ifu_xx_dbgon | input | 1 | - |
| rtu_ifu_xx_expt_vec | input | 6 | - |
| rtu_ifu_xx_expt_vld | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_cp0_rst_inv_req | output | 1 | - |
| ifu_xx_sync_reset | output | 1 | - |
| vector_debug_cur_st | output | 10 | - |
| vector_debug_reset_on | output | 1 | - |
| vector_ifctrl_reset_on | output | 1 | - |
| vector_ifctrl_sm_on | output | 1 | - |
| vector_ifctrl_sm_start | output | 1 | - |
| vector_pcgen_pc | output | 39 | - |
| vector_pcgen_pcload | output | 1 | - |
| vector_pcgen_reset_on | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| IDLE | 1 | 10'b0000000001 | - |
| PHYADD | 1 | 10'b0000000010 | - |
| WAIT1 | 1 | 10'b0000000100 | - |
| CACHE | 1 | 10'b0000001000 | - |
| CMP | 1 | 10'b0000010000 | - |
| WAIT2 | 1 | 10'b0000100000 | - |
| MISS | 1 | 10'b0001000000 | - |
| EXP | 1 | 10'b0010000000 | - |
| RESET | 1 | 10'b0100000000 | - |
| PCLOAD | 1 | 10'b1000000000 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| nonvec_pc | 39 | - |
| vec_cur_state | 10 | - |
| vec_next_state | 10 | - |
| vector_rst_inv_ff | 1 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_rst_inv_done | 1 | - |
| cp0_ifu_rvbr | 40 | - |
| cp0_ifu_vbr | 40 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| expt_mode | 2 | - |
| expt_virtual_pc | 39 | - |
| forever_cpuclk | 1 | - |
| ifu_cp0_rst_inv_req | 1 | - |
| ifu_xx_sync_reset | 1 | - |
| int_vld | 1 | - |
| pad_yy_icg_scan_en | 1 | - |
| pc_load | 1 | - |
| reset_expt | 1 | - |
| reset_virtual_pc | 39 | - |
| rtu_ifu_xx_dbgon | 1 | - |
| rtu_ifu_xx_expt_vec | 6 | - |
| rtu_ifu_xx_expt_vld | 1 | - |
| vec_sm_clk | 1 | - |
| vec_sm_clk_en | 1 | - |
| vector_debug_cur_st | 10 | - |
| vector_debug_reset_on | 1 | - |
| vector_ifctrl_reset_on | 1 | - |
| vector_ifctrl_sm_on | 1 | - |
| vector_ifctrl_sm_start | 1 | - |
| vector_pc_update_clk | 1 | - |
| vector_pc_update_clk_en | 1 | - |
| vector_pcgen_pc | 39 | - |
| vector_pcgen_pcload | 1 | - |

*注：共34个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：向量模块
- 所属单元：取指单元(IFU)
- 接口数量：输入11个，输出10个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
