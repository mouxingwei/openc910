# ct_cp0_iui 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_cp0_iui` - CP0指令接口模块

### 1.2 功能描述
`ct_cp0_iui` 是CP0的指令接口模块，负责处理来自IU（Integer Unit）的CSR指令。该模块进行CSR指令译码、权限检查、读写控制以及异常检测，是CPU执行CSR操作的主要接口。

### 1.3 主要特性
- CSR指令译码（CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI）
- 特权级权限检查
- CSR读写控制
- 非法CSR访问检测
- MRET/SRET指令处理
- 原子CSR操作支持

## 2. CSR指令格式

### 2.1 CSR指令编码

```
CSRRW:  funct3=001  | csrrw  rd, csr, rs1
CSRRS:  funct3=010  | csrrs  rd, csr, rs1
CSRRC:  funct3=011  | csrrc  rd, csr, rs1
CSRRWI: funct3=101  | csrrwi rd, csr, uimm[4:0]
CSRRSI: funct3=110  | csrrsi rd, csr, uimm[4:0]
CSRRCI: funct3=111  | csrrci rd, csr, uimm[4:0]

指令格式:
|31-20    |19-15  |14-12   |11-7   |6-0        |
| csr     | rs1   | funct3 | rd    | opcode    |
| 12 bits | 5 bits| 3 bits | 5 bits| 7 bits    |
```

### 2.2 指令操作

| 指令 | 操作 | 描述 |
|------|------|------|
| CSRRW | rd = CSR; CSR = rs1 | 读后写 |
| CSRRS | rd = CSR; CSR = CSR \| rs1 | 读后置位 |
| CSRRC | rd = CSR; CSR = CSR & ~rs1 | 读后清零 |
| CSRRWI | rd = CSR; CSR = uimm | 读后写立即数 |
| CSRRSI | rd = CSR; CSR = CSR \| uimm | 读后置位立即数 |
| CSRRCI | rd = CSR; CSR = CSR & ~uimm | 读后清零立即数 |

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                            ct_cp0_iui                                          │
                    │                                                                                  │
    iu_cp0_ex2_inst │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    [31:0]          │  │                        指令译码                                          │    │
    ──────────────────►│                                                                          │    │
    iu_cp0_ex2_src0 │  │  • 解析opcode, funct3                                                    │    │
    [63:0]          │  │  • 提取CSR地址                                                           │    │
    ──────────────────►│  • 提取rs1/rd索引                                                        │    │
    iu_cp0_ex2_ipupb│  │  • 识别MRET/SRET                                                         │    │
    ──────────────────►│                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        权限检查                                          │    │
                    │  │                                                                          │    │
                    │  │  • CSR特权级检查                                                         │    │
                    │  │  • 当前特权模式检查                                                      │    │
                    │  │  • 读写权限检查                                                          │    │
                    │  │  • 非法CSR检测                                                           │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        读写控制                                          │    │
                    │  │                                                                          │    │
                    │  │  • CSR选择信号生成                                                       │    │
                    │  │  • 写数据准备                                                            │    │
                    │  │  • 写使能生成                                                            │    │
                    │  │  • 读数据选择                                                            │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  ┌─────────────────────────────────────────────────────────────────────────┐    │
                    │  │                        异常处理                                          │    │
                    │  │                                                                          │    │
                    │  │  • 非法指令异常                                                          │    │
                    │  │  • 权限违规异常                                                          │    │
                    │  │  • 异常信号输出                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                    │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ iui_regs_sel | iui_regs_addr[11:0] | iui_regs_src0[63:0]               │  │
                    │  │ iui_regs_csr_wr | iui_regs_csrw | regs_iui_data_out[63:0]              │  │
                    │  │ cp0_iu_ex2_data[63:0] | cp0_iu_ex2_ipuseq                               │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 4. 接口定义

### 4.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `forever_cpuclk` | 1 | 永久CPU时钟 |
| `cp0_yy_clk_en` | 1 | CP0时钟使能 |
| `pad_yy_icg_scan_en` | 1 | 扫描使能信号 |
| `iu_cp0_ex2_ipupb` | 1 | EX2阶段IPU流水线更新 |
| `iu_cp0_ex2_inst[31:0]` | 32 | EX2阶段指令 |
| `iu_cp0_ex2_src0[63:0]` | 64 | EX2阶段源操作数 |
| `regs_iui_data_out[63:0]` | 64 | 寄存器输出数据 |
| `regs_iui_chk_vld` | 1 | 检查有效信号 |
| `regs_iui_tee_vld` | 1 | TEE有效信号 |
| `regs_iui_tsr` | 1 | TSR状态 |
| `regs_iui_tvm` | 1 | TVM状态 |
| `regs_iui_tw` | 1 | TW状态 |
| `cp0_yy_priv_mode[1:0]` | 2 | 当前特权模式 |
| `rtu_yy_xx_flush` | 1 | 流水线刷新信号 |

### 4.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `iui_regs_sel` | 1 | 寄存器选择信号 |
| `iui_regs_addr[11:0]` | 12 | CSR地址 |
| `iui_regs_src0[63:0]` | 64 | 写数据 |
| `iui_regs_csr_wr` | 1 | CSR写使能 |
| `iui_regs_csrw` | 1 | CSR写标志 |
| `iui_regs_opcode[31:0]` | 32 | 操作码 |
| `iui_regs_ori_src0[63:0]` | 64 | 原始源操作数 |
| `iui_regs_inst_mret` | 1 | MRET指令标志 |
| `iui_regs_inst_sret` | 1 | SRET指令标志 |
| `iui_regs_ex3_inst_csr` | 1 | EX3阶段CSR指令 |
| `iui_regs_inv_expt` | 1 | 无效异常 |
| `iui_regs_rst_inv_i` | 1 | 复位无效I |
| `iui_regs_rst_inv_d` | 1 | 复位无效D |
| `cp0_iu_ex2_data[63:0]` | 64 | EX2阶段输出数据 |
| `cp0_iu_ex2_ipuseq` | 1 | IPU顺序信号 |
| `cp0_mret` | 1 | MRET信号 |
| `cp0_sret` | 1 | SRET信号 |

## 5. 关键逻辑设计

### 5.1 指令译码

```verilog
// CSR指令识别
assign csr_inst = (opcode == 7'b1110011) && 
                  (funct3 inside {3'b001, 3'b010, 3'b011, 3'b101, 3'b110, 3'b111});

// CSR地址提取
assign csr_addr[11:0] = inst[31:20];

// 指令类型识别
assign csrrw  = csr_inst && (funct3 == 3'b001);
assign csrrs  = csr_inst && (funct3 == 3'b010);
assign csrrc  = csr_inst && (funct3 == 3'b011);
assign csrrwi = csr_inst && (funct3 == 3'b101);
assign csrrsi = csr_inst && (funct3 == 3'b110);
assign csrrci = csr_inst && (funct3 == 3'b111);

// MRET/SRET识别
assign mret_inst = (inst == 32'h30200073);  // MRET
assign sret_inst = (inst == 32'h10200073);  // SRET
```

### 5.2 权限检查

```verilog
// CSR特权级判断
// CSR地址[9:8]表示特权级
// 00: User, 01: Supervisor, 10: Hypervisor, 11: Machine
assign csr_priv_level = csr_addr[9:8];

// 权限检查
assign priv_check_pass = (cp0_yy_priv_mode >= csr_priv_level);

// 非法CSR检测
assign illegal_csr = !priv_check_pass || 
                     !csr_exist(csr_addr);
```

### 5.3 读写控制

```verilog
// 写使能生成
assign csr_wr_en = csrrw || csrrwi || 
                   ((csrrs || csrrsi) && (rs1 != 0)) ||
                   ((csrrc || csrrci) && (rs1 != 0));

// 写数据准备
always @(*) begin
    case (funct3)
        3'b001: write_data = src0;           // CSRRW
        3'b010: write_data = csr_data | src0; // CSRRS
        3'b011: write_data = csr_data & ~src0; // CSRRC
        3'b101: write_data = uimm;           // CSRRWI
        3'b110: write_data = csr_data | uimm; // CSRRSI
        3'b111: write_data = csr_data & ~uimm; // CSRRCI
    endcase
end
```

### 5.4 异常生成

```verilog
// 非法指令异常
assign illegal_inst_expt = csr_inst && illegal_csr;

// 权限违规异常
assign priv_violation = csr_inst && !priv_check_pass;

// 异常输出
assign iui_regs_inv_expt = illegal_inst_expt || priv_violation;
```

## 6. CSR特权级编码

| CSR地址[9:8] | 特权级 | 描述 |
|--------------|--------|------|
| 00 | User | 用户级CSR |
| 01 | Supervisor | 监督级CSR |
| 10 | Hypervisor | 超级监督者CSR |
| 11 | Machine | 机器级CSR |

## 7. MRET/SRET处理

### 7.1 MRET处理

```verilog
// MRET指令检测
assign mret_inst = (inst == 32'h30200073);

// TSR检查（Trap SRET）
// 当TSR=1且在S-Mode执行SRET时产生非法指令异常
assign mret_illegal = mret_inst && (cp0_yy_priv_mode != 2'b11);

// MRET输出
assign cp0_mret = mret_inst && !mret_illegal;
```

### 7.2 SRET处理

```verilog
// SRET指令检测
assign sret_inst = (inst == 32'h10200073);

// TSR检查
assign sret_illegal = sret_inst && regs_iui_tsr && (cp0_yy_priv_mode == 2'b01);

// SRET输出
assign cp0_sret = sret_inst && !sret_illegal;
```

## 8. 时序图

### 8.1 CSR读操作时序

```
时钟:        T1              T2              T3
            ┌───────────────┬───────────────┬───────────────┐
iu_cp0_ex2_inst ────────────────────────────────────────────
            ┌───────────────┐
iu_cp0_ex2_src0                └───────────────────────────
            
            │   译码/检查    │   读CSR       │   输出       │
            
iui_regs_sel                 ────────────────
iui_regs_addr                ────────────────
regs_iui_data_out                            ────────────────
cp0_iu_ex2_data                                              ────
```

### 8.2 CSR写操作时序

```
时钟:        T1              T2              T3
            ┌───────────────┬───────────────┬───────────────┐
iu_cp0_ex2_inst ────────────────────────────────────────────
iu_cp0_ex2_src0 ────────────────────────────────────────────
            
            │   译码/检查    │   写CSR       │   完成       │
            
iui_regs_sel                 ────────────────
iui_regs_csr_wr              ────────────────
iui_regs_src0                ────────────────
```

## 9. 设计要点

### 9.1 原子性
- CSR读写操作是原子的
- 读和写在同一周期完成

### 9.2 权限检查
- 所有CSR访问都需要权限检查
- 权限不足产生非法指令异常

### 9.3 特殊指令处理
- MRET/SRET需要额外的状态检查
- WFI指令受TW位控制

## 10. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
