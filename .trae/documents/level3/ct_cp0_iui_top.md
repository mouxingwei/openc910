# ct_cp0_iui 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_cp0_iui |
| 文件路径 | cp0/rtl/ct_cp0_iui.v |
| 功能描述 | CP0接口 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_cp0_cmplt | input | 1 | |
| biu_cp0_rdata | input | 128 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| hpcp_cp0_cmplt | input | 1 | |
| hpcp_cp0_data | input | 64 | |
| idu_cp0_rf_func | input | 5 | |
| idu_cp0_rf_gateclk_sel | input | 1 | |
| idu_cp0_rf_iid | input | 7 | |
| idu_cp0_rf_opcode | input | 32 | |
| idu_cp0_rf_preg | input | 7 | |
| idu_cp0_rf_sel | input | 1 | |
| idu_cp0_rf_src0 | input | 64 | |
| ifu_cp0_icache_inv_done | input | 1 | |
| ifu_cp0_rst_inv_req | input | 1 | |
| lpmd_cmplt | input | 1 | |
| lsu_cp0_dcache_done | input | 1 | |
| mmu_cp0_cmplt | input | 1 | |
| mmu_cp0_tlb_done | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| regs_iui_cfr_no_op | input | 1 | |
| regs_iui_chk_vld | input | 1 | |
| regs_iui_cindex_l2 | input | 1 | |
| regs_iui_cins_no_op | input | 1 | |
| regs_iui_cskyee | input | 1 | |
| regs_iui_data_out | input | 64 | |
| regs_iui_dca_sel | input | 1 | |
| regs_iui_fs_off | input | 1 | |
| regs_iui_hpcp_regs_sel | input | 1 | |
| ... | ... | ... | 共50个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_biu_op | output | 16 | |
| cp0_biu_sel | output | 1 | |
| cp0_biu_wdata | output | 64 | |
| cp0_hpcp_op | output | 4 | |
| cp0_hpcp_sel | output | 1 | |
| cp0_hpcp_src0 | output | 64 | |
| cp0_ifu_rst_inv_done | output | 1 | |
| cp0_iu_ex3_abnormal | output | 1 | |
| cp0_iu_ex3_expt_vec | output | 5 | |
| cp0_iu_ex3_expt_vld | output | 1 | |
| cp0_iu_ex3_flush | output | 1 | |
| cp0_iu_ex3_iid | output | 7 | |
| cp0_iu_ex3_inst_vld | output | 1 | |
| cp0_iu_ex3_mtval | output | 32 | |
| cp0_iu_ex3_rslt_data | output | 64 | |
| cp0_iu_ex3_rslt_preg | output | 7 | |
| cp0_iu_ex3_rslt_vld | output | 1 | |
| cp0_mmu_tlb_all_inv | output | 1 | |
| cp0_mret | output | 1 | |
| cp0_rtu_xx_int_b | output | 1 | |
| cp0_rtu_xx_vec | output | 5 | |
| cp0_sret | output | 1 | |
| inst_lpmd_ex1_ex2 | output | 1 | |
| iui_regs_addr | output | 12 | |
| iui_regs_csr_wr | output | 1 | |
| iui_regs_csrw | output | 1 | |
| iui_regs_ex3_inst_csr | output | 1 | |
| iui_regs_inst_mret | output | 1 | |
| iui_regs_inst_sret | output | 1 | |
| iui_regs_inv_expt | output | 1 | |
| ... | ... | ... | 共37个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_iui_gated_clk |
| no | operation |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
