# ct_rtu_rob 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_rob |
| 文件路径 | rtu/rtl/ct_rtu_rob.v |
| 功能描述 | 重排序缓冲 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | |
| cp0_rtu_xx_int_b | input | 1 | |
| cp0_rtu_xx_vec | input | 5 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| had_rtu_data_bkpt_dbgreq | input | 1 | |
| had_rtu_dbg_req_en | input | 1 | |
| had_rtu_debug_retire_info_en | input | 1 | |
| had_rtu_inst_bkpt_dbgreq | input | 1 | |
| had_rtu_xx_tme | input | 1 | |
| hpcp_rtu_cnt_en | input | 1 | |
| idu_rtu_fence_idle | input | 1 | |
| idu_rtu_rob_create0_data | input | 40 | |
| idu_rtu_rob_create0_dp_en | input | 1 | |
| idu_rtu_rob_create0_en | input | 1 | |
| idu_rtu_rob_create0_gateclk_en | input | 1 | |
| idu_rtu_rob_create1_data | input | 40 | |
| idu_rtu_rob_create1_dp_en | input | 1 | |
| idu_rtu_rob_create1_en | input | 1 | |
| idu_rtu_rob_create1_gateclk_en | input | 1 | |
| idu_rtu_rob_create2_data | input | 40 | |
| idu_rtu_rob_create2_dp_en | input | 1 | |
| idu_rtu_rob_create2_en | input | 1 | |
| idu_rtu_rob_create2_gateclk_en | input | 1 | |
| idu_rtu_rob_create3_data | input | 40 | |
| idu_rtu_rob_create3_dp_en | input | 1 | |
| idu_rtu_rob_create3_en | input | 1 | |
| idu_rtu_rob_create3_gateclk_en | input | 1 | |
| ifu_rtu_cur_pc | input | 39 | |
| ... | ... | ... | 共116个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| rob_pst_retire_inst0_gateclk_vld | output | 1 | |
| rob_pst_retire_inst0_iid | output | 7 | |
| rob_pst_retire_inst0_iid_updt_val | output | 7 | |
| rob_pst_retire_inst1_gateclk_vld | output | 1 | |
| rob_pst_retire_inst1_iid | output | 7 | |
| rob_pst_retire_inst1_iid_updt_val | output | 7 | |
| rob_pst_retire_inst2_gateclk_vld | output | 1 | |
| rob_pst_retire_inst2_iid | output | 7 | |
| rob_pst_retire_inst2_iid_updt_val | output | 7 | |
| rob_retire_commit0 | output | 1 | |
| rob_retire_commit1 | output | 1 | |
| rob_retire_commit2 | output | 1 | |
| rob_retire_ctc_flush_srt_en | output | 1 | |
| rob_retire_inst0_bht_mispred | output | 1 | |
| rob_retire_inst0_bju | output | 1 | |
| rob_retire_inst0_bju_inc_pc | output | 39 | |
| rob_retire_inst0_bkpt | output | 1 | |
| rob_retire_inst0_chk_idx | output | 8 | |
| rob_retire_inst0_condbr | output | 1 | |
| rob_retire_inst0_condbr_taken | output | 1 | |
| rob_retire_inst0_ctc_flush | output | 1 | |
| rob_retire_inst0_cur_pc | output | 39 | |
| rob_retire_inst0_data_bkpt | output | 1 | |
| rob_retire_inst0_dbg_disable | output | 1 | |
| rob_retire_inst0_efpc_vld | output | 1 | |
| rob_retire_inst0_expt_vec | output | 4 | |
| rob_retire_inst0_expt_vld | output | 1 | |
| rob_retire_inst0_fp_dirty | output | 1 | |
| rob_retire_inst0_high_hw_expt | output | 1 | |
| rob_retire_inst0_iid | output | 7 | |
| ... | ... | ... | 共187个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_rtu_rob_entry | x_ct_rtu_rob_entry0 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry1 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry2 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry3 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry4 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry5 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry6 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry7 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry8 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry9 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry10 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry11 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry12 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry13 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry14 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry15 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry16 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry17 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry18 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry19 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry20 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry21 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry22 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry23 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry24 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry25 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry26 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry27 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry28 |
| ct_rtu_rob_entry | x_ct_rtu_rob_entry29 |
| ... | 共85个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
