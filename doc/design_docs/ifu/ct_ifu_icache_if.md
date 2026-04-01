# ct_ifu_icache_if 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_icache_if |
| 文件名称 | ct_ifu_icache_if.v |
| 功能描述 | 指令缓存接口模块 |

### 1.2 功能描述

指令缓存接口模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icache_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| hpcp_ifu_cnt_en | input | 1 | - |
| ifctrl_icache_if_index | input | 39 | - |
| ifctrl_icache_if_inv_fifo | input | 1 | - |
| ifctrl_icache_if_inv_on | input | 1 | - |
| ifctrl_icache_if_read_req_data0 | input | 1 | - |
| ifctrl_icache_if_read_req_data1 | input | 1 | - |
| ifctrl_icache_if_read_req_index | input | 39 | - |
| ifctrl_icache_if_read_req_tag | input | 1 | - |
| ifctrl_icache_if_reset_req | input | 1 | - |
| ifctrl_icache_if_tag_req | input | 1 | - |
| ifctrl_icache_if_tag_wen | input | 3 | - |
| ifu_hpcp_icache_miss_pre | input | 1 | - |
| ipb_icache_if_index | input | 34 | - |
| ipb_icache_if_req | input | 1 | - |
| ipb_icache_if_req_for_gateclk | input | 1 | - |
| l1_refill_icache_if_fifo | input | 1 | - |
| l1_refill_icache_if_first | input | 1 | - |
| l1_refill_icache_if_index | input | 39 | - |
| l1_refill_icache_if_inst_data | input | 128 | - |
| l1_refill_icache_if_last | input | 1 | - |
| l1_refill_icache_if_pre_code | input | 32 | - |
| l1_refill_icache_if_ptag | input | 28 | - |
| l1_refill_icache_if_wr | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_icache_if_chgflw | input | 1 | - |
| pcgen_icache_if_chgflw_bank0 | input | 1 | - |
| pcgen_icache_if_chgflw_bank1 | input | 1 | - |
| pcgen_icache_if_chgflw_bank2 | input | 1 | - |
| pcgen_icache_if_chgflw_bank3 | input | 1 | - |
| pcgen_icache_if_chgflw_short | input | 1 | - |
| pcgen_icache_if_gateclk_en | input | 1 | - |
| pcgen_icache_if_index | input | 16 | - |
| pcgen_icache_if_seq_data_req | input | 1 | - |
| pcgen_icache_if_seq_data_req_short | input | 1 | - |
| pcgen_icache_if_seq_tag_req | input | 1 | - |
| pcgen_icache_if_way_pred | input | 2 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| icache_if_ifctrl_inst_data0 | output | 128 | - |
| icache_if_ifctrl_inst_data1 | output | 128 | - |
| icache_if_ifctrl_tag_data0 | output | 29 | - |
| icache_if_ifctrl_tag_data1 | output | 29 | - |
| icache_if_ifdp_fifo | output | 1 | - |
| icache_if_ifdp_inst_data0 | output | 128 | - |
| icache_if_ifdp_inst_data1 | output | 128 | - |
| icache_if_ifdp_precode0 | output | 32 | - |
| icache_if_ifdp_precode1 | output | 32 | - |
| icache_if_ifdp_tag_data0 | output | 29 | - |
| icache_if_ifdp_tag_data1 | output | 29 | - |
| icache_if_ipb_tag_data0 | output | 29 | - |
| icache_if_ipb_tag_data1 | output | 29 | - |
| ifu_hpcp_icache_access | output | 1 | - |
| ifu_hpcp_icache_miss | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| icache_index_higher | 16 | - |
| ifu_hpcp_icache_access_reg | 1 | - |
| ifu_hpcp_icache_miss_reg | 1 | - |
| ifu_icache_tag_wen | 3 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_ifu_icache_en | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| fifo_bit | 1 | - |
| forever_cpuclk | 1 | - |
| hpcp_clk | 1 | - |
| hpcp_clk_en | 1 | - |
| hpcp_ifu_cnt_en | 1 | - |
| icache_if_ifctrl_inst_data0 | 128 | - |
| icache_if_ifctrl_inst_data1 | 128 | - |
| icache_if_ifctrl_tag_data0 | 29 | - |
| icache_if_ifctrl_tag_data1 | 29 | - |
| icache_if_ifdp_fifo | 1 | - |
| icache_if_ifdp_inst_data0 | 128 | - |
| icache_if_ifdp_inst_data1 | 128 | - |
| icache_if_ifdp_precode0 | 32 | - |
| icache_if_ifdp_precode1 | 32 | - |
| icache_if_ifdp_tag_data0 | 29 | - |
| icache_if_ifdp_tag_data1 | 29 | - |
| icache_if_ipb_tag_data0 | 29 | - |
| icache_if_ipb_tag_data1 | 29 | - |
| icache_ifu_data_array0_dout | 128 | - |
| icache_ifu_data_array1_dout | 128 | - |
| icache_ifu_predecd_array0_dout | 32 | - |
| icache_ifu_predecd_array1_dout | 32 | - |
| icache_ifu_tag_dout | 59 | - |
| icache_index_sel | 4 | - |
| icache_read_req | 1 | - |
| icache_req_higher | 1 | - |

*注：共105个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：指令缓存接口模块
- 所属单元：取指单元(IFU)
- 接口数量：输入41个，输出15个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
