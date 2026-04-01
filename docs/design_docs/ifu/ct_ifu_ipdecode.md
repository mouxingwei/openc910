# ct_ifu_ipdecode 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipdecode |
| 文件名称 | ct_ifu_ipdecode.v |
| 功能描述 | IP阶段译码模块 |

### 1.2 功能描述

IP阶段译码模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_cskyee | input | 1 | - |
| cp0_idu_frm | input | 3 | - |
| cp0_idu_fs | input | 2 | - |
| cp0_ifu_vl | input | 8 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| h0_data | input | 16 | - |
| h1_br | input | 1 | - |
| h1_data | input | 16 | - |
| h2_br | input | 1 | - |
| h2_data | input | 16 | - |
| h3_br | input | 1 | - |
| h3_data | input | 16 | - |
| h4_br | input | 1 | - |
| h4_data | input | 16 | - |
| h5_br | input | 1 | - |
| h5_data | input | 16 | - |
| h6_br | input | 1 | - |
| h6_data | input | 16 | - |
| h7_br | input | 1 | - |
| h7_data | input | 16 | - |
| h8_br | input | 1 | - |
| h8_data | input | 16 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ipdecode_ipdp_auipc | output | 8 | - |
| ipdecode_ipdp_branch | output | 8 | - |
| ipdecode_ipdp_chgflw | output | 8 | - |
| ipdecode_ipdp_con_br | output | 8 | - |
| ipdecode_ipdp_dst_vld | output | 8 | - |
| ipdecode_ipdp_fence | output | 8 | - |
| ipdecode_ipdp_h0_fence | output | 1 | - |
| ipdecode_ipdp_h0_ind_br | output | 1 | - |
| ipdecode_ipdp_h0_ld | output | 1 | - |
| ipdecode_ipdp_h0_offset | output | 21 | - |
| ipdecode_ipdp_h0_pcall | output | 1 | - |
| ipdecode_ipdp_h0_preturn | output | 1 | - |
| ipdecode_ipdp_h0_split0_type | output | 3 | - |
| ipdecode_ipdp_h0_split1_type | output | 3 | - |
| ipdecode_ipdp_h0_st | output | 1 | - |
| ipdecode_ipdp_h0_vlmax | output | 8 | - |
| ipdecode_ipdp_h0_vlmul | output | 2 | - |
| ipdecode_ipdp_h0_vsetvli | output | 1 | - |
| ipdecode_ipdp_h0_vsew | output | 3 | - |
| ipdecode_ipdp_h1_offset | output | 21 | - |
| ipdecode_ipdp_h1_split0_type | output | 3 | - |
| ipdecode_ipdp_h1_split1_type | output | 3 | - |
| ipdecode_ipdp_h2_offset | output | 21 | - |
| ipdecode_ipdp_h2_split0_type | output | 3 | - |
| ipdecode_ipdp_h2_split1_type | output | 3 | - |
| ipdecode_ipdp_h3_offset | output | 21 | - |
| ipdecode_ipdp_h3_split0_type | output | 3 | - |
| ipdecode_ipdp_h3_split1_type | output | 3 | - |
| ipdecode_ipdp_h4_offset | output | 21 | - |
| ipdecode_ipdp_h4_split0_type | output | 3 | - |
| ipdecode_ipdp_h4_split1_type | output | 3 | - |
| ipdecode_ipdp_h5_offset | output | 21 | - |
| ipdecode_ipdp_h5_split0_type | output | 3 | - |
| ipdecode_ipdp_h5_split1_type | output | 3 | - |
| ipdecode_ipdp_h6_offset | output | 21 | - |
| ipdecode_ipdp_h6_split0_type | output | 3 | - |
| ipdecode_ipdp_h6_split1_type | output | 3 | - |
| ipdecode_ipdp_h7_offset | output | 21 | - |
| ipdecode_ipdp_h7_split0_type | output | 3 | - |
| ipdecode_ipdp_h7_split1_type | output | 3 | - |
| ipdecode_ipdp_h8_offset | output | 21 | - |
| ipdecode_ipdp_h8_split0_type | output | 3 | - |
| ipdecode_ipdp_h8_split1_type | output | 3 | - |
| ipdecode_ipdp_ind_br | output | 8 | - |
| ipdecode_ipdp_jal | output | 8 | - |
| ipdecode_ipdp_jalr | output | 8 | - |
| ipdecode_ipdp_ld | output | 8 | - |
| ipdecode_ipdp_pc_oper | output | 8 | - |
| ipdecode_ipdp_pcall | output | 8 | - |
| ipdecode_ipdp_preturn | output | 8 | - |

*注：共55个输出端口，此处仅显示前50个*

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_idu_cskyee | 1 | - |
| cp0_idu_frm | 3 | - |
| cp0_idu_fs | 2 | - |
| cp0_ifu_vl | 8 | - |
| cp0_ifu_vsetvli_pred_disable | 1 | - |
| h0_auipc | 1 | - |
| h0_br | 1 | - |
| h0_branch | 1 | - |
| h0_chgflw | 1 | - |
| h0_con_br | 1 | - |
| h0_data | 16 | - |
| h0_dst_vld | 1 | - |
| h0_fence | 1 | - |
| h0_fence_type | 3 | - |
| h0_ind_br | 1 | - |
| h0_inst | 32 | - |
| h0_jal | 1 | - |
| h0_jalr | 1 | - |
| h0_ld | 1 | - |
| h0_offset | 21 | - |
| h0_pc_oper | 1 | - |
| h0_pcall | 1 | - |
| h0_preturn | 1 | - |
| h0_split | 1 | - |
| h0_split_long_type | 10 | - |
| h0_split_potnt | 3 | - |
| h0_split_short | 1 | - |
| h0_split_short_potnt | 3 | - |
| h0_split_short_type | 7 | - |
| h0_st | 1 | - |

*注：共321个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IP阶段译码模块
- 所属单元：取指单元(IFU)
- 接口数量：输入22个，输出55个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
