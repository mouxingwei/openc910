# OpenC910 二级模块方案文档

本方案进一步将 OpenC910 的关键一级模块（主要是核心流水线）分解为二级子模块（Level-2 Modules），这些子模块基本对应 RTL 目录下的各个具体的 `.v` 顶层设计。

## 1. IFU（取指单元）二级模块
IFU 主要负责指令提取与分支预测，核心二级子模块包括：
- **PCGEN (`ct_ifu_pcgen`)**：PC 生成模块，负责选择下一条取指的 PC 地址。
- **ICACHE 相关 (`ct_ifu_icache_*`)**：包含指令 Cache 的标签(Tag)与数据(Data)阵列接口。
- **IFCTRL / IPCTRL / IBCTRL**：各级取指控制逻辑。涉及 IF 阶段（取指）、IP 阶段（预译码）和 IB 阶段（指令缓冲）的控制。
- **IFDP / IPDP / IBDP**：对应各阶段的数据通路。
- **BHT (`ct_ifu_bht`)**：分支历史表，用于方向预测。
- **BTB (`ct_ifu_btb`, `ct_ifu_l0_btb`, `ct_ifu_ind_btb`)**：分支目标缓冲及间接分支目标预测。
- **RAS (`ct_ifu_ras`)**：返回地址栈。
- **IBUF (`ct_ifu_ibuf`)**：指令缓冲模块，隔离取指与译码流水线，平滑指令流。

## 2. IDU（译码与分发单元）二级模块
IDU 负责指令识别与发射准备，核心二级子模块包括：
- **ID (`ct_idu_id_*`)**：指令译码阶段，包含正常译码、长指令切分（`id_split_long` / `id_split_short`）、依赖分析等。
- **IR (`ct_idu_ir_*`)**：寄存器重命名阶段，管理逻辑寄存器到物理寄存器的映射树（包含 `ir_rt`, `ir_frt`, `ir_vrt`）。
- **IS (`ct_idu_is_*`)**：指令发射阶段（Issue Station），包含多个发射队列：
  - `aiq0` / `aiq1`：ALU 发射队列。
  - `biq`：分支指令发射队列。
  - `lsiq` / `sdiq`：加载/存储指令及数据发射队列。
  - `viq0` / `viq1`：向量/浮点发射队列。
- **RF (`ct_idu_rf_*`)**：物理寄存器堆读写及前递（Bypass/Forwarding）逻辑，包含整数（PRF_PREG）与浮点/向量（PRF_VREG）寄存器堆。

## 3. IU（整数执行单元）二级模块
IU 处理整数与分支指令，包含：
- **ALU (`ct_iu_alu`)**：算术逻辑运算单元。
- **BJU (`ct_iu_bju`)**：分支跳转执行单元，并包含 PC FIFO（`ct_iu_bju_pcfifo`）记录分支预测信息以供恢复。
- **MULT (`ct_iu_mult`)**：整数乘法单元。
- **DIV (`ct_iu_div`)**：整数除法单元（Radix-16 SRT 除法器）。
- **SPECIAL (`ct_iu_special`)**：处理特殊系统指令或控制状态寄存器操作。

## 4. LSU（访存单元）二级模块
LSU 执行 load/store 操作并维护内存一致性：
- **LD Pipe (`ct_lsu_ld_*`)**：Load 指令流水线，含地址生成(ag)、数据缓存提取(dc)、数据对齐(da)及写回(wb)。
- **ST Pipe (`ct_lsu_st_*`)**：Store 指令流水线，类似 load 流水线阶段。
- **LQ / SQ (`ct_lsu_lq`, `ct_lsu_sq`)**：Load/Store 队列，用于乱序访存管理。
- **LFB (`ct_lsu_lfb`)**：Line Fill Buffer，缓存缺失时的行填充缓冲。
- **WMB (`ct_lsu_wmb`)**：Write Merge Buffer，写合并缓冲，用于提高写内存效率。
- **PFU (`ct_lsu_pfu`)**：数据预取单元（Prefetch Unit）。
- **DCACHE 相关**：数据缓存的数据/标签阵列仲裁与接口。
- **SNOOP (`ct_lsu_snoop_*`)**：用于缓存一致性维护的监听逻辑。

## 5. MMU（内存管理单元）二级模块
MMU 负责虚实地址转换：
- **JTBL (`ct_mmu_jtlb`)**：联合 TLB (Joint TLB)，大容量的主 TLB。
- **IUTLB (`ct_mmu_iutlb`)**：指令微 TLB（Instruction Micro TLB）。
- **DUTLB (`ct_mmu_dutlb`)**：数据微 TLB（Data Micro TLB）。
- **PTW (`ct_mmu_ptw`)**：页表漫游器 (Page Table Walker)，负责硬件遍历页表处理 TLB Miss。
- **SYS MAP (`ct_mmu_sysmap`)**：系统地址映射属性检查。
- **TLB OPER (`ct_mmu_tlboper`)**：响应并处理 TLB 维护指令（如 sfence.vma）。
