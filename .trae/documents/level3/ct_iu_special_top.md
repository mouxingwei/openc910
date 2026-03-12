# ct_iu_special 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_iu_special |
| 文件路径 | iu/rtl/ct_iu_special.v |
| 功能描述 | 特殊操作单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bju_special_pc | input | 40 | |
| cp0_iu_icg_en | input | 1 | |
| cp0_iu_vill | input | 1 | |
| cp0_iu_vl | input | 8 | |
| cp0_iu_vsetvli_pre_decd_disable | input | 1 | |
| cp0_iu_vstart | input | 7 | |
| cp0_yy_clk_en | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| idu_iu_rf_pipe0_dst_preg | input | 7 | |
| idu_iu_rf_pipe0_expt_vec | input | 5 | |
| idu_iu_rf_pipe0_expt_vld | input | 1 | |
| idu_iu_rf_pipe0_func | input | 5 | |
| idu_iu_rf_pipe0_high_hw_expt | input | 1 | |
| idu_iu_rf_pipe0_iid | input | 7 | |
| idu_iu_rf_pipe0_opcode | input | 32 | |
| idu_iu_rf_pipe0_special_imm | input | 20 | |
| idu_iu_rf_pipe0_src0 | input | 64 | |
| idu_iu_rf_pipe0_src1_no_imm | input | 64 | |
| idu_iu_rf_pipe0_vl | input | 8 | |
| idu_iu_rf_special_gateclk_sel | input | 1 | |
| idu_iu_rf_special_sel | input | 1 | |
| mmu_xx_mmu_en | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| rtu_yy_xx_flush | input | 1 | |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| special_cbus_ex1_abnormal | output | 1 | |
| special_cbus_ex1_bkpt | output | 1 | |
| special_cbus_ex1_expt_vec | output | 5 | |
| special_cbus_ex1_expt_vld | output | 1 | |
| special_cbus_ex1_flush | output | 1 | |
| special_cbus_ex1_high_hw_expt | output | 1 | |
| special_cbus_ex1_iid | output | 7 | |
| special_cbus_ex1_immu_expt | output | 1 | |
| special_cbus_ex1_inst_gateclk_vld | output | 1 | |
| special_cbus_ex1_inst_vld | output | 1 | |
| special_cbus_ex1_mtval | output | 32 | |
| special_cbus_ex1_vsetvl | output | 1 | |
| special_cbus_ex1_vstart | output | 7 | |
| special_cbus_ex1_vstart_vld | output | 1 | |
| special_rbus_ex1_data | output | 64 | |
| special_rbus_ex1_data_vld | output | 1 | |
| special_rbus_ex1_preg | output | 7 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_ex1_ctrl_gated_clk |
| gated_clk_cell | x_ex1_inst_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
