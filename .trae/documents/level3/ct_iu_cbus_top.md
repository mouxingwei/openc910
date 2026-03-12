# ct_iu_cbus 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_cbus |
| 文件路径 | iu/rtl/ct_iu_cbus.v |
| 功能描述 | C总线接口 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bju_cbus_ex2_pipe2_abnormal | input | 1 | |
| bju_cbus_ex2_pipe2_bht_mispred | input | 1 | |
| bju_cbus_ex2_pipe2_iid | input | 7 | |
| bju_cbus_ex2_pipe2_jmp_mispred | input | 1 | |
| bju_cbus_ex2_pipe2_sel | input | 1 | |
| cp0_iu_ex3_abnormal | input | 1 | |
| cp0_iu_ex3_efpc | input | 39 | |
| cp0_iu_ex3_efpc_vld | input | 1 | |
| cp0_iu_ex3_expt_vec | input | 5 | |
| cp0_iu_ex3_expt_vld | input | 1 | |
| cp0_iu_ex3_flush | input | 1 | |
| cp0_iu_ex3_iid | input | 7 | |
| cp0_iu_ex3_inst_vld | input | 1 | |
| cp0_iu_ex3_mtval | input | 32 | |
| cp0_iu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_iu_rf_div_sel | input | 1 | |
| idu_iu_rf_mult_sel | input | 1 | |
| idu_iu_rf_pipe0_cbus_gateclk_sel | input | 1 | |
| idu_iu_rf_pipe0_iid | input | 7 | |
| idu_iu_rf_pipe0_sel | input | 1 | |
| idu_iu_rf_pipe1_cbus_gateclk_sel | input | 1 | |
| idu_iu_rf_pipe1_iid | input | 7 | |
| idu_iu_rf_pipe1_sel | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |
| special_cbus_ex1_abnormal | input | 1 | |
| special_cbus_ex1_bkpt | input | 1 | |
| ... | ... | ... | 共42个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| iu_rtu_pipe0_abnormal | output | 1 | |
| iu_rtu_pipe0_bkpt | output | 1 | |
| iu_rtu_pipe0_cmplt | output | 1 | |
| iu_rtu_pipe0_efpc | output | 39 | |
| iu_rtu_pipe0_efpc_vld | output | 1 | |
| iu_rtu_pipe0_expt_vec | output | 5 | |
| iu_rtu_pipe0_expt_vld | output | 1 | |
| iu_rtu_pipe0_flush | output | 1 | |
| iu_rtu_pipe0_high_hw_expt | output | 1 | |
| iu_rtu_pipe0_iid | output | 7 | |
| iu_rtu_pipe0_immu_expt | output | 1 | |
| iu_rtu_pipe0_mtval | output | 32 | |
| iu_rtu_pipe0_vsetvl | output | 1 | |
| iu_rtu_pipe0_vstart | output | 7 | |
| iu_rtu_pipe0_vstart_vld | output | 1 | |
| iu_rtu_pipe1_cmplt | output | 1 | |
| iu_rtu_pipe1_iid | output | 7 | |
| iu_rtu_pipe2_abnormal | output | 1 | |
| iu_rtu_pipe2_bht_mispred | output | 1 | |
| iu_rtu_pipe2_cmplt | output | 1 | |
| iu_rtu_pipe2_iid | output | 7 | |
| iu_rtu_pipe2_jmp_mispred | output | 1 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_inst_vld_gated_clk |
| gated_clk_cell | x_pipe0_data_gated_clk |
| gated_clk_cell | x_pipe0_abnormal_gated_clk |
| gated_clk_cell | x_pipe1_data_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
