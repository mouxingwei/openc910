---
name: verilog-linter
description: |
  Verilog静态检查与代码修改SKILL。
  调用Verilog静态检查工具（如Verilator, SpyGlass）检查代码，分析检查结果，自动修改代码修复问题。
  当用户需要检查RTL代码质量、修复静态检查问题时使用此技能。
---

# Verilog静态检查与代码修改

## 功能概述

本SKILL调用Verilog静态检查工具检查RTL代码，分析检查结果并自动修复问题。

## 使用场景

- RTL代码编写完成，需要进行静态检查
- 需要修复静态检查发现的问题
- 需要确保代码符合编码规范

## 工作流程

### Step 1: 收集输入

1. 确认需要检查的Verilog文件
2. 确认检查工具（Verilator/SpyGlass等）
3. 确认检查规则配置

### Step 2: 执行静态检查

**使用Verilator检查**：

```bash
verilator --lint-only -Wall module_name.v
```

**使用SpyGlass检查**：

```bash
spyglass -batch -project project.tcl
```

### Step 3: 分析检查结果

解析检查结果，分类问题：

**严重问题（Critical）**：
- 语法错误
- 端口连接错误
- 信号未连接

**警告问题（Warning）**：
- 代码风格问题
- 可综合性问题
- 异步复位问题

**信息问题（Info）**：
- 建议性改进
- 代码优化提示

### Step 4: 自动修复问题

对于可自动修复的问题，进行修复：

**可自动修复的问题**：
- 缺少default分支的case语句
- 组合逻辑中的锁存器
- 未使用的信号
- 编码规范问题

**需要手动修复的问题**：
- 逻辑错误
- 端口连接错误
- 复杂的时序问题

### Step 5: 生成检查报告

## 检查报告模板

```markdown
# Verilog静态检查报告

## 检查信息

| 项目 | 内容 |
|------|------|
| 模块名称 | |
| 检查工具 | |
| 检查时间 | |
| 检查文件 | |

---

## 检查结果汇总

| 级别 | 数量 |
|------|------|
| 严重 | X |
| 警告 | X |
| 信息 | X |

---

## 严重问题

### 问题 1: [问题描述]

**文件**: xxx.v
**行号**: XX
**问题**: [问题描述]
**建议修复**: [修复建议]

---

## 警告问题

### 问题 1: [问题描述]

**文件**: xxx.v
**行号**: XX
**问题**: [问题描述]
**建议修复**: [修复建议]

---

## 已自动修复的问题

| 文件 | 行号 | 问题 | 修复方式 |
|------|------|------|----------|
| xxx.v | 10 | 缺少default | 添加default分支 |

---

## 未修复问题

| 文件 | 行号 | 问题 | 原因 |
|------|------|------|------|
| xxx.v | 20 | 逻辑错误 | 需要手动修复 |
```

### Step 6: 迭代修复

对于需要手动修复的问题：
1. 标记问题
2. 提供修复建议
3. 等待用户修复
4. 重新检查

### Step 7: 输出最终代码

修复所有可修复的问题后，输出最终的Verilog代码。

## 检查规则说明

### 严重规则

| 规则 | 描述 | 检查工具 |
|------|------|----------|
| SYNTAX_ERROR | 语法错误 | All |
| PORT_CONNECTION | 端口连接错误 | All |
| MULTIDRIVEN | 多驱动问题 | All |
| COMBINATIONAL_LOOP | 组合逻辑环路 | All |

### 警告规则

| 规则 | 描述 | 检查工具 |
|------|------|----------|
| LATCH | 锁存器推断 | All |
| UNUSED_SIGNAL | 未使用信号 | All |
| WIDTH_MISMATCH | 位宽不匹配 | All |
| ASYNC_RESET | 异步复位建议 | Verilator |

### 信息规则

| 规则 | 描述 | 检查工具 |
|------|------|----------|
| STYLE | 代码风格 | Verilator |
| OPTIMIZE | 代码优化建议 | Verilator |

## 常用检查命令

### Verilator

```bash
# 基本检查
verilator --lint-only -Wall module.v

# 详细检查
verilator --lint-only -Wall --debug module.v

# 指定规则
verilator --lint-only -Wall --rule-always style,latency module.v

# 输出到文件
verilator --lint-only -Wall module.v 2>&1 | tee lint_report.txt
```

### SpyGlass

```bash
# 使用预设规则集
spyglass -batch -goal lint/rtl_lint module.v

# 使用自定义规则
spyglass -batch -goal my_rules module.v
```

## 自动修复示例

### 1. 添加default分支

**问题**：
```verilog
case (state)
    IDLE: next_state = RUN;
    RUN: next_state = DONE;
    // 缺少default
endcase
```

**修复后**：
```verilog
case (state)
    IDLE: next_state = RUN;
    RUN: next_state = DONE;
    default: next_state = IDLE;
endcase
```

### 2. 添加复位值

**问题**：
```verilog
always @(posedge clk) begin
    data <= data_in;
end
```

**修复后**：
```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 1'b0;
    end else begin
        data <= data_in;
    end
end
```

### 3. 删除未使用信号

**问题**：
```verilog
wire unused_signal;
assign unused_signal = a & b;
assign out = c | d;
```

**修复后**：
```verilog
// wire unused_signal;  // 删除未使用的信号
// assign unused_signal = a & b;
assign out = c | d;
```

## 输出格式

### 1. 检查报告

输出Markdown格式的检查报告。

### 2. 修复后的代码

输出修复后的Verilog代码文件。

## 注意事项

1. **先检查后修复**：先执行检查，再进行修复
2. **保留备份**：修复前备份原始文件
3. **逐个修复**：逐个问题修复，便于追踪
4. **验证修复**：修复后重新检查确认
5. **手动修复**：对于复杂问题，提供修复建议

## 相关SKILL

- `rtl-code-generator`: 生成RTL代码
- `chip-design-orchestrator`: 调度整个芯片设计流程
