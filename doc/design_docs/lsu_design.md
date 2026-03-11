# OpenC910 LSU (Load/Store Unit) 深度设计与源码级解析

## 1. 引言与乱序访存模型概览 (Overview)
OpenC910 LSU 是决定 CPU 指令吞吐 IPC 的命脉模块。在这个源码深度的解析中，我们将聚焦于 C910 如何处理复杂的推测访存冲突、高并发下的对齐跨界处理、多核 Snoop 一致性等高级微架构技术。

---

## 2. 核心源码级子模块与高速队列解析 (Sub-Modules Deep Dive)

### 2.1 极深度的双发 Load/Store 管线 (`ct_lsu_ld_*` 与 `ct_lsu_st_*`)
LSU 管线物理上至少分离出独立的 Load Pipe 和 Store Pipe，具备 AG、DC、DA、WB 等四站：
- **AG (地址生成 - `ct_lsu_ld_ag`, `st_ag`)**：基址加偏移，并生成非对齐边界信号，请求 MMU 获取物理地址。
- **DC (Cache 访问 - `ct_lsu_ld_dc`, `st_dc`)**：操作 D-Cache tag 和 data。对于写操作，在此并不立即把数据刷入阵列（等待退休）。
- **DA (数据对齐 - `ct_lsu_ld_da`, `st_da`)**：C910 容忍非对齐访问。当数据横跨字边界或行边界时（`unalign_2nd` 状态），LSU 状态机会停顿或拆分交易合并返回。
- **WB (写回与前递 - `ct_lsu_ld_wb`)**：将结果送上 `lsu_idu_wb_pipe3_wb_preg` 总线以供 Bypass。

### 2.2 四大缓存重排序与维护队列 (Reorder & Buffer Queues)
这些队列是 LSU 中逻辑最错综复杂的部分，负责“抹平”乱序与等待：
- **Load 队列 (LQ - `ct_lsu_lq.v`)**：记录发出但未退休的 Loads。如果监测到晚来的但程序序较老的 Store 写入了同地址，即通过 `spec_fail_predict.v` 触发特有的投机失败冲刷与黑名单训练。
- **Store 队列 (SQ - `ct_lsu_sq.v`)**：挂起所有被执行但尚未被 RTU 提交的 Store 数据。
- **写回合并队列 (WMB - `ct_lsu_wmb.v`)**：这是 C910 极其核心的吞吐源泉。提交后的 Store 不是立即塞给 D-Cache，而是进入 WMB 进行归约（例如不同指针对同一 Cache-line 的不连续字节写入被折叠为一条总 Burst 事务）。
- **行填充缓冲 (LFB - `ct_lsu_lfb.v`)**：挂起 D-Cache Miss 后的事务等候。

### 2.3 硬件预取引擎 (Hardware Prefetcher : PFU)
对应 `gen_rtl/lsu/rtl/ct_lsu_pfu*.v`。
- 包含了全局跨步监听 (`pfu_gpfb`) 和短步态监测 (`pfu_gsdb`)。
- 当 L1 数据流出现规律（例如 +4, +8）的规律跳跃时，`ct_lsu_pfu_pfb` 会生成探测哨兵预先抓回总线数据。

### 2.4 一致性控制与防死锁网络 (Coherency Protocol Snoop)
对应 `ct_lsu_snoop_snq.v` / `ctcq.v`。
- 多核系统依靠 Snoop Req 维系，即 `biu_lsu_ac_req`。
- LSU 内含有一个针对总线窥探的队列 (SNQ, Snoop Queue)。当受到其它核共享缓存的窥探读报文时，LSU 需要暂时锁定针对该行的 WMB/LFB 操作，等待降级，保证不发生 MOESI 死锁。

---

## 3. 主干 IO 接口架构亮点
- **AMO 旁路架构**：原子内存指令（Atomic）通过 LSU 到 L2 的 `lsu_mmu_stamo_pa` / `biu_lsu_ar_*` 以不可打断事务进行传播。
- **激进的前递器 (Store-to-Load Forwarding)**：依赖 `ct_lsu_rot_data.v` 和 `ct_lsu_sq_entry.v` 内部的深层比对逻辑，只要物理地址与字节蒙版（Byte Mask）相切合，甚至是非对齐重叠的切合，都能实现零周期的 SQ 向 Load 流水线泄露。
