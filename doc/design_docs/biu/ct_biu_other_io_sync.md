# ct_biu_other_io_sync 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_biu_other_io_sync` - BIU其他IO同步模块

### 1.2 功能描述
`ct_biu_other_io_sync` 是BIU的其他IO同步模块，负责处理器与外部系统之间的信号同步。该模块处理中断信号、调试信号、CSR接口信号、定时器信号等的跨时钟域同步和缓冲。

### 1.3 主要特性
- 中断信号同步
- 调试信号同步
- CSR接口同步
- 定时器信号处理
- 复位向量配置
- 低功耗模式信号处理

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                     ct_biu_other_io_sync                                      │
                    │                                                                                  │
    pad_biu_me_int  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        中断同步                                          │    │
    pad_biu_ms_int  │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
    pad_biu_mt_int  │  │   ME中断同步   │    │   MS中断同步   │    │   MT中断同步   │           │    │
    ──────────────────►│  │               │    │               │    │               │           │    │
    pad_biu_se_int  │  │  • ff1同步     │    │  • ff1同步     │    │  • ff1同步     │           │    │
    ──────────────────►│  │  • ff2同步     │    │  • ff2同步     │    │  • ff2同步     │           │    │
    pad_biu_ss_int  │  │               │    │               │    │               │           │    │
    ──────────────────►│  └───────────────┘    └───────────────┘    └───────────────┘           │    │
    pad_biu_st_int  │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
                    │  │   SE中断同步   │    │   SS中断同步   │    │   ST中断同步   │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  │  • ff1同步     │    │  • ff1同步     │    │  • ff1同步     │           │    │
                    │  │  • ff2同步     │    │  • ff2同步     │    │  • ff2同步     │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    pad_biu_dbgrq_b│  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        调试信号同步                                      │    │
                    │  │                                                                          │    │
                    │  │  • 调试请求同步 (ff1, ff2)                                              │    │
                    │  │  • 调试唤醒信号生成                                                      │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    biu_csr_sel     │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        CSR接口同步                                       │    │
    biu_csr_op      │  │                                                                          │    │
    ──────────────────►│  • CSR选择信号同步                                                       │    │
    biu_csr_wdata   │  │  • CSR写数据同步                                                         │    │
    ──────────────────►│  • CSR读数据同步                                                         │    │
    pad_biu_csr_cmplt│  │  • CSR完成信号同步                                                       │    │
    ──────────────────►│                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    pad_xx_time     │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        定时器信号                                        │    │
    hpcp_biu_cnt_en │  │                                                                          │    │
    ──────────────────►│  • 时间戳同步                                                            │    │
    pad_biu_hpcp_l2of_int│  • 计数器使能同步                                                     │    │
    ──────────────────►│  • L2溢出中断同步                                                        │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    pad_core_hartid │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        配置信号                                          │    │
    pad_core_rvba   │  │                                                                          │    │
    ──────────────────►│  • CPU ID传递                                                            │    │
    pad_xx_apb_base │  │  • 复位向量基址传递                                                       │    │
    ──────────────────►│  • APB基址传递                                                           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    cp0_biu_lpmd_b  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        低功耗信号                                        │    │
    had_biu_jdb_pm  │  │                                                                          │    │
    ──────────────────►│  • 低功耗模式信号同步                                                    │    │
                    │  │  • 调试电源管理信号同步                                                  │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ biu_cp0_* | biu_had_* | biu_hpcp_* | biu_pad_* | biu_xx_*               │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `coreclk` | 1 | 核心时钟 |
| `forever_coreclk` | 1 | 永久核心时钟 |
| `cpurst_b` | 1 | 全局复位信号 |
| `cp0_biu_icg_en` | 1 | CP0门控时钟使能 |
| `pad_yy_icg_scan_en` | 1 | 扫描使能 |
| `pad_biu_me_int` | 1 | 机器外部中断 |
| `pad_biu_ms_int` | 1 | 机器软件中断 |
| `pad_biu_mt_int` | 1 | 机器定时器中断 |
| `pad_biu_se_int` | 1 | 监督外部中断 |
| `pad_biu_ss_int` | 1 | 监督软件中断 |
| `pad_biu_st_int` | 1 | 监督定时器中断 |
| `pad_biu_dbgrq_b` | 1 | 调试请求 |
| `biu_csr_sel` | 1 | CSR选择 |
| `biu_csr_op[15:0]` | 16 | CSR操作码 |
| `biu_csr_wdata[63:0]` | 64 | CSR写数据 |
| `pad_biu_csr_cmplt` | 1 | CSR操作完成 |
| `pad_biu_csr_rdata[127:0]` | 128 | CSR读数据 |
| `pad_xx_time[63:0]` | 64 | 时间戳 |
| `hpcp_biu_cnt_en[3:0]` | 4 | 计数器使能 |
| `pad_biu_hpcp_l2of_int[3:0]` | 4 | L2溢出中断 |
| `pad_core_hartid[2:0]` | 3 | CPU ID |
| `pad_core_rvba[39:0]` | 40 | 复位向量基址 |
| `pad_xx_apb_base[39:0]` | 40 | APB基址 |
| `cp0_biu_lpmd_b[1:0]` | 2 | 低功耗模式 |
| `had_biu_jdb_pm[1:0]` | 2 | 调试电源管理 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `biu_cp0_me_int` | 1 | 同步后的机器外部中断 |
| `biu_cp0_ms_int` | 1 | 同步后的机器软件中断 |
| `biu_cp0_mt_int` | 1 | 同步后的机器定时器中断 |
| `biu_cp0_se_int` | 1 | 同步后的监督外部中断 |
| `biu_cp0_ss_int` | 1 | 同步后的监督软件中断 |
| `biu_cp0_st_int` | 1 | 同步后的监督定时器中断 |
| `biu_cp0_coreid[2:0]` | 3 | CPU ID |
| `biu_cp0_rvba[39:0]` | 40 | 复位向量基址 |
| `biu_cp0_apb_base[39:0]` | 40 | APB基址 |
| `biu_had_sdb_req_b` | 1 | 同步后的调试请求 |
| `biu_had_coreid[1:0]` | 2 | CPU ID (调试用) |
| `biu_csr_cmplt` | 1 | CSR操作完成 |
| `biu_csr_rdata[127:0]` | 128 | CSR读数据 |
| `biu_pad_csr_sel` | 1 | CSR选择输出 |
| `biu_pad_csr_wdata[79:0]` | 80 | CSR写数据输出 |
| `biu_hpcp_time[63:0]` | 64 | 同步后的时间戳 |
| `biu_pad_cnt_en[3:0]` | 4 | 计数器使能输出 |
| `biu_hpcp_l2of_int[3:0]` | 4 | 同步后的L2溢出中断 |
| `biu_pad_lpmd_b` | 1 | 低功耗模式输出 |
| `biu_pad_jdb_pm` | 1 | 调试电源管理输出 |
| `biu_xx_int_wakeup` | 1 | 中断唤醒信号 |
| `biu_xx_dbg_wakeup` | 1 | 调试唤醒信号 |
| `biu_xx_normal_work` | 1 | 正常工作标志 |
| `biu_mmu_smp_disable` | 1 | MMU SMP禁用 |
| `biu_xx_pmp_sel` | 1 | PMP选择 |

## 4. 关键逻辑设计

### 4.1 中断信号同步

```verilog
// 两级同步器防止亚稳态
always @(posedge forever_coreclk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        cp0_me_int_ff1 <= 1'b0;
        cp0_me_int_ff2 <= 1'b0;
        // ... 其他中断信号
    end else begin
        cp0_me_int_ff1 <= pad_biu_me_int;
        cp0_me_int_ff2 <= cp0_me_int_ff1;
        // ... 其他中断信号
    end
end

assign biu_cp0_me_int = cp0_me_int_ff2;
```

### 4.2 中断唤醒信号

```verilog
// 任意中断都可以唤醒处理器
assign biu_xx_int_wakeup = cp0_me_int_ff2 | cp0_mt_int_ff2 | cp0_ms_int_ff2 |
                           cp0_se_int_ff2 | cp0_st_int_ff2 | cp0_ss_int_ff2;
```

### 4.3 调试信号同步

```verilog
always @(posedge forever_coreclk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        had_sdb_req_b_ff1 <= 1'b1;
        had_sdb_req_b_ff2 <= 1'b1;
    end else begin
        had_sdb_req_b_ff1 <= pad_biu_dbgrq_b;
        had_sdb_req_b_ff2 <= had_sdb_req_b_ff1;
    end
end

assign biu_had_sdb_req_b = had_sdb_req_b_ff2;
assign biu_xx_dbg_wakeup = !had_sdb_req_b_ff2;
```

### 4.4 CSR接口同步

```verilog
// CSR选择脉冲生成
always @(posedge l2reg_oclk or negedge cpurst_b) begin
    if (!cpurst_b)
        biu_csr_sel_ff <= 1'b0;
    else
        biu_csr_sel_ff <= biu_csr_sel;
end

assign csr_sel_pulse = biu_csr_sel & !biu_csr_sel_ff;

// CSR数据打包
assign biu_csr_req_data[79:0] = {biu_csr_op[15:0], biu_csr_wdata[63:0]};

always @(posedge l2reg_oclk) begin
    if (csr_sel_pulse)
        biu_pad_csr_wdata[79:0] <= biu_csr_req_data[79:0];
end
```

### 4.5 配置信号传递

```verilog
// CPU ID直接传递
assign biu_cp0_coreid[2:0] = pad_core_hartid[2:0];
assign biu_had_coreid[1:0] = pad_core_hartid[1:0];

// 复位向量基址寄存
always @(posedge coreclk) begin
    biu_cp0_rvba[39:0] <= pad_core_rvba[39:0];
end

// APB基址寄存
always @(posedge coreclk) begin
    biu_cp0_apb_base[39:0] <= pad_xx_apb_base[39:0];
end
```

### 4.6 低功耗信号处理

```verilog
always @(posedge forever_coreclk or negedge cpurst_b) begin
    if (!cpurst_b) begin
        biu_pad_lpmd_b <= 1'b1;
        biu_pad_jdb_pm <= 1'b0;
    end else begin
        biu_pad_lpmd_b <= cp0_biu_lpmd_b[0];
        biu_pad_jdb_pm <= had_biu_jdb_pm[1];
    end
end

assign biu_xx_normal_work = biu_pad_lpmd_b;
```

## 5. 时序图

### 5.1 中断同步时序

```
时钟:        T1      T2      T3      T4
            ┌───────┬───────┬───────┬───────┐
pad_biu_me_int────────┐               │
                        └───────────────┘
            
ff1         ────────────────┐           │
                            └───────────┘
            
ff2         ────────────────────────┐   │
                                    └───┘
            
biu_cp0_me_int─────────────────────────┐
                                        └───
```

## 6. 设计要点

### 6.1 两级同步器
- 所有异步输入信号使用两级同步器
- 防止亚稳态传播
- 确保时序稳定

### 6.2 时钟域隔离
- 使用forever_coreclk作为同步时钟
- CSR接口使用独立门控时钟
- 定时器使用coreclk

### 6.3 唤醒信号生成
- 中断唤醒信号汇总
- 调试唤醒信号独立
- 支持低功耗模式唤醒

## 7. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
