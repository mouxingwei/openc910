# ct_lsu_bus_arb 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_lsu_bus_arb |
| 文件路径 | lsu/rtl/ct_lsu_bus_arb.v |
| 功能描述 | 总线仲裁 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| biu_lsu_ar_ready | input | 1 | |
| biu_lsu_aw_vb_grnt | input | 1 | |
| biu_lsu_aw_wmb_grnt | input | 1 | |
| biu_lsu_w_vb_grnt | input | 1 | |
| biu_lsu_w_wmb_grnt | input | 1 | |
| cp0_lsu_icg_en | input | 1 | |
| cp0_yy_clk_en | input | 1 | |
| cpurst_b | input | 1 | |
| forever_cpuclk | input | 1 | |
| pad_yy_icg_scan_en | input | 1 | |
| pfu_biu_ar_addr | input | 40 | |
| pfu_biu_ar_bar | input | 2 | |
| pfu_biu_ar_burst | input | 2 | |
| pfu_biu_ar_cache | input | 4 | |
| pfu_biu_ar_domain | input | 2 | |
| pfu_biu_ar_dp_req | input | 1 | |
| pfu_biu_ar_id | input | 5 | |
| pfu_biu_ar_len | input | 2 | |
| pfu_biu_ar_lock | input | 1 | |
| pfu_biu_ar_prot | input | 3 | |
| pfu_biu_ar_req | input | 1 | |
| pfu_biu_ar_req_gateclk_en | input | 1 | |
| pfu_biu_ar_size | input | 3 | |
| pfu_biu_ar_snoop | input | 4 | |
| pfu_biu_ar_user | input | 3 | |
| rb_biu_ar_addr | input | 40 | |
| rb_biu_ar_bar | input | 2 | |
| rb_biu_ar_burst | input | 2 | |
| rb_biu_ar_cache | input | 4 | |
| rb_biu_ar_domain | input | 2 | |
| ... | ... | ... | 共99个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bus_arb_pfu_ar_grnt | output | 1 | |
| bus_arb_pfu_ar_ready | output | 1 | |
| bus_arb_pfu_ar_sel | output | 1 | |
| bus_arb_rb_ar_grnt | output | 1 | |
| bus_arb_rb_ar_sel | output | 1 | |
| bus_arb_vb_aw_grnt | output | 1 | |
| bus_arb_vb_w_grnt | output | 1 | |
| bus_arb_wmb_ar_grnt | output | 1 | |
| bus_arb_wmb_aw_grnt | output | 1 | |
| bus_arb_wmb_w_grnt | output | 1 | |
| lsu_biu_ar_addr | output | 40 | |
| lsu_biu_ar_bar | output | 2 | |
| lsu_biu_ar_burst | output | 2 | |
| lsu_biu_ar_cache | output | 4 | |
| lsu_biu_ar_domain | output | 2 | |
| lsu_biu_ar_dp_req | output | 1 | |
| lsu_biu_ar_id | output | 5 | |
| lsu_biu_ar_len | output | 2 | |
| lsu_biu_ar_lock | output | 1 | |
| lsu_biu_ar_prot | output | 3 | |
| lsu_biu_ar_req | output | 1 | |
| lsu_biu_ar_req_gate | output | 1 | |
| lsu_biu_ar_size | output | 3 | |
| lsu_biu_ar_snoop | output | 4 | |
| lsu_biu_ar_user | output | 3 | |
| lsu_biu_aw_req_gate | output | 1 | |
| lsu_biu_aw_st_addr | output | 40 | |
| lsu_biu_aw_st_bar | output | 2 | |
| lsu_biu_aw_st_burst | output | 2 | |
| lsu_biu_aw_st_cache | output | 4 | |
| ... | ... | ... | 共66个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| gated_clk_cell | x_lsu_bus_arb_mask_gated_clk |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
