# ct_had_private_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_had_private_top |
| 文件路径 | had/rtl/ct_had_private_top.v |
| 功能描述 | 硬件调试 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_had_coreid | input | 2 | |
| biu_had_sdb_req_b | input | 1 | |
| cp0_had_cpuid_0 | input | 32 | |
| cp0_had_debug_info | input | 4 | |
| cp0_had_lpmd_b | input | 2 | |
| cp0_had_trace_pm_wdata | input | 2 | |
| cp0_had_trace_pm_wen | input | 1 | |
| cp0_yy_priv_mode | input | 2 | |
| cpuclk | input | 1 | |
| cpurst_b | input | 1 | |
| forever_coreclk | input | 1 | |
| idu_had_debug_info | input | 50 | |
| idu_had_id_inst0_info | input | 40 | |
| idu_had_id_inst0_vld | input | 1 | |
| idu_had_id_inst1_info | input | 40 | |
| idu_had_id_inst1_vld | input | 1 | |
| idu_had_id_inst2_info | input | 40 | |
| idu_had_id_inst2_vld | input | 1 | |
| idu_had_iq_empty | input | 1 | |
| idu_had_pipe_stall | input | 1 | |
| ... | ... | ... | 共105个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| had_biu_jdb_pm | output | 2 | |
| had_cp0_xx_dbg | output | 1 | |
| had_idu_debug_id_inst_en | output | 1 | |
| had_idu_wbbr_data | output | 64 | |
| had_idu_wbbr_vld | output | 1 | |
| had_ifu_ir | output | 32 | |
| had_ifu_ir_vld | output | 1 | |
| had_ifu_pc | output | 39 | |
| had_ifu_pcload | output | 1 | |
| had_lsu_bus_trace_en | output | 1 | |
| had_lsu_dbg_en | output | 1 | |
| had_rtu_data_bkpt_dbgreq | output | 1 | |
| had_rtu_dbg_disable | output | 1 | |
| had_rtu_dbg_req_en | output | 1 | |
| had_rtu_debug_retire_info_en | output | 1 | |
| had_rtu_event_dbgreq | output | 1 | |
| had_rtu_fdb | output | 1 | |
| had_rtu_hw_dbgreq | output | 1 | |
| had_rtu_hw_dbgreq_gateclk | output | 1 | |
| had_rtu_inst_bkpt_dbgreq | output | 1 | |
| ... | ... | ... | 共38个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_had_bkpt | x_ct_had_bkpta |
| ct_had_bkpt | x_ct_had_bkptb |
| ct_had_ctrl | x_ct_had_ctrl |
| ct_had_ddc_ctrl | x_ct_had_ddc_ctrl |
| ct_had_ddc_dp | x_ct_had_ddc_dp |
| ct_had_pcfifo | x_ct_had_pcfifo |
| ct_had_regs | x_ct_had_regs |
| ct_had_trace | x_ct_had_trace |
| ct_had_event | x_ct_had_event |
| ct_had_dbg_info | x_ct_had_dbg_info |
| ct_had_nirv_bkpt | x_ct_had_nirv_bkpt |
| ct_had_private_ir | x_ct_had_private_ir |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
