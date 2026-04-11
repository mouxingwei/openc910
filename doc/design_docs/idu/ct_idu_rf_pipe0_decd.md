# ct_idu_rf_pipe0_decd 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_rf_pipe0_decd |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_rf_pipe0_decd.v |
| 功能描述 | Pipe0流水线指令解码模块 |

### 1.2 功能描述

ct_idu_rf_pipe0_decd 是寄存器重命名阶段Pipe0的指令解码模块，负责：
- 立即数提取和解码
- 执行单元选择
- 功能码生成
- 立即数选择信号生成
- 指令操作数准备

### 1.3 设计特点

- 支持16位和32位指令解码
- 支持多种立即数格式
- 支持ALU、DIV、SPECIAL、CP0执行单元选择
- 立即数扩展到64位

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe0_decd_expt_vld | 1 | 异常有效标志 |
| pipe0_decd_opcode | 32 | 操作码输入 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| pipe0_decd_eu_sel | 4 | 执行单元选择 |
| pipe0_decd_func | 5 | 功能码 |
| pipe0_decd_imm | 6 | 立即数输出 |
| pipe0_decd_sel | 21 | 操作数选择 |
| pipe0_decd_src1_imm | 64 | 源操作数1立即数 |

## 3. 执行单元定义

| EU_SEL值 | 执行单元 | 说明 |
|----------|----------|------|
| 4'b0001 | ALU | 算术逻辑单元 |
| 4'b0010 | DIV | 除法单元 |
| 4'b0100 | SPECIAL | 特殊功能单元 |
| 4'b1000 | CP0 | 协处理器0 |

## 4. 立即数选择

| SEL值 | 立即数类型 | 位数 |
|-------|------------|------|
| 5'h01 | imm20 | 20位 |
| 5'h02 | imm12 | 12位 |
| 5'h04 | imm6 | 6位 |
| 5'h08 | caddisp | 压缩addi4spn |
| 5'h10 | caddi4spn | 压缩addi4spn |

## 5. 功能码定义

| 功能码 | 操作 |
|--------|------|
| ALU_SEL + ADDER_ADD | 加法 |
| ALU_SEL + ADDER_ADDW | 加法(字) |
| ALU_SEL + ADDER_SUB | 减法 |
| ALU_SEL + ADDER_SUBW | 减法(字) |
| ALU_SEL + ADDER_SLT | 有符号比较 |
| ALU_SEL + SHIFTER_SL | 左移 |

## 6. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
