# ct_idu_rf_pipe4_decd 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_pipe4_decd |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe4_decd.v |
| 功能描述 | Pipe4流水线存储指令解码模块 |

### 1.2 功能描述

ct_idu_rf_pipe4_decd 是寄存器重命名阶段Pipe4的存储指令解码模块，负责：
- 存储指令解码
- 存储大小识别
- Fence指令处理
- TLB广播控制
- 偏移量计算
- 原子操作识别

### 1.3 设计特点

- 支持所有RISC-V存储指令
- 支持多种Fence模式
- 支持TLB广播控制
- 支持缓存一致性操作(ICC)
- 支持存储结果左移

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_lsu_fencei_broad_dis | 1 | Fence.i广播禁用 |
| cp0_lsu_fencerw_broad_dis | 1 | Fence.rw广播禁用 |
| cp0_lsu_tlb_broad_dis | 1 | TLB广播禁用 |
| pipe4_decd_dst_preg | 7 | 目标物理寄存器 |
| pipe4_decd_opcode | 32 | 操作码输入 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe4_decd_atomic | 1 | 原子操作标志 |
| pipe4_decd_dst_preg | 7 | 目标物理寄存器 |
| pipe4_decd_fence_mode | 4 | Fence模式 |
| pipe4_decd_icc | 1 | 缓存一致性标志 |
| pipe4_decd_inst_fls | 1 | 故障存储标志 |
| pipe4_decd_inst_flush | 1 | 刷新指令标志 |
| pipe4_decd_inst_mode | 2 | 指令模式 |
| pipe4_decd_inst_share | 1 | 共享标志 |
| pipe4_decd_inst_size | 2 | 存储大小 |
| pipe4_decd_inst_str | 1 | 存储结果左移 |
| pipe4_decd_inst_type | 2 | 指令类型 |
| pipe4_decd_lsfifo | 1 | LSFIFO队列标志 |
| pipe4_decd_mmu_req | 1 | MMU请求 |
| pipe4_decd_off_0_extend | 1 | 偏移0扩展 |
| pipe4_decd_offset | 12 | 存储偏移量 |
| pipe4_decd_offset_plus | 13 | 偏移量加1 |
| pipe4_decd_shift | 4 | 移位量 |
| pipe4_decd_st | 1 | 存储指令 |
| pipe4_decd_sync_fence | 1 | 同步Fence标志 |

## 3. Fence模式定义

| MODE值 | 类型 | 说明 |
|--------|------|------|
| 4'b0001 | fence | 内存屏障 |
| 4'b0010 | fence.i | 指令屏障 |
| 4'b0100 | fence.tso | 总顺序保留 |
| 4'b1000 | sfence.vma | TLB刷新 |

## 4. 存储大小定义

| SIZE值 | 类型 | 数据宽度 |
|--------|------|----------|
| 2'b00 | BYTE | 8位 |
| 2'b01 | HALF | 16位 |
| 2'b10 | WORD | 32位 |
| 2'b11 | DWORD | 64位 |

## 5. RVV相关性分析

### 5.1 向量存储指令支持

本模块通过`pipe4_decd_inst_type`识别向量存储指令：

| TYPE值 | 存储类型 | RVV指令示例 |
|--------|----------|-------------|
| 2'b00 | 普通存储 | sb, sh, sw, sd |
| 2'b01 | 向量存储 | vse.v, vse8.v |
| 2'b10 | 向量索引存储 | vsuxei.v |
| 2'b11 | 特殊存储 | (保留) |

### 5.2 向量存储相关信号

| 信号 | 说明 |
|------|------|
| pipe4_decd_lsfifo | 标识向量存储进入LSFIFO队列 |
| pipe4_decd_inst_vls | 向量存储标志(已定义但未使用) |

## 6. RVV 1.0指令集修改点

### 6.1 向量存储指令支持

RVV 1.0向量存储指令的解码支持：

| 修改项 | 说明 |
|--------|------|
| 单位步长存储 | vse.v, vse8.v, vse16.v, vse32.v, vse64.v |
| 索引存储 | vsuxei.v |
| 掩码存储 | vsse.v |

### 6.2 存储大小扩展

RVV 1.0支持的向量元素存储宽度：

| SEW值 | 元素宽度 | 向量存储 |
|--------|----------|----------|
| 2'b00 | 8位 | vse8.v |
| 2'b01 | 16位 | vse16.v |
| 2'b10 | 32位 | vse32.v |
| 2'b11 | 64位 | vse64.v |

### 6.3 Fence指令与向量同步

RVV 1.0中的向量同步操作：

| 指令 | fence_mode | 说明 |
|------|------------|------|
| vsetivli | - | 配置vl后需同步 |
| vsync | 特定编码 | 向量指令同步 |

### 6.4 存储偏移量处理

| 偏移模式 | 说明 |
|----------|------|
| pipe4_decd_offset | 12位基偏移 |
| pipe4_decd_offset_plus | 13位偏移(+1) |
| pipe4_decd_off_0_extend | 偏移0扩展控制 |

## 7. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.1 | 2026-04-01 | Auto-generated | 添加RVV相关性分析和1.0修改点 |
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
