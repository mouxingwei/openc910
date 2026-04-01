# ct_ifu_lbuf_entry 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_lbuf_entry |
| 文件名称 | ct_ifu_lbuf_entry.v |
| 功能描述 | 循环缓冲表项模块 |

### 1.2 功能描述

循环缓冲表项模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| entry_create_32_start_x | input | 1 | - |
| entry_create_back_br_x | input | 1 | - |
| entry_create_bkpta_x | input | 1 | - |
| entry_create_bkptb_x | input | 1 | - |
| entry_create_clk_en_x | input | 1 | - |
| entry_create_fence_x | input | 1 | - |
| entry_create_front_br_x | input | 1 | - |
| entry_create_inst_data_v | input | 16 | - |
| entry_create_split0_type_v | input | 3 | - |
| entry_create_split1_type_v | input | 3 | - |
| entry_create_vl_v | input | 8 | - |
| entry_create_vlmul_v | input | 2 | - |
| entry_create_vsetvli_x | input | 1 | - |
| entry_create_vsew_v | input | 3 | - |
| entry_create_x | input | 1 | - |
| fill_state_enter | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| lbuf_flush | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| entry_32_start_x | output | 1 | - |
| entry_back_br_x | output | 1 | - |
| entry_bkpta_x | output | 1 | - |
| entry_bkptb_x | output | 1 | - |
| entry_fence_x | output | 1 | - |
| entry_front_br_x | output | 1 | - |
| entry_inst_data_v | output | 16 | - |
| entry_split0_type_v | output | 3 | - |
| entry_split1_type_v | output | 3 | - |
| entry_vl_v | output | 8 | - |
| entry_vld_x | output | 1 | - |
| entry_vlmul_v | output | 2 | - |
| entry_vsetvli_x | output | 1 | - |
| entry_vsew_v | output | 3 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| entry_32_start_x | 1 | - |
| entry_back_br_x | 1 | - |
| entry_bkpta_x | 1 | - |
| entry_bkptb_x | 1 | - |
| entry_fence_x | 1 | - |
| entry_front_br_x | 1 | - |
| entry_inst_data_v | 16 | - |
| entry_split0_type_v | 3 | - |
| entry_split1_type_v | 3 | - |
| entry_vl_v | 8 | - |
| entry_vld_x | 1 | - |
| entry_vlmul_v | 2 | - |
| entry_vsetvli_x | 1 | - |
| entry_vsew_v | 3 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| entry_create_32_start_x | 1 | - |
| entry_create_back_br_x | 1 | - |
| entry_create_bkpta_x | 1 | - |
| entry_create_bkptb_x | 1 | - |
| entry_create_clk_en_x | 1 | - |
| entry_create_fence_x | 1 | - |
| entry_create_front_br_x | 1 | - |
| entry_create_inst_data_v | 16 | - |
| entry_create_split0_type_v | 3 | - |
| entry_create_split1_type_v | 3 | - |
| entry_create_vl_v | 8 | - |
| entry_create_vlmul_v | 2 | - |
| entry_create_vsetvli_x | 1 | - |
| entry_create_vsew_v | 3 | - |
| entry_create_x | 1 | - |
| fill_state_enter | 1 | - |
| forever_cpuclk | 1 | - |
| lbuf_entry_update_clk | 1 | - |
| lbuf_entry_update_clk_en | 1 | - |
| lbuf_flush | 1 | - |
| lbuf_vld_update_clk | 1 | - |
| lbuf_vld_update_clk_en | 1 | - |
| pad_yy_icg_scan_en | 1 | - |

## 4. 设计说明

### 4.1 设计特点

- 模块类型：循环缓冲表项模块
- 所属单元：取指单元(IFU)
- 接口数量：输入22个，输出14个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
