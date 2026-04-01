# ct_ifu_ind_btb 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_ind_btb |
| 文件名称 | ct_ifu_ind_btb.v |
| 功能描述 | 间接BTB模块 |

### 1.2 功能描述

间接BTB模块。该模块是OpenC910处理器取指单元(IFU)的组成部分。

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| bht_ind_btb_rtu_ghr | input | 8 | - |
| bht_ind_btb_vghr | input | 8 | - |
| cp0_ifu_icg_en | input | 1 | - |
| cp0_ifu_ind_btb_en | input | 1 | - |
| cp0_yy_clk_en | input | 1 | - |
| cp0_yy_priv_mode | input | 2 | - |
| cpurst_b | input | 1 | - |
| forever_cpuclk | input | 1 | - |
| ibctrl_ind_btb_check_vld | input | 1 | - |
| ibctrl_ind_btb_fifo_stall | input | 1 | - |
| ibctrl_ind_btb_path | input | 8 | - |
| ifctrl_ind_btb_inv | input | 1 | - |
| ipctrl_ind_btb_con_br_vld | input | 1 | - |
| ipdp_ind_btb_jmp_detect | input | 1 | - |
| pad_yy_icg_scan_en | input | 1 | - |
| rtu_ifu_flush | input | 1 | - |
| rtu_ifu_retire0_chk_idx | input | 8 | - |
| rtu_ifu_retire0_jmp | input | 1 | - |
| rtu_ifu_retire0_jmp_mispred | input | 1 | - |
| rtu_ifu_retire0_mispred | input | 1 | - |
| rtu_ifu_retire0_next_pc | input | 39 | - |
| rtu_ifu_retire1_chk_idx | input | 8 | - |
| rtu_ifu_retire1_jmp | input | 1 | - |
| rtu_ifu_retire2_chk_idx | input | 8 | - |
| rtu_ifu_retire2_jmp | input | 1 | - |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ind_btb_ibctrl_dout | output | 23 | - |
| ind_btb_ibctrl_priv_mode | output | 2 | - |
| ind_btb_ifctrl_inv_done | output | 1 | - |
| ind_btb_ifctrl_inv_on | output | 1 | - |

## 3. 内部信号列表

### 3.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| after_path_reg_rtu_updt | 1 | - |
| ind_btb_dout_reg | 23 | - |
| ind_btb_index | 8 | - |
| ind_btb_inv_cnt | 8 | - |
| ind_btb_inv_on_reg | 1 | - |
| ind_btb_rd_flop | 1 | - |
| path_reg_0 | 8 | - |
| path_reg_1 | 8 | - |
| path_reg_2 | 8 | - |
| path_reg_3 | 8 | - |
| priv_mode_reg | 2 | - |
| rtu_path_reg_0 | 8 | - |
| rtu_path_reg_0_pre | 8 | - |
| rtu_path_reg_1 | 8 | - |
| rtu_path_reg_1_pre | 8 | - |
| rtu_path_reg_2 | 8 | - |
| rtu_path_reg_2_pre | 8 | - |
| rtu_path_reg_3 | 8 | - |
| rtu_path_reg_3_pre | 8 | - |

### 3.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| after_path_reg_rtu_updt_rd | 1 | - |
| bht_ind_btb_rtu_ghr | 8 | - |
| bht_ind_btb_vghr | 8 | - |
| cp0_ifu_icg_en | 1 | - |
| cp0_ifu_ind_btb_en | 1 | - |
| cp0_yy_clk_en | 1 | - |
| cp0_yy_priv_mode | 2 | - |
| cpurst_b | 1 | - |
| dout_update_clk | 1 | - |
| dout_update_clk_en | 1 | - |
| forever_cpuclk | 1 | - |
| ib_stage_path_update_rd | 1 | - |
| ibctrl_ind_btb_check_vld | 1 | - |
| ibctrl_ind_btb_fifo_stall | 1 | - |
| ibctrl_ind_btb_path | 8 | - |
| ifctrl_ind_btb_inv | 1 | - |
| ind_btb_cen_b | 1 | - |
| ind_btb_clk_en | 1 | - |
| ind_btb_data_in | 23 | - |
| ind_btb_dout | 23 | - |
| ind_btb_ibctrl_dout | 23 | - |
| ind_btb_ibctrl_priv_mode | 2 | - |
| ind_btb_ifctrl_inv_done | 1 | - |
| ind_btb_ifctrl_inv_on | 1 | - |
| ind_btb_inv_reg_upd_clk | 1 | - |
| ind_btb_inv_reg_upd_clk_en | 1 | - |
| ind_btb_invalidate | 1 | - |
| ind_btb_rd | 1 | - |
| ind_btb_rd_index | 8 | - |
| ind_btb_wen_b | 1 | - |

*注：共62个线网信号，此处仅显示前30个*

## 4. 设计说明

### 4.1 设计特点

- 模块类型：间接BTB模块
- 所属单元：取指单元(IFU)
- 接口数量：输入25个，输出4个

## 5. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
