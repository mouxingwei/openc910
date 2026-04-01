# ct_vfdsu_srt_radix16_only_div 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_srt_radix16_only_div` - SRT radix-16纯除法迭代模块

### 1.2 功能描述
`ct_vfdsu_srt_radix16_only_div` 实现SRT radix-16算法的纯除法迭代逻辑。该模块专门用于除法运算，不包含平方根功能，通过迭代计算产生商和余数。

### 1.3 主要特性
- SRT radix-16除法迭代
- 每次迭代产生4位商
- 商位范围: -9 到 +9
- 余数更新和部分商累加
- 支持多种精度

## 2. 算法原理

### 2.1 除法迭代公式

```
r(i+1) = 16 * r(i) - q(i+1) * d

其中:
- r(i): 第i步的余数
- q(i+1): 第i+1步的商位
- d: 除数
```

### 2.2 商位选择
商位q的选择基于余数的高位和除数的高位，通过查找表确定边界值进行比较。

### 2.3 部分商累加

```
Q(i+1) = Q(i) + q(i+1) * 16^(-i-1)

实际实现中:
Q(i+1) = {Q(i)[51:0], q_bits}  // 移位累加
```

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                    ct_vfdsu_srt_radix16_only_div                               │
                    │                                                                                  │
    divisor[55:0]   │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        余数初始化                                        │    │
    dividend[55:0]  │  │                                                                          │    │
    ──────────────────►│  rem[0] = dividend (被除数作为初始余数)                                 │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        迭代计算                                        │    │
                    │  │                                                                          │    │
                    │  │  ┌───────────────┐      ┌───────────────┐      ┌───────────────┐        │    │
                    │  │  │   余数移位    │      │   商位选择    │      │   余数更新    │        │    │
                    │  │  │               │      │               │      │               │        │    │
                    │  │  │ rem << 4      │─────►│ 查表比较      │─────►│ rem - q*d     │        │    │
                    │  │  │               │      │               │      │               │        │    │
                    │  │  └───────────────┘      └───────────────┘      └───────────────┘        │    │
                    │  │         │                      │                      │                 │    │
                    │  │         │                      ▼                      │                 │    │
                    │  │         │              ┌───────────────┐              │                 │    │
                    │  │         │              │  部分商累加   │              │                 │    │
                    │  │         │              │               │              │                 │    │
                    │  │         └─────────────►│ Q = Q<<4 + q  │◄─────────────┘                 │    │
                    │  │                        │               │                                │    │
                    │  │                        └───────────────┘                                │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        输出寄存器                                      │    │
                    │  │                                                                          │    │
                    │  │  • qt[55:0]      - 商                                                  │    │
                    │  │  • rem_sign      - 余数符号                                            │    │
                    │  │  • rem_zero      - 余数为零                                            │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `divisor[55:0]` | 56 | 规格化除数 |
| `dividend[55:0]` | 56 | 规格化被除数 |
| `srt_cnt[4:0]` | 5 | SRT迭代计数器 |
| `srt_cnt_zero` | 1 | SRT计数器归零标志 |
| `pipedown` | 1 | 流水线下移信号 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `qt[55:0]` | 56 | 商结果 |
| `rem_sign` | 1 | 余数符号位 |
| `rem_zero` | 1 | 余数为零标志 |

## 5. 关键逻辑设计

### 5.1 余数初始化

```verilog
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        rem <= {REM_WIDTH{1'b0}};
    else if (srt_start)
        rem <= {{(REM_WIDTH-DATA_WIDTH){1'b0}}, dividend};
end
```

### 5.2 余数移位

```verilog
// 每次迭代前，余数左移4位（相当于乘以16）
assign rem_shifted = {rem[REM_WIDTH-5:0], 4'b0};
```

### 5.3 商位选择

#### 5.3.1 边界值获取
```verilog
// 根据除数高位获取边界值
assign bound_sel = divisor[55:49];  // 取除数高7位

ct_vfdsu_srt_radix16_bound_table u_bound_table (
    .bound_sel          (bound_sel),
    .sqrt_first_round   (1'b0),
    .sqrt_second_round  (1'b0),
    .bound_1            (bound_1),
    .bound_2            (bound_2),
    // ...
    .bound_9            (bound_9)
);
```

#### 5.3.2 商位确定
```verilog
// 余数高位
assign rem_high = rem_shifted[REM_WIDTH-1:REM_WIDTH-7];

// 商位选择逻辑
always @(*) begin
    if (rem_high >= bound_9)
        q_digit = 4'd9;
    else if (rem_high >= bound_8)
        q_digit = 4'd8;
    else if (rem_high >= bound_7)
        q_digit = 4'd7;
    else if (rem_high >= bound_6)
        q_digit = 4'd6;
    else if (rem_high >= bound_5)
        q_digit = 4'd5;
    else if (rem_high >= bound_4)
        q_digit = 4'd4;
    else if (rem_high >= bound_3)
        q_digit = 4'd3;
    else if (rem_high >= bound_2)
        q_digit = 4'd2;
    else if (rem_high >= bound_1)
        q_digit = 4'd1;
    else if (rem_high <= -bound_9)
        q_digit = -4'd9;
    else if (rem_high <= -bound_8)
        q_digit = -4'd8;
    // ... 负数边界
    else if (rem_high <= -bound_1)
        q_digit = -4'd1;
    else
        q_digit = 4'd0;
end
```

### 5.4 余数更新

```verilog
// 余数更新: rem = rem_shifted - q_digit * divisor
// 使用加减法器实现

always @(*) begin
    case (q_digit)
        4'd0:    rem_next = rem_shifted;
        4'd1:    rem_next = rem_shifted - divisor;
        4'd2:    rem_next = rem_shifted - (divisor << 1);
        4'd3:    rem_next = rem_shifted - (divisor * 3);
        4'd4:    rem_next = rem_shifted - (divisor << 2);
        4'd5:    rem_next = rem_shifted - (divisor * 5);
        4'd6:    rem_next = rem_shifted - (divisor * 6);
        4'd7:    rem_next = rem_shifted - (divisor * 7);
        4'd8:    rem_next = rem_shifted - (divisor << 3);
        4'd9:    rem_next = rem_shifted - (divisor * 9);
        // 负数情况使用加法
        -4'd1:   rem_next = rem_shifted + divisor;
        -4'd2:   rem_next = rem_shifted + (divisor << 1);
        // ... 其他负数情况
        default: rem_next = rem_shifted;
    endcase
end
```

### 5.5 部分商累加

```verilog
// 部分商累加
// 使用带符号累加

always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        partial_qt <= {QT_WIDTH{1'b0}};
    else if (srt_start)
        partial_qt <= {QT_WIDTH{1'b0}};
    else if (iter_en)
        partial_qt <= {partial_qt[QT_WIDTH-5:0], q_digit};
end
```

### 5.6 余数符号和零检测

```verilog
// 余数符号
assign rem_sign = rem[REM_WIDTH-1];

// 余数为零检测
assign rem_zero = (rem == {REM_WIDTH{1'b0}});
```

## 6. 迭代过程示例

### 6.1 除法迭代示例

```
计算: 25 / 3

初始:
  dividend = 25 (二进制: 11001)
  divisor  = 3  (二进制: 11)
  rem = 25, Q = 0

迭代1:
  rem_shifted = 25 * 16 = 400
  bound_sel = 3的高位
  rem_high = 400的高位
  选择 q = 8 (因为 400 >= 8*3*16 的边界)
  rem_next = 400 - 8*3 = 376
  Q = 8

迭代2:
  rem_shifted = 376 * 16 = 6016
  选择 q = 3
  rem_next = 6016 - 3*3 = 6007
  Q = 8*16 + 3 = 131

... 继续迭代

最终: Q ≈ 8.333...
```

## 7. 数据通路

### 7.1 数据宽度

| 信号 | 位宽 | 描述 |
|------|------|------|
| divisor | 56 | 除数 |
| dividend | 56 | 被除数 |
| rem | 61 | 余数（扩展位宽保证精度） |
| partial_qt | 58 | 部分商 |
| q_digit | 4 | 商位（带符号） |

### 7.2 精度保证
- 余数位宽比操作数多5位，保证迭代精度
- 部分商位宽足够容纳所有迭代结果

## 8. 时序图

```
时钟:        T1      T2      T3      T4      ...
            ┌───────┬───────┬───────┬───────┬─────
srt_cnt:    13      12      11      10      ...
            
迭代:        #1      #2      #3      #4      ...
            
rem:        初始化   更新1   更新2   更新3   ...
            
q_digit:    q1      q2      q3      q4      ...
            
partial_qt:  0      Q1      Q2      Q3      ...
```

## 9. 设计要点

### 9.1 商位选择优化
- 使用查找表减少比较器数量
- 边界值预先计算

### 9.2 余数更新优化
- 使用加减法器复用
- 常数乘法器优化

### 9.3 时序优化
- 关键路径在商位选择和余数更新
- 可考虑流水线化

## 10. 参数定义

```verilog
parameter DATA_WIDTH = 56;
parameter REM_WIDTH = 61;
parameter QT_WIDTH = 58;
```

## 11. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
