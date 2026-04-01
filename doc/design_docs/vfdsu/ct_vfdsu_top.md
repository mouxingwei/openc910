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
    ──────────────────►│  │  • vfdsu_xx_wb_dst_preg[5:0]             │             │   │
    vfdsu_xx_ex1_    │  └──────────────────────────────────────────┘             │   │
    double           │                                                          │   │
    ──────────────────►│                                                          │   │
    vfdsu_xx_ex1_    │                                                          │   │
    single           │                                                          │   │
    ──────────────────►│                                                          │   │
    vfdsu_xx_ex1_rm[2:0]                                                         │
    ──────────────────►│                                                          │   │
                    └─────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cp0_yy_clk` | 1 | CP0时钟信号 |
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `vfdsu_xx_gateclk_v` | 1 | 门控时钟使能信号 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号，用于DFT |
| `vfdsu_xx_ex1_src_data[63:0]` | 64 | EX1阶段源操作数数据 |
| `vfdsu_xx_ex1_src_vld` | 1 | EX1阶段源数据有效信号 |
| `vfdsu_xx_ex1_src_id[5:0]` | 6 | EX1阶段源操作数ID |
| `vfdsu_xx_ex1_div` | 1 | EX1阶段除法操作指示 |
| `vfdsu_xx_ex1_sqrt` | 1 | EX1阶段平方根操作指示 |
| `vfdsu_xx_ex1_double` | 1 | EX1阶段双精度操作指示 |
| `vfdsu_xx_ex1_single` | 1 | EX1阶段单精度操作指示 |
| `vfdsu_xx_ex1_rm[2:0]` | 3 | EX1阶段舍入模式 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |
| `rtu_yy_xx_expt_int` | 1 | 异常中断信号 |
| `iu_yy_xx_cancel` | 1 | IU取消信号 |
| `lsu_xx_no_op` | 1 | LSU无操作信号 |
| `lsu_xx_right_shift[4:0]` | 5 | LSU右移量 |
| `vfdsu_xx_wb_grant` | 1 | 写回授权信号 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `vfdsu_xx_ex1_ready` | 1 | EX1阶段就绪信号，表示可以接收新操作 |
| `vfdsu_xx_ex2_stall` | 1 | EX2阶段暂停信号 |
| `vfdsu_xx_wb_data[63:0]` | 64 | 写回数据 |
| `vfdsu_xx_wb_expt[4:0]` | 5 | 写回异常标志（NV, DZ, OF, UF, NX） |
| `vfdsu_xx_wb_dst_vld` | 1 | 写回目标有效信号 |
| `vfdsu_xx_wb_dst_preg[5:0]` | 6 | 写回目标物理寄存器号 |
| `vfdsu_xx_wb_iid[6:0]` | 7 | 写回指令ID |
| `vfdsu_xx_wb_flush` | 1 | 写回刷新信号 |
| `vfdsu_xx_wb_split` | 1 | 写回分割信号 |

## 4. 子模块实例化

### 4.1 模块层次结构

```
ct_vfdsu_top
├── ct_vfdsu_ctrl          -- 控制模块
├── ct_vfdsu_double        -- 双精度数据通路
│   ├── ct_vfdsu_prepare   -- 输入准备
│   ├── ct_vfdsu_srt       -- SRT算法
│   ├── ct_vfdsu_round     -- 舍入
│   └── ct_vfdsu_pack      -- 结果打包
└── ct_vfdsu_scalar_dp     -- 标量数据处理
```

### 4.2 实例化详情

#### 4.2.1 ct_vfdsu_ctrl 实例
```verilog
ct_vfdsu_ctrl x_ct_vfdsu_ctrl (
    .cpurst_b                    (cpurst_b),
    .vfdsu_xx_gateclk_v          (vfdsu_xx_gateclk_v),
    .forever_cpuclk              (forever_cpuclk),
    .pad_yy_icg_scanen           (pad_yy_icg_scanen),
    // ... 其他端口连接
);
```

#### 4.2.2 ct_vfdsu_double 实例
```verilog
ct_vfdsu_double x_ct_vfdsu_double (
    .cpurst_b                    (cpurst_b),
    .vfdsu_xx_gateclk_v          (vfdsu_xx_gateclk_v),
    .forever_cpuclk              (forever_cpuclk),
    .pad_yy_icg_scanen           (pad_yy_icg_scanen),
    // ... 其他端口连接
);
```

#### 4.2.3 ct_vfdsu_scalar_dp 实例
```verilog
ct_vfdsu_scalar_dp x_ct_vfdsu_scalar_dp (
    .cpurst_b                    (cpurst_b),
    .forever_cpuclk              (forever_cpuclk),
    .pad_yy_icg_scanen           (pad_yy_icg_scanen),
    // ... 其他端口连接
);
```

## 5. 流水线架构

### 5.1 流水线阶段

| 阶段 | 名称 | 功能描述 |
|------|------|----------|
| EX1 | 准备阶段 | 操作数预处理、特殊值检测、规格化 |
| EX2 | SRT迭代阶段 | SRT radix-16除法/平方根迭代计算 |
| EX3 | 舍入阶段 | IEEE 754舍入处理 |
| EX4 | 打包阶段 | 结果格式化、异常标志生成、写回 |

### 5.2 流水线时序图

```
时钟周期:    T1      T2      T3      T4      T5      T6      ...
            ┌───────┬───────┬───────┬───────┬───────┬───────┐
操作1:       │  EX1  │  EX2  │  EX2  │  EX2  │  EX3  │  EX4  │
            │       │ (迭代)│ (迭代)│ (迭代)│       │       │
            └───────┴───────┴───────┴───────┴───────┴───────┘
                                    ┌───────┬───────┬───────┐
操作2:                              │  EX1  │  EX2  │  ...  │
                                    └───────┴───────┴───────┘
```

**注**: EX2阶段迭代次数根据精度不同而变化：
- 双精度：13次迭代
- 单精度：6次迭代
- 半精度：3次迭代

## 6. 门控时钟设计

### 6.1 门控时钟单元
模块使用门控时钟单元（gated_clk_cell）进行时钟管理，以降低功耗：

```verilog
gated_clk_cell u_ex1_gateclk (
    .clk_in     (forever_cpuclk),
    .clk_out    (ex1_clk),
    .external_en(1'b1),
    .global_en  (cp0_yy_clk),
    .local_en   (ex1_clk_en),
    .module_en  (vfdsu_xx_gateclk_v),
    .pad_yy_icg_scanen(pad_yy_icg_scanen)
);
```

### 6.2 时钟域
- `ex1_clk`: EX1阶段时钟
- `ex2_clk`: EX2阶段时钟
- `ex3_clk`: EX3阶段时钟
- `ex4_clk`: EX4阶段时钟

## 7. 设计要点

### 7.1 操作类型支持
- **除法 (FDIV)**: 被除数 ÷ 除数
- **平方根 (FSQRT)**: √操作数

### 7.2 精度支持
| 精度 | 数据位宽 | 符号位 | 指数位 | 尾数位 |
|------|----------|--------|--------|--------|
| 双精度 | 64位 | 1位 | 11位 | 52位 |
| 单精度 | 32位 | 1位 | 8位 | 23位 |
| 半精度 | 16位 | 1位 | 5位 | 10位 |

### 7.3 舍入模式
| 编码 | 模式 | 描述 |
|------|------|------|
| 000 | RNE | 向最近偶数舍入 |
| 001 | RTZ | 向零舍入 |
| 010 | RDN | 向下舍入 |
| 011 | RUP | 向上舍入 |
| 100 | RMM | 向最大幅值舍入 |

## 8. 异常处理

### 8.1 异常类型
- **NV (Invalid Operation)**: 无效操作，如NaN输入、负数开方
- **DZ (Divide by Zero)**: 除零异常
- **OF (Overflow)**: 上溢
- **UF (Underflow)**: 下溢
- **NX (Inexact)**: 不精确结果

### 8.2 特殊值处理
| 输入情况 | 处理结果 |
|----------|----------|
| NaN输入 | 输出NaN，置NV标志 |
| 无穷大/零组合 | 按IEEE 754规则处理 |
| 负数开方 | 输出NaN，置NV标志 |
| 除数为零 | 输出无穷大，置DZ标志 |

## 9. 关键信号时序

### 9.1 操作启动时序
```
            ┌───────┐
vfdsu_xx_ex1_src_vld ────┘       └───────
            ┌───────┐
vfdsu_xx_ex1_ready  ────┘       └───────
            ┌───────────────────────────────┐
vfdsu_xx_ex1_src_data ──────────────────────┘
```

### 9.2 写回时序
```
            ┌───────┐
vfdsu_xx_wb_grant   ────┘       └───────
            ┌───────┐
vfdsu_xx_wb_dst_vld ────┘       └───────
            ┌───────────────────────────────┐
vfdsu_xx_wb_data    ──────────────────────┘
```

## 10. 设计约束

### 10.1 时序约束
- 关键路径：SRT迭代路径
- 最大工作频率：需根据综合结果确定

### 10.2 面积约束
- 目标面积：需根据工艺库确定
- 优化方向：迭代逻辑复用

## 11. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
