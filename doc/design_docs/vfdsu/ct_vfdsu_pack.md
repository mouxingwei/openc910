# ct_vfdsu_pack 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_pack` - 浮点结果打包模块

### 1.2 功能描述
`ct_vfdsu_pack` 是VFDSU流水线EX4阶段的模块，负责将舍入后的尾数和指数打包成IEEE 754标准格式的浮点结果。该模块处理特殊值输出、非规格化结果格式化、异常标志生成以及最终结果组装。

### 1.3 主要特性
- IEEE 754格式结果打包
- 特殊值输出处理（NaN、无穷大、零）
- 非规格化结果格式化
- 异常标志生成（NV、DZ、OF、UF、NX）
- 多精度支持（双精度、单精度、半精度）

## 2. IEEE 754格式

### 2.1 双精度格式 (64位)

```
| 符号 | 指数[10:0] | 尾数[51:0] |
|  1   |    11      |    52      |

偏置值: 1023
指数范围: 1 ~ 2046 (规格化)
特殊值:
  - 零: 指数=0, 尾数=0
  - 非规格化: 指数=0, 尾数≠0
  - 无穷大: 指数=2047, 尾数=0
  - NaN: 指数=2047, 尾数≠0
```

### 2.2 单精度格式 (32位)

```
| 符号 | 指数[7:0] | 尾数[22:0] |
|  1   |    8      |    23      |

偏置值: 127
指数范围: 1 ~ 254 (规格化)
```

### 2.3 半精度格式 (16位)

```
| 符号 | 指数[4:0] | 尾数[9:0] |
|  1   |    5      |    10     |

偏置值: 15
指数范围: 1 ~ 30 (规格化)
```

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                            ct_vfdsu_pack                                        │
                    │                                                                                  │
    ex3_qt_rnd[52:0]│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                      特殊值检测                                        │    │
    ex3_expt_rnd[11:0]│  │                                                                          │    │
    ──────────────────►│  • is_nan: 无效操作                                                      │    │
    ex3_overflow      │  │  • is_inf: 溢出                                                         │    │
    ──────────────────►│  • is_zero: 结果为零                                                    │    │
    ex3_underflow     │  │  • is_denorm: 非规格化结果                                              │    │
    ──────────────────►│                                                                          │    │
    ex1_sign          │  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                                  │
    ex1_nv            │              ┌───────────────┴───────────────┐                                  │
    ──────────────────►│              ▼                               ▼                                  │
    ex1_dz            │  ┌───────────────────────┐      ┌───────────────────────┐                       │
    ──────────────────►│  │    特殊值生成         │      │    正常值打包         │                       │
    double            │  │                       │      │                       │                       │
    ──────────────────►│  │  NaN:                 │      │  规格化结果:          │                       │
    single            │  │    {sign, 11'b1, frac}│      │  {sign, expt, frac}   │                       │
    ──────────────────►│  │                       │      │                       │                       │
    ex4_pipedown      │  │  无穷大:              │      │  非规格化结果:        │                       │
    ──────────────────►│  │    {sign, 11'b1, 0}  │      │  {sign, 0, frac}      │                       │
                    │  │                       │      │                       │                       │
                    │  │  零:                  │      │                       │                       │
                    │  │    {sign, 0, 0}       │      │                       │                       │
                    │  └───────────────────────┘      └───────────────────────┘                       │
                    │              │                               │                                  │
                    │              └───────────────┬───────────────┘                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                      结果选择                                        │    │
                    │  │                                                                          │    │
                    │  │  result = is_nan  ? NAN_RESULT :                                        │    │
                    │  │           is_inf  ? INF_RESULT :                                        │    │
                    │  │           is_zero ? ZERO_RESULT :                                       │    │
                    │  │           normal_result;                                                │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                      异常标志生成                                    │    │
                    │  │                                                                          │    │
                    │  │  • NV: 无效操作 (NaN输入、负数开方)                                     │    │
                    │  │  • DZ: 除零                                                             │    │
                    │  │  • OF: 上溢                                                             │    │
                    │  │  • UF: 下溢                                                             │    │
                    │  │  • NX: 不精确 (舍入发生)                                                │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌────────────────────────────────────────────────────────────────────────┐   │
                    │  │ ex4_out_result[63:0] | ex4_out_expt[4:0]                               │   │
                    │  └────────────────────────────────────────────────────────────────────────┘   │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `vfdsu_xx_gateclk_v` | 1 | 门控时钟模块使能 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `ex3_qt_rnd[52:0]` | 53 | 舍入后的尾数 |
| `ex3_expt_rnd[11:0]` | 12 | 舍入后的指数 |
| `ex3_overflow` | 1 | 上溢标志 |
| `ex3_underflow` | 1 | 下溢标志 |
| `ex1_sign` | 1 | 结果符号 |
| `ex1_nv` | 1 | 无效操作标志 |
| `ex1_dz` | 1 | 除零标志 |
| `double` | 1 | 双精度标志 |
| `single` | 1 | 单精度标志 |
| `ex4_pipedown` | 1 | EX4阶段流水线下移信号 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `ex4_out_result[63:0]` | 64 | 最终结果（IEEE 754格式） |
| `ex4_out_expt[4:0]` | 5 | 异常标志（NV, DZ, OF, UF, NX） |

## 5. 关键逻辑设计

### 5.1 特殊值检测

```verilog
// NaN检测
assign is_nan = ex1_nv;

// 无穷大检测（溢出）
assign is_inf = ex3_overflow && !ex1_nv;

// 零检测
assign is_zero = (ex3_expt_rnd == 0) && (ex3_qt_rnd == 0) && !ex1_nv;

// 非规格化检测
assign is_denorm = (ex3_expt_rnd == 0) && (ex3_qt_rnd != 0) && !ex1_nv;
```

### 5.2 特殊值生成

#### 5.2.1 NaN生成
```verilog
// 双精度NaN: 指数全1，尾数非零
assign nan_result_dp = {ex1_sign, 11'b11111111111, 52'h8000000000000};

// 单精度NaN
assign nan_result_sp = {32'b0, ex1_sign, 8'b11111111, 23'h400000};

// 半精度NaN
assign nan_result_hp = {48'b0, ex1_sign, 5'b11111, 10'h200};
```

#### 5.2.2 无穷大生成
```verilog
// 双精度无穷大: 指数全1，尾数为零
assign inf_result_dp = {ex1_sign, 11'b11111111111, 52'b0};

// 单精度无穷大
assign inf_result_sp = {32'b0, ex1_sign, 8'b11111111, 23'b0};

// 半精度无穷大
assign inf_result_hp = {48'b0, ex1_sign, 5'b11111, 10'b0};
```

#### 5.2.3 零生成
```verilog
// 零: 指数和尾数都为零
assign zero_result_dp = {ex1_sign, 63'b0};
assign zero_result_sp = {32'b0, ex1_sign, 31'b0};
assign zero_result_hp = {48'b0, ex1_sign, 15'b0};
```

### 5.3 正常值打包

#### 5.3.1 双精度打包
```verilog
// 双精度结果打包
// ex3_qt_rnd[52:0] = {隐含位, frac[51:0]}
assign dp_result = {
    ex1_sign,                    // 符号位
    ex3_expt_rnd[10:0],          // 指数
    ex3_qt_rnd[51:0]             // 尾数（去掉隐含位）
};
```

#### 5.3.2 单精度打包
```verilog
// 单精度结果打包
assign sp_result = {
    32'b0,                       // 高位填充
    ex1_sign,                    // 符号位
    ex3_expt_rnd[7:0],           // 指数
    ex3_qt_rnd[51:29]            // 尾数（截取23位）
};
```

#### 5.3.3 半精度打包
```verilog
// 半精度结果打包
assign hp_result = {
    48'b0,                       // 高位填充
    ex1_sign,                    // 符号位
    ex3_expt_rnd[4:0],           // 指数
    ex3_qt_rnd[51:42]            // 尾数（截取10位）
};
```

### 5.4 结果选择

```verilog
always @(*) begin
    // 根据精度选择结果
    if (double) begin
        nan_result = nan_result_dp;
        inf_result = inf_result_dp;
        zero_result = zero_result_dp;
        normal_result = dp_result;
    end else if (single) begin
        nan_result = nan_result_sp;
        inf_result = inf_result_sp;
        zero_result = zero_result_sp;
        normal_result = sp_result;
    end else begin
        nan_result = nan_result_hp;
        inf_result = inf_result_hp;
        zero_result = zero_result_hp;
        normal_result = hp_result;
    end
end

// 最终结果选择
assign ex4_out_result = is_nan  ? nan_result  :
                        is_inf  ? inf_result  :
                        is_zero ? zero_result :
                        normal_result;
```

### 5.5 异常标志生成

```verilog
// NV (Invalid Operation): 无效操作
assign ex4_nv = ex1_nv;

// DZ (Divide by Zero): 除零
assign ex4_dz = ex1_dz;

// OF (Overflow): 上溢
assign ex4_of = ex3_overflow && !ex1_nv;

// UF (Underflow): 下溢
assign ex4_uf = ex3_underflow && !ex1_nv;

// NX (Inexact): 不精确结果
// 当舍入发生或溢出/下溢时置位
assign ex4_nx = (!ex3_qt_rnd[52] || ex3_overflow || ex3_underflow) && 
                !ex1_nv && !ex1_dz;

// 异常标志打包
assign ex4_out_expt = {ex4_nv, ex4_dz, ex4_of, ex4_uf, ex4_nx};
```

## 6. 非规格化结果处理

### 6.1 非规格化结果格式

```verilog
// 非规格化数: 指数为0，尾数不含隐含位
// 需要将尾数右移以对齐

always @(*) begin
    if (is_denorm) begin
        // 计算右移量
        denorm_shift = 1 - ex3_expt_rnd;
        // 右移尾数
        denorm_frac = ex3_qt_rnd >> denorm_shift;
        // 组装结果
        denorm_result = {ex1_sign, {EXP_WIDTH{1'b0}}, denorm_frac};
    end
end
```

### 6.2 非规格化异常

```verilog
// 非规格化结果触发下溢异常
assign ex4_uf = is_denorm || ex3_underflow;
```

## 7. 溢出处理

### 7.1 溢出到无穷大

```verilog
// 根据舍入模式决定溢出结果
always @(*) begin
    if (ex3_overflow) begin
        case (rm)
            3'b010: // RDN: 向负无穷
                overflow_result = ex1_sign ? neg_inf : max_normal;
            3'b011: // RUP: 向正无穷
                overflow_result = ex1_sign ? max_normal : pos_inf;
            default: // RNE, RTZ, RMM
                overflow_result = {ex1_sign, EXP_MAX, FRAC_ZERO};
        endcase
    end
end
```

## 8. 输出格式示例

### 8.1 双精度输出

```
正常结果:
| sign | expt[10:0] | frac[51:0] |
|  1   |    11      |    52      |

NaN:
| sign | 11111111111 | 1000...0 |
|  1   |     11      |    52     |

无穷大:
| sign | 11111111111 | 0000...0 |
|  1   |     11      |    52     |

零:
| sign | 00000000000 | 0000...0 |
|  1   |     11      |    52     |
```

## 9. 时序图

```
时钟:        T1              T2
            ┌───────────────┬───────────────┐
ex3_qt_rnd  ────────────────────────────────
ex3_expt_rnd────────────────────────────────
            
            │   特殊值检测   │   输出寄存   │
            │   结果打包     │               │
            │   异常生成     │               │
            
ex4_out_result              ────────────────
ex4_out_expt                ────────────────
```

## 10. 设计要点

### 10.1 精度适配
- 根据精度类型选择正确的位宽
- 尾数截断或填充

### 10.2 特殊值优先级
- NaN优先级最高
- 其次是无穷大
- 最后是零和正常值

### 10.3 异常标志
- 五种异常标志独立生成
- 遵循IEEE 754标准

## 11. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
