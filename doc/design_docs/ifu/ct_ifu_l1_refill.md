# ct_ifu_l1_refill 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_l1_refill |
| 文件名称 | ct_ifu_l1_refill.v |
| 功能描述 | L1填充模块 |

### 1.2 功能描述

L1填充模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ifctrl_l1_refill_ins_inv | input | 1 | - |
| ifctrl_l1_refill_ins_inv_dn | input | 1 | - |
| ifctrl_l1_refill_inv_busy | input | 1 | - |
| ifctrl_l1_refill_inv_on | input | 1 | - |
| ifdp_l1_refill_bufferable | input | 1 | - |
| ifdp_l1_refill_cacheable | input | 1 | - |
| ifdp_l1_refill_fifo | input | 1 | - |
| ifdp_l1_refill_machine_mode | input | 1 | - |
| ifdp_l1_refill_secure | input | 1 | - |
| ifdp_l1_refill_supv_mode | input | 1 | - |
| ifdp_l1_refill_tsize | input | 1 | - |
| ipb_l1_refill_data_vld | input | 1 | - |
| ipb_l1_refill_grnt | input | 1 | - |
| ipb_l1_refill_rdata | input | 128 | - |
| ipb_l1_refill_trans_err | input | 1 | - |
| ipctrl_l1_refill_chk_err | input | 1 | - |
| ipctrl_l1_refill_fifo | input | 1 | - |
| ipctrl_l1_refill_miss_req | input | 1 | - |
| ipctrl_l1_refill_ppc | input | 39 | - |
| ipctrl_l1_refill_req_for_gateclk | input | 1 | - |
| ipctrl_l1_refill_vpc | input | 39 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_l1_refill_chgflw | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_hpcp_icache_miss_pre | output | 1 | - |
| l1_refill_debug_refill_st | output | 4 | - |
| l1_refill_icache_if_fifo | output | 1 | - |
| l1_refill_icache_if_first | output | 1 | - |
| l1_refill_icache_if_index | output | 39 | - |
| l1_refill_icache_if_inst_data | output | 128 | - |
| l1_refill_icache_if_last | output | 1 | - |
| l1_refill_icache_if_pre_code | output | 32 | - |
| l1_refill_icache_if_ptag | output | 28 | - |
| l1_refill_icache_if_wr | output | 1 | - |
| l1_refill_ifctrl_ctc | output | 1 | - |
| l1_refill_ifctrl_idle | output | 1 | - |
| l1_refill_ifctrl_pc | output | 39 | - |
| l1_refill_ifctrl_refill_on | output | 1 | - |
| l1_refill_ifctrl_reissue | output | 1 | - |
| l1_refill_ifctrl_start | output | 1 | - |
| l1_refill_ifctrl_start_for_gateclk | output | 1 | - |
| l1_refill_ifctrl_trans_cmplt | output | 1 | - |
| l1_refill_ifdp_acc_err | output | 1 | - |
| l1_refill_ifdp_inst_data | output | 128 | - |
| l1_refill_ifdp_precode | output | 32 | - |
| l1_refill_ifdp_refill_on | output | 1 | - |
| l1_refill_ifdp_tag_data | output | 29 | - |
| l1_refill_inv_wfd_back | output | 1 | - |
| l1_refill_ipb_bufferable | output | 1 | - |
| l1_refill_ipb_cacheable | output | 1 | - |
| l1_refill_ipb_ctc_inv | output | 1 | - |
| l1_refill_ipb_machine_mode | output | 1 | - |
| l1_refill_ipb_ppc | output | 40 | - |
| l1_refill_ipb_pre_cancel | output | 1 | - |
| l1_refill_ipb_refill_on | output | 1 | - |
| l1_refill_ipb_req | output | 1 | - |
| l1_refill_ipb_req_for_gateclk | output | 1 | - |
| l1_refill_ipb_req_pre | output | 1 | - |
| l1_refill_ipb_secure | output | 1 | - |
| l1_refill_ipb_supv_mode | output | 1 | - |
| l1_refill_ipb_tsize | output | 1 | - |
| l1_refill_ipb_vpc | output | 40 | - |
| l1_refill_ipctrl_busy | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| IDLE | 1 | 4'b0000 | - |
| REQ | 1 | 4'b0001 | - |
| WFG | 1 | 4'b0010 | - |
| WFD1 | 1 | 4'b0100 | - |
| WFD2 | 1 | 4'b0101 | - |
| WFD3 | 1 | 4'b0110 | - |
| WFD4 | 1 | 4'b0111 | - |
| INV_WFD1 | 1 | 4'b1000 | - |
| INV_WFD2 | 1 | 4'b1001 | - |
| INV_WFD3 | 1 | 4'b1010 | - |
| INV_WFD4 | 1 | 4'b1011 | - |
| CTC_INV | 1 | 4'b0011 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| bufferable | 1 | - |
| cacheable | 1 | - |
| inv_wfd_back | 1 | - |
| l1_refill_icache_if_fifo | 1 | - |
| machine_mode | 1 | - |
| physical_pc | 39 | - |
| refill_cur_state | 4 | - |
| refill_next_state | 4 | - |
| secure | 1 | - |
| supv_mode | 1 | - |
| tsize | 1 | - |
| virtual_pc | 39 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| byte0 | 8 | - |
| byte1 | 8 | - |
| byte10 | 8 | - |
| byte11 | 8 | - |
| byte12 | 8 | - |
| byte13 | 8 | - |
| byte14 | 8 | - |
| byte15 | 8 | - |
| byte2 | 8 | - |
| byte3 | 8 | - |
| byte4 | 8 | - |
| byte5 | 8 | - |
| byte6 | 8 | - |
| byte7 | 8 | - |
| byte8 | 8 | - |
| byte9 | 8 | - |
| change_flow | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| icache_inv_busy | 1 | - |
| ifctrl_l1_refill_ins_inv | 1 | - |
| ifctrl_l1_refill_ins_inv_dn | 1 | - |
| ifctrl_l1_refill_inv_busy | 1 | - |
| ifctrl_l1_refill_inv_on | 1 | - |
| ifdp_l1_refill_bufferable | 1 | - |
| ifdp_l1_refill_cacheable | 1 | - |
| ifdp_l1_refill_fifo | 1 | - |
| ifdp_l1_refill_machine_mode | 1 | - |

*注：共98个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：L1填充模块
- 所属单元：取指单元(IFU)
- 接口数量：输入27个，输出39个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
