# ct_idu_rf_pipe3_decd 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_pipe3_decd |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe3_decd.v |
| 功能描述 | Pipe3流水线加载指令解码模块 |

### 1.2 功能描述

ct_idu_rf_pipe3_decd 是寄存器重命名阶段Pipe3的加载指令解码模块，负责：
- 加载指令解码
- 加载大小识别(byte/half/word/dword)
- 符号扩展控制
- 偏移量计算
- 原子操作识别
- RVV FOF(Fault-Only-First)指令支持

### 1.3 设计特点

- 支持所有RISC-V加载指令
- 支持RVV 1.0 Fault-Only-First加载
- 支持加载结果左移(用于非对齐访问)
- 支持LSFIFO队列管理
- 支持向量化加载

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe3_decd_opcode | 32 | 操作码输入 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe3_decd_atomic | 1 | 原子操作标志 |
| pipe3_decd_inst_fls | 1 | 故障加载清零-设置 |
| pipe3_decd_inst_fof | 1 | 故障仅首次标志(RVV 1.0) |
| pipe3_decd_inst_ldr | 1 | 加载结果左移 |
| pipe3_decd_inst_size | 2 | 加载大小 |
| pipe3_decd_inst_type | 2 | 指令类型 |
| pipe3_decd_lsfifo | 1 | LSFIFO队列标志 |
| pipe3_decd_off_0_extend | 1 | 偏移0扩展 |
| pipe3_decd_offset | 12 | 加载偏移量 |
| pipe3_decd_offset_plus | 13 | 偏移量加1 |
| pipe3_decd_shift | 4 | 移位量 |
| pipe3_decd_sign_extend | 1 | 符号扩展标志 |

## 3. 加载大小定义

| SIZE值 | 类型 | 数据宽度 |
|--------|------|----------|
| 2'b00 | BYTE | 8位 |
| 2'b01 | HALF | 16位 |
| 2'b10 | WORD | 32位 |
| 2'b11 | DWORD | 64位 |

## 4. 支持的加载指令

| 指令 | 符号扩展 | 大小 |
|------|----------|------|
| lb | 是 | BYTE |
| lh | 是 | HALF |
| lw | 是 | WORD |
| ld | 是 | DWORD |
| lbu | 否 | BYTE |
| lhu | 否 | HALF |
| lwu | 否 | WORD |

## 5. RVV相关性分析

### 5.1 向量加载指令支持

本模块通过`pipe3_decd_inst_type`识别向量加载指令：

| TYPE值 | 加载类型 | RVV指令示例 |
|--------|----------|-------------|
| 2'b00 | 普通加载 | lb, lh, lw, ld |
| 2'b01 | 向量加载 | vle.v, vle8.v |
| 2'b10 | 向量索引加载 | vluxei.v |
| 2'b11 | 特殊加载 | (保留) |

### 5.2 RVV向量加载信号

| 信号 | 说明 |
|------|------|
| pipe3_decd_lsfifo | 标识向量加载进入LSFIFO队列 |
| pipe3_decd_inst_vls | 向量加载标志(已定义但未使用) |

## 6. RVV 1.0指令集修改点

### 6.1 FOF (Fault-Only-First) 机制

RVV 1.0最重要的修改之一是FOF机制：

| 信号 | 说明 |
|------|------|
| pipe3_decd_inst_fof | FOF指令标志 |
| pipe3_decd_inst_fls | 故障清零-设置标志 |

**FOF工作原理：**
1. 首次发生页面故障时，正常报告异常
2. 后续元素访问同一页面时，不重复报告异常
3. 避免异常处理中的重复报告

### 6.2 FOF指令编码

| 指令 | opcode | 说明 |
|------|--------|------|
| vle1ff.v | 特定编码 | 单位步长FOF加载 |
| vluxei1ff.v | 特定编码 | 索引FOF加载 |

### 6.3 向量加载大小扩展

RVV 1.0支持的向量元素宽度：

| SEW值 | 元素宽度 | 向量加载 |
|--------|----------|----------|
| 2'b00 | 8位 | vle8.v |
| 2'b01 | 16位 | vle16.v |
| 2'b10 | 32位 | vle32.v |
| 2'b11 | 64位 | vle64.v |

### 6.4 加载偏移量处理

RVV 1.0向量加载偏移量计算：

| 偏移模式 | 说明 |
|----------|------|
| pipe3_decd_offset | 12位基偏移 |
| pipe3_decd_offset_plus | 13位偏移(+1) |
| pipe3_decd_off_0_extend | 偏移0扩展控制 |

## 7. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.2 | 2026-04-01 | Auto-generated | 添加RVV相关性详细分析 |
| 1.1 | 2026-04-01 | Auto-generated | 添加RVV 1.0 FOF支持 |
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
