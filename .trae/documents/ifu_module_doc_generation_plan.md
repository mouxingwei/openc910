# IFU 模块详细方案文档生成计划

## 目标

使用 module-design-generator 技能在 docs 目录生成 ct\_ifu\_top 模块的详细方案文档，包含模块概述、系统架构、接口定义、功能描述、实现方案、测试策略等章节。所有图表使用 Mermaid 语法。

## 模块分析结果

### 模块基本信息

| 属性    | 值                                                  |
| ----- | -------------------------------------------------- |
| 模块名称  | ct\_ifu\_top                                       |
| 文件路径  | C910\_RTL\_FACTORY\gen\_rtl\ifu\rtl\ct\_ifu\_top.v |
| 层级    | Level 2 (子系统级)                                     |
| 所属子系统 | IFU (Instruction Fetch Unit)                       |
| 子模块数量 | 20个                                                |

### 功能描述

ct\_ifu\_top 是 OpenC910 处理器中的**指令获取单元（Instruction Fetch Unit）顶层模块**，负责完成以下核心功能：

1. **指令获取（IF Stage）**：从 ICache 获取指令，管理取指地址
2. **指令预取（IP Stage）**：预取指令到指令缓冲，提高取指效率
3. **分支预测（BPU）**：使用 BHT/BTB/RAS 进行分支预测
4. **指令缓存（ICache）**：管理指令缓存，处理缓存缺失
5. **指令缓冲（IBuffer）**：缓存指令，提供给 IDU 译码

### 子模块列表（共20个）

| 序号 | 子模块名称               | 功能描述           |
| -- | ------------------- | -------------- |
| 1  | ct\_ifu\_pcgen      | PC 生成器，管理取指 PC |
| 2  | ct\_ifu\_addrgen    | 地址生成器，计算取指地址   |
| 3  | ct\_ifu\_ifctrl     | 取指控制逻辑         |
| 4  | ct\_ifu\_ifdp       | 取指数据通路         |
| 5  | ct\_ifu\_ipctrl     | 指令预取控制         |
| 6  | ct\_ifu\_ipdp       | 指令预取数据通路       |
| 7  | ct\_ifu\_ipb        | 指令预取缓冲         |
| 8  | ct\_ifu\_ibctrl     | 指令缓冲控制         |
| 9  | ct\_ifu\_ibdp       | 指令缓冲数据通路       |
| 10 | ct\_ifu\_ibuf       | 指令缓冲           |
| 11 | ct\_ifu\_icache\_if | ICache 接口      |
| 12 | ct\_ifu\_bht        | 分支历史表          |
| 13 | ct\_ifu\_btb        | 分支目标缓冲         |
| 14 | ct\_ifu\_ind\_btb   | 间接 BTB         |
| 15 | ct\_ifu\_l0\_btb    | L0 BTB（快速预测）   |
| 16 | ct\_ifu\_ras        | 返回地址栈          |
| 17 | ct\_ifu\_sfp        | 分支预测器          |
| 18 | ct\_ifu\_lbuf       | 行缓冲            |
| 19 | ct\_ifu\_vector     | 向量处理支持         |
| 20 | ct\_ifu\_debug      | 调试支持           |

### 主要接口

| 接口类型   | 连接模块 | 主要信号          |
| ------ | ---- | ------------- |
| CP0 接口 | CP0  | 配置信号、使能信号     |
| IDU 接口 | IDU  | 指令数据、有效信号     |
| IU 接口  | IU   | 分支预测结果、PCFIFO |
| LSU 接口 | LSU  | ICache 无效化    |
| MMU 接口 | MMU  | 地址翻译          |
| RTU 接口 | RTU  | 流水线冲刷、PC 更新   |
| BIU 接口 | BIU  | 总线请求          |

***

## 任务分解

### \[ ] 任务 1：分析 IFU 顶层模块接口

* **Priority**: P0

* **Depends On**: None

* **Description**:

  * 读取 ct\_ifu\_top.v 文件，提取所有输入输出端口

  * 分析端口功能，按接口类型分类（CP0/IDU/IU/LSU/MMU/RTU/BIU）

  * 识别关键信号的功能

* **Success Criteria**:

  * 完整的端口列表

  * 清晰的接口分类

* **Test Requirements**:

  * `programmatic` TR-1.1: 端口列表完整，无遗漏

  * `human-judgment` TR-1.2: 接口分类合理，描述准确

### \[ ] 任务 2：分析子模块结构和功能

* **Priority**: P0

* **Depends On**: 任务 1

* **Description**:

  * 分析各子模块的功能

  * 确定模块层次结构（IF Stage / IP Stage / IBuffer / BPU）

  * 识别关键数据流和控制流

* **Success Criteria**:

  * 完整的子模块功能描述

  * 清晰的模块层次结构

* **Test Requirements**:

  * `programmatic` TR-2.1: 子模块列表完整

  * `human-judgment` TR-2.2: 功能描述准确

### \[ ] 任务 3：生成模块架构图

* **Priority**: P0

* **Depends On**: 任务 2

* **Description**:

  * 使用 Mermaid 语法绘制模块架构图

  * 显示子模块之间的连接关系

  * 标注主要数据流和控制流

* **Success Criteria**:

  * 清晰的架构图

  * 完整的子模块关系

* **Test Requirements**:

  * `programmatic` TR-3.1: Mermaid 语法正确

  * `human-judgment` TR-3.2: 架构图清晰易懂

### \[ ] 任务 4：生成详细方案文档

* **Priority**: P0

* **Depends On**: 任务 3

* **Description**:

  * 按模板结构生成完整文档

  * 包含模块概述、系统架构、接口定义、功能描述、实现方案、测试策略等章节

  * 使用 Mermaid 语法绘制所有图表

* **Success Criteria**:

  * 完整的文档结构

  * 清晰的内容描述

* **Test Requirements**:

  * `programmatic` TR-4.1: 文档格式正确

  * `human-judgment` TR-4.2: 内容完整准确

### \[ ] 任务 5：质量检查和输出

* **Priority**: P1

* **Depends On**: 任务 4

* **Description**:

  * 检查文档完整性

  * 检查 Mermaid 图表正确性

  * 输出到 docs 目录

* **Success Criteria**:

  * 文档质量达标

  * 输出路径正确

* **Test Requirements**:

  * `programmatic` TR-5.1: 文件已生成到 docs 目录

  * `human-judgment` TR-5.2: 文档质量符合要求

***

## 文档结构模板

```markdown
# ct_ifu_top 模块详细方案文档

## 1. 模块概述
### 1.1 基本信息
### 1.2 功能描述
### 1.3 设计特点
### 1.4 模块层次结构

## 2. 模块接口说明
### 2.1 接口总览
### 2.2 与 CP0 接口
### 2.3 与 IDU 接口
### 2.4 与 IU 接口
### 2.5 与 LSU 接口
### 2.6 与 MMU 接口
### 2.7 与 RTU 接口
### 2.8 与 BIU 接口

## 3. 模块架构图
### 3.1 整体架构（Mermaid）
### 3.2 流水线结构（Mermaid）
### 3.3 主要数据连线

## 4. 子模块详细说明
### 4.1 取指控制模块 (IF Stage)
### 4.2 指令预取模块 (IP Stage)
### 4.3 指令缓存模块 (ICache)
### 4.4 指令缓冲模块 (IBuffer)
### 4.5 分支预测模块 (BPU)

## 5. 功能描述
### 5.1 指令获取
### 5.2 分支预测
### 5.3 指令缓存
### 5.4 指令缓冲

## 6. 实现方案
### 6.1 流水线设计
### 6.2 分支预测算法
### 6.3 缓存管理

## 7. 测试策略
### 7.1 功能验证
### 7.2 边界条件
### 7.3 性能测试

## 8. 参考资料
```

***

## 预期输出

* **文件路径**: `d:\code\openc910\docs\ct_ifu_top_detailed.md`

* **文档格式**: Markdown (使用 Mermaid 图表)

* **图表类型**:

  * 模块架构图 (Mermaid graph TB)

  * 流水线结构图 (Mermaid sequenceDiagram)

  * 状态机图 (Mermaid stateDiagram-v2，如适用)

