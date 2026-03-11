# OpenC910 CP0 及系统控制模块详细设计说明书

## 1. 引言与概述 (Overview)
### 1.1 模块功能定位
处理器除了执行普通数学与访存指令外，需要一整套管理其中断、特权级状态、硬件性能监控以及外部调试的设施。在 C910 中，这个角色由 CP0 (协处理器0)、CLINT / PLIC (中断控制器)、HAD (硬件调试)、PMU (性能监控) 以及时钟复位模块 (CLK/RST) 共同承担。

---

## 2. 核心二级子模块及数据流向 (Top-Level Architecture)

### 2.1 协处理器 0 (CP0)
对应 `gen_rtl/cp0/rtl`。
- **功能**：掌管整个 RISC-V 架构所定义的控制状态寄存器 (CSR)，例如 `mstatus`, `mepc`, `mcause`, `satp` 等等。
- **异常代理与状态切换**：当 RTU 报告精确实时异常时，CP0 冻结当前 PC 到 `mepc`，并根据特权级（M/S/U Mode）更新状态屏蔽字，提取异常向量首地址告知流水线强制重定向。
- **广播控制**：从各种 CSR 中解码出底层的硬件行为配置位（例如是否关闭分支预测，是否允许跨缓存行存取等），并将这些标志位广播给对应的 IFU, IDU, LSU 等管线模块。

### 2.2 本地与平台级中断控制器 (CLINT / PLIC)
对应 `gen_rtl/clint` 与 `gen_rtl/plic`。
- **CLINT (Core Local Interruptor)**：处理核心局部的软中断 (Software Interrupt) 和机器定时器中断 (Timer Interrupt)。它维护着 `mtime` 和 `mtimecmp`。
- **PLIC (Platform-Level Interrupt Controller)**：统一仲裁芯片级别的外设硬中断。为不同来源的中断规划优先级和阈值，并路由转发给具体的 CPU Core。

### 2.3 性能监控单元 (PMU)
对应 `gen_rtl/pmu/rtl`。
- **功能**：依据 RISC-V HPM (Hardware Performance Monitor) 标准，埋点收集包括 L1 Cache Miss 率、分支预测命中率、提交/冲刷指令数等各类架构和微架构事件计数。是底层软件进行性能剖析 (Profiling) 的关键数据源。

### 2.4 硬件调试助手 (HAD)
对应 `gen_rtl/had/rtl`。
- **功能**：实现 JTAG 接口对接外部调试器（如 T-Head 调试套件或 OpenOCD）。
- **机制**：通过外部注入指令或读取内部寄存器池的方法，协助开发者打断流水线，实现在线单步跟踪、设置硬件地址断点、观察物理内存和核心寄存器的内容。

### 2.5 时钟与复位生成树 (CLK & RST)
对应 `gen_rtl/clk` 与 `gen_rtl/rst`。
- 接收外部晶振与 PLL 时钟，经过门控电路分发给上述的所有的流水管线层。
- 管理多核环境下的软/硬复位定序（例如热复位、系统冷复位），以保证巨型状态机在复位后安全且有序地启动。

---

## 3. 对外接口规格 (Module Interfaces & IO)

### 3.1 CP0 与整机所有模块的互联
- 这是芯片内部扇出 (Fan-out) 最大的模块之一。其包含的几百个 CSR 位会牵动 IFU 的取指基址、LSU 的权限屏蔽、IDU 的特定扩展使能。

### 3.2 中断控制器与外部世界
- **中断线阵列**：PLIC 会向 SoC 端暴露出数百根外部中断请求信号 (`ext_int_req`)，并在仲裁后向 CP0 投递核心告警 (`mext_int`)。

---

## 4. 微架构亮点总结
- **平滑的特权级过渡**：C910 的 CP0 高度合规于 RISC-V Privileged ISA。同时对大量的可配置控制开关进行了流水线周期的延迟匹配，保证在修改 CSR (如打开/关闭中断) 瞬间流水线上混杂的新旧指令行为不会导致状态机崩溃。
