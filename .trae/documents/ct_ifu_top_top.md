# ct_ifu_top 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_ifu_top |
| 文件路径 | ifu/rtl/ct_ifu_top.v |
| 功能描述 | 取指单元顶层模块 |
| 设计特点 | 支持分支预测、指令缓存、指令预取 |

### 1.2 功能描述

ct_ifu_top 是 OpenC910 处理器的取指单元，负责从内存中获取指令并传递给译码单元。主要功能包括：

- **指令获取**：从 ICache 或内存获取指令
- **分支预测**：使用 BHT/BTB 进行分支预测
- **指令缓冲**：缓存预取的指令
- **地址生成**：生成取指地址

### 1.3 设计特点

- 支持多级分支预测（BHT/BTB/L0 BTB）
- 支持 ICache 管理和无效化
- 支持 RVI/RVC 混合指令集
- 支持指令预取优化

## 2. 子模块列表

| 模块名 | 实例名 | 功能描述 |
|--------|--------|----------|
| ct_ifu_addrgen | x_ct_ifu_addrgen | 地址生成单元 |
| ct_ifu_bht | x_ct_ifu_bht | 分支历史表 |
| ct_ifu_btb | x_ct_ifu_btb | 分支目标缓冲 |
| ct_ifu_l0_btb | x_ct_ifu_l0_btb | L0分支目标缓冲 |
| ct_ifu_sfp | x_ct_ifu_sfp | 简单预测器 |
| ct_ifu_ibctrl | x_ct_ifu_ibctrl | 指令缓冲控制 |
| ct_ifu_ibdp | x_ct_ifu_ibdp | 指令缓冲分发 |
| ct_ifu_ibuf | x_ct_ifu_ibuf | 指令缓冲 |

## 3. 主要接口信号

### 3.1 输入信号

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| forever_cpuclk | input | 1 | 全局时钟 |
| cpurst_b | input | 1 | 复位信号（低有效） |
| biu_ifu_rd_data | input | 128 | 总线读数据 |
| biu_ifu_rd_data_vld | input | 1 | 总线读数据有效 |
| biu_ifu_rd_grnt | input | 1 | 总线读授权 |
| cp0_ifu_icache_en | input | 1 | ICache使能 |
| cp0_ifu_bht_en | input | 1 | BHT使能 |
| cp0_ifu_btb_en | input | 1 | BTB使能 |

### 3.2 输出信号

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_biu_rd_addr | output | 40 | 总线读地址 |
| ifu_biu_rd_req | output | 1 | 总线读请求 |
| ifu_biu_rd_len | output | 4 | 总线读长度 |
| ifu_cp0_icache_inv_done | output | 1 | ICache无效化完成 |
| ifu_cp0_bht_inv_done | output | 1 | BHT无效化完成 |
| ifu_cp0_btb_inv_done | output | 1 | BTB无效化完成 |

## 4. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2024-01-01 | T-Head | 初始版本 |
