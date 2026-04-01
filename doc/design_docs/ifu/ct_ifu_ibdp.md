# ct_ifu_ibdp 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibdp |
| 文件名称 | ct_ifu_ibdp.v |
| 功能描述 | IB阶段数据通路模块 |

### 1.2 功能描述

IB阶段数据通路模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_ras_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibctrl_ibdp_buf_stall | input | 1 | - |
| ibctrl_ibdp_bypass_inst_vld | input | 1 | - |
| ibctrl_ibdp_cancel | input | 1 | - |
| ibctrl_ibdp_chgflw | input | 1 | - |
| ibctrl_ibdp_fifo_full_stall | input | 1 | - |
| ibctrl_ibdp_fifo_stall | input | 1 | - |
| ibctrl_ibdp_ibuf_inst_vld | input | 1 | - |
| ibctrl_ibdp_if_chgflw_vld | input | 1 | - |
| ibctrl_ibdp_ind_btb_rd_stall | input | 1 | - |
| ibctrl_ibdp_ip_chgflw_vld | input | 1 | - |
| ibctrl_ibdp_l0_btb_hit | input | 1 | - |
| ibctrl_ibdp_l0_btb_mispred | input | 1 | - |
| ibctrl_ibdp_l0_btb_miss | input | 1 | - |
| ibctrl_ibdp_l0_btb_wait | input | 1 | - |
| ibctrl_ibdp_lbuf_inst_vld | input | 1 | - |
| ibctrl_ibdp_mispred_stall | input | 1 | - |
| ibctrl_ibdp_self_stall | input | 1 | - |
| ibuf_ibdp_bypass_inst0 | input | 32 | - |
| ibuf_ibdp_bypass_inst0_bkpta | input | 1 | - |
| ibuf_ibdp_bypass_inst0_bkptb | input | 1 | - |
| ibuf_ibdp_bypass_inst0_ecc_err | input | 1 | - |
| ibuf_ibdp_bypass_inst0_expt | input | 1 | - |
| ibuf_ibdp_bypass_inst0_fence | input | 1 | - |
| ibuf_ibdp_bypass_inst0_high_expt | input | 1 | - |
| ibuf_ibdp_bypass_inst0_no_spec | input | 1 | - |
| ibuf_ibdp_bypass_inst0_pc | input | 15 | - |
| ibuf_ibdp_bypass_inst0_split0 | input | 1 | - |
| ibuf_ibdp_bypass_inst0_split1 | input | 1 | - |
| ibuf_ibdp_bypass_inst0_valid | input | 1 | - |
| ibuf_ibdp_bypass_inst0_vec | input | 4 | - |
| ibuf_ibdp_bypass_inst0_vl | input | 8 | - |
| ibuf_ibdp_bypass_inst0_vl_pred | input | 1 | - |
| ibuf_ibdp_bypass_inst0_vlmul | input | 2 | - |
| ibuf_ibdp_bypass_inst0_vsew | input | 3 | - |
| ibuf_ibdp_bypass_inst1 | input | 32 | - |
| ibuf_ibdp_bypass_inst1_bkpta | input | 1 | - |
| ibuf_ibdp_bypass_inst1_bkptb | input | 1 | - |
| ibuf_ibdp_bypass_inst1_ecc_err | input | 1 | - |
| ibuf_ibdp_bypass_inst1_expt | input | 1 | - |
| ibuf_ibdp_bypass_inst1_fence | input | 1 | - |
| ibuf_ibdp_bypass_inst1_high_expt | input | 1 | - |
| ibuf_ibdp_bypass_inst1_no_spec | input | 1 | - |
| ibuf_ibdp_bypass_inst1_pc | input | 15 | - |
| ibuf_ibdp_bypass_inst1_split0 | input | 1 | - |
| ibuf_ibdp_bypass_inst1_split1 | input | 1 | - |

*注：共306个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibdp_addrgen_branch_base | output | 39 | - |
| ibdp_addrgen_branch_offset | output | 21 | - |
| ibdp_addrgen_branch_result | output | 39 | - |
| ibdp_addrgen_branch_valid | output | 1 | - |
| ibdp_addrgen_branch_vl | output | 8 | - |
| ibdp_addrgen_branch_vlmul | output | 2 | - |
| ibdp_addrgen_branch_vsew | output | 3 | - |
| ibdp_addrgen_btb_index_pc | output | 39 | - |
| ibdp_addrgen_l0_btb_hit | output | 1 | - |
| ibdp_addrgen_l0_btb_hit_entry | output | 16 | - |
| ibdp_btb_miss | output | 1 | - |
| ibdp_debug_inst0_vld | output | 1 | - |
| ibdp_debug_inst1_vld | output | 1 | - |
| ibdp_debug_inst2_vld | output | 1 | - |
| ibdp_debug_mmu_deny_vld | output | 1 | - |
| ibdp_ibctrl_chgflw_vl | output | 8 | - |
| ibdp_ibctrl_chgflw_vlmul | output | 2 | - |
| ibdp_ibctrl_chgflw_vsew | output | 3 | - |
| ibdp_ibctrl_default_pc | output | 39 | - |
| ibdp_ibctrl_hn_ind_br | output | 8 | - |
| ibdp_ibctrl_hn_pcall | output | 8 | - |
| ibdp_ibctrl_hn_preturn | output | 8 | - |
| ibdp_ibctrl_l0_btb_mispred_pc | output | 39 | - |
| ibdp_ibctrl_ras_chgflw_mask | output | 1 | - |
| ibdp_ibctrl_ras_mistaken | output | 1 | - |
| ibdp_ibctrl_ras_pc | output | 39 | - |
| ibdp_ibctrl_vpc | output | 39 | - |
| ibdp_ibuf_h0_32_start | output | 1 | - |
| ibdp_ibuf_h0_bkpta | output | 1 | - |
| ibdp_ibuf_h0_bkptb | output | 1 | - |
| ibdp_ibuf_h0_data | output | 16 | - |
| ibdp_ibuf_h0_fence | output | 1 | - |
| ibdp_ibuf_h0_high_expt | output | 1 | - |
| ibdp_ibuf_h0_ldst | output | 1 | - |
| ibdp_ibuf_h0_no_spec | output | 1 | - |
| ibdp_ibuf_h0_pc | output | 15 | - |
| ibdp_ibuf_h0_spe_vld | output | 1 | - |
| ibdp_ibuf_h0_split0 | output | 1 | - |
| ibdp_ibuf_h0_split1 | output | 1 | - |
| ibdp_ibuf_h0_vl | output | 8 | - |
| ibdp_ibuf_h0_vl_pred | output | 1 | - |
| ibdp_ibuf_h0_vld | output | 1 | - |
| ibdp_ibuf_h0_vlmul | output | 2 | - |
| ibdp_ibuf_h0_vsew | output | 3 | - |
| ibdp_ibuf_h1_data | output | 16 | - |
| ibdp_ibuf_h1_pc | output | 15 | - |
| ibdp_ibuf_h1_vl | output | 8 | - |
| ibdp_ibuf_h1_vlmul | output | 2 | - |
| ibdp_ibuf_h1_vsew | output | 3 | - |
| ibdp_ibuf_h2_data | output | 16 | - |

*注：共221个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| ID_WIDTH | 1 | 73 | - |
| ID_VL_PRED | 1 | 72 | - |
| ID_VL | 1 | 71 | - |
| ID_PC | 1 | 63 | - |
| ID_VSEW | 1 | 48 | - |
| ID_VLMUL | 1 | 45 | - |
| ID_NO_SPEC | 1 | 43 | - |
| ID_BKPTA_INST | 1 | 42 | - |
| ID_BKPTB_INST | 1 | 41 | - |
| ID_SPLIT_SHORT | 1 | 40 | - |
| ID_FENCE | 1 | 39 | - |
| ID_SPLIT_LONG | 1 | 38 | - |
| ID_HIGH_HW_EXPT | 1 | 37 | - |
| ID_EXPT_VEC | 1 | 36 | - |
| ID_EXPT_VLD | 1 | 32 | - |
| ID_OPCODE | 1 | 31 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| hn_pc_oper_updt_val | 8 | - |
| inst0 | 32 | - |
| inst0_bkpta | 1 | - |
| inst0_bkptb | 1 | - |
| inst0_ecc_err | 1 | - |
| inst0_expt_vld | 1 | - |
| inst0_fence | 1 | - |
| inst0_high_expt | 1 | - |
| inst0_no_spec | 1 | - |
| inst0_pc | 15 | - |
| inst0_split0 | 1 | - |
| inst0_split1 | 1 | - |
| inst0_vec | 4 | - |
| inst0_vl | 8 | - |
| inst0_vl_pred | 1 | - |
| inst0_vld | 1 | - |
| inst0_vlmul | 2 | - |
| inst0_vsew | 3 | - |
| inst1 | 32 | - |
| inst1_bkpta | 1 | - |
| inst1_bkptb | 1 | - |
| inst1_ecc_err | 1 | - |
| inst1_expt_vld | 1 | - |
| inst1_fence | 1 | - |
| inst1_high_expt | 1 | - |
| inst1_no_spec | 1 | - |
| inst1_pc | 15 | - |
| inst1_split0 | 1 | - |
| inst1_split1 | 1 | - |
| inst1_vec | 4 | - |

*注：共58个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| buf_stall | 1 | - |
| bypass_inst_vld | 1 | - |
| chgflw_mask | 8 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_ras_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| fifo_full_stall | 1 | - |
| fifo_mask_clk | 1 | - |
| fifo_mask_clk_en | 1 | - |
| fifo_stall | 1 | - |
| forever_cpuclk | 1 | - |
| hn_pc_oper_updt_val_pre | 8 | - |
| ib_data_vld | 1 | - |
| ibctrl_ibdp_buf_stall | 1 | - |
| ibctrl_ibdp_bypass_inst_vld | 1 | - |
| ibctrl_ibdp_cancel | 1 | - |
| ibctrl_ibdp_chgflw | 1 | - |
| ibctrl_ibdp_fifo_full_stall | 1 | - |
| ibctrl_ibdp_fifo_stall | 1 | - |
| ibctrl_ibdp_ibuf_inst_vld | 1 | - |
| ibctrl_ibdp_if_chgflw_vld | 1 | - |
| ibctrl_ibdp_ind_btb_rd_stall | 1 | - |
| ibctrl_ibdp_ip_chgflw_vld | 1 | - |
| ibctrl_ibdp_l0_btb_hit | 1 | - |
| ibctrl_ibdp_l0_btb_mispred | 1 | - |
| ibctrl_ibdp_l0_btb_miss | 1 | - |
| ibctrl_ibdp_l0_btb_wait | 1 | - |
| ibctrl_ibdp_lbuf_inst_vld | 1 | - |
| ibctrl_ibdp_mispred_stall | 1 | - |

*注：共672个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IB阶段数据通路模块
- 所属单元：取指单元(IFU)
- 接口数量：输入306个，输出221个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
