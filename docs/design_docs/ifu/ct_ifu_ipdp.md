# ct_ifu_ipdp 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ipdp |
| 文件名称 | ct_ifu_ipdp.v |
| 功能描述 | IP阶段数据通路模块 |

### 1.2 功能描述

IP阶段数据通路模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| addrgen_ipdp_chgflw_vl | input | 8 | - |
| addrgen_ipdp_chgflw_vlmul | input | 2 | - |
| addrgen_ipdp_chgflw_vsew | input | 3 | - |
| addrgen_xx_pcload | input | 1 | - |
| bht_ipdp_pre_array_data_ntake | input | 32 | - |
| bht_ipdp_pre_array_data_taken | input | 32 | - |
| bht_ipdp_pre_offset_onehot | input | 16 | - |
| bht_ipdp_sel_array_result | input | 2 | - |
| bht_ipdp_vghr | input | 22 | - |
| cp0_idu_cskyee | input | 1 | - |
| cp0_idu_frm | input | 3 | - |
| cp0_idu_fs | input | 2 | - |
| cp0_ifu_btb_en | input | 1 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_vl | input | 8 | - |
| cp0_ifu_vlmul | input | 2 | - |
| cp0_ifu_vsetvli_pred_disable | input | 1 | - |
| cp0_ifu_vsew | input | 3 | - |
| cp0_yy_clk_en | input | 1 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| had_ifu_ir | input | 32 | - |
| had_ifu_ir_vld | input | 1 | - |
| ibctrl_ipdp_chgflw_vl | input | 8 | - |
| ibctrl_ipdp_chgflw_vlmul | input | 2 | - |
| ibctrl_ipdp_chgflw_vsew | input | 3 | - |
| ibctrl_ipdp_pcload | input | 1 | - |
| ifdp_ipdp_acc_err | input | 1 | - |
| ifdp_ipdp_bkpta | input | 8 | - |
| ifdp_ipdp_bkptb | input | 8 | - |
| ifdp_ipdp_btb_way0_pred | input | 2 | - |
| ifdp_ipdp_btb_way0_tag | input | 10 | - |
| ifdp_ipdp_btb_way0_target | input | 20 | - |
| ifdp_ipdp_btb_way0_vld | input | 1 | - |
| ifdp_ipdp_btb_way1_pred | input | 2 | - |
| ifdp_ipdp_btb_way1_tag | input | 10 | - |
| ifdp_ipdp_btb_way1_target | input | 20 | - |
| ifdp_ipdp_btb_way1_vld | input | 1 | - |
| ifdp_ipdp_btb_way2_pred | input | 2 | - |
| ifdp_ipdp_btb_way2_tag | input | 10 | - |
| ifdp_ipdp_btb_way2_target | input | 20 | - |
| ifdp_ipdp_btb_way2_vld | input | 1 | - |
| ifdp_ipdp_btb_way3_pred | input | 2 | - |
| ifdp_ipdp_btb_way3_tag | input | 10 | - |
| ifdp_ipdp_btb_way3_target | input | 20 | - |
| ifdp_ipdp_btb_way3_vld | input | 1 | - |
| ifdp_ipdp_h1_inst_high_way0 | input | 14 | - |
| ifdp_ipdp_h1_inst_high_way1 | input | 14 | - |
| ifdp_ipdp_h1_inst_low_way0 | input | 2 | - |
| ifdp_ipdp_h1_inst_low_way1 | input | 2 | - |

*注：共156个输入端口，此处仅显示前50个*

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ipdp_bht_h0_con_br | output | 1 | - |
| ipdp_bht_vpc | output | 39 | - |
| ipdp_btb_index_pc | output | 39 | - |
| ipdp_btb_target_pc | output | 20 | - |
| ipdp_ibdp_bht_pre_result | output | 2 | - |
| ipdp_ibdp_bht_result | output | 1 | - |
| ipdp_ibdp_bht_sel_result | output | 2 | - |
| ipdp_ibdp_branch_base | output | 39 | - |
| ipdp_ibdp_branch_btb_miss | output | 1 | - |
| ipdp_ibdp_branch_offset | output | 21 | - |
| ipdp_ibdp_branch_result | output | 39 | - |
| ipdp_ibdp_branch_vl | output | 8 | - |
| ipdp_ibdp_branch_vlmul | output | 2 | - |
| ipdp_ibdp_branch_vsew | output | 3 | - |
| ipdp_ibdp_branch_way_pred | output | 2 | - |
| ipdp_ibdp_btb_index_pc | output | 39 | - |
| ipdp_ibdp_chgflw_mask | output | 8 | - |
| ipdp_ibdp_chgflw_num | output | 4 | - |
| ipdp_ibdp_chgflw_num_vld | output | 1 | - |
| ipdp_ibdp_chgflw_vl | output | 8 | - |
| ipdp_ibdp_chgflw_vlmul | output | 2 | - |
| ipdp_ibdp_chgflw_vsew | output | 3 | - |
| ipdp_ibdp_con_br_cur_pc | output | 39 | - |
| ipdp_ibdp_con_br_half_num | output | 4 | - |
| ipdp_ibdp_con_br_inst_32 | output | 1 | - |
| ipdp_ibdp_con_br_num | output | 4 | - |
| ipdp_ibdp_con_br_num_vld | output | 1 | - |
| ipdp_ibdp_con_br_offset | output | 21 | - |
| ipdp_ibdp_h0_bkpta | output | 1 | - |
| ipdp_ibdp_h0_bkptb | output | 1 | - |
| ipdp_ibdp_h0_con_br | output | 1 | - |
| ipdp_ibdp_h0_cur_pc | output | 36 | - |
| ipdp_ibdp_h0_data | output | 16 | - |
| ipdp_ibdp_h0_fence | output | 1 | - |
| ipdp_ibdp_h0_high_expt | output | 1 | - |
| ipdp_ibdp_h0_ldst | output | 1 | - |
| ipdp_ibdp_h0_no_spec | output | 1 | - |
| ipdp_ibdp_h0_spe_vld | output | 1 | - |
| ipdp_ibdp_h0_split0 | output | 1 | - |
| ipdp_ibdp_h0_split0_type | output | 3 | - |
| ipdp_ibdp_h0_split1 | output | 1 | - |
| ipdp_ibdp_h0_split1_type | output | 3 | - |
| ipdp_ibdp_h0_vl | output | 8 | - |
| ipdp_ibdp_h0_vl_pred | output | 1 | - |
| ipdp_ibdp_h0_vld | output | 1 | - |
| ipdp_ibdp_h0_vlmul | output | 2 | - |
| ipdp_ibdp_h0_vsetvli | output | 1 | - |
| ipdp_ibdp_h0_vsew | output | 3 | - |
| ipdp_ibdp_h1_base | output | 3 | - |
| ipdp_ibdp_h1_data | output | 16 | - |

*注：共187个输出端口，此处仅显示前50个*

### 2.3 参数定义

| 参数名 | 位宽 | 默认值 | 描述 |
|--------|------|--------|------|
| PC_WIDTH | 1 | 40 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ab_br_after_head | 8 | - |
| auipc_after_head | 8 | - |
| base_pc_branch | 39 | - |
| base_pc_con_br | 39 | - |
| bht_pre_result | 2 | - |
| bkpta_after_head | 8 | - |
| bkptb_after_head | 8 | - |
| bry_data_after_head | 8 | - |
| btb_branch_pred | 2 | - |
| btb_branch_tag | 10 | - |
| btb_branch_target | 20 | - |
| btb_branch_way_vld | 1 | - |
| btb_index_pc | 39 | - |
| chgflw_after_head | 8 | - |
| chgflw_mask | 8 | - |
| chgflw_vl | 8 | - |
| chgflw_vlmul | 2 | - |
| chgflw_vsew | 3 | - |
| con_br_after_head | 8 | - |
| con_br_first_branch | 1 | - |
| con_br_vl | 8 | - |
| con_br_vlmul | 2 | - |
| con_br_vmask | 8 | - |
| con_br_vsew | 3 | - |
| dst_vld_after_head | 8 | - |
| fence_after_head | 8 | - |
| h0_ab_br | 1 | - |
| h0_auipc | 1 | - |
| h0_bkpta | 1 | - |
| h0_bkptb | 1 | - |

*注：共286个寄存器信号，此处仅显示前30个*

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ab_br | 8 | - |
| ab_br_pre | 8 | - |
| addrgen_ipdp_chgflw_vl | 8 | - |
| addrgen_ipdp_chgflw_vlmul | 2 | - |
| addrgen_ipdp_chgflw_vsew | 3 | - |
| addrgen_xx_pcload | 1 | - |
| auipc_pre | 8 | - |
| bar_hit | 1 | - |
| bht_ipdp_pre_array_data_ntake | 32 | - |
| bht_ipdp_pre_array_data_taken | 32 | - |
| bht_ipdp_pre_offset_onehot | 16 | - |
| bht_ipdp_sel_array_result | 2 | - |
| bht_ipdp_vghr | 22 | - |
| bht_result | 1 | - |
| bht_sel_result | 2 | - |
| bkpta | 8 | - |
| bkptb | 8 | - |
| br | 8 | - |
| br_pre | 8 | - |
| branch | 8 | - |
| bry_data | 8 | - |
| btb_branch_miss | 1 | - |
| chgflw | 8 | - |
| chgflw_pre | 8 | - |
| con_br | 8 | - |
| con_br_more_than_one | 1 | - |
| con_br_pre | 8 | - |
| cp0_idu_cskyee | 1 | - |
| cp0_idu_frm | 3 | - |
| cp0_idu_fs | 2 | - |

*注：共977个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：IP阶段数据通路模块
- 所属单元：取指单元(IFU)
- 接口数量：输入156个，输出187个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
