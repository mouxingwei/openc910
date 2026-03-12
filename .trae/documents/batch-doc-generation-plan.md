# OpenC910 项目 0/1/2 级模块设计文档生成计划

## 目标

为 OpenC910 项目的所有 0、1、2 级模块生成设计文档，包括 Markdown 和 Word 格式。

## 模块列表

### Level 0 (顶层模块) - 1个

| 序号 | 模块名     | 状态    |
| -- | ------- | ----- |
| 1  | ct\_top | ✅ 已生成 |

### Level 1 (一级子模块) - 8个

| 序号 | 模块名                   | 实例名                      | 功能描述   |
| -- | --------------------- | ------------------------ | ------ |
| 1  | ct\_core              | x\_ct\_core              | 处理器核心  |
| 2  | ct\_mmu\_top          | x\_ct\_mmu\_top          | 内存管理单元 |
| 3  | ct\_pmp\_top          | x\_ct\_pmp\_top          | 物理内存保护 |
| 4  | ct\_biu\_top          | x\_ct\_biu\_top          | 总线接口单元 |
| 5  | ct\_had\_private\_top | x\_ct\_had\_private\_top | 硬件调试   |
| 6  | ct\_hpcp\_top         | x\_ct\_hpcp\_top         | 性能计数器  |
| 7  | ct\_rst\_top          | x\_ct\_rst\_top          | 复位控制   |
| 8  | ct\_clk\_top          | x\_ct\_clk\_top          | 时钟控制   |

### Level 2 (二级子模块) - 7个

| 序号 | 模块名           | 实例名              | 功能描述     |
| -- | ------------- | ---------------- | -------- |
| 1  | ct\_ifu\_top  | x\_ct\_ifu\_top  | 取指单元     |
| 2  | ct\_idu\_top  | x\_ct\_idu\_top  | 译码单元     |
| 3  | ct\_iu\_top   | x\_ct\_iu\_top   | 整数执行单元   |
| 4  | ct\_vfpu\_top | x\_ct\_vfpu\_top | 向量浮点单元   |
| 5  | ct\_lsu\_top  | x\_ct\_lsu\_top  | 访存单元     |
| 6  | ct\_cp0\_top  | x\_ct\_cp0\_top  | 协处理器 CP0 |
| 7  | ct\_rtu\_top  | x\_ct\_rtu\_top  | 退休单元     |

## 实现步骤

### 步骤 1：生成 Level 1 模块文档 (8个)

按顺序处理：

1. ct\_core
2. ct\_mmu\_top
3. ct\_pmp\_top
4. ct\_biu\_top
5. ct\_had\_private\_top
6. ct\_hpcp\_top
7. ct\_rst\_top
8. ct\_clk\_top

每个模块：

* 解析 Verilog 文件

* 生成模块框图

* 生成 Markdown 文档

* 生成 Word 文档

### 步骤 2：生成 Level 2 模块文档 (7个)

按顺序处理：

1. ct\_ifu\_top
2. ct\_idu\_top
3. ct\_iu\_top
4. ct\_vfpu\_top
5. ct\_lsu\_top
6. ct\_cp0\_top
7. ct\_rtu\_top

每个模块：

* 解析 Verilog 文件

* 生成模块框图

* 生成 Markdown 文档

* 生成 Word 文档

### 步骤 3：上传 Git

```bash
git add .trae/documents/
git commit -m "docs: 生成0/1/2级模块设计文档"
git push
```

## 预计生成文档数量

| 级别      | 模块数量 | 文档数量 (MD+DOCX) |
| ------- | ---- | -------------- |
| Level 0 | 1    | 2 (已生成)        |
| Level 1 | 8    | 16             |
| Level 2 | 7    | 14             |
| **总计**  | 16   | 32             |

## 输出文件

**输出目录**: `d:\code\openc910\.trae\documents\`

**文件列表**:

* ct\_top\_top.md / ct\_top\_top.docx (已生成)

* ct\_core\_top.md / ct\_core\_top.docx

* ct\_mmu\_top\_top.md / ct\_mmu\_top\_top.docx

* ct\_pmp\_top\_top.md / ct\_pmp\_top\_top.docx

* ct\_biu\_top\_top.md / ct\_biu\_top\_top.docx

* ct\_had\_private\_top\_top.md / ct\_had\_private\_top\_top.docx

* ct\_hpcp\_top\_top.md / ct\_hpcp\_top\_top.docx

* ct\_rst\_top\_top.md / ct\_rst\_top\_top.docx

* ct\_clk\_top\_top.md / ct\_clk\_top\_top.docx

* ct\_ifu\_top\_top.md / ct\_ifu\_top\_top.docx

* ct\_idu\_top\_top.md / ct\_idu\_top\_top.docx

* ct\_iu\_top\_top.md / ct\_iu\_top\_top.docx

* ct\_vfpu\_top\_top.md / ct\_vfpu\_top\_top.docx

* ct\_lsu\_top\_top.md / ct\_lsu\_top\_top.docx

* ct\_cp0\_top\_top.md / ct\_cp0\_top\_top.docx

* ct\_rtu\_top\_top.md / ct\_rtu\_top\_top.docx

