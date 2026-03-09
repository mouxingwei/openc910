# OpenC910 一级模块文档：指令取指单元 (IFU)

## 1. 模块概述

指令取指单元 (Instruction Fetch Unit, IFU) 是 OpenC910 处理器的指令获取前端，负责从内存中获取指令并提供给后续的译码单元。IFU 包含指令缓存、分支预测器和指令缓冲队列，是处理器性能的关键组成部分。

### 1.1 主要功能

- PC 生成与地址计算
- 指令缓存访问
- 分支预测 (BTB/BHT/RAS)
- 指令预解码
- 指令缓冲与分发

## 2. 模块接口

### 2.1 与 IDU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| ifu_idu_ib_inst0_data | O | 32 | 指令0数据 |
| ifu_idu_ib_inst0_vld | O | 1 | 指令0有效 |
| ifu_idu_ib_inst1_data | O | 32 | 指令1数据 |
| ifu_idu_ib_inst1_vld | O | 1 | 指令1有效 |
| ifu_idu_ib_inst2_data | O | 32 | 指令2数据 |
| ifu_idu_ib_inst2_vld | O | 1 | 指令2有效 |
| idu_ifu_id_stall | I | 1 | IDU 反压信号 |

### 2.2 与 BIU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| ifu_biu_rd_addr | O | 40 | 读请求地址 |
| ifu_biu_rd_req | O | 1 | 读请求有效 |
| ifu_biu_r_ready | O | 1 | 准备接收数据 |
| biu_ifu_rd_data | I | 128 | 返回数据 |
| biu_ifu_rd_data_vld | I | 1 | 返回数据有效 |
| biu_ifu_rd_grnt | I | 1 | 总线授权 |

### 2.3 与 MMU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| ifu_mmu_va | O | 63 | 虚拟地址 |
| ifu_mmu_va_vld | O | 1 | 虚拟地址有效 |
| mmu_ifu_pa | I | 28 | 物理地址 |
| mmu_ifu_pavld | I | 1 | 物理地址有效 |
| mmu_ifu_pgflt | I | 1 | 页错误标志 |

### 2.4 与 CP0 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| cp0_ifu_icache_en | I | 1 | I-Cache 使能 |
| cp0_ifu_btb_en | I | 1 | BTB 使能 |
| cp0_ifu_bht_en | I | 1 | BHT 使能 |
| cp0_ifu_rvbr | I | 40 | 复位向量基址 |

## 3. 内部架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                           ct_ifu_top                                 │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐   ┌─────────────┐   ┌─────────────┐               │
│  │ ct_ifu_pcgen│   │ct_ifu_ifctrl│   │ ct_ifu_ifdp │               │
│  │   PC生成    │──▶│   取指控制  │──▶│   取指数据  │               │
│  └─────────────┘   └─────────────┘   └─────────────┘               │
│         │                 │                 │                       │
│         ▼                 ▼                 ▼                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    分支预测子系统                             │   │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │   │
│  │  │ct_ifu_  │  │ct_ifu_  │  │ct_ifu_  │  │ct_ifu_  │        │   │
│  │  │l0_btb   │  │ btb     │  │  bht    │  │  ras    │        │   │
│  │  │L0-BTB   │  │ 主BTB   │  │  BHT    │  │  RAS    │        │   │
│  │  └─────────┘  └─────────┘  └─────────┘  └─────────┘        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│         │                 │                 │                       │
│         ▼                 ▼                 ▼                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    指令缓存子系统                             │   │
│  │  ┌──────────────────┐  ┌──────────────────┐                 │   │
│  │  │ ct_ifu_icache_if │  │ ct_ifu_icache_*  │                 │   │
│  │  │   Cache 接口     │  │   Cache 存储阵列  │                 │   │
│  │  └──────────────────┘  └──────────────────┘                 │   │
│  └─────────────────────────────────────────────────────────────┘   │
│         │                 │                 │                       │
│         ▼                 ▼                 ▼                       │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    指令缓冲与分发                             │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ ct_ifu_ibuf  │  │ ct_ifu_ibdp  │  │ct_ifu_ibctrl │      │   │
│  │  │  指令缓冲    │  │  缓冲数据通路 │  │  缓冲控制    │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 4. 二级模块列表

### 4.1 PC生成模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_pcgen | ct_ifu_pcgen.v | PC值生成，顺序/跳转PC计算 |
| ct_ifu_addrgen | ct_ifu_addrgen.v | 地址生成逻辑 |

### 4.2 取指控制模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_ifctrl | ct_ifu_ifctrl.v | 取指控制状态机 |
| ct_ifu_ifdp | ct_ifu_ifdp.v | 取指数据通路 |

### 4.3 分支预测模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_l0_btb | ct_ifu_l0_btb.v | L0 BTB，快速分支目标预测 |
| ct_ifu_l0_btb_entry | ct_ifu_l0_btb_entry.v | L0 BTB 表项 |
| ct_ifu_btb | ct_ifu_btb.v | 主分支目标缓冲区 |
| ct_ifu_btb_tag_array | ct_ifu_btb_tag_array.v | BTB 标签阵列 |
| ct_ifu_btb_data_array | ct_ifu_btb_data_array.v | BTB 数据阵列 |
| ct_ifu_bht | ct_ifu_bht.v | 分支历史表 |
| ct_ifu_bht_pre_array | ct_ifu_bht_pre_array.v | BHT 预测阵列 |
| ct_ifu_bht_sel_array | ct_ifu_bht_sel_array.v | BHT 选择阵列 |
| ct_ifu_ras | ct_ifu_ras.v | 返回地址栈 |
| ct_ifu_ind_btb | ct_ifu_ind_btb.v | 间接BTB |
| ct_ifu_ind_btb_array | ct_ifu_ind_btb_array.v | 间接BTB阵列 |

### 4.4 指令缓存模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_icache_if | ct_ifu_icache_if.v | I-Cache 接口逻辑 |
| ct_ifu_icache_data_array0 | ct_ifu_icache_data_array0.v | Cache 数据阵列0 |
| ct_ifu_icache_data_array1 | ct_ifu_icache_data_array1.v | Cache 数据阵列1 |
| ct_ifu_icache_tag_array | ct_ifu_icache_tag_array.v | Cache 标签阵列 |
| ct_ifu_icache_predecd_array0 | ct_ifu_icache_predecd_array0.v | 预解码阵列0 |
| ct_ifu_icache_predecd_array1 | ct_ifu_icache_predecd_array1.v | 预解码阵列1 |

### 4.5 指令缓冲模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_ibuf | ct_ifu_ibuf.v | 指令缓冲主模块 |
| ct_ifu_ibuf_entry | ct_ifu_ibuf_entry.v | 指令缓冲表项 |
| ct_ifu_ibctrl | ct_ifu_ibctrl.v | 指令缓冲控制 |
| ct_ifu_ibdp | ct_ifu_ibdp.v | 指令缓冲数据通路 |

### 4.6 预解码模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_precode | ct_ifu_precode.v | 预解码逻辑 |
| ct_ifu_decd_normal | ct_ifu_decd_normal.v | 常规指令解码 |

### 4.7 其他模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_ifu_ipb | ct_ifu_ipb.v | 指令预取缓冲 |
| ct_ifu_ipctrl | ct_ifu_ipctrl.v | 预取控制 |
| ct_ifu_ipdp | ct_ifu_ipdp.v | 预取数据通路 |
| ct_ifu_ipdecode | ct_ifu_ipdecode.v | 预取解码 |
| ct_ifu_lbuf | ct_ifu_lbuf.v | 行缓冲 |
| ct_ifu_lbuf_entry | ct_ifu_lbuf_entry.v | 行缓冲表项 |
| ct_ifu_l1_refill | ct_ifu_l1_refill.v | L1 重填逻辑 |
| ct_ifu_sfp | ct_ifu_sfp.v | 简单分支预测器 |
| ct_ifu_sfp_entry | ct_ifu_sfp_entry.v | SFP 表项 |
| ct_ifu_pcfifo_if | ct_ifu_pcfifo_if.v | PC FIFO 接口 |
| ct_ifu_vector | ct_ifu_vector.v | 向量取指支持 |
| ct_ifu_debug | ct_ifu_debug.v | 调试支持 |

## 5. 分支预测机制

### 5.1 预测器层次

```
┌─────────────────────────────────────────────────────┐
│                  分支预测层次结构                     │
├─────────────────────────────────────────────────────┤
│  Level 0: L0-BTB (快速预测，1周期延迟)              │
│  ├── 小容量、低延迟                                 │
│  └── 用于顺序取指时的快速预测                       │
├─────────────────────────────────────────────────────┤
│  Level 1: 主BTB + BHT (精确预测)                    │
│  ├── 大容量BTB存储分支目标                          │
│  ├── 2-bit BHT存储分支历史                          │
│  └── 支持条件分支预测                               │
├─────────────────────────────────────────────────────┤
│  辅助预测器:                                        │
│  ├── RAS (返回地址栈) - 函数返回预测                │
│  └── Indirect BTB - 间接跳转预测                    │
└─────────────────────────────────────────────────────┘
```

### 5.2 预测算法

- **条件分支**: 2-bit 饱和计数器 BHT
- **直接跳转**: BTB 存储目标地址
- **函数返回**: RAS 栈预测
- **间接跳转**: 间接BTB预测

## 6. I-Cache 配置

| 参数 | 值 |
|-----|-----|
| 容量 | 32KB / 64KB |
| 组相联 | 4-way |
| 行大小 | 64B |
| 替换策略 | PLRU |
| 预解码 | 支持 |

## 7. 关键时序

### 7.1 取指流水线

```
周期:    T0      T1      T2      T3
       ┌───────┬───────┬───────┬───────┐
IF1    │PC生成 │       │       │       │
       └───────┴───────┴───────┴───────┘
               ┌───────┬───────┬───────┐
IF2            │Cache  │       │       │
               │访问   │       │       │
               └───────┴───────┴───────┴───────┘
                       ┌───────┬───────┐
IB                     │指令   │       │
                       │缓冲   │       │
                       └───────┴───────┘
```

### 7.2 分支预测恢复

- 预测错误检测: EX阶段
- 流水线刷新: 1-2周期
- PC重定向: 立即生效

## 8. 设计要点

1. **多级预测器**: L0-BTB + 主BTB + BHT 分层预测
2. **预解码**: 在Cache填充时进行预解码，加速后续译码
3. **指令缓冲**: 支持多指令并行分发
4. **向量扩展支持**: 支持V扩展指令的取指

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
