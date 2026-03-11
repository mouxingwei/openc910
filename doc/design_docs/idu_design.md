# OpenC910 IDU (Instruction Decode Unit) 详细设计说明书

## 1. 引言与概述 (Introduction & Overview)
### 1.1 文档目的
本文档旨在详细描述 OpenC910 (基于玄铁 C910) 处理器中指令译码单元 (IDU) 的架构设计与微操作实现。
### 1.2 模块功能定位
IDU 位于处理器前端 (IFU) 与执行后端之间，主要承担以下功能：
- 接收来自 IFU 的指令包。
- 指令译码 (Decode)：分辨指令类型，产生控制信号，拆解长指令以及识别异常。
- 寄存器重命名 (Register Renaming)：解决写后写 (WAW) 和读后写 (RAW) 等假相关，记录寄存器间的真数据依赖。
- 指令缓冲与发射 (Issue queues)：利用发射队列挂起未就绪指令，并在操作数就绪时乱序发射 (Out-of-Order Issue) 到对应的执行管道。
- 寄存器读与前递 (Register Read & Forwarding)：从物理寄存器堆读取源操作数，并处理来自各个执行流水线甚至 Load 数据返回的前递互联。

---

## 2. 核心二级子模块及数据流向 (Top-Level Architecture)

IDU 内部逻辑复杂，主要被切分为四个流水级（模块），呈现高度模块化的设计特征：

### 2.1 ID (Instruction Decode) 阶段
对应 `ct_idu_id_*` 系列文件。
- **输入**：IFU 传来的 4 条并行取指的指令。
- **功能**：基础微操作解码，特殊指令（如 CSR）标志位提取。
- **核心子模块**：
  - `ct_idu_id_decd`：主译码阵列。
  - `ct_idu_id_split_long` / `short`：负责长短指令的微指令级 (uop) 拆解。

### 2.2 IR (Instruction Rename) 阶段
对应 `ct_idu_ir_*` 系列文件。
- **输入**：ID 阶段输出的多条解码微指令流。
- **功能**：分配物理寄存器，消除假数据流依赖。
- **核心子模块**：
  - `ct_idu_ir_rt` (Rename Table for Integer)：整数寄存器重命名映射表。
  - `ct_idu_ir_frt` / `vrt`：浮点及向量寄存器映射表。
  - 维护 Free List，负责响应 RTU 的寄存器释放信号。

### 2.3 IS (Instruction Issue) 发射站阶段
对应 `ct_idu_is_*` 系列文件。
- **功能**：根据指令类型将重命名后的指令路由到不同的发射队列 (Issue Queues)。在队列中，指令等待源操作数就绪（旁路唤醒信号），一旦就绪便参与发射仲裁。
- **队列划分**：
  - `aiq0` / `aiq1` (ALU Issue Queue)：整数与简单算术指令。
  - `biq` (Branch Issue Queue)：分支跳转指令。
  - `lsiq` (Load/Store Issue Queue)：访存地址生成及相关指令。
  - `sdiq` (Store Data Issue Queue)：Store 数据专用的队列。
  - `viq0` / `viq1` (Vector/Float Issue Queue)：向量与浮点指令发射队列。

### 2.4 RF (Register File & Forwarding) 操作数读取阶段
对应 `ct_idu_rf_*` 系列文件。
- **功能**：发射出的指令访问物理寄存器对获取操作数。若源操作数尚未写回，则通过前递逻辑捕获总线上的旁路数据。
- **核心子模块**：
  - `prf` (Physical Register Files)：包含 `pregfile` (整数物理寄存器堆) 和 `vregfile` (向量/浮点物理寄存器堆)。
  - `fwd` (Forwarding)：错综复杂的旁路数据网络，收集所有流水线写回级的数据，并在读阶段进行比较和替换。
  - `pipe_decd` (Pipe Decode)：针对特定执行管道（如 Pipe0~Pipe7）进行再一步的具体控制信号细化。

---

## 3. 对外接口规格 (Module Interfaces & IO)
IDU 的顶层文件为 `ct_idu_top.v`。这里列举与关键周边模块交互的最主要接口组别：

### 3.1 IDU 与 IFU (取指) 通信
- **输入包**：`ifu_idu_ib_inst0` ~ `inst3` (指令码、PC 等)。
- **握手与流控**：`idu_ifu_id_stall` / `ifu_idu_ib_vld` 控制流水线节拍。
- **分支修正**：发生早期分之错误时，从 IDU 通知 IFU 重定向PC (`idu_ifu_rf_pipe*_bju_*`)。

### 3.2 IDU 与执行单元 (IU, LSU, VFPU)
- **指令分派下发**：
  - 发往 IU (Pipe 0, 1, 2)：包含最终源操作数、目的物理寄存器号、操作码 (`idu_iu_rf_pipe*_src0` 等)。
  - 发往 LSU (Pipe 3, 4, 5)：访存基地址与偏移 (`idu_lsu_rf_pipe*_offset` 等)。
- **执行极反馈前递** (Forwarding)：
  - 来自 IU 的各级流水旁路：`iu_idu_ex1_pipe0_fwd_preg_data`。
  - 来自 LSU 的数据返回旁路。

### 3.3 IDU 与 RTU (退休控制)
- **流控与释放**：传递已发射离开流水线指令的句柄给 RTU (`idu_rtu_pst_dis_inst0_preg` 等) 供其按序记录。
- **异常冲刷 (Flush)**：接收来自 RTU/CP0 的全局重置信号 (`rtu_idu_flush_fe`)，冲刷所有的发射队列和流水线寄存器。
- **资源回收**：RTU 退休后释放的物理寄存器指针交由 IDU_IR 更新对应的 Free List。

---

## 4. 时钟、复位与功耗控制 (Clock & Low Power)
- 采用了细粒度的门控时钟结构 (Clock Gating)。例如对于大深度的寄存器堆 (`ct_idu_rf_prf_gated_preg`), 使用选通信号 (`gateclk_sel`) 控制对应的触发器翻转，以降低动态功耗。
- 复位均为异步复位同步释放。

---

## 5. 关键微架构设计亮点分析
1. **多级发射架构**：通过引入长短指令切分器，将 CISC 风格的多周期访存运算（往往出现于浮点扩展中）在解码阶段微操化，维持后端执行管线的整齐划一。
2. **分布式发射队列 (Distributed Issue Queues)**：不同于统一的发射池 (Centralized Issue Window)，采用多队列极大降低了唤醒仲裁器 (Wake-up/Select Logic) 的布线与时序压力，这是提升主频到 2GHz 以上的关键设计。
3. **精细的数据前递网络**：在 `ct_idu_rf_fwd.v` 中，前递逻辑被专门独立。这是乱序 CPU 中时序最紧张的路径之一。通过引入 `ready_stage` 等预断信号，C910 的旁路网络可以在寄存器读取前一个周期就开始预计算选择信号，从而缩减了关键路径。
