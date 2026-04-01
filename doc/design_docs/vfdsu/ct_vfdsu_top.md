# ct_vfdsu_top 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_top` - 向量浮点除法/平方根单元顶层模块

### 1.2 功能描述
`ct_vfdsu_top` 是VFDSU（Vector Floating-point Division/Square-root Unit）的顶层封装模块，负责实现RISC-V处理器中的浮点除法和平方根运算。该模块集成了控制逻辑、双精度数据通路和标量数据处理单元，支持IEEE 754标准的双精度、单精度和半精度浮点运算。

### 1.3 主要特性
- 支持浮点除法（FDIV）和平方根（FSQRT）运算
- 支持三种浮点精度：双精度(64位)、单精度(32位)、半精度(16位)
- 采用SRT radix-16迭代算法
- 4级流水线架构：EX1(准备) → EX2(SRT迭代) → EX3(舍入) → EX4(打包写回)
- IEEE 754标准兼容
- 支持五种舍入模式：RNE、RTZ、RDN、RUP、RMM
- 门控时钟支持，低功耗设计

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                    ct_vfdsu_top                              │
                    │                                                              │
    cp0_yy_clk     │  ┌──────────────┐                                           │
    ──────────────────►│              │                                           │
    cpurst_b        │  │ ct_vfdsu_ctrl│◄──────────────────────────────────────┐   │
    ──────────────────►│              │                                       │   │
    vfdsu_xx_gateclk_v│  └──────┬───────┘                                       │   │
    ──────────────────►│        │                                               │   │
    forever_cpuclk    │        │ ctrl signals                                  │   │
    ──────────────────►│        ▼                                               │   │
    pad_yy_icg_scanen │  ┌──────────────┐     ┌──────────────┐                 │   │
    ──────────────────►│  │              │     │              │                 │   │
                    │  │ ct_vfdsu_    │     │ ct_vfdsu_    │                 │   │
    vfdsu_xx_ex1_    │  │   double     │     │  scalar_dp   │                 │   │
    src_data[63:0]   │  │              │     │              │                 │   │
    ──────────────────►│  └──────────────┘     └──────────────┘                 │   │
    vfdsu_xx_ex1_    │        │                      │                          │   │
    src_vld          │        │ result               │ dest/iid                 │   │
    ──────────────────►│        ▼                      ▼                          │   │
    vfdsu_xx_ex1_    │  ┌──────────────────────────────────────────┐             │   │
    src_id[5:0]      │  │              输出信号                      │             │   │
    ──────────────────►│  │  • vfdsu_xx_ex1_ready                     │             │   │
    vfdsu_xx_ex1_    │  │  • vfdsu_xx_ex2_stall                     │             │   │
    div              │  │  • vfdsu_xx_wb_grant                      │             │   │
    ──────────────────►│  │  • vfdsu_xx_wb_data[63:0]                │             │   │
    vfdsu_xx_ex1_    │  │  • vfdsu_xx_wb_expt[4:0]                  │             │   │
    sqrt             │  │  • vfdsu_xx_wb_dst_vld                    │             │   │
    ──────────────────►│  │  • vfdsu_xx_wb_dst_preg[5: