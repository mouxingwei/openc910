# ct_idu_ir_decd 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_ir_decd |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_ir_decd.v |
| 功能描述 | IR阶段指令解码模块 |

### 1.2 功能描述

ct_idu_ir_decd 是指令解码单元的IR(Instruction Decode)阶段解码模块，负责：
- 指令类别识别(加载、存储、分支、跳转等)
- 向量指令识别和处理
- 浮点指令识别
- 特殊指令识别(CSR、系统调用等)
- 向量操作类型识别

### 1.3 设计特点

- 支持RVV向量指令扩展
- 支持向量除法指令
- 支持向量乘加指令
- 支持向量设置指令(vsetvl/vsetvli)
- 支持向量AMO操作

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| x_illegal | 1 | 非法指令标志 |
| x_opcode | 32 | 操作码输入 |
| x_type_alu | 1 | ALU类型指令标志 |
| x_type_staddr | 1 | 存储地址类型 |
| x_type_vload | 1 | 向量加载类型 |
| x_vsew | 3 | 向量元素宽度 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| x_alu_short | 1 | 短ALU指令 |
| x_bar | 1 | 分支指令 |
| x_bar_type | 4 | 分支类型编码 |
| x_csr | 1 | CSR指令 |
| x_ecall | 1 | 环境调用指令 |
| x_fp | 1 | 浮点指令 |
| x_load | 1 | 加载指令 |
| x_mfvr | 1 | 移动向量寄存器 |
| x_mtvr | 1 | 移动到向量寄存器 |
| x_pcall | 1 | 过程调用 |
| x_pcfifo | 1 | PC FIFO指令 |
| x_rts | 1 | 返回指令 |
| x_store | 1 | 存储指令 |
| x_str | 1 | 字符串指令 |
| x_sync | 1 | 同步指令 |
| x_unit_stride | 1 | 单位步长向量指令 |
| x_vamo | 1 | 向量原子操作 |
| x_vdiv | 1 | 向量除法 |
| x_vec | 1 | 向量指令 |
| x_viq_srcv12_switch | 1 | VIQ源切换 |
| x_vmla_short | 1 | 短向量乘加 |
| x_vmla_type | 3 | 向量乘加类型 |
| x_vmul | 1 | 向量乘法 |
| x_vmul_unsplit | 1 | 非分裂向量乘法 |
| x_vsetvl | 1 | 向量设置vl |
| x_vsetvli | 1 | 向量设置vli |
| x_vsetivli | 1 | 向量设置ivli |

## 3. 指令类型说明

### 3.1 基础指令类型

| 输出信号 | 描述 |
|----------|------|
| x_load | 内存加载指令 |
| x_store | 内存存储指令 |
| x_bar | 分支跳转指令 |
| x_fp | 浮点操作指令 |

### 3.2 向量指令类型

| 输出信号 | 描述 |
|----------|------|
| x_vec | 向量指令标志 |
| x_vmul | 向量乘法 |
| x_vdiv | 向量除法 |
| x_vmla_short | 短向量乘加 |
| x_unit_stride | 单位步长向量加载/存储 |
| x_vamo | 向量原子操作 |
| x_vsetvl/vli | 向量长度设置 |

### 3.3 控制传输指令

| 输出信号 | 描述 |
|----------|------|
| x_rts | 函数返回 |
| x_pcall | 过程调用 |
| x_ecall | 环境调用 |
| x_csr | CSR访问 |

## 4. RVV相关性分析

### 4.1 向量指令类型识别

本模块是RVV向量指令识别的重要阶段，通过多个信号识别向量指令：

| 向量信号 | 说明 | 典型RVV指令 |
|----------|------|-------------|
| x_vec | 向量指令总标志 | 所有向量指令 |
| x_vmul | 向量乘法 | vmul.vv, vmul.vx |
| x_vdiv | 向量除法 | vdiv.vv, vdiv.vx |
| x_vmla_short | 短向量乘加 | vmadd.vv, vnmsub.vv |
| x_unit_stride | 单位步长向量加载/存储 | vle.v, vse.v |
| x_vamo | 向量原子操作 | vamo*.v |
| x_vsetvl/vli/ivli | 向量配置指令 | vsetvl, vsetvli, vsetivli |

### 4.2 向量配置指令

| 指令 | 信号 | 说明 |
|------|------|------|
| vsetvl | x_vsetvl | 根据vl寄存器值动态配置 |
| vsetvli | x_vsetvli | 使用立即数配置vl |
| vsetivli | x_vsetivli | 使用立即数配置vl(imm) |

### 4.3 向量操作分类

```
向量指令类型
├── 算术操作 (x_vec)
│   ├── 乘法 (x_vmul)
│   ├── 除法 (x_vdiv)
│   └── 乘加 (x_vmla_short)
├── 加载/存储
│   └── 单位步长 (x_unit_stride)
├── 原子操作 (x_vamo)
└── 配置指令 (x_vsetvl/vli/ivli)
```

## 5. RVV 1.0指令集修改点

### 5.1 向量指令识别变更

RVV 1.0对向量指令识别的主要修改：

| 修改项 | 说明 |
|--------|------|
| vsetvli/vsetivli | 新增立即数形式的vset配置指令 |
| 向量归约 | 优化归约指令的流水线分配 |
| 向量掩码 | 严格化掩码指令的语义 |

### 5.2 新增向量信号

RVV 1.0新增的输出信号：

| 信号 | 位宽 | 说明 |
|------|------|------|
| x_vsetivli | 1 | 立即数vset配置指令标志 |
| x_viq_srcv12_switch | 1 | VIQ源切换(1:vs1, 2:vs2) |
| x_vmul_unsplit | 1 | 非分裂向量乘法标志 |

### 5.3 向量除法支持

RVV 1.0明确支持向量除法指令：

| 指令 | 操作数格式 |
|------|-----------|
| vdiv.vv | 向量-向量 |
| vdiv.vx | 向量-标量 |
| vdivu.vv | 无符号向量-向量 |
| vdivu.vx | 无符号向量-标量 |
| vrem.vv | 向量-向量余数 |
| vrem.vx | 向量-标量余数 |

### 5.4 向量乘加类型 (x_vmla_type)

| 类型值 | 操作 | 说明 |
|--------|------|------|
| 3'b000 | vmadd | 乘加 |
| 3'b001 | vnmsub | 乘减(后减) |
| 3'b010 | vmacc | 乘累加 |
| 3'b011 | vnmsac | 乘累减(后减) |

## 6. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.1 | 2026-04-01 | Auto-generated | 添加RVV相关性分析和1.0修改点 |
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
