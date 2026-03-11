# OpenC910 VFPU (Vector/Float Processing Unit) 深度设计与源码级解析

## 1. 引言与架构参数 (Architecture Parameters)
通过深度研读 `gen_rtl/vfpu` 及衍生目录的源码，我们得知 OpenC910 的 VFPU (Vector/Float Processing Unit) 并非单纯的浮点协处理器，而是一个与 IDU 紧密耦合、具备深度超标量乱序能力的双管道 (Pipe6 & Pipe7) 计算集群。
- **指令分发通道**：专属占据 CPU 后端的 Pipe 6 和 Pipe 7。
- **数据位宽**：广泛支持 64-bit 标量浮点 (Double) 及半精度 (Half) 以及更宽的 SIMD 向量。
- **操作数网络**：支持最多三源操作数 (Source 0, 1, 2) 的并行读取，专为 FMA (Fused Multiply-Add) 和向量微架构设计。

---

## 2. 核心源码级微架构切分 (Micro-Architecture Deep Dive)

按照源码逻辑域划分，VFPU 被解耦为三大核心算术引擎集群：VFALU、VFMAU 和 VFDSU。

### 2.1 向量/浮点算数逻辑单元：VFALU (`gen_rtl/vfalu/rtl`)
处理除乘除法外的所有常规计算，通过细化管线进一步拆解：
- **浮点加法器 (FADD)**：`ct_fadd_double_dp.v` / `half_dp`。使用了高性能的**双路径并行计算架构 (Dual-Path Architecture)**：
  - **近路径 (Close Path - `ct_fadd_close_*`)**：专为有效减法 (Effective Subtraction) 且阶差极小 (0或1) 的操作设计。包含了 LZA (Leading Zero Anticipator，前导零预测器) 以在 1 周期内掩盖尾数相减后的巨大前导零移位延迟。
  - **远路径 (Far Path)**：处理阶差大的对阶移位加法。
- **格式转化单元 (FCNVT)**：`ct_fcnvt_*.v`，提供整数到浮点 (itof), 浮点到整数 (ftoi), 以及不同精度浮点互转 (stod, dtos 等) 的快速数据通路。
- **特殊处理单元 (FSPU)**：`ct_fspu_*.v`，处理比较 (FCMP)、浮点分类 (FCLASS) 及符号注入 (FSGNJ)。

### 2.2 向量/浮点乘加单元：VFMAU (`gen_rtl/vfmau/rtl`)
处理融合乘加 (FMA) 这一 HPC 最关键的计算。
- **数据通路管线 (`ct_vfmau_dp.v`)**：流水线极深，时钟频率潜力极高。
- **乘法器核心压缩网络 (`ct_vfmau_mult1.v` & `ct_vfmau_mult_compressor`)**：
  - 采用 **Booth 编码** 削减部分积数量（大约减半）。
  - 使用 **Wallace Tree (华莱士树压缩器阵列, 4-2 / 3-2 压缩器)** 将十几个部分积通过纵向加法高速压缩阵列，降维到 C 和 S 两个最终进位保留向量。
- **LZA 加速 (`ct_vfmau_lza.v`)**：同样为乘加尾部的加法器布置了 32位/42位的领先零预测，消除长位宽进位传播等待。

### 2.3 向量/浮点除法与开方单元：VFDSU (`gen_rtl/vfdsu/rtl`)
执行浮点除法 (FDIV) 与平方根 (FSQRT)，此模块不可完全流水化。
- **迭代算法核心 (`ct_vfdsu_srt_radix16_*`)**：
  - 基于 **基数 16 的 SRT (Sweeney, Robertson, Tocher) 迭代算法**。这意味着每个时钟周期可以计算出 4 bit 的商或平方根。
  - **查表预估 (`ct_vfdsu_srt_radix16_bound_table.v`)**：在迭代启动时或过程中，通过硬件查表逻辑预测商数边界，结合移位加法实现高速收敛。
- **握手与阻塞控制 (`ct_vfdsu_ctrl.v`)**：当除法启动期间，模块向顶层输出 `vfpu_idu_vdiv_busy` 和 `vfpu_idu_vdiv_wb_stall`，使得 IDU 暂停向除法部件派发新的冲突指令。

---

## 3. 管线交互与旁路前递网络 (Forwarding & Interfaces)
- **输入多路前递**：由于浮点/向量部件往往需要 3 个 Register 读口，在乱序执行下数据的源头多变。`ct_vfpu_top.v` 揭示了其包含了海量的 `_dup0`, `_dup1` 等前递通路（如 `vfpu_idu_ex1_pipe7_fmla_data_vld_dup0`）。VFPU 需要自行解决来自流水线各级级之间的操作数 Bypass 捕获。
- **多状态写回 (`vfpu_idu_ex5_pipe6_wb_*`)**：浮点结果并非在一个固定时钟全部返回，而是依据执行单元的快慢在不同的阶段（例如 EX3, EX4, EX5）请求写回物理寄存器并唤醒等待列队。
