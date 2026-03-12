# ct_rtu_retire 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_retire |
| 文件路径 | rtu/rtl/ct_rtu_retire.v |
| 功能描述 | 退休单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | |
| cp0_rtu_srt_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_rtu_dbg_disable | input | 1 | |
| had_rtu_dbg_req_en | input | 1 | |
| had_rtu_event_dbgreq | input | 1 | |
| had_rtu_fdb | input | 1 | |
| had_rtu_hw_dbgreq | input | 1 | |
| had_rtu_hw_dbgreq_gateclk | input | 1 | |
| had_rtu_non_irv_bkpt_dbgreq | input | 1 | |
| had_rtu_pop1_disa | input | 1 | |
| had_rtu_trace_dbgreq | input | 1 | |
| had_rtu_trace_en | input | 1 | |
| had_rtu_xx_jdbreq | input | 1 | |
| had_yy_xx_exit_dbg | input | 1 | |
| hpcp_rtu_cnt_en | input | 1 | |
| lsu_rtu_all_commit_data_vld | input | 1 | |
| lsu_rtu_async_expt_addr | input | 40 | |
| lsu_rtu_async_expt_vld | input | 1 | |
| lsu_rtu_ctc_flush_vld | input | 1 | |
| mmu_xx_mmu_en | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pst_retire_retired_reg_wb | input | 1 | |
| rob_retire_commit0 | input | 1 | |
| rob_retire_commit1 | input | 1 | |
| rob_retire_commit2 | input | 1 | |
| rob_retire_ctc_flush_srt_en | input | 1 | |
| rob_retire_inst0_bht_mispred | input | 1 | |
| ... | ... | ... | 共139个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| retire_pst_async_flush | output | 1 | |
| retire_pst_wb_retire_inst0_ereg_vld | output | 1 | |
| retire_pst_wb_retire_inst0_preg_vld | output | 1 | |
| retire_pst_wb_retire_inst0_vreg_vld | output | 1 | |
| retire_pst_wb_retire_inst1_ereg_vld | output | 1 | |
| retire_pst_wb_retire_inst1_preg_vld | output | 1 | |
| retire_pst_wb_retire_inst1_vreg_vld | output | 1 | |
| retire_pst_wb_retire_inst2_ereg_vld | output | 1 | |
| retire_pst_wb_retire_inst2_preg_vld | output | 1 | |
| retire_pst_wb_retire_inst2_vreg_vld | output | 1 | |
| retire_rob_async_expt_commit_mask | output | 1 | |
| retire_rob_ctc_flush_req | output | 1 | |
| retire_rob_dbg_inst0_ack_int | output | 1 | |
| retire_rob_dbg_inst0_dbg_mode_on | output | 1 | |
| retire_rob_dbg_inst0_expt_vld | output | 1 | |
| retire_rob_dbg_inst0_flush | output | 1 | |
| retire_rob_dbg_inst0_mispred | output | 1 | |
| retire_rob_flush | output | 1 | |
| retire_rob_flush_cur_state | output | 5 | |
| retire_rob_flush_gateclk | output | 1 | |
| retire_rob_inst0_jmp | output | 1 | |
| retire_rob_inst1_jmp | output | 1 | |
| retire_rob_inst2_jmp | output | 1 | |
| retire_rob_inst_flush | output | 1 | |
| retire_rob_retire_empty | output | 1 | |
| retire_rob_rt_mask | output | 1 | |
| retire_rob_split_fof_flush | output | 1 | |
| retire_rob_srt_en | output | 1 | |
| retire_top_ae_cur_state | output | 2 | |
| rtu_cp0_epc | output | 64 | |
| ... | ... | ... | 共171个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_retire_gated_clk |
| gated_clk_cell | x_sm_gated_clk |
| gated_clk_cell | x_hpcp_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
