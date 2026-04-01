# ct_vfdsu_srt_radix16_with_sqrt 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_srt_radix16_with_sqrt` - SRT radix-16除法与平方根迭代模块

### 1.2 功能描述
`ct_vfdsu_srt_radix16_with_sqrt` 实现SRT radix-16算法的除法和平方根迭代逻辑。该模块支持两种运算模式，通过迭代计算产生商/根和余数。

### 1.3 主要特性
- SRT radix-16迭代算法
- 支持除法和平方根两种运算
- 每次迭代产生4位商/根
- 商/根位范围: -9 到 +9
- 余数更新和部分商/根累加
- 平方根特殊处理（首轮、次轮）

## 2. 算法原理

### 2.1 除法迭代公式

```
r(i+1) = 16 * r(i) - q(i+1) * d

其中:
- r(i): 第i步的余数
- q(i+1): 第i+1步的商位
- d: 除数
```

### 2.2 平方根迭代公式

```
r(i+1) = 16 * r(i) - q(i+1) * (2*Q(i) + q(i+1)*16^(-i-1))

简化实现:
r(i+1) = 16 * r(i) - q(i+1) * F(i)

其中 F(i) 为平方根迭代因子
```

### 2.3 平方根迭代因子

```
F(0) = 1 (首轮)
F(i) = 2 * Q(i-1) + q(i) * 16^(-i) (后续轮)
```

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                  ct_vfdsu_srt_radix16_with_sqrt                                │
                    │                                                                                  │
    divisor[55:0]   │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        模式选择                                        │    │
    dividend[55:0]  │  │                                                                          │    │
    ──────────────────►│  div=1: 除法模式                                                         │    │
    div              │  │  sqrt=1: 平方根模式                                                      │    │
    ──────────────────►│                                                                          │    │
    sqrt             │  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                                  │
                    │              ┌───────────────┴───────────────┐                                  │
                    │              ▼                               ▼                                  │
                    │  ┌───────────────────────┐      ┌───────────────────────┐                       │
                    │  │      除法数据通路      │      │    平方根数据通路      │                       │
                    │  │                       │      │                       │                       │
                    │  │  • 余数 = rem - q*d   │      │  • 余数 = rem - q*F   │                       │
                    │  │  • 边界基于除数       │      │  • 边界基于部分根     │                       │
                    │  │  • 部分商累加         │      │  • 部分根累加         │                       │
                    │  │                       │      │  • 首轮/次轮特殊处理  │                       │
                    │  └───────────────────────┘      └───────────────────────┘                       │
                    │              │                               │                                  │
                    │              └───────────────┬───────────────┘                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                   ct_vfdsu_srt_radix16_bound_table                      │    │
                    │  │                                                                          │    │
                    │  │  • 除法: bound_sel = divisor[55:49]                                      │    │
                    │  │  • 平方根: bound_sel = partial_qt[55:49]                                 │    │
                    │  │  • sqrt_first_round / sqrt_second_round 特殊处理                        │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        迭代控制                                        │    │
                    │  │                                                                          │    │
                    │  │  ┌───────────────┐      ┌───────────────┐      ┌───────────────┐        │    │
                    │  │  │   余数移位    │      │   商位选择    │      │   余数更新    │        │    │
                    │  │  │               │      │               │      │               │        │    │
                    │  │  │ rem << 4      │─────►│ 查表比较      │─────►│ rem - q*F     │        │    │
                    │  │  │               │      │               │      │               │        │    │
                    │  │  └───────────────┘      └───────────────┘      └───────────────┘        │    │
                    │  │         │                      │                      │                 │    │
                    │  │         │                      ▼                      │                 │    │
                    │  │         │              ┌───────────────┐              │                 │    │
                    │  │         │              │ 部分商/根累加 │              │                 │    │
                    │  │         │              │               │              │                 │    │
                    │  │         └─────────────►│ Q = Q<<4 + q  │◄─────────────┘                 │    │
                    │  │                        │               │                                │    │
                    │  │                        └───────────────┘                                │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌────────────────────────────────────────────────────────────────────────┐   │
                    │  │ qt[55:0] | rem_sign | rem_zero                                         │   │
                    │  └────────────────────────────────────────────────────────────────────────┘   │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `divisor[55:0]` | 56 | 规格化除数（除法模式） |
| `dividend[55:0]` | 56 | 规格化被除数/根号下数 |
| `div` | 1 | 除法操作指示 |
| `sqrt` | 1 | 平方根操作指示 |
| `srt_cnt[4:0]` | 5 | SRT迭代计数器 |
| `srt_cnt_zero` | 1 | SRT计数器归零标志 |
| `pipedown` | 1 | 流水线下移信号 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `qt[55:0]` | 56 | 商/根结果 |
| `rem_sign` | 1 | 余数符号位 |
| `rem_zero` | 1 | 余数为零标志 |

## 5. 关键逻辑设计

### 5.1 模式选择

```verilog
// 边界选择信号
assign bound_sel = div ? divisor[55:49] : 
                   partial_qt[55:49];

// 平方根首轮/次轮标志
assign sqrt_first_round = sqrt && (srt_cnt == srt_cnt_ini);
assign sqrt_second_round = sqrt && (srt_cnt == srt_cnt_ini - 1);
```

### 5.2 平方根迭代因子

```verilog
// 平方根迭代因子 F
// F = 2 * Q + q * 16^(-i)
// 简化实现: F ≈ 2 * Q (高位)

always @(*) begin
    if (sqrt_first_round)
        sqrt_factor = 56'h1;  // 首轮因子为1
    else if (sqrt)
        sqrt_factor = {partial_qt[55:0], 1'b0};  // 2 * Q
    else
        sqrt_factor = divisor;  // 除法使用除数
end
```

### 5.3 余数初始化

```verilog
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        rem <= {REM_WIDTH{1'b0}};
    else if (srt_start)
        rem <= {{(REM_WIDTH-DATA_WIDTH){1'b0}}, dividend};
end
```

### 5.4 商位选择

```verilog
// 边界值获取
ct_vfdsu_srt_radix16_bound_table u_bound_table (
    .bound_sel          (bound_sel),
    .sqrt_first_round   (sqrt_first_round),
    .sqrt_second_round  (sqrt_second_round),
    .bound_1            (bound_1),
    .bound_2            (bound_2),
    // ...
    .bound_9            (bound_9)
);

// 商位选择
always @(*) begin
    rem_high = rem_shifted[REM_WIDTH-1:REM_WIDTH-7];
    
    if (rem_high >= bound_9)
        q_digit = 4'd9;
    else if (rem_high >= bound_8)
        q_digit = 4'd8;
    // ... 其他正数边界
    else if (rem_high <= -bound_9)
        q_digit = -4'd9;
    // ... 其他负数边界
    else
        q_digit = 4'd0;
end
```

### 5.5 余数更新

```verilog
// 余数更新
always @(*) begin
    if (div) begin
        // 除法: rem = rem_shifted - q * divisor
        case (q_digit)
            4'd0:    rem_next = rem_shifted;
            4'd1:    rem_next = rem_shifted - divisor;
            4'd2:    rem_next = rem_shifted - (divisor << 1);
            // ...
            -4'd1:   rem_next = rem_shifted + divisor;
            // ...
        endcase
    end else begin
        // 平方根: rem = rem_shifted - q * sqrt_factor
        case (q_digit)
            4'd0:    rem_next = rem_shifted;
            4'd1:    rem_next = rem_shifted - sqrt_factor;
            4'd2:    rem_next = rem_shifted - (sqrt_factor << 1);
            // ...
            -4'd1:   rem_next = rem_shifted + sqrt_factor;
            // ...
        endcase
    end
end
```

### 5.6 部分商/根累加

```verilog
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        partial_qt <= {QT_WIDTH{1'b0}};
    else if (srt_start)
        partial_qt <= {QT_WIDTH{1'b0}};
    else if (iter_en)
        partial_qt <= {partial_qt[QT_WIDTH-5:0], q_digit};
end
```

## 6. 平方根特殊处理

### 6.1 首轮处理

平方根首轮迭代时，部分根Q=0，需要使用特殊的边界值：

```verilog
// 首轮边界值
// 由于 Q=0, F=1
// 商位选择基于特殊的边界值
assign sqrt_first_bound_sel = 7'h00;  // 特殊值
```

### 6.2 次轮处理

次轮迭代时，部分根Q只有首轮产生的4位：

```verilog
// 次轮边界值
// Q = q1 (首轮商位)
// F ≈ 2 * q1
```

### 6.3 指数奇偶处理

```verilog
// 如果原始指数为奇数，被开方数左移1位
// 结果指数 = (exp + BIAS) / 2
// 奇数指数时，整数部分和小数部分分开处理
```

## 7. 迭代过程示例

### 7.1 平方根迭代示例

```
计算: √25

初始:
  dividend = 25 (二进制: 11001)
  rem = 25, Q = 0

迭代1 (首轮):
  rem_shifted = 25 * 16 = 400
  sqrt_factor = 1 (首轮特殊)
  选择 q = 5 (因为 400 >= 5*1 的边界)
  rem_next = 400 - 5*1 = 395
  Q = 5

迭代2 (次轮):
  rem_shifted = 395 * 16 = 6320
  sqrt_factor = 2 * 5 = 10
  选择 q = 0
  rem_next = 6320
  Q = 5*16 + 0 = 80

... 继续迭代

最终: Q ≈ 5.0
```

## 8. 数据通路

### 8.1 数据宽度

| 信号 | 位宽 | 描述 |
|------|------|------|
| divisor | 56 | 除数 |
| dividend | 56 | 被除数/根号下数 |
| rem | 61 | 余数 |
| partial_qt | 58 | 部分商/根 |
| sqrt_factor | 56 | 平方根迭代因子 |
| q_digit | 4 | 商/根位 |

### 8.2 多路选择器

```verilog
// 迭代因子选择
assign iter_factor = div ? divisor : sqrt_factor;

// 边界选择
assign bound_sel_mux = div ? divisor[55:49] : 
                       sqrt_first_round ? 7'h00 :
                       sqrt_second_round ? {2'b0, partial_qt[3:0], 1'b0} :
                       partial_qt[55:49];
```

## 9. 时序图

```
时钟:        T1      T2      T3      T4      ...
            ┌───────┬───────┬───────┬───────┬─────
srt_cnt:    13      12      11      10      ...
            
迭代:        #1      #2      #3      #4      ...
            
rem:        初始化   更新1   更新2   更新3   ...
            
q_digit:    q1      q2      q3      q4      ...
            
partial_qt:  0      Q1      Q2      Q3      ...

sqrt_factor: 1      F2      F3      F4      ... (平方根模式)
```

## 10. 设计要点

### 10.1 模式切换
- 除法和平方根共享大部分逻辑
- 通过多路选择器切换数据通路

### 10.2 平方根优化
- 首轮/次轮特殊处理减少复杂度
- 迭代因子简化计算

### 10.3 精度保证
- 余数扩展位宽
- 迭代因子精度足够

## 11. 参数定义

```verilog
parameter DATA_WIDTH = 56;
parameter REM_WIDTH = 61;
parameter QT_WIDTH = 58;
```

## 12. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
