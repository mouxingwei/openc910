# ct_core 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_core |
| 文件路径 | cpu/rtl/ct_core.v |
| 功能描述 | 处理器核心 |

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
| biu_ifu_rd_data | input | 128 | |
| biu_ifu_rd_data_vld | input | 1 | |
| biu_ifu_rd_grnt | input | 1 | |
| biu_ifu_rd_id | input | 1 | |
| biu_ifu_rd_last | input | 1 | |
| biu_ifu_rd_resp | input | 2 | |
| biu_lsu_ac_addr | input | 40 | |
| biu_lsu_ac_prot | input | 3 | |
| biu_lsu_ac_req | input | 1 | |
| ... | ... | ... | 共130个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_biu_icg_en | output | 1 | |
| cp0_biu_lpmd_b | output | 2 | |
| cp0_biu_op | output | 16 | |
| cp0_biu_sel | output | 1 | |
| cp0_biu_wdata | output | 64 | |
| cp0_had_cpuid_0 | output | 32 | |
| cp0_had_debug_info | output | 4 | |
| cp0_had_lpmd_b | output | 2 | |
| cp0_had_trace_pm_wdata | output | 2 | |
| cp0_had_trace_pm_wen | output | 1 | |
| cp0_hpcp_icg_en | output | 1 | |
| cp0_hpcp_index | output | 12 | |
| cp0_hpcp_int_disable | output | 1 | |
| cp0_hpcp_mcntwen | output | 32 | |
| cp0_hpcp_op | output | 4 | |
| cp0_hpcp_pmdm | output | 1 | |
| cp0_hpcp_pmds | output | 1 | |
| cp0_hpcp_pmdu | output | 1 | |
| cp0_hpcp_sel | output | 1 | |
| cp0_hpcp_src0 | output | 64 | |
| ... | ... | ... | 共328个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_ifu_top | x_ct_ifu_top |
| ct_idu_top | x_ct_idu_top |
| ct_iu_top | x_ct_iu_top |
| ct_vfpu_top | x_ct_vfpu_top |
| ct_lsu_top | x_ct_lsu_top |
| ct_cp0_top | x_ct_cp0_top |
| ct_rtu_top | x_ct_rtu_top |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
