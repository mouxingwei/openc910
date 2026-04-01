# ct_biu_csr_req_arbiter 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_biu_csr_req_arbiter` - CSR请求仲裁器模块

### 1.2 功能描述
`ct_biu_csr_req_arbiter` 是BIU的CSR请求仲裁模块，负责处理对L2缓存控制寄存器的访问请求。该模块仲裁来自不同源的CSR访问请求，并管理CSR读写操作的时序。

### 1.3 主要特性
- CSR访问请求仲裁
- 读写操作分离
- 响应处理
- 时序同步

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                     ct_biu_csr_req_arbiter                                    │
                    │                                                                                  │
    biu_csr_sel     │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        请求处理                                          │    │
    biu_csr_op[15:0]│  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
    biu_csr_wdata   │  │   请求接收     │    │   仲裁逻辑    │    │   响应处理    │           │    │
    [63:0]          │  │               │    │               │    │               │           │    │
    ──────────────────►│  • sel信号    │    │  • 操作类型   │    │  • rdata返回  │           │    │
                    │  │  • op操作码   │    │  • 时序控制   │    │  • cmplt信号  │           │    │
                    │  │  • wdata数据  │    │  • 请求发送   │    │               │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ biu_pad_csr_sel | biu_pad_csr_wdata[79:0] | biu_csr_rdata[127:0]        │  │
                    │  │ biu_csr_cmplt                                                          │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `forever_coreclk` | 1 | 永久核心时钟 |
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `biu_csr_sel` | 1 | CSR选择信号 |
| `biu_csr_op[15:0]` | 16 | CSR操作码 |
| `biu_csr_wdata[63:0]` | 64 | CSR写数据 |
| `pad_biu_csr_cmplt` | 1 | CSR操作完成 |
| `pad_biu_csr_rdata[127:0]` | 128 | CSR读数据 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `biu_pad_csr_sel` | 1 | CSR选择输出 |
| `biu_pad_csr_wdata[79:0]` | 80 | CSR写数据输出（含操作码） |
| `biu_csr_rdata[127:0]` | 128 | CSR读数据 |
| `biu_csr_cmplt` | 1 | CSR操作完成指示 |

## 4. CSR操作类型

### 4.1 操作码定义

| 操作码 | 描述 |
|--------|------|
| READ | CSR读操作 |
| WRITE | CSR写操作 |
| SET | CSR置位操作 |
| CLEAR | CSR清零操作 |

### 4.2 数据格式

```
biu_pad_csr_wdata[79:0]:
| [79:64]  | [63:0]      |
| op[15:0] | wdata[63:0] |
```

## 5. 关键逻辑设计

### 5.1 请求脉冲生成

```verilog
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        csr_sel_ff <= 1'b0;
    else
        csr_sel_ff <= biu_csr_sel;
end

assign csr_sel_pulse = biu_csr_sel && !csr_sel_ff;
```

### 5.2 数据打包

```verilog
assign biu_csr_req_data[79:0] = {biu_csr_op[15:0], biu_csr_wdata[63:0]};

always @(posedge clk) begin
    if (csr_sel_pulse)
        biu_pad_csr_wdata[79:0] <= biu_csr_req_data[79:0];
end
```

### 5.3 响应处理

```verilog
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        biu_csr_cmplt <= 1'b0;
    else
        biu_csr_cmplt <= pad_biu_csr_cmplt;
end

always @(posedge clk) begin
    if (pad_biu_csr_cmplt)
        biu_csr_rdata[127:0] <= pad_biu_csr_rdata[127:0];
end
```

## 6. 时序图

### 6.1 CSR读写时序

```
时钟:        T1      T2      T3      T4
            ┌───────┬───────┬───────┬───────┐
biu_csr_sel ────────┐                       │
                    └───────────────────────┘
            
csr_sel_pulse───────┐                       │
                    └───────────────────────┘
            
biu_pad_csr_sel─────┐                       │
                    └───────────────────────┘
            
pad_biu_csr_cmplt           ────────┐       │
                                    └───────┘
            
biu_csr_cmplt               ────────┐       │
                                    └───────┘
```

## 7. 设计要点

### 7.1 时序同步
- 输入信号需要同步
- 输出信号需要寄存

### 7.2 脉冲生成
- 将电平信号转换为脉冲
- 确保单次操作

### 7.3 数据完整性
- 保持数据稳定
- 正确处理响应

## 8. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
