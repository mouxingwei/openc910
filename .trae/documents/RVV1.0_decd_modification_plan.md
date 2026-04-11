# RVV 1.0 Decd模块修改计划

## 1. 背景与目标

### 1.1 RVV 1.0指令集概述

RVV 1.0共包含**359条指令**，分为**15大类**：

| 类别 | 指令数 | 说明 |
|------|--------|------|
| 算术运算 (Arithmetic) | 69 | vadd, vsub, vmin, vmax等 |
| 逻辑 (Logical) | 9 | vand, vor, vxor等 |
| 移动 (Move) | 21 | vmv.s.x, vmv.x.s等 |
| 移位 (Shift) | 33 | vsll, vsrl, vsra等 |
| 比较 (Compare) | 30 | vmslt, vmsle, vmseq等 |
| 归约 (Reduction) | 10 | vredsum, vredand等 |
| 乘加 (Multiply-Add) | 29 | vmadd, vnmsub, vmacc等 |
| 掩码 (Mask) | 12 | vmand, vmor, vmxor等 |
| 浮点 (Floating-Point) | 66 | vfadd, vfsub等 |
| 转换 (Convert) | 21 | vfcvt.xu.f等 |
| 特殊 (Special) | 5 | vcpop, vfirst等 |
| 加载 (Load) | 24 | vle, vluxei, vlse等 |
| 存储 (Store) | 20 | vse, vsuxei, vsse等 |
| 配置 (Configuration) | 3 | vsetvli, vsetivli, vsetvl |
| 原子 (Atomic) | 7 | vamo*等 |

### 1.2 当前decd模块现状

| 模块 | 当前支持 | 流水线 |
|------|----------|--------|
| ct_idu_id_decd | 向量寄存器解码、vsew/vlmul | ID阶段 |
| ct_idu_ir_decd | 向量指令识别(vsetvl/vli/ivli) | IR阶段 |
| ct_idu_rf_pipe3_decd | 向量加载(含FOF) | Pipe3 |
| ct_idu_rf_pipe4_decd | 向量存储 | Pipe4 |
| ct_idu_rf_pipe6_decd | 向量乘加/除法/FMA | Pipe6 |
| ct_idu_rf_pipe7_decd | 向量ALU/比较/移位 | Pipe7 |

---

## 2. 修改差距分析

### 2.1 配置类指令 (Configuration) - 高优先级

**RVV 1.0配置指令：**
- `vsetvli rd, rs1, vtypei` - 从寄存器设置vl
- `vsetivli rd, uimm, vtypei` - 从立即数设置vl (高立即数)
- `vsetvl rd, rs1, rs2` - 架构寄存器形式

**当前状态：** ct_idu_ir_decd已识别x_vsetvl/vli/ivli信号

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| vtypei编码解析 | 从立即数提取SEW/LMUL/Sewl |
| vill位处理 | vill=1表示非法vtype |
| vlmax计算 | 根据vtype计算vlmax |
| vill信号输出 | 新增x_vill信号 |

### 2.2 归约类指令 (Reduction) - 高优先级

**RVV 1.0归约指令：**
- vredsum, vredand, vredor, vredxor
- vredminu, vredmin, vredmaxu, vredmax
- vfredusum, vfredosum (浮点)

**当前状态：** 归约指令可能混在arithmetic类型中

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| 独立归约类型 | x_reduction信号，新增6'h10类型 |
| Pipe6/Pipe7分工 | vred* → Pipe6; vf.red* → Pipe7 |
| 归约操作数顺序 | vd=vs1, vs2=源向量 |

### 2.3 加载/存储指令扩展 - 高优先级

**RVV 1.0加载指令(24条)：**
- 单位步长: vle8, vle16, vle32, vle64, vle1ff
- 索引: vluxei8, vluxei16, vluxei32, vluxei64
- 步长: vlse8, vlse16, vlse32, vlse64
- 分段: vlm, vsm (mask)

**RVV 1.0存储指令(20条)：**
- 单位步长: vse8, vse16, vse32, vse64
- 索引: vsuxei8, vsuxei16, vsuxei32, vsuxei64
- 步长: vsse8, vsse16, vsse32, vsse64
- 分段: vsm (mask)

**当前状态：** ct_idu_rf_pipe3_decd支持vle.v, ct_idu_rf_pipe4_decd支持vse.v

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| 索引加载/存储解码 | 新增x_indexed_load/store类型 |
| 步长加载/存储解码 | 新增x_stride_load/store类型 |
| 分段加载/存储解码 | 新增x_segment_load/store类型 |
| 元素宽度SEW识别 | vle8-vle64的SEW字段 |

### 2.4 乘加类指令扩展 - 中优先级

**RVV 1.0乘加指令(29条)包含：**
- vmadd, vnmsub, vmacc, vnmsac
- vsaddu, vsadd, vssubu, vssub (饱和运算)
- vmv, vmvt (向量移动)

**当前状态：** Pipe6已有x_vmla_type信号

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| 饱和运算识别 | vsadd/vssub的saturation标志 |
| 向量移动指令 | vmv.v.v, vmv.v.x的decoding |
| 扩展乘加 | vmadc, vmadc.vi (进位加法) |

### 2.5 掩码指令扩展 - 中优先级

**RVV 1.0掩码指令(12条)：**
- vmand, vmandn, vmor, vmxor, vmorn, vmxnor
- vmcpy, vmclr, vmset, vminv, vmmv
- vpopc, vfirst

**当前状态：** 有x_vmb信号

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| 独立掩码指令类型 | x_mask_inst类型 |
| vpopc/vfirst | 计数/索引操作 |
| 掩码逻辑扩展 | vmandn, vmorn, vmxnor |

### 2.6 特殊功能指令 - 低优先级

**RVV 1.0特殊指令(5条)：**
- vcpop - 掩码位计数
- vfirst - 首个置位索引
- vmsbf - 掩码设置ifirst
- vmsif - 掩码设置ifirst
- vmsof - 掩码设置onlyfirst

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| vcpop/vfirst | 需要特殊执行单元 |
| 掩码生成扩展 | vmsbf, vmsif, vmsof |

### 2.7 转换指令扩展 - 低优先级

**RVV 1.0转换指令(21条)：**
- vfcvt.xu.f, vfcvt.x.f - 浮点到整数
- vfcvt.f.xu, vfcvt.f.x - 整数到浮点
- vfcvt.rtz.xu.f, vfcvt.rtz.x.f - RTX舍入

**需要补充：**
| 修改项 | 说明 |
|--------|------|
| 浮点转换类型 | x_fcvt_inst类型 |
| RTX舍入模式 | 独立于正常舍入模式 |

---

## 3. 修改计划

### 3.1 第一阶段：配置指令完善

**目标：** 完善vset*指令的完整支持

**修改模块：**
- `ct_idu_ir_decd.v`

**具体任务：**
1. 添加vtypei编码解析逻辑
   - 从vtypei[6:0]提取LMUL、Sewl等字段
   - 计算vlmax值

2. 添加vill位处理
   - vill=1时表示非法vtype
   - 输出x_vill信号

3. 添加vset*指令与CP0寄存器的交互
   - 更新vl, vtype寄存器

**工作量：** 中等

### 3.2 第二阶段：归约指令支持

**目标：** 添加独立归约指令类型

**修改模块：**
- `ct_idu_ir_decd.v`
- `ct_idu_rf_pipe6_decd.v` 或 `ct_idu_rf_pipe7_decd.v`

**具体任务：**
1. 在ct_idu_ir_decd中添加：
   ```verilog
   x_reduction        // 归约指令标志
   x_vfred*           // 浮点归约
   ```

2. 在decd模块中添加归约专用类型：
   ```verilog
   6'h10: x_reduction  // 归约指令
   ```

3. 分配Pipe6处理整数归约(vred*)
4. 分配Pipe7处理浮点归约(vfred*)

**工作量：** 中等

### 3.3 第三阶段：加载/存储扩展

**目标：** 支持所有RVV 1.0加载存储变体

**修改模块：**
- `ct_idu_rf_pipe3_decd.v`
- `ct_idu_rf_pipe4_decd.v`

**具体任务：**

**Pipe3 (加载)：**
1. 添加索引加载识别
   ```verilog
   x_indexed_load     // vluxei*
   ```

2. 添加步长加载识别
   ```verilog
   x_stride_load       // vlse*
   ```

3. 添加FOF完整支持
   - vle1ff指令的fault-only-first行为

**Pipe4 (存储)：**
1. 添加索引存储识别
   ```verilog
   x_indexed_store    // vsuxei*
   ```

2. 添加步长存储识别
   ```verilog
   x_stride_store      // vsse*
   ```

**工作量：** 较大

### 3.4 第四阶段：乘加指令完善

**目标：** 支持饱和运算和更多乘加变体

**修改模块：**
- `ct_idu_rf_pipe6_decd.v`

**具体任务：**
1. 添加饱和运算标志
   ```verilog
   x_saturation       // vsadd/vssub的saturation标志
   ```

2. 添加向量移动指令识别
   ```verilog
   x_vmv              // vmv.v.v, vmv.v.x
   ```

3. 扩展x_vmla_type编码

**工作量：** 小

### 3.5 第五阶段：掩码指令完善

**目标：** 完整支持12条掩码指令

**修改模块：**
- `ct_idu_rf_pipe7_decd.v`

**具体任务：**
1. 添加掩码指令独立类型
   ```verilog
   6'h20: x_mask       // 掩码指令
   ```

2. 添加vpopc/vfirst支持
   ```verilog
   x_vpopc            // 掩码位计数
   x_vfirst           // 首个置位索引
   ```

3. 添加掩码逻辑扩展指令
   ```verilog
   x_vmandn, x_vmor, x_vmxnor  // 扩展掩码逻辑
   ```

**工作量：** 中等

---

## 4. 修改清单汇总

### 4.1 ct_idu_ir_decd.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加x_vill信号 | 高 | vill位处理 |
| 2 | 添加x_reduction信号 | 高 | 归约指令标志 |
| 3 | 添加vtypei解析 | 高 | 配置指令解析 |
| 4 | 扩展vset*识别 | 高 | vsetivli完整支持 |

### 4.2 ct_idu_rf_pipe3_decd.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加索引加载识别 | 高 | vluxei* |
| 2 | 添加步长加载识别 | 高 | vlse* |
| 3 | 完善FOF机制 | 高 | vle1ff完整支持 |
| 4 | 扩展SEW处理 | 中 | 支持vle8-vle64 |

### 4.3 ct_idu_rf_pipe4_decd.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加索引存储识别 | 高 | vsuxei* |
| 2 | 添加步长存储识别 | 高 | vsse* |
| 3 | 扩展SEW处理 | 中 | 支持vse8-vse64 |

### 4.4 ct_idu_rf_pipe6_decd.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加x_saturation信号 | 中 | 饱和运算 |
| 2 | 添加x_vmv信号 | 中 | 向量移动 |
| 3 | 整数归约支持 | 高 | vredsum等 |

### 4.5 ct_idu_rf_pipe7_decd.v

| 序号 | 修改项 | 优先级 | 说明 |
|------|--------|--------|------|
| 1 | 添加x_mask独立类型 | 中 | 掩码指令 |
| 2 | 添加x_vpopc/vfirst | 中 | 计数/索引 |
| 3 | 添加扩展掩码逻辑 | 低 | vmandn等 |

---

## 5. 实施时间估算

| 阶段 | 模块 | 任务点 | 复杂度 |
|------|------|--------|--------|
| 1 | ct_idu_ir_decd | 4项 | 中 |
| 2 | ct_idu_ir_decd + pipe6/7 | 3项 | 中 |
| 3 | pipe3 + pipe4 | 6项 | 大 |
| 4 | pipe6 | 3项 | 小 |
| 5 | pipe7 | 3项 | 中 |

**总复杂度：** 大

---

## 6. 验证计划

### 6.1 功能验证
1. 使用RVV 1.0合规性测试套件
2. 随机向量指令生成测试
3. 边界条件测试(vl=0, vl=vlmax等)

### 6.2 兼容性验证
1. 与RVV 0.7代码的向后兼容
2. 现有测试用例回归通过

### 6.3 性能验证
1. 流水线利用率测试
2. 向量单元吞吐率测试

---

## 7. 风险与应对

| 风险 | 影响 | 应对措施 |
|------|------|----------|
| 指令编码冲突 | 高 | 严格遵循RVV 1.0编码规范 |
| 流水线冲突 | 中 | 合理分配Pipe6/Pipe7 |
| 时序收敛 | 中 | 预留足够的pipeline stage |
| 验证覆盖不全 | 高 | 使用形式化验证补充 |
