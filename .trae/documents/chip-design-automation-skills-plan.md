# 芯片设计自动化SKILL开发计划

## 任务概述

开发一套完整的芯片设计自动化SKILL，覆盖从需求到代码的全流程。

## 现有资源分析

### 已有Skill
- `verilog-state-diagram` - 状态机转移图生成
- `verilog-block-diagram` - 模块框图生成
- `verilog-file-tree` - 文件列表和模块例化树
- `verilog-timing-diagram` - 接口时序图生成
- `verilog-doc-generator` - 模块文档生成
- `docx` - Word文档生成

### 已有文档模板
- `.trae/specs/upgrade-rvv-1.0/spec.md` - 需求规范模板(Gherkin格式)
- `.trae/documents/*.md` - 模块方案文档模板

## SKILL开发计划

### SKILL 1: 需求分析与明确化

**Skill名称**: `requirements-analyzer`

**功能**:
1. 接收原始需求列表(用户输入或文档)
2. 识别需求中的错误、歧义和遗漏点
3. 生成问题清单让用户确认
4. 输出明确的需求列表

**输出格式**: Gherkin格式需求

**参考模板**:
- 参照 `.trae/specs/upgrade-rvv-1.0/spec.md` 的需求格式

**实现步骤**:
1. 解析原始需求文本
2. 识别模糊表述(如"可能"、"也许"、"支持某些功能")
3. 识别矛盾需求
4. 识别不完整信息(缺少条件、边界值)
5. 生成问题确认清单
6. 整合确认后的明确需求

### SKILL 2: 功能规格说明书生成

**Skill名称**: `functional-spec-generator`

**功能**:
1. 接收明确的需求列表
2. 生成完整的芯片功能规格说明书
3. 包含功能列表、接口定义、性能指标等

**输出格式**: Markdown/Word文档

**文档结构**:
```
1. 概述
   1.1 芯片简介
   1.2 技术指标
   1.3 功能清单
2. 功能详细描述
   2.1 功能模块划分
   2.2 各模块功能描述
3. 接口定义
   3.1 外部接口
   3.2 内部接口
4. 寄存器定义
5. 性能指标
6. 异常处理
```

### SKILL 3: 芯片总体方案文档生成

**Skill名称**: `top-level-design-generator`

**功能**:
1. 接收功能规格说明书
2. 生成芯片总体方案文档
3. 包含架构设计、子系统划分、接口定义等

**文档结构**:
```
1. 芯片概述
2. 系统架构
   2.1 整体架构图
   2.2 子系统划分
   2.3 时钟网络
   2.4 复位网络
3. 各子系统功能描述
4. 系统接口
5. 地址规划
6. 中断和异常
7. 低功耗设计
```

### SKILL 4: 模块详细方案文档生成

**Skill名称**: `module-design-generator`

**功能**:
1. 接收功能规格说明书和总体方案文档
2. 生成模块详细方案文档
3. 包含模块概述、功能需求、设计架构、接口定义、实现方案、测试策略等

**文档结构**:
```
1. 模块概述
   1.1 功能简介
   1.2 主要功能
   1.3 技术指标
2. 系统架构
   2.1 整体架构图
   2.2 子模块列表
   2.3 数据流
3. 接口定义
   3.1 时钟复位
   3.2 信号接口列表
4. 功能描述
   4.1 状态机设计
   4.2 数据处理流程
5. 实现方案
   5.1 关键逻辑设计
   5.2 状态机设计
6. 测试策略
7. 附录
```

### SKILL 5: 芯片代码生成

**Skill名称**: `rtl-code-generator`

**功能**:
1. 接收模块详细方案文档
2. 生成Verilog RTL代码
3. 遵循编码规范

**编码规范检查项**:
- 命名规范(信号、模块、参数)
- 代码结构(always块、assign)
- 时序逻辑描述
- 组合逻辑描述
- 例化模板

### SKILL 6: 寄存器手册生成

**Skill名称**: `register-manual-generator`

**功能**:
1. 接收模块详细方案文档
2. 生成寄存器手册
3. 包含寄存器列表、字段定义、访问属性等

**文档结构**:
```
1. 寄存器概述
2. 寄存器列表
   2.1 寄存器名称
   2.2 地址偏移
   2.3 访问属性
   2.4 字段定义
3. 寄存器访问示例
```

### SKILL 7: Verilog静态检查与代码修改

**Skill名称**: `verilog-linter`

**功能**:
1. 调用Verilog静态检查工具(如Verilator, SpyGlass)
2. 分析检查结果
3. 自动修改代码修复问题

**检查工具**: Verilator, SpyGlass, Design Compiler

### SKILL 8: 工作流调度器

**Skill名称**: `chip-design-orchestrator`

**功能**:
1. 调度执行上述所有SKILL
2. 检查输出质量
3. 迭代优化直到生成达标文档和代码

**调度逻辑**:
```
1. requirements-analyzer -> 明确需求
2. functional-spec-generator <- 明确需求 -> 功能规格说明书
3. top-level-design-generator <- 功能规格说明书 -> 总体方案
4. module-design-generator <- 总体方案 + 功能规格 -> 模块方案
5. rtl-code-generator <- 模块方案 -> RTL代码
6. register-manual-generator <- 模块方案 -> 寄存器手册
7. verilog-linter <- RTL代码 -> 检查结果
8. 如果检查失败 -> 迭代修复
9. 质量检查 -> 输出最终文档和代码
```

## 文件结构

```
.skills/
├── requirements-analyzer/
│   ├── SKILL.md
│   └── scripts/
│       └── requirements_parser.py
├── functional-spec-generator/
│   ├── SKILL.md
│   └── templates/
│       └── functional_spec.md
├── top-level-design-generator/
│   ├── SKILL.md
│   └── templates/
│       └── top_level_design.md
├── module-design-generator/
│   ├── SKILL.md
│   └── templates/
│       └── module_design.md
├── rtl-code-generator/
│   ├── SKILL.md
│   ├── templates/
│   │   └── rtl_template.v
│   └── scripts/
│       └── code_generator.py
├── register-manual-generator/
│   ├── SKILL.md
│   └── templates/
│       └── register_manual.md
├── verilog-linter/
│   ├── SKILL.md
│   └── scripts/
│       └── lint_checker.py
└── chip-design-orchestrator/
    ├── SKILL.md
    └── scripts/
        └── workflow_scheduler.py
```

## 实现优先级

| 优先级 | Skill | 依赖 |
|--------|-------|------|
| 1 | requirements-analyzer | 无 |
| 2 | functional-spec-generator | requirements-analyzer |
| 3 | module-design-generator | functional-spec-generator |
| 4 | rtl-code-generator | module-design-generator |
| 5 | register-manual-generator | module-design-generator |
| 6 | top-level-design-generator | functional-spec-generator |
| 7 | verilog-linter | rtl-code-generator |
| 8 | chip-design-orchestrator | 以上所有 |

## 验证计划

1. 使用 `.trae/specs/upgrade-rvv-1.0/spec.md` 作为测试输入
2. 依次执行各SKILL
3. 验证输出文档的完整性和正确性
4. 迭代优化直到输出质量达标
