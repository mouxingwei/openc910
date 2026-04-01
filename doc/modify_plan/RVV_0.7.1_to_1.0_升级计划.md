# OpenC910 RVV 0.7.1升级到RVV 1.0代码修改计划

## 文档信息
- **文档版本**: 1.0
- **创建日期**: 2026-04-01
- **目标**: 将OpenC910的向量扩展从v0.7.1升级到v1.0
- **代码库**: d:\code\openc910\C910_RTL_FACTORY
- **参考文档**: RISC-V向量扩展v0.7.1与v1.0差异分析.md

---

## 1. 升级概述

### 1.1 升级目标
将OpenC910处理器的向量扩展实现从RISC-V向量扩展规范v0.7.1升级到v1.0，以获得：
- 标准化的向量扩展实现
- 更好的工具链支持
- 更完善的生态系统兼容性
- 新特性支持（分数LMUL、近似计算等）

### 1.2 升级范围
本次升级涉及以下主要模块：
1. **CSR寄存器模块**：新增vcsr和vlenb寄存器
2. **vtype寄存器**：字段重新定义，支持分数LMUL
3. **指令解码模块**：新增v1.0指令解码
4. **向量执行单元**：新增近似计算等功能单元
5. **验证环境**：更新测试用例和验证策略

### 1.3 升级策略
采用**渐进式升级策略**：
- **阶段一**：修改CSR和vtype定义（基础架构）
- **阶段二**：修改指令解码和执行逻辑（核心功能）
- **阶段三**：新增v1.0特有功能（扩展特性）
- **阶段四**：验证和性能优化（质量保证）

---

## 2. 详细修改计划

### 2.1 CSR寄存器修改

#### 2.1.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/cp0/rtl/ct_cp0_regs.v` | 新增vcsr和vlenb CSR定义 | 高 |
| `gen_rtl/cp0/rtl/ct_cp0_top.v` | 更新CSR读写逻辑 | 高 |
| `gen_rtl/cp0/rtl/ct_cp0_iui.v` | 更新CSR接口逻辑 | 中 |

#### 2.1.2 具体修改点

**文件：ct_cp0_regs.v**

**修改点1：新增CSR地址定义**
```verilog
// 现有定义（v0.7.1）
parameter VSTART    = 12'h008;
parameter VXSAT     = 12'h009;
parameter VXRM      = 12'h00A;
parameter VTYPE     = 12'hC21;
parameter VLENB     = 12'hC22;  // 已存在但需要激活

// 新增定义（v1.0）
parameter VCSR      = 12'h00F;  // 新增：向量控制状态寄存器
```

**修改点2：新增vcsr寄存器**
```verilog
// 在寄存器定义区域添加
reg  [2:0]  vcsr_value;  // vcsr寄存器，包含vxsat和vxrm的镜像

// 新增vcsr寄存器读写逻辑
always @(posedge cp0_clk or negedge cp0_rst_b) begin
  if (!cp0_rst_b) begin
    vcsr_value[2:0] <= 3'b0;
  end else if (vcsr_wen) begin
    vcsr_value[2:0] <= iui_regs_wdata[2:0];
  end else begin
    vcsr_value[2:0] <= vcsr_value[2:0];
  end
end

// vcsr与vxsat/vxrm的同步逻辑
always @(*) begin
  // vcsr[0] = vxsat
  // vcsr[2:1] = vxrm
  vcsr_value[0] = vxsat_value;
  vcsr_value[2:1] = vxrm_value[1:0];
end
```

**修改点3：激活vlenb寄存器**
```verilog
// vlenb是只读寄存器，值为VLEN/8
// 需要根据实际VLEN配置设置
parameter VLEN = 128;  // 示例：128位向量寄存器
wire [11:0] vlenb_value = VLEN / 8;  // = 16

assign vlenb_rdata = vlenb_value;
```

**修改点4：新增CSR读数据选择逻辑**
```verilog
// 在CSR读数据选择中添加
always @(*) begin
  case (iui_regs_addr[11:0])
    VSTART:   data_out = vstart_value;
    VXSAT:    data_out = {60'b0, vxsat_value};
    VXRM:     data_out = {62'b0, vxrm_value};
    VCSR:     data_out = {61'b0, vcsr_value};  // 新增
    VTYPE:    data_out = vtype_value;
    VLENB:    data_out = {52'b0, vlenb_value}; // 激活
    default:  data_out = 64'b0;
  endcase
end
```

---

### 2.2 vtype寄存器修改

#### 2.2.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/rtu/rtl/ct_rtu_rob_entry.v` | vtype字段定义扩展 | 高 |
| `gen_rtl/rtu/rtl/ct_rtu_rob_rt.v` | vtype字段传递逻辑 | 高 |
| `gen_rtl/rtu/rtl/ct_rtu_retire.v` | vtype字段处理逻辑 | 高 |
| `gen_rtl/iu/rtl/ct_iu_special.v` | vsetvli指令执行逻辑 | 高 |
| `gen_rtl/cp0/rtl/ct_cp0_regs.v` | vtype寄存器定义 | 高 |

#### 2.2.2 具体修改点

**文件：ct_rtu_rob_entry.v**

**修改点1：扩展vlmul字段宽度**
```verilog
// 现有定义（v0.7.1）
reg  [1:0]  vlmul;  // 2位，支持LMUL=1,2,4,8

// 修改为（v1.0）
reg  [2:0]  vlmul;  // 3位，支持LMUL=1/8,1/4,1/2,1,2,4,8
```

**修改点2：新增vma和vta字段**
```verilog
// 新增字段定义
reg         vma;    // 向量掩码无关模式
reg         vta;    // 向量尾部无关模式

// 初始化
always @(posedge rob_clk or negedge rob_rst_b) begin
  if (!rob_rst_b) begin
    vlmul[2:0] <= 3'b0;
    vma        <= 1'b0;
    vta        <= 1'b0;
  end else if (x_create_en) begin
    vlmul[2:0] <= x_create_data[ROB_VLMUL:ROB_VLMUL-2];
    vma        <= x_create_data[ROB_VMA];
    vta        <= x_create_data[ROB_VTA];
  end
end
```

**修改点3：移除vediv字段**
```verilog
// 删除vediv字段定义（v0.7.1独有）
// reg  [1:0]  vediv;  // 已废弃
```

**文件：ct_rtu_retire.v**

**修改点4：更新vsetvl指令的vtype处理**
```verilog
// 修改vsetvl指令的vtype字段提取逻辑
always @(*) begin
  // 从mtval中提取vtype字段
  rtu_cp0_vsetvl_vlmul[2:0]  = rob_retire_inst0_mtval[2:0];   // 扩展为3位
  rtu_cp0_vsetvl_vsew[2:0]   = rob_retire_inst0_mtval[5:3];
  rtu_cp0_vsetvl_vta         = rob_retire_inst0_mtval[6];     // 新增
  rtu_cp0_vsetvl_vma         = rob_retire_inst0_mtval[7];     // 新增
end
```

**文件：ct_cp0_regs.v**

**修改点5：更新vtype寄存器定义**
```verilog
// vtype寄存器布局（v1.0）
// [XLEN-1]    : vill
// [XLEN-2:8]  : Reserved
// [7]         : vma
// [6]         : vta
// [5:3]       : vsew[2:0]
// [2:0]       : vlmul[2:0]

reg         vtype_vill;
reg  [2:0]  vtype_vlmul;
reg  [2:0]  vtype_vsew;
reg         vtype_vta;
reg         vtype_vma;

// vtype寄存器组合
wire [63:0] vtype_value = {
  vtype_vill,        // [63]
  55'b0,             // [62:8] Reserved
  vtype_vma,         // [7]
  vtype_vta,         // [6]
  vtype_vsew[2:0],   // [5:3]
  vtype_vlmul[2:0]   // [2:0]
};
```

---

### 2.3 指令解码修改

#### 2.3.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/idu/rtl/ct_idu_ir_decd.v` | 新增v1.0指令解码 | 高 |
| `gen_rtl/ifu/rtl/ct_ifu_decd_normal.v` | 向量指令预解码 | 中 |
| `gen_rtl/idu/rtl/ct_idu_is_dp.v` | 向量指令分发逻辑 | 中 |

#### 2.3.2 具体修改点

**文件：ct_idu_ir_decd.v**

**修改点1：新增vsetivli指令解码**
```verilog
// v1.0新增vsetivli指令（立即数版本）
wire  decd_vsetivli;
assign decd_vsetivli = (x_opcode[31:30]==2'b11) && 
                       (x_opcode[14:12]==3'b111) && 
                       (x_opcode[6:0]==7'b1010111);

// 输出信号
output  x_vsetivli;
assign x_vsetivli = !x_illegal && decd_vsetivli;
```

**修改点2：修改vsetvli指令的vtype立即数提取**
```verilog
// v1.0中vsetvli的vtype字段布局变化
// 需要提取vma和vta字段
wire  [4:0]  vlmul_imm;  // 5位有符号立即数
wire  [2:0]  vsew_imm;
wire         vta_imm;
wire         vma_imm;

assign vlmul_imm[4:0] = x_opcode[30:26];  // zimm[4:0]
assign vsew_imm[2:0]  = x_opcode[25:23];  // zimm[7:5]
assign vta_imm        = x_opcode[22];     // zimm[8]
assign vma_imm        = x_opcode[21];     // zimm[9]
```

**修改点3：新增v1.0特有指令解码**
```verilog
// 近似计算指令
wire  decd_vfrece7;
wire  decd_vfrsqrte7;

assign decd_vfrece7   = (x_opcode[31:26]==6'b000000) && 
                        (x_opcode[14:12]==3'b011) && 
                        (x_opcode[6:0]==7'b1010111);

assign decd_vfrsqrte7 = (x_opcode[31:26]==6'b000000) && 
                        (x_opcode[14:12]==3'b101) && 
                        (x_opcode[6:0]==7'b1010111);

// 向量重排指令
wire  decd_vrgatherei16;
assign decd_vrgatherei16 = (x_opcode[31:26]==6'b001100) && 
                           (x_opcode[14:12]==3'b010) && 
                           (x_opcode[6:0]==7'b1010111);
```

---

### 2.4 向量执行单元修改

#### 2.4.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/vfpu/rtl/ct_vfpu_top.v` | 新增近似计算单元 | 中 |
| `gen_rtl/vfpu/rtl/ct_vfpu_dp.v` | 近似计算数据通路 | 中 |
| `gen_rtl/vfalu/rtl/ct_vfalu_dp_pipe6.v` | 近似计算执行 | 中 |

#### 2.4.2 具体修改点

**文件：ct_vfpu_dp.v**

**修改点1：新增近似计算单元接口**
```verilog
// 近似倒数估计单元
module vfpu_frece7 (
  input   [63:0]  src0,
  output  [63:0]  result
);

  // 使用查找表实现
  // 7位精度的倒数估计
  // 可通过Newton-Raphson迭代提高精度
  
endmodule

// 近似平方根倒数估计单元
module vfpu_frsqrte7 (
  input   [63:0]  src0,
  output  [63:0]  result
);

  // 使用查找表实现
  // 7位精度的平方根倒数估计
  
endmodule
```

**修改点2：分数LMUL支持**
```verilog
// 在向量寄存器访问逻辑中添加分数LMUL支持
// 需要根据LMUL值计算实际使用的寄存器部分

always @(*) begin
  case (vlmul[2:0])
    3'b101:   // LMUL = 1/8
      elem_count = VLEN / (SEW * 8);
    3'b110:   // LMUL = 1/4
      elem_count = VLEN / (SEW * 4);
    3'b111:   // LMUL = 1/2
      elem_count = VLEN / (SEW * 2);
    3'b000:   // LMUL = 1
      elem_count = VLEN / SEW;
    3'b001:   // LMUL = 2
      elem_count = VLEN * 2 / SEW;
    3'b010:   // LMUL = 4
      elem_count = VLEN * 4 / SEW;
    3'b011:   // LMUL = 8
      elem_count = VLEN * 8 / SEW;
    default:
      elem_count = 0;
  endcase
end
```

---

### 2.5 向量访存单元修改

#### 2.5.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/lsu/rtl/ct_lsu_ld_ag.v` | 新增Fault-Only-First加载支持 | 中 |
| `gen_rtl/lsu/rtl/ct_lsu_sq_entry.v` | 向量访存指令处理 | 中 |
| `gen_rtl/lsu/rtl/ct_lsu_top.v` | 向量访存接口 | 中 |

#### 2.5.2 具体修改点

**文件：ct_lsu_ld_ag.v**

**修改点1：新增Fault-Only-First加载指令支持**
```verilog
// Fault-Only-First加载指令
// 在第一个错误时停止，不触发异常
// 用于处理向量长度不匹配的情况

wire  lsiq_vleff;  // Fault-Only-First加载标志

always @(*) begin
  if (lsiq_vleff && memory_fault) begin
    // 停止后续元素加载
    // 更新vl寄存器为成功加载的元素数量
    ld_stop = 1'b1;
  end
end
```

---

### 2.6 异常处理修改

#### 2.6.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/rtu/rtl/ct_rtu_rob_expt.v` | 向量异常处理 | 高 |
| `gen_rtl/rtu/rtl/ct_rtu_retire.v` | 向量指令提交 | 高 |

#### 2.6.2 具体修改点

**文件：ct_rtu_rob_expt.v**

**修改点1：新增向量异常类型**
```verilog
// 向量相关异常
wire  vector_illegal_vtype;  // 非法vtype设置
wire  vector_illegal_vstart; // 非法vstart值

always @(*) begin
  if (vector_illegal_vtype || vector_illegal_vstart) begin
    expt_vec = 1'b1;
    expt_cause = 32'h00000002;  // Illegal instruction
  end
end
```

---

## 3. 新增功能实现

### 3.1 标准向量扩展支持

#### 3.1.1 需要新增的文件

| 文件路径 | 功能描述 | 优先级 |
|---------|---------|--------|
| `gen_rtl/cp0/rtl/ct_cp0_vext_cfg.v` | 向量扩展配置模块 | 高 |

#### 3.1.2 具体实现

**文件：ct_cp0_vext_cfg.v**
```verilog
module ct_cp0_vext_cfg (
  output  [2:0]  vext_type,    // 扩展类型：Zve32x, Zve64d, V等
  output  [11:0] vlen_value,   // VLEN值
  output  [11:0] elen_value    // ELEN值
);

  // 根据配置选择向量扩展类型
  // Zve32x: ELEN=32, VLEN>=32, 仅整数
  // Zve64d: ELEN=64, VLEN>=64, 支持双精度浮点
  // V:      ELEN>=64, VLEN>=128, 完整向量扩展
  
  parameter VEXT_TYPE = "V";  // 可配置
  
  generate
    if (VEXT_TYPE == "Zve32x") begin
      assign vext_type  = 3'b001;
      assign elen_value = 12'd32;
      assign vlen_value = 12'd128;  // 示例值
    end else if (VEXT_TYPE == "Zve64d") begin
      assign vext_type  = 3'b010;
      assign elen_value = 12'd64;
      assign vlen_value = 12'd256;
    end else if (VEXT_TYPE == "V") begin
      assign vext_type  = 3'b100;
      assign elen_value = 12'd64;
      assign vlen_value = 12'd512;
    end
  endgenerate

endmodule
```

### 3.2 掩码和尾部处理优化

#### 3.2.1 需要修改的文件

| 文件路径 | 修改内容 | 优先级 |
|---------|---------|--------|
| `gen_rtl/vfpu/rtl/ct_vfpu_dp.v` | vma/vta字段处理 | 中 |

#### 3.2.2 具体实现

```verilog
// 根据vma和vta字段优化掩码和尾部处理
always @(*) begin
  if (vta && is_tail_element) begin
    // 尾部元素可以不清零，直接保持或写1
    tail_result = 64'hFFFFFFFFFFFFFFFF;  // agnostic模式
  end else begin
    // 尾部元素保持不变
    tail_result = original_value;
  end
  
  if (vma && is_mask_inactive) begin
    // 掩码非活跃元素可以不写
    mask_result = 64'hFFFFFFFFFFFFFFFF;  // agnostic模式
  end else begin
    // 掩码非活跃元素保持不变
    mask_result = original_value;
  end
end
```

---

## 4. 验证计划

### 4.1 单元测试

#### 4.1.1 CSR测试

| 测试项 | 测试内容 | 优先级 |
|--------|---------|--------|
| vcsr读写测试 | 验证vcsr寄存器的读写功能 | 高 |
| vlenb只读测试 | 验证vlenb寄存器返回正确的VLEN/8值 | 高 |
| vtype字段测试 | 验证vma、vta、vlmul字段的正确设置 | 高 |

#### 4.1.2 指令测试

| 测试项 | 测试内容 | 优先级 |
|--------|---------|--------|
| vsetivli指令测试 | 验证vsetivli指令的正确执行 | 高 |
| 分数LMUL测试 | 验证LMUL=1/8,1/4,1/2的正确性 | 高 |
| 近似计算测试 | 验证vfrece7、vfrsqrte7指令精度 | 中 |

### 4.2 集成测试

#### 4.2.1 向量指令序列测试

| 测试场景 | 测试内容 | 优先级 |
|---------|---------|--------|
| 混合宽度操作 | 测试不同SEW下的向量操作 | 高 |
| 分数LMUL混合使用 | 测试不同LMUL值的指令序列 | 高 |
| 掩码操作序列 | 测试vma/vta字段的影响 | 中 |

### 4.3 系统测试

#### 4.3.1 兼容性测试

| 测试项 | 测试内容 | 优先级 |
|--------|---------|--------|
| v0.7.1代码兼容性 | 验证v0.7.1代码能否在v1.0上运行 | 高 |
| 工具链兼容性 | 验证GCC/LLVM生成的v1.0代码 | 高 |

---

## 5. 实施时间表

### 5.1 阶段一：基础架构修改（2周）

| 任务 | 预计时间 | 负责模块 |
|------|---------|---------|
| CSR寄存器修改 | 3天 | cp0 |
| vtype寄存器修改 | 4天 | rtu, cp0 |
| 基础验证 | 3天 | 验证团队 |

### 5.2 阶段二：核心功能修改（3周）

| 任务 | 预计时间 | 负责模块 |
|------|---------|---------|
| 指令解码修改 | 5天 | idu, ifu |
| 向量执行单元修改 | 7天 | vfpu, vfalu |
| 核心功能验证 | 3天 | 验证团队 |

### 5.3 阶段三：扩展特性实现（2周）

| 任务 | 预计时间 | 负责模块 |
|------|---------|---------|
| 近似计算单元实现 | 4天 | vfpu |
| 分数LMUL支持 | 5天 | 多模块 |
| 扩展特性验证 | 1天 | 验证团队 |

### 5.4 阶段四：验证和优化（2周）

| 任务 | 预计时间 | 负责模块 |
|------|---------|---------|
| 系统级验证 | 5天 | 验证团队 |
| 性能优化 | 3天 | 设计团队 |
| 回归测试 | 2天 | 验证团队 |

**总计：9周**

---

## 6. 风险评估

### 6.1 技术风险

| 风险项 | 风险等级 | 缓解措施 |
|--------|---------|---------|
| 二进制不兼容 | 高 | 提供迁移指南，更新工具链 |
| 验证复杂度增加 | 中 | 增加验证资源，使用形式化验证 |
| 性能回退 | 中 | 性能基准测试，针对性优化 |

### 6.2 项目风险

| 风险项 | 风险等级 | 缓解措施 |
|--------|---------|---------|
| 时间延期 | 中 | 分阶段交付，优先核心功能 |
| 资源不足 | 低 | 提前规划，协调资源 |

---

## 7. 交付物清单

### 7.1 设计文档

- [ ] CSR寄存器设计文档
- [ ] vtype字段定义文档
- [ ] 指令解码设计文档
- [ ] 向量执行单元设计文档

### 7.2 RTL代码

- [ ] 修改后的RTL代码
- [ ] 新增模块RTL代码
- [ ] 代码审查报告

### 7.3 验证文档

- [ ] 验证计划
- [ ] 测试用例文档
- [ ] 验证报告

### 7.4 用户文档

- [ ] 升级指南
- [ ] 迁移手册
- [ ] 发布说明

---

## 8. 附录

### 8.1 关键文件清单

#### CSR相关文件
- `gen_rtl/cp0/rtl/ct_cp0_regs.v` - CSR寄存器定义
- `gen_rtl/cp0/rtl/ct_cp0_top.v` - CSR顶层模块
- `gen_rtl/cp0/rtl/ct_cp0_iui.v` - CSR接口模块

#### vtype相关文件
- `gen_rtl/rtu/rtl/ct_rtu_rob_entry.v` - ROB条目
- `gen_rtl/rtu/rtl/ct_rtu_rob_rt.v` - ROB退休逻辑
- `gen_rtl/rtu/rtl/ct_rtu_retire.v` - 指令提交
- `gen_rtl/iu/rtl/ct_iu_special.v` - 特殊指令处理

#### 指令解码相关文件
- `gen_rtl/idu/rtl/ct_idu_ir_decd.v` - 指令解码
- `gen_rtl/ifu/rtl/ct_ifu_decd_normal.v` - 预解码

#### 向量执行相关文件
- `gen_rtl/vfpu/rtl/ct_vfpu_top.v` - 向量浮点单元顶层
- `gen_rtl/vfpu/rtl/ct_vfpu_dp.v` - 向量浮点数据通路
- `gen_rtl/vfalu/rtl/ct_vfalu_dp_pipe6.v` - 向量ALU数据通路

#### 向量访存相关文件
- `gen_rtl/lsu/rtl/ct_lsu_ld_ag.v` - 加载地址生成
- `gen_rtl/lsu/rtl/ct_lsu_sq_entry.v` - 存储队列条目
- `gen_rtl/lsu/rtl/ct_lsu_top.v` - LSU顶层

### 8.2 参考资料

1. RISC-V向量扩展v0.7.1与v1.0差异分析.md
2. RISC-V "V" Vector Extension Version 1.0
3. OpenC910用户手册
4. RISC-V特权架构规范

---

**文档结束**
