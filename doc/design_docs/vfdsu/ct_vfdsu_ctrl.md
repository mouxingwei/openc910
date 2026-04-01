# ct_vfdsu_ctrl 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_vfdsu_ctrl` - 向量浮点除法/平方根单元控制模块

### 1.2 功能描述
`ct_vfdsu_ctrl` 是VFDSU的核心控制模块，负责管理整个流水线的运行状态。该模块包含两个主要状态机：SRT状态机和除法写回状态机，协同控制EX1至EX4各阶段的操作流程，处理流水线暂停、刷新和写回等控制逻辑。

### 1.3 主要特性
- 双状态机架构：SRT状态机 + 除法写回状态机
- 流水线各阶段控制信号生成
- SRT迭代计数管理
- 异常和刷新处理
- 门控时钟使能控制
- 写回仲裁逻辑

## 2. 状态机设计

### 2.1 SRT状态机

#### 2.1.1 状态定义

| 状态名 | 编码 | 描述 |
|--------|------|------|
| `SRT_IDLE` | 1'b0 | 空闲状态，等待新操作 |
| `SRT_BUSY` | 1'b1 | 忙碌状态，正在进行SRT迭代 |

#### 2.1.2 状态转移图

```
              ┌─────────────────────────────────────┐
              │                                     │
              ▼              srt_busy_done          │
        ┌───────────┐      (迭代完成)               │
        │ SRT_IDLE  │◄────────────────────────────┐ │
        │           │                             │ │
        └───────────┘                             │ │
              │                                   │ │
              │ srt_start                         │ │
              │ (新操作启动)                       │ │
              ▼                                   │ │
        ┌───────────┐                             │ │
        │ SRT_BUSY  │─────────────────────────────┘ │
        │           │                               │
        └───────────┘                               │
              │                                     │
              │ flush                               │
              │ (流水线刷新)                         │
              └─────────────────────────────────────┘
```

#### 2.1.3 状态转移条件

| 当前状态 | 下一状态 | 转移条件 |
|----------|----------|----------|
| SRT_IDLE | SRT_BUSY | `srt_start` 有效且无刷新 |
| SRT_BUSY | SRT_IDLE | `srt_busy_done` 或 `flush` 有效 |
| SRT_IDLE | SRT_IDLE | 无新操作或刷新 |
| SRT_BUSY | SRT_BUSY | 迭代未完成且无刷新 |

### 2.2 除法写回状态机

#### 2.2.1 状态定义

| 状态名 | 编码 | 描述 |
|--------|------|------|
| `IDLE` | 4'b0000 | 空闲状态 |
| `RF` | 4'b0100 | 读寄存器堆阶段 |
| `EX1` | 4'b0101 | 准备阶段 |
| `EX2` | 4'b0110 | SRT迭代阶段 |
| `WB_REQ` | 4'b0111 | 写回请求阶段 |
| `WB` | 4'b1000 | 写回阶段 |

#### 2.2.2 状态转移图

```
                    ┌─────────────────────────────────────────────────┐
                    │                                                 │
                    ▼                                                 │
              ┌───────────┐                                          │
              │   IDLE    │                                          │
              │  (0000)   │                                          │
              └───────────┘                                          │
                    │                                                │
                    │ div_start                                      │
                    ▼                                                │
              ┌───────────┐                                          │
              │    RF     │                                          │
              │  (0100)   │                                          │
              └───────────┘                                          │
                    │                                                │
                    │ 自动转移                                        │
                    ▼                                                │
              ┌───────────┐                                          │
              │   EX1     │◄──────────────────────────┐              │
              │  (0101)   │                           │              │
              └───────────┘                           │              │
                    │                                 │              │
                    │ ex1_pipedown                    │              │
                    ▼                                 │              │
              ┌───────────┐                           │              │
              │   EX2     │                           │              │
              │  (0110)   │                           │              │
              └───────────┘                           │              │
                    │                                 │              │
                    │ ex2_pipedown && srt_done        │              │
                    ▼                                 │              │
              ┌───────────┐                           │              │
              │  WB_REQ   │                           │              │
              │  (0111)   │                           │              │
              └───────────┘                           │              │
                    │                                 │              │
                    │ wb_grant                        │ flush        │
                    ▼                                 │              │
              ┌───────────┐                           │              │
              │    WB     │───────────────────────────┘              │
              │  (1000)   │                                          │
              └───────────┘                                          │
                    │                                                │
                    │ wb_done                                        │
                    └────────────────────────────────────────────────┘
```

#### 2.2.3 状态转移条件

| 当前状态 | 下一状态 | 转移条件 |
|----------|----------|----------|
| IDLE | RF | `div_start` 有效 |
| RF | EX1 | 自动转移（下一周期） |
| EX1 | EX2 | `ex1_pipedown` 有效 |
| EX2 | WB_REQ | `ex2_pipedown` 且 `srt_done` 有效 |
| WB_REQ | WB | `wb_grant` 有效 |
| WB | IDLE | 写回完成 |
| 任意状态 | IDLE | `flush` 有效 |

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────┐
                    │                         ct_vfdsu_ctrl                                │
                    │                                                                      │
    cpurst_b        │  ┌─────────────────────────────────────────────────────────────┐   │
    ──────────────────►│                        复位逻辑                              │   │
                    │  └─────────────────────────────────────────────────────────────┘   │
                    │                                                                      │
    forever_cpuclk  │  ┌─────────────────────────────────────────────────────────────┐   │
    ──────────────────►│                      门控时钟生成                            │   │
    vfdsu_xx_gateclk_v│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │   │
    ──────────────────►│  │ ex1_clk │  │ ex2_clk │  │ ex3_clk │  │ ex4_clk │      │   │
    pad_yy_icg_scanen │  └──┴─────────┴──┴─────────┴──┴─────────┴──┴─────────┴──────┘   │
    ──────────────────►│                                                              │   │
                    │  ┌─────────────────────────────────────────────────────────────┐   │
    vfdsu_xx_ex1_    │  │                     SRT状态机                              │   │
    src_vld          │  │  ┌───────────┐              ┌───────────┐                 │   │
    ──────────────────►│  │ SRT_IDLE  │◄────────────►│ SRT_BUSY  │                 │   │
    vfdsu_xx_ex1_div  │  └───────────┘              └───────────┘                 │   │
    ──────────────────►│       │                          │                        │   │
    vfdsu_xx_ex1_sqrt │       │ srt_cnt                  │                        │   │
    ──────────────────►│       ▼                          ▼                        │   │
    vfdsu_xx_ex1_     │  ┌──────────────────────────────────────────────────────┐  │   │
    double            │  │              SRT迭代计数器                            │  │   │
    ──────────────────►│  │  双精度: 13次 | 单精度: 6次 | 半精度: 3次            │  │   │
    vfdsu_xx_ex1_     │  └──────────────────────────────────────────────────────┘  │   │
    single            │                                                              │   │
    ──────────────────►│                                                              │   │
                    │  ┌─────────────────────────────────────────────────────────────┐   │
    rtu_yy_xx_flush  │  │                   除法写回状态机                          │   │
    ──────────────────►│  │  IDLE → RF → EX1 → EX2 → WB_REQ → WB → IDLE            │   │
    rtu_yy_xx_expt_int│  └─────────────────────────────────────────────────────────────┘   │
    ──────────────────►│                                                              │   │
    iu_yy_xx_cancel   │  ┌─────────────────────────────────────────────────────────────┐   │
    ──────────────────►│                    流水线控制信号生成                        │   │
    vfdsu_xx_wb_grant │  │  • ex1_pipedown    • ex2_pipedown                        │   │
    ──────────────────►│  │  • ex3_pipedown    • ex4_pipedown                        │   │
                    │  │  • ex1_clk_en      • ex2_clk_en                            │   │
                    │  │  • ex3_clk_en      • ex4_clk_en                            │   │
                    │  └─────────────────────────────────────────────────────────────┘   │
                    │                                                                      │
                    │  输出信号                                                            │
                    │  ┌──────────────────────────────────────────────────────────────┐  │
                    │  │ vfdsu_xx_ex1_ready | vfdsu_xx_ex2_stall | vfdsu_xx_wb_vld  │  │
                    │  └──────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `vfdsu_xx_gateclk_v` | 1 | 门控时钟模块使能 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `pad_yy_icg_scanen` | 1 | 扫描使能信号 |
| `vfdsu_xx_ex1_src_vld` | 1 | EX1阶段源数据有效 |
| `vfdsu_xx_ex1_div` | 1 | EX1阶段除法操作 |
| `vfdsu_xx_ex1_sqrt` | 1 | EX1阶段平方根操作 |
| `vfdsu_xx_ex1_double` | 1 | EX1阶段双精度操作 |
| `vfdsu_xx_ex1_single` | 1 | EX1阶段单精度操作 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |
| `rtu_yy_xx_expt_int` | 1 | 异常中断信号 |
| `iu_yy_xx_cancel` | 1 | IU取消信号 |
| `vfdsu_xx_wb_grant` | 1 | 写回授权信号 |
| `srt_busy_done` | 1 | SRT迭代完成信号 |
| `ex2_srt_cnt_zero` | 1 | EX2阶段SRT计数器归零 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `vfdsu_xx_ex1_ready` | 1 | EX1阶段就绪信号 |
| `vfdsu_xx_ex2_stall` | 1 | EX2阶段暂停信号 |
| `vfdsu_xx_wb_vld` | 1 | 写回有效信号 |
| `ex1_pipedown` | 1 | EX1阶段流水线下移信号 |
| `ex2_pipedown` | 1 | EX2阶段流水线下移信号 |
| `ex3_pipedown` | 1 | EX3阶段流水线下移信号 |
| `ex4_pipedown` | 1 | EX4阶段流水线下移信号 |
| `ex1_clk_en` | 1 | EX1阶段时钟使能 |
| `ex2_clk_en` | 1 | EX2阶段时钟使能 |
| `ex3_clk_en` | 1 | EX3阶段时钟使能 |
| `ex4_clk_en` | 1 | EX4阶段时钟使能 |
| `srt_start` | 1 | SRT迭代启动信号 |
| `srt_cnt_ini[4:0]` | 5 | SRT计数器初始值 |
| `div_wb_req` | 1 | 除法写回请求 |

## 5. 关键逻辑设计

### 5.1 SRT迭代计数器

#### 5.1.1 初始值设定
根据精度类型设置不同的迭代次数：

```verilog
// SRT计数器初始值
// 双精度: 13次迭代 (5'b01101)
// 单精度: 6次迭代  (5'b00110)
// 半精度: 3次迭代  (5'b00011)
assign srt_cnt_ini[4:0] = (ex1_double) ? 5'b01101 : 
                          (ex1_single) ? 5'b00110 : 5'b00011;
```

#### 5.1.2 计数器逻辑
```verilog
// SRT计数器递减逻辑
always @(posedge ex2_clk or negedge cpurst_b) begin
    if (!cpurst_b)
        srt_cnt <= 5'b0;
    else if (srt_start)
        srt_cnt <= srt_cnt_ini;
    else if (ex2_pipedown && (srt_cnt > 0))
        srt_cnt <= srt_cnt - 1'b1;
end
```

### 5.2 流水线下移控制

#### 5.2.1 EX1阶段下移条件
```verilog
assign ex1_pipedown = vfdsu_xx_ex1_src_vld && 
                      vfdsu_xx_ex1_ready && 
                      !rtu_yy_xx_flush;
```

#### 5.2.2 EX2阶段下移条件
```verilog
assign ex2_pipedown = srt_state == SRT_BUSY && 
                      ex2_srt_cnt_zero && 
                      !rtu_yy_xx_flush;
```

#### 5.2.3 EX3阶段下移条件
```verilog
assign ex3_pipedown = ex2_pipedown && 
                      !rtu_yy_xx_flush;
```

#### 5.2.4 EX4阶段下移条件
```verilog
assign ex4_pipedown = ex3_pipedown && 
                      vfdsu_xx_wb_grant && 
                      !rtu_yy_xx_flush;
```

### 5.3 就绪信号生成

```verilog
// EX1就绪信号：SRT状态机空闲且无刷新
assign vfdsu_xx_ex1_ready = (srt_state == SRT_IDLE) && 
                            !rtu_yy_xx_flush;

// EX2暂停信号：SRT迭代进行中
assign vfdsu_xx_ex2_stall = (srt_state == SRT_BUSY) && 
                            !ex2_srt_cnt_zero;
```

## 6. 门控时钟控制

### 6.1 时钟使能逻辑

```verilog
// EX1时钟使能：有新操作或刷新
assign ex1_clk_en = vfdsu_xx_ex1_src_vld || rtu_yy_xx_flush;

// EX2时钟使能：SRT迭代期间
assign ex2_clk_en = (srt_state == SRT_BUSY) || srt_start;

// EX3时钟使能：EX2完成时
assign ex3_clk_en = ex2_pipedown && ex2_srt_cnt_zero;

// EX4时钟使能：EX3完成时
assign ex4_clk_en = ex3_pipedown;
```

### 6.2 门控时钟实例化

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

## 7. 异常处理

### 7.1 刷新处理
当收到刷新信号时，所有状态机立即返回空闲状态：

```verilog
// SRT状态机刷新处理
always @(posedge forever_cpuclk or negedge cpurst_b) begin
    if (!cpurst_b)
        srt_state <= SRT_IDLE;
    else if (rtu_yy_xx_flush)
        srt_state <= SRT_IDLE;
    else case (srt_state)
        SRT_IDLE: if (srt_start) srt_state <= SRT_BUSY;
        SRT_BUSY: if (srt_busy_done) srt_state <= SRT_IDLE;
    endcase
end
```

### 7.2 取消处理
```verilog
// IU取消信号处理
assign op_cancel = iu_yy_xx_cancel || rtu_yy_xx_expt_int;
```

## 8. 时序图

### 8.1 正常操作时序

```
时钟:        T1      T2      T3      T4      T5      T6      T7      T8
            ┌───────┬───────┬───────┬───────┬───────┬───────┬───────┬───────┐
src_vld     ─┐       └───────└───────└───────└───────└───────└───────└───────
            └┐
ex1_ready   ─┘       └───────└───────└───────└───────└───────└───────└───────
            
SRT状态:    IDLE    BUSY    BUSY    BUSY    BUSY    IDLE    IDLE    IDLE
            
srt_cnt:    0       13      12      ...     0       0       0       0
            
ex1_pipe:           ─┐                                             
                    └┘
ex2_pipe:                           ─┐                             
                                    └┘
ex3_pipe:                                           ─┐             
                                                    └┘
ex4_pipe:                                                   ─┐     
                                                            └┘
            
wb_grant:                                                   ─┐     
                                                            └┘
wb_vld:                                                         ─┐ 
                                                                └┘
```

### 8.2 刷新时序

```
时钟:        T1      T2      T3      T4
            ┌───────┬───────┬───────┬───────┐
src_vld     ─┐       └───────└───────└───────
            └┐
SRT状态:    IDLE    BUSY    IDLE    IDLE
            
flush:                      ─┐     
                            └┘
            
srt_cnt:    0       13      0       0
            
ex1_ready:  ─┐               ─┐     
            └┘               └┘
```

## 9. 设计要点

### 9.1 状态机协同
- SRT状态机控制迭代过程
- 除法写回状态机控制整体流程
- 两个状态机通过 `srt_start` 和 `srt_busy_done` 信号同步

### 9.2 流水线控制
- 采用分布式流水线控制
- 每阶段独立的下移信号
- 支持单周期暂停和恢复

### 9.3 功耗优化
- 门控时钟降低动态功耗
- 仅在需要时使能各阶段时钟
- 支持模块级时钟门控

## 10. 参数定义

```verilog
// SRT状态机参数
parameter SRT_IDLE = 1'b0;
parameter SRT_BUSY = 1'b1;

// 除法写回状态机参数
parameter IDLE    = 4'b0000;
parameter RF      = 4'b0100;
parameter EX1     = 4'b0101;
parameter EX2     = 4'b0110;
parameter WB_REQ  = 4'b0111;
parameter WB      = 4'b1000;
```

## 11. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
