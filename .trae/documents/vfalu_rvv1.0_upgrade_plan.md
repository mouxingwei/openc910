# VFALU模块RVV 1.0适配修改计划

## 1. 概述

### 1.1 背景
OpenC910处理器需要将VFALU（向量浮点运算单元）模块适配到RVV 1.0指令集标准。本计划详细描述了所需的修改内容。

### 1.2 现有模块结构
```
vfalu/
├── rtl/
│   ├── ct_vfalu_top_pipe6.v      # Pipeline6顶层模块
│   ├── ct_vfalu_top_pipe7.v      # Pipeline7顶层模块
│   ├── ct_vfalu_dp_pipe6.v       # Pipeline6数据通路
│   ├── ct_vfalu_dp_pipe7.v       # Pipeline7数据通路
│   ├── ct_fadd_top.v             # 浮点加法顶层
│   ├── ct_fadd_ctrl.v            # 浮点加法控制
│   ├── ct_fadd_double_dp.v       # 双精度加法数据通路
│   ├── ct_fadd_half_dp.v         # 半精度加法数据通路
│   ├── ct_fadd_single_dp.v       # 单精度加法数据通路
│   ├── ct_fadd_scalar_dp.v       # 标量加法数据通路
│   ├── ct_fspu_top.v             # 浮点特殊功能单元顶层
│   ├── ct_fspu_ctrl.v            # 浮点特殊功能单元控制
│   ├── ct_fspu_dp.v              # 浮点特殊功能单元数据通路
│   ├── ct_fcnvt_top.v            # 浮点转换顶层
│   ├── ct_fcnvt_ctrl.v           # 浮点转换控制
│   ├── ct_fcnvt_double_dp.v      # 双精度转换数据通路
│   └── ct_fcnvt_scalar_dp.v      # 标量转换数据通路
```

### 1.3 RVV 1.0浮点指令集

#### 1.3.1 基本浮点运算指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfadd.vv/vf | 向量浮点加法 | ✓ |
| vfsub.vv/vf | 向量浮点减法 | ✓ |
| vfmul.vv/vf | 向量浮点乘法 | ✓ |
| vfdiv.vv/vf | 向量浮点除法 | ✓ |
| vfrdiv.vf | 向量浮点反向除法 | 需新增 |
| vfrsub.vf | 向量浮点反向减法 | 需新增 |

#### 1.3.2 浮点比较指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vmfeq.vv/vf | 向量浮点相等比较 | ✓ |
| vmfle.vv/vf | 向量浮点小于等于比较 | ✓ |
| vmflt.vv/vf | 向量浮点小于比较 | ✓ |
| vmfne.vv/vf | 向量浮点不等比较 | ✓ |
| vmfgt.vf | 向量浮点大于比较 | 需新增 |
| vmfge.vf | 向量浮点大于等于比较 | 需新增 |

#### 1.3.3 浮点特殊功能指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfsgnj.vv/vf | 向量浮点符号注入 | ✓ |
| vfsgnjn.vv/vf | 向量浮点符号取反注入 | ✓ |
| vfsgnjx.vv/vf | 向量浮点符号异或注入 | ✓ |
| vfmin.vv/vf | 向量浮点最小值 | ✓ |
| vfmax.vv/vf | 向量浮点最大值 | ✓ |
| vfmerge.vf | 向量浮点合并 | 需新增 |
| vfmv.v.f | 向量浮点移动 | 需检查 |

#### 1.3.4 浮点乘加指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfmadd.vv/vf | 向量浮点乘加 | 需检查 |
| vfnmadd.vv/vf | 向量浮点负乘加 | 需检查 |
| vfmsub.vv/vf | 向量浮点乘减 | 需检查 |
| vfnmsub.vv/vf | 向量浮点负乘减 | 需检查 |
| vfmacc.vv/vf | 向量浮点乘累加 | 需新增 |
| vfnmacc.vv/vf | 向量浮点负乘累加 | 需新增 |
| vfmsac.vv/vf | 向量浮点乘累减 | 需新增 |
| vfnmsac.vv/vf | 向量浮点负乘累减 | 需新增 |

#### 1.3.5 浮点归约指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfredusum.vs | 向量浮点无符号求和归约 | 需新增 |
| vfredosum.vs | 向量浮点有序求和归约 | 需新增 |
| vfredmin.vs | 向量浮点最小值归约 | 需新增 |
| vfredmax.vs | 向量浮点最大值归约 | 需新增 |

#### 1.3.6 浮点一元运算指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfsqrt.v | 向量浮点平方根 | 需检查 |
| vfrsqrt7.v | 向量浮点近似平方根倒数 | 需新增 |
| vfrec7.v | 向量浮点近似倒数 | 需新增 |
| vfclass.v | 向量浮点分类 | 需新增 |

#### 1.3.7 浮点转换指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfcvt.xu.f.v | 浮点到无符号整数 | ✓ |
| vfcvt.x.f.v | 浮点到有符号整数 | ✓ |
| vfcvt.f.xu.v | 无符号整数到浮点 | ✓ |
| vfcvt.f.x.v | 有符号整数到浮点 | ✓ |
| vfcvt.rtz.xu.f.v | 浮点到无符号整数截断 | 需新增 |
| vfcvt.rtz.x.f.v | 浮点到有符号整数截断 | 需新增 |

#### 1.3.8 浮点扩展/缩小转换指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfwcvt.xu.f.v | 浮点到无符号整数扩展 | 需新增 |
| vfwcvt.x.f.v | 浮点到有符号整数扩展 | 需新增 |
| vfwcvt.f.xu.v | 无符号整数到浮点扩展 | 需新增 |
| vfwcvt.f.x.v | 有符号整数到浮点扩展 | 需新增 |
| vfwcvt.f.f.v | 浮点到浮点扩展 | 需新增 |
| vfncvt.xu.f.w | 浮点到无符号整数缩小 | 需新增 |
| vfncvt.x.f.w | 浮点到有符号整数缩小 | 需新增 |
| vfncvt.f.xu.w | 无符号整数到浮点缩小 | 需新增 |
| vfncvt.f.x.w | 有符号整数到浮点缩小 | 需新增 |
| vfncvt.f.f.w | 浮点到浮点缩小 | 需新增 |

#### 1.3.9 浮点滑动指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfslide1up.vf | 向量浮点上移1位 | 需新增 |
| vfslide1down.vf | 向量浮点下移1位 | 需新增 |

#### 1.3.10 扩展宽度浮点运算指令
| 指令 | 描述 | 现有支持 |
|------|------|----------|
| vfwadd.vv/vf | 向量浮点扩展加法 | 需新增 |
| vfwsub.vv/vf | 向量浮点扩展减法 | 需新增 |
| vfwadd.w.vv/vf | 向量浮点扩展加法(字) | 需新增 |
| vfwsub.w.vv/vf | 向量浮点扩展减法(字) | 需新增 |
| vfwmul.vv/vf | 向量浮点扩展乘法 | 需新增 |
| vfwmacc.vv/vf | 向量浮点扩展乘累加 | 需新增 |
| vfwnmacc.vv/vf | 向量浮点扩展负乘累加 | 需新增 |
| vfwmsac.vv/vf | 向量浮点扩展乘累减 | 需新增 |
| vfwnmsac.vv/vf | 向量浮点扩展负乘累减 | 需新增 |

## 2. 修改计划

### 2.1 Phase 1: 指令译码修改

#### 2.1.1 IDU模块修改
- **文件**: `gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe3_decd.v`
- **修改内容**:
  - 添加RVV 1.0新增浮点指令的译码逻辑
  - 修改指令功能码（funct3/funct6）解码
  - 添加新指令的操作类型识别

#### 2.1.2 具体新增指令译码
```
新增指令译码列表：
1. vfrdiv.vf    - 反向除法
2. vfrsub.vf    - 反向减法
3. vmfgt.vf     - 大于比较
4. vmfge.vf     - 大于等于比较
5. vfmerge.vf   - 浮点合并
6. vfmacc.vv/vf - 乘累加
7. vfnmacc.vv/vf - 负乘累加
8. vfmsac.vv/vf - 乘累减
9. vfnmsac.vv/vf - 负乘累减
10. vfredusum.vs - 无序求和归约
11. vfredosum.vs - 有序求和归约
12. vfredmin.vs - 最小值归约
13. vfredmax.vs - 最大值归约
14. vfrsqrt7.v  - 近似平方根倒数
15. vfrec7.v    - 近似倒数
16. vfclass.v   - 浮点分类
17. vfcvt.rtz.* - 截断转换
18. vfwcvt.*    - 扩展转换
19. vfncvt.*    - 缩小转换
20. vfslide1up.vf - 上移1位
21. vfslide1down.vf - 下移1位
22. vfwadd/vfwsub - 扩展加减法
23. vfwmul      - 扩展乘法
24. vfwmacc/vfwnmacc/vfwmsac/vfwnmsac - 扩展乘累加/减
```

### 2.2 Phase 2: VFALU控制逻辑修改

#### 2.2.1 ct_fadd_ctrl.v修改
- 添加新操作类型控制信号
- 支持反向操作（vfrsub, vfrdiv）
- 支持扩展精度操作

#### 2.2.2 ct_fspu_ctrl.v修改
- 添加vfclass指令支持
- 添加vfrsqrt7/vfrec7指令支持
- 添加vfmerge指令支持

#### 2.2.3 ct_fcnvt_ctrl.v修改
- 添加rtz（向零截断）舍入模式支持
- 添加扩展/缩小转换控制
- 添加ROD（round-to-odd）舍入模式支持

### 2.3 Phase 3: 数据通路修改

#### 2.3.1 ct_fadd_double_dp.v修改
- 添加反向操作数据通路
- 修改操作数选择逻辑

#### 2.3.2 ct_fspu_dp.v修改
- 添加vfclass分类逻辑
- 添加vfrsqrt7近似平方根倒数逻辑
- 添加vfrec7近似倒数逻辑
- 添加vfmerge合并逻辑

#### 2.3.3 ct_fcnvt_double_dp.v修改
- 添加rtz舍入模式数据通路
- 添加扩展转换数据通路
- 添加缩小转换数据通路

### 2.4 Phase 4: 新增模块

#### 2.4.1 归约运算模块
- **新建文件**: `ct_freduct_top.v`, `ct_freduct_dp.v`
- **功能**: 实现浮点归约操作
  - vfredusum: 无序求和归约
  - vfredosum: 有序求和归约
  - vfredmin: 最小值归约
  - vfredmax: 最大值归约

#### 2.4.2 扩展运算模块
- **新建文件**: `ct_fwiden_top.v`, `ct_fwiden_dp.v`
- **功能**: 实现扩展宽度浮点运算
  - vfwadd/vfwsub: 扩展加减法
  - vfwmul: 扩展乘法
  - vfwmacc/vfwnmacc/vfwmsac/vfwnmsac: 扩展乘累加/减

#### 2.4.3 缩小转换模块
- **新建文件**: `ct_fnarrow_top.v`, `ct_fnarrow_dp.v`
- **功能**: 实现缩小宽度转换
  - vfncvt.*: 各种缩小转换

### 2.5 Phase 5: 顶层模块集成

#### 2.5.1 ct_vfalu_top_pipe6.v修改
- 集成新增的归约运算模块
- 集成新增的扩展运算模块
- 修改模块间信号连接

#### 2.5.2 ct_vfalu_top_pipe7.v修改
- 集成新增的缩小转换模块
- 修改模块间信号连接

#### 2.5.3 ct_vfalu_dp_pipe6.v修改
- 添加新模块的数据通路选择逻辑
- 添加新指令的结果选择逻辑

#### 2.5.4 ct_vfalu_dp_pipe7.v修改
- 添加新模块的数据通路选择逻辑
- 添加新指令的结果选择逻辑

## 3. 详细修改清单

### 3.1 文件修改列表

| 序号 | 文件名 | 修改类型 | 修改内容 |
|------|--------|----------|----------|
| 1 | ct_vfalu_top_pipe6.v | 修改 | 集成新模块，添加信号连接 |
| 2 | ct_vfalu_top_pipe7.v | 修改 | 集成新模块，添加信号连接 |
| 3 | ct_vfalu_dp_pipe6.v | 修改 | 添加数据通路选择逻辑 |
| 4 | ct_vfalu_dp_pipe7.v | 修改 | 添加数据通路选择逻辑 |
| 5 | ct_fadd_ctrl.v | 修改 | 添加新操作控制信号 |
| 6 | ct_fadd_double_dp.v | 修改 | 添加反向操作数据通路 |
| 7 | ct_fadd_half_dp.v | 修改 | 添加反向操作数据通路 |
| 8 | ct_fspu_ctrl.v | 修改 | 添加新指令控制 |
| 9 | ct_fspu_dp.v | 修改 | 添加vfclass/vfrsqrt7/vfrec7逻辑 |
| 10 | ct_fcnvt_ctrl.v | 修改 | 添加rtz/扩展/缩小转换控制 |
| 11 | ct_fcnvt_double_dp.v | 修改 | 添加扩展/缩小转换数据通路 |
| 12 | ct_freduct_top.v | 新建 | 归约运算顶层模块 |
| 13 | ct_freduct_dp.v | 新建 | 归约运算数据通路 |
| 14 | ct_fwiden_top.v | 新建 | 扩展运算顶层模块 |
| 15 | ct_fwiden_dp.v | 新建 | 扩展运算数据通路 |
| 16 | ct_fnarrow_top.v | 新建 | 缩小转换顶层模块 |
| 17 | ct_fnarrow_dp.v | 新建 | 缩小转换数据通路 |

### 3.2 信号修改列表

#### 3.2.1 新增控制信号
| 信号名 | 位宽 | 描述 |
|--------|------|------|
| ex1_op_frdiv | 1 | 反向除法操作 |
| ex1_op_frsub | 1 | 反向减法操作 |
| ex1_op_mfgt | 1 | 大于比较操作 |
| ex1_op_mfge | 1 | 大于等于比较操作 |
| ex1_op_fmerge | 1 | 浮点合并操作 |
| ex1_op_fmacc | 1 | 乘累加操作 |
| ex1_op_fnmacc | 1 | 负乘累加操作 |
| ex1_op_fmsac | 1 | 乘累减操作 |
| ex1_op_fnmsac | 1 | 负乘累减操作 |
| ex1_op_redusum | 1 | 无序求和归约 |
| ex1_op_redosum | 1 | 有序求和归约 |
| ex1_op_redmin | 1 | 最小值归约 |
| ex1_op_redmax | 1 | 最大值归约 |
| ex1_op_frsqrt7 | 1 | 近似平方根倒数 |
| ex1_op_frec7 | 1 | 近似倒数 |
| ex1_op_fclass | 1 | 浮点分类 |
| ex1_op_cvt_rtz | 1 | 截断转换 |
| ex1_op_cvt_widen | 1 | 扩展转换 |
| ex1_op_cvt_narrow | 1 | 缩小转换 |
| ex1_op_slide1up | 1 | 上移1位 |
| ex1_op_slide1down | 1 | 下移1位 |
| ex1_op_fwadd | 1 | 扩展加法 |
| ex1_op_fwsub | 1 | 扩展减法 |
| ex1_op_fwmul | 1 | 扩展乘法 |
| ex1_op_fwmacc | 1 | 扩展乘累加 |

#### 3.2.2 新增数据信号
| 信号名 | 位宽 | 描述 |
|--------|------|------|
| freduct_result | 63:0 | 归约运算结果 |
| fwiden_result | 127:0 | 扩展运算结果 |
| fnarrow_result | 63:0 | 缩小转换结果 |
| fclass_result | 63:0 | 浮点分类结果 |

## 4. 实施步骤

### 4.1 Step 1: 准备工作
1. 创建RVV 1.0指令集参考文档
2. 分析现有VFALU模块架构
3. 确定修改范围和优先级

### 4.2 Step 2: 译码层修改
1. 修改IDU指令译码模块
2. 添加新指令的译码逻辑
3. 验证译码正确性

### 4.3 Step 3: 控制逻辑修改
1. 修改ct_fadd_ctrl.v
2. 修改ct_fspu_ctrl.v
3. 修改ct_fcnvt_ctrl.v
4. 验证控制信号正确性

### 4.4 Step 4: 数据通路修改
1. 修改现有数据通路模块
2. 添加新操作的数据通路
3. 验证数据通路正确性

### 4.5 Step 5: 新增模块实现
1. 实现归约运算模块
2. 实现扩展运算模块
3. 实现缩小转换模块
4. 单元测试各新模块

### 4.6 Step 6: 集成与验证
1. 集成新模块到顶层
2. 修改数据通路选择逻辑
3. 系统级验证

### 4.7 Step 7: 文档更新
1. 更新设计文档
2. 更新验证文档
3. 更新用户手册

## 5. 风险评估

### 5.1 技术风险
| 风险项 | 风险等级 | 缓解措施 |
|--------|----------|----------|
| 归约运算实现复杂 | 高 | 参考标准实现，充分验证 |
| 扩展/缩小转换精度问题 | 中 | 严格遵循IEEE 754标准 |
| 时序收敛困难 | 中 | 优化关键路径，必要时增加流水级 |
| 向后兼容性 | 低 | 保持现有指令行为不变 |

### 5.2 进度风险
| 风险项 | 风险等级 | 缓解措施 |
|--------|----------|----------|
| 新增模块工作量超预期 | 中 | 分阶段实施，优先核心功能 |
| 验证工作量超预期 | 高 | 开发自动化验证脚本 |
| 文档更新滞后 | 低 | 同步更新文档 |

## 6. 验证计划

### 6.1 单元测试
- 每个新增/修改模块需通过单元测试
- 测试覆盖率目标: 95%以上

### 6.2 集成测试
- 所有浮点指令的功能测试
- 边界条件测试
- 异常情况测试

### 6.3 系统测试
- 运行RVV 1.0标准测试套件
- 性能基准测试
- 功耗分析

## 7. 交付物

### 7.1 RTL代码
- 修改后的VFALU模块代码
- 新增模块代码

### 7.2 验证环境
- 单元测试用例
- 集成测试用例
- 验证脚本

### 7.3 文档
- 设计文档更新
- 验证报告
- 用户手册更新

## 8. 时间估算

| 阶段 | 预计时间 |
|------|----------|
| 准备工作 | 1周 |
| 译码层修改 | 1周 |
| 控制逻辑修改 | 1周 |
| 数据通路修改 | 2周 |
| 新增模块实现 | 3周 |
| 集成与验证 | 2周 |
| 文档更新 | 1周 |
| **总计** | **11周** |

## 9. 现有代码分析

### 9.1 IDU译码模块分析

#### 9.1.1 ct_idu_rf_pipe6_decd.v
- 已支持大部分RVV 1.0浮点指令译码
- 已添加VFSLIDE1UP、VFSLIDE1DOWN指令支持
- 已添加VFRSQRT7、VFREC7指令支持
- 需要验证vmfgt、vmfge比较指令译码

#### 9.1.2 ct_idu_rf_pipe7_decd.v
- 主要处理转换类指令
- 需要添加扩展/缩小转换指令译码

### 9.2 VFALU控制模块分析

#### 9.2.1 ct_fadd_ctrl.v
- 流水线控制模块，主要管理pipedown信号
- 通过dp_vfalu_ex1_pipex_sel[1]选择
- 无需大量修改，控制信号在数据通路模块中处理

#### 9.2.2 ct_fspu_ctrl.v
- 通过dp_vfalu_ex1_pipex_sel[0]选择
- 无需大量修改

#### 9.2.3 ct_fcnvt_ctrl.v
- 通过dp_vfalu_ex1_pipex_sel[2]选择
- 无需大量修改

### 9.3 VFALU数据通路模块分析

#### 9.3.1 ct_fadd_double_dp.v
**现有功能**:
- 支持双精度和单精度浮点加/减法
- 支持比较操作 (feq, fle, flt, fne, ford)
- 支持最大/最小值操作 (maxnm, minnm)
- 三级流水线结构 (EX1/EX2/EX3)
- 支持多种舍入模式 (RNE, RTZ, RDN, RUP, RMM)

**需要修改**:
- 添加反向操作支持 (vfrsub: src0和src1交换)
- 添加vmfgt、vmfge比较支持 (可通过交换操作数实现)

**修改建议**:
```verilog
// 在EX1阶段添加操作数交换逻辑
assign ex1_op_swap = ex1_op_frsub || ex1_op_frdiv;
assign ex1_src0_final = ex1_op_swap ? ex1_src1 : ex1_src0;
assign ex1_src1_final = ex1_op_swap ? ex1_src0 : ex1_src1;
```

#### 9.3.2 ct_fspu_dp.v
**现有功能**:
- 支持fsgnj、fsgnjn、fsgnjx操作
- 支持fmv操作 (浮点-整数移动)
- 支持fclass操作 (已实现)
- 支持双精度、单精度、半精度

**需要修改**:
- 添加vfrsqrt7近似平方根倒数逻辑
- 添加vfrec7近似倒数逻辑
- 添加vfmerge合并逻辑

**修改建议**:
```verilog
// 添加vfrsqrt7/vfrec7近似计算
// 使用查找表或多项式近似实现
assign ex1_op_rsqrt7 = func[XX];  // 需要定义功能码
assign ex1_op_rec7   = func[XX];  // 需要定义功能码
assign ex1_op_merge  = func[XX];  // 需要定义功能码

// vfmerge实现
assign ex1_merge_result = mask ? ex1_src0 : ex1_src1;
```

#### 9.3.3 ct_fcnvt_double_dp.v
**现有功能**:
- 支持浮点到整数转换
- 支持整数到浮点转换
- 支持不同精度之间的转换

**需要修改**:
- 添加rtz舍入模式数据通路
- 添加扩展转换 (vfwcvt.*)
- 添加缩小转换 (vfncvt.*)

### 9.4 新增模块设计建议

#### 9.4.1 归约运算模块 (ct_freduct_top.v, ct_freduct_dp.v)
**设计要点**:
- 使用树形结构实现并行归约
- 支持无序求和 (vfredusum) 和有序求和 (vfredosum)
- 支持最小值/最大值归约 (vfredmin/vfredmax)
- 需要处理NaN和特殊值

**建议实现**:
```verilog
module ct_freduct_dp(
  input  [63:0]  src0,          // 向量元素
  input  [63:0]  src1,          // 累加器
  input          op_redusum,    // 无序求和
  input          op_redosum,    // 有序求和
  input          op_redmin,     // 最小值归约
  input          op_redmax,     // 最大值归约
  output [63:0]  result         // 归约结果
);
  // 实现归约操作
endmodule
```

#### 9.4.2 扩展运算模块 (ct_fwiden_top.v, ct_fwiden_dp.v)
**设计要点**:
- 半精度扩展到单精度
- 单精度扩展到双精度
- 扩展加法/减法 (vfwadd/vfwsub)
- 扩展乘法 (vfwmul)
- 扩展乘累加 (vfwmacc等)

**建议实现**:
```verilog
module ct_fwiden_dp(
  input  [63:0]  src0,          // 操作数0 (低位)
  input  [63:0]  src1,          // 操作数1 (高位)
  input          op_fwadd,      // 扩展加法
  input          op_fwsub,      // 扩展减法
  input          op_fwmul,      // 扩展乘法
  output [127:0] result         // 扩展结果
);
  // 实现扩展运算
endmodule
```

#### 9.4.3 缩小转换模块 (ct_fnarrow_top.v, ct_fnarrow_dp.v)
**设计要点**:
- 双精度缩小到单精度
- 单精度缩小到半精度
- 需要处理精度损失和舍入
- 需要处理溢出和下溢

**建议实现**:
```verilog
module ct_fnarrow_dp(
  input  [127:0] src,           // 输入数据 (高位)
  input          op_narrow,     // 缩小转换
  output [63:0]  result         // 缩小结果
);
  // 实现缩小转换
endmodule
```

## 10. 参考资料

1. RISC-V Vector Extension Specification v1.0
2. IEEE 754-2019 Floating-Point Arithmetic Standard
3. OpenC910 Technical Reference Manual
4. 现有VFALU模块设计文档
