# ct_lsu_lm 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_lm |
| 文件路径 | lsu/rtl/ct_lsu_lm.v |
| 功能描述 | 本地存储 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_r_id | input | 5 | |
| biu_lsu_r_resp | input | 4 | |
| biu_lsu_r_vld | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| ld_ag_dc_access_size | input | 3 | |
| ld_ag_lm_init_vld | input | 1 | |
| ld_ag_lr_inst | input | 1 | |
| ld_ag_pa | input | 40 | |
| ld_da_idx | input | 8 | |
| ld_da_lm_discard_grnt | input | 1 | |
| ld_da_lm_ecc_err | input | 1 | |
| ld_da_lm_no_req | input | 1 | |
| ld_da_lm_vector_nop | input | 1 | |
| mmu_lsu_buf0 | input | 1 | |
| mmu_lsu_ca0 | input | 1 | |
| mmu_lsu_sec0 | input | 1 | |
| mmu_lsu_sh0 | input | 1 | |
| mmu_lsu_so0 | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pfu_biu_req_addr | input | 40 | |
| rb_lm_ar_id | input | 5 | |
| rb_lm_atomic_next_resp | input | 1 | |
| rb_lm_wait_resp_dp_vld | input | 1 | |
| rb_lm_wait_resp_vld | input | 1 | |
| rtu_lsu_async_flush | input | 1 | |
| rtu_lsu_eret_flush | input | 1 | |
| rtu_lsu_expt_flush | input | 1 | |
| ... | ... | ... | 共40个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| lm_addr_pa | output | 28 | |
| lm_already_snoop | output | 1 | |
| lm_ld_da_hit_idx | output | 1 | |
| lm_lfb_depd_wakeup | output | 1 | |
| lm_page_buf | output | 1 | |
| lm_page_ca | output | 1 | |
| lm_page_sec | output | 1 | |
| lm_page_share | output | 1 | |
| lm_page_so | output | 1 | |
| lm_pfu_biu_req_hit_idx | output | 1 | |
| lm_snq_stall | output | 1 | |
| lm_sq_sc_fail | output | 1 | |
| lm_st_da_hit_idx | output | 1 | |
| lm_state_is_amo_lock | output | 1 | |
| lm_state_is_ex_wait_lock | output | 1 | |
| lm_state_is_idle | output | 1 | |
| lsu_had_lm_state | output | 3 | |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_lm_gated_clk |
| gated_clk_cell | x_lsu_lm_init_gated_clk |
| ecc | err |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
