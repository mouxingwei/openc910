# LSU模块RVV 1.0升级计划

## 文档信息
- **文档版本**: 1.0
- **创建日期**: 2026-04-12
- **目标**: 分析RVV 0.7.1升级到RVV 1.0时LSU模块需要修改的点
- **参考文档**: 
  - RISC-V向量扩展v0.7.1与v1.0差异分析.md
  - riscv-v-spec-v1.0-extracted.json

---

## 1. 概述

### 1.1 LSU模块当前状态

LSU (Load Store Unit) 模块是OpenC910处理器的加载存储单元，负责处理所有加载和存储操作。当前LSU模块对向量扩展的支持包括：

- **向量加载指令支持**: 通过Pipe3流水线处理（AG → DC → DA → WB）
- **向量存储指令支持**: 通过Pipe4/Pipe5流水线处理
- **vstart支持**: 已有cp0_lsu_vstart输入信号（7位）
- **vsew支持**: 已有idu_lsu_vmb_create0_vsew/idu_lsu_vmb_create1_vsew信号（2位）
- **向量存储Buffer (VMB)**: 用于向量存储操作

### 1.2 RVV 1.0关键变化对LSU的影响

| 变化项 | 影响程度 | LSU相关模块 |
|--------|---------|------------|
| Fault-Only-First加载指令 | 高 | ld_ag, ld_dc, ld_da, ld_wb |
| 全寄存器加载/存储指令 | 高 | ld_ag, st_ag, 新增控制逻辑 |
| vstart精确异常支持 | 高 | ld_dc, ld_da, st_dc, st_da |
| vlmul扩展到3位 | 中 | 所有向量相关模块 |
| vma/vta字段 | 中 | ld_wb, st_wb |
| 指令编码变化 | 高 | IDU解码模块（不在LSU内） |

---

## 2. 详细修改计划

### 2.1 Fault-Only-First加载指令支持

#### 2.1.1 功能描述

RVV 1.0新增Fault-Only-First加载指令：
- `vle8ff.v` - 8位单位步长fault-only-first加载
- `vle16ff.v` - 16位单位步长fault-only-first加载
- `vle32ff.v` - 32位单位步长fault-only-first加载
- `vle64ff.v` - 64位单位步长fault-only-first加载

**关键特性**：
- 只在元素0上触发同步异常陷阱
- 如果元素>0触发异常，不产生陷阱，而是将vl减少到触发异常的元素索引
- 用于向量化数据依赖退出条件的循环（while循环）

#### 2.1.2 修改点

**文件: ct_lsu_ld_ag.v**
```verilog
// 新增信号
output          ld_ag_inst_vleff;        // fault-only-first加载指令标识

// 修改逻辑
assign ld_ag_inst_vleff = ...; // 根据指令解码结果设置
```

**文件: ct_lsu_ld_dc.v**
```verilog
// 新增信号
input           ld_dc_inst_vleff;        // fault-only-first加载指令标识
output          ld_dc_ff_exception;      // fault-only-first异常标志
output  [6:0]   ld_dc_ff_new_vl;         // 新的vl值

// 新增逻辑：处理元素>0的异常
// 如果是fault-only-first指令且异常发生在元素>0
// 则不触发异常，而是更新vl
```

**文件: ct_lsu_ld_da.v**
```verilog
// 新增信号
input           ld_da_inst_vleff;
input   [6:0]   ld_da_ff_new_vl;

// 处理fault-only-first的异常逻辑
```

**文件: ct_lsu_ld_wb.v**
```verilog
// 新增信号：更新vl寄存器
output          ld_wb_vl_update;         // vl更新使能
output  [6:0]   ld_wb_new_vl;            // 新的vl值

// 需要与CP0模块接口，更新vl CSR
```

**文件: ct_lsu_top.v**
```verilog
// 新增输出到CP0
output          lsu_cp0_vl_update;
output  [6:0]   lsu_cp0_new_vl;
```

#### 2.1.3 实现要点

1. **异常处理逻辑**：
   - 元素0异常：正常触发异常，不修改vl
   - 元素>0异常：不触发异常，更新vl为当前元素索引

2. **vl更新机制**：
   - 需要与CP0模块协调，添加vl CSR写接口
   - vl更新需要原子操作，避免竞态条件

3. **性能考虑**：
   - fault-only-first指令可能需要逐元素检查
   - 可以考虑批量处理优化

---

### 2.2 全寄存器加载/存储指令支持

#### 2.2.1 功能描述

RVV 1.0新增全寄存器加载/存储指令：
- `vl1r.v` / `vs1r.v` - 加载/存储1个向量寄存器
- `vl2r.v` / `vs2r.v` - 加载/存储2个向量寄存器
- `vl4r.v` / `vs4r.v` - 加载/存储4个向量寄存器
- `vl8r.v` / `vs8r.v` - 加载/存储8个向量寄存器

**关键特性**：
- 不依赖vtype设置
- 用于上下文切换、数据块传输
- nf字段编码传输的寄存器数量

#### 2.2.2 修改点

**文件: ct_lsu_ld_ag.v**
```verilog
// 新增信号
output          ld_ag_inst_vlwhole;      // 全寄存器加载指令标识
output  [2:0]   ld_ag_nf;                // nf字段（寄存器数量-1）

// 全寄存器加载不需要vtype，直接传输数据
```

**文件: ct_lsu_st_ag.v**
```verilog
// 新增信号
output          st_ag_inst_vswhole;      // 全寄存器存储指令标识
output  [2:0]   st_ag_nf;                // nf字段
```

**文件: ct_lsu_ld_dc.v / ct_lsu_st_dc.v**
```verilog
// 处理全寄存器传输的特殊逻辑
// 不需要考虑元素宽度转换
// 直接传输VLEN * (nf+1) 位数据
```

#### 2.2.3 实现要点

1. **数据宽度计算**：
   - 传输数据量 = VLEN × (nf + 1)
   - 需要支持多拍传输

2. **与vtype无关**：
   - 全寄存器指令不依赖vtype设置
   - 即使vtype.vill=1也可以执行

---

### 2.3 vstart精确异常支持增强

#### 2.3.1 功能描述

RVV 1.0对vstart的要求：
- 所有向量指令必须支持从vstart指定的元素开始执行
- vstart在指令执行结束时重置为0
- 支持向量指令的精确异常

#### 2.3.2 修改点

**文件: ct_lsu_ld_dc.v**
```verilog
// 增强vstart处理
input   [6:0]   cp0_lsu_vstart;          // 已存在，需增强使用

// 计算实际处理的元素范围
// 元素索引从vstart开始，到vl-1结束
assign ld_dc_element_start = cp0_lsu_vstart;
assign ld_dc_element_end   = cp0_lsu_vl - 1;
```

**文件: ct_lsu_ld_da.v**
```verilog
// 处理vstart相关的地址计算
// 第一个元素的地址需要考虑vstart偏移
assign ld_da_first_element_addr = ld_ag_base_addr + cp0_lsu_vstart * element_size;
```

**文件: ct_lsu_ld_wb.v**
```verilog
// 异常时更新vstart
output  [6:0]   ld_wb_new_vstart;        // 异常时的vstart值

// 如果发生异常，vstart设置为当前处理的元素索引
```

**文件: ct_lsu_st_dc.v / ct_lsu_st_da.v**
```verilog
// 存储指令的vstart支持
// 类似加载指令的处理逻辑
```

#### 2.3.3 实现要点

1. **vstart位宽**：
   - 当前实现为7位（支持VLEN=128）
   - RVV 1.0要求vstart位宽 = log2(VLEN)
   - 如果VLEN>128，需要扩展vstart位宽

2. **异常处理**：
   - 精确异常需要记录当前处理的元素索引
   - 恢复执行时从vstart位置继续

---

### 2.4 vlmul扩展支持（2位→3位）

#### 2.4.1 功能描述

RVV 1.0将vlmul从2位扩展到3位，支持分数LMUL：
- vlmul[2:0] = 101: LMUL = 1/8
- vlmul[2:0] = 110: LMUL = 1/4
- vlmul[2:0] = 111: LMUL = 1/2
- vlmul[2:0] = 000: LMUL = 1
- vlmul[2:0] = 001: LMUL = 2
- vlmul[2:0] = 010: LMUL = 4
- vlmul[2:0] = 011: LMUL = 8

#### 2.4.2 修改点

**文件: ct_lsu_top.v**
```verilog
// 当前vsew为2位，可能需要扩展
// 检查是否需要支持更多SEW设置
input   [2:0]   idu_lsu_vmb_create0_vlmul;  // 扩展为3位
input   [2:0]   idu_lsu_vmb_create1_vlmul;
```

**文件: ct_lsu_ld_ag.v / ct_lsu_st_ag.v**
```verilog
// 元素计数计算需要考虑分数LMUL
// VLMAX = LMUL * VLEN / SEW
// 分数LMUL时VLMAX变小
```

#### 2.4.3 实现要点

1. **分数LMUL处理**：
   - 分数LMUL减少有效向量长度
   - 需要正确计算VLMAX

2. **寄存器分组**：
   - 分数LMUL时，一个向量寄存器可以分成多个组
   - 需要正确处理寄存器索引

---

### 2.5 vma/vta字段支持

#### 2.5.1 功能描述

RVV 1.0新增vma（掩码聚合）和vta（尾部聚合）字段：
- vta=0: 尾部元素保持不变（undisturbed）
- vta=1: 尾部元素可被覆盖为全1（agnostic）
- vma=0: 掩码非活跃元素保持不变
- vma=1: 掩码非活跃元素可被覆盖为全1

#### 2.5.2 修改点

**文件: ct_lsu_ld_wb.v**
```verilog
// 新增输入
input           cp0_lsu_vta;             // 尾部聚合模式
input           cp0_lsu_vma;             // 掩码聚合模式

// 写回逻辑需要考虑vta/vma
// 如果vta=1或vma=1，可以跳过尾部/掩码元素的写回
```

**文件: ct_lsu_st_wb.v**
```verilog
// 存储指令的掩码处理
// vma=1时，掩码非活跃元素可以不处理
```

#### 2.5.3 实现要点

1. **功耗优化**：
   - vta=1或vma=1时，可以跳过不必要的写操作
   - 减少寄存器写入功耗

2. **兼容性**：
   - 简单实现可以忽略vta/vma，始终使用undisturbed策略
   - 需要提供vta/vma状态位以支持线程迁移

---

### 2.6 段加载/存储指令支持

#### 2.6.1 功能描述

RVV 1.0的段加载/存储指令使用nf字段编码段中字段数量：
- nf[2:0] = 0: 单值传输（常规向量加载/存储）
- nf[2:0] = 1-7: 每个段包含2-8个字段

#### 2.6.2 修改点

**文件: ct_lsu_ld_ag.v**
```verilog
// 新增nf字段处理
input   [2:0]   idu_lsu_nf;              // nf字段

// 计算段加载的地址
// 每个元素位置传输nf+1个值
```

**文件: ct_lsu_st_ag.v**
```verilog
// 段存储的地址计算
input   [2:0]   idu_lsu_nf;
```

#### 2.6.3 实现要点

1. **地址计算**：
   - 段加载/存储的地址步进需要考虑字段数量
   - 每个元素位置传输多个值

2. **寄存器分配**：
   - 段加载需要多个目标向量寄存器
   - 寄存器编号需要按LMUL对齐

---

### 2.7 掩码加载/存储指令

#### 2.7.1 功能描述

RVV 1.0定义了专门的掩码加载/存储指令：
- `vlm.v` - 掩码加载（EEW=8）
- `vsm.v` - 掩码存储（EEW=8）

#### 2.7.2 修改点

**文件: ct_lsu_ld_ag.v / ct_lsu_st_ag.v**
```verilog
// 掩码加载/存储的特殊处理
// EEW固定为8，与SEW无关
output          ld_ag_inst_vlm;          // 掩码加载指令
output          st_ag_inst_vsm;          // 掩码存储指令
```

---

## 3. 接口修改汇总

### 3.1 新增输入信号

| 信号名 | 位宽 | 来源 | 描述 |
|--------|------|------|------|
| idu_lsu_inst_vleff | 1 | IDU | fault-only-first加载指令标识 |
| idu_lsu_inst_vlwhole | 1 | IDU | 全寄存器加载指令标识 |
| idu_lsu_inst_vswhole | 1 | IDU | 全寄存器存储指令标识 |
| idu_lsu_nf[2:0] | 3 | IDU | 段加载/存储字段数量 |
| idu_lsu_vlmul[2:0] | 3 | IDU | 向量长度乘数（扩展为3位） |
| cp0_lsu_vta | 1 | CP0 | 尾部聚合模式 |
| cp0_lsu_vma | 1 | CP0 | 掩码聚合模式 |
| cp0_lsu_vl[6:0] | 7 | CP0 | 向量长度 |

### 3.2 新增输出信号

| 信号名 | 位宽 | 目标 | 描述 |
|--------|------|------|------|
| lsu_cp0_vl_update | 1 | CP0 | vl更新使能 |
| lsu_cp0_new_vl[6:0] | 7 | CP0 | 新的vl值 |
| lsu_cp0_vstart_update | 1 | CP0 | vstart更新使能 |
| lsu_cp0_new_vstart[6:0] | 7 | CP0 | 新的vstart值 |

---

## 4. 实现优先级

### 4.1 高优先级（必须实现）

1. **Fault-Only-First加载指令** - RVV 1.0关键特性
2. **vstart精确异常支持增强** - 异常处理必需
3. **vlmul扩展到3位** - 分数LMUL支持

### 4.2 中优先级（建议实现）

1. **全寄存器加载/存储指令** - 上下文切换优化
2. **vma/vta字段支持** - 功耗优化

### 4.3 低优先级（可选实现）

1. **段加载/存储指令** - 特定应用场景
2. **掩码加载/存储指令优化** - 特定场景优化

---

## 5. 验证要点

### 5.1 功能验证

1. **Fault-Only-First测试**：
   - 元素0异常测试
   - 元素>0异常测试
   - vl更新正确性测试

2. **vstart测试**：
   - 非零vstart执行测试
   - 异常恢复测试
   - vstart重置测试

3. **分数LMUL测试**：
   - LMUL=1/8, 1/4, 1/2测试
   - VLMAX计算正确性测试

### 5.2 边界条件测试

1. vl=0时的向量指令行为
2. vstart >= vl时的行为
3. 跨页边界的向量访问

---

## 6. 风险评估

### 6.1 技术风险

| 风险项 | 风险等级 | 缓解措施 |
|--------|---------|---------|
| vl动态更新竞态条件 | 高 | 添加vl更新互斥机制 |
| vstart位宽不足 | 中 | 评估VLEN配置，必要时扩展 |
| 指令编码兼容性 | 高 | 确保IDU解码同步更新 |

### 6.2 进度风险

| 风险项 | 风险等级 | 缓解措施 |
|--------|---------|---------|
| Fault-Only-First实现复杂度 | 高 | 分阶段实现，先支持基本功能 |
| 验证工作量增加 | 中 | 提前准备测试用例 |

---

## 7. 总结

LSU模块升级到RVV 1.0需要进行以下关键修改：

1. **新增Fault-Only-First加载指令支持** - 需要修改ld_ag, ld_dc, ld_da, ld_wb模块
2. **新增全寄存器加载/存储指令支持** - 需要修改ld_ag, st_ag模块
3. **增强vstart精确异常支持** - 需要修改所有向量加载存储相关模块
4. **支持vlmul扩展到3位** - 需要修改信号位宽和相关计算逻辑
5. **支持vma/vta字段** - 需要修改ld_wb, st_wb模块

建议按照优先级分阶段实施，首先完成高优先级的Fault-Only-First和vstart支持，然后逐步完成其他功能。
