# ct_idu_rf_fwd 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_fwd |
| 文件路径 | idu/rtl/ct_idu_rf_fwd.v |
| 功能描述 | 前递控制 |

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_idu_src2_fwd_disable | input | 1 | |
| cp0_idu_srcv2_fwd_disable | input | 1 | |
| dp_fwd_rf_pipe0_src0_preg | input | 7 | |
| dp_fwd_rf_pipe0_src1_preg | input | 7 | |
| dp_fwd_rf_pipe1_mla | input | 1 | |
| dp_fwd_rf_pipe1_src0_preg | input | 7 | |
| dp_fwd_rf_pipe1_src1_preg | input | 7 | |
| dp_fwd_rf_pipe2_src0_preg | input | 7 | |
| dp_fwd_rf_pipe2_src1_preg | input | 7 | |
| dp_fwd_rf_pipe3_src0_preg | input | 7 | |
| dp_fwd_rf_pipe3_src1_preg | input | 7 | |
| dp_fwd_rf_pipe4_src0_preg | input | 7 | |
| dp_fwd_rf_pipe4_src1_preg | input | 7 | |
| dp_fwd_rf_pipe5_src0_preg | input | 7 | |
| dp_fwd_rf_pipe5_srcv0_vreg | input | 7 | |
| dp_fwd_rf_pipe6_srcv0_vreg | input | 7 | |
| dp_fwd_rf_pipe6_srcv1_vreg | input | 7 | |
| dp_fwd_rf_pipe6_srcv2_vreg | input | 7 | |
| dp_fwd_rf_pipe6_srcvm_vreg | input | 7 | |
| dp_fwd_rf_pipe6_vmla | input | 1 | |
| dp_fwd_rf_pipe7_srcv0_vreg | input | 7 | |
| dp_fwd_rf_pipe7_srcv1_vreg | input | 7 | |
| dp_fwd_rf_pipe7_srcv2_vreg | input | 7 | |
| dp_fwd_rf_pipe7_srcvm_vreg | input | 7 | |
| dp_fwd_rf_pipe7_vmla | input | 1 | |
| iu_idu_ex1_pipe0_fwd_preg | input | 7 | |
| iu_idu_ex1_pipe0_fwd_preg_data | input | 64 | |
| iu_idu_ex1_pipe0_fwd_preg_vld | input | 1 | |
| iu_idu_ex1_pipe1_fwd_preg | input | 7 | |
| iu_idu_ex1_pipe1_fwd_preg_data | input | 64 | |
| ... | ... | ... | 共86个端口 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| fwd_dp_rf_pipe0_src0_data | output | 64 | |
| fwd_dp_rf_pipe0_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe0_src1_data | output | 64 | |
| fwd_dp_rf_pipe0_src1_no_fwd | output | 1 | |
| fwd_dp_rf_pipe1_src0_data | output | 64 | |
| fwd_dp_rf_pipe1_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe1_src1_data | output | 64 | |
| fwd_dp_rf_pipe1_src1_no_fwd | output | 1 | |
| fwd_dp_rf_pipe2_src0_data | output | 64 | |
| fwd_dp_rf_pipe2_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe2_src1_data | output | 64 | |
| fwd_dp_rf_pipe2_src1_no_fwd | output | 1 | |
| fwd_dp_rf_pipe3_src0_data | output | 64 | |
| fwd_dp_rf_pipe3_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe3_src1_data | output | 64 | |
| fwd_dp_rf_pipe3_src1_no_fwd | output | 1 | |
| fwd_dp_rf_pipe3_srcvm_no_fwd_expt_vmla | output | 1 | |
| fwd_dp_rf_pipe3_srcvm_vreg_vr0_data | output | 64 | |
| fwd_dp_rf_pipe3_srcvm_vreg_vr1_data | output | 64 | |
| fwd_dp_rf_pipe4_src0_data | output | 64 | |
| fwd_dp_rf_pipe4_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe4_src1_data | output | 64 | |
| fwd_dp_rf_pipe4_src1_no_fwd | output | 1 | |
| fwd_dp_rf_pipe4_srcvm_no_fwd_expt_vmla | output | 1 | |
| fwd_dp_rf_pipe4_srcvm_vreg_vr0_data | output | 64 | |
| fwd_dp_rf_pipe4_srcvm_vreg_vr1_data | output | 64 | |
| fwd_dp_rf_pipe5_src0_data | output | 64 | |
| fwd_dp_rf_pipe5_src0_no_fwd | output | 1 | |
| fwd_dp_rf_pipe5_src0_no_fwd_expt_mla | output | 1 | |
| fwd_dp_rf_pipe5_srcv0_no_fwd | output | 1 | |
| ... | ... | ... | 共63个端口 |

## 3. 子模块列表

| 模块名 | 实例名 |
|--------|--------|
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe0_src0 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe0_src1 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe1_src0 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe1_src1 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe2_src0 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe2_src1 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe3_src0 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe3_src1 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe3_srcvm |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe3_srcvm |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe4_src0 |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe4_src1 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe4_srcvm |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe4_srcvm |
| ct_idu_rf_fwd_preg | x_ct_idu_rf_fwd_preg_pipe5_src0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_fr_pipe5_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe5_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe5_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_fr_pipe6_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe6_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe6_srcv0 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_fr_pipe6_srcv1 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe6_srcv1 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe6_srcv1 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_fr_pipe6_srcv2 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe6_srcv2 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe6_srcv2 |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr0_pipe6_srcvm |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_vr1_pipe6_srcvm |
| ct_idu_rf_fwd_vreg | x_ct_idu_rf_fwd_vreg_fr_pipe7_srcv0 |
| ... | 共40个实例 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
