# OpenC910 RVV 1.0 升级修改记录

## 文档信息
- **文档版本**: 1.0
- **创建日期**: 2026-04-01
- **修改人**: AI Assistant
- **基于文档**: RVV_0.7.1_to_1.0_升级计划.md

---

## 1. 已完成的修改

### 1.1 CSR寄存器修改

#### 1.1.1 ct_cp0_iui.v
**修改内容**:
- 新增VCSR寄存器地址定义: `parameter VCSR = 12'h00F;`
- 在iui_vs_inv逻辑中添加VCSR验证

**修改原因**: RVV 1.0新增VCSR寄存器，需要支持其地址解码和访问验证

#### 1.1.2 ct_cp0_regs.v
**修改内容**:
- 新增VCSR寄存器地址定义
- 扩展vtype_raw_vlmul从2位到3位
- 新增vtype_raw_vma和vtype_raw_vta字段
- 新增vcsr_value信号定义
- 添加VCSR读数据选择逻辑
- 修改vtype_value组合逻辑，包含vma和vta字段
- 扩展cp0_ifu_vlmul从2位到3位
- 新增cp0_idu_vma和cp0_idu_vta输出

**关键代码**:
```verilog
// vtype寄存器布局（v1.0）
// [XLEN-1]    : vill
// [XLEN-2:8]  : Reserved
// [7]         : vma
// [6]         : vta
// [5:3]       : vsew[2:0]
// [2:0]       : vlmul[2:0]

assign vtype_value[63:0] = {vtype_vill, 55'b0, vtype_vma, vtype_vta,
                            vtype_vsew[2:0], vtype_vlmul[2:0]};

// VCSR寄存器
assign vcsr_value[2:0] = {fcsr_vxrm[1:0], fcsr_vxsat};
```

#### 1.1.3 ct_cp0_top.v
**修改内容**:
- 扩展cp0_ifu_vlmul输出信号从2位到3位

### 1.2 ROB模块修改

#### 1.2.1 ct_rtu_rob_entry.v
**修改内容**:
- 扩展ROB_WIDTH从40位到42位
- 扩展vlmul字段从2位到3位
- 新增vma和vta字段
- 更新ROB参数定义:
  - ROB_VL_PRED = 41
  - ROB_VL = 40
  - ROB_VEC_DIRTY = 32
  - ROB_VSETVLI = 31
  - ROB_VSEW = 30
  - ROB_VLMUL = 27 (3位)
  - ROB_VMA = 26
  - ROB_VTA = 25
  - 其他参数相应调整

**修改原因**: 支持RVV 1.0的vtype字段扩展，包括3位vlmul和新增的vma/vta字段

#### 1.2.2 ct_rtu_rob.v
**修改内容**:
- 更新ROB参数定义与ct_rtu_rob_entry.v一致
- 扩展idu_rtu_rob_create*_data信号位宽从40位到42位

#### 1.2.3 ct_rtu_retire.v
**修改内容**:
- 扩展rtu_cp0_vsetvl_vlmul输出从2位到3位
- 新增rtu_cp0_vsetvl_vma和rtu_cp0_vsetvl_vta输出
- 扩展rob_retire_inst*_vlmul输入从2位到3位
- 新增rob_retire_inst*_vma和rob_retire_inst*_vta输入
- 更新vsetvl指令处理逻辑，支持vma和vta字段

**关键代码**:
```verilog
// vsetvl指令的vtype字段提取（v1.0）
if(retire_inst0_vsetvlx) begin
  rtu_cp0_vsetvl_vlmul[2:0] = rob_retire_inst0_mtval[2:0];
  rtu_cp0_vsetvl_vsew[2:0]  = rob_retire_inst0_mtval[5:3];
  rtu_cp0_vsetvl_vta        = rob_retire_inst0_mtval[6];
  rtu_cp0_vsetvl_vma        = rob_retire_inst0_mtval[7];
  rtu_cp0_vsetvl_vl[7:0]    = rob_retire_inst0_mtval[12:5];
end
```

#### 1.2.4 ct_rtu_rob_rt.v
**修改内容**:
- 扩展rob_retire_inst*_vlmul输出从2位到3位
- 新增rob_retire_inst*_vma和rob_retire_inst*_vta输出
- 更新retire_inst*_data位段提取逻辑

---

## 2. 待完成的修改

### 2.1 指令解码修改（阶段三）- 已完成

需要修改的文件:
- `gen_rtl/idu/rtl/ct_idu_ir_decd.v` - 新增vsetivli指令解码 ✅
- `gen_rtl/ifu/rtl/ct_ifu_decd_normal.v` - 向量指令预解码
- `gen_rtl/idu/rtl/ct_idu_ir_dp.v` - 数据通路支持 ✅

**已完成的修改**:
- ct_idu_ir_decd.v:
  - 新增vsetivli指令解码逻辑
  - 添加x_vsetivli输出端口
  - vsetivli编码: bit[31:30]=11, funct3=111, opcode=1010111
- ct_idu_ir_dp.v:
  - 新增IS_VSETIVLI参数定义
  - 添加ir_inst*_vsetivli信号
  - 添加dp_ir_inst*_data[IS_VSETIVLI]赋值
  - 调整IS_VSEW和IS_VLMUL参数值避免冲突

### 2.2 向量执行单元修改（阶段四）

需要修改的文件:
- `gen_rtl/vfpu/rtl/ct_vfpu_top.v` - 新增近似计算单元
- `gen_rtl/vfpu/rtl/ct_vfpu_dp.v` - 近似计算数据通路

**修改说明**:
近似计算单元（vfrece7, vfrsqrte7）是RVV 1.0新增的指令，需要新增硬件模块支持：
- vfrece7: 7位精度的倒数估计
- vfrsqrte7: 7位精度的平方根倒数估计

**实现方案**:
使用查找表（LUT）实现近似计算，可通过Newton-Raphson迭代提高精度。

**分数LMUL支持**:
需要在向量寄存器访问逻辑中添加分数LMUL（1/8, 1/4, 1/2）的支持。

**状态**: 需要进一步设计和实现

### 2.3 向量访存单元修改（阶段五）

需要修改的文件:
- `gen_rtl/lsu/rtl/ct_lsu_ld_ag.v` - 新增Fault-Only-First加载支持

**修改说明**:
Fault-Only-First (FOF) 加载指令是RVV 1.0新增的特性：
- 在第一个元素访问出错时停止加载
- 不触发异常，而是更新vl寄存器为成功加载的元素数量
- 用于处理向量长度不匹配的情况

**实现要点**:
1. 检测FOF加载指令标志
2. 在内存访问错误时停止后续元素加载
3. 更新vl寄存器为成功加载的元素数量

**状态**: 需要进一步设计和实现

### 2.4 异常处理修改（阶段六）

需要修改的文件:
- `gen_rtl/rtu/rtl/ct_rtu_rob_expt.v` - 向量异常处理

**修改说明**:
需要新增向量相关的异常类型处理：
- 非法vtype设置异常
- 非法vstart值异常

**状态**: 需要进一步设计和实现

---

## 3. 关键技术决策

### 3.1 ROB数据位宽扩展
- **决策**: 将ROB_WIDTH从40位扩展到42位
- **原因**: 需要新增2位来支持vma和vta字段，同时保持vlmul从2位扩展到3位
- **影响**: 所有使用ROB数据的模块需要更新信号位宽

### 3.2 vtype字段布局
- **决策**: 采用RVV 1.0标准的vtype字段布局
- **布局**:
  - [2:0] vlmul (3位，支持分数LMUL)
  - [5:3] vsew
  - [6] vta
  - [7] vma
  - [XLEN-1] vill

### 3.3 VCSR寄存器实现
- **决策**: VCSR作为VXSAT和VXRM的镜像寄存器
- **实现**: vcsr[0] = vxsat, vcsr[2:1] = vxrm
- **原因**: 符合RVV 1.0规范，允许通过单一寄存器访问向量固定点舍入和饱和模式

---

## 4. 验证要点

### 4.1 CSR寄存器验证
- [ ] VCSR读写功能正确
- [ ] VCSR与VXSAT/VXRM同步正确
- [ ] vtype字段设置正确
- [ ] vma/vta字段读写正确

### 4.2 指令验证
- [ ] vsetvli指令正确设置vtype和vl
- [ ] vsetvl指令正确处理vma/vta字段
- [ ] 分数LMUL支持正确

### 4.3 兼容性验证
- [ ] v0.7.1代码在修改后硬件上行为正确
- [ ] 工具链生成的v1.0代码正确执行

---

## 5. 注意事项

1. **位段重新分配**: ROB参数位置发生了变化，需要确保所有相关模块的位段提取逻辑同步更新
2. **信号位宽**: 多个信号的位宽发生了变化，需要确保所有连接点都正确更新
3. **向后兼容**: 需要确保修改不影响现有v0.7.1代码的执行

---

**文档结束**
