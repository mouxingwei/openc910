# VFALU VPERM/VMISC 功能实现计划

## 1. 背景分析

### 1.1 IDU中的EU定义
在`ct_idu_rf_pipe6_decd.v`中已定义执行单元选择信号：
```verilog
parameter VALU                  = 12'b0000001_00000;
parameter VPERM                 = 12'b0000010_00000;
parameter VMISC                 = 12'b0000100_00000;
parameter VREDU                 = 12'b0001000_00000;
```

### 1.2 VMISC指令集（按IDU定义）
| 功能码 | 指令 | 说明 |
|--------|------|------|
| VAND | vand.vv/vx/vi | 位与操作 |
| VORR | vor.vv/vx/vi | 位或操作 |
| VXOR | vxor.vv/vx/vi | 位异或操作 |
| VMGE | vmerge | 合并操作 |
| VMOV | vmv.v | 移动操作 |
| VMAND | vmand.mm | 掩码与 |
| VMANDN | vmandn.mm | 掩码与非 |
| VMXOR | vmxor.mm | 掩码异或 |
| VMORR | vmor.mm | 掩码或 |
| VMNORR | vmnor.mm | 掩码非或 |
| VMORRN | vmorn.mm | 掩码或非 |
| VMNAND | vmnand.mm | 掩码与非 |
| VMPOP | vmpop.m | 掩码位计数 |
| VMFIRST | vfirst.m | 查找首个置位 |
| VMUNARY0 | vmsbf/vmsif/vmsof/viota/vid | 一元掩码操作 |

### 1.3 VPERM指令集（按IDU定义）
| 功能码 | 指令 | 说明 |
|--------|------|------|
| VEXT | vext.x.v | 提取元素 |
| VSLIDEUP | vslideup | 向上滑动 |
| VSLIDEDOWN | vslidedown | 向下滑动 |
| VSLIDE1UP | vslide1up | 带1位偏移上滑 |
| VSLIDE1DOWN | vslide1down | 带1位偏移下滑 |
| VRGATHERVV | vrgather.vv | 索引 gather |
| VRGATHERVK | vrgather.vx/vi | 索引 gather (scalar/imm) |
| VCOMPRESS | vcompress | 压缩操作 |

### 1.4 Func位域定义（来自IDU）
```verilog
// VPERM func [19:0]
parameter VEXT        = 20'b0000_0000_0000_0000_0001;
parameter VSLIDEUP    = 20'b0000_0000_0000_0100_1000;
parameter VSLIDEDOWN = 20'b0000_0000_0000_0010_1000;
parameter VSLIDE1UP   = 20'b0000_0000_0000_0101_0000;
parameter VSLIDE1DOWN = 20'b0000_0000_0000_0011_0000;
parameter VRGATHERVV  = 20'b0000_0000_0000_0000_1000;
parameter VRGATHERVK  = 20'b0000_0000_0100_0000_1000;
parameter VCOMPRESS   = 20'b0000_0000_0000_0000_1100;

// VMISC func [19:0]
parameter VAND    = 20'b0000_0000_0000_1000_0100;
parameter VORR    = 20'b0000_0000_0001_0000_0100;
parameter VXOR    = 20'b0000_0000_0010_0000_0100;
parameter VMGE    = 20'b0000_0000_0100_0000_0100;
parameter VMOV    = 20'b0000_0000_1000_0000_0100;
parameter VMAND   = 20'b0000_0000_0000_1000_1000;
parameter VMNAND  = 20'b0000_0000_0100_1000_1000;
parameter VMANDN  = 20'b0000_0000_1000_1000_1000;
parameter VMXOR   = 20'b0000_0000_0010_0000_1000;
parameter VMNXOR  = 20'b0000_0000_0110_0000_1000;
parameter VMORR   = 20'b0000_0000_0001_0000_1000;
parameter VMNORR  = 20'b0000_0000_0101_0000_1000;
parameter VMORRN  = 20'b0000_0000_1001_0000_1000;
parameter VMPOP   = 20'b0000_0000_0000_0011_0000;
parameter VMFIRST = 20'b0000_0000_0000_0101_0000;
parameter VMUNARY0= 20'b0000_0000_0000_1001_0000;
```

## 2. 现有VFALU模块结构

```
ct_vfalu_top_pipe6
├── ct_fadd_top       (FP 加法)
├── ct_fspu_top       (FP 标量/符号操作)
├── ct_freduct_top    (FP 归约)
├── ct_fwiden_top     (FP 扩展)
├── ct_fcnvt_top      (FP 格式转换)
└── ct_vfalu_dp_pipe6 (结果选择)
```

## 3. 实现方案

### 3.1 第一阶段：创建VMISC模块

#### 3.1.1 创建 `ct_vmisc_ctrl.v`
- 负责VMISC单元的流水线门控和控制信号
- 包含EX1-EX3的pipedown信号
- 类似于`ct_fspu_ctrl.v`的结构

#### 3.1.2 创建 `ct_vmisc_dp.v`
- 负责VMISC单元的数据通路处理
- 实现以下功能：
  - **位逻辑操作**: VAND, VORR, VXOR (vs2 & vs1, vs2 | vs1, vs2 ^ vs1)
  - **掩码操作**: VMAND, VMNAND, VMANDN, VMXOR, VMORR, VMNORR, VMORRN
  - **计数操作**: VMPOP (count population)
  - **查找操作**: VMFIRST (find first set)
  - **一元操作**: VMUNARY0 (vmsbf, vmsif, vmsof, viota, vid)

#### 3.1.3 创建 `ct_vmisc_top.v`
- VMISC子模块的顶层封装
- 实例化`ct_vmisc_ctrl`和`ct_vmisc_dp`

### 3.2 第二阶段：创建VPERM模块

#### 3.2.1 创建 `ct_vperm_ctrl.v`
- 负责VPERM单元的流水线门控和控制信号

#### 3.2.2 创建 `ct_vperm_dp.v`
- 负责VPERM单元的数据通路处理
- 实现以下功能：
  - **提取操作**: VEXT (vext.x.v)
  - **滑动操作**: VSLIDEUP, VSLIDEDOWN, VSLIDE1UP, VSLIDE1DOWN
  - **Gather操作**: VRGATHERVV, VRGATHERVK
  - **压缩操作**: VCOMPRESS

#### 3.2.3 创建 `ct_vperm_top.v`
- VPERM子模块的顶层封装
- 实例化`ct_vperm_ctrl`和`ct_vperm_dp`

### 3.3 第三阶段：修改顶层模块

#### 3.3.1 修改 `ct_vfalu_top_pipe6.v`
- 添加VMISC和VPERM模块实例
- 添加相应的forward信号
- 修改`ct_vfalu_dp_pipe6.v`添加结果选择逻辑

### 3.4 第四阶段：修改DP选择模块

#### 3.4.1 修改 `ct_vfalu_dp_pipe6.v`
- 添加VMISC和VPERM结果选择的mux逻辑

## 4. 接口信号定义

### 4.1 VMISC模块接口
```verilog
module ct_vmisc_top(
  // 时钟和复位
  input         cp0_vfpu_icg_en,
  input         cp0_yy_clk_en,
  input         cpurst_b,
  input         forever_cpuclk,
  input         pad_yy_icg_scan_en,

  // 数据输入
  input  [19:0] dp_vfalu_ex1_pipex_func,   // 功能码
  input  [2:0]  dp_vfalu_ex1_pipex_sel,     // 选择信号
  input  [63:0] dp_vfalu_ex1_pipex_srcf0,   // 源操作数0
  input  [63:0] dp_vfalu_ex1_pipex_srcf1,   // 源操作数1

  // 结果输出
  output        vmisc_forward_r_vld,
  output [63:0] vmisc_forward_result,
  output [63:0] vmisc_mfvr_data
);
```

### 4.2 VPERM模块接口
```verilog
module ct_vperm_top(
  // 时钟和复位
  input         cp0_vfpu_icg_en,
  input         cp0_yy_clk_en,
  input         cpurst_b,
  input         forever_cpuclk,
  input         pad_yy_icg_scan_en,

  // 数据输入
  input  [19:0] dp_vfalu_ex1_pipex_func,   // 功能码
  input  [2:0]  dp_vfalu_ex1_pipex_sel,     // 选择信号
  input  [63:0] dp_vfalu_ex1_pipex_srcf0,   // 源操作数0
  input  [63:0] dp_vfalu_ex1_pipex_srcf1,   // 源操作数1
  input  [63:0] dp_vfalu_ex1_pipex_mtvr_src0, // MTVR源

  // 结果输出
  output        vperm_forward_r_vld,
  output [63:0] vperm_forward_result,
  output [63:0] vperm_mfvr_data
);
```

## 5. 实现文件清单

| 序号 | 文件路径 | 说明 |
|------|----------|------|
| 1 | `vfalu/rtl/ct_vmisc_ctrl.v` | VMISC控制单元 |
| 2 | `vfalu/rtl/ct_vmisc_dp.v` | VMISC数据通路 |
| 3 | `vfalu/rtl/ct_vmisc_top.v` | VMISC顶层封装 |
| 4 | `vfalu/rtl/ct_vperm_ctrl.v` | VPERM控制单元 |
| 5 | `vfalu/rtl/ct_vperm_dp.v` | VPERM数据通路 |
| 6 | `vfalu/rtl/ct_vperm_top.v` | VPERM顶层封装 |
| 7 | `vfalu/rtl/ct_vfalu_top_pipe6.v` | 修改：添加实例化 |
| 8 | `vfalu/rtl/ct_vfalu_dp_pipe6.v` | 修改：添加结果选择 |

## 6. 流水线阶段

| 单元 | EX1 | EX2 | EX3 | EX4 | EX5 |
|------|-----|-----|-----|-----|-----|
| VMISC | 解码+执行 | 流水线寄存器 | 结果输出 | - | - |
| VPERM | 解码+索引计算 | 流水线寄存器 | Gather/Slide执行 | 结果输出 | - |

## 7. 关键设计要点

### 7.1 位逻辑操作实现
```verilog
// VAND: result = vs2 & vs1
assign ex1_vand_result = ex1_pipex_src0 & ex1_pipex_src1;

// VORR: result = vs2 | vs1
assign ex1_vorr_result = ex1_pipex_src0 | ex1_pipex_src1;

// VXOR: result = vs2 ^ vs1
assign ex1_vxor_result = ex1_pipex_src0 ^ ex1_pipex_src1;
```

### 7.2 掩码操作实现
```verilog
// VMAND: mask[i] = vs2[i] AND vs1[i]
assign ex1_vmand_result = ex1_pipex_src0 & ex1_pipex_src1;

// VMXOR: mask[i] = vs2[i] XOR vs1[i]
assign ex1_vmxor_result = ex1_pipex_src0 ^ ex1_pipex_src1;
```

### 7.3 Gather操作实现
```verilog
// VRGATHERVV: vd[i] = vs2[vs1[i]]
// 需要索引解码和选择逻辑
```

### 7.4 Slide操作实现
```verilog
// VSLIDEUP: vd[i+offset] = vs2[i] for i < VLMAX-offset
// 需要偏移量处理和数据移动逻辑
```

## 8. 验证要点

### 8.1 功能验证
- [ ] VAND/VORR/VXOR 基本位逻辑运算
- [ ] 掩码操作 (VMAND, VMXOR, VMOR等)
- [ ] VMPOP计数功能
- [ ] VMFIRST查找功能
- [ ] VRGATHER索引gather
- [ ] VSLIDEUP/VSLIDEDOWN滑动操作
- [ ] VCOMPRESS压缩操作

### 8.2 边界条件
- [ ] vl=0时的处理
- [ ] vstart非零时的处理
- [ ] 跨寄存器边界操作
- [ ] 索引超出范围时的处理

## 9. 风险评估

| 风险项 | 影响等级 | 缓解措施 |
|--------|----------|----------|
| VRGATHER索引复杂度高 | 中 | 使用查找表实现 |
| VCOMPRESS实现复杂度 | 高 | 分解为多个简单操作 |
| 与现有FP单元资源冲突 | 低 | VMISC/VPERM独立于FP流水线 |

## 10. 实施顺序

1. **第一阶段**: 创建VMISC模块（ct_vmisc_ctrl, ct_vmisc_dp, ct_vmisc_top）
2. **第二阶段**: 在ct_vfalu_top_pipe6.v中实例化VMISC
3. **第三阶段**: 创建VPERM模块（ct_vperm_ctrl, ct_vperm_dp, ct_vperm_top）
4. **第四阶段**: 在ct_vfalu_top_pipe6.v中实例化VPERM
5. **第五阶段**: 修改ct_vfalu_dp_pipe6.v添加结果选择
6. **第六阶段**: 功能验证和边界测试
