# OpenC910 一级模块方案文档

## 1. 概述
在 OpenC910 处理器中，一级模块主要围绕处理器的流水线与系统架构进行划分。主要包括前端、解码与分发、执行单元、访存与内存管理以及系统与控制模块。

## 2. 前端模块 (Front-End)
### 2.1 IFU (Instruction Fetch Unit)
 IFU 是处理器的取指单元，主要负责提供高带宽的指令流。它包含 L1 指令缓存 (ICache)、分支预测器 (BHT, BTB, RAS等) 以及指令缓冲 (IBUF)。IFU 与 L2C/BIU 进行交互，处理指令缓存缺失 (Cache Miss)。

## 3. 解码与分发模块 (Decode & Dispatch)
### 3.1 IDU (Instruction Decode Unit)
 IDU 接收 IFU 传来的指令，进行译码 (Decode)、寄存器重命名 (Register Renaming) 以及分发 (Dispatch/Issue)。IDU 内部维护了发射队列 (Issue Queues)、物理寄存器堆 (PRF - Physical Register File) 以及依赖关系检查逻辑。

## 4. 执行单元 (Execution Units)
执行单元被划分为多个并行执行的子模块，以支持超标量乱序执行：
### 4.1 IU (Integer Unit)
 整数执行单元，负责执行基本的算术逻辑指令 (ALU)、乘除法指令 (MULT/DIV) 以及分支跳转指令 (BJU)。
### 4.2 VFPU (Vector/Float Processing Unit)
 向量与浮点处理复合体，包含：
 - **VFALU**：向量及浮点算术逻辑单元。
 - **VFDSU**：除法与开方单元。
 - **VFMAU**：乘加单元。

## 5. 访存与内存管理 (Memory System)
### 5.1 LSU (Load/Store Unit)
 访存单元负责执行所有的 Load 和 Store 指令。LSU 处理地址计算、L1 数据缓存 (DCache) 访问、数据对齐、内存屏障 (Fence/Sync) 等操作。
### 5.2 MMU (Memory Management Unit)
 内存管理单元负责虚拟地址到物理地址的翻译，包含 TLB (Translation Lookaside Buffer) 以及页表漫游 (Page Table Walker) 逻辑。
### 5.3 L2C (L2 Cache)
 二级缓存模块，提供更大容量的缓存以降低访存延迟，通常由多核共享并维护多核间的一致性。

## 6. 退休与控制模块 (Retire & Control)
### 6.1 RTU (Retire Unit)
 退休单元也就是重排序缓冲 (ROB) 所在的模块。它跟踪所有在途 (in-flight) 的指令，并确保它们按照程序顺序 (In-order) 进行退休 (Commit)，或者在发生异常/分支预测失败时进行流水线冲刷。
### 6.2 CP0/CLINT/PLIC (System Control & Interrupts)
 协处理器与中断控制模块，处理特权级切换、CSR 读写以及外部和本地中断响应。
