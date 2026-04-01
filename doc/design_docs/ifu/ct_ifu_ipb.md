# ct_ifu_ipb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipb |
| 文件名称 | ct_ifu_ipb.v |
| 功能描述 | 指令预取缓冲模块 |

### 1.2 功能描述

指令预取缓冲模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_ifu_rd_data | input | 128 | - |
| biu_ifu_rd_data_vld | input | 1 | - |
| biu_ifu_rd_grnt | input | 1 | - |
| biu_ifu_rd_id | input | 1 | - |
| biu_ifu_rd_last | input | 1 | - |
| biu_ifu_rd_resp | input | 2 | - |
| cp0_ifu_icache_pref_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_insde | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| icache_if_ipb_tag_data0 | input | 29 | - |
| icache_if_ipb_tag_data1 | input | 29 | - |
| ifctrl_ipb_inv_on | input | 1 | - |
| ifu_no_op_req | input | 1 | - |
| l1_refill_ipb_bufferable | input | 1 | - |
| l1_refill_ipb_cacheable | input | 1 | - |
| l1_refill_ipb_ctc_inv | input | 1 | - |
| l1_refill_ipb_machine_mode | input | 1 | - |
| l1_refill_ipb_ppc | input | 40 | - |
| l1_refill_ipb_pre_cancel | input | 1 | - |
| l1_refill_ipb_refill_on | input | 1 | - |
| l1_refill_ipb_req | input | 1 | - |
| l1_refill_ipb_req_for_gateclk | input | 1 | - |
| l1_refill_ipb_req_pre | input | 1 | - |
| l1_refill_ipb_secure | input | 1 | - |
| l1_refill_ipb_supv_mode | input | 1 | - |
| l1_refill_ipb_tsize | input | 1 | - |
| l1_refill_ipb_vpc | input | 40 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| pcgen_ipb_chgflw | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_biu_r_ready | output | 1 | - |
| ifu_biu_rd_addr | output | 40 | - |
| ifu_biu_rd_burst | output | 2 | - |
| ifu_biu_rd_cache | output | 4 | - |
| ifu_biu_rd_domain | output | 2 | - |
| ifu_biu_rd_id | output | 1 | - |
| ifu_biu_rd_len | output | 2 | - |
| ifu_biu_rd_prot | output | 3 | - |
| ifu_biu_rd_req | output | 1 | - |
| ifu_biu_rd_req_gate | output | 1 | - |
| ifu_biu_rd_size | output | 3 | - |
| ifu_biu_rd_snoop | output | 4 | - |
| ifu_biu_rd_user | output | 2 | - |
| ipb_debug_req_cur_st | output | 4 | - |
| ipb_debug_wb_cur_st | output | 3 | - |
| ipb_icache_if_index | output | 34 | - |
| ipb_icache_if_req | output | 1 | - |
| ipb_icache_if_req_for_gateclk | output | 1 | - |
| ipb_ifctrl_prefetch_idle | output | 1 | - |
| ipb_l1_refill_data_vld | output | 1 | - |
| ipb_l1_refill_grnt | output | 1 | - |
| ipb_l1_refill_rdata | output | 128 | - |
| ipb_l1_refill_trans_err | output | 1 | - |

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |
| IDLE | 1 | 4'b0000,
          CACHE  = 4'b0001,
          CMP    = 4'b0011,
          PF_REQ = 4'b0010,
          PF0    = 4'b0110,
          PF1    = 4'b0111,
          PF2    = 4'b0101,
          PF3    = 4'b0100,
          INV    = 4'b1000 | - |
| PF_IDLE | 1 | 3'b000,
          PF_VLD  = 3'b001,  
          PF_GRNT = 3'b011,
          PF_WB0  = 3'b110,  
          PF_WB1  = 3'b111,
          PF_WB2  = 3'b101,
          PF_WB3  = 3'b100 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| icache_if_req | 1 | - |
| icache_inv_record | 1 | - |
| icache_tag_data0_reg | 29 | - |
| icache_tag_data1_reg | 29 | - |
| ipb_icache_if_index | 34 | - |
| pbuf_entry0 | 128 | - |
| pbuf_entry1 | 128 | - |
| pbuf_entry2 | 128 | - |
| pbuf_entry3 | 128 | - |
| pref_bufferable | 1 | - |
| pref_cacheable | 1 | - |
| pref_line_addr | 34 | - |
| pref_line_offset | 2 | - |
| pref_machine_mode | 1 | - |
| pref_secure | 1 | - |
| pref_supv_mode | 1 | - |
| req_cur_st | 4 | - |
| req_gate | 1 | - |
| req_nxt_st | 4 | - |
| wb_cur_st | 3 | - |
| wb_nxt_st | 3 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| biu_ifu_rd_data | 128 | - |
| biu_ifu_rd_data_vld | 1 | - |
| biu_ifu_rd_grnt | 1 | - |
| biu_ifu_rd_id | 1 | - |
| biu_ifu_rd_last | 1 | - |
| biu_ifu_rd_resp | 2 | - |
| biu_pref_data_vld | 1 | - |
| biu_pref_grnt | 1 | - |
| biu_pref_last | 1 | - |
| biu_pref_trans_err | 1 | - |
| biu_ref_data_vld | 1 | - |
| biu_ref_grnt | 1 | - |
| biu_ref_trans_err | 1 | - |
| cp0_ifu_icache_pref_en | 1 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_insde | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cpurst_b | 1 | - |
| forever_cpuclk | 1 | - |
| icache_flop_clk | 1 | - |
| icache_flop_clk_en | 1 | - |
| icache_if_ipb_tag_data0 | 29 | - |
| icache_if_ipb_tag_data1 | 29 | - |
| icache_inv_for_pref | 1 | - |
| ifctrl_ipb_inv_on | 1 | - |
| ifu_biu_r_ready | 1 | - |
| ifu_biu_rd_addr | 40 | - |
| ifu_biu_rd_burst | 2 | - |
| ifu_biu_rd_cache | 4 | - |
| ifu_biu_rd_domain | 2 | - |

*注：共126个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：指令预取缓冲模块
- 所属单元：取指单元(IFU)
- 接口数量：输入32个，输出23个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
