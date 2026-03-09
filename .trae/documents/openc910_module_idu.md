# OpenC910 一级模块文档：指令分发单元 (IDU)

## 1. 模块概述

指令分发单元 (Instruction Dispatch Unit, IDU) 是 OpenC910 处理器的核心调度模块，负责指令译码、寄存器重命名、发射队列管理和指令发射。IDU 将取指单元提供的指令转换为可执行的微操作，并调度到各个执行单元。

### 1.1 主要功能

- 指令译码
- 寄存器重命名
- 发射队列管理
- 操作数就绪检查
- 指令发射调度
- 寄存器文件访问

## 2. 模块接口

### 2.1 与 IFU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| ifu_idu_ib_inst0_data | I | 32 | 指令0数据 |
| ifu_idu_ib_inst0_vld | I | 1 | 指令0有效 |
| ifu_idu_ib_inst1_data | I | 32 | 指令1数据 |
| ifu_idu_ib_inst1_vld | I | 1 | 指令1有效 |
| ifu_idu_ib_inst2_data | I | 32 | 指令2数据 |
| ifu_idu_ib_inst2_vld | I | 1 | 指令2有效 |
| idu_ifu_id_stall | O | 1 | IDU 反压信号 |

### 2.2 与 IU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| idu_iu_rf_pipe0_sel | O | 1 | Pipe0 发射选择 |
| idu_iu_rf_pipe0_src0 | O | 64 | Pipe0 源操作数0 |
| idu_iu_rf_pipe0_src1 | O | 64 | Pipe0 源操作数1 |
| idu_iu_rf_pipe0_dst_preg | O | 6 | Pipe0 目的物理寄存器 |
| idu_iu_rf_bju_sel | O | 1 | BJU 发射选择 |
| idu_iu_rf_div_sel | O | 1 | 除法器发射选择 |
| idu_iu_rf_mult_sel | O | 1 | 乘法器发射选择 |

### 2.3 与 LSU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| idu_lsu_rf_pipe3_sel | O | 1 | Pipe3 (Load) 发射选择 |
| idu_lsu_rf_pipe3_offset | O | 12 | Load 偏移量 |
| idu_lsu_rf_pipe3_src0 | O | 64 | Load 基地址 |
| idu_lsu_rf_pipe4_sel | O | 1 | Pipe4 (Store) 发射选择 |
| idu_lsu_rf_pipe4_offset | O | 12 | Store 偏移量 |

### 2.4 与 RTU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| idu_rtu_rob_create0_en | O | 1 | ROB 创建0使能 |
| idu_rtu_rob_create0_data | O | - | ROB 创建0数据 |
| idu_rtu_ir_preg0_alloc_vld | O | 1 | 物理寄存器分配有效 |

## 3. 内部架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                           ct_idu_top                                 │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      译码阶段 (ID)                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_id_ctrl│  │ ct_idu_id_dp │  │ct_idu_id_decd│      │   │
│  │  │   译码控制   │  │   译码数据   │  │   指令解码   │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_idu_id_    │  │ct_idu_id_    │                        │   │
│  │  │split_long    │  │split_short   │                        │   │
│  │  │ 长指令拆分   │  │ 短指令拆分   │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   寄存器重命名阶段 (IR)                       │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_ir_ctrl│  │ ct_idu_ir_dp │  │ct_idu_ir_decd│      │   │
│  │  │   重命名控制 │  │   重命名数据 │  │   重命名解码 │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_ir_rt  │  │ct_idu_ir_frt │  │ct_idu_ir_vrt │      │   │
│  │  │ 整数重命名表 │  │ 浮点重命名表 │  │ 向量重命名表 │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      发射队列 (IS)                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_is_aiq0│  │ct_idu_is_aiq1│  │ct_idu_is_biq │      │   │
│  │  │  ALU队列0   │  │  ALU队列1    │  │  分支队列    │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_is_lsiq│  │ct_idu_is_sdiq│  │ct_idu_is_viq │      │   │
│  │  │  访存队列   │  │  特殊队列    │  │  向量队列    │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_idu_is_ctrl│  │ ct_idu_is_dp │                        │   │
│  │  │   发射控制   │  │   发射数据   │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    寄存器文件 (RF)                           │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_rf_ctrl│  │ ct_idu_rf_dp │  │ct_idu_rf_fwd │      │   │
│  │  │   RF控制     │  │   RF数据     │  │   前递逻辑   │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_idu_rf_prf_│  │ct_idu_rf_prf_│  │ct_idu_rf_prf_│      │   │
│  │  │  pregfile    │  │  fregfile    │  │  vregfile    │      │   │
│  │  │ 整数寄存器   │  │ 浮点寄存器   │  │ 向量寄存器   │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 4. 二级模块列表

### 4.1 译码模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_id_ctrl | ct_idu_id_ctrl.v | 译码阶段控制逻辑 |
| ct_idu_id_dp | ct_idu_id_dp.v | 译码阶段数据通路 |
| ct_idu_id_decd | ct_idu_id_decd.v | 指令解码逻辑 |
| ct_idu_id_decd_special | ct_idu_id_decd_special.v | 特殊指令解码 |
| ct_idu_id_fence | ct_idu_id_fence.v | Fence指令处理 |
| ct_idu_id_split_long | ct_idu_id_split_long.v | 长指令拆分 |
| ct_idu_id_split_short | ct_idu_id_split_short.v | 短指令拆分 |

### 4.2 寄存器重命名模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_ir_ctrl | ct_idu_ir_ctrl.v | 重命名控制逻辑 |
| ct_idu_ir_dp | ct_idu_ir_dp.v | 重命名数据通路 |
| ct_idu_ir_decd | ct_idu_ir_decd.v | 重命名解码 |
| ct_idu_ir_rt | ct_idu_ir_rt.v | 整数寄存器重命名表 |
| ct_idu_ir_frt | ct_idu_ir_frt.v | 浮点寄存器重命名表 |
| ct_idu_ir_vrt | ct_idu_ir_vrt.v | 向量寄存器重命名表 |

### 4.3 发射队列模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_is_ctrl | ct_idu_is_ctrl.v | 发射控制逻辑 |
| ct_idu_is_dp | ct_idu_is_dp.v | 发射数据通路 |
| ct_idu_is_aiq0 | ct_idu_is_aiq0.v | ALU发射队列0 |
| ct_idu_is_aiq0_entry | ct_idu_is_aiq0_entry.v | ALU队列0表项 |
| ct_idu_is_aiq1 | ct_idu_is_aiq1.v | ALU发射队列1 |
| ct_idu_is_aiq1_entry | ct_idu_is_aiq1_entry.v | ALU队列1表项 |
| ct_idu_is_biq | ct_idu_is_biq.v | 分支发射队列 |
| ct_idu_is_biq_entry | ct_idu_is_biq_entry.v | 分支队列表项 |
| ct_idu_is_lsiq | ct_idu_is_lsiq.v | Load/Store发射队列 |
| ct_idu_is_lsiq_entry | ct_idu_is_lsiq_entry.v | LS队列表项 |
| ct_idu_is_sdiq | ct_idu_is_sdiq.v | 特殊指令发射队列 |
| ct_idu_is_sdiq_entry | ct_idu_is_sdiq_entry.v | SD队列表项 |
| ct_idu_is_viq0 | ct_idu_is_viq0.v | 向量发射队列0 |
| ct_idu_is_viq0_entry | ct_idu_is_viq0_entry.v | 向量队列0表项 |
| ct_idu_is_viq1 | ct_idu_is_viq1.v | 向量发射队列1 |
| ct_idu_is_viq1_entry | ct_idu_is_viq1_entry.v | 向量队列1表项 |
| ct_idu_is_pipe_entry | ct_idu_is_pipe_entry.v | 通用发射队列表项 |
| ct_idu_is_aiq_lch_rdy_* | ct_idu_is_aiq_lch_rdy_*.v | 发射就绪逻辑 |

### 4.4 寄存器文件模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_rf_ctrl | ct_idu_rf_ctrl.v | RF控制逻辑 |
| ct_idu_rf_dp | ct_idu_rf_dp.v | RF数据通路 |
| ct_idu_rf_fwd | ct_idu_rf_fwd.v | 前递逻辑 |
| ct_idu_rf_fwd_preg | ct_idu_rf_fwd_preg.v | 整数前递 |
| ct_idu_rf_fwd_vreg | ct_idu_rf_fwd_vreg.v | 向量前递 |
| ct_idu_rf_prf_pregfile | ct_idu_rf_prf_pregfile.v | 整数物理寄存器文件 |
| ct_idu_rf_prf_fregfile | ct_idu_rf_prf_fregfile.v | 浮点物理寄存器文件 |
| ct_idu_rf_prf_vregfile | ct_idu_rf_prf_vregfile.v | 向量物理寄存器文件 |
| ct_idu_rf_prf_eregfile | ct_idu_rf_prf_eregfile.v | 扩展寄存器文件 |
| ct_idu_rf_prf_gated_preg | ct_idu_rf_prf_gated_preg.v | 门控整数寄存器 |
| ct_idu_rf_prf_gated_vreg | ct_idu_rf_prf_gated_vreg.v | 门控向量寄存器 |
| ct_idu_rf_prf_gated_ereg | ct_idu_rf_prf_gated_ereg.v | 门控扩展寄存器 |

### 4.5 译码器模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_rf_pipe0_decd | ct_idu_rf_pipe0_decd.v | Pipe0译码 |
| ct_idu_rf_pipe1_decd | ct_idu_rf_pipe1_decd.v | Pipe1译码 |
| ct_idu_rf_pipe2_decd | ct_idu_rf_pipe2_decd.v | Pipe2译码 |
| ct_idu_rf_pipe3_decd | ct_idu_rf_pipe3_decd.v | Pipe3译码 |
| ct_idu_rf_pipe4_decd | ct_idu_rf_pipe4_decd.v | Pipe4译码 |
| ct_idu_rf_pipe6_decd | ct_idu_rf_pipe6_decd.v | Pipe6译码 |
| ct_idu_rf_pipe7_decd | ct_idu_rf_pipe7_decd.v | Pipe7译码 |

### 4.6 依赖检查模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_idu_dep_reg_entry | ct_idu_dep_reg_entry.v | 整数依赖表项 |
| ct_idu_dep_reg_src2_entry | ct_idu_dep_reg_src2_entry.v | 源操作数2依赖 |
| ct_idu_dep_vreg_entry | ct_idu_dep_vreg_entry.v | 向量依赖表项 |
| ct_idu_dep_vreg_srcv2_entry | ct_idu_dep_vreg_srcv2_entry.v | 向量源依赖 |

## 5. 流水线阶段

### 5.1 ID阶段 (Instruction Decode)

- 指令解码
- 指令类型识别
- 源/目的操作数提取
- 立即数符号扩展
- 指令拆分 (复杂指令)

### 5.2 IR阶段 (Instruction Rename)

- 寄存器重命名
- 物理寄存器分配
- 依赖关系建立
- ROB表项分配

### 5.3 IS阶段 (Instruction Schedule)

- 发射队列写入
- 操作数就绪检查
- 唤醒逻辑
- 发射仲裁

### 5.4 RF阶段 (Register File)

- 寄存器文件读取
- 前递数据选择
- 最终操作数准备

## 6. 发射队列配置

| 队列名称 | 深度 | 服务单元 | 功能 |
|---------|------|---------|------|
| AIQ0 | 16 | Pipe0 | ALU操作 |
| AIQ1 | 16 | Pipe1 | ALU/乘法操作 |
| BIQ | 8 | Pipe2 | 分支/跳转操作 |
| LSIQ | 16 | Pipe3/4 | Load/Store操作 |
| SDIQ | 8 | Special | 特殊操作 |
| VIQ0 | 8 | Pipe6 | 向量ALU操作 |
| VIQ1 | 8 | Pipe7 | 向量乘加操作 |

## 7. 寄存器重命名

### 7.1 物理寄存器数量

| 寄存器类型 | 数量 | 架构寄存器 |
|-----------|------|-----------|
| 整数 (PREG) | 96 | 32 (x0-x31) |
| 浮点 (FREG) | 96 | 32 (f0-f31) |
| 向量 (VREG) | 64 | 32 (v0-v31) |

### 7.2 重命名策略

- 空闲列表管理
- 顺序分配
- 提交时释放

## 8. 设计要点

1. **乱序发射**: 支持指令乱序发射到执行单元
2. **前递网络**: 支持多级前递，减少数据冒险
3. **依赖跟踪**: 精确跟踪操作数就绪状态
4. **向量支持**: 完整支持V扩展的重命名和发射

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
