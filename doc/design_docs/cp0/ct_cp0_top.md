# ct_cp0_top 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_cp0_top` - CP0（Control and Status Register）顶层模块

### 1.2 功能描述
`ct_cp0_top` 是RISC-V处理器的控制与状态寄存器（CSR）顶层模块，负责协调整个CP0子系统的运行。该模块集成了CSR寄存器模块、IUI接口模块和低功耗管理模块，提供处理器状态管理、异常处理、中断控制等功能。

### 1.3 主要特性
- RISC-V特权架构支持
- 机器模式（M-Mode）、监督模式（S-Mode）、用户模式（U-Mode）
- 完整的CSR寄存器集
- 中断委托机制
- 异常处理支持
- 低功耗管理
- 向量扩展支持

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                            ct_cp0_top                                          │
                    │                                                                                  │
    forever_cpuclk  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        时钟与复位                                        │    │
    cpurst_b        │  │                                                                          │    │
    ──────────────────►│  • 全局时钟分发                                                          │    │
    cp0_yy_clk_en   │  │  • 复位信号分发                                                          │    │
    ──────────────────►│  • 门控时钟控制                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                                                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        ct_cp0_iui                                       │    │
    iu_cp0_ex2_ipupb│  │                                                                          │    │
    ──────────────────►│  • CSR指令译码                                                           │    │
    iu_cp0_ex2_inst │  │  • 读写控制                                                              │    │
    ──────────────────►│  • 异常检测                                                              │    │
    iu_cp0_ex2_src0 │  │  • 权限检查                                                              │    │
    ──────────────────►│                                                                          │    │
    rtu_cp0_expt_vld│  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                              │
    rtu_cp0_epc     │                              │                                              │
    ──────────────────►│                              ▼                                              │
    rtu_cp0_expt_mtval                                                              │
    ──────────────────►│  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        ct_cp0_regs                                       │    │
    biu_cp0_me_int  │  │                                                                          │    │
    ──────────────────►│  • 机器级CSR (mstatus, mepc, mcause...)                                  │    │
    biu_cp0_ms_int  │  │  • 监督级CSR (sstatus, sepc, scause...)                                  │    │
    ──────────────────►│  • 用户级CSR (fcsr, vstart, vl...)                                       │    │
    biu_cp0_mt_int  │  │  • 扩展CSR (mxstatus, mhcr, mhint...)                                    │    │
    ──────────────────►│  • 中断管理                                                              │    │
    biu_cp0_se_int  │  │  • 异常处理                                                              │    │
    ──────────────────►│                                                                          │    │
    biu_cp0_ss_int  │  └─────────────────────────────────────────────────────────────────────────┘    │
    ──────────────────►│                              │                                              │
    biu_cp0_st_int  │                              │                                              │
    ──────────────────►│                              ▼                                              │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        ct_cp0_lpmd                                      │    │
                    │  │                                                                          │    │
                    │  │  • 低功耗模式控制                                                        │    │
                    │  │  • 中断唤醒                                                              │    │
                    │  │  • 电源管理                                                              │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                                                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ cp0_idu_*  | cp0_ifu_*  | cp0_iu_*  | cp0_lsu_*  | cp0_mmu_*            │  │
                    │  │ cp0_rtu_*  | cp0_hpcp_* | cp0_pad_* | cp0_biu_*                        │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 子模块层次结构

```
ct_cp0_top
├── ct_cp0_regs          -- CSR寄存器模块
├── ct_cp0_iui           -- IUI接口模块（CSR指令处理）
└── ct_cp0_lpmd          -- 低功耗管理模块
```

## 4. 接口定义

### 4.1 时钟与复位

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| `forever_cpuclk` | 输入 | 1 | 永久CPU时钟 |
| `cpurst_b` | 输入 | 1 | 全局复位信号，低有效 |
| `cp0_yy_clk_en` | 输入 | 1 | CP0时钟使能 |
| `pad_yy_icg_scan_en` | 输入 | 1 | 扫描使能信号 |

### 4.2 IU接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| `iu_cp0_ex2_ipupb` | 输入 | 1 | EX2阶段IPU流水线更新 |
| `iu_cp0_ex2_inst[31:0]` | 输入 | 32 | EX2阶段指令 |
| `iu_cp0_ex2_src0[63:0]` | 输入 | 64 | EX2阶段源操作数 |
| `cp0_iu_ex2_data[63:0]` | 输出 | 64 | EX2阶段CSR读数据 |
| `cp0_iu_ex2_ipuseq` | 输出 | 1 | EX2阶段IPU顺序信号 |

### 4.3 RTU接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| `rtu_cp0_expt_vld` | 输入 | 1 | 异常有效信号 |
| `rtu_cp0_epc[63:0]` | 输入 | 64 | 异常PC值 |
| `rtu_cp0_expt_mtval[63:0]` | 输入 | 64 | 异常值 |
| `rtu_yy_xx_expt_vec[5:0]` | 输入 | 6 | 异常向量 |
| `rtu_yy_xx_flush` | 输入 | 1 | 流水线刷新 |
| `cp0_rtu_expt_vec[7:0]` | 输出 | 8 | 异常向量输出 |
| `cp0_rtu_mret` | 输出 | 1 | MRET指令信号 |
| `cp0_rtu_sret` | 输出 | 1 | SRET指令信号 |

### 4.4 中断接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| `biu_cp0_me_int` | 输入 | 1 | 机器外部中断 |
| `biu_cp0_ms_int` | 输入 | 1 | 机器软件中断 |
| `biu_cp0_mt_int` | 输入 | 1 | 机器定时器中断 |
| `biu_cp0_se_int` | 输入 | 1 | 监督外部中断 |
| `biu_cp0_ss_int` | 输入 | 1 | 监督软件中断 |
| `biu_cp0_st_int` | 输入 | 1 | 监督定时器中断 |

### 4.5 系统状态输出

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| `cp0_yy_priv_mode[1:0]` | 输出 | 2 | 当前特权模式 |
| `cp0_yy_virtual_mode` | 输出 | 1 | 虚拟化模式 |
| `cp0_yy_hyper` | 输出 | 1 | 超级监督者模式 |
| `cp0_xx_core_icg_en` | 输出 | 1 | 核心门控时钟使能 |

## 5. 子模块实例化

### 5.1 ct_cp0_regs 实例

```verilog
ct_cp0_regs x_ct_cp0_regs (
    .forever_cpuclk    (forever_cpuclk),
    .cpurst_b          (cpurst_b),
    .cp0_yy_clk_en     (cp0_yy_clk_en),
    // IUI接口
    .iui_regs_sel      (iui_regs_sel),
    .iui_regs_addr     (iui_regs_addr),
    .iui_regs_src0     (iui_regs_src0),
    .regs_iui_data_out (regs_iui_data_out),
    // 中断接口
    .biu_cp0_me_int    (biu_cp0_me_int),
    .biu_cp0_ms_int    (biu_cp0_ms_int),
    // ... 其他端口
);
```

### 5.2 ct_cp0_iui 实例

```verilog
ct_cp0_iui x_ct_cp0_iui (
    .forever_cpuclk    (forever_cpuclk),
    .cpurst_b          (cpurst_b),
    .cp0_yy_clk_en     (cp0_yy_clk_en),
    // IU接口
    .iu_cp0_ex2_inst   (iu_cp0_ex2_inst),
    .iu_cp0_ex2_src0   (iu_cp0_ex2_src0),
    // 寄存器接口
    .regs_iui_data_out (regs_iui_data_out),
    .iui_regs_sel      (iui_regs_sel),
    // ... 其他端口
);
```

### 5.3 ct_cp0_lpmd 实例

```verilog
ct_cp0_lpmd x_ct_cp0_lpmd (
    .forever_cpuclk    (forever_cpuclk),
    .cpurst_b          (cpurst_b),
    .cp0_yy_clk_en     (cp0_yy_clk_en),
    // 低功耗控制
    .regs_lpmd_int_vld (regs_lpmd_int_vld),
    // ... 其他端口
);
```

## 6. 特权模式

### 6.1 特权级别

| 模式 | 编码 | 描述 |
|------|------|------|
| M-Mode | 2'b11 | 机器模式，最高特权级 |
| S-Mode | 2'b01 | 监督模式 |
| U-Mode | 2'b00 | 用户模式，最低特权级 |

### 6.2 特权模式切换

```
异常发生时:
  U-Mode → M-Mode (mpp = 00)
  S-Mode → M-Mode (mpp = 01) 或 S-Mode (委托)
  M-Mode → M-Mode (mpp = 11)

异常返回时:
  MRET: 从mpp恢复
  SRET: 从spp恢复
```

## 7. CSR地址空间

### 7.1 地址分配

| 地址范围 | 特权级 | 描述 |
|----------|--------|------|
| 0x000-0x0FF | User | 用户级CSR |
| 0x100-0x1FF | Supervisor | 监督级CSR |
| 0x200-0x2FF | Hypervisor | 超级监督者CSR |
| 0x300-0x3FF | Machine | 机器级CSR |
| 0x7C0-0x7FF | Machine | C-SKY扩展CSR |
| 0xFC0-0xFFF | Machine | 处理器ID CSR |

### 7.2 主要CSR列表

| 地址 | 名称 | 描述 |
|------|------|------|
| 0x300 | mstatus | 机器状态寄存器 |
| 0x301 | misa | ISA扩展寄存器 |
| 0x302 | medeleg | 机器异常委托 |
| 0x303 | mideleg | 机器中断委托 |
| 0x304 | mie | 机器中断使能 |
| 0x305 | mtvec | 机器陷入向量 |
| 0x340 | mscratch | 机器暂存寄存器 |
| 0x341 | mepc | 机器异常PC |
| 0x342 | mcause | 机器异常原因 |
| 0x343 | mtval | 机器陷入值 |
| 0x344 | mip | 机器中断挂起 |
| 0x100 | sstatus | 监督状态寄存器 |
| 0x104 | sie | 监督中断使能 |
| 0x105 | stvec | 监督陷入向量 |
| 0x141 | sepc | 监督异常PC |
| 0x142 | scause | 监督异常原因 |
| 0x143 | stval | 监督陷入值 |
| 0x180 | satp | 监督地址翻译 |

## 8. 设计要点

### 8.1 CSR访问权限
- User级CSR在U-Mode可读
- Supervisor级CSR在S-Mode及以上可访问
- Machine级CSR仅在M-Mode可访问

### 8.2 异常处理
- 异常发生时自动保存PC到epc
- 设置cause寄存器记录异常原因
- 设置mtval/stval记录附加信息
- 切换到对应特权模式

### 8.3 中断委托
- medeleg: 异常委托设置
- mideleg: 中断委托设置
- 委托后异常/中断由S-Mode处理

## 9. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
