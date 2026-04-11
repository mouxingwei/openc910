# RISC-V Vector Extension (RVV1.0) 指令集整理计划

## 任务目标
将 `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master` 中的 RISC-V V Vector Extension v1.0 指令集整理成 JSON 和 Excel 格式文件，包含以下信息：
- 指令名 (Instruction Name)
- 指令类型 (Instruction Type/Category)
- 指令域段 (Instruction Fields/Encoding)
- 指令功能 (Instruction Function/Description)

## 文档分析

### 关键源文件
| 文件 | 用途 |
|------|------|
| `v-spec.adoc` | 主规格文档，包含所有指令定义 |
| `inst-table.adoc` | 指令编码表（ funct3/funct6/操作数类型）|
| `listing.adoc` | 指令语义说明（C代码格式）|
| `vector-op-base.csv` | 指令基本操作信息 |
| `vector-op-vtypes.csv` | 指令VTYPE操作信息 |
| `vcfg-format.adoc` | 配置类指令格式 |
| `vmem-format.adoc` | 内存操作指令格式 |
| `valu-format.adoc` | 算术逻辑单元指令格式 |
| `vamo-format.adoc` | 原子操作指令格式 |
| `vtype-format.adoc` | 向量类型寄存器格式 |

### 指令分类
1. **配置类 (Configuration)**: vsetvl, vsetvli, vsetivl, vsetvl
2. **加载/存储类 (Load/Store)**: vl, vs, vls, vss, vlx, vsx 等
3. **算术运算类 (Arithmetic)**: vadd, vsub, vmul, vdiv 等
4. **比较类 (Compare)**: vseq, vsne, vslt, vsle 等
5. **逻辑类 (Logical)**: vand, vor, vxor 等
6. **移位类 (Shift)**: vsll, vsrl, vsra 等
7. **归约类 (Reduction)**: vredsum, vredmax, vredmin 等
8. **乘加类 (Multiply-Add)**: vmadd, vmsub, vmacc 等
9. **浮点类 (FP)**: vfadd, vfsub, vfmul, vfdiv 等
10. **转换类 (Convert)**: vfcvt, vfwcvt, vfncvt 等
11. **掩码类 (Mask)**: vmand, vmor, vmxor 等
12. **移动类 (Move)**: vmv, vfmv 等
13. **原子操作类 (Atomic)**: vamoadd, vamoand 等
14. **特殊功能类 (Special)**: vpopc, vfirst, vmv.x.s 等

## 实施步骤

### 步骤 1: 分析并提取所有指令信息
- 解析 `inst-table.adoc` 获取指令编码表
- 解析 `vector-op-base.csv` 和 `vector-op-vtypes.csv` 获取指令分类信息
- 解析 `listing.adoc` 获取指令语义
- 解析各个 format 文件获取指令域段定义

### 步骤 2: 构建指令 JSON 数据结构
创建 JSON 文件结构：
```json
{
  "metadata": {
    "version": "1.0",
    "source": "riscv-v-spec-master",
    "description": "RISC-V Vector Extension Instruction Set"
  },
  "instructions": [
    {
      "name": "vadd",
      "full_name": "Vector Add",
      "category": "arithmetic",
      "type": "OPIVV/OPIVX/OPIVI",
      "encoding": {
        "funct6": "000000",
        "funct3": "000",
        "opcode": "1010111"
      },
      "operands": {
        "vd": "destination",
        "vs1": "source1",
        "vs2": "source2",
        "vm": "mask"
      },
      "description": "Add vector elements",
      "semantics": "vd[i] = vs1[i] + vs2[i]"
    }
  ]
}
```

### 步骤 3: 生成 Excel 文件
- 使用 Python + openpyxl 或 pandas 生成 Excel
- 创建多个工作表：指令总表、分类统计、编码参考

### 步骤 4: 输出文件位置
- JSON: `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master\rvv_instructions.json`
- Excel: `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master\rvv_instructions.xlsx`

## 技术方案
- 使用 Python 脚本进行文档解析和数据提取
- 使用 `pandas` 库处理数据并生成 Excel
- 使用标准 `json` 库生成 JSON 文件

## 预期产出
1. `rvv_instructions.json` - 完整的 RVV1.0 指令集 JSON 格式文件
2. `rvv_instructions.xlsx` - 包含以下工作表的 Excel 文件：
   - Sheet1: 指令总表（按名称排序）
   - Sheet2: 指令分类总览
   - Sheet3: 指令编码表
   - Sheet4: 各分类指令详情
