# ct_ifu_debug 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_debug |
| 文件名称 | ct_ifu_debug.v |
| 功能描述 | 调试模块 |

### 1.2 功能描述

调试模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_rtu_xx_jdbreq | input | 1 | - |
| ibctrl_debug_buf_stall | input | 1 | - |
| ibctrl_debug_bypass_inst_vld | input | 1 | - |
| ibctrl_debug_fifo_full_stall | input | 1 | - |
| ibctrl_debug_fifo_stall | input | 1 | - |
| ibctrl_debug_ib_expt_vld | input | 1 | - |
| ibctrl_debug_ib_ip_stall | input | 1 | - |
| ibctrl_debug_ib_vld | input | 1 | - |
| ibctrl_debug_ibuf_empty | input | 1 | - |
| ibctrl_debug_ibuf_full | input | 1 | - |
| ibctrl_debug_ibuf_inst_vld | input | 1 | - |
| ibctrl_debug_ind_btb_stall | input | 1 | - |
| ibctrl_debug_lbuf_inst_vld | input | 1 | - |
| ibctrl_debug_mispred_stall | input | 1 | - |
| ibdp_debug_inst0_vld | input | 1 | - |
| ibdp_debug_inst1_vld | input | 1 | - |
| ibdp_debug_inst2_vld | input | 1 | - |
| ibdp_debug_mmu_deny_vld | input | 1 | - |
| ifctrl_debug_if_pc_vld | input | 1 | - |
| ifctrl_debug_if_stall | input | 1 | - |
| ifctrl_debug_if_vld | input | 1 | - |
| ifctrl_debug_inv_st | input | 4 | - |
| ifctrl_debug_lsu_all_inv | input | 1 | - |
| ifctrl_debug_lsu_line_inv | input | 1 | - |
| ifctrl_debug_mmu_pavld | input | 1 | - |
| ifctrl_debug_way_pred_stall | input | 1 | - |
| ifdp_debug_acc_err_vld | input | 1 | - |
| ifdp_debug_mmu_expt_vld | input | 1 | - |
| ipb_debug_req_cur_st | input | 4 | - |
| ipb_debug_wb_cur_st | input | 3 | - |
| ipctrl_debug_bry_missigned_stall | input | 1 | - |
| ipctrl_debug_h0_vld | input | 1 | - |
| ipctrl_debug_ip_expt_vld | input | 1 | - |
| ipctrl_debug_ip_if_stall | input | 1 | - |
| ipctrl_debug_ip_vld | input | 1 | - |
| ipctrl_debug_miss_under_refill_stall | input | 1 | - |
| l0_btb_debug_cur_state | input | 2 | - |
| l1_refill_debug_refill_st | input | 4 | - |
| lbuf_debug_st | input | 6 | - |
| pcgen_debug_chgflw | input | 1 | - |
| pcgen_debug_pcbus | input | 14 | - |
| rtu_ifu_xx_dbgon | input | 1 | - |
| vector_debug_cur_st | input | 10 | - |
| vector_debug_reset_on | input | 1 | - |
| vfdsu_ifu_debug_ex2_wait | input | 1 | - |
| vfdsu_ifu_debug_idle | input | 1 | - |
| vfdsu_ifu_debug_pipe_busy | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_had_debug_info | output | 83 | - |
| ifu_had_reset_on | output | 1 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ifu_had_debug_info | 83 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bry_missigned_stall | 1 | - |
| buf_stall | 1 | - |
| bypass_inst_vld | 1 | - |
| chgflw | 1 | - |
| cpurst_b | 1 | - |
| dbg_ack_info | 1 | - |
| fifo_full_stall | 1 | - |
| fifo_stall | 1 | - |
| forever_cpuclk | 1 | - |
| had_debug_info | 83 | - |
| had_rtu_xx_jdbreq | 1 | - |
| ib_expt_vld | 1 | - |
| ib_ip_stall | 1 | - |
| ib_mmu_deny_vld | 1 | - |
| ib_vld | 1 | - |
| ibctrl_debug_buf_stall | 1 | - |
| ibctrl_debug_bypass_inst_vld | 1 | - |
| ibctrl_debug_fifo_full_stall | 1 | - |
| ibctrl_debug_fifo_stall | 1 | - |
| ibctrl_debug_ib_expt_vld | 1 | - |
| ibctrl_debug_ib_ip_stall | 1 | - |
| ibctrl_debug_ib_vld | 1 | - |
| ibctrl_debug_ibuf_empty | 1 | - |
| ibctrl_debug_ibuf_full | 1 | - |
| ibctrl_debug_ibuf_inst_vld | 1 | - |
| ibctrl_debug_ind_btb_stall | 1 | - |
| ibctrl_debug_lbuf_inst_vld | 1 | - |
| ibctrl_debug_mispred_stall | 1 | - |
| ibdp_debug_inst0_vld | 1 | - |
| ibdp_debug_inst1_vld | 1 | - |

*注：共96个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：调试模块
- 所属单元：取指单元(IFU)
- 接口数量：输入49个，输出2个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
