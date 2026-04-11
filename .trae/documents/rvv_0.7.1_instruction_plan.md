# RVV 0.7.1 指令集文档整理计划

## 任务目标

根据RVV 0.7.1指令集文档，参考1.0版本的整理方式和格式，将RVV 0.7.1指令集中所有指令整理成JSON和Excel格式文件。

## 输入文件

- **0.7.1版本目录**: `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1`
  - `v-spec.adoc` - 主规范文档
  - `inst-table.adoc` - 指令编码表
  - `listing.adoc` - 指令详细语义

- **1.0版本参考**: `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0`
  - `rvv_instructions.json` - JSON格式参考
  - `rvv_instructions.xlsx` - Excel格式参考
  - `generate_rvv_docs.py` - 生成脚本参考
  - `generate_rvv_excel.py` - Excel生成脚本参考

## 输出文件

- `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1\rvv_instructions_0.7.1.json`
- `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1\rvv_instructions_0.7.1.xlsx`

## 0.7.1与1.0版本主要差异

### 指令命名差异

| 0.7.1版本 | 1.0版本 | 说明 |
|-----------|---------|------|
| vlb/vlb/vlw/vld | vle8/vle16/vle32/vle64 | 单位步幅加载 |
| vsb/vsh/vsw/vsd | vse8/vse16/vse32/vse64 | 单位步幅存储 |
| vlsb/vlsh/vlsw/vlsd | vlse8/vlse16/vlse32/vlse64 | 跨步加载 |
| vlxb/vlxh/vlxw/vlxd | vluxei8/vluxei16/vluxei32/vluxei64 | 索引加载 |
| vclipb/vcliph/vclipw | vnclip | 截断指令 |

### 0.7.1特有指令

- **点积指令**: vdotu, vdot
- **扩展乘加**: vwsmaccu, vwsmacc, vwsmaccsu, vwsmaccus
- **截断指令**: vclipb, vclipbu, vcliph, vcliphu, vclipw, vclipwu
- **掩码操作**: vmpopc, vmfirst (1.0中改为vcpop, vfirst)

### 1.0新增指令（0.7.1没有）

- Fault-Only-First加载指令 (vle8ff等)
- vsetvli/vsetivli/vsetvl 配置指令
- vfrec7, vfrsqrt7 近似指令
- 更多浮点转换指令

## 实施步骤

### 步骤1：创建Python生成脚本

创建 `generate_rvv_0.7.1_docs.py`，包含：

1. **指令数据定义**
   - 从inst-table.adoc提取所有指令编码
   - 从listing.adoc提取指令语义描述
   - 定义指令分类和类型

2. **指令分类定义**（参考1.0格式）
   ```python
   CATEGORIES = {
       "configuration": "配置类 (Configuration)",
       "load": "加载类 (Load)",
       "store": "存储类 (Store)",
       "arithmetic": "算术运算类 (Arithmetic)",
       "compare": "比较类 (Compare)",
       "logical": "逻辑类 (Logical)",
       "shift": "移位类 (Shift)",
       "reduction": "归约类 (Reduction)",
       "multiply-add": "乘加类 (Multiply-Add)",
       "fp": "浮点类 (Floating-Point)",
       "convert": "转换类 (Convert)",
       "mask": "掩码类 (Mask)",
       "move": "移动类 (Move)",
       "dot": "点积类 (Dot Product)",
       "clip": "截断类 (Clip)"
   }
   ```

3. **指令类型定义**（参考1.0格式）
   ```python
   OP_TYPES = {
       "000": "OPIVV (vector-vector)",
       "001": "OPFVV (FP vector-vector)",
       "010": "OPMVV (multiply vector-vector)",
       "011": "OPIVI (vector-immediate)",
       "100": "OPIVX (vector-scalar)",
       "101": "OPFVF (FP vector-scalar)",
       "110": "OPMVX (multiply vector-scalar)"
   }
   ```

### 步骤2：提取指令列表

从inst-table.adoc提取指令编码信息：

**整数运算指令 (OPIVV/OPIVX/OPIVI)**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vadd | 000000 | V/X/I | arithmetic | 向量加法 |
| vsub | 000010 | V/X | arithmetic | 向量减法 |
| vrsub | 000011 | X/I | arithmetic | 反向向量减法 |
| vminu | 000100 | V/X | arithmetic | 向量无符号最小值 |
| vmin | 000101 | V/X | arithmetic | 向量有符号最小值 |
| vmaxu | 000110 | V/X | arithmetic | 向量无符号最大值 |
| vmax | 000111 | V/X | arithmetic | 向量有符号最大值 |
| vand | 001001 | V/X/I | logical | 向量按位与 |
| vor | 001010 | V/X/I | logical | 向量按位或 |
| vxor | 001011 | V/X/I | logical | 向量按位异或 |
| vrgather | 001100 | V/X/I | move | 向量聚合收集 |
| vslideup | 001110 | X/I | shift | 向量上移 |
| vslidedown | 001111 | X/I | shift | 向量下移 |
| vadc | 010000 | V/X/I | arithmetic | 向量加法(进位) |
| vmadc | 010001 | V/X/I | arithmetic | 向量加法进位(掩码) |
| vsbc | 010010 | V/X | arithmetic | 向量减法(借位) |
| vmsbc | 010011 | V/X | arithmetic | 向量减法借位(掩码) |
| vmerge/vmv | 010111 | V/X/I | move | 向量合并/移动 |
| vmseq | 011000 | V/X/I | compare | 向量相等比较 |
| vmsne | 011001 | V/X/I | compare | 向量不等比较 |
| vmsltu | 011010 | V/X | compare | 向量无符号小于比较 |
| vmslt | 011011 | V/X | compare | 向量有符号小于比较 |
| vmsleu | 011100 | V/X/I | compare | 向量无符号小于等于比较 |
| vmsle | 011101 | V/X/I | compare | 向量有符号小于等于比较 |
| vmsgtu | 011110 | X/I | compare | 向量无符号大于比较 |
| vmsgt | 011111 | X/I | compare | 向量有符号大于比较 |
| vsaddu | 100000 | V/X/I | arithmetic | 向量饱和无符号加法 |
| vsadd | 100001 | V/X/I | arithmetic | 向量饱和有符号加法 |
| vssubu | 100010 | V/X | arithmetic | 向量饱和无符号减法 |
| vssub | 100011 | V/X | arithmetic | 向量饱和有符号减法 |
| vaadd | 100100 | V/X/I | arithmetic | 向量绝对值加法 |
| vsll | 100101 | V/X/I | shift | 向量逻辑左移 |
| vasub | 100110 | V/X | arithmetic | 向量绝对值减法 |
| vsmul | 100111 | V/X | arithmetic | 向量饱和乘法 |
| vsrl | 101000 | V/X/I | shift | 向量逻辑右移 |
| vsra | 101001 | V/X/I | shift | 向量算术右移 |
| vssrl | 101010 | V/X/I | shift | 向量饱和逻辑右移 |
| vssra | 101011 | V/X/I | shift | 向量饱和算术右移 |
| vnsrl | 101100 | V/X/I | shift | 向量窄逻辑右移 |
| vnsra | 101101 | V/X/I | shift | 向量窄算术右移 |
| vnclipu | 101110 | V/X/I | shift | 向量窄截断无符号右移 |
| vnclip | 101111 | V/X/I | shift | 向量窄截断有符号右移 |

**OPMVV/OPMVX指令**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vdivu | 100000 | V/X | arithmetic | 向量无符号除法 |
| vdiv | 100001 | V/X | arithmetic | 向量有符号除法 |
| vremu | 100010 | V/X | arithmetic | 向量无符号余数 |
| vrem | 100011 | V/X | arithmetic | 向量有符号余数 |
| vmulhu | 100100 | V/X | multiply-add | 向量无符号乘法高位 |
| vmul | 100101 | V/X | multiply-add | 向量乘法 |
| vmulhsu | 100110 | V/X | multiply-add | 向量有符号×无符号乘法高位 |
| vmulh | 100111 | V/X | multiply-add | 向量有符号乘法高位 |
| vmadd | 101001 | V/X | multiply-add | 向量乘法加法 |
| vnmsub | 101011 | V/X | multiply-add | 向量负乘法减法 |
| vmacc | 101101 | V/X | multiply-add | 向量乘法累加 |
| vnmsac | 101111 | V/X | multiply-add | 向量负乘法累减 |
| vwaddu | 110000 | V/X | arithmetic | 向量扩展无符号加法 |
| vwadd | 110001 | V/X | arithmetic | 向量扩展有符号加法 |
| vwsubu | 110010 | V/X | arithmetic | 向量扩展无符号减法 |
| vwsub | 110011 | V/X | arithmetic | 向量扩展有符号减法 |
| vwaddu.w | 110100 | V/X | arithmetic | 向量扩展无符号加法(字) |
| vwadd.w | 110101 | V/X | arithmetic | 向量扩展有符号加法(字) |
| vwsubu.w | 110110 | V/X | arithmetic | 向量扩展无符号减法(字) |
| vwsub.w | 110111 | V/X | arithmetic | 向量扩展有符号减法(字) |
| vwmulu | 111000 | V/X | multiply-add | 向量扩展无符号乘法 |
| vwmulsu | 111010 | V/X | multiply-add | 向量扩展有符号×无符号乘法 |
| vwmul | 111011 | V/X | multiply-add | 向量扩展有符号乘法 |
| vwmaccu | 111100 | V/X | multiply-add | 向量扩展无符号乘加 |
| vwmacc | 111101 | V/X | multiply-add | 向量扩展有符号乘加 |
| vwmaccsu | 111110 | V/X | multiply-add | 向量扩展有符号×无符号乘加 |
| vwmaccus | 111111 | X | multiply-add | 向量扩展无符号×有符号乘加 |

**归约指令**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vredsum | 000000 | V | reduction | 向量求和归约 |
| vredand | 000001 | V | reduction | 向量按位与归约 |
| vredor | 000010 | V | reduction | 向量按位或归约 |
| vredxor | 000011 | V | reduction | 向量按位异或归约 |
| vredminu | 000100 | V | reduction | 向量无符号最小值归约 |
| vredmin | 000101 | V | reduction | 向量有符号最小值归约 |
| vredmaxu | 000110 | V | reduction | 向量无符号最大值归约 |
| vredmax | 000111 | V | reduction | 向量有符号最大值归约 |
| vwredsumu | 110000 | V | reduction | 向量扩展无符号求和归约 |
| vwredsum | 110001 | V | reduction | 向量扩展有符号求和归约 |

**点积指令（0.7.1特有）**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vdotu | 111000 | V | dot | 向量无符号点积 |
| vdot | 111001 | V | dot | 向量有符号点积 |
| vwsmaccu | 111100 | V/X | dot | 向量扩展无符号点积累加 |
| vwsmacc | 111101 | V/X | dot | 向量扩展有符号点积累加 |
| vwsmaccsu | 111110 | V/X | dot | 向量扩展有符号×无符号点积累加 |
| vwsmaccus | 111111 | X | dot | 向量扩展无符号×有符号点积累加 |

**浮点指令 (OPFVV/OPFVF)**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vfadd | 000000 | V/F | fp | 向量浮点加法 |
| vfredsum | 000001 | V | fp | 向量浮点求和归约 |
| vfsub | 000010 | V/F | fp | 向量浮点减法 |
| vfredosum | 000011 | V | fp | 向量浮点有序求和归约 |
| vfmin | 000100 | V/F | fp | 向量浮点最小值 |
| vfredmin | 000101 | V | fp | 向量浮点最小值归约 |
| vfmax | 000110 | V/F | fp | 向量浮点最大值 |
| vfredmax | 000111 | V | fp | 向量浮点最大值归约 |
| vfsgnj | 001000 | V/F | fp | 向量浮点符号注入 |
| vfsgnjn | 001001 | V/F | fp | 向量浮点符号取反注入 |
| vfsgnjx | 001010 | V/F | fp | 向量浮点符号异或注入 |
| vfmv.f.s | 001100 | V | move | 向量到浮点标量移动 |
| vfmv.s.f | 001101 | F | move | 浮点标量到向量移动 |
| vfmerge.vf/vfmv | 010111 | F | move | 向量浮点合并/移动 |
| vmfeq | 011000 | V/F | compare | 向量浮点相等比较 |
| vmfle | 011001 | V/F | compare | 向量浮点小于等于比较 |
| vmford | 011010 | V/F | compare | 向量浮点有序比较 |
| vmflt | 011011 | V/F | compare | 向量浮点小于比较 |
| vmfne | 011100 | V/F | compare | 向量浮点不等比较 |
| vmfgt | 011101 | F | compare | 向量浮点大于比较 |
| vmfge | 011111 | F | compare | 向量浮点大于等于比较 |
| vfdiv | 100000 | V/F | fp | 向量浮点除法 |
| vfrdiv | 100001 | F | fp | 向量浮点反向除法 |
| vfmul | 100100 | V/F | fp | 向量浮点乘法 |
| vfrsub | 100111 | F | fp | 向量浮点反向减法 |
| vfmadd | 101000 | V/F | fp | 向量浮点乘加 |
| vfnmadd | 101001 | V/F | fp | 向量浮点负乘加 |
| vfmsub | 101010 | V/F | fp | 向量浮点乘减 |
| vfnmsub | 101011 | V/F | fp | 向量浮点负乘减 |
| vfmacc | 101100 | V/F | fp | 向量浮点乘累加 |
| vfnmacc | 101101 | V/F | fp | 向量浮点负乘累加 |
| vfmsac | 101110 | V/F | fp | 向量浮点乘累减 |
| vfnmsac | 101111 | V/F | fp | 向量浮点负乘累减 |
| vfwadd | 110000 | V/F | fp | 向量浮点扩展加法 |
| vfwredsum | 110001 | V | fp | 向量浮点扩展求和归约 |
| vfwsub | 110010 | V/F | fp | 向量浮点扩展减法 |
| vfwredosum | 110011 | V | fp | 向量浮点扩展有序求和归约 |
| vfwadd.w | 110100 | V/F | fp | 向量浮点扩展加法(字) |
| vfwsub.w | 110110 | V/F | fp | 向量浮点扩展减法(字) |
| vfwmul | 111000 | V/F | fp | 向量浮点扩展乘法 |
| vfdot | 111001 | V | fp | 向量浮点点积 |
| vfwmacc | 111100 | V/F | fp | 向量浮点扩展乘累加 |
| vfwnmacc | 111101 | V/F | fp | 向量浮点扩展负乘累加 |
| vfwmsac | 111110 | V/F | fp | 向量浮点扩展乘累减 |
| vfwnmsac | 111111 | V/F | fp | 向量浮点扩展负乘累减 |

**浮点转换指令 (VFUNARY0)**
| 指令名 | vs1 | 分类 | 描述 |
|--------|-----|------|------|
| vfcvt.xu.f.v | 00000 | convert | 向量浮点到无符号整数转换 |
| vfcvt.x.f.v | 00001 | convert | 向量浮点到有符号整数转换 |
| vfcvt.f.xu.v | 00010 | convert | 向量无符号整数到浮点转换 |
| vfcvt.f.x.v | 00011 | convert | 向量有符号整数到浮点转换 |
| vfwcvt.xu.f.v | 01000 | convert | 向量浮点到无符号整数扩展转换 |
| vfwcvt.x.f.v | 01001 | convert | 向量浮点到有符号整数扩展转换 |
| vfwcvt.f.xu.v | 01010 | convert | 向量无符号整数到浮点扩展转换 |
| vfwcvt.f.x.v | 01011 | convert | 向量有符号整数到浮点扩展转换 |
| vfwcvt.f.f.v | 01100 | convert | 向量浮点到浮点扩展转换 |
| vfncvt.xu.f.v | 10000 | convert | 向量浮点到无符号整数缩小转换 |
| vfncvt.x.f.v | 10001 | convert | 向量浮点到有符号整数缩小转换 |
| vfncvt.f.xu.v | 10010 | convert | 向量无符号整数到浮点缩小转换 |
| vfncvt.f.x.v | 10011 | convert | 向量有符号整数到浮点缩小转换 |
| vfncvt.f.f.v | 10100 | convert | 向量浮点到浮点缩小转换 |

**浮点单目指令 (VFUNARY1)**
| 指令名 | vs1 | 分类 | 描述 |
|--------|-----|------|------|
| vfsqrt.v | 00000 | fp | 向量浮点平方根 |
| vfclass.v | 10000 | special | 向量浮点分类 |

**掩码操作指令**
| 指令名 | funct6 | vs1 | 分类 | 描述 |
|--------|--------|-----|------|------|
| vmsbf | 010110 | 00001 | mask | 向量掩码设置后置 |
| vmsof | 010110 | 00010 | mask | 向量掩码设置前置 |
| vmsif | 010110 | 00011 | mask | 向量掩码设置索引 |
| viota | 010110 | 10000 | special | 向量IOTA |
| vid | 010110 | 10001 | special | 向量索引生成 |
| vmandnot | 011000 | V | mask | 向量与非掩码 |
| vmand | 011001 | V | mask | 向量与掩码 |
| vmor | 011010 | V | mask | 向量或掩码 |
| vmxor | 011011 | V | mask | 向量异或掩码 |
| vmornot | 011100 | V | mask | 向量或非掩码 |
| vmnand | 011101 | V | mask | 向量与非掩码 |
| vmnor | 011110 | V | mask | 向量或非掩码 |
| vmxnor | 011111 | V | mask | 向量异或非掩码 |
| vmpopc | 010100 | V | mask | 向量掩码位计数 |
| vmfirst | 010101 | V | mask | 向量掩码首位索引 |
| vcompress | 010111 | V | mask | 向量压缩 |

**特殊指令**
| 指令名 | funct6 | funct3 | 分类 | 描述 |
|--------|--------|--------|------|------|
| vext.x.v | 001100 | V | move | 向量到标量提取 |
| vmv.s.x | 001101 | X | move | 标量到向量移动 |
| vslide1up | 001110 | X | shift | 向量上移1位 |
| vslide1down | 001111 | X | shift | 向量下移1位 |

**加载指令**
| 指令名 | 分类 | 描述 |
|--------|------|------|
| vlb | load | 向量加载(8位有符号) |
| vlbu | load | 向量加载(8位无符号) |
| vlh | load | 向量加载(16位有符号) |
| vlhu | load | 向量加载(16位无符号) |
| vlw | load | 向量加载(32位有符号) |
| vlwu | load | 向量加载(32位无符号) |
| vld | load | 向量加载(64位) |
| vflh | load | 向量浮点加载(16位) |
| vflw | load | 向量浮点加载(32位) |
| vfld | load | 向量浮点加载(64位) |
| vlsb/vlsbu/vlsh/vlshu/vlsw/vlswu/vlsd | load | 跨步加载 |
| vflsh/vflsw/vflsd | load | 浮点跨步加载 |
| vlxb/vlxbu/vlxh/vlxhu/vlxw/vlxwu/vlxd | load | 索引加载 |
| vflxh/vflxw/vflxd | load | 浮点索引加载 |
| vlob/vlobu/vloh/vlohu/vlow/vlowu/vlod | load | 单元素加载 |
| vfloh/vflow/vflod | load | 浮点单元素加载 |

**存储指令**
| 指令名 | 分类 | 描述 |
|--------|------|------|
| vsb | store | 向量存储(8位) |
| vsh | store | 向量存储(16位) |
| vsw | store | 向量存储(32位) |
| vsd | store | 向量存储(64位) |
| vssb/vssh/vssw/vssd | store | 跨步存储 |
| vsxb/vsxh/vsxw/vsxd | store | 索引存储 |
| vsob/vsoh/vsow/vsod | store | 单元素存储 |

### 步骤3：生成JSON文件

按照1.0格式生成JSON，包含：
- metadata（版本0.7.1）
- categories（分类统计）
- instruction_types（指令类型定义）
- instructions（完整指令列表）

### 步骤4：生成Excel文件

按照1.0格式生成Excel，包含工作表：
- 分类总览
- 指令总表
- 编码参考
- 各分类详情

### 步骤5：验证输出

- 检查JSON格式正确性
- 检查Excel各工作表内容
- 对比0.7.1和1.0版本差异

## 预估指令数量

- 整数运算指令：约60条
- 浮点指令：约50条
- 加载/存储指令：约60条
- 掩码指令：约15条
- 其他指令：约20条
- **总计：约200+条指令**

## 注意事项

1. 0.7.1版本的指令编码与1.0有差异，需要严格按照inst-table.adoc提取
2. 部分指令在0.7.1和1.0中名称不同，需要保留0.7.1的原始命名
3. 0.7.1特有的指令（如vdotu、vdot、vclip等）需要特别标注
4. 加载/存储指令的命名差异较大，需要仔细区分
