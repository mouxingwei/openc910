# ct_biu_lowpower 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_biu_lowpower` - BIU低功耗管理模块

### 1.2 功能描述
`ct_biu_lowpower` 是BIU的低功耗管理模块，负责BIU各子模块的门控时钟生成和低功耗状态管理。该模块通过门控时钟技术降低动态功耗，并生成低功耗状态指示信号。

### 1.3 主要特性
- 多通道独立门控时钟
- 读/写通道时钟管理
- 监听通道时钟管理
- 低功耗状态指示
- 动态时钟使能控制

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                       ct_biu_lowpower                                         │
                    │                                                                                  │
    coreclk         │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    forever_coreclk │  │                        门控时钟生成                                      │    │
    ──────────────────►│                                                                          │    │
    cp0_biu_icg_en  │  │  ┌───────────────────────────────────────────────────────────────────┐  │    │
    ──────────────────►│  │                    读通道门控时钟                                   │  │    │
    pad_yy_icg_scan_en│  │  │                                                                    │  │    │
    ──────────────────►│  │  │  ┌─────────────┐    ┌─────────────┐                            │  │    │
                    │  │  │  │ AR通道门控  │    │ R通道门控   │                            │  │    │
    read_ar_clk_en  │  │  │  │             │    │             │                            │  │    │
    ──────────────────►│  │  │  │ arcpuclk   │    │ rcpuclk     │                            │  │    │
    read_r_clk_en   │  │  │  │             │    │             │                            │  │    │
    ──────────────────►│  │  │  └─────────────┘    └─────────────┘                            │  │    │
                    │  │  │                                                                    │  │    │
    vict_aw_clk_en  │  │  └───────────────────────────────────────────────────────────────────┘  │    │
    ──────────────────►│                                                                          │    │
    st_aw_clk_en    │  │  ┌───────────────────────────────────────────────────────────────────┐  │    │
    ──────────────────►│  │                    写通道门控时钟                                   │  │    │
    vict_w_clk_en   │  │  │                                                                    │  │    │
    ──────────────────►│  │  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │  │    │
    st_w_clk_en     │  │  │  │ Victim AW   │    │ Store AW    │    │ B通道门控   │        │  │    │
    ──────────────────►│  │  │  │ 门控        │    │ 门控        │    │             │        │  │    │
    round_w_clk_en  │  │  │  │ vict_awcpuclk│    │ st_awcpuclk │    │ bcpuclk     │        │  │    │
    ──────────────────►│  │  │  └─────────────┘    └─────────────┘    └─────────────┘        │  │    │
    write_b_clk_en  │  │  │                                                                    │  │    │
    ──────────────────►│  │  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │  │    │
                    │  │  │  │ Victim W    │    │ Store W     │    │ Round W     │        │  │    │
    snoop_ac_clk_en │  │  │  │ 门控        │    │ 门控        │    │ 门控        │        │  │    │
    ──────────────────►│  │  │  │ vict_wcpuclk│    │ st_wcpuclk  │    │ round_wcpuclk│       │  │    │
    snoop_cr_clk_en │  │  │  └─────────────┘    └─────────────┘    └─────────────┘        │  │    │
    ──────────────────►│  │  │                                                                    │  │    │
    snoop_cd_clk_en │  │  └───────────────────────────────────────────────────────────────────┘  │    │
    ──────────────────►│                                                                          │    │
                    │  │  ┌───────────────────────────────────────────────────────────────────┐  │    │
    read_busy       │  │  │                    监听通道门控时钟                                 │  │    │
    ──────────────────►│  │  │                                                                    │  │    │
    write_busy      │  │  │  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │  │    │
    ──────────────────►│  │  │  │ AC通道门控  │    │ CR通道门控  │    │ CD通道门控  │        │  │    │
                    │  │  │  │             │    │             │    │             │        │  │    │
                    │  │  │  │ accpuclk    │    │ crcpuclk    │    │ cdcpuclk    │        │  │    │
                    │  │  │  └─────────────┘    └─────────────┘    └─────────────┘        │  │    │
                    │  │  │                                                                    │  │    │
                    │  │  └───────────────────────────────────────────────────────────────────┘  │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        低功耗状态                                      │    │
                    │  │                                                                          │    │
                    │  │  biu_yy_xx_no_op = !read_busy && !write_busy                            │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ arcpuclk | rcpuclk | vict_awcpuclk | st_awcpuclk | vict_wcpuclk        │  │
                    │  │ st_wcpuclk | round_wcpuclk | bcpuclk | accpuclk | crcpuclk | cdcpuclk  │  │
                    │  │ biu_yy_xx_no_op                                                        │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `coreclk` | 1 | 核心时钟 |
| `forever_coreclk` | 1 | 永久核心时钟 |
| `cp0_biu_icg_en` | 1 | CP0门控时钟使能 |
| `pad_yy_icg_scan_en` | 1 | 扫描使能 |
| `read_ar_clk_en` | 1 | 读AR通道时钟使能 |
| `read_r_clk_en` | 1 | 读R通道时钟使能 |
| `vict_aw_clk_en` | 1 | Victim AW通道时钟使能 |
| `st_aw_clk_en` | 1 | Store AW通道时钟使能 |
| `vict_w_clk_en` | 1 | Victim W通道时钟使能 |
| `st_w_clk_en` | 1 | Store W通道时钟使能 |
| `round_w_clk_en` | 1 | Round W通道时钟使能 |
| `write_b_clk_en` | 1 | 写B通道时钟使能 |
| `snoop_ac_clk_en` | 1 | 监听AC通道时钟使能 |
| `snoop_cr_clk_en` | 1 | 监听CR通道时钟使能 |
| `snoop_cd_clk_en` | 1 | 监听CD通道时钟使能 |
| `read_busy` | 1 | 读通道忙标志 |
| `write_busy` | 1 | 写通道忙标志 |
| `bus_arb_w_fifo_clk_en` | 1 | 总线仲裁写FIFO时钟使能 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `arcpuclk` | 1 | 读AR通道门控时钟 |
| `rcpuclk` | 1 | 读R通道门控时钟 |
| `vict_awcpuclk` | 1 | Victim AW通道门控时钟 |
| `st_awcpuclk` | 1 | Store AW通道门控时钟 |
| `vict_wcpuclk` | 1 | Victim W通道门控时钟 |
| `st_wcpuclk` | 1 | Store W通道门控时钟 |
| `round_wcpuclk` | 1 | Round W通道门控时钟 |
| `bcpuclk` | 1 | 写B通道门控时钟 |
| `accpuclk` | 1 | 监听AC通道门控时钟 |
| `crcpuclk` | 1 | 监听CR通道门控时钟 |
| `cdcpuclk` | 1 | 监听CD通道门控时钟 |
| `bus_arb_w_fifo_clk` | 1 | 总线仲裁写FIFO门控时钟 |
| `biu_yy_xx_no_op` | 1 | 无操作标志（低功耗状态） |

## 4. 门控时钟单元

### 4.1 门控时钟单元实例化

```verilog
// 读通道AR门控时钟
gated_clk_cell x_read_channel_ar_gated_cell (
    .clk_in             (coreclk           ),
    .clk_out            (arcpuclk          ),
    .external_en        (1'b0              ),
    .global_en          (1'b1              ),
    .local_en           (read_ar_clk_en    ),
    .module_en          (cp0_biu_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// 读通道R门控时钟
gated_clk_cell x_read_channel_r_gated_cell (
    .clk_in             (coreclk           ),
    .clk_out            (rcpuclk           ),
    .external_en        (1'b0              ),
    .global_en          (1'b1              ),
    .local_en           (read_r_clk_en     ),
    .module_en          (cp0_biu_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// 写通道Victim AW门控时钟
gated_clk_cell x_write_channel_vict_aw_gated_cell (
    .clk_in             (coreclk           ),
    .clk_out            (vict_awcpuclk     ),
    .external_en        (1'b0              ),
    .global_en          (1'b1              ),
    .local_en           (vict_aw_clk_en    ),
    .module_en          (cp0_biu_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

// 监听通道AC门控时钟
gated_clk_cell x_snoop_channel_ac_gated_cell (
    .clk_in             (forever_coreclk   ),
    .clk_out            (accpuclk          ),
    .external_en        (1'b0              ),
    .global_en          (1'b1              ),
    .local_en           (snoop_ac_clk_en   ),
    .module_en          (cp0_biu_icg_en    ),
    .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);
```

## 5. 低功耗状态

### 5.1 无操作状态

```verilog
// 当读写通道都空闲时，表示无操作状态
assign biu_yy_xx_no_op = !read_busy && !write_busy;
```

### 5.2 时钟使能策略

| 通道 | 时钟使能条件 |
|------|-------------|
| AR通道 | 有读请求或AR状态非空闲 |
| R通道 | 有读数据或数据有效 |
| AW通道 | 有写请求或AW状态非空闲 |
| W通道 | 有写数据或数据传输中 |
| B通道 | 有写响应或响应有效 |
| AC通道 | 有监听请求或缓冲区非空 |
| CR通道 | 有监听响应或响应有效 |
| CD通道 | 有监听数据或数据有效 |

## 6. 时钟域划分

### 6.1 时钟域列表

| 时钟域 | 时钟源 | 用途 |
|--------|--------|------|
| arcpuclk | coreclk | 读地址通道 |
| rcpuclk | coreclk | 读数据通道 |
| vict_awcpuclk | coreclk | Victim写地址通道 |
| st_awcpuclk | coreclk | Store写地址通道 |
| vict_wcpuclk | coreclk | Victim写数据通道 |
| st_wcpuclk | coreclk | Store写数据通道 |
| round_wcpuclk | coreclk | Round写数据通道 |
| bcpuclk | coreclk | 写响应通道 |
| accpuclk | forever_coreclk | 监听地址通道 |
| crcpuclk | coreclk | 监听响应通道 |
| cdcpuclk | coreclk | 监听数据通道 |

## 7. 设计要点

### 7.1 门控时钟优化
- 各通道独立门控
- 仅在需要时使能时钟
- 减少动态功耗

### 7.2 时钟域隔离
- 读/写通道独立时钟
- 监听通道独立时钟
- 避免时钟域交叉问题

### 7.3 低功耗状态检测
- 监测通道忙状态
- 生成无操作标志
- 支持系统级低功耗管理

## 8. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
