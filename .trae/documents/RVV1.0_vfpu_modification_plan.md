# RVV 1.0 VFPU模块修改计划

## 1. 背景与目标

### 1.1 RVV 1.0浮点指令集概述

RVV 1.0共包含**66条浮点指令**，分为**16大类**：

| 类别 | 指令数 | 说明 |
|------|--------|------|
| 算术运算 | 7 | vfadd, vfsub, vfmin, vfmax, vfsgnj* |
| 除法 | 2 | vfdiv, vfrdiv |
| 乘法 | 1 | vfmul |
| 乘加融合 | 8 | vfmadd, vfmsub, vfmacc, vfmsac, vfnmacc, vfnmsac |
| 归约 | 4 | vfredusum, vfredosum, vfredmin, vfredmax |
| 滑动 | 2 | vfslide1up, vfslide1down |
| 合并/移动 | 2 | vfmerge, vfmv.v.f |
| 转换 | 6 | vfcvt.xu.f, vfcvt.x.f, vfcvt.f.xu, vfcvt.f.x, vfcvt.rtz.xu.f, vfcvt.rtz.x.f |
| 宽转换 | 7 | vfwcvt.* (7种) |
| 窄转换 | 8 | vfncvt.* (8种) |
| 平方根 | 1 | vfsqrt.v |
| 倒数 | 2 | vfrsqrt7.v, vfrec7.v |
| 分类 | 1 | vfclass.v |
| 宽算术 | 9 | vfwadd, vfwsub, vfwadd.w, vfwsub.w, vfwmul, vfwmacc, vfwnmacc, vfwmsac, vfwnmsac |
| 宽归约 | 2 | vfwredusum, vfwredosum |
| Mask推移 | 2 | vfredusum, vfredmax (浮点归约) |

### 1.2 当前VFPU模块现状

| 子模块 | 功能 | 当前支持 |
|--------|------|----------|
| ct_vfpu_ctrl | 流水线控制 | Pipe6/Pipe7控制逻辑 |
| ct_vfpu_cbus | 指令完成总线 | 完成判定 |
| ct_vfpu_dp | 数据通路 | 运算器数据路径 |
| ct_vfpu_rbus | 结果总线 | 写回控制 |
| ct_vfalu | 浮点ALU | vfadd, vfsub, vfmin, vfmax, vfsgnj* |
| ct_vfmau | 乘加单元 | vfmul, vfmadd, vfnmadd, vfmsub, vfnmsub |
| ct_vfdsu | 除法/开方 | vfdiv, vfsqrt |

---

## 2. 修改差距分析

### 2.1 宽算术指令扩展 - 高优先级

**RVV 1.0宽算术指令(9条)：**
- `vfwadd.vv`, `vfwadd.vf` - 宽向量加法
- `vfwsub.vv`, `vfwsub.vf` - 宽向量减法
- `vfwadd.w.v`, `vfwadd.wf` - 宽加法(结果加宽)
- `vfwsub.w.v`, `vfwsub.wf` - 宽减法(结果加宽)
- `vfwmul.vv`, `vfwmul.vf` - 宽向量乘法
- `vfwmacc.vv`, `vfwmacc.vf` - 宽乘加
- `vfwnmacc.vv`, `vfwnmacc.vf` - 宽负乘加
- `vfwmsac.vv`, `vfwmsac.vf` - 宽乘减
- `vfwnmsac.vv`, `vfwnmsac.vf` - 宽负乘减

**当前状态：** 无支持

**需要添加：**
| 修改项 | 说明 |
|--------|------|
| VFMAU扩展 | 支持结果加宽的乘加操作 |
| 新运算单元 | 可能需要独立的宽运算单元 |

### 2.2 宽/窄转换指令扩展 - 高优先级

**RVV 1.0转换指令(21条)：**

**窄转换(8条)：**
- `vfncvt.xu.f.w`, `vfncvt.x.f.w` - 浮点到无符号/有符号整数
- `vfncvt.f.xu.w`, `vfncvt.f.x.w` - 无符号/有符号整数到浮点
- `vfncvt.f.f.w` - 浮点到浮点
- `vfncvt.rod.f.f.w` - 舍入到偶数浮点到浮点
- `vfncvt.rtz.xu.f.w`, `vfncvt.rtz.x.f.w` - RTX舍入

**宽转换(7条)：**
- `vfwcvt.xu.f.v`, `vfwcvt.x.f.v` - 浮点到整数
- `vfwcvt.f.xu.v`, `vfwcvt.f.x.v` - 整数到浮点
- `vfwcvt.f.f.v` - 浮点到浮点
- `vfwcvt.rtz.xu.f.v`, `vfwcvt.rtz.x.f.v` - RTX舍入

**当前状态：** 部分支持(vfcvt.*)

**需要添加：**
| 修改项 | 说明 |
|--------|------|
| vfwcvt扩展 | 支持更多宽转换格式组合 |
| vfncvt扩展 | 支持所有窄转换变体 |
| RTZ舍入 | 独立于正常舍入模式的RTX处理 |

### 2.3 归约指令扩展 - 高优先级

**RVV 1.0浮点归约指令(6条)：**
- `vfredusum.vv` - 浮点归约求和
- `vfredosum.vv` - 浮点归约按位或和
- `vfredmin.vv` - 浮点归约最小值
- `vfredmax.vv` - 浮点归约最大值
- `vfwredusum.vv` - 宽浮点归约求和
- `vfwredosum.vv` - 宽浮点归约按位或和

**当前状态：** pipe7可能支持部分

**需要添加：**
| 修改项 | 说明 |
|--------|------|
| 浮点归约单元 | 独立的归约运算路径 |
| Pipe6/Pipe7分工 | vfred* → Pipe6; vfwred* → Pipe7 |

### 2.4 特殊浮点指令 - 中优先级

**RVV 1.0特殊浮点指令(4条)：**
- `vfrsqrt7.v` - 近似平方根倒数
- `vfrec7.v` - 近似倒数
- `vfclass.v` - 浮点分类
- `vfslide1up.v`, `vfslide1down.v` - 滑动操作

**当前状态：** 无支持

**需要添加：**
| 修改项 | 说明 |
|--------|------|
| vfrsqrt7 | Newton-Raphson迭代近似 |
| vfrec7 | Newton-Raphson迭代近似 |
| vfclass | 分类逻辑提取指数/尾数/符号 |
| vfslide | 寄存器滑动移位 |

### 2.5 融合乘加指令扩展 - 中优先级

**当前状态：** 已支持vfmadd, vfmsub, vfnmadd, vfnmsub

**需要添加：**
| 修改项 | 说明 |
|--------|------|
| vfmacc | 融合乘加(无需取反) |
| vfnmacc | 融合负乘加 |
| vfmsac | 融合乘减 |
| vfnmsac | 融合负乘减 |

---

## 3. 修改计划

### 3.1 第一阶段：宽算术指令支持

**目标：** 支持所有RVV 1.0宽算术指令

**修改模块：**
- `ct_vfpu_dp.v`
- `ct_vfmau_top_pipe6.v`
- `ct_vfmau_top_pipe7.v`

**具体任务：**
1. 扩展VFMAU支持结果加宽
   ```verilog
   // vfwadd: 输入SEW, 输出2*SEW
   // vfwmul: 输入SEW, 输出2*SEW
   // vfwmacc: 乘加结果加宽
   ```

2. 添加新的功能码
   ```verilog
   VFWMADD  = 20'bxxxx_xxxx_xxxx_xxxx_xxxx;
   VFWNMACC = 20'bxxxx_xxxx_xxxx_xxxx_xxxx;
   VFWMSAC  = 20'bxxxx_xxxx_xxxx_xxxx_xxxx;
   VFWMSAC  = 20'bxxxx_xxxx_xxxx_xxxx_xxxx;
   ```

**工作量：** 大

### 3.2 第二阶段：转换指令扩展

**目标：** 支持所有RVV 1.0宽/窄转换指令

**修改模块：**
- `ct_vfalu_top_pipe6.v`
- `ct_vfalu_top_pipe7.v`

**具体任务：**
1. 添加vfwcvt指令支持
   - vfwcvt.f.f.v (FP widening)
   - vfwcvt.xu.f.v, vfwcvt.x.f.v (to integer)
   - vfwcvt.f.xu.v, vfwcvt.f.x.v (from integer)
   - vfwcvt.rtz.* (RTX rounding)

2. 添加vfncvt指令支持
   - vfncvt.f.f.w (FP narrowing)
   - vfncvt.xu.f.w, vfncvt.x.f.w (to integer)
   - vfncvt.f.xu.w, vfncvt.f.x.w (from integer)
   - vfncvt.rod.f.f.w (round-to-odd)
   - vfncvt.rtz.* (RTX rounding)

**工作量：** 大

### 3.3 第三阶段：归约指令支持

**目标：** 支持所有RVV 1.0浮点归约指令

**修改模块：**
- `ct_vfpu_dp.v`
- `ct_vfalu_top_pipe6.v` 或 `ct_vfalu_top_pipe7.v`

**具体任务：**
1. 添加浮点归约运算单元
   ```verilog
   VREDUSUM  = 归约加法树
   VREDOSUM  = 归约按位或和
   VREDMIN   = 归约最小值
   VREDMAX   = 归约最大值
   ```

2. 扩展Pipe6/Pipe7分工
   - vfred* → Pipe6或Pipe7
   - vfwred* → Pipe7

**工作量：** 中

### 3.4 第四阶段：特殊浮点指令

**目标：** 支持近似倒数/平方根倒数和分类指令

**修改模块：**
- `ct_vfdsu_top.v` (可能需要扩展)
- `ct_vfalu_top_pipe6.v` 或 `ct_vfalu_top_pipe7.v`

**具体任务：**
1. 添加vfrsqrt7和vfrec7
   - 使用Newton-Raphson迭代
   - 7位精度近似

2. 添加vfclass
   - 提取Sign/Exponent/Mantissa
   - IEEE 754分类

3. 添加vfslide1up/vfslide1down
   - 寄存器元素滑动

**工作量：** 中

### 3.5 第五阶段：乘加指令完善

**目标：** 支持所有RVV 1.0乘加变体

**修改模块：**
- `ct_vfmau_top_pipe6.v`
- `ct_vfmau_top_pipe7.v`

**具体任务：**
1. 添加vfmacc/vfnmacc
   - 无需符号取反的乘加

2. 添加vfmsac/vfnmsac
   - 乘减变体

**工作量：** 小

---

## 4. 修改清单汇总

### 4.1 ct_vfpu_dp.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 扩展数据通路宽度 | 高 | 支持2*SEW输出 |
| 2 | 添加宽运算旁路 | 高 | vfw* 结果前推 |

### 4.2 ct_vfmau_top_pipe6.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加vfwmacc | 高 | 宽乘加 |
| 2 | 添加vfwnmacc | 高 | 宽负乘加 |
| 3 | 添加vfwmsac | 高 | 宽乘减 |
| 4 | 添加vfwnmsac | 高 | 宽负乘减 |
| 5 | 扩展vfwmul | 高 | 宽乘法 |

### 4.3 ct_vfmau_top_pipe7.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加vfwadd | 高 | 宽加法 |
| 2 | 添加vfwsub | 高 | 宽减法 |
| 3 | 添加vfwadd.w | 高 | 宽加法(结果加宽) |
| 4 | 添加vfwsub.w | 高 | 宽减法(结果加宽) |

### 4.4 ct_vfalu_top_pipe6.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加vfwcvt | 高 | 宽转换 |
| 2 | 添加vfncvt | 高 | 窄转换 |
| 3 | 添加vfrsqrt7 | 中 | 近似平方根倒数 |
| 4 | 添加vfrec7 | 中 | 近似倒数 |

### 4.5 ct_vfalu_top_pipe7.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加vfred* | 高 | 浮点归约 |
| 2 | 添加vfclass | 中 | 浮点分类 |
| 3 | 添加vfslide | 中 | 滑动操作 |

### 4.6 ct_vfdsu_top.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 扩展vfsqrt | 高 | 支持vfwsqrt |
| 2 | 添加vfrsqrt7 | 中 | 近似平方根倒数 |

---

## 5. 实施时间估算

| 阶段 | 模块 | 任务点 | 复杂度 |
|------|------|--------|--------|
| 1 | pipe6/7 VFMAU | 5项 | 大 |
| 2 | pipe6/7 VFALU | 8项 | 大 |
| 3 | VFALU pipe7 | 4项 | 中 |
| 4 | VFALU/VFDSU | 4项 | 中 |
| 5 | VFMAU | 4项 | 小 |

**总复杂度：** 大

---

## 6. 验证计划

### 6.1 功能验证
1. 使用RVV 1.0浮点合规性测试套件
2. 随机浮点向量指令生成测试
3. 精度验证(与参考模型对比)

### 6.2 兼容性验证
1. 与RVV 0.7代码的向后兼容
2. 现有测试用例回归通过

### 6.3 数值精度验证
1. vfrsqrt7/vfrec7精度测试
2. 宽运算溢出检测
3. NaN/Inf特殊值处理

---

## 7. 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| 宽运算数据通路扩展 | 高 | 预留足够位宽，使用参数化设计 |
| 乘加器资源增加 | 中 | 复用现有乘法器，增加加法器 |
| 转换精度 | 高 | 严格遵循IEEE 754舍入模式 |
| 时序收敛 | 中 | 流水线切割，预留stage |

---

## 8. 参考资料

- RISC-V Vector Extension Specification v1.0
- RVV指令集规格: `riscv-v-spec-master/rvv_instructions.json`
- VFPU模块文档: `doc/design_docs/vfpu/`
