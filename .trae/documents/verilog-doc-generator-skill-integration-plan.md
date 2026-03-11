# verilog-doc-generator SKILL 优化计划

## 优化目标

优化 `verilog-doc-generator` SKILL，将图表生成功能委托给专门的子 SKILL：

1. **状态转移图** → 调用 `verilog-state-diagram`
2. **接口时序图** → 调用 `verilog-timing-diagram`
3. **模块框图、流水线图** → 调用 `verilog-block-diagram`
4. **Python 脚本** → 放到 `scripts` 目录

---

## 详细修改步骤

### 步骤 1：创建 scripts 目录结构

在 `verilog-doc-generator` skill 目录下创建 `scripts` 目录：

```
.trae/skills/verilog-doc-generator/
├── SKILL.md
└── scripts/
    ├── verilog_parser.py          # Verilog 解析脚本（使用 Hdlparse/Pyverilog）
    ├── docx_generator.js          # Word 文档生成脚本
    └── mermaid_to_png.js          # Mermaid 转 PNG 脚本（可选）
```

### 步骤 2：创建 verilog_parser.py

将 SKILL.md 中的 Python 解析脚本提取到独立文件：

**文件路径：** `.trae/skills/verilog-doc-generator/scripts/verilog_parser.py`

**功能：**
- 使用 Hdlparse 提取基础信息（端口、参数）
- 使用 Pyverilog 进行深度分析（实例化、信号、always块）
- 正则表达式回退解析
- 输出 JSON 格式

### 步骤 3：修改 SKILL.md - 调用子 SKILL

#### 3.1 调用 verilog-state-diagram

**修改位置：** 步骤 3 智能分析 → 状态机检测

**调用方式：**
```markdown
#### 3.1 状态机检测

调用 `verilog-state-diagram` skill 进行状态机分析。

**调用方法：**
1. 使用 Skill 工具调用 `verilog-state-diagram`
2. 传递 Verilog 文件路径或内容
3. 获取返回的状态机分析结果：
   - `states`: 状态列表（数组）
   - `transitions`: 转移条件列表（数组）
   - `mermaid`: Mermaid 状态图语法字符串
   - `png_path`: PNG 图片路径（如需要生成 Word 文档）

**返回数据结构示例：**
```json
{
    "fsm_type": "Moore",
    "fsm_structure": "三段式",
    "state_reg": "current_state",
    "next_state_reg": "next_state",
    "states": [
        {"name": "IDLE", "encoding": "3'b000", "description": "空闲状态"},
        {"name": "RUN", "encoding": "3'b001", "description": "运行状态"}
    ],
    "transitions": [
        {"from": "IDLE", "to": "RUN", "condition": "start=1", "description": "启动"}
    ],
    "mermaid": "stateDiagram-v2\n    [*] --> IDLE: 复位\n    ...",
    "png_path": "/path/to/state_diagram.png"
}
```

**整合到文档：**
- 将 `mermaid` 内容插入 Markdown 文档的状态转移图章节
- 将 `png_path` 指向的图片嵌入 Word 文档
- 将 `states` 和 `transitions` 转换为表格格式
```

#### 3.2 调用 verilog-timing-diagram

**修改位置：** 步骤 4 生成 Markdown 文档 → 接口时序（可选）

**调用方式：**
```markdown
**接口时序分析：**

调用 `verilog-timing-diagram` skill 进行接口时序分析。

**调用方法：**
1. 使用 Skill 工具调用 `verilog-timing-diagram`
2. 传递 Verilog 文件路径和输出目录
3. 获取返回的时序图文件路径：
   - `md_path`: Markdown 文件路径（包含 Mermaid Sequence Diagram）
   - `json_path`: WaveDrom JSON 文件路径
   - `png_path`: PNG 图片路径（用于 Word 文档）

**返回数据结构示例：**
```json
{
    "md_path": "/path/to/module_timing.md",
    "json_path": "/path/to/module_timing.json",
    "png_path": "/path/to/module_timing.png"
}
```

**整合到文档：**
- 将 Markdown 文件内容嵌入文档的"接口时序"章节
- 将 PNG 图片嵌入 Word 文档
- 使用 JSON 文件进行进一步处理或在线预览
```

#### 3.3 调用 verilog-block-diagram

**修改位置：** 步骤 4 生成 Markdown 文档 → 模块框图、流水线图

**调用方式：**
```markdown
**模块框图和流水线图生成：**

调用 `verilog-block-diagram` skill 生成模块框图和流水线图。

**调用方法：**
1. 使用 Skill 工具调用 `verilog-block-diagram`
2. 传递 Verilog 文件路径和输出目录
3. 获取返回的文件路径：
   - `md_path`: Markdown 文件路径（包含 Mermaid 框图）
   - `mmd_path`: Mermaid 源文件路径
   - `png_path`: PNG 图片路径
   - `pipeline_md_path`: 流水线图 Markdown 路径（如检测到流水线）
   - `pipeline_png_path`: 流水线图 PNG 路径（如检测到流水线）

**返回数据结构示例：**
```json
{
    "md_path": "/path/to/module_block_diagram.md",
    "mmd_path": "/path/to/module_block_diagram.mmd",
    "png_path": "/path/to/module_block_diagram.png",
    "pipeline_detected": true,
    "pipeline_md_path": "/path/to/module_pipeline.md",
    "pipeline_png_path": "/path/to/module_pipeline.png"
}
```

**整合到文档：**
- 将框图 Markdown 内容插入文档的"模块框图"章节
- 将流水线图 Markdown 内容插入文档的"流水线图"章节（如检测到）
- 将 PNG 图片嵌入 Word 文档
```

### 步骤 4：更新工作流程

**新的工作流程：**

```
步骤 1：收集输入文件
    └── 读取 Verilog 文件内容

步骤 2：解析 Verilog 代码
    ├── 调用 scripts/verilog_parser.py
    ├── 使用 Hdlparse 提取基础信息（端口、参数）
    ├── 使用 Pyverilog 进行深度分析
    └── 输出 JSON 格式解析结果

步骤 3：调用子 SKILL 生成图表
    ├── 调用 verilog-state-diagram → 状态转移图
    ├── 调用 verilog-timing-diagram → 接口时序图
    └── 调用 verilog-block-diagram → 模块框图、流水线图

步骤 4：生成 Markdown 文档
    └── 整合解析结果和子 SKILL 输出

步骤 5：生成 Word 文档
    ├── 调用 scripts/docx_generator.js
    └── 整合 PNG 图片
```

### 步骤 5：删除冗余代码

从 SKILL.md 中删除以下冗余内容：

1. **删除** 状态机检测的详细实现代码（改为调用 verilog-state-diagram）
2. **删除** 流水线检测的详细实现代码（改为调用 verilog-block-diagram）
3. **删除** 分支逻辑检测代码（保留简单描述）
4. **移动** Python 解析脚本到 scripts 目录

### 步骤 6：更新依赖说明

```markdown
## 依赖安装

### Python 库

pip install pyverilog hdlparse

### Node.js 库

npm install -g docx @mermaid-js/mermaid-cli wavedrom-cli

### 相关 SKILL

- verilog-state-diagram: 状态机分析
- verilog-timing-diagram: 时序图生成
- verilog-block-diagram: 框图和流水线图生成
```

---

## 文件修改清单

| 文件路径 | 修改类型 | 说明 |
|----------|----------|------|
| `.trae/skills/verilog-doc-generator/SKILL.md` | 重写 | 更新工作流程，调用子 SKILL |
| `.trae/skills/verilog-doc-generator/scripts/verilog_parser.py` | 新建 | Python 解析脚本 |
| `.trae/skills/verilog-doc-generator/scripts/docx_generator.js` | 新建 | Word 文档生成脚本（可选） |

---

## 预期结果

优化后的 SKILL 将：

1. **模块化设计**：各图表生成功能委托给专门的子 SKILL
2. **代码复用**：避免重复实现状态机检测、时序分析等功能
3. **易于维护**：修改图表生成逻辑只需更新对应的子 SKILL
4. **脚本独立**：Python 脚本放在 scripts 目录，便于测试和维护
5. **统一接口**：所有子 SKILL 返回统一的数据结构

---

## 验证方法

1. 调用 verilog-doc-generator 生成文档
2. 验证状态转移图正确生成
3. 验证接口时序图正确生成
4. 验证模块框图和流水线图正确生成
5. 验证 Markdown 和 Word 文档都正确生成
