# RVV 1.0 升级规范

## Why
OpenC910 当前实现的向量扩展基于 RVV 0.7 版本，需要升级到 RVV 1.0 正式规范以支持最新的 RISC-V 向量标准，提高软件兼容性和生态支持。

## What Changes
- **BREAKING**: `vtype` CSR 格式变更
  - vlmul 从 2 位扩展为 3 位，支持分数 LMUL
  - v1.0 新增 `vma` (mask agnostic) 和 `vta` (tail agnostic) 字段
  - v1.0 移除 `vediv` 字段
  - `vill` 位置和语义调整
- **BREAKING**: 新增 `vlenb` CSR (0xC22) - 只读，返回 VLEN/8
- **BREAKING**: 新增 `vcsr` CSR (0x00F) - 向量控制状态寄存器
  - 包含 `vxrm` (向量定点舍入模式) 和 `vxsat` (向量定点饱和标志)
- 新增 `vsetivli` 指令支持
- `vsetvli` 行为变更: AVL=0 时 VL=0 (v0.7 为 VL=VLMAX)
- 尾部元素和屏蔽元素处理策略变更
- 掩码寄存器布局统一化

## Impact

### Affected specs
- 向量寄存器文件结构
- 向量执行单元 (VFPU, VFALU, VFMAU)
- CSR 寄存器文件 (CP0)
- 指令译码单元 (IDU)
- 取指单元分支预测 (IFU)

### Affected code
- `C910_RTL_FACTORY/gen_rtl/cp0/` - CSR 寄存器定义和访问
- `C910_RTL_FACTORY/gen_rtl/idu/` - 指令译码逻辑
- `C910_RTL_FACTORY/gen_rtl/vfpu/` - 向量执行单元
- `C910_RTL_FACTORY/gen_rtl/vfalu/` - 向量 ALU
- `C910_RTL_FACTORY/gen_rtl/vfmau/` - 向量乘加单元
- `C910_RTL_FACTORY/gen_rtl/rtu/` - 提交单元 (vsetvl 处理)

## ADDED Requirements

### Requirement: vtype CSR 升级
系统应支持 RVV 1.0 格式的 vtype CSR 寄存器。

#### Scenario: vtype 寄存器格式
- **WHEN** 读取 vtype CSR
- **THEN** 返回值格式为 `[vill][vma][vta][vsew[2:0]][vlmul[2:0]]`
- **AND** vill 位于最高位 (bit XLEN-1)
- **AND** vma 位于 bit 7
- **AND** vta 位于 bit 6
- **AND** vsew 位于 bits [4:2]
- **AND** vlmul 位于 bits [2:0]

### Requirement: 分数 LMUL 支持
系统应支持分数 LMUL (LMUL = 1/2, 1/4, 1/8)。

#### Scenario: 分数 LMUL 编码
- **WHEN** vlmul 设置为 101, 110, 或 111
- **THEN** LMUL 分别为 1/2, 1/4, 1/8
- **AND** VLMAX = LMUL * VLEN / SEW
- **AND** 向量寄存器组大小为 1

### Requirement: vlenb CSR 支持
系统应实现 vlenb CSR (地址 0xC22)。

#### Scenario: vlenb 读取
- **WHEN** 读取 vlenb CSR
- **THEN** 返回 VLEN/8 的值
- **AND** 该寄存器为只读

### Requirement: vcsr CSR 支持
系统应实现 vcsr CSR (地址 0x00F)。

#### Scenario: vcsr 访问
- **WHEN** 读取 vcsr CSR
- **THEN** 返回格式为 `bits[2:0] = {vxrm[1:0], vxsat}`
- **WHEN** 写入 vcsr CSR
- **THEN** 同时更新 vxrm 和 vxsat

### Requirement: 尾部/屏蔽元素策略
系统应支持 vta 和 vma 控制的尾部/屏蔽元素处理策略。

#### Scenario: 尾部元素处理
- **WHEN** vta = 0 (tail undisturbed)
- **THEN** 尾部元素保持原值不变
- **WHEN** vta = 1 (tail agnostic)
- **THEN** 尾部元素可被设置为任意值 (推荐为 1)

#### Scenario: 屏蔽元素处理
- **WHEN** vma = 0 (mask undisturbed)
- **THEN** 被屏蔽的元素保持原值不变
- **WHEN** vma = 1 (mask agnostic)
- **THEN** 被屏蔽的元素可被设置为任意值

### Requirement: vsetivli 指令支持
系统应支持 vsetivli 指令 (立即数 AVL 版本)。

#### Scenario: vsetivli 执行
- **WHEN** 执行 vsetivli 指令
- **THEN** AVL 来自指令立即数字段 (zimm5)
- **AND** 更新 vl 和 vtype 寄存器

### Requirement: vsetvli 行为变更
系统应实现 RVV 1.0 的 vsetvli 行为。

#### Scenario: AVL 为零
- **WHEN** vsetvli 的 AVL 参数为 0
- **THEN** vl 被设置为 0
- **AND** 不再设置为 VLMAX (v0.7 行为)

### Requirement: 掩码寄存器布局
掩码处理应符合 RVV 1.0 规范。

#### Scenario: 掩码位位置
- **WHEN** 使用向量掩码
- **THEN** 掩码位位于 v0 寄存器的最低有效位
- **AND** 掩码布局与 SEW/LMUL 无关 (移除 MLEN 概念)

## REMOVED Requirements

### Requirement: vediv 字段
**Reason**: RVV 1.0 移除了向量元素除法扩展 (EDIV)，该功能由编译器通过标准向量指令实现。
**Migration**: 移除 vtype 中的 vediv 字段及相关逻辑。

### Requirement: MLEN 概念
**Reason**: RVV 1.0 统一了掩码寄存器布局，不再需要 MLEN 概念。
**Migration**: 掩码位始终位于 v0[i]，移除 MLEN 相关计算逻辑。

## MODIFIED Requirements

### Requirement: vlmul 编码扩展
vtype 中的 vlmul 字段应从 2 位扩展为 3 位，支持 RVV 1.0 编码。

#### Scenario: vlmul 编码
- **WHEN** vlmul 设置为以下值
- **THEN** 对应的 LMUL 值:
  - 000: LMUL = 1
  - 001: LMUL = 2
  - 010: LMUL = 4
  - 011: LMUL = 8
  - 101: LMUL = 1/2 (新增)
  - 110: LMUL = 1/4 (新增)
  - 111: LMUL = 1/8 (新增)
  - 100: 保留 (设置 vill)

### Requirement: vill 语义调整
vill 位应位于 vtype 的最高位，语义保持不变但位置变更。

#### Scenario: vill 设置
- **WHEN** vsetvl{i} 指令尝试设置不支持的 vtype 值
- **THEN** vill 位设置为 1
- **AND** vtype 其他位清零
- **AND** 后续向量指令触发非法指令异常

### Requirement: VL 计算公式
VL 的计算应支持 RVV 1.0 规则。

#### Scenario: VL 计算
- **WHEN** 执行 vsetvl{i} 指令
- **THEN** VL = min(AVL, VLMAX)
- **AND** 当 AVL = 0 时，VL = 0 (RVV 1.0 变更)
- **AND** 当 AVL >= VLMAX 时，VL = VLMAX

### Requirement: 向量寄存器分组
向量寄存器分组应支持分数 LMUL。

#### Scenario: 分数 LMUL 寄存器分组
- **WHEN** LMUL 为分数 (1/2, 1/4, 1/8)
- **THEN** 单个向量寄存器可被多个逻辑向量寄存器共享
- **AND** VLMAX = LMUL * VLEN / SEW

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
