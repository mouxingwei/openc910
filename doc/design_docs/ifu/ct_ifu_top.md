# ct_ifu_top 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_top |
| 文件名称 | ct_ifu_top.v |
| 功能描述 | 取指单元顶层模块，负责指令获取的整体控制 |

### 1.2 功能描述

取指单元顶层模块，负责指令获取的整体控制。该模块是OpenC910处理器取指单元(IFU)的组成部分。

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
| cp0_idu_cskyee | input | 1 | - |
| cp0_idu_frm | input | 3 | - |
| cp0_idu_fs | input | 2 | - |
| cp0_ifu_bht_en | input | 1 | - |
| cp0_ifu_bht_inv | input | 1 | - |
| cp0_ifu_btb_en | input | 1 | - |
| cp0_ifu_btb_inv | input | 1 | - |
| cp0_ifu_icache_en | input | 1 | - |
| cp0_ifu_icache_inv | input | 1 | - |
| cp0_ifu_icache_pref_en | input | 1 | - |
| cp0_ifu_icache_read_index | input | 17 | - |
| cp0_ifu_icache_read_req | input | 1 | - |
| cp0_ifu_icache_read_tag | input | 1 | - |
| cp0_ifu_icache_read_way | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_ind_btb_en | input | 1 | - |
| cp0_ifu_ind_btb_inv | input | 1 | - |
| cp0_ifu_insde | input | 1 | - |
| cp0_ifu_iwpe | input | 1 | - |
| cp0_ifu_l0btb_en | input | 1 | - |
| cp0_ifu_lbuf_en | input | 1 | - |
| cp0_ifu_no_op_req | input | 1 | - |
| cp0_ifu_nsfe | input | 1 | - |
| cp0_ifu_ras_en | input | 1 | - |
| cp0_ifu_rst_inv_done | input | 1 | - |
| cp0_ifu_rvbr | input | 40 | - |
| cp0_ifu_vbr | input | 40 | - |
| cp0_ifu_vl | input | 8 | - |
| cp0_ifu_vlmul | input | 2 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| cp0_ifu_vsetvli_pred_mode | input | 1 | - |
| cp0_ifu_vsew | input | 3 | - |
| cp0_yy_clk_en | input | 1 | - |
| cp0_yy_priv_mode | input | 2 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_ifu_ir | input | 32 | - |
| had_ifu_ir_vld | input | 1 | - |
| had_ifu_pc | input | 39 | - |
| had_ifu_pcload | input | 1 | - |
| had_rtu_xx_jdbreq | input | 1 | - |
| had_yy_xx_bkpta_base | input | 40 | - |
| had_yy_xx_bkpta_mask | input | 8 | - |
| had_yy_xx_bkpta_rc | input | 1 | - |

*注：共133个输入端口，此处仅显示前50个*

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
| ifu_cp0_bht_inv_done | output | 1 | - |
| ifu_cp0_btb_inv_done | output | 1 | - |
| ifu_cp0_icache_inv_done | output | 1 | - |
| ifu_cp0_icache_read_data | output | 128 | - |
| ifu_cp0_icache_read_data_vld | output | 1 | - |
| ifu_cp0_ind_btb_inv_done | output | 1 | - |
| ifu_cp0_rst_inv_req | output | 1 | - |
| ifu_had_debug_info | output | 83 | - |
| ifu_had_no_inst | output | 1 | - |
| ifu_had_no_op | output | 1 | - |
| ifu_had_reset_on | output | 1 | - |
| ifu_hpcp_btb_inst | output | 1 | - |
| ifu_hpcp_btb_mispred | output | 1 | - |
| ifu_hpcp_frontend_stall | output | 1 | - |
| ifu_hpcp_icache_access | output | 1 | - |
| ifu_hpcp_icache_miss | output | 1 | - |
| ifu_idu_ib_inst0_data | output | 73 | - |
| ifu_idu_ib_inst0_vld | output | 1 | - |
| ifu_idu_ib_inst1_data | output | 73 | - |
| ifu_idu_ib_inst1_vld | output | 1 | - |
| ifu_idu_ib_inst2_data | output | 73 | - |
| ifu_idu_ib_inst2_vld | output | 1 | - |
| ifu_idu_ib_pipedown_gateclk | output | 1 | - |
| ifu_iu_pcfifo_create0_bht_pred | output | 1 | - |
| ifu_iu_pcfifo_create0_chk_idx | output | 25 | - |
| ifu_iu_pcfifo_create0_cur_pc | output | 40 | - |
| ifu_iu_pcfifo_create0_dst_vld | output | 1 | - |
| ifu_iu_pcfifo_create0_en | output | 1 | - |
| ifu_iu_pcfifo_create0_gateclk_en | output | 1 | - |
| ifu_iu_pcfifo_create0_jal | output | 1 | - |
| ifu_iu_pcfifo_create0_jalr | output | 1 | - |
| ifu_iu_pcfifo_create0_jmp_mispred | output | 1 | - |
| ifu_iu_pcfifo_create0_tar_pc | output | 40 | - |
| ifu_iu_pcfifo_create1_bht_pred | output | 1 | - |
| ifu_iu_pcfifo_create1_chk_idx | output | 25 | - |
| ifu_iu_pcfifo_create1_cur_pc | output | 40 | - |
| ifu_iu_pcfifo_create1_dst_vld | output | 1 | - |

*注：共64个输出端口，此处仅显示前50个*

## 3. 内部信号列表

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_btb_index | 10 | - |
| addrgen_btb_tag | 10 | - |
| addrgen_btb_target_pc | 20 | - |
| addrgen_btb_update_vld | 1 | - |
| addrgen_ibctrl_cancel | 1 | - |
| addrgen_ipdp_chgflw_vl | 8 | - |
| addrgen_ipdp_chgflw_vlmul | 2 | - |
| addrgen_ipdp_chgflw_vsew | 3 | - |
| addrgen_l0_btb_update_entry | 16 | - |
| addrgen_l0_btb_update_vld | 1 | - |
| addrgen_l0_btb_update_vld_bit | 1 | - |
| addrgen_l0_btb_wen | 4 | - |
| addrgen_pcgen_pc | 39 | - |
| addrgen_pcgen_pcload | 1 | - |
| addrgen_xx_pcload | 1 | - |
| bht_ifctrl_inv_done | 1 | - |
| bht_ifctrl_inv_on | 1 | - |
| bht_ind_btb_rtu_ghr | 8 | - |
| bht_ind_btb_vghr | 8 | - |
| bht_ipdp_pre_array_data_ntake | 32 | - |
| bht_ipdp_pre_array_data_taken | 32 | - |
| bht_ipdp_pre_offset_onehot | 16 | - |
| bht_ipdp_sel_array_result | 2 | - |
| bht_ipdp_vghr | 22 | - |
| bht_lbuf_pre_ntaken_result | 32 | - |
| bht_lbuf_pre_taken_result | 32 | - |
| bht_lbuf_vghr | 22 | - |
| biu_ifu_rd_data | 128 | - |
| biu_ifu_rd_data_vld | 1 | - |
| biu_ifu_rd_grnt | 1 | - |

*注：共1294个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：取指单元顶层模块，负责指令获取的整体控制
- 所属单元：取指单元(IFU)
- 接口数量：输入133个，输出64个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
