# OpenC910 MMU (Memory Management Unit) 深度设计与源码级解析

## 1. 引言与架构参数 (Architecture Parameters)
MMU 是协调虚拟地址与物理地址翻译的核心组件。通过深度解析 `gen_rtl/mmu/rtl` 源码，OpenC910 的 MMU 严格遵循 RISC-V 规范，并具备以下硬件级固化参数 (见 `ct_mmu_ptw.v` 等)：
- **VADDR_WIDTH = 39**：支持 Sv39 虚拟内存系统（39 位虚拟地址）。
- **PADDR_WIDTH = 40**：支持最高 40 位的物理地址空间。
- **PTE_LEVEL = 3**：硬件自动页表漫游支持 3 级页表树 (Level-3 Page Table Walk)。
- **VPN / PPN 位宽**：VPN 27 位，PPN 28 位。
- **支持页帧大小 (PGS)**：通过硬件标志位，支持 4KB (Base Page), 2MB (Mega Page), 1GB (Giga Page) 巨型页的无缝映射。

---

## 2. 核心源码级子模块解析 (Sub-Modules Deep Dive)

### 2.1 硬件页表漫游状态机：PTW (`ct_mmu_ptw.v`)
在缓存全 Miss 的惩罚下，PTW 接管控制权向内存发起真实的页表项 (PTE) 读取。其内部由核心的一个多级复杂 FSM（有限状态机）驱动：
- **`PTW_IDLE`**：待机，随时侦听 JTLB 抛出的 `jtlb_ptw_req` 请求。
- **一级遍历 (`PTW_FST_PMP` -> `PTW_FST_DATA` -> `PTW_FST_CHK`)**：
  - 硬件计算 `satp_ppn` 结合最高级 VPN，进行 PMP (Physical Memory Protection) 权限检查。
  - 向 LSU 发起读请求 (`mmu_lsu_data_req`)。
  - 校验返回的 PTE 标志 (`ptw_flg`)。若探测到 `ptw_hit_1g` (即权限位表示这是一个 1GB 巨型页叶节点)，则直接跳转到结束前验证流程；若为分支表，则进入下一级。
- **二级与三级遍历 (`PTW_SCD_*`, `PTW_THD_*`)**：
  - 过程类似一级遍历，分别使用 VPN 的中间段和末尾段去索引 2MB 或 4KB 页的 PTE。
- **异常收尾状态 (`PTW_ACC_FLT`, `PTW_PGE_FLT`)**：
  - 当基址访问遇到总线级错误 (`lsu_mmu_bus_error`)，转入 `PTW_ACC_FLT` 触发 Access Fault。
  - 若权限校验失败 (如 R, W, X 缺失，U/S 模式越权，A/D 位违反)，转入 `PTW_PGE_FLT` 触发 Page Fault 异常。
- **完成与回填 (`PTW_DATA_VLD`)**：
  - 将计算所得的 28位 PPN 及标志位通过 `ptw_arb_data_din` 接口仲裁回写入 JTLB。

### 2.2 主转换快表：JTLB (`ct_mmu_jtlb.v`)
JTLB 是系统主要的共享地址翻译表，使用大容量的静态 RAM 阵列 (SPSRAM)。
- **存储介质与拓扑**：由 Tag Array (`ct_mmu_jtlb_tag_array`) 存储 VPN 标签，并由 Data Array (`ct_mmu_jtlb_data_array`) 存储 PPN 及标志位。
- **多路组相联 (Set-Associative)**：JTLB 的表项分布于多个 Bank (模块中含有 `arb_jtlb_bank_sel` 信号)，以降低单点碰撞率并简化走线扇出。
- **替换算法**：内部使用分离的伪 LRU (PLRU) 树（详见 `ct_mmu_dplru.v` 与 `ct_mmu_iplru.v`）为每一次 Cache 填充挑选牺牲块。

### 2.3 微型快表：I-uTLB 和 D-uTLB (`ct_mmu_iutlb.v` / `dutlb.v`)
- 微表挂载在流水线最敏感的零周期通路侧。例如对于 D-uTLB (`dutlb.v`)：
  - **双端口支持**：为适应 LSU 超标量全双工特性，D-uTLB 同时提供了 `lsu_mmu_va0` 和 `lsu_mmu_va1` 两个查询端点。
  - **快速前向传输**：一旦命中 (`mmu_lsu_pa0_vld` / `pa1_vld`)，其内部的数据几乎是纯组合逻辑输出给 LSU 做 Cache Tag 比对用的物理基址，无任何时钟边沿延误。

### 2.4 仲裁器极属性查询 (`ct_mmu_arb.v` & `sysmap.v`)
- 当发生微表缺失回求 JTLB 时，由 `ct_mmu_arb.v` 进行公平轮询仲裁。
- 翻译出的物理地址送入 `sysmap.v`（`sysmap_mmu_hit3` / `flg3`），确认这段内存的 PXP、Cacheable 配置项。

---

## 3. 对外核心控制握手信号解析 (Handshake Protocols)
- **CP0 状态交互**：PTW 及 uTLB 大量依赖 `cp0_priv_mode` 等特权级信号判断越权。其中巧妙使用了 `cp0_mmu_mprv` 和 `cp0_mmu_mpp`。当进入 `mret` 等中断返回态前，使用 MPP 中的过往特权级进行预先判定，而非当前机器模式。
- **电源管理与门控**：整个 MMU 模块极大地运用了 `gated_clk_cell` (例如实例 `x_ptw_gateclk`)，仅在 `jtlb_ptw_req` 或自身有挂起事务时才打开时钟 (`ptw_clk_en`)，静态状态下几乎零动态功耗泄漏。
