# ct_biu_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_biu_top |
| 文件路径 | biu/rtl/ct_biu_top.v |
| 功能描述 | 总线接口单元 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| coreclk | input | 1 | |
| cp0_biu_icg_en | input | 1 | |
| cp0_biu_lpmd_b | input | 2 | |
| cp0_biu_op | input | 16 | |
| cp0_biu_sel | input | 1 | |
| cp0_biu_wdata | input | 64 | |
| cpurst_b | input | 1 | |
| forever_coreclk | input | 1 | |
| had_biu_jdb_pm | input | 2 | |
| hpcp_biu_cnt_en | input | 4 | |
| hpcp_biu_op | input | 16 | |
| hpcp_biu_sel | input | 1 | |
| hpcp_biu_wdata | input | 64 | |
| ifu_biu_r_ready | input | 1 | |
| ifu_biu_rd_addr | input | 40 | |
| ifu_biu_rd_burst | input | 2 | |
| ifu_biu_rd_cache | input | 4 | |
| ifu_biu_rd_domain | input | 2 | |
| ifu_biu_rd_id | input | 1 | |
| ifu_biu_rd_len | input | 2 | |
| ... | ... | ... | 共126个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_cp0_apb_base | output | 40 | |
| biu_cp0_cmplt | output | 1 | |
| biu_cp0_coreid | output | 3 | |
| biu_cp0_me_int | output | 1 | |
| biu_cp0_ms_int | output | 1 | |
| biu_cp0_mt_int | output | 1 | |
| biu_cp0_rdata | output | 128 | |
| biu_cp0_rvba | output | 40 | |
| biu_cp0_se_int | output | 1 | |
| biu_cp0_ss_int | output | 1 | |
| biu_cp0_st_int | output | 1 | |
| biu_had_coreid | output | 2 | |
| biu_had_sdb_req_b | output | 1 | |
| biu_hpcp_cmplt | output | 1 | |
| biu_hpcp_l2of_int | output | 4 | |
| biu_hpcp_rdata | output | 128 | |
| biu_hpcp_time | output | 64 | |
| biu_ifu_rd_data | output | 128 | |
| biu_ifu_rd_data_vld | output | 1 | |
| biu_ifu_rd_grnt | output | 1 | |
| ... | ... | ... | 共98个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_biu_req_arbiter | x_ct_biu_req_arbiter |
| ct_biu_read_channel | x_ct_biu_read_channel |
| ct_biu_write_channel | x_ct_biu_write_channel |
| ct_biu_snoop_channel | x_ct_biu_snoop_channel |
| ct_biu_lowpower | x_ct_biu_lowpower |
| ct_biu_csr_req_arbiter | x_ct_biu_csr_req_arbiter |
| ct_biu_other_io_sync | x_ct_biu_other_io_sync |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
