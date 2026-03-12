# ct_ifu_ibuf 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibuf |
| 文件路径 | ifu/rtl/ct_ifu_ibuf.v |
| 功能描述 | 指令缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibctrl_ibuf_bypass_not_select | input | 1 | |
| ibctrl_ibuf_create_vld | input | 1 | |
| ibctrl_ibuf_data_vld | input | 1 | |
| ibctrl_ibuf_flush | input | 1 | |
| ibctrl_ibuf_merge_vld | input | 1 | |
| ibctrl_ibuf_retire_vld | input | 1 | |
| ibdp_ibuf_h0_32_start | input | 1 | |
| ibdp_ibuf_h0_bkpta | input | 1 | |
| ibdp_ibuf_h0_bkptb | input | 1 | |
| ibdp_ibuf_h0_data | input | 16 | |
| ibdp_ibuf_h0_fence | input | 1 | |
| ibdp_ibuf_h0_high_expt | input | 1 | |
| ibdp_ibuf_h0_ldst | input | 1 | |
| ibdp_ibuf_h0_no_spec | input | 1 | |
| ibdp_ibuf_h0_pc | input | 15 | |
| ibdp_ibuf_h0_spe_vld | input | 1 | |
| ibdp_ibuf_h0_split0 | input | 1 | |
| ibdp_ibuf_h0_split1 | input | 1 | |
| ibdp_ibuf_h0_vl | input | 8 | |
| ibdp_ibuf_h0_vl_pred | input | 1 | |
| ibdp_ibuf_h0_vld | input | 1 | |
| ibdp_ibuf_h0_vlmul | input | 2 | |
| ibdp_ibuf_h0_vsew | input | 3 | |
| ibdp_ibuf_h1_data | input | 16 | |
| ibdp_ibuf_h1_pc | input | 15 | |
| ibdp_ibuf_h1_vl | input | 8 | |
| ... | ... | ... | 共89个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibuf_ibctrl_empty | output | 1 | |
| ibuf_ibctrl_stall | output | 1 | |
| ibuf_ibdp_bypass_inst0 | output | 32 | |
| ibuf_ibdp_bypass_inst0_bkpta | output | 1 | |
| ibuf_ibdp_bypass_inst0_bkptb | output | 1 | |
| ibuf_ibdp_bypass_inst0_ecc_err | output | 1 | |
| ibuf_ibdp_bypass_inst0_expt | output | 1 | |
| ibuf_ibdp_bypass_inst0_fence | output | 1 | |
| ibuf_ibdp_bypass_inst0_high_expt | output | 1 | |
| ibuf_ibdp_bypass_inst0_no_spec | output | 1 | |
| ibuf_ibdp_bypass_inst0_pc | output | 15 | |
| ibuf_ibdp_bypass_inst0_split0 | output | 1 | |
| ibuf_ibdp_bypass_inst0_split1 | output | 1 | |
| ibuf_ibdp_bypass_inst0_valid | output | 1 | |
| ibuf_ibdp_bypass_inst0_vec | output | 4 | |
| ibuf_ibdp_bypass_inst0_vl | output | 8 | |
| ibuf_ibdp_bypass_inst0_vl_pred | output | 1 | |
| ibuf_ibdp_bypass_inst0_vlmul | output | 2 | |
| ibuf_ibdp_bypass_inst0_vsew | output | 3 | |
| ibuf_ibdp_bypass_inst1 | output | 32 | |
| ibuf_ibdp_bypass_inst1_bkpta | output | 1 | |
| ibuf_ibdp_bypass_inst1_bkptb | output | 1 | |
| ibuf_ibdp_bypass_inst1_ecc_err | output | 1 | |
| ibuf_ibdp_bypass_inst1_expt | output | 1 | |
| ibuf_ibdp_bypass_inst1_fence | output | 1 | |
| ibuf_ibdp_bypass_inst1_high_expt | output | 1 | |
| ibuf_ibdp_bypass_inst1_no_spec | output | 1 | |
| ibuf_ibdp_bypass_inst1_pc | output | 15 | |
| ibuf_ibdp_bypass_inst1_split0 | output | 1 | |
| ibuf_ibdp_bypass_inst1_split1 | output | 1 | |
| ... | ... | ... | 共105个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_0 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_1 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_2 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_3 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_4 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_5 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_6 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_7 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_8 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_9 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_10 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_11 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_12 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_13 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_14 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_15 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_16 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_17 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_18 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_19 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_20 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_21 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_22 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_23 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_24 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_25 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_26 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_27 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_28 |
| ct_ifu_ibuf_entry | x_ct_ifu_ibuf_entry_29 |
| ... | 共35个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
