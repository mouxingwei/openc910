# ct_ifu_ibuf_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibuf_entry |
| 文件名称 | ct_ifu_ibuf_entry.v |
| 功能描述 | 指令缓冲表项模块 |

### 1.2 功能描述

指令缓冲表项模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| entry_create_32_start_x | input | 1 | - |
| entry_create_acc_err_x | input | 1 | - |
| entry_create_bkpta_x | input | 1 | - |
| entry_create_bkptb_x | input | 1 | - |
| entry_create_fence_x | input | 1 | - |
| entry_create_high_expt_x | input | 1 | - |
| entry_create_inst_data_v | input | 16 | - |
| entry_create_no_spec_x | input | 1 | - |
| entry_create_pc_v | input | 15 | - |
| entry_create_pgflt_x | input | 1 | - |
| entry_create_split0_x | input | 1 | - |
| entry_create_split1_x | input | 1 | - |
| entry_create_vl_pred_x | input | 1 | - |
| entry_create_vl_v | input | 8 | - |
| entry_create_vlmul_v | input | 2 | - |
| entry_create_vsew_v | input | 3 | - |
| entry_create_x | input | 1 | - |
| entry_data_create_clk_en_x | input | 1 | - |
| entry_data_create_x | input | 1 | - |
| entry_pc_create_clk_en_x | input | 1 | - |
| entry_pc_create_x | input | 1 | - |
| entry_retire_x | input | 1 | - |
| entry_spe_data_vld | input | 1 | - |
| entry_vld_create_clk_en_x | input | 1 | - |
| entry_vld_retire_clk_en_x | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibuf_flush | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| entry_32_start_x | output | 1 | - |
| entry_acc_err_x | output | 1 | - |
| entry_bkpta_x | output | 1 | - |
| entry_bkptb_x | output | 1 | - |
| entry_fence_x | output | 1 | - |
| entry_high_expt_x | output | 1 | - |
| entry_inst_data_v | output | 16 | - |
| entry_no_spec_x | output | 1 | - |
| entry_pc_v | output | 15 | - |
| entry_pgflt_x | output | 1 | - |
| entry_split0_x | output | 1 | - |
| entry_split1_x | output | 1 | - |
| entry_vl_pred_x | output | 1 | - |
| entry_vl_v | output | 8 | - |
| entry_vld_x | output | 1 | - |
| entry_vlmul_v | output | 2 | - |
| entry_vsew_v | output | 3 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_32_start_x | 1 | - |
| entry_acc_err_x | 1 | - |
| entry_bkpta_x | 1 | - |
| entry_bkptb_x | 1 | - |
| entry_fence_x | 1 | - |
| entry_high_expt_x | 1 | - |
| entry_inst_data_v | 16 | - |
| entry_no_spec_x | 1 | - |
| entry_pc_v | 15 | - |
| entry_pgflt_x | 1 | - |
| entry_split0_x | 1 | - |
| entry_split1_x | 1 | - |
| entry_vl_pred_x | 1 | - |
| entry_vl_v | 8 | - |
| entry_vld_x | 1 | - |
| entry_vlmul_v | 2 | - |
| entry_vsew_v | 3 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_create_32_start_x | 1 | - |
| entry_create_acc_err_x | 1 | - |
| entry_create_bkpta_x | 1 | - |
| entry_create_bkptb_x | 1 | - |
| entry_create_fence_x | 1 | - |
| entry_create_high_expt_x | 1 | - |
| entry_create_inst_data_v | 16 | - |
| entry_create_no_spec_x | 1 | - |
| entry_create_pc_v | 15 | - |
| entry_create_pgflt_x | 1 | - |
| entry_create_split0_x | 1 | - |
| entry_create_split1_x | 1 | - |
| entry_create_vl_pred_x | 1 | - |
| entry_create_vl_v | 8 | - |
| entry_create_vlmul_v | 2 | - |
| entry_create_vsew_v | 3 | - |
| entry_create_x | 1 | - |
| entry_data_create_clk_en_x | 1 | - |
| entry_data_create_x | 1 | - |
| entry_pc_create_clk_en_x | 1 | - |
| entry_pc_create_x | 1 | - |
| entry_retire_x | 1 | - |
| entry_spe_data_vld | 1 | - |
| entry_vld_create_clk_en_x | 1 | - |
| entry_vld_retire_clk_en_x | 1 | - |
| forever_cpuclk | 1 | - |
| ibuf_entry_pc_clk | 1 | - |

*注：共39个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：指令缓冲表项模块
- 所属单元：取指单元(IFU)
- 接口数量：输入31个，输出17个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
