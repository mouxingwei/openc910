# ct_idu_id_decd_special 模块详细方案文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_idu_id_decd_special |
| 文件路径 | C910_RTL_FACTORY/gen_rtl _rvv1.0/idu/rtl/ct_idu_id_decd_special.v |
| 功能描述 | ID阶段特殊指令解码模块 |

### 1.2 功能描述

ct_idu_id_decd_special 是ID阶段特殊指令解码模块，负责：
- 指令分裂检测(长指令和短指令)
- Fence指令解码
- 原子操作(AMO)解码
- 索引加载/存储指令解码
- C-Sky特定扩展指令解码

### 1.3 设计特点

- 支持RISC-V标准压缩指令扩展
- 支持C-Sky EE特定指令
- 支持向量索引寻址指令
- 支持同步和缓存维护指令

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| cp0_idu_cskyee | 1 | C-Sky EE模式控制 |
| cp0_idu_frm | 3 | 浮点舍入模式 |
| cp0_idu_fs | 2 | 浮点状态控制 |
| x_inst | 32 | 指令输入 |

### 2.2 输出端口

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| x_fence | 1 | Fence指令标志 |
| x_fence_type | 3 | Fence类型编码 |
| x_split | 1 | 指令分裂标志 |
| x_split_long_type | 10 | 长指令分裂类型 |
| x_split_potnt | 3 | 分裂指针类型 |
| x_split_short | 1 | 短指令分裂标志 |
| x_split_short_potnt | 3 | 短分裂指针类型 |
| x_split_short_type | 7 | 短指令分裂类型编码 |

## 3. 解码类型说明

### 3.1 短指令分裂类型 (x_split_short_type)

| Bit | 类型 | 描述 |
|-----|------|------|
| [0] | jal with dest | 带目标寄存器的跳转指令(c.jalr) |
| [1] | FP compare/convert | 浮点比较和转换指令 |
| [2] | Indexed Load | 索引加载指令(lbix/lhia等) |
| [3] | Indexed Store | 索引存储指令(sbix/shia等) |

### 3.2 长指令分裂类型 (x_split_long_type)

| Bit | 类型 | 描述 |
|-----|------|------|
| [0] | Atomic Load/Store/AMO | 原子加载/存储/AMO指令 |
| [1] | Normal Vector | 普通向量指令 |
| [2] | Permute | 置换指令 |
| [3] | Vector Reduction | 向量归约指令 |
| [4] | Stride Vector Load/Store | 步长向量加载存储 |
| [5] | Index Vector Load/Store | 索引向量加载存储 |

### 3.3 Fence指令类型 (x_fence_type)

| Bit | 类型 | 描述 |
|-----|------|------|
| [0] | Sync/DCache | 同步指令和缓存清除 |
| [1] | CP0 Instruction | CP0特权指令 |
| [2] | Reserved | 保留 |

## 4. 支持的指令列表

### 4.1 索引加载指令
- lbib, lbia, lhib, lhia, lwib, lwia, ldib, ldia
- lbuib, lbuia, lhuib, lhuia, lwuib, lwuia

### 4.2 索引存储指令
- sbib, sbia, shib, shia, swib, swia, sdib, sdia

### 4.3 原子操作指令
- lr.w, lr.d (加载保留)
- sc.w, sc.d (条件存储)
- amoxor, amoor, amoand, amoadd
- amomin, amomax, amominu, amomaxu
- amoswap

## 4. RVV相关性分析

### 4.1 向量指令分裂类型

本模块通过`x_split_long_type`信号识别RVV向量指令分裂类型：

| Bit | 类型 | 描述 | RVV指令示例 |
|-----|------|------|-------------|
| [1] | Normal Vector | 普通向量指令 | vadd.vv, vsub.vv |
| [2] | Permute | 置换指令 | vrgather.vv |
| [3] | Vector Reduction | 向量归约指令 | vredsum.vs |
| [4] | Stride Vec Load/Store | 步长向量加载存储 | vlse.v, vsse.v |
| [5] | Index Vec Load/Store | 索引向量加载存储 | vluxei.v, vsuxei.v |

### 4.2 向量指令分裂流程

```
RVV指令解码 → x_split_long_type识别 → 分裂到对应流水线
                                            │
    ├── Normal Vector (bit[1]) → Pipe6/Pipe7
    ├── Permute (bit[2])       → Pipe6/Pipe7
    ├── Reduction (bit[3])     → Pipe6/Pipe7
    ├── Stride (bit[4])       → LSU Pipe
    └── Index (bit[5])        → LSU Pipe
```

## 5. RVV 1.0指令集修改点

### 5.1 分裂类型变更

RVV 1.0对指令分裂类型的重要变更：

| 修改项 | 说明 |
|--------|------|
| 向量AMO支持 | 新增`x_split_long_type[6]`用于向量原子操作 |
| Zvlsseg支持 | 新增`x_split_long_type[7]`用于分段加载 |
| 步长/索引变化 | 优化stride和index寻址模式识别 |

### 5.2 新增分裂类型

RVV 1.0新增的指令分裂类型：

| Bit | 类型 | 说明 |
|-----|------|------|
| [6] | Vector AMO | 向量原子操作指令 |
| [7] | Zvlsseg Unit | 分段加载单元指令 |
| [8] | Zvlsseg Stride | 分段步长加载指令 |
| [9] | Zvlsseg Index | 分段索引加载指令 |

### 5.3 C-Sky EE扩展

本模块支持C-Sky EE特定的索引加载/存储指令：

| 指令 | 格式 | 说明 |
|------|------|------|
| lbia/lbia | Indexed Byte | 索引字节加载 |
| lhia/lhia | Indexed Half | 索引半字加载 |
| lwia/lwud | Indexed Word | 索引字加载 |
| ldia/ldd | Indexed Dword | 索引双字加载 |

## 6. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.1 | 2026-04-01 | Auto-generated | 添加RVV相关性分析和1.0修改点 |
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
