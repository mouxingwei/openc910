# IFU (Instruction Fetch Unit) 取指单元

## 1. 模块功能说明

IFU (Instruction Fetch Unit) 是 OpenC910 处理器的取指单元，负责从指令存储器中获取指令并传递给 IDU 进行译码。IFU 实现了高性能的指令获取机制，包括：

- **指令缓存 (ICache)**: 16KB 4路组相联指令缓存，支持预取和预译码
- **分支预测**: 包含 BTB (Branch Target Buffer)、BHT (Branch History Table)、RAS (Return Address Stack) 和间接跳转预测
- **指令缓冲**: 多级指令缓冲队列，支持乱序取指
- **PC 生成**: 支持顺序取指、分支跳转、异常处理等 PC 生成逻辑

### 主要特性

| 特性 | 描述 |
|------|------|
| ICache 容量 | 16KB, 4路组相联 |
| ICache 行大小 | 64 Bytes |
| BTB 条目数 | 1024 条目, 4路组相联 |
| BHT 条目数 | 2048 条目, 2位饱和计数器 |
| RAS 深度 | 16 层返回地址栈 |
| 预译码支持 | 支持 RVC 压缩指令预译码 |
| 向量扩展 | 支持 RVV 向量长度预测 |

## 2. 模块接口说明

### 2.1 接口列表

#### 与 BIU (总线接口单元) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_biu_rd_req | O | 1 | 读请求有效 |
| ifu_biu_rd_addr | O | 40 | 读地址 |
| ifu_biu_rd_size | O | 3 | 传输大小 |
| ifu_biu_rd_burst | O | 2 | 突发类型 |
| ifu_biu_rd_len | O | 2 | 突发长度 |
| ifu_biu_rd_cache | O | 4 | 缓存属性 |
| ifu_biu_rd_prot | O | 3 | 保护属性 |
| biu_ifu_rd_data | I | 128 | 读数据 |
| biu_ifu_rd_data_vld | I | 1 | 读数据有效 |
| biu_ifu_rd_grnt | I | 1 | 读请求授权 |
| biu_ifu_rd_last | I | 1 | 最后一个数据 |
| biu_ifu_rd_resp | I | 2 | 读响应 |

#### 与 IDU (译码单元) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_idu_ib_inst0_data | O | 73 | 指令0数据 |
| ifu_idu_ib_inst0_vld | O | 1 | 指令0有效 |
| ifu_idu_ib_inst1_data | O | 73 | 指令1数据 |
| ifu_idu_ib_inst1_vld | O | 1 | 指令1有效 |
| ifu_idu_ib_inst2_data | O | 73 | 指令2数据 |
| ifu_idu_ib_inst2_vld | O | 1 | 指令2有效 |
| idu_ifu_id_stall | I | 1 | ID 阶段暂停 |

#### 与 IU (整数单元) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| iu_ifu_chgflw_vld | I | 1 | 控制流改变有效 |
| iu_ifu_chgflw_pc | I | 63 | 控制流改变目标PC |
| iu_ifu_mispred_stall | I | 1 | 分支误预测暂停 |
| ifu_iu_pcfifo_create0_en | O | 1 | PC FIFO 创建0使能 |
| ifu_iu_pcfifo_create0_cur_pc | O | 40 | 当前PC |
| ifu_iu_pcfifo_create0_tar_pc | O | 40 | 目标PC |

#### 与 CP0 (协处理器) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_ifu_icache_en | I | 1 | ICache 使能 |
| cp0_ifu_icache_inv | I | 1 | ICache 失效 |
| cp0_ifu_btb_en | I | 1 | BTB 使能 |
| cp0_ifu_bht_en | I | 1 | BHT 使能 |
| cp0_ifu_ras_en | I | 1 | RAS 使能 |
| cp0_ifu_vl | I | 8 | 向量长度 |
| cp0_ifu_vlmul | I | 2 | 向量乘数 |
| cp0_ifu_vsew | I | 3 | 向量元素宽度 |

#### 与 MMU (内存管理单元) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| ifu_mmu_va | O | 63 | 虚拟地址 |
| ifu_mmu_va_vld | O | 1 | 虚拟地址有效 |
| mmu_ifu_pa | I | 28 | 物理地址 |
| mmu_ifu_pavld | I | 1 | 物理地址有效 |
| mmu_ifu_pgflt | I | 1 | 页错误 |

#### 与 RTU (提交单元) 的接口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| rtu_ifu_flush | I | 1 | 流水线冲刷 |
| rtu_ifu_chgflw_vld | I | 1 | 控制流改变有效 |
| rtu_ifu_chgflw_pc | I | 39 | 控制流改变目标PC |
| ifu_rtu_cur_pc | O | 39 | 当前PC |

### 2.2 模块参数

IFU 模块无参数配置。

## 3. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                         IFU Top                              │
                    │                                                             │
    ┌──────────┐    │  ┌──────────┐    ┌──────────┐    ┌──────────┐              │
    │   BIU    │◄───┼──│ ICache   │◄───│  PC Gen  │◄───│   BPU    │              │
    │ (总线)   │    │  │ Interface│    │          │    │(分支预测)│              │
    └──────────┘    │  └──────────┘    └──────────┘    └──────────┘              │
                    │        │               ▲               ▲                    │
                    │        ▼               │               │                    │
                    │  ┌──────────┐    ┌─────┴─────┐   ┌─────┴─────┐             │
                    │  │ PreDecode│    │    IB     │   │ BTB/BHT/  │             │
                    │  │  预译码   │───►│ 指令缓冲  │   │ RAS/IndBTB│             │
                    │  └──────────┘    └─────┬─────┘   └───────────┘             │
                    │                        │                                    │
                    └────────────────────────┼────────────────────────────────────┘
                                             │
                                             ▼
                                        ┌──────────┐
                                        │   IDU    │
                                        │ (译码单元)│
                                        └──────────┘
```

## 4. 模块实现方案

### 4.1 取指流水线

IFU 采用多级流水线结构实现指令获取：

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│  IF0    │──►│  IF1    │──►│  IF2    │──►│  ID     │──►│  IR     │
│ PC生成  │   │ 地址翻译 │   │ ICache  │   │ 指令缓冲 │   │ 指令发射 │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

**各级功能**:
- **IF0**: PC 生成，根据分支预测结果选择下一个取指地址
- **IF1**: 地址翻译，MMU 进行虚拟地址到物理地址的翻译
- **IF2**: ICache 访问，从指令缓存获取指令数据
- **ID**: 指令缓冲，暂存指令并传递给 IDU
- **IR**: 指令发射，将指令发射到 IDU 进行译码

### 4.2 分支预测机制

#### BTB (Branch Target Buffer)

```
┌─────────────────────────────────────────────────────────┐
│                    BTB 结构                              │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Tag Array (1024 entries × 4 ways)               │   │
│  │  - Tag[9:0]: PC[11:2] 的标签位                    │   │
│  │  - Valid: 条目有效位                              │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Data Array (1024 entries × 4 ways)              │   │
│  │  - Target[19:0]: 分支目标地址偏移                 │   │
│  │  - Pred[1:0]: 预测信息                           │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

#### BHT (Branch History Table)

```
┌─────────────────────────────────────────────────────────┐
│                    BHT 结构                              │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Pre-array (2048 entries)                        │   │
│  │  - 每条目 32 位，存储多个分支的预测状态            │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Sel-array (2048 entries)                        │   │
│  │  - 选择位，用于选择预测结果                       │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

#### RAS (Return Address Stack)

```
┌─────────────────────────────────────────────────────────┐
│                    RAS 结构                              │
│  ┌──────────────────────────────────────────────────┐   │
│  │  Stack (16 entries)                              │   │
│  │  - 存储函数调用返回地址                           │   │
│  │  - 支持 Push/Pop 操作                            │   │
│  │  - 支持 Speculative Push/Pop 和 Retire 确认      │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### 4.3 ICache 实现

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ICache 结构                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────┐  │
│  │   Tag Array     │  │  Data Array 0   │  │  Data Array 1       │  │
│  │  (4-way, 256组) │  │  (64-bit wide)  │  │  (64-bit wide)      │  │
│  └─────────────────┘  └─────────────────┘  └─────────────────────┘  │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │              PreDecode Array (预译码信息)                    │    │
│  │  - 分支类型识别                                              │    │
│  │  - 压缩指令识别                                              │    │
│  └─────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

**ICache 参数**:
- 容量: 16KB
- 组织: 4路组相联，256组
- 行大小: 64 Bytes
- 替换策略: 伪 LRU
- 写策略: 只读，无写操作

## 5. 内部关键信号列表

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| addrgen_pcgen_pc | 39 | PC 生成器输出的 PC |
| addrgen_xx_pcload | 1 | PC 加载信号 |
| bht_ipdp_pre_array_data_taken | 32 | BHT 预测 taken 数据 |
| bht_ipdp_pre_array_data_ntake | 32 | BHT 预测 not taken 数据 |
| btb_ifdp_way0_vld | 1 | BTB Way0 有效 |
| btb_ifdp_way0_target | 20 | BTB Way0 目标地址 |
| bht_ifctrl_inv_done | 1 | BHT 失效完成 |
| btb_ifctrl_inv_done | 1 | BTB 失效完成 |

## 6. 模块表项设置

| 表项名称 | 域段内容 | RAM资源 |
|----------|----------|---------|
| ICache Tag Array | Tag[19:0], Valid, LRU | 256×23×4 |
| ICache Data Array 0 | Data[127:0] | 256×128×4 |
| ICache Data Array 1 | Data[127:0] | 256×128×4 |
| PreDecode Array | PreDecode[127:0] | 256×128×4 |
| BTB Tag Array | Tag[9:0], Valid | 1024×11×4 |
| BTB Data Array | Target[19:0], Pred[1:0] | 1024×22×4 |
| BHT Pre Array | PreData[31:0] | 2048×32 |
| BHT Sel Array | SelData[1:0] | 2048×2 |
| Indirect BTB | Target[39:0] | 64×40 |
| L0 BTB | Target[39:0], Tag | 16×50 |

## 7. 子模块方案

| 子模块名称 | 功能描述 | 文档链接 |
|------------|----------|----------|
| ct_ifu_pcgen | PC 生成器 | [pcgen.md](./ifu/ct_ifu_pcgen.md) |
| ct_ifu_addrgen | 地址生成器 | [addrgen.md](./ifu/ct_ifu_addrgen.md) |
| ct_ifu_icache_if | ICache 接口 | [icache_if.md](./ifu/ct_ifu_icache_if.md) |
| ct_ifu_ibuf | 指令缓冲 | [ibuf.md](./ifu/ct_ifu_ibuf.md) |
| ct_ifu_btb | 分支目标缓冲 | [btb.md](./ifu/ct_ifu_btb.md) |
| ct_ifu_bht | 分支历史表 | [bht.md](./ifu/ct_ifu_bht.md) |
| ct_ifu_ras | 返回地址栈 | [ras.md](./ifu/ct_ifu_ras.md) |
| ct_ifu_ind_btb | 间接跳转预测 | [ind_btb.md](./ifu/ct_ifu_ind_btb.md) |
| ct_ifu_l0_btb | L0 BTB | [l0_btb.md](./ifu/ct_ifu_l0_btb.md) |
| ct_ifu_precode | 预译码 | [precode.md](./ifu/ct_ifu_precode.md) |
| ct_ifu_ibctrl | 指令缓冲控制 | [ibctrl.md](./ifu/ct_ifu_ibctrl.md) |
| ct_ifu_ifctrl | 取指控制 | [ifctrl.md](./ifu/ct_ifu_ifctrl.md) |

## 8. 可测试性设计

### 8.1 扫描链设计

- 所有触发器支持扫描链插入
- 支持 MBIST (Memory Built-In Self Test)
- 支持 ICache Tag/Data Array 的直接访问

### 8.2 调试支持

- 支持 HAD (Hardware Assisted Debug) 接口
- 支持指令地址断点匹配
- 支持程序计数器采样
- 支持 ICache 状态读取

### 8.3 性能计数

- ICache 访问计数
- ICache 缺失计数
- BTB 预测次数
- BTB 误预测次数
- 前端暂停周期

---

*文档生成时间: 2026-03-11*
*基于 OpenC910 RTL 代码自动生成*
