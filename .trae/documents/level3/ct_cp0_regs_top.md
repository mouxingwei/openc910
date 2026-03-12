# ct_cp0_regs 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_cp0_regs |
| 文件路径 | cp0/rtl/ct_cp0_regs.v |
| 功能描述 | CP0寄存器 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_cp0_apb_base | input | 40 | |
| biu_cp0_cmplt | input | 1 | |
| biu_cp0_coreid | input | 3 | |
| biu_cp0_me_int | input | 1 | |
| biu_cp0_ms_int | input | 1 | |
| biu_cp0_mt_int | input | 1 | |
| biu_cp0_rdata | input | 128 | |
| biu_cp0_rvba | input | 40 | |
| biu_cp0_se_int | input | 1 | |
| biu_cp0_ss_int | input | 1 | |
| biu_cp0_st_int | input | 1 | |
| cp0_mret | input | 1 | |
| cp0_sret | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| hpcp_cp0_data | input | 64 | |
| hpcp_cp0_int_vld | input | 1 | |
| hpcp_cp0_sce | input | 1 | |
| idu_cp0_fesr_acc_updt_val | input | 7 | |
| idu_cp0_fesr_acc_updt_vld | input | 1 | |
| ifu_cp0_bht_inv_done | input | 1 | |
| ifu_cp0_btb_inv_done | input | 1 | |
| ifu_cp0_icache_inv_done | input | 1 | |
| ifu_cp0_icache_read_data | input | 128 | |
| ifu_cp0_icache_read_data_vld | input | 1 | |
| ifu_cp0_ind_btb_inv_done | input | 1 | |
| ifu_cp0_rst_inv_req | input | 1 | |
| iui_regs_addr | input | 12 | |
| iui_regs_csr_wr | input | 1 | |
| ... | ... | ... | 共65个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_biu_icg_en | output | 1 | |
| cp0_had_cpuid_0 | output | 32 | |
| cp0_had_trace_pm_wdata | output | 2 | |
| cp0_had_trace_pm_wen | output | 1 | |
| cp0_hpcp_icg_en | output | 1 | |
| cp0_hpcp_index | output | 12 | |
| cp0_hpcp_int_disable | output | 1 | |
| cp0_hpcp_mcntwen | output | 32 | |
| cp0_hpcp_pmdm | output | 1 | |
| cp0_hpcp_pmds | output | 1 | |
| cp0_hpcp_pmdu | output | 1 | |
| cp0_hpcp_wdata | output | 64 | |
| cp0_idu_cskyee | output | 1 | |
| cp0_idu_dlb_disable | output | 1 | |
| cp0_idu_frm | output | 3 | |
| cp0_idu_fs | output | 2 | |
| cp0_idu_icg_en | output | 1 | |
| cp0_idu_iq_bypass_disable | output | 1 | |
| cp0_idu_rob_fold_disable | output | 1 | |
| cp0_idu_src2_fwd_disable | output | 1 | |
| cp0_idu_srcv2_fwd_disable | output | 1 | |
| cp0_idu_vill | output | 1 | |
| cp0_idu_vs | output | 2 | |
| cp0_idu_vstart | output | 7 | |
| cp0_idu_zero_delay_move_disable | output | 1 | |
| cp0_ifu_bht_en | output | 1 | |
| cp0_ifu_bht_inv | output | 1 | |
| cp0_ifu_btb_en | output | 1 | |
| cp0_ifu_btb_inv | output | 1 | |
| cp0_ifu_icache_en | output | 1 | |
| ... | ... | ... | 共149个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_regs_gated_clk |
| gated_clk_cell | x_vec_gated_clk |
| gated_clk_cell | x_regs_flush_gated_clk |
| gated_clk_cell | x_cp0_cdata_gated_clk |
| RV64 | IMAFDC |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
