# ct_vfdsu_scalar_dp 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_scalar_dp` - 标量数据处理模块

### 1.2 功能描述
`ct_vfdsu_scalar_dp` 是VFDSU的标量数据处理模块，负责管理目标寄存器信息和指令ID的流水线传递。该模块处理写回时的目标物理寄存器号和指令ID的传递，支持标量浮点除法和平方根操作。

### 1.3 主要特性
- 目标寄存器信息流水线传递
- 指令ID（IID）管理
- 除法/平方根操作控制信号生成
- 双精度/单精度模式选择
- 流水线刷新处理

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                         ct_vfdsu_scalar_dp                                      │
                    │                                                                                  │
    cpurst_b        │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        流水线寄存器                                      │    │
    forever_cpuclk  │  │                                                                          │    │
    ──────────────────►│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌──────────┐ │    │
    pad_yy_icg_scanen│  │   EX1寄存器  │───►│   EX2寄存器  │───►│   EX3寄存器  │───►│ EX4寄存器│ │    │
    ──────────────────►│  │             │    │             │    │             │    │          │ │    │
                    │  │  • dst_preg  │    │  • dst_preg  │    │  • dst_preg  │    │ •dst_preg│ │    │
    vfdsu_xx_ex1_   │  │  • iid       │    │  • iid       │    │  • iid       │    │ •iid     │ │    │
    dst_preg[5:0]   │  │  • div       │    │  • div       │    │  • div       │    │ •div     │ │    │
    ──────────────────►│  │  • sqrt      │    │  • sqrt      │    │  • sqrt      │    │ •sqrt    │ │    │
    vfdsu_xx_ex1_   │  │  • double    │    │  • double    │    │  • double    │    │ •double  │ │    │
    iid[6:0]        │  │  • single    │    │  • single    │    │  • single    │    │ •single  │ │    │
    ──────────────────►│  └─────────────┘    └─────────────┘    └─────────────┘    └──────────┘ │    │
    vfdsu_xx_ex1_   │  │                                                                          │    │
    div             │  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                                  │
    vfdsu_xx_ex1_   │                              ▼                                                  │
    sqrt            │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        控制信号生成                                      │    │
    vfdsu_xx_ex1_   │  │                                                                          │    │
    double          │  │  • vfdsu_div_double: 双精度除法                                          │    │
    ──────────────────►│  • vfdsu_div_single: 单精度除法                                          │    │
    vfdsu_xx_ex1_   │  │  • vfdsu_sqrt_double: 双精度平方根                                       │    │
    single          │  │  • vfdsu_sqrt_single: 单精度平方根                                       │    │
    ──────────────────►│                                                                          │    │
    ex1_pipedown    │  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                                  │
    ex2_pipedown    │                              ▼                                                  │
    ──────────────────►│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ex3_pipedown    │  │                        输出选择                                        │    │
    ──────────────────►│  │                                                                          │    │
    ex4_pipedown    │  │  根据流水线阶段选择输出:                                                 │    │
    ──────────────────►│  │  • wb_dst_preg: 写回目标寄存器                                          │    │
    rtu_yy_xx_flush │  │  • wb_iid: 写回指令ID                                                    │    │
    ──────────────────►│  │  • wb_dst_vld: 写回有效                                                 │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌────────────────────────────────────────────────────────────────────────┐   │
                    │  │ wb_dst_preg[5:0] | wb_iid[6:0] | wb_dst_vld | 控制信号                 │   │
                    │  └────────────────────────────────────────────────────────────────────────┘   │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `vfdsu_xx_ex1_dst_preg[5:0]` | 6 | EX1阶段目标物理寄存器号 |
| `vfdsu_xx_ex1_iid[6:0]` | 7 | EX1阶段指令ID |
| `vfdsu_xx_ex1_div` | 1 | EX1阶段除法操作 |
| `vfdsu_xx_ex1_sqrt` | 1 | EX1阶段平方根操作 |
| `vfdsu_xx_ex1_double` | 1 | EX1阶段双精度操作 |
| `vfdsu_xx_ex1_single` | 1 | EX1阶段单精度操作 |
| `ex1_pipedown` | 1 | EX1阶段流水线下移 |
| `ex2_pipedown` | 1 | EX2阶段流水线下移 |
| `ex3_pipedown` | 1 | EX3阶段流水线下移 |
| `ex4_pipedown` | 1 | EX4阶段流水线下移 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `wb_dst_preg[5:0]` | 6 | 写回目标物理寄存器号 |
| `wb_iid[6:0]` | 7 | 写回指令ID |
| `wb_dst_vld` | 1 | 写回目标有效信号 |
| `vfdsu_div_double` | 1 | 双精度除法操作指示 |
| `vfdsu_div_single` | 1 | 单精度除法操作指示 |
| `vfdsu_sqrt_double` | 1 | 双精度平方根操作指示 |
| `vfdsu_sqrt_single` | 1 | 单精度平方根操作指示 |

## 4. 关键逻辑设计

### 4.1 流水线寄存器

#### 4.1.1 EX1寄存器
```verilog
always @(posedge ex1_clk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        ex1_dst_preg_reg <= 6'b0;
        ex1_iid_reg <= 7'b0;
        ex1_div_reg <= 1'b0;
        ex1_sqrt_reg <= 1'b0;
        ex1_double_reg <= 1'b0;
        ex1_single_reg <= 1'b0;
    end else if (ex1_pipedown && !rtu_yy_xx_flush) begin
        ex1_dst_preg_reg <= vfdsu_xx_ex1_dst_preg;
        ex1_iid_reg <= vfdsu_xx_ex1_iid;
        ex1_div_reg <= vfdsu_xx_ex1_div;
        ex1_sqrt_reg <= vfdsu_xx_ex1_sqrt;
        ex1_double_reg <= vfdsu_xx_ex1_double;
        ex1_single_reg <= vfdsu_xx_ex1_single;
    end
end
```

#### 4.1.2 EX2寄存器
```verilog
always @(posedge ex2_clk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        ex2_dst_preg_reg <= 6'b0;
        ex2_iid_reg <= 7'b0;
        ex2_div_reg <= 1'b0;
        ex2_sqrt_reg <= 1'b0;
        ex2_double_reg <= 1'b0;
        ex2_single_reg <= 1'b0;
    end else if (ex2_pipedown && !rtu_yy_xx_flush) begin
        ex2_dst_preg_reg <= ex1_dst_preg_reg;
        ex2_iid_reg <= ex1_iid_reg;
        ex2_div_reg <= ex1_div_reg;
        ex2_sqrt_reg <= ex1_sqrt_reg;
        ex2_double_reg <= ex1_double_reg;
        ex2_single_reg <= ex1_single_reg;
    end
end
```

#### 4.1.3 EX3寄存器
```verilog
always @(posedge ex3_clk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        ex3_dst_preg_reg <= 6'b0;
        ex3_iid_reg <= 7'b0;
    end else if (ex3_pipedown && !rtu_yy_xx_flush) begin
        ex3_dst_preg_reg <= ex2_dst_preg_reg;
        ex3_iid_reg <= ex2_iid_reg;
    end
end
```

#### 4.1.4 EX4寄存器
```verilog
always @(posedge ex4_clk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        ex4_dst_preg_reg <= 6'b0;
        ex4_iid_reg <= 7'b0;
    end else if (ex4_pipedown && !rtu_yy_xx_flush) begin
        ex4_dst_preg_reg <= ex3_dst_preg_reg;
        ex4_iid_reg <= ex3_iid_reg;
    end
end
```

### 4.2 控制信号生成

```verilog
// 双精度除法
assign vfdsu_div_double = ex1_div_reg && ex1_double_reg;

// 单精度除法
assign vfdsu_div_single = ex1_div_reg && ex1_single_reg;

// 双精度平方根
assign vfdsu_sqrt_double = ex1_sqrt_reg && ex1_double_reg;

// 单精度平方根
assign vfdsu_sqrt_single = ex1_sqrt_reg && ex1_single_reg;
```

### 4.3 写回输出

```verilog
// 写回目标寄存器
assign wb_dst_preg = ex4_dst_preg_reg;

// 写回指令ID
assign wb_iid = ex4_iid_reg;

// 写回有效信号
assign wb_dst_vld = ex4_pipedown && !rtu_yy_xx_flush;
```

## 5. 流水线数据流

### 5.1 数据流图

```
EX1阶段          EX2阶段          EX3阶段          EX4阶段          写回
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│dst_preg │────►│dst_preg │────►│dst_preg │────►│dst_preg │────►│ wb_data │
│iid      │     │iid      │     │iid      │     │iid      │     │         │
│div      │     │div      │     │         │     │         │     │         │
│sqrt     │     │sqrt     │     │         │     │         │     │         │
│double   │     │double   │     │         │     │         │     │         │
│single   │     │single   │     │         │     │         │     │         │
└─────────┘     └─────────┘     └─────────┘     └─────────┘     └─────────┘
     │               │
     └───────────────┴───────────► 控制信号输出
```

### 5.2 流水线时序

```
时钟:        T1      T2      T3      T4      T5
            ┌───────┬───────┬───────┬───────┬───────┐
dst_preg:   输入    EX1     EX2     EX3     EX4输出
iid:        输入    EX1     EX2     EX3     EX4输出
div/sqrt:   输入    EX1     EX2     (不再需要)
double/sp:  输入    EX1     EX2     (不再需要)
```

## 6. 刷新处理

### 6.1 刷新逻辑

```verilog
// 当收到刷新信号时，清空流水线寄存器
always @(posedge forever_cpuclk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        // 复位所有寄存器
    end else if (rtu_yy_xx_flush) begin
        // 清空流水线
        ex1_dst_preg_reg <= 6'b0;
        ex1_iid_reg <= 7'b0;
        // ... 其他寄存器
    end
end
```

### 6.2 刷新时序

```
时钟:        T1      T2      T3
            ┌───────┬───────┬───────┐
flush:                      ────────
                            └───────
            
寄存器:     正常    正常    清零
```

## 7. 设计要点

### 7.1 寄存器管理
- 每阶段独立的寄存器
- 支持流水线暂停
- 支持刷新清零

### 7.2 控制信号
- 操作类型信号在EX1/EX2阶段使用
- 写回信息传递到EX4阶段

### 7.3 功耗优化
- 使用门控时钟
- 仅在需要时更新寄存器

## 8. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
