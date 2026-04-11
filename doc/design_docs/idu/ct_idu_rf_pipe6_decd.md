# ct_idu_rf_pipe6_decd 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_pipe6_decd |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe6_decd.v |
| 功能描述 | Pipe6流水线向量/浮点指令解码模块 |

### 1.2 功能描述

ct_idu_rf_pipe6_decd 是寄存器重命名阶段Pipe6的向量/浮点指令解码模块，负责：
- 向量指令解码
- 浮点指令解码(FPU/FMA)
- 执行单元选择
- 功能码生成
- 操作数大小识别
- 准备阶段控制

### 1.3 设计特点

- 支持向量ALU指令
- 支持向量乘加(FMA)指令
- 支持向量归约指令
- 支持标量浮点指令
- 支持浮点格式转换(vfcvt)
- 支持向量寄存器掩码操作

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe6_decd_opcode | 32 | 操作码输入 |
| pipe6_decd_vsew | 2 | 向量SEW设置 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe6_decd_eu_sel | 12 | 执行单元选择 |
| pipe6_decd_func | 20 | 功能码 |
| pipe6_decd_imm0 | 3 | 立即数0(舍入模式) |
| pipe6_decd_inst_type | 6 | 指令类型 |
| pipe6_decd_oper_size | 3 | 操作数大小 |
| pipe6_decd_ready_stage | 3 | 准备阶段 |
| pipe6_decd_vimm | 5 | 向量立即数 |
| pipe6_decd_vsew | 2 | 向量SEW |

## 3. 执行单元选择

| EU_SEL值 | 执行单元 | 说明 |
|----------|----------|------|
| 12'h001 | VEC_ALU | 向量ALU |
| 12'h002 | VEC_MUL | 向量乘法 |
| 12'h004 | VEC_DIV | 向量除法 |
| 12'h008 | FPU | 浮点单元 |
| 12'h010 | FMA | 浮点乘加 |
| 12'h020 | MASK | 掩码单元 |

## 4. 指令类型

| INST_TYPE | 类别 |
|-----------|------|
| 6'h01 | 向量算术 |
| 6'h02 | 向量逻辑 |
| 6'h04 | 向量移位 |
| 6'h08 | 向量比较 |
| 6'h10 | 向量归约 |
| 6'h20 | 浮点操作 |

## 5. 操作数大小

| OPER_SIZE | 类型 |
|-----------|------|
| 3'b000 | BYTE |
| 3'b001 | HALF |
| 3'b010 | WORD |
| 3'b011 | DWORD |
| 3'b100 | QWORD |

## 5. RVV相关性分析

### 5.1 向量执行单元映射

本模块是RVV向量指令的核心解码模块，向量执行单元选择映射：

| EU_SEL位 | 执行单元 | RVV指令示例 |
|-----------|----------|-------------|
| [0] | VEC_ALU | vadd.vv, vsub.vv, vmin.vv |
| [1] | VEC_MUL | vmul.vv, vmul.vx |
| [2] | VEC_DIV | vdiv.vv, vrem.vv |
| [3] | FPU | vfadd.vv, vfsub.vv |
| [4] | FMA | vfmadd.vv, vfnmadd.vv |
| [5] | MASK | vmand, vmor, vmxor |

### 5.2 向量指令类型详细映射

| INST_TYPE | 向量指令类别 | 典型指令 |
|-----------|--------------|----------|
| 6'h01 | 向量算术 | vadd, vsub, vmin, vmax |
| 6'h02 | 向量逻辑 | vmand, vmor, vmxor, vmnot |
| 6'h04 | 向量移位 | vsll.vv, vsrl.vv, vsra.vv |
| 6'h08 | 向量比较 | vmslt, vmsle, vmseq |
| 6'h10 | 向量归约 | vredsum, vredmax, vredand |
| 6'h20 | 浮点向量 | vfadd, vfsub, vfdiv |

### 5.3 向量立即数 (vimm)

RVV 1.0支持的向量立即数编码：

| vimm位宽 | 用途 | 示例 |
|----------|------|------|
| 5位 | 向量移位量 | vsll.vi |
| 5位 | 向量掩码生成 | vmseq.vi |
| 5位 | 向量设置 | vmerge |

### 5.4 操作数大小 (oper_size) 与 SEW

| oper_size | SEW | 元素宽度 | 应用场景 |
|-----------|-----|----------|----------|
| 3'b000 | 2'b00 | 8位 | vle8, vse8 |
| 3'b001 | 2'b01 | 16位 | vle16, vse16, vfadd.h |
| 3'b010 | 2'b10 | 32位 | vle32, vse32, vfadd.s |
| 3'b011 | 2'b11 | 64位 | vle64, vse64, vfadd.d |
| 3'b100 | - | 128位 | QWORD操作 |

## 6. RVV 1.0指令集修改点

### 6.1 Pipe6专用RVV指令

RVV 1.0分配给Pipe6的主要向量指令：

| 指令类型 | 指令示例 | EU_SEL | 说明 |
|----------|----------|--------|------|
| 向量乘法 | vmul.vv, vmul.vx | VEC_MUL | 向量乘 |
| 向量乘加 | vmadd.vv, vnmsub.vv | VEC_MUL | 乘加运算 |
| 向量除法 | vdiv.vv, vdiv.vx | VEC_DIV | 向量除法 |
| 向量归约 | vredsum.vs | VEC_ALU | 归约求和 |
| 浮点向量 | vfmadd.vv | FMA | 浮点乘加 |

### 6.2 FMA操作类型 (func扩展)

RVV 1.0定义的乘加操作：

| func[3:0] | 操作 | 说明 |
|------------|------|------|
| 4'b0000 | vmadd | (a*b)+c |
| 4'b0001 | vnmsub | -(a*b)+c |
| 4'b0010 | vmacc | (a*b)+c (累加) |
| 4'b0011 | vnmsac | -(a*b)+c (累减) |
| 4'b0100 | vsadd | 饱和加法 |
| 4'b0101 | vssub | 饱和减法 |

### 6.3 新增向量指令支持

RVV 1.0相比0.7版本在Pipe6的新增支持：

| 指令 | 功能 | 说明 |
|------|------|------|
| vfnmadd | 否定乘加 | -(a*b)+c |
| vfnmsub | 否定乘减 | -a*b+c |
| vfsqrt | 浮点平方根 | 单精度平方根 |
| vfcvt | 浮点转换 | 格式转换 |

### 6.4 舍入模式 (imm0)

| imm0值 | 舍入模式 | 说明 |
|--------|----------|------|
| 3'b000 | RNE | 最近偶数 |
| 3'b001 | RTZ | 置零 |
| 3'b010 | RDN | 向下(向负无穷) |
| 3'b011 | RUP | 向上(向正无穷) |
| 3'b100 | RMM | 最近偶数(数学) |
| 3'b111 | DYN | 动态舍入 |

## 7. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.1 | 2026-04-01 | Auto-generated | 添加RVV相关性分析和1.0修改点 |
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
