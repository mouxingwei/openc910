# ct_biu_snoop_channel 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_biu_snoop_channel` - AXI监听通道模块

### 1.2 功能描述
`ct_biu_snoop_channel` 是BIU的AXI监听通道模块，负责处理外部总线对处理器Cache的监听请求。该模块实现ACE协议的AC（监听地址）、CR（监听响应）和CD（监听数据）通道，支持Cache一致性协议。

### 1.3 主要特性
- ACE AC通道实现
- ACE CR通道实现
- ACE CD通道实现
- 双缓冲设计
- 监听数据传输
- 时钟门控支持

## 2. ACE监听通道协议

### 2.1 AC通道信号

| 信号 | 方向 | 描述 |
|------|------|------|
| ACVALID | 输入 | 监听地址有效 |
| ACREADY | 输出 | 监听地址就绪 |
| ACADDR | 输入 | 监听地址 |
| ACSNOOP | 输入 | 监听类型 |
| ACPROT | 输入 | 保护属性 |

### 2.2 CR通道信号

| 信号 | 方向 | 描述 |
|------|------|------|
| CRVALID | 输出 | 监听响应有效 |
| CRREADY | 输入 | 监听响应就绪 |
| CRRESP | 输出 | 监听响应 |

### 2.3 CD通道信号

| 信号 | 方向 | 描述 |
|------|------|------|
| CDVALID | 输出 | 监听数据有效 |
| CDREADY | 输入 | 监听数据就绪 |
| CDDATA | 输出 | 监听数据 |
| CDLAST | 输出 | 最后数据 |

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                      ct_biu_snoop_channel                                     │
                    │                                                                                  │
    pad_biu_acvalid│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        AC通道                                            │    │
    pad_biu_acaddr │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
    pad_biu_acsnoop│  │   双缓冲接收   │    │   选择逻辑    │    │   LSU接口    │           │    │
    ──────────────────►│  │               │    │               │    │               │           │    │
    pad_biu_acprot │  │  • buf0       │    │  • pop_sel    │    │  • ac_req    │           │    │
    ──────────────────►│  │  • buf1       │    │  • crt1_sel   │    │  • ac_addr   │           │    │
                    │  │               │    │               │    │  • ac_snoop  │           │    │
                    │  │               │    │               │    │  • ac_prot   │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    lsu_biu_cr_valid│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        CR通道                                            │    │
    lsu_biu_cr_resp │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
                    │  │   双缓冲接收   │    │   选择逻辑    │    │   CIU接口    │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  │  • buf0       │    │  • pop_sel    │    │  • crvalid   │           │    │
                    │  │  • buf1       │    │  • crt1_sel   │    │  • crresp    │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    lsu_biu_cd_valid│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        CD通道                                            │    │
    lsu_biu_cd_data │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
    lsu_biu_cd_last │  │   双缓冲接收   │    │   选择逻辑    │    │   CIU接口    │           │    │
    ──────────────────►│  │               │    │               │    │               │           │    │
                    │  │  • buf0       │    │  • pop_sel    │    │  • cdvalid   │           │    │
                    │  │  • buf1       │    │  • crt1_sel   │    │  • cddata    │           │    │
                    │  │               │    │               │    │  • cdlast    │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ biu_xx_snoop_vld | biu_lsu_ac_* | biu_pad_cr_* | biu_pad_cd_*           │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `forever_coreclk` | 1 | 永久核心时钟 |
| `cpurst_b` | 1 | 全局复位信号 |
| `pad_biu_acvalid` | 1 | 监听地址有效 |
| `pad_biu_acaddr[39:0]` | 40 | 监听地址 |
| `pad_biu_acsnoop[3:0]` | 4 | 监听类型 |
| `pad_biu_acprot[2:0]` | 3 | 保护属性 |
| `pad_biu_crready` | 1 | 监听响应就绪 |
| `pad_biu_cdready` | 1 | 监听数据就绪 |
| `lsu_biu_ac_ready` | 1 | LSU监听地址就绪 |
| `lsu_biu_ac_empty` | 1 | LSU监听地址空 |
| `lsu_biu_cr_valid` | 1 | LSU监听响应有效 |
| `lsu_biu_cr_resp[4:0]` | 5 | LSU监听响应 |
| `lsu_biu_cd_valid` | 1 | LSU监听数据有效 |
| `lsu_biu_cd_data[127:0]` | 128 | LSU监听数据 |
| `lsu_biu_cd_last` | 1 | LSU监听数据最后 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `biu_pad_acready` | 1 | 监听地址就绪 |
| `biu_lsu_ac_req` | 1 | LSU监听请求 |
| `biu_lsu_ac_addr[39:0]` | 40 | LSU监听地址 |
| `biu_lsu_ac_snoop[3:0]` | 4 | LSU监听类型 |
| `biu_lsu_ac_prot[2:0]` | 3 | LSU保护属性 |
| `biu_lsu_cr_ready` | 1 | LSU监听响应就绪 |
| `biu_lsu_cd_ready` | 1 | LSU监听数据就绪 |
| `biu_pad_crvalid` | 1 | 监听响应有效 |
| `biu_pad_crresp[4:0]` | 5 | 监听响应 |
| `biu_pad_cdvalid` | 1 | 监听数据有效 |
| `biu_pad_cddata[127:0]` | 128 | 监听数据 |
| `biu_pad_cdlast` | 1 | 监听数据最后 |
| `biu_pad_cderr` | 1 | 监听数据错误 |
| `biu_xx_snoop_vld` | 1 | 监听有效标志 |
| `snoop_ac_clk_en` | 1 | AC通道时钟使能 |
| `snoop_cr_clk_en` | 1 | CR通道时钟使能 |
| `snoop_cd_clk_en` | 1 | CD通道时钟使能 |

## 5. 双缓冲设计

### 5.1 AC通道双缓冲

```verilog
// 缓冲区0
reg [39:0] cur_acaddr_buf0_acaddr;
reg [2:0]  cur_acaddr_buf0_acprot;
reg [3:0]  cur_acaddr_buf0_acsnoop;
reg        cur_acaddr_buf0_acvalid;

// 缓冲区1
reg [39:0] cur_acaddr_buf1_acaddr;
reg [2:0]  cur_acaddr_buf1_acprot;
reg [3:0]  cur_acaddr_buf1_acsnoop;
reg        cur_acaddr_buf1_acvalid;

// 选择信号
reg cur_acaddr_buf_crt1_sel;  // 创建选择
reg cur_acaddr_buf_pop1_sel;  // 弹出选择
```

### 5.2 CR通道双缓冲

```verilog
// 缓冲区0
reg [4:0] cur_craddr_buf0_crresp;
reg       cur_craddr_buf0_crvalid;

// 缓冲区1
reg [4:0] cur_craddr_buf1_crresp;
reg       cur_craddr_buf1_crvalid;

// 选择信号
reg cur_craddr_buf_crt1_sel;
reg cur_craddr_buf_pop1_sel;
```

### 5.3 CD通道双缓冲

```verilog
// 缓冲区0
reg [127:0] cur_cddata_buf0_cddata;
reg         cur_cddata_buf0_cdlast;
reg         cur_cddata_buf0_cdvalid;

// 缓冲区1
reg [127:0] cur_cddata_buf1_cddata;
reg         cur_cddata_buf1_cdlast;
reg         cur_cddata_buf1_cdvalid;

// 选择信号
reg cur_cddata_buf_crt1_sel;
reg cur_cddata_buf_pop1_sel;
```

## 6. 关键逻辑设计

### 6.1 AC通道控制

```verilog
// 缓冲区就绪
assign cur_acaddr_buf_ready = !cur_acaddr_buf0_acvalid || !cur_acaddr_buf1_acvalid;

// 创建使能
assign snoop_req_create_en = cur_acaddr_buf_ready && pad_biu_acvalid;

// 创建选择切换
always @(posedge accpuclk or negedge cpurst_b) begin
    if (!cpurst_b)
        cur_acaddr_buf_crt1_sel <= 1'b0;
    else if (snoop_req_create_en)
        cur_acaddr_buf_crt1_sel <= !cur_acaddr_buf_crt1_sel;
end

// 弹出选择切换
always @(posedge accpuclk or negedge cpurst_b) begin
    if (!cpurst_b)
        cur_acaddr_buf_pop1_sel <= 1'b0;
    else if (cur_acaddr_buf_acvalid && lsu_biu_ac_ready)
        cur_acaddr_buf_pop1_sel <= !cur_acaddr_buf_pop1_sel;
end
```

### 6.2 监听有效标志

```verilog
// 核心监听空判断
assign core_ac_empty = lsu_biu_ac_empty 
                    && !cur_craddr_buf_crvalid 
                    && !cur_cddata_buf_cdvalid;

// 监听有效标志
always @(posedge forever_coreclk or negedge cpurst_b) begin
    if (!cpurst_b)
        core_snoop_vld <= 1'b0;
    else if (snoop_req_create_en)
        core_snoop_vld <= 1'b1;
    else if (core_ac_empty)
        core_snoop_vld <= 1'b0;
end

assign biu_xx_snoop_vld = core_snoop_vld;
```

### 6.3 时钟使能

```verilog
assign snoop_ac_clk_en = cur_acaddr_buf_ready || lsu_biu_ac_ready;
assign snoop_cr_clk_en = lsu_biu_cr_valid || cur_craddr_buf_crvalid;
assign snoop_cd_clk_en = lsu_biu_cd_valid || cur_cddata_buf_cdvalid;
```

## 7. 监听响应编码

### 7.1 CRRESP编码

| 位 | 描述 |
|----|------|
| [0] | Data Transfer - 是否需要数据传输 |
| [1] | Error - 错误标志 |
| [2] | Pass Dirty - 脏数据传递 |
| [3] | Is Shared - 共享状态 |
| [4] | Was Unique - 唯一状态 |

## 8. 时序图

### 8.1 监听操作时序

```
时钟:        T1      T2      T3      T4      T5
            ┌───────┬───────┬───────┬───────┬───────┐
acvalid     ────────┐                       │
                    └───────────────────────┘
acready     ────────────────┐               │
                            └───────────────┘
            
acaddr      [ADDR]  │       │               │
            
lsu_ac_req          ────────┐               │
                            └───────────────┘
            
crvalid                     ────────┐       │
                                    └───────┘
crresp                      [RESP]  │       │
            
cdvalid                             ────────┐
                                            └───────┘
cddata                              [DATA]  │
cdlast                                      ────────
```

## 9. 设计要点

### 9.1 双缓冲优势
- 提高吞吐量
- 减少等待时间
- 支持流水线操作

### 9.2 监听有效性
- 正确处理监听请求
- 维护Cache一致性

### 9.3 数据传输
- 按需传输数据
- 正确处理CDLAST

## 10. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
