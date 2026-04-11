# VFDSU模块RVV 1.0修改计划

## 1. 文档概述

### 1.1 目的
本文档详细描述了VFDSU（向量浮点除法/平方根单元）模块从当前标量实现升级到支持RVV 1.0向量扩展的修改计划。

### 1.2 参考文档
- RVV 1.0指令集规范：`d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master\rvv_instructions.json`
- 现有VFDSU RTL代码：`d:\code\openc910\C910_RTL_FACTORY\gen_rtl _rvv1.0\vfdsu\rtl\`
- 现有VFDSU设计文档：`d:\code\openc910\doc\design_docs\vfdsu\`

### 1.3 修改日期
2026-04-11

---

## 2. 当前VFDSU实现分析

### 2.1 模块架构

```
ct_vfdsu_top (顶层模块)
├── ct_vfdsu_ctrl          -- 控制模块（状态机、流水线控制）
├── ct_vfdsu_double        -- 双精度数据通路
│   ├── ct_vfdsu_prepare   -- 输入准备（操作数预处理）
│   ├── ct_vfdsu_srt       -- SRT算法迭代
│   ├── ct_vfdsu_round     -- 舍入处理
│   └── ct_vfdsu_pack      -- 结果打包
└── ct_vfdsu_scalar_dp     -- 标量数据处理（指令译码、目标寄存器管理）
```

### 2.2 流水线架构
| 阶段 | 名称 | 功能描述 |
|------|------|----------|
| EX1 | 准备阶段 | 操作数预处理、特殊值检测、规格化 |
| EX2 | SRT迭代阶段 | SRT radix-16除法/平方根迭代计算 |
| EX3 | 舍入阶段 | IEEE 754舍入处理 |
| EX4 | 打包阶段 | 结果格式化、异常标志生成、写回 |

### 2.3 当前支持的指令
- **fdiv**: 标量浮点除法
- **fsqrt**: 标量浮点平方根

### 2.4 当前支持的精度
- 双精度（64位）：13次SRT迭代
- 单精度（32位）：6次SRT迭代
- 半精度（16位）：3次SRT迭代

### 2.5 关键代码特征
1. **标量模式固定**：`ct_vfdsu_scalar_dp.v`中`ex1_scalar = 1'b1`硬编码为标量模式
2. **SIMD实例已注释**：`ct_vfdsu_top.v`中存在注释掉的SIMD实例代码（set0/set1, double/single/half）
3. **指令译码**：通过`idu_vfpu_rf_pipex_func[19:0]`信号进行指令译码
   - `func[0]` = ex1_div（除法）
   - `func[1]` = ex1_sqrt（平方根）
   - `func[15]` = ex1_single（单精度）
   - `func[16]` = ex1_double（双精度）

---

## 3. RVV 1.0指令集要求

### 3.1 VFDSU相关指令列表

| 指令 | 类型 | 操作数 | 描述 | 当前支持 |
|------|------|--------|------|----------|
| vfdiv | OPFVV | vd, vs1, vs2[, vm] | 向量浮点除法：vd = vs2 / vs1 | 部分支持（标量） |
| vfdiv | OPFVF | vd, rs1, vs2[, vm] | 向量浮点除法：vd = vs2 / rs1 | 部分支持（标量） |
| vfrdiv | OPFVF | vd, rs1, vs2[, vm] | 向量浮点反向除法：vd = rs1 / vs2 | **不支持** |
| vfsqrt.v | OPFVV | vd, vs1[, vm] | 向量浮点平方根：vd = sqrt(vs2) | 部分支持（标量） |
| vfrsqrt7.v | OPFVV | vd, vs1[, vm] | 向量浮点近似平方根倒数：vd = 1/sqrt(vs2) | **不支持** |
| vfrec7.v | OPFVV | vd, vs1[, vm] | 向量浮点近似倒数：vd = 1/vs2 | **不支持** |

### 3.2 RVV 1.0向量扩展特性

#### 3.2.1 向量掩码（vm）
- 每条指令支持可选的向量掩码
- 当vm=0时，使用v0寄存器作为掩码
- 掩码为0的元素保持目标寄存器原值不变

#### 3.2.2 向量长度（vl）
- vl寄存器控制实际处理的元素数量
- 超过vl的元素保持原值

#### 3.2.3 向量起始位置（vstart）
- vstart寄存器指示起始元素位置
- 用于异常恢复

#### 3.2.4 标准元素宽度（SEW）
- 支持SEW=16/32/64（半精度/单精度/双精度）

#### 3.2.5 Fault-Only-First（FOF）
- 部分向量加载指令支持FOF模式
- 发生异常时只更新vstart

---

## 4. 差距分析

### 4.1 功能差距

| 功能需求 | 当前状态 | 差距描述 |
|----------|----------|----------|
| vfdiv（向量-向量） | 标量支持 | 需要向量迭代处理 |
| vfdiv（向量-标量） | 标量支持 | 需要向量迭代处理 |
| vfrdiv | 不支持 | 需要新增反向除法逻辑 |
| vfsqrt.v | 标量支持 | 需要向量迭代处理 |
| vfrsqrt7.v | 不支持 | 需要新增近似平方根倒数逻辑 |
| vfrsqrt7.v精度 | 不支持 | 需要7位近似精度 |
| vfrec7.v | 不支持 | 需要新增近似倒数逻辑 |
| vfrec7.v精度 | 不支持 | 需要7位近似精度 |
| 向量掩码（vm） | 不支持 | 需要新增掩码处理逻辑 |
| 向量长度（vl） | 不支持 | 需要与CSR集成 |
| vstart支持 | 不支持 | 需要异常恢复机制 |
| SEW支持 | 部分支持 | 已支持16/32/64位精度 |

### 4.2 接口差距

| 接口需求 | 当前状态 | 差距描述 |
|----------|----------|----------|
| 向量寄存器读写 | 标量寄存器 | 需要向量寄存器接口 |
| 掩码输入 | 无 | 需要新增v0掩码输入 |
| vl/vstart CSR | 无 | 需要CSR接口 |
| 元素索引输出 | 无 | 需要当前处理元素索引 |
| 向量完成信号 | 标量完成 | 需要向量操作完成信号 |

---

## 5. 修改方案

### 5.1 总体架构修改

#### 5.1.1 新增模块
```
ct_vfdsu_top (顶层模块)
├── ct_vfdsu_ctrl          -- 控制模块（修改）
├── ct_vfdsu_double        -- 双精度数据通路（修改）
│   ├── ct_vfdsu_prepare   -- 输入准备（修改）
│   ├── ct_vfdsu_srt       -- SRT算法迭代（修改）
│   ├── ct_vfdsu_round     -- 舍入处理（修改）
│   └── ct_vfdsu_pack      -- 结果打包（修改）
├── ct_vfdsu_scalar_dp     -- 标量数据处理（修改）
├── ct_vfdsu_approx        -- 【新增】近似计算模块
│   ├── ct_vfdsu_rsqrt7    -- 近似平方根倒数
│   └── ct_vfdsu_rec7      -- 近似倒数
└── ct_vfdsu_vector_ctrl   -- 【新增】向量控制模块
    ├── 元素迭代控制
    ├── 掩码处理
    └── vl/vstart管理
```

### 5.2 详细修改步骤

---

### 5.2.1 ct_vfdsu_top.v 修改

#### 修改内容
1. **新增接口信号**
```verilog
// 新增输入信号
input   [6:0]    dp_vfdsu_ex1_pipex_mask;      // 向量掩码
input            dp_vfdsu_ex1_pipex_vm;        // 掩码使能
input   [6:0]    dp_vfdsu_ex1_pipex_vl;        // 向量长度
input   [6:0]    dp_vfdsu_ex1_pipex_vstart;    // 起始位置
input   [2:0]    dp_vfdsu_ex1_pipex_sew;       // 标准元素宽度
input            dp_vfdsu_ex1_pipex_is_vector; // 向量操作指示

// 新增输出信号
output  [6:0]    pipex_dp_vfdsu_element_idx;   // 当前元素索引
output           pipex_dp_vfdsu_vector_done;   // 向量操作完成
output           pipex_dp_vfdsu_exception;     // 向量异常
```

2. **新增模块实例化**
```verilog
// 新增近似计算模块
ct_vfdsu_approx x_ct_vfdsu_approx (
    .ex1_rsqrt7      (ex1_rsqrt7),
    .ex1_rec7        (ex1_rec7),
    // ... 其他端口
);

// 新增向量控制模块
ct_vfdsu_vector_ctrl x_ct_vfdsu_vector_ctrl (
    .ex1_vm          (ex1_vm),
    .ex1_vl          (ex1_vl),
    .ex1_vstart      (ex1_vstart),
    // ... 其他端口
);
```

3. **修改数据通路选择逻辑**
```verilog
// 根据指令类型选择数据通路
assign data_path_sel = ex1_rsqrt7 || ex1_rec7 ? APPROX_PATH :
                       ex1_div    || ex1_sqrt ? SRT_PATH :
                       SRT_PATH;
```

---

### 5.2.2 ct_vfdsu_scalar_dp.v 修改

#### 修改内容
1. **新增指令译码信号**
```verilog
// 新增指令译码
output  ex1_rdiv;       // 反向除法（vfrdiv）
output  ex1_rsqrt7;     // 近似平方根倒数（vfrsqrt7.v）
output  ex1_rec7;       // 近似倒数（vfrec7.v）
output  ex1_vm;         // 掩码使能
output  [6:0] ex1_vl;   // 向量长度
output  [6:0] ex1_vstart; // 起始位置
output  ex1_is_vector;  // 向量操作指示
```

2. **修改指令译码逻辑**
```verilog
// 扩展指令译码
always @(posedge vfdsu_sew_clk or negedge cpurst_b) begin
    if(!cpurst_b) begin
        ex1_div      <= 1'b0;
        ex1_sqrt     <= 1'b0;
        ex1_rdiv     <= 1'b0;  // 新增
        ex1_rsqrt7   <= 1'b0;  // 新增
        ex1_rec7     <= 1'b0;  // 新增
        ex1_double   <= 1'b0;
        ex1_single   <= 1'b0;
    end
    else if(idu_vfpu_rf_pipex_gateclk_sel) begin
        ex1_div      <= idu_vfpu_rf_pipex_func[0];
        ex1_sqrt     <= idu_vfpu_rf_pipex_func[1];
        ex1_rdiv     <= idu_vfpu_rf_pipex_func[2];  // 新增
        ex1_rsqrt7   <= idu_vfpu_rf_pipex_func[3];  // 新增
        ex1_rec7     <= idu_vfpu_rf_pipex_func[4];  // 新增
        ex1_double   <= idu_vfpu_rf_pipex_func[16];
        ex1_single   <= idu_vfpu_rf_pipex_func[15];
    end
end
```

3. **修改标量模式控制**
```verilog
// 修改：ex1_scalar不再硬编码
assign ex1_scalar = ~ex1_is_vector;  // 根据向量操作指示确定
```

---

### 5.2.3 ct_vfdsu_prepare.v 修改

#### 修改内容
1. **新增反向除法操作数交换逻辑**
```verilog
// vfrdiv: 操作数交换，实现 rs1/vs2
assign ex1_oper0_rdiv[63:0] = ex1_src1[63:0];  // rs1作为被除数
assign ex1_oper1_rdiv[63:0] = ex1_src0[63:0];  // vs2作为除数

// 操作数选择
assign ex1_oper0[63:0] = ex1_rdiv ? ex1_oper0_rdiv[63:0] : ex1_src0[63:0];
assign ex1_oper1[63:0] = ex1_rdiv ? ex1_oper1_rdiv[63:0] : ex1_src1[63:0];
```

2. **新增近似计算跳过SRT逻辑**
```verilog
// 近似计算不需要SRT迭代
assign ex1_srt_skip = ex1_result_zero || 
                      ex1_result_qnan || 
                      ex1_result_inf ||
                      ex1_rsqrt7 ||     // 新增
                      ex1_rec7;         // 新增
```

---

### 5.2.4 ct_vfdsu_ctrl.v 修改

#### 修改内容
1. **新增向量迭代控制状态机**
```verilog
// 新增状态
parameter VEC_ITER = 4'b1001;  // 向量迭代状态

// 修改状态转换
always @(*) begin
    case(div_cur_state[3:0])
    IDLE    : if(dp_vfdsu_idu_fdiv_issue)
                 div_next_state[3:0] = RF;
              else
                 div_next_state[3:0] = IDLE;
    RF      : div_next_state[3:0] = EX1;
    EX1     : if(dp_vfdsu_ex1_pipex_sel) 
                 div_next_state[3:0] = ex1_is_vector ? VEC_ITER : EX2;
              else
                 div_next_state[3:0] = IDLE;
    VEC_ITER: if(vector_done)  // 新增：向量迭代完成
                 div_next_state[3:0] = EX2;
              else
                 div_next_state[3:0] = VEC_ITER;
    EX2     : if(srt_last_round)
                 div_next_state[3:0] = WB_REQ;
              else 
                 div_next_state[3:0] = EX2;
    WB_REQ  : if(ex4_pipedown)
                 div_next_state[3:0] = WB;
              else
                 div_next_state[3:0] = WB_REQ;
    WB      : if(dp_vfdsu_idu_fdiv_issue)
                 div_next_state[3:0] = RF;
              else
                 div_next_state[3:0] = IDLE;
    default : div_next_state[3:0] = IDLE;
    endcase
end
```

2. **新增向量元素计数器**
```verilog
// 向量元素计数器
reg [6:0] vector_element_cnt;
reg [6:0] vector_element_idx;

always @(posedge div_sm_clk or negedge cpurst_b) begin
    if(!cpurst_b)
        vector_element_cnt <= 7'b0;
    else if(rtu_yy_xx_flush)
        vector_element_cnt <= 7'b0;
    else if(ex1_pipedown && ex1_is_vector)
        vector_element_cnt <= ex1_vl - ex1_vstart;  // 初始化计数器
    else if(div_cur_state == VEC_ITER && element_done)
        vector_element_cnt <= vector_element_cnt - 7'b1;
end
```

---

### 5.2.5 新增 ct_vfdsu_approx.v 模块

#### 模块功能
实现vfrsqrt7.v和vfrec7.v近似计算功能。

#### 模块接口
```verilog
module ct_vfdsu_approx(
    // 时钟复位
    input           cp0_yy_clk_en,
    input           cpurst_b,
    input           forever_cpuclk,
    input           pad_yy_icg_scan_en,
    input           cp0_vfpu_icg_en,
    
    // 控制信号
    input           ex1_rsqrt7,      // 近似平方根倒数
    input           ex1_rec7,        // 近似倒数
    input           ex1_double,      // 双精度
    input           ex1_single,      // 单精度
    input           ex1_pipedown,
    
    // 输入操作数
    input   [63:0]  ex1_src0,        // 输入操作数
    
    // 输出结果
    output  [63:0]  approx_result,   // 近似结果
    output  [4:0]   approx_expt      // 异常标志
);
```

#### 实现要点
1. **vfrsqrt7.v实现**
   - 7位近似平方根倒数
   - 使用查找表（LUT）实现
   - 输入：浮点数x
   - 输出：1/sqrt(x)的7位近似值

2. **vfrec7.v实现**
   - 7位近似倒数
   - 使用查找表（LUT）实现
   - 输入：浮点数x
   - 输出：1/x的7位近似值

3. **查找表设计**
```verilog
// 近似倒数查找表（示例）
// 基于输入指数和尾数高位进行查表
always @(*) begin
    casez({exponent_high, mantissa_high})
        // 查找表项...
        default: approx_value = DEFAULT_VALUE;
    endcase
end
```

---

### 5.2.6 新增 ct_vfdsu_vector_ctrl.v 模块

#### 模块功能
实现向量迭代控制、掩码处理和vl/vstart管理。

#### 模块接口
```verilog
module ct_vfdsu_vector_ctrl(
    // 时钟复位
    input           cp0_yy_clk_en,
    input           cpurst_b,
    input           forever_cpuclk,
    input           pad_yy_icg_scan_en,
    input           cp0_vfpu_icg_en,
    
    // 向量控制输入
    input           ex1_vm,          // 掩码使能
    input   [6:0]   ex1_vl,          // 向量长度
    input   [6:0]   ex1_vstart,      // 起始位置
    input           ex1_is_vector,   // 向量操作指示
    input   [6:0]   ex1_mask,        // 掩码值
    
    // 元素处理控制
    input           element_done,    // 当前元素处理完成
    input           element_exception,// 当前元素异常
    
    // 输出控制
    output  [6:0]   element_idx,     // 当前元素索引
    output          element_mask,    // 当前元素掩码值
    output          element_active,  // 当前元素是否活跃
    output          vector_done,     // 向量操作完成
    output  [6:0]   next_vstart      // 更新的vstart值
);
```

#### 实现要点
1. **元素迭代控制**
```verilog
// 元素索引管理
always @(posedge clk or negedge cpurst_b) begin
    if(!cpurst_b)
        element_idx <= 7'b0;
    else if(ex1_pipedown && ex1_is_vector)
        element_idx <= ex1_vstart;  // 从vstart开始
    else if(element_done)
        element_idx <= element_idx + 7'b1;
end

// 向量完成判断
assign vector_done = (element_idx >= ex1_vl - 7'b1) && element_done;
```

2. **掩码处理**
```verilog
// 提取当前元素掩码位
assign element_mask = ex1_mask[element_idx[2:0]];

// 判断元素是否活跃
assign element_active = ex1_vm | element_mask;
```

---

### 5.2.7 ct_vfdsu_srt.v 修改

#### 修改内容
1. **支持反向除法**
```verilog
// vfrdiv: 反向除法使用相同的SRT算法
// 操作数已在prepare阶段交换
// 无需额外修改SRT核心逻辑
```

2. **新增近似计算跳过逻辑**
```verilog
// 近似计算直接跳过SRT迭代
assign srt_ctrl_skip_srt = ex2_of || 
                           ex2_id_nor_srt_skip ||
                           vfdsu_ex2_srt_skip ||
                           vfdsu_ex2_rsqrt7 ||  // 新增
                           vfdsu_ex2_rec7;      // 新增
```

---

### 5.2.8 ct_vfdsu_round.v 修改

#### 修改内容
1. **支持近似计算结果**
```verilog
// 近似计算结果直接传递，不需要舍入
assign final_result = vfdsu_ex3_rsqrt7 ? approx_rsqrt7_result :
                      vfdsu_ex3_rec7   ? approx_rec7_result :
                      srt_round_result;
```

---

### 5.2.9 ct_vfdsu_pack.v 修改

#### 修改内容
1. **支持近似计算结果打包**
```verilog
// 近似计算结果打包
assign ex4_out_result = vfdsu_ex4_rsqrt7 ? pack_rsqrt7_result :
                        vfdsu_ex4_rec7   ? pack_rec7_result :
                        pack_srt_result;
```

---

## 6. 指令编码扩展

### 6.1 idu_vfpu_rf_pipex_func 扩展定义

| 位域 | 功能 | 描述 |
|------|------|------|
| [0] | ex1_div | 除法操作 |
| [1] | ex1_sqrt | 平方根操作 |
| [2] | ex1_rdiv | 反向除法（vfrdiv） |
| [3] | ex1_rsqrt7 | 近似平方根倒数（vfrsqrt7.v） |
| [4] | ex1_rec7 | 近似倒数（vfrec7.v） |
| [15] | ex1_single | 单精度 |
| [16] | ex1_double | 双精度 |
| [17] | ex1_is_vector | 向量操作指示 |

---

## 7. 测试计划

### 7.1 单元测试

| 测试项 | 测试内容 | 预期结果 |
|--------|----------|----------|
| vfdiv.vv | 向量-向量除法 | 正确计算所有元素 |
| vfdiv.vf | 向量-标量除法 | 正确计算所有元素 |
| vfrdiv.vf | 向量反向除法 | 正确计算所有元素 |
| vfsqrt.v | 向量平方根 | 正确计算所有元素 |
| vfrsqrt7.v | 近似平方根倒数 | 7位精度正确 |
| vfrec7.v | 近似倒数 | 7位精度正确 |
| 向量掩码 | vm=0时的掩码处理 | 正确跳过掩码为0的元素 |
| vl边界 | vl=0, vl=MAX | 正确处理边界条件 |
| vstart | 非零vstart | 从正确位置开始处理 |

### 7.2 集成测试

| 测试项 | 测试内容 | 预期结果 |
|--------|----------|----------|
| 向量指令序列 | 连续向量指令 | 正确流水执行 |
| 异常处理 | 除零、NaN等异常 | 正确报告异常 |
| 中断恢复 | vstart正确更新 | 可正确恢复执行 |

---

## 8. 实施计划

### 8.1 阶段一：基础向量支持（预计2周）
1. 修改ct_vfdsu_top.v接口
2. 修改ct_vfdsu_scalar_dp.v指令译码
3. 新增ct_vfdsu_vector_ctrl.v模块
4. 修改ct_vfdsu_ctrl.v向量迭代控制

### 8.2 阶段二：新指令支持（预计2周）
1. 修改ct_vfdsu_prepare.v支持vfrdiv
2. 新增ct_vfdsu_approx.v模块
3. 修改ct_vfdsu_srt.v/round.v/pack.v支持近似计算

### 8.3 阶段三：验证与优化（预计1周）
1. 编写测试用例
2. 功能验证
3. 性能优化

---

## 9. 风险评估

| 风险项 | 影响 | 缓解措施 |
|--------|------|----------|
| 向量迭代性能 | 向量操作吞吐量下降 | 考虑多元素并行处理 |
| 近似计算精度 | 7位精度可能不足 | 提供可配置精度选项 |
| 掩码处理复杂度 | 增加逻辑复杂度 | 使用专用掩码处理模块 |
| 向量异常处理 | vstart更新逻辑复杂 | 详细设计异常恢复流程 |

---

## 10. 附录

### 10.1 文件修改清单

| 文件 | 修改类型 | 修改内容概述 |
|------|----------|--------------|
| ct_vfdsu_top.v | 修改 | 新增接口、新增模块实例化 |
| ct_vfdsu_ctrl.v | 修改 | 新增向量迭代状态机 |
| ct_vfdsu_scalar_dp.v | 修改 | 新增指令译码信号 |
| ct_vfdsu_prepare.v | 修改 | 新增反向除法操作数交换 |
| ct_vfdsu_srt.v | 修改 | 新增近似计算跳过逻辑 |
| ct_vfdsu_round.v | 修改 | 支持近似计算结果 |
| ct_vfdsu_pack.v | 修改 | 支持近似计算结果打包 |
| ct_vfdsu_approx.v | 新增 | 近似计算模块 |
| ct_vfdsu_vector_ctrl.v | 新增 | 向量控制模块 |

### 10.2 参考资料
1. RISC-V Vector Extension Specification v1.0
2. IEEE 754-2019 Floating-Point Arithmetic Standard
3. OpenC910 Architecture Reference Manual
