# ct_vfdsu_prepare 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_prepare` - 浮点除法/平方根输入准备模块

### 1.2 功能描述
`ct_vfdsu_prepare` 是VFDSU流水线的EX1阶段模块，负责对输入操作数进行预处理。主要功能包括：操作数解析、特殊值检测、非规格化数处理、指数计算、操作数规格化以及异常检测。

### 1.3 主要特性
- 支持双精度、单精度、半精度三种格式
- 特殊值检测（零、无穷大、NaN）
- 非规格化数规格化处理
- FF1（Find First One）查找逻辑
- 指数预计算
- 异常标志生成（NV、DZ）
- 结果符号确定

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                            ct_vfdsu_prepare                                      │
                    │                                                                                  │
    src_data[63:0]  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        操作数解析与分离                                    │    │
                    │  │                                                                          │    │
                    │  │  src_data[63:0]                                                          │    │
                    │  │      │                                                                   │    │
                    │  │      ├──► src_sign (符号位)                                               │    │
                    │  │      ├──► src_expt[10:0] (指数)                                          │    │
                    │  │      └──► src_frac[51:0] (尾数)                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        特殊值检测                                        │    │
                    │  │                                                                          │    │
                    │  │  • src_zero: 操作数为零                                                  │    │
                    │  │  • src_inf: 操作数为无穷大                                               │    │
                    │  │  • src_nan: 操作数为NaN                                                  │    │
                    │  │  • src_denorm: 操作数为非规格化数                                        │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │              ┌───────────────┴───────────────┐                                  │
                    │              ▼                               ▼                                  │
                    │  ┌───────────────────────┐      ┌───────────────────────┐                       │
                    │  │   ct_vfdsu_ff1 (x2)   │      │     指数计算逻辑       │                       │
                    │  │                       │      │                       │                       │
    src_frac[51:0]  │  │  frac → FF1 → shift   │      │  除法: exp_a - exp_b  │                       │
    ──────────────────►│  frac → FF1 → value   │      │  平方根: exp/2        │                       │
                    │  │                       │      │                       │                       │
                    │  │  输出:                 │      │  输出:                 │                       │
                    │  │  • shift_num[5:0]     │      │  • expt_sum[11:0]     │                       │
                    │  │  • frac_bin_val       │      │  • expt_odd           │                       │
                    │  └───────────────────────┘      └───────────────────────┘                       │
                    │              │                               │                                  │
                    │              └───────────────┬───────────────┘                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        规格化处理                                        │    │
                    │  │                                                                          │    │
                    │  │  • 非规格化数左移规格化                                                  │    │
                    │  │  • 调整指数                                                              │    │
                    │  │  • 生成规格化操作数                                                      │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        异常检测                                          │    │
                    │  │                                                                          │    │
                    │  │  • NV: 无效操作 (NaN输入、负数开方)                                       │    │
                    │  │  • DZ: 除零 (除数为零且被除数非零)                                        │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌────────────────────────────────────────────────────────────────────────┐   │
                    │  │ ex1_divisor[55:0] | ex1_dividend[55:0] | ex1_expt_sum[11:0]            │   │
                    │  │ ex1_sign | ex1_nv | ex1_dz | ex1_special_case                         │   │
                    │  └────────────────────────────────────────────────────────────────────────┘   │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `vfdsu_xx_gateclk_v` | 1 | 门控时钟模块使能 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `src_data[63:0]` | 64 | 源操作数数据（包含被除数和除数） |
| `src_frac[51:0]` | 52 | 源操作数尾数部分 |
| `src_expt[10:0]` | 11 | 源操作数指数部分 |
| `src_sign` | 1 | 源操作数符号位 |
| `div` | 1 | 除法操作指示 |
| `sqrt` | 1 | 平方根操作指示 |
| `double` | 1 | 双精度操作指示 |
| `single` | 1 | 单精度操作指示 |
| `ex1_pipedown` | 1 | EX1阶段流水线下移信号 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `ex1_divisor[55:0]` | 56 | 规格化除数（除法）或常量（平方根） |
| `ex1_dividend[55:0]` | 56 | 规格化被除数（除法）或根号下数（平方根） |
| `ex1_expt_sum[11:0]` | 12 | 指数和/差（预计算结果） |
| `ex1_sign` | 1 | 结果符号位 |
| `ex1_nv` | 1 | 无效操作异常标志 |
| `ex1_dz` | 1 | 除零异常标志 |
| `ex1_special_case` | 1 | 特殊情况标志 |
| `ex1_skip_srt` | 1 | 跳过SRT迭代标志 |

## 4. 子模块实例化

### 4.1 ct_vfdsu_ff1 实例（被除数/根号下数）

```verilog
ct_vfdsu_ff1 x_ct_vfdsu_ff1_dividend (
    .frac           (src_frac_dividend),
    .fanc_shift_num (dividend_shift_num),
    .frac_bin_val   (dividend_bin_val)
);
```

### 4.2 ct_vfdsu_ff1 实例（除数）

```verilog
ct_vfdsu_ff1 x_ct_vfdsu_ff1_divisor (
    .frac           (src_frac_divisor),
    .fanc_shift_num (divisor_shift_num),
    .frac_bin_val   (divisor_bin_val)
);
```

## 5. 关键逻辑设计

### 5.1 操作数解析

#### 5.1.1 双精度格式解析
```verilog
// 双精度: [63]符号, [62:52]指数, [51:0]尾数
assign src_sign_a = src_data[63];
assign src_expt_a = src_data[62:52];
assign src_frac_a = src_data[51:0];

assign src_sign_b = src_data[31];  // 单精度时为除数
assign src_expt_b = src_data[30:23];
assign src_frac_b = src_data[22:0];
```

#### 5.1.2 单精度格式解析
```verilog
// 单精度: [31]符号, [30:23]指数, [22:0]尾数
assign sp_sign = src_data[31];
assign sp_expt = src_data[30:23];
assign sp_frac = src_data[22:0];
```

### 5.2 特殊值检测

#### 5.2.1 零检测
```verilog
// 双精度零检测
assign src_zero_dp = (src_expt == 11'b0) && (src_frac == 52'b0);

// 单精度零检测
assign src_zero_sp = (src_expt_sp == 8'b0) && (src_frac_sp == 23'b0);
```

#### 5.2.2 无穷大检测
```verilog
// 双精度无穷大检测
assign src_inf_dp = (src_expt == 11'b11111111111) && (src_frac == 52'b0);

// 单精度无穷大检测
assign src_inf_sp = (src_expt_sp == 8'b11111111) && (src_frac_sp == 23'b0);
```

#### 5.2.3 NaN检测
```verilog
// 双精度NaN检测
assign src_nan_dp = (src_expt == 11'b11111111111) && (src_frac != 52'b0);

// 单精度NaN检测
assign src_nan_sp = (src_expt_sp == 8'b11111111) && (src_frac_sp != 23'b0);
```

#### 5.2.4 非规格化数检测
```verilog
// 双精度非规格化数检测
assign src_denorm_dp = (src_expt == 11'b0) && (src_frac != 52'b0);

// 单精度非规格化数检测
assign src_denorm_sp = (src_expt_sp == 8'b0) && (src_frac_sp != 23'b0);
```

### 5.3 指数计算

#### 5.3.1 除法指数计算
```verilog
// 除法: exponent_result = exponent_dividend - exponent_divisor + BIAS
// 双精度: BIAS = 1023
// 单精度: BIAS = 127
// 半精度: BIAS = 15

assign expt_diff = expt_dividend - expt_divisor;
assign expt_sum_div = expt_diff + BIAS;
```

#### 5.3.2 平方根指数计算
```verilog
// 平方根: exponent_result = (exponent_operand + BIAS) / 2
// 奇数指数时需要特殊处理

assign expt_sum_sqrt = (expt_operand + BIAS) >> 1;
assign expt_odd = (expt_operand + BIAS)[0];  // 指数为奇数
```

### 5.4 规格化处理

#### 5.4.1 非规格化数规格化
```verilog
// 使用FF1结果进行左移规格化
assign normalized_frac = src_frac << shift_num;
assign adjusted_expt = src_expt - shift_num + 1;
```

#### 5.4.2 平方根特殊处理
```verilog
// 平方根时，如果指数为奇数，尾数左移1位
assign sqrt_frac = expt_odd ? {src_frac, 1'b0} : {1'b0, src_frac};
```

### 5.5 异常检测

#### 5.5.1 无效操作（NV）
```verilog
// NV条件:
// 1. 任一操作数为NaN
// 2. 平方根操作数为负数
// 3. 0/0 或 ∞/∞

assign nv_nan = src_nan_a || src_nan_b;
assign nv_sqrt_neg = sqrt && src_sign_a;
assign nv_div_invalid = div && ((src_zero_a && src_zero_b) || (src_inf_a && src_inf_b));

assign ex1_nv = nv_nan || nv_sqrt_neg || nv_div_invalid;
```

#### 5.5.2 除零（DZ）
```verilog
// DZ条件: 除法且除数为零，被除数非零非无穷
assign ex1_dz = div && src_zero_b && !src_zero_a && !src_inf_a && !src_nan_a;
```

### 5.6 结果符号计算

```verilog
// 除法: 结果符号 = 被除数符号 XOR 除数符号
// 平方根: 结果符号 = 0 (正数)

assign ex1_sign = div ? (src_sign_a ^ src_sign_b) : 1'b0;
```

## 6. 特殊情况处理

### 6.1 特殊情况列表

| 操作类型 | 操作数A | 操作数B | 结果 | 异常 |
|----------|---------|---------|------|------|
| DIV | NaN | 任意 | NaN | NV |
| DIV | 任意 | NaN | NaN | NV |
| DIV | ±∞ | ±∞ | NaN | NV |
| DIV | ±0 | ±0 | NaN | NV |
| DIV | 任意 | ±0 | ±∞ | DZ |
| DIV | ±0 | 任意 | ±0 | - |
| DIV | ±∞ | 任意 | ±∞ | - |
| SQRT | NaN | - | NaN | NV |
| SQRT | -0 | - | -0 | - |
| SQRT | 负数 | - | NaN | NV |
| SQRT | +∞ | - | +∞ | - |

### 6.2 特殊情况跳过SRT
```verilog
// 当检测到特殊情况时，跳过SRT迭代
assign ex1_skip_srt = ex1_nv || ex1_dz || src_zero_a || src_inf_a || src_inf_b;
```

## 7. 数据格式转换

### 7.1 精度适配

```verilog
// 根据精度类型选择正确的位宽和偏置值
assign BIAS = double ? 11'd1023 : 
              single ? 11'd127 : 11'd15;

// 尾数扩展到内部56位宽度
assign frac_extended = double ? {1'b1, src_frac, 3'b0} :
                       single ? {1'b1, {src_frac, 29'b0}, 3'b0} :
                               {1'b1, {src_frac, 42'b0}, 3'b0};
```

## 8. 时序图

### 8.1 正常操作时序

```
时钟:        T1              T2
            ┌───────────────┬───────────────┐
src_data    ────────────────────────────────
            ┌───────────────┐
ex1_pipedown                └───────────────
            
            │   解析/检测    │   输出寄存    │
            │   FF1查找      │               │
            │   指数计算     │               │
            │   规格化       │               │
            
ex1_divisor                 ────────────────
ex1_dividend                ────────────────
ex1_expt_sum                ────────────────
```

## 9. 设计要点

### 9.1 FF1优化
- 使用casez语句实现高效的FF1查找
- 同时输出移位量和二进制值

### 9.2 精度处理
- 内部使用统一的高精度格式
- 输入时扩展，输出时截断

### 9.3 异常优先级
- NV优先级最高
- DZ次之
- 其他异常在后续阶段处理

## 10. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
