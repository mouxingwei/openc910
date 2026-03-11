# OpenC910 IFU (Instruction Fetch Unit) 深度设计与源码级解析

## 1. 引言与微架构概览 (Micro-Architecture Overview)
IFU 是 OpenC910 最前端的枢纽。不同于简单的取指部件，由于 C910 支持混编不定长的 RISC-V C 扩展 (16-bit) 并在高主频下维持宽发射，其 IFU 的核心挑战在于**跨 Cache-line 拼接、复杂的不定长指令预解码**以及**极具深度的分支预测系统**。

---

## 2. 核心源码级子模块解析 (Sub-Modules Deep Dive)

### 2.1 层次化分支预测网络 (Hierarchical Predictor)
在 `gen_rtl/ifu/rtl` 下可以清晰看到四个并行又相互依赖的分支部件：
- **微型目标缓冲 (L0 BTB - `ct_ifu_l0_btb.v`)**：
  极小容量（如 16~32 项）但速度极快，用于提供零周期 (Zero-Cycle) 的预测，是主频突破 2GHz 时的关键。
- **主目标缓冲 (Main BTB - `ct_ifu_btb*.v`)**：
  包含 `tag_array` 和 `data_array`，拥有大容量。当 L0 发生 Miss 时，BTB 提供 1 周期延迟的目标地址预测，并负责回填 L0。
- **分支历史表 (BHT - `ct_ifu_bht*.v`)**：
  采用如 Gshare 等两级饱和计数器来猜测条件分支是否被采纳 (Taken / Not-Taken)。其内部划分了 `pre_array` 阵列供快速查表。
- **返回地址栈 (RAS - `ct_ifu_ras.v`)**：
  针对 `jalr` 的子程序返回。当解码识别为 Call 时压栈，识别为 Return 时弹栈。
- **间接分支预测器 (Ind-BTB - `ct_ifu_ind_btb.v`)**：
  针对非 Return 类的寄存器跳转。通过目标地址的历史记录缓冲阵列来进行猜测。

### 2.2 多级取指拼接与缓冲系统 (Fetch & Buffer Pipeline)
- **IF 级，地址生成与取指 (`ct_ifu_pcgen.v` / `ct_ifu_icache_if.v`)**：
  负责发起 I-Cache 查表。包含 Tag 和 Data 的独立访问通路 (`icache_data_array0` / `array1`) 的选通。
- **IP 级，指令预解码 (`ct_ifu_ipdecode.v` / `ct_ifu_precode.v`)**：
  从 SRAM 中拿到的块级数据在这里被切分。最复杂之处在于**跨行处理**：如果一条 32 位的指令前半跨在缓存行 A 末尾，后半在 B 开头，IPDECODE 会将其拼接缓冲。
- **IB 级，指令队列 (`ct_ifu_ibuf.v`)**：
  拥有 60+ 词条的大深度 FIFO，缓冲预解码后对齐的指令码、长度标志、异常标志，每个周期以 4-Issue 的带宽倾泻给解码单元 (IDU)。

### 2.3 I-Cache 控制与失配回填 (Cache & Refill)
- `ct_ifu_l1_refill.v` 和 `ct_ifu_lbuf.v` 充当 L1 Miss 时与 L2/总线的握手状态机，包含发送读请求并管理多 Beat 数据返回填充入 I-Cache 数据阵列的全过程。

---

## 3. 外围管线信令交互 (Pipeline Handshake signals)
通过 `ct_ifu_top.v` 可见，IFU 的外界接口极为茂盛：
- 与执行单元的分支反馈 (`iu_ifu_bht_pred`, `rtu_ifu_retire_inst*_condbr_taken`)：当后端发现真实的分支去向后，将利用这些信号更新 BHT 及 BTB 等的内部计数器和表项权重。
- 从 CP0 送达的寄存器读写控制信号（如 `cp0_ifu_bht_en`, `cp0_ifu_ras_en`），由操作系统或机器监视器控制前端预测器的使能状态，用于功耗控制及某些特权隔离操作。
