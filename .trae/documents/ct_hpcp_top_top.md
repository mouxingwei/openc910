# ct_hpcp_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_hpcp_top |
| 文件路径 | pmu/rtl/ct_hpcp_top.v |
| 功能描述 | 性能计数器 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_hpcp_cmplt | input | 1 | |
| biu_hpcp_l2of_int | input | 4 | |
| biu_hpcp_rdata | input | 128 | |
| biu_hpcp_time | input | 64 | |
| cp0_hpcp_icg_en | input | 1 | |
| cp0_hpcp_index | input | 12 | |
| cp0_hpcp_int_disable | input | 1 | |
| cp0_hpcp_mcntwen | input | 32 | |
| cp0_hpcp_op | input | 4 | |
| cp0_hpcp_pmdm | input | 1 | |
| cp0_hpcp_pmds | input | 1 | |
| cp0_hpcp_pmdu | input | 1 | |
| cp0_hpcp_sel | input | 1 | |
| cp0_hpcp_src0 | input | 64 | |
| cp0_hpcp_wdata | input | 64 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_hpcp_backend_stall | input | 1 | |
| idu_hpcp_fence_sync_vld | input | 1 | |
| ... | ... | ... | 共108个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| hpcp_biu_cnt_en | output | 4 | |
| hpcp_biu_op | output | 16 | |
| hpcp_biu_sel | output | 1 | |
| hpcp_biu_wdata | output | 64 | |
| hpcp_cp0_cmplt | output | 1 | |
| hpcp_cp0_data | output | 64 | |
| hpcp_cp0_int_vld | output | 1 | |
| hpcp_cp0_sce | output | 1 | |
| hpcp_idu_cnt_en | output | 1 | |
| hpcp_ifu_cnt_en | output | 1 | |
| hpcp_lsu_cnt_en | output | 1 | |
| hpcp_mmu_cnt_en | output | 1 | |
| hpcp_rtu_cnt_en | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_hpcp_gated_clk |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_3 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_4 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_5 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_6 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_7 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_8 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_9 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_10 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_11 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_12 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_13 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_14 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_15 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_16 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_17 |
| ct_hpcp_adder_sel | x_ct_hpcp_adder_sel_18 |
| ct_hpcp_cntinten_reg | x_ct_hpcp_cntinten_0 |
| ct_hpcp_cntinten_reg | x_ct_hpcp_cntinten_2 |
| ct_hpcp_cntinten_reg | x_ct_hpcp_cntinten_3 |
| ... | 共113个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
