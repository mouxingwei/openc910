# VFMAU模块RVV1.0指令集适配修改计划

## 1. 任务概述

基于RVV1.0指令集和当前VFMAU模块实现，分析差距并制定适配修改计划。

### 1.1 任务目标
使VFMAU模块能够支持RVV1.0标准中规定的所有向量浮点乘累加运算指令。

### 1.2 参考文档
- RISC-V V Vector Extension v1.0 指令集: `riscv-v-spec-master/rvv_instructions.json`
- VFMAU设计文档: `design_docs/vfmau/`
- VFMAU RTL代码: `C910_RTL_FACTORY/gen_rtl _rvv1.0/vfmau/rtl/`

---

## 2. 现状分析

### 2.1 VFMAU模块当前支持的功能

| 特性 | 当前状态 |
|------|----------|
| 流水线深度 | 5级 (EX1→EX2→EX3→EX4→EX5) |
| 支持精度 | 双精度(64bit)、单精度(32bit)、半精度(16bit) |
| SIMD支持 | 支持（半精度4路、单精度2路） |
| FMA运算 | 支持 A×B+C |
| 乘法运算 | 支持 A×B |
| 前递机制 | 支持EX4→EX1, EX5→EX1, EX5→EX2 |
| 特殊值处理 | 支持NaN、无穷大、零、非规格化数 |

### 2.2 VFMAU模块支持的指令类型

从设计文档和RTL分析，当前VFMAU支持：
- `vfmadd` - 浮点乘加
- `vfnmadd` - 浮点负乘加
- `vfmsub` - 浮点乘减
- `vfnmsub` - 浮点负乘减
- `vfmacc` - 浮点乘累加
- `vfnmacc` - 浮点负乘累加
- `vfmsac` - 浮点乘累减
- `vfnmsac` - 浮点负乘累减

### 2.3 RVV1.0 FP指令集覆盖分析

#### 2.3.1 当前完全支持的指令

| 指令类别 | 指令列表 | 支持状态 |
|----------|----------|----------|
| FP FMA | vfmadd, vfnmadd, vfmsub, vfnmsub, vfmacc, vfnmacc, vfmsac, vfnmsac | **已支持** |
| FP 乘法 | vfmul | **已支持** |
| FP 乘加(扩展) | vfwmacc, vfwnmacc, vfwmsac, vfwnmsac | **已支持** |
| FP 乘法(扩展) | vfwmul | **已支持** |

#### 2.3.2 需要复用FMA单元的指令

| 指令 | 实现方式 | 需要的修改 |
|------|----------|------------|
| vfadd | FMA(0, vs1, vs2) | 控制逻辑添加快速路径 |
| vfsub | FMA(0, vs1, -vs2) | 控制逻辑添加快速路径 |
| vfrsub | FMA(0, vs1, -vs2) | 控制逻辑添加快速路径 |
| vfdiv | 迭代算法 | 需使用VFDSU单元 |
| vfrdiv | 迭代算法 | 需使用VFDSU单元 |

#### 2.3.3 缺失的指令功能

| 指令类别 | 指令列表 | 差距分析 |
|----------|----------|----------|
| FP 加减法 | vfadd, vfsub, vfrsub | 缺少专用加减法路径 |
| FP 比较 | vmfeq, vmfle, vmflt, vmfne, vmfgt, vmfge | 需添加比较器 |
| FP 符号注入 | vfsgnj, vfsgnjn, vfsgnjx | 需添加符号操作单元 |
| FP 求最大值/最小值 | vfmax, vfmin | 需添加max/min单元 |
| FP 归约 | vfredusum, vfredosum, vfredmin, vfredmax | 需添加归约树 |
| FP 开方 | vfsqrt.v | 需使用VFDSU单元 |
| FP 近似倒数 | vfrsqrt7.v, vfrec7.v | 需添加查找表/迭代单元 |
| FP 分类 | vfclass.v | 需添加分类逻辑 |
| FP 扩展运算 | vfwadd, vfwsub, vfwadd.w, vfwsub.w | 需扩展数据通路 |
| FP 转换 | vfcvt.*, vfwcvt.*, vfncvt.* | 需使用VFCVT单元 |

---

## 3. 修改计划

### 3.1 第一阶段：控制逻辑增强

#### 3.1.1 添加加减法快速路径
- **修改文件**: `ct_vfmau_ctrl.v`
- **修改内容**:
  - 添加`ctrl_ex1_fadd_mode`信号，标识加减法模式
  - 添加`ctrl_ex1_fadd_sub`信号，标识减法操作
  - 旁路乘法器，直接进行加法操作

#### 3.1.2 添加比较模式支持
- **修改文件**: `ct_vfmau_ctrl.v`
- **修改内容**:
  - 添加`ctrl_ex1_fcmp_mode`信号
  - 添加比较结果选择逻辑

### 3.2 第二阶段：数据通路扩展

#### 3.2.1 扩展EX1阶段操作数预处理
- **修改文件**: `ct_vfmau_dp.v`
- **修改内容**:
  - 添加操作数符号提取和比较逻辑
  - 添加max/min选择器
  - 添加符号注入单元

#### 3.2.2 扩展EX2阶段功能
- **修改文件**: `ct_vfmau_mult1.v`
- **修改内容**:
  - 添加加法器旁路路径
  - 添加比较器模块例化

#### 3.2.3 添加归约树
- **修改文件**: `ct_vfmau_dp.v`, 新建`ct_vfmau_red_tree.v`
- **修改内容**:
  - 添加归约操作控制
  - 实现多级归约树结构

### 3.3 第三阶段：特殊功能单元

#### 3.3.1 添加符号注入单元
- **修改文件**: `ct_vfmau_dp.v`
- **修改内容**:
  - 实例化符号注入模块
  - 支持vfsgnj, vfsgnjn, vfsgnjx指令

#### 3.3.2 添加比较器
- **修改文件**: `ct_vfmau_dp.v`
- **修改内容**:
  - 实例化FP比较器
  - 支持vmfeq, vmfle, vmflt等指令

#### 3.3.3 添加分类逻辑
- **修改文件**: `ct_vfmau_dp.v`
- **修改内容**:
  - 添加FP分类检测逻辑
  - 支持vfclass.v指令

### 3.4 第四阶段：验证与集成

#### 3.4.1 时序收敛
- 确保所有新增逻辑在5级流水线内完成

#### 3.4.2 功能验证
- 添加RVV1.0 FP指令测试用例
- 验证所有指令功能正确性

---

## 4. 修改详细清单

### 4.1 ct_vfmau_ctrl.v 修改

| 序号 | 修改项 | 说明 | 优先级 |
|------|--------|------|--------|
| 1 | 添加fadd模式控制信号 | 支持vfadd/vfsub | High |
| 2 | 添加fcmp模式控制信号 | 支持FP比较指令 | High |
| 3 | 添加fminmax模式控制 | 支持vfmax/vfmin | High |
| 4 | 优化流水线使能逻辑 | 适配新模式 | Medium |

### 4.2 ct_vfmau_dp.v 修改

| 序号 | 修改项 | 说明 | 优先级 |
|------|--------|------|--------|
| 1 | 添加符号注入单元 | 支持vfsgnj系列 | High |
| 2 | 添加FP比较器 | 支持FP比较指令 | High |
| 3 | 添加max/min选择器 | 支持vfmax/vfmin | High |
| 4 | 扩展操作数预处理 | 适配新指令 | High |
| 5 | 添加归约树接口 | 支持FP归约指令 | Medium |

### 4.3 ct_vfmau_mult1.v 修改

| 序号 | 修改项 | 说明 | 优先级 |
|------|--------|------|--------|
| 1 | 添加加法器旁路 | 跳过乘法阶段 | High |
| 2 | 添加比较结果生成 | 支持比较模式 | Medium |

### 4.4 新增模块

| 序号 | 模块名 | 功能 | 优先级 |
|------|--------|------|--------|
| 1 | ct_vfmau_fcmp | FP比较器 | High |
| 2 | ct_vfmau_fsign | FP符号注入 | High |
| 3 | ct_vfmau_red_tree | FP归约树 | Medium |
| 4 | ct_vfmau_fclass | FP分类器 | Medium |

---

## 5. 实施时间表（预估）

| 阶段 | 工作内容 | 优先级 |
|------|----------|--------|
| 第一阶段 | 控制逻辑增强 | High |
| 第二阶段 | 数据通路扩展 | High |
| 第三阶段 | 特殊功能单元 | High |
| 第四阶段 | 验证与集成 | Medium |

---

## 6. 风险评估

| 风险项 | 影响 | 缓解措施 |
|----------|------|----------|
| 时序紧张 | 新增逻辑可能影响关键路径 | 流水化设计 |
| 面积增加 | 新增单元增加芯片面积 | 共享现有硬件 |
| 功能验证 | 新指令需要完整验证 | 添加定向测试用例 |

---

## 7. 后续工作

1. 与VFCVT单元协调，确保转换指令正确路由
2. 与VFDSU单元协调，确保除法/开方指令正确路由
3. 更新IDU译码逻辑，识别新支持的指令
4. 更新指令调度策略，优化流水线利用率
