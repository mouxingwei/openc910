# RVV0.7.1 升级到 RVV1.0 执行单元需求分析计划

## 1. 任务目标

分析从RVV0.7.1升级到RVV1.0是否需要新增以下执行单元：
- **VREDU**: 向量归约单元 (vredsum, vredmax, vredmin, vredand, vredor, vredxor)
- **VPERM**: 向量置换单元 (vrgather, vslideup, vslidedown, vrgatherei16)
- **VMISC**: 向量杂项单元 (vand, vor, vxor, vmand, vmor, vmxor等掩码操作)

## 2. 分析范围

### 2.1 源文档
- `d:\code\openc910\doc\Instruction_Set\riscv-v-spec-v1.0-extracted.json` - RVV1.0指令集规格

### 2.2 RTL代码
- `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\idu\rtl\ct_idu_rf_pipe6_decd.v` - 向量指令译码
- `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\vfpu\rtl\ct_vfpu_ctrl.v` - VFPU控制逻辑
- `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\vfalu\rtl\` - VFALU实现
- `d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\vfmau\rtl\` - VFMAU实现

## 3. 分析步骤

### 3.1 第一步：指令覆盖分析

#### 3.1.1 VREDU 归约指令分析

| 指令 | funct6 | funct3 | 当前EU | 是否已支持 |
|------|--------|--------|--------|------------|
| vredsum.vv | 000000 | 001 | ? | 待确认 |
| vredand.vv | 000001 | 001 | ? | 待确认 |
| vredor.vv | 000010 | 001 | ? | 待确认 |
| vredxor.vv | 000011 | 001 | ? | 待确认 |
| vredminu.vv | 000100 | 001 | ? | 待确认 |
| vredmin.vv | 000101 | 001 | ? | 待确认 |
| vredmaxu.vv | 000110 | 001 | ? | 待确认 |
| vredmax.vv | 000111 | 001 | ? | 待确认 |

#### 3.1.2 VPERM 置换指令分析

| 指令 | funct6 | funct3 | 当前EU | 是否已支持 |
|------|--------|--------|--------|------------|
| vrgather.vv | 001100 | 000 | ? | 待确认 |
| vrgather.vx | 001100 | 100 | ? | 待确认 |
| vrgather.vi | 001100 | 011 | ? | 待确认 |
| vrgatherei16.vv | 001110 | 000 | ? | 待确认 |
| vslideup.vx | 001111 | 100 | ? | 待确认 |
| vslideup.vi | 001111 | 011 | ? | 待确认 |
| vslidedown.vx | 010000 | 100 | ? | 待确认 |
| vslidedown.vi | 010000 | 011 | ? | 待确认 |

#### 3.1.3 VMISC 杂项指令分析

| 指令 | funct6 | funct3 | 当前EU | 是否已支持 |
|------|--------|--------|--------|------------|
| vand.vv | 001001 | 000 | ? | 待确认 |
| vand.vx | 001001 | 100 | ? | 待确认 |
| vand.vi | 001001 | 011 | ? | 待确认 |
| vor.vv | 001010 | 000 | ? | 待确认 |
| vxor.vv | 001011 | 000 | ? | 待确认 |
| vmand | 011001 | 001 | ? | 待确认 |
| vmor | 011010 | 001 | ? | 待确认 |
| vmxor | 011011 | 001 | ? | 待确认 |

### 3.2 第二步：现有EU实现分析

#### 3.2.1 检查VFALU模块
- 分析`ct_vfalu_top.v`是否已实现归约、置换、杂项功能
- 检查是否有相关信号和控制逻辑

#### 3.2.2 检查VFPU顶层
- 分析`ct_vfpu_top.v`的模块实例化关系
- 确认是否有独立的VREDU/VPERM/VMISC模块

#### 3.2.3 检查执行单元选择
- 分析`pipe6_eu_sel`信号的生成逻辑
- 确认VREDU/VPERM/VMISC选择信号的用途

### 3.3 第三步：差异分析

#### 3.3.1 RVV0.7.1 vs RVV1.0 差异
- 比较RVV0.7.1和RVV1.0指令集
- 识别新增指令
- 评估对硬件的影响

#### 3.3.2 当前实现 vs RVV1.0需求
- 当前实现是否满足RVV1.0要求
- 是否需要新增硬件模块

## 4. 预期产出

### 4.1 分析报告
- VREDU/VPERM/VMISC指令覆盖情况表
- 当前EU实现状态
- 差距分析

### 4.2 决策建议
- 是否需要新增执行单元
- 如果需要，推荐的实现方案

### 4.3 修改计划（如需）
- 新增模块清单
- 现有模块修改清单
- 验证计划

## 5. 后续步骤（根据分析结果）

### 5.1 如果不需要新增EU
- 确认现有EU的正确实现
- 添加缺失指令的解码和执行支持

### 5.2 如果需要新增EU
- 创建VREDU模块（归约运算）
- 创建VPERM模块（置换操作）
- 创建VMISC模块（杂项操作）
- 更新IDU译码逻辑
- 更新VFPU顶层连接
