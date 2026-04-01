# ct_ifu_ibuf 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibuf |
| 文件名称 | ct_ifu_ibuf.v |
| 功能描述 | 指令缓冲模块 |

### 1.2 功能描述

指令缓冲模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibctrl_ibuf_bypass_not_select | input | 1 | - |
| ibctrl_ibuf_create_vld | input | 1 | - |
| ibctrl_ibuf_data_vld | input | 1 | - |
| ibctrl_ibuf_flush | input | 1 | - |
| ibctrl_ibuf_merge_vld | input | 1 | - |
| ibctrl_ibuf_retire_vld | input | 1 | - |
| ibdp_ibuf_h0_32_start | input | 1 | - |
| ibdp_ibuf_h0_bkpta | input | 1 | - |
| ibdp_ibuf_h0_bkptb | input | 1 | - |
| ibdp_ibuf_h0_data | input | 16 | - |
| ibdp_ibuf_h0_fence | input | 1 | - |
| ibdp_ibuf_h0_high_expt | input | 1 | - |
| ibdp_ibuf_h0_ldst | input | 1 | - |
| ibdp_ibuf_h0_no_spec | input | 1 | - |
| ibdp_ibuf_h0_pc | input | 15 | - |
| ibdp_ibuf_h0_spe_vld | input | 1 | - |
| ibdp_ibuf_h0_split0 | input | 1 | - |
| ibdp_ibuf_h0_split1 | input | 1 | - |
| ibdp_ibuf_h0_vl | input | 8 | - |
| ibdp_ibuf_h0_vl_pred | input | 1 | - |
| ibdp_ibuf_h0_vld | input | 1 | - |
| ibdp_ibuf_h0_vlmul | input | 2 | - |
| ibdp_ibuf_h0_vsew | input | 3 | - |
| ibdp_ibuf_h1_data | input | 16 | - |
| ibdp_ibuf_h1_pc | input | 15 | - |
| ibdp_ibuf_h1_vl | input | 8 | - |
| ibdp_ibuf_h1_vlmul | input | 2 | - |
| ibdp_ibuf_h1_vsew | input | 3 | - |
| ibdp_ibuf_h2_data | input | 16 | - |
| ibdp_ibuf_h2_pc | input | 15 | - |
| ibdp_ibuf_h2_vl | input | 8 | - |
| ibdp_ibuf_h2_vlmul | input | 2 | - |
| ibdp_ibuf_h2_vsew | input | 3 | - |
| ibdp_ibuf_h3_data | input | 16 | - |
| ibdp_ibuf_h3_pc | input | 15 | - |
| ibdp_ibuf_h3_vl | input | 8 | - |
| ibdp_ibuf_h3_vlmul | input | 2 | - |
| ibdp_ibuf_h3_vsew | input | 3 | - |
| ibdp_ibuf_h4_data | input | 16 | - |
| ibdp_ibuf_h4_pc | input | 15 | - |
| ibdp_ibuf_h4_vl | input | 8 | - |
| ibdp_ibuf_h4_vlmul | input | 2 | - |
| ibdp_ibuf_h4_vsew | input | 3 | - |
| ibdp_ibuf_h5_data | input | 16 | - |
| ibdp_ibuf_h5_pc | input | 15 | - |
| ibdp_ibuf_h5_vl | input | 8 | - |

*注：共89个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibuf_ibctrl_empty | output | 1 | - |
| ibuf_ibctrl_stall | output | 1 | - |
| ibuf_ibdp_bypass_inst0 | output | 32 | - |
| ibuf_ibdp_bypass_inst0_bkpta | output | 1 | - |
| ibuf_ibdp_bypass_inst0_bkptb | output | 1 | - |
| ibuf_ibdp_bypass_inst0_ecc_err | output | 1 | - |
| ibuf_ibdp_bypass_inst0_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst0_fence | output | 1 | - |
| ibuf_ibdp_bypass_inst0_high_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst0_no_spec | output | 1 | - |
| ibuf_ibdp_bypass_inst0_pc | output | 15 | - |
| ibuf_ibdp_bypass_inst0_split0 | output | 1 | - |
| ibuf_ibdp_bypass_inst0_split1 | output | 1 | - |
| ibuf_ibdp_bypass_inst0_valid | output | 1 | - |
| ibuf_ibdp_bypass_inst0_vec | output | 4 | - |
| ibuf_ibdp_bypass_inst0_vl | output | 8 | - |
| ibuf_ibdp_bypass_inst0_vl_pred | output | 1 | - |
| ibuf_ibdp_bypass_inst0_vlmul | output | 2 | - |
| ibuf_ibdp_bypass_inst0_vsew | output | 3 | - |
| ibuf_ibdp_bypass_inst1 | output | 32 | - |
| ibuf_ibdp_bypass_inst1_bkpta | output | 1 | - |
| ibuf_ibdp_bypass_inst1_bkptb | output | 1 | - |
| ibuf_ibdp_bypass_inst1_ecc_err | output | 1 | - |
| ibuf_ibdp_bypass_inst1_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst1_fence | output | 1 | - |
| ibuf_ibdp_bypass_inst1_high_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst1_no_spec | output | 1 | - |
| ibuf_ibdp_bypass_inst1_pc | output | 15 | - |
| ibuf_ibdp_bypass_inst1_split0 | output | 1 | - |
| ibuf_ibdp_bypass_inst1_split1 | output | 1 | - |
| ibuf_ibdp_bypass_inst1_valid | output | 1 | - |
| ibuf_ibdp_bypass_inst1_vec | output | 4 | - |
| ibuf_ibdp_bypass_inst1_vl | output | 8 | - |
| ibuf_ibdp_bypass_inst1_vl_pred | output | 1 | - |
| ibuf_ibdp_bypass_inst1_vlmul | output | 2 | - |
| ibuf_ibdp_bypass_inst1_vsew | output | 3 | - |
| ibuf_ibdp_bypass_inst2 | output | 32 | - |
| ibuf_ibdp_bypass_inst2_bkpta | output | 1 | - |
| ibuf_ibdp_bypass_inst2_bkptb | output | 1 | - |
| ibuf_ibdp_bypass_inst2_ecc_err | output | 1 | - |
| ibuf_ibdp_bypass_inst2_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst2_fence | output | 1 | - |
| ibuf_ibdp_bypass_inst2_high_expt | output | 1 | - |
| ibuf_ibdp_bypass_inst2_no_spec | output | 1 | - |
| ibuf_ibdp_bypass_inst2_pc | output | 15 | - |
| ibuf_ibdp_bypass_inst2_split0 | output | 1 | - |
| ibuf_ibdp_bypass_inst2_split1 | output | 1 | - |
| ibuf_ibdp_bypass_inst2_valid | output | 1 | - |
| ibuf_ibdp_bypass_inst2_vec | output | 4 | - |
| ibuf_ibdp_bypass_inst2_vl | output | 8 | - |

*注：共105个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| ENTRY_NUM | 1 | 32 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bypass_way_half_num | 3 | - |
| bypass_way_inst0_32_start | 1 | - |
| bypass_way_inst0_bkpta | 1 | - |
| bypass_way_inst0_bkptb | 1 | - |
| bypass_way_inst0_data | 32 | - |
| bypass_way_inst0_ecc_err | 1 | - |
| bypass_way_inst0_expt | 1 | - |
| bypass_way_inst0_fence | 1 | - |
| bypass_way_inst0_high_expt | 1 | - |
| bypass_way_inst0_no_spec | 1 | - |
| bypass_way_inst0_pc | 15 | - |
| bypass_way_inst0_split0 | 1 | - |
| bypass_way_inst0_split1 | 1 | - |
| bypass_way_inst0_valid | 1 | - |
| bypass_way_inst0_vec | 4 | - |
| bypass_way_inst0_vl | 8 | - |
| bypass_way_inst0_vl_pred | 1 | - |
| bypass_way_inst0_vlmul | 2 | - |
| bypass_way_inst0_vsew | 3 | - |
| bypass_way_inst1_32_start | 1 | - |
| bypass_way_inst1_bkpta | 1 | - |
| bypass_way_inst1_bkptb | 1 | - |
| bypass_way_inst1_data | 32 | - |
| bypass_way_inst1_ecc_err | 1 | - |
| bypass_way_inst1_expt | 1 | - |
| bypass_way_inst1_fence | 1 | - |
| bypass_way_inst1_high_expt | 1 | - |
| bypass_way_inst1_no_spec | 1 | - |
| bypass_way_inst1_pc | 15 | - |
| bypass_way_inst1_split0 | 1 | - |

*注：共149个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bypass_vld | 1 | - |
| bypass_way_h0_32_start | 1 | - |
| bypass_way_h0_acc_err | 1 | - |
| bypass_way_h0_bkpta | 1 | - |
| bypass_way_h0_bkptb | 1 | - |
| bypass_way_h0_data | 16 | - |
| bypass_way_h0_ecc_err | 1 | - |
| bypass_way_h0_expt | 1 | - |
| bypass_way_h0_fence | 1 | - |
| bypass_way_h0_high_expt | 1 | - |
| bypass_way_h0_no_spec | 1 | - |
| bypass_way_h0_pc | 15 | - |
| bypass_way_h0_pgflt | 1 | - |
| bypass_way_h0_split0 | 1 | - |
| bypass_way_h0_split1 | 1 | - |
| bypass_way_h0_vec | 4 | - |
| bypass_way_h0_vl | 8 | - |
| bypass_way_h0_vl_pred | 1 | - |
| bypass_way_h0_vld | 1 | - |
| bypass_way_h0_vlmul | 2 | - |
| bypass_way_h0_vsew | 3 | - |
| bypass_way_h1_32_start | 1 | - |
| bypass_way_h1_acc_err | 1 | - |
| bypass_way_h1_bkpta | 1 | - |
| bypass_way_h1_bkptb | 1 | - |
| bypass_way_h1_data | 16 | - |
| bypass_way_h1_ecc_err | 1 | - |
| bypass_way_h1_expt | 1 | - |
| bypass_way_h1_fence | 1 | - |
| bypass_way_h1_high_expt | 1 | - |

*注：共860个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：指令缓冲模块
- 所属单元：取指单元(IFU)
- 接口数量：输入89个，输出105个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
