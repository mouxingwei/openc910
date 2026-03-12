# ct_ifu_ibdp 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ibdp |
| 文件路径 | ifu/rtl/ct_ifu_ibdp.v |
| 功能描述 | 指令缓冲数据通路 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | |
| cp0_ifu_ras_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ibctrl_ibdp_buf_stall | input | 1 | |
| ibctrl_ibdp_bypass_inst_vld | input | 1 | |
| ibctrl_ibdp_cancel | input | 1 | |
| ibctrl_ibdp_chgflw | input | 1 | |
| ibctrl_ibdp_fifo_full_stall | input | 1 | |
| ibctrl_ibdp_fifo_stall | input | 1 | |
| ibctrl_ibdp_ibuf_inst_vld | input | 1 | |
| ibctrl_ibdp_if_chgflw_vld | input | 1 | |
| ibctrl_ibdp_ind_btb_rd_stall | input | 1 | |
| ibctrl_ibdp_ip_chgflw_vld | input | 1 | |
| ibctrl_ibdp_l0_btb_hit | input | 1 | |
| ibctrl_ibdp_l0_btb_mispred | input | 1 | |
| ibctrl_ibdp_l0_btb_miss | input | 1 | |
| ibctrl_ibdp_l0_btb_wait | input | 1 | |
| ibctrl_ibdp_lbuf_inst_vld | input | 1 | |
| ibctrl_ibdp_mispred_stall | input | 1 | |
| ibctrl_ibdp_self_stall | input | 1 | |
| ibuf_ibdp_bypass_inst0 | input | 32 | |
| ibuf_ibdp_bypass_inst0_bkpta | input | 1 | |
| ibuf_ibdp_bypass_inst0_bkptb | input | 1 | |
| ibuf_ibdp_bypass_inst0_ecc_err | input | 1 | |
| ibuf_ibdp_bypass_inst0_expt | input | 1 | |
| ibuf_ibdp_bypass_inst0_fence | input | 1 | |
| ibuf_ibdp_bypass_inst0_high_expt | input | 1 | |
| ibuf_ibdp_bypass_inst0_no_spec | input | 1 | |
| ... | ... | ... | 共310个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ibdp_addrgen_branch_base | output | 39 | |
| ibdp_addrgen_branch_offset | output | 21 | |
| ibdp_addrgen_branch_result | output | 39 | |
| ibdp_addrgen_branch_valid | output | 1 | |
| ibdp_addrgen_branch_vl | output | 8 | |
| ibdp_addrgen_branch_vlmul | output | 2 | |
| ibdp_addrgen_branch_vsew | output | 3 | |
| ibdp_addrgen_btb_index_pc | output | 39 | |
| ibdp_addrgen_l0_btb_hit | output | 1 | |
| ibdp_addrgen_l0_btb_hit_entry | output | 16 | |
| ibdp_btb_miss | output | 1 | |
| ibdp_debug_inst0_vld | output | 1 | |
| ibdp_debug_inst1_vld | output | 1 | |
| ibdp_debug_inst2_vld | output | 1 | |
| ibdp_debug_mmu_deny_vld | output | 1 | |
| ibdp_ibctrl_chgflw_vl | output | 8 | |
| ibdp_ibctrl_chgflw_vlmul | output | 2 | |
| ibdp_ibctrl_chgflw_vsew | output | 3 | |
| ibdp_ibctrl_default_pc | output | 39 | |
| ibdp_ibctrl_hn_ind_br | output | 8 | |
| ibdp_ibctrl_hn_pcall | output | 8 | |
| ibdp_ibctrl_hn_preturn | output | 8 | |
| ibdp_ibctrl_l0_btb_mispred_pc | output | 39 | |
| ibdp_ibctrl_ras_chgflw_mask | output | 1 | |
| ibdp_ibctrl_ras_mistaken | output | 1 | |
| ibdp_ibctrl_ras_pc | output | 39 | |
| ibdp_ibctrl_vpc | output | 39 | |
| ibdp_ibuf_h0_32_start | output | 1 | |
| ibdp_ibuf_h0_bkpta | output | 1 | |
| ibdp_ibuf_h0_bkptb | output | 1 | |
| ... | ... | ... | 共221个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_updt_vld_clk |
| one | cycle |
| gated_clk_cell | x_fifo_mask_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
