# ct_vfdsu_double 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_double` - 双精度浮点除法/平方根数据通路模块

### 1.2 功能描述
`ct_vfdsu_double` 是VFDSU的核心数据通路模块，负责实现双精度浮点除法和平方根运算的完整数据流。该模块集成了输入准备、SRT迭代计算、舍入处理和结果打包四个子模块，形成完整的运算流水线。

### 1.3 主要特性
- 完整的双精度浮点运算数据通路
- 集成四个子模块：prepare、srt、round、pack
- 支持除法和平方根两种运算
- 支持双精度、单精度、半精度三种格式
- 流水线寄存器管理
- 异常标志传递

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                              ct_vfdsu_double                                      │
                    │                                                                                  │
    src_data[63:0]  │  ┌───────────────────────────────────────────────────────────────────────────┐  │
    ──────────────────►│                          EX1: ct_vfdsu_prepare                              │  │
    src_frac[51:0]  │  │                                                                           │  │
    ──────────────────►│  • 操作数预处理                          • 特殊值检测                        │  │
    src_expt[10:0]  │  │  • 指数计算                              • 规格化处理                        │  │
    ──────────────────►│  • 异常检测                              • FF1查找                           │  │
    src_sign       │  │                                                                           │  │
    ──────────────────►│  输出: ex1_divisor[55:0], ex1_dividend[55:0], ex1_expt_sum[11:0]            │  │
    div            │  └───────────────────────────────────────────────────────────────────────────┘  │
    ──────────────────►│                              │                                               │  │
    sqrt           │                              │ ex1_pipedown                                  │  │
    ──────────────────►│                              ▼                                               │  │
    double         │  ┌───────────────────────────────────────────────────────────────────────────┐  │
    ──────────────────►│                          EX2: ct_vfdsu_srt                                 │  │
    single         │  │                                                                           │  │
    ──────────────────►│  • SRT radix-16迭代                      • 商/根选择                         │  │
    rm[2:0]        │  │  • 余数计算                              • 部分商累加                        │  │
    ──────────────────►│  • 边界表查找                            • 溢出/下溢检测                     │  │
                    │  │                                                                           │  │
    ex1_pipedown   │  │  输出: ex2_qt[55:0], ex2_expt[10:0], ex2_rem_sign, ex2_rem_zero            │  │
    ──────────────────►│                              │                                               │  │
    ex2_pipedown   │                              │ ex2_pipedown                                  │  │
    ──────────────────►│                              ▼                                               │  │
    ex3_pipedown   │  ┌───────────────────────────────────────────────────────────────────────────┐  │
    ──────────────────►│                          EX3: ct_vfdsu_round                                │  │
    ex4_pipedown   │  │                                                                           │  │
    ──────────────────►│  • IEEE 754舍入                          • 舍入模式处理                      │  │
                    │  │  • 非规格化舍入                          • Guard/Sticky位处理               │  │
    srt_cnt_zero   │  │  • 指数调整                              • 进位传播                          │  │
    ──────────────────►│                                                                           │  │
                    │  │  输出: ex3_qt_rnd[52:0], ex3_expt_rnd[11:0]                               │  │
                    │                              │                                               │  │
                    │                              │ ex3_pipedown                                  │  │
                    │                              ▼                                               │  │
                    │  ┌───────────────────────────────────────────────────────────────────────────┐  │
                    │  │                          EX4: ct_vfdsu_pack                                 │  │
                    │  │                                                                           │  │
                    │  │  • 结果打包                              • IEEE 754格式化                    │  │
                    │  │  • 异常标志生成                          • 非规格化结果处理                  │  │
                    │  │  • 符号处理                              • 最终输出组装                      │  │
                    │  │                                                                           │  │
                    │  │  输出: ex4_out_result[63:0], ex4_out_expt[4:0]                            │  │
                    │  └───────────────────────────────────────────────────────────────────────────┘  │
                    │                                                                                  │
                    │  输出信号                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ wb_data[63:0] | wb_expt[4:0] | rem_sign | rem_zero | overflow/underflow │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 子模块层次结构

```
ct_vfdsu_double
├── ct_vfdsu_prepare          -- EX1: 输入准备模块
│   └── ct_vfdsu_ff1 (x2)     -- 查找第一个1的位置
├── ct_vfdsu_srt              -- EX2: SRT迭代模块
│   └── ct_vfdsu_srt_radix16_with_sqrt
│       └── ct_vfdsu_srt_radix16_bound_table
├── ct_vfdsu_round            -- EX3: 舍入模块
└── ct_vfdsu_pack             -- EX4: 结果打包模块
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `vfdsu_xx_gateclk_v` | 1 | 门控时钟模块使能 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `src_data[63:0]` | 64 | 源操作数数据 |
| `src_frac[51:0]` | 52 | 源操作数尾数部分 |
| `src_expt[10:0]` | 11 | 源操作数指数部分 |
| `src_sign` | 1 | 源操作数符号位 |
| `div` | 1 | 除法操作指示 |
| `sqrt` | 1 | 平方根操作指示 |
| `double` | 1 | 双精度操作指示 |
| `single` | 1 | 单精度操作指示 |
| `rm[2:0]` | 3 | 舍入模式 |
| `ex1_pipedown` | 1 | EX1阶段流水线下移 |
| `ex2_pipedown` | 1 | EX2阶段流水线下移 |
| `ex3_pipedown` | 1 | EX3阶段流水线下移 |
| `ex4_pipedown` | 1 | EX4阶段流水线下移 |
| `srt_cnt_zero` | 1 | SRT计数器归零标志 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `wb_data[63:0]` | 64 | 写回数据 |
| `wb_expt[4:0]` | 5 | 写回异常标志 |
| `rem_sign` | 1 | 余数符号 |
| `rem_zero` | 1 | 余数为零标志 |
| `overflow` | 1 | 上溢标志 |
| `underflow` | 1 | 下溢标志 |

## 5. 子模块实例化

### 5.1 ct_vfdsu_prepare 实例

```verilog
ct_vfdsu_prepare x_ct_vfdsu_prepare (
    .cpurst_b              (cpurst_b),
    .vfdsu_xx_gateclk_v    (vfdsu_xx_gateclk_v),
    .forever_cpuclk        (forever_cpuclk),
    .pad_yy_icg_scanen     (pad_yy_icg_scanen),
    .src_data              (src_data),
    .src_frac              (src_frac),
    .src_expt              (src_expt),
    .src_sign              (src_sign),
    .div                   (div),
    .sqrt                  (sqrt),
    .double                (double),
    .single                (single),
    .ex1_pipedown          (ex1_pipedown),
    // 输出
    .ex1_divisor           (ex1_divisor),
    .ex1_dividend          (ex1_dividend),
    .ex1_expt_sum          (ex1_expt_sum),
    .ex1_sign              (ex1_sign),
    .ex1_nv                (ex1_nv),
    .ex1_dz                (ex1_dz)
);
```

### 5.2 ct_vfdsu_srt 实例

```verilog
ct_vfdsu_srt x_ct_vfdsu_srt (
    .cpurst_b              (cpurst_b),
    .vfdsu_xx_gateclk_v    (vfdsu_xx_gateclk_v),
    .forever_cpuclk        (forever_cpuclk),
    .pad_yy_icg_scanen     (pad_yy_icg_scanen),
    .ex1_divisor           (ex1_divisor),
    .ex1_dividend          (ex1_dividend),
    .ex1_expt_sum          (ex1_expt_sum),
    .ex1_sign              (ex1_sign),
    .div                   (div),
    .sqrt                  (sqrt),
    .double                (double),
    .single                (single),
    .ex2_pipedown          (ex2_pipedown),
    .srt_cnt_zero          (srt_cnt_zero),
    // 输出
    .ex2_qt                (ex2_qt),
    .ex2_expt              (ex2_expt),
    .ex2_rem_sign          (ex2_rem_sign),
    .ex2_rem_zero          (ex2_rem_zero),
    .ex2_overflow          (ex2_overflow),
    .ex2_underflow         (ex2_underflow)
);
```

### 5.3 ct_vfdsu_round 实例

```verilog
ct_vfdsu_round x_ct_vfdsu_round (
    .cpurst_b              (cpurst_b),
    .vfdsu_xx_gateclk_v    (vfdsu_xx_gateclk_v),
    .forever_cpuclk        (forever_cpuclk),
    .pad_yy_icg_scanen     (pad_yy_icg_scanen),
    .ex2_qt                (ex2_qt),
    .ex2_expt              (ex2_expt),
    .ex2_rem_sign          (ex2_rem_sign),
    .ex2_rem_zero          (ex2_rem_zero),
    .ex2_overflow          (ex2_overflow),
    .ex2_underflow         (ex2_underflow),
    .rm                    (rm),
    .double                (double),
    .single                (single),
    .ex3_pipedown          (ex3_pipedown),
    // 输出
    .ex3_qt_rnd            (ex3_qt_rnd),
    .ex3_expt_rnd          (ex3_expt_rnd),
    .ex3_overflow          (ex3_overflow),
    .ex3_underflow         (ex3_underflow)
);
```

### 5.4 ct_vfdsu_pack 实例

```verilog
ct_vfdsu_pack x_ct_vfdsu_pack (
    .cpurst_b              (cpurst_b),
    .vfdsu_xx_gateclk_v    (vfdsu_xx_gateclk_v),
    .forever_cpuclk        (forever_cpuclk),
    .pad_yy_icg_scanen     (pad_yy_icg_scanen),
    .ex3_qt_rnd            (ex3_qt_rnd),
    .ex3_expt_rnd          (ex3_expt_rnd),
    .ex3_overflow          (ex3_overflow),
    .ex3_underflow         (ex3_underflow),
    .ex1_sign              (ex1_sign),
    .ex1_nv                (ex1_nv),
    .ex1_dz                (ex1_dz),
    .double                (double),
    .single                (single),
    .ex4_pipedown          (ex4_pipedown),
    // 输出
    .ex4_out_result        (wb_data),
    .ex4_out_expt          (wb_expt)
);
```

## 6. 流水线寄存器

### 6.1 EX1→EX2 流水线寄存器

| 寄存器名 | 位宽 | 描述 |
|----------|------|------|
| `ex1_divisor_reg[55:0]` | 56 | 规格化除数 |
| `ex1_dividend_reg[55:0]` | 56 | 规格化被除数/根号下数 |
| `ex1_expt_sum_reg[11:0]` | 12 | 指数和/差 |
| `ex1_sign_reg` | 1 | 结果符号 |
| `ex1_nv_reg` | 1 | 无效操作标志 |
| `ex1_dz_reg` | 1 | 除零标志 |
| `ex1_div_reg` | 1 | 除法操作 |
| `ex1_sqrt_reg` | 1 | 平方根操作 |
| `ex1_double_reg` | 1 | 双精度标志 |
| `ex1_single_reg` | 1 | 单精度标志 |
| `ex1_rm_reg[2:0]` | 3 | 舍入模式 |

### 6.2 EX2→EX3 流水线寄存器

| 寄存器名 | 位宽 | 描述 |
|----------|------|------|
| `ex2_qt_reg[55:0]` | 56 | 商/根 |
| `ex2_expt_reg[10:0]` | 11 | 指数 |
| `ex2_rem_sign_reg` | 1 | 余数符号 |
| `ex2_rem_zero_reg` | 1 | 余数为零 |
| `ex2_overflow_reg` | 1 | 上溢标志 |
| `ex2_underflow_reg` | 1 | 下溢标志 |

### 6.3 EX3→EX4 流水线寄存器

| 寄存器名 | 位宽 | 描述 |
|----------|------|------|
| `ex3_qt_rnd_reg[52:0]` | 53 | 舍入后尾数 |
| `ex3_expt_rnd_reg[11:0]` | 12 | 舍入后指数 |
| `ex3_overflow_reg` | 1 | 上溢标志 |
| `ex3_underflow_reg` | 1 | 下溢标志 |

## 7. 数据流描述

### 7.1 除法运算数据流

```
输入: src_data[63:0] = {dividend[63:0], divisor[63:0]}

EX1 (prepare):
  dividend → FF1 → 规格化 → ex1_dividend[55:0]
  divisor  → FF1 → 规格化 → ex1_divisor[55:0]
  expt_dividend - expt_divisor + BIAS → ex1_expt_sum[11:0]

EX2 (srt):
  SRT迭代: ex1_dividend / ex1_divisor
  每次迭代产生4位商
  输出: ex2_qt[55:0], ex2_expt[10:0]

EX3 (round):
  根据舍入模式调整商
  输出: ex3_qt_rnd[52:0], ex3_expt_rnd[11:0]

EX4 (pack):
  组装IEEE 754格式结果
  输出: wb_data[63:0] = {sign, expt, frac}
```

### 7.2 平方根运算数据流

```
输入: src_data[63:0] = operand[63:0]

EX1 (prepare):
  operand → FF1 → 规格化 → ex1_dividend[55:0]
  (expt + BIAS) / 2 → ex1_expt_sum[11:0]
  奇数指数时尾数左移1位

EX2 (srt):
  SRT迭代: √ex1_dividend
  每次迭代产生4位根
  输出: ex2_qt[55:0], ex2_expt[10:0]

EX3 (round):
  根据舍入模式调整根
  输出: ex3_qt_rnd[52:0], ex3_expt_rnd[11:0]

EX4 (pack):
  组装IEEE 754格式结果
  输出: wb_data[63:0] = {sign, expt, frac}
```

## 8. 门控时钟设计

### 8.1 时钟生成

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

gated_clk_cell u_ex2_gateclk (
    .clk_in     (forever_cpuclk),
    .clk_out    (ex2_clk),
    .external_en(1'b1),
    .global_en  (cp0_yy_clk),
    .local_en   (ex2_clk_en),
    .module_en  (vfdsu_xx_gateclk_v),
    .pad_yy_icg_scanen(pad_yy_icg_scanen)
);
```

### 8.2 时钟使能逻辑

```verilog
assign ex1_clk_en = ex1_pipedown;
assign ex2_clk_en = ex2_pipedown || srt_cnt_zero;
assign ex3_clk_en = ex3_pipedown;
assign ex4_clk_en = ex4_pipedown;
```

## 9. 精度处理

### 9.1 双精度格式 (64位)

```
| 符号 | 指数[10:0] | 尾数[51:0] |
| S    | E          | F          |
| 1位  | 11位       | 52位       |

偏置值: 1023
指数范围: -1022 ~ +1023
```

### 9.2 单精度格式 (32位)

```
| 符号 | 指数[7:0] | 尾数[22:0] |
| S    | E         | F          |
| 1位  | 8位       | 23位       |

偏置值: 127
指数范围: -126 ~ +127
```

### 9.3 半精度格式 (16位)

```
| 符号 | 指数[4:0] | 尾数[9:0] |
| S    | E         | F         |
| 1位  | 5位       | 10位      |

偏置值: 15
指数范围: -14 ~ +15
```

## 10. 设计要点

### 10.1 数据通路宽度
- 内部使用56位宽进行计算，保证精度
- 支持双精度52位尾数的完整计算

### 10.2 流水线控制
- 各阶段独立控制
- 支持流水线暂停和刷新
- 异常情况正确传递

### 10.3 功耗优化
- 门控时钟减少动态功耗
- 仅在需要时使能各阶段

## 11. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
