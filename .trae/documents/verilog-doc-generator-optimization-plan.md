# Verilog 文档生成器优化计划

## 优化目标

优化 verilog-doc-generator SKILL 的描述，确保：

1. **Markdown 文档**：所有框图、时序图、状态机转移图等使用 Mermaid 语法
2. **Word 文档**：所有图表替换为对应的 PNG 图片

## 任务分解

### [x] 任务 1：更新 SKILL 描述
- **Priority**: P0
- **Depends On**: None
- **Description**:
  - 明确在 Markdown 文档中使用 Mermaid 语法
  - 明确在 Word 文档中使用 PNG 图片
  - 更新文档生成流程描述
- **Success Criteria**:
  - SKILL 描述清晰说明图表处理方式
  - 文档生成流程中明确图表处理步骤
- **Test Requirements**:
  - `programmatic` TR-1.1: SKILL.md 文件已更新 ✓
  - `human-judgment` TR-1.2: 描述清晰、准确，符合用户要求 ✓

### [x] 任务 2：优化图表生成流程
- **Priority**: P0
- **Depends On**: 任务 1
- **Description**:
  - 确保子 SKILL 调用时同时生成 Mermaid 和 PNG
  - 明确 Markdown 文档插入 Mermaid 代码
  - 明确 Word 文档插入 PNG 图片
- **Success Criteria**:
  - 图表生成流程清晰明确
  - 两种文档格式的图表处理方式明确区分
- **Test Requirements**:
  - `programmatic` TR-2.1: 流程描述完整 ✓
  - `human-judgment` TR-2.2: 流程逻辑正确，符合用户要求 ✓

### [x] 任务 3：更新输出文件清单
- **Priority**: P1
- **Depends On**: 任务 2
- **Description**:
  - 明确 Markdown 文档使用 Mermaid
  - 明确 Word 文档使用 PNG
  - 确保所有图表类型都有对应的处理方式
- **Success Criteria**:
  - 输出文件清单明确图表文件类型
  - 文档格式与图表类型对应关系清晰
- **Test Requirements**:
  - `programmatic` TR-3.1: 输出文件清单已更新 ✓
  - `human-judgment` TR-3.2: 清单内容完整、准确 ✓

### [x] 任务 4：更新验证检查清单
- **Priority**: P1
- **Depends On**: 任务 3
- **Description**:
  - 添加图表格式验证项目
  - 确保 Markdown 中 Mermaid 正确
  - 确保 Word 中 PNG 图片正确
- **Success Criteria**:
  - 验证检查清单包含图表格式验证
  - 验证项目覆盖所有图表类型
- **Test Requirements**:
  - `programmatic` TR-4.1: 验证检查清单已更新 ✓
  - `human-judgment` TR-4.2: 验证项目完整、合理 ✓

## 优化总结

### 已完成的优化

1. **SKILL 描述更新**：
   - 明确 Markdown 文档使用 Mermaid 语法
   - 明确 Word 文档使用 PNG 图片
   - 更新了文档生成流程描述

2. **图表生成流程优化**：
   - 确保子 SKILL 调用时同时生成 Mermaid 和 PNG
   - 明确 Markdown 文档插入 Mermaid 代码
   - 明确 Word 文档插入 PNG 图片

3. **输出文件清单更新**：
   - 明确 Markdown 文档使用 Mermaid
   - 明确 Word 文档使用 PNG
   - 确保所有图表类型都有对应的处理方式

4. **验证检查清单更新**：
   - 添加图表格式验证项目
   - 确保 Markdown 中 Mermaid 正确
   - 确保 Word 中 PNG 图片正确

### 预期效果

- **Markdown 文档**：所有框图、时序图、状态机转移图等使用 Mermaid 语法
- **Word 文档**：所有图表替换为对应的 PNG 图片
- **生成流程**：更加明确和规范
- **验证流程**：更加全面和严格

## 实施步骤

1. **分析当前 SKILL 描述**：了解当前的图表处理方式
2. **更新 SKILL 描述**：明确 Mermaid 和 PNG 的使用场景
3. **优化生成流程**：确保两种格式的图表处理正确
4. **更新输出清单**：明确文件类型和对应关系
5. **更新验证清单**：添加图表格式验证项目

## 预期成果

* 优化后的 SKILL 描述清晰说明图表处理方式

* Markdown 文档使用 Mermaid 语法显示图表

* Word 文档使用 PNG 图片显示图表

* 文档生成流程更加明确和规范

