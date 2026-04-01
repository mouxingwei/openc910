# ct_cp0_regs 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_cp0_regs` - 控制与状态寄存器模块

### 1.2 功能描述
`ct_cp0_regs` 是CP0的核心寄存器模块，实现了RISC-V特权架构中定义的所有控制与状态寄存器（CSR）。该模块包含机器级、监督级、用户级以及C-SKY扩展的CSR寄存器，负责处理器状态管理、中断控制、异常处理、性能计数等功能。

### 1.3 主要特性
- 完整的RISC-V CSR实现
- 机器级CSR（mstatus, mepc, mcause等）
- 监督级CSR（sstatus, sepc, scause等）
- 用户级CSR（fcsr, vstart, vl等）
- C-SKY扩展CSR（mxstatus, mhcr, mhint等）
- 中断委托机制
- 异常处理支持
- 性能计数器
- 向量扩展支持

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                            ct_cp0_regs                                         │
                    │                                                                                  │
    iui_regs_sel    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        CSR译码与选择                                     │    │
    iui_regs_addr[11:0]│                                                                          │    │
    ──────────────────►│  • CSR地址译码                                                           │    │
    iui_regs_src0[63:0]│  • 读写使能生成                                                          │    │
    ──────────────────►│  • 权限检查                                                              │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │              ┌───────────────┼───────────────┬───────────────┐                │
                    │              ▼               ▼               ▼               ▼                │
                    │  ┌───────────────────┐ ┌───────────────────┐ ┌───────────────────┐            │
                    │  │   机器级CSR       │ │   监督级CSR       │ │   用户级CSR       │            │
                    │  │                   │ │                   │ │                   │            │
                    │  │ • mstatus         │ │ • sstatus         │ │ • fflags          │            │
                    │  │ • misa            │ │ • sie             │ │ • frm             │            │
                    │  │ • medeleg         │ │ • stvec           │ │ • fcsr            │            │
                    │  │ • mideleg         │ │ • sscratch        │ │ • vstart          │            │
                    │  │ • mie             │ │ • sepc            │ │ • vl              │            │
                    │  │ • mtvec           │ │ • scause          │ │ • vtype           │            │
                    │  │ • mscratch        │ │ • stval           │ │ • vxsat           │            │
                    │  │ • mepc            │ │ • sip             │ │ • vxrm            │            │
                    │  │ • mcause          │ │ • satp            │ │                   │            │
                    │  │ • mtval           │ │                   │ │                   │            │
                    │  │ • mip             │ │                   │ │                   │            │
                    │  └───────────────────┘ └───────────────────┘ └───────────────────┘            │
                    │              │               │               │                                │
                    │              └───────────────┼───────────────┘                                │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        C-SKY扩展CSR                                     │    │
                    │  │                                                                          │    │
                    │  │ • mxstatus  • mhcr     • mcor    • mccr2    • mcer2                    │    │
                    │  │ • mhint     • mhint2   • mhint3  • mhint4   • mcntwen                   │    │
                    │  │ • mcins     • mcindex  • mcdata0 • mcdata1  • meicr                     │    │
                    │  │ • mcpuid    • mapbaddr  • mwmsr                                        │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        中断控制逻辑                                     │    │
                    │  │                                                                          │    │
                    │  │  • 中断使能 (mie/sie)                                                   │    │
                    │  │  • 中断挂起 (mip/sip)                                                   │    │
                    │  │  • 中断委托 (mideleg)                                                   │    │
                    │  │  • 中断选择输出                                                         │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ regs_iui_data_out[63:0] | cp0_*_* | regs_lpmd_int_vld                   │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. CSR寄存器分类

### 3.1 机器信息寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0xF11 | mvendorid | 厂商ID | RO |
| 0xF12 | marchid | 架构ID | RO |
| 0xF13 | mimpid | 实现ID | RO |
| 0xF14 | mhartid | 硬件线程ID | RO |

### 3.2 机器陷入设置寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x300 | mstatus | 机器状态 | RW |
| 0x301 | misa | ISA扩展 | RW |
| 0x302 | medeleg | 机器异常委托 | RW |
| 0x303 | mideleg | 机器中断委托 | RW |
| 0x304 | mie | 机器中断使能 | RW |
| 0x305 | mtvec | 机器陷入向量 | RW |
| 0x306 | mcnten | 机器计数器使能 | RW |

### 3.3 机器陷入处理寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x340 | mscratch | 机器暂存 | RW |
| 0x341 | mepc | 机器异常PC | RW |
| 0x342 | mcause | 机器异常原因 | RW |
| 0x343 | mtval | 机器陷入值 | RW |
| 0x344 | mip | 机器中断挂起 | RW |

### 3.4 监督级寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x100 | sstatus | 监督状态 | RW |
| 0x104 | sie | 监督中断使能 | RW |
| 0x105 | stvec | 监督陷入向量 | RW |
| 0x140 | sscratch | 监督暂存 | RW |
| 0x141 | sepc | 监督异常PC | RW |
| 0x142 | scause | 监督异常原因 | RW |
| 0x143 | stval | 监督陷入值 | RW |
| 0x144 | sip | 监督中断挂起 | RW |
| 0x180 | satp | 监督地址翻译 | RW |

### 3.5 用户浮点寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x001 | fflags | 浮点异常标志 | RW |
| 0x002 | frm | 浮点舍入模式 | RW |
| 0x003 | fcsr | 浮点控制状态 | RW |

### 3.6 用户向量寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x008 | vstart | 向量起始元素 | RW |
| 0x009 | vxsat | 向量饱和标志 | RW |
| 0x00A | vxrm | 向量舍入模式 | RW |
| 0x00F | vcsr | 向量控制状态 | RW |
| 0xC20 | vl | 向量长度 | RO |
| 0xC21 | vtype | 向量类型 | RO |
| 0xC22 | vlenb | 向量长度字节 | RO |

### 3.7 C-SKY扩展寄存器

| 地址 | 名称 | 描述 | 访问 |
|------|------|------|------|
| 0x7C0 | mxstatus | 扩展状态 | RW |
| 0x7C1 | mhcr | 硬件控制 | RW |
| 0x7C2 | mcor | 缓存操作 | RW |
| 0x7C3 | mccr2 | 缓存控制2 | RW |
| 0x7C5 | mhint | 硬件提示 | RW |
| 0x7C9 | mcntwen | 计数器写使能 | RW |
| 0x7D2 | mcins | 缓存指令 | RW |
| 0x7D3 | mcindex | 缓存索引 | RW |
| 0x7D4 | mcdata0 | 缓存数据0 | RW |
| 0x7D5 | mcdata1 | 缓存数据1 | RW |
| 0xFC0 | mcpuid | CPU ID | RO |

## 4. 关键寄存器设计

### 4.1 MSTATUS寄存器

```
|63|62-40|39|38-36|35-34|33-32|31-25|24-23|22|21|20|19|18|17|16-15|14-13|12-11|10-9|8|7|6|5|4|3|2|1|0|
|SD| Res |MPV| Res | SXL | UXL | Res | VS  |TSR|TW|TVM|MXR|SUM|MPRV| Res | FS  | MPP |Res|SPP|MPIE|Res|SPIE|Res|MIE|Res|SIE|Res|
```

**关键字段说明：**
- SD: 状态脏位（FS/VS/XS为11时置位）
- VS[1:0]: 向量状态（00=Off, 01=Initial, 10=Clean, 11=Dirty）
- FS[1:0]: 浮点状态
- MPP[1:0]: 机器先前特权模式
- SPP: 监督先前特权模式
- MIE/SIE: 机器/监督中断使能

### 4.2 MCAUSE寄存器

```
|63|62-4|3-0|
|Interrupt| Res | Exception Code |
```

**异常编码：**
| 编码 | 名称 | 描述 |
|------|------|------|
| 0 | Instruction address misaligned | 指令地址未对齐 |
| 1 | Instruction access fault | 指令访问错误 |
| 2 | Illegal instruction | 非法指令 |
| 3 | Breakpoint | 断点 |
| 4 | Load address misaligned | 加载地址未对齐 |
| 5 | Load access fault | 加载访问错误 |
| 6 | Store/AMO address misaligned | 存储/原子地址未对齐 |
| 7 | Store/AMO access fault | 存储/原子访问错误 |
| 8 | Environment call from U-mode | U模式环境调用 |
| 9 | Environment call from S-mode | S模式环境调用 |
| 11 | Environment call from M-mode | M模式环境调用 |
| 12 | Instruction page fault | 指令页错误 |
| 13 | Load page fault | 加载页错误 |
| 15 | Store/AMO page fault | 存储/原子页错误 |

### 4.3 中断处理

```verilog
// 中断选择逻辑
assign int_sel[14:0] = {
    mcip_nodeleg_vld, mhip_nodeleg_vld,
    meip_vld, msip_vld, mtip_vld,
    seip_nodeleg_vld, ssip_nodeleg_vld, stip_nodeleg_vld,
    moip_nodeleg_vld,
    mcip_deleg_vld, mhip_deleg_vld,
    seip_deleg_vld, ssip_deleg_vld, stip_deleg_vld,
    moip_deleg_vld
};
```

## 5. 门控时钟设计

```verilog
// 寄存器时钟
assign regs_clk_en = iui_regs_sel || idu_cp0_fesr_acc_updt_vld;

gated_clk_cell x_regs_gated_clk (
    .clk_in     (forever_cpuclk),
    .clk_out    (regs_clk),
    .global_en  (cp0_yy_clk_en),
    .local_en   (regs_clk_en),
    .module_en  (regs_xx_icg_en)
);

// 向量寄存器时钟
assign vec_clk_en = vstart_local_en
                 || rtu_cp0_vstart_vld
                 || rtu_cp0_vsetvl_vl_vld
                 || rtu_cp0_vsetvl_vtype_vld;

// 刷新时钟
assign regs_flush_clk_en = rtu_yy_xx_flush || iui_regs_sel
                        || rtu_cp0_expt_gateclk_vld
                        || !regs_iui_cins_no_op
                        || cfr_bits_done
                        || iui_regs_inst_mret
                        || iui_regs_inst_sret;
```

## 6. 异常处理流程

### 6.1 异常发生时

```
1. 保存当前PC到mepc/sepc
2. 设置mcause/scause记录异常原因
3. 设置mtval/stval记录附加信息
4. 保存当前特权模式到mpp/spp
5. 保存当前中断使能到mpie/spie
6. 清除MIE/SIE
7. 根据委托设置切换到M-Mode或S-Mode
8. 跳转到mtvec/stvec指定的地址
```

### 6.2 异常返回时

```
MRET:
1. 从mpp恢复特权模式
2. 从mpie恢复MIE
3. 跳转到mepc

SRET:
1. 从spp恢复特权模式
2. 从spie恢复SIE
3. 跳转到sepc
```

## 7. 中断委托机制

### 7.1 异常委托 (medeleg)

```verilog
// medeleg位定义
// [15] Store/AMO page fault
// [13] Load page fault
// [12] Instruction page fault
// [11] Environment call from M-mode
// [9] Environment call from S-mode
// [8] Environment call from U-mode
// [7] Store/AMO access fault
// [6] Store/AMO address misaligned
// [5] Load access fault
// [4] Load address misaligned
// [3] Breakpoint
// [2] Illegal instruction
// [1] Instruction access fault
// [0] Instruction address misaligned
```

### 7.2 中断委托 (mideleg)

```verilog
// mideleg位定义
// [9] SEI - 监督外部中断
// [5] STI - 监督定时器中断
// [1] SSI - 监督软件中断
```

## 8. 设计要点

### 8.1 CSR访问权限检查
- 根据CSR地址高2位判断所需特权级
- 当前特权级低于CSR特权级时产生非法指令异常

### 8.2 状态脏位管理
- FS/VS状态自动更新
- 浮点/向量操作后设置为Dirty
- 上下文切换时用于惰性保存

### 8.3 中断优先级
- MEI > MSI > MTI > SEI > STI > SSI
- 委托中断按优先级处理

## 9. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
