# OpenC910 总体方案文档

## 1. 概述
OpenC910 是一个基于 RISC-V 架构的高性能开源处理器（基于玄铁 C910）。本方案主要根据其 RTL 代码结构（`C910_RTL_FACTORY/gen_rtl`）进行了自顶向下的模块划分与解析。

## 2. 核心架构与一级模块划分
OpenC910 的硬件架构被划分为以下主要的一级模块（Level-1 Modules）：

### 2.1 前端模块 (Front-End)
- **IFU (Instruction Fetch Unit)**：指令取指单元。负责从内存/缓存中获取指令，并进行分支预测。
- **IDU (Instruction Decode Unit)**：指令译码单元。负责将获取的指令译码为内部微操作，并处理寄存器重命名和指令分发。

### 2.2 执行模块 (Execution Units)
- **IU (Integer Unit)**：整数执行单元。处理算术、逻辑运算以及分支指令的执行。
- **LSU (Load/Store Unit)**：访存执行单元。处理数据加载与存储指令，管理缓存的数据一致性与内存屏障。
- **VFPU (Vector/Float Processing Unit)** 等：包含向量/浮点处理单元，细分为：
  - **VFALU**：向量/浮点算术逻辑单元。
  - **VFDSU**：向量/浮点除法与开方单元。
  - **VFMAU**：向量/浮点乘加单元。

### 2.3 访存与内存管理 (Memory Subsystem)
- **MMU (Memory Management Unit)**：内存管理单元。负责虚拟地址到物理地址的映射及权限检查。
- **PMP (Physical Memory Protection)**：物理内存保护模块。
- **L2C (L2 Cache)**：二级缓存。
- **BIU (Bus Interface Unit)**：总线接口单元，负责处理器与外部系统总线的通信。

### 2.4 控制与系统模块 (Control & System)
- **RTU (Retire Unit)**：退休单元/提交单元。负责指令的按序提交（In-order commit）以及精确异常的维护。
- **CP0 (Coprocessor 0)**：系统控制协处理器，包含 CSR（控制状态寄存器）等。
- **CLINT (Core Local Interruptor)** / **PLIC (Platform-Level Interrupt Controller)**：中断控制器，负责处理本地与平台级中断。
- **PMU (Performance Monitoring Unit)**：性能监控单元。
- **HAD (Hardware Debug)**：硬件调试支持模块。
- **CLK / RST**：时钟与复位控制模块。
- **CIU**：一致性互连单元（Coherent Interconnect Unit），用于多核间的一致性维护。
