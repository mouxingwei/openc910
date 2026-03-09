# OpenC910 模块方案文档生成计划

## 项目概述

OpenC910 是平头哥(T-Head Semiconductor)开源的高性能 RISC-V 64位处理器核心，采用乱序执行、超标量架构设计。支持双核 SMP 配置，具有完整的内存管理、缓存系统和调试接口。

## 文档结构规划

### 1. 总体方案文档 (openc910_overall_architecture.md)
- 处理器整体架构概述
- 核心特性与技术规格
- 系统架构层次图
- 模块间接口关系
- 数据流与控制流概述

### 2. 一级模块文档 (共12个一级模块)

#### 2.1 CPU核心模块 (ct_core)
- 文件: `openc910_module_cpu_core.md`
- 内容: 核心内部架构、子模块集成、流水线概述

#### 2.2 指令取指单元 (IFU - Instruction Fetch Unit)
- 文件: `openc910_module_ifu.md`
- 内容: 取指流水线、分支预测、指令缓存

#### 2.3 指令分发单元 (IDU - Instruction Dispatch Unit)
- 文件: `openc910_module_idu.md`
- 内容: 指令解码、寄存器重命名、发射队列

#### 2.4 整数执行单元 (IU - Integer Unit)
- 文件: `openc910_module_iu.md`
- 内容: ALU、乘法器、除法器、分支单元

#### 2.5 浮点/向量执行单元 (VFPU - Vector Floating Point Unit)
- 文件: `openc910_module_vfpu.md`
- 内容: 浮点运算、向量运算、SIMD处理

#### 2.6 访存单元 (LSU - Load Store Unit)
- 文件: `openc910_module_lsu.md`
- 内容: 数据缓存、访存流水线、内存一致性

#### 2.7 内存管理单元 (MMU - Memory Management Unit)
- 文件: `openc910_module_mmu.md`
- 内容: TLB、页表遍历、地址翻译

#### 2.8 协处理器0 (CP0 - Coprocessor 0)
- 文件: `openc910_module_cp0.md`
- 内容: CSR寄存器、异常处理、中断控制

#### 2.9 提交单元 (RTU - Retire Unit)
- 文件: `openc910_module_rtu.md`
- 内容: 重排序缓冲区、指令提交、异常处理

#### 2.10 总线接口单元 (BIU - Bus Interface Unit)
- 文件: `openc910_module_biu.md`
- 内容: AXI总线接口、总线仲裁、协议转换

#### 2.11 调试与跟踪单元 (HAD - Hardware Assisted Debug)
- 文件: `openc910_module_had.md`
- 内容: JTAG调试、断点、跟踪功能

#### 2.12 二级缓存与互连 (L2C & CIU)
- 文件: `openc910_module_l2c_ciu.md`
- 内容: L2缓存、缓存一致性、多核互连

### 3. 二级模块文档 (每个一级模块下的子模块详细设计)

## 实施步骤

### 步骤1: 创建总体方案文档
- 分析顶层模块 openC910.v 和 ct_top.v
- 绘制系统架构图
- 描述模块间接口

### 步骤2: 创建一级模块文档
- 分析各一级模块的顶层文件
- 描述模块功能与接口
- 绘制模块内部结构图

### 步骤3: 创建二级模块文档
- 深入分析各子模块RTL代码
- 描述详细功能实现
- 分析关键信号与时序

## 文档模板结构

每个模块文档将包含以下章节:
1. 模块概述
2. 功能描述
3. 接口信号定义
4. 内部架构设计
5. 关键时序
6. 子模块列表(二级模块)
7. 设计要点

## 预计产出

| 文档类型 | 数量 | 文件命名 |
|---------|------|---------|
| 总体方案 | 1 | openc910_overall_architecture.md |
| 一级模块 | 12 | openc910_module_*.md |
| 二级模块 | 约50+ | openc910_submodule_*.md |

## 执行计划

1. **阶段一**: 生成总体方案文档
2. **阶段二**: 生成12个一级模块文档
3. **阶段三**: 生成各一级模块下的二级模块文档

## 已完成文档

### 总体方案文档
- ✅ openc910_overall_architecture.md

### 一级模块文档 (12个)
- ✅ openc910_module_ifu.md (指令取指单元)
- ✅ openc910_module_idu.md (指令分发单元)
- ✅ openc910_module_lsu.md (访存单元)
- ✅ openc910_module_iu.md (整数执行单元)
- ✅ openc910_module_rtu.md (提交单元)
- ✅ openc910_module_mmu.md (内存管理单元)
- ✅ openc910_module_cp0.md (协处理器0)
- ✅ openc910_module_had.md (硬件辅助调试)
- ✅ openc910_module_vfpu.md (向量浮点单元)
- ✅ openc910_module_biu.md (总线接口单元)
- ✅ openc910_module_l2c_ciu.md (二级缓存与互连)

### 二级模块文档 (6个)
- ✅ openc910_submodule_btb.md (分支目标缓冲区)
- ✅ openc910_submodule_bht.md (分支历史表)
- ✅ openc910_submodule_ras.md (返回地址栈)
- ✅ openc910_submodule_rob.md (重排序缓冲区)
- ✅ openc910_submodule_issue_queue.md (发射队列)
- ✅ openc910_submodule_tlb.md (TLB)

---

*计划创建时间: 2026-03-09*
*完成时间: 2026-03-09*
