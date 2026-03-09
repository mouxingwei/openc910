# OpenC910 一级模块文档：访存单元 (LSU)

## 1. 模块概述

访存单元 (Load Store Unit, LSU) 是 OpenC910 处理器的数据访问核心，负责所有内存加载和存储操作。LSU 包含数据缓存、访存流水线、写缓冲和一致性维护逻辑，支持乱序访存和内存一致性协议。

### 1.1 主要功能

- Load/Store 指令执行
- 数据缓存管理
- 地址计算与对齐处理
- 内存一致性维护
- 原子操作支持
- 预取支持

## 2. 模块接口

### 2.1 与 IDU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| idu_lsu_rf_pipe3_sel | I | 1 | Load 发射选择 |
| idu_lsu_rf_pipe3_src0 | I | 64 | Load 基地址 |
| idu_lsu_rf_pipe3_offset | I | 12 | Load 偏移量 |
| idu_lsu_rf_pipe3_inst_type | I | 3 | 访存类型 |
| idu_lsu_rf_pipe3_inst_size | I | 2 | 访存大小 |
| idu_lsu_rf_pipe4_sel | I | 1 | Store 发射选择 |
| idu_lsu_rf_pipe4_src0 | I | 64 | Store 基地址 |
| idu_lsu_rf_pipe4_src1 | I | 64 | Store 数据 |

### 2.2 与 BIU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| lsu_biu_ar_addr | O | 40 | 读地址 |
| lsu_biu_ar_req | O | 1 | 读请求 |
| lsu_biu_ar_ready | I | 1 | 读就绪 |
| lsu_biu_r_data | I | 128 | 读数据 |
| lsu_biu_r_vld | I | 1 | 读数据有效 |
| lsu_biu_aw_st_addr | O | 40 | 写地址 |
| lsu_biu_aw_st_req | O | 1 | 写请求 |
| lsu_biu_w_st_data | O | 128 | 写数据 |
| lsu_biu_w_st_vld | O | 1 | 写数据有效 |

### 2.3 与 MMU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| lsu_mmu_va0 | O | 64 | 虚拟地址0 |
| lsu_mmu_va0_vld | O | 1 | VA0有效 |
| mmu_lsu_pa0 | I | 28 | 物理地址0 |
| mmu_lsu_pa0_vld | I | 1 | PA0有效 |
| mmu_lsu_page_fault0 | I | 1 | 页错误标志 |

### 2.4 与 RTU 的接口

| 信号名称 | 方向 | 位宽 | 功能描述 |
|---------|------|------|---------|
| lsu_rtu_wb_pipe3_cmplt | O | 1 | Load 完成标志 |
| lsu_rtu_wb_pipe3_iid | O | 7 | 指令ID |
| lsu_rtu_wb_pipe3_expt_vld | O | 1 | 异常有效 |
| lsu_rtu_wb_pipe3_expt_vec | O | 5 | 异常向量 |
| lsu_rtu_wb_pipe4_cmplt | O | 1 | Store 完成标志 |

## 3. 内部架构

```
┌─────────────────────────────────────────────────────────────────────┐
│                           ct_lsu_top                                 │
├─────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      AG 阶段 (地址生成)                      │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_lsu_ld_ag  │  │ct_lsu_st_ag  │                        │   │
│  │  │  Load AG     │  │  Store AG    │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      DA 阶段 (数据访问)                      │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_lsu_ld_da  │  │ct_lsu_st_da  │                        │   │
│  │  │  Load DA     │  │  Store DA    │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      DC 阶段 (数据缓存)                      │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_lsu_ld_dc  │  │ct_lsu_st_dc  │                        │   │
│  │  │  Load DC     │  │  Store DC    │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      WB 阶段 (写回)                          │   │
│  │  ┌──────────────┐  ┌──────────────┐                        │   │
│  │  │ct_lsu_ld_wb  │  │ct_lsu_st_wb  │                        │   │
│  │  │  Load WB     │  │  Store WB    │                        │   │
│  │  └──────────────┘  └──────────────┘                        │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      D-Cache 子系统                          │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ct_lsu_dcache_│  │ct_lsu_dcache_│  │ct_lsu_dcache_│      │   │
│  │  │   top        │  │  data_array  │  │  tag_array   │      │   │
│  │  │  DCache顶层  │  │   数据阵列   │  │   标签阵列   │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      缓冲与队列                               │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ ct_lsu_lq    │  │ ct_lsu_sq    │  │ ct_lsu_wmb   │      │   │
│  │  │  Load队列    │  │  Store队列   │  │  写合并缓冲  │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ ct_lsu_lfb   │  │ ct_lsu_rb    │  │ ct_lsu_vb    │      │   │
│  │  │ 行填充缓冲   │  │ 重放缓冲     │  │ 牺牲缓冲     │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      一致性维护                               │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │   │
│  │  │ ct_lsu_icc   │  │ct_lsu_snoop_*│  │ ct_lsu_mcic  │      │   │
│  │  │ Cache一致性  │  │  Snoop逻辑   │  │ 多核一致性   │      │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘      │   │
│  └─────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## 4. 二级模块列表

### 4.1 流水线阶段模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_ld_ag | ct_lsu_ld_ag.v | Load 地址生成阶段 |
| ct_lsu_ld_da | ct_lsu_ld_da.v | Load 数据访问阶段 |
| ct_lsu_ld_dc | ct_lsu_ld_dc.v | Load 数据缓存阶段 |
| ct_lsu_ld_wb | ct_lsu_ld_wb.v | Load 写回阶段 |
| ct_lsu_st_ag | ct_lsu_st_ag.v | Store 地址生成阶段 |
| ct_lsu_st_da | ct_lsu_st_da.v | Store 数据访问阶段 |
| ct_lsu_st_dc | ct_lsu_st_dc.v | Store 数据缓存阶段 |
| ct_lsu_st_wb | ct_lsu_st_wb.v | Store 写回阶段 |

### 4.2 数据缓存模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_dcache_top | ct_lsu_dcache_top.v | D-Cache 顶层 |
| ct_lsu_dcache_arb | ct_lsu_dcache_arb.v | D-Cache 仲裁 |
| ct_lsu_dcache_data_array | ct_lsu_dcache_data_array.v | 数据阵列 |
| ct_lsu_dcache_tag_array | ct_lsu_dcache_tag_array.v | 标签阵列 |
| ct_lsu_dcache_ld_tag_array | ct_lsu_dcache_ld_tag_array.v | Load标签阵列 |
| ct_lsu_dcache_dirty_array | ct_lsu_dcache_dirty_array.v | 脏位阵列 |
| ct_lsu_dcache_info_update | ct_lsu_dcache_info_update.v | Cache信息更新 |

### 4.3 队列与缓冲模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_lq | ct_lsu_lq.v | Load 队列 |
| ct_lsu_lq_entry | ct_lsu_lq_entry.v | Load 队列表项 |
| ct_lsu_sq | ct_lsu_sq.v | Store 队列 |
| ct_lsu_sq_entry | ct_lsu_sq_entry.v | Store 队列表项 |
| ct_lsu_wmb | ct_lsu_wmb.v | 写合并缓冲 |
| ct_lsu_wmb_entry | ct_lsu_wmb_entry.v | WMB 表项 |
| ct_lsu_wmb_ce | ct_lsu_wmb_ce.v | WMB 一致性 |
| ct_lsu_lfb | ct_lsu_lfb.v | 行填充缓冲 |
| ct_lsu_lfb_addr_entry | ct_lsu_lfb_addr_entry.v | LFB 地址表项 |
| ct_lsu_lfb_data_entry | ct_lsu_lfb_data_entry.v | LFB 数据表项 |
| ct_lsu_rb | ct_lsu_rb.v | 重放缓冲 |
| ct_lsu_rb_entry | ct_lsu_rb_entry.v | RB 表项 |
| ct_lsu_vb | ct_lsu_vb.v | 牺牲缓冲 |
| ct_lsu_vb_addr_entry | ct_lsu_vb_addr_entry.v | VB 地址表项 |
| ct_lsu_vb_sdb_data | ct_lsu_vb_sdb_data.v | VB 数据存储 |
| ct_lsu_vb_sdb_data_entry | ct_lsu_vb_sdb_data_entry.v | VB 数据表项 |

### 4.4 一致性维护模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_icc | ct_lsu_icc.v | Cache一致性控制器 |
| ct_lsu_mcic | ct_lsu_mcic.v | 多核一致性接口 |
| ct_lsu_snoop_ctcq | ct_lsu_snoop_ctcq.v | Snoop CTC队列 |
| ct_lsu_snoop_ctcq_entry | ct_lsu_snoop_ctcq_entry.v | Snoop CTCQ表项 |
| ct_lsu_snoop_snq | ct_lsu_snoop_snq.v | Snoop SN队列 |
| ct_lsu_snoop_snq_entry | ct_lsu_snoop_snq_entry.v | Snoop SNQ表项 |
| ct_lsu_snoop_req_arbiter | ct_lsu_snoop_req_arbiter.v | Snoop请求仲裁 |
| ct_lsu_snoop_resp | ct_lsu_snoop_resp.v | Snoop响应 |

### 4.5 预取模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_pfu | ct_lsu_pfu.v | 预取单元 |
| ct_lsu_pfu_gpfb | ct_lsu_pfu_gpfb.v | 全局预取缓冲 |
| ct_lsu_pfu_gsdb | ct_lsu_pfu_gsdb.v | 全局流检测缓冲 |
| ct_lsu_pfu_pfb_entry | ct_lsu_pfu_pfb_entry.v | 预取缓冲表项 |
| ct_lsu_pfu_pmb_entry | ct_lsu_pfu_pmb_entry.v | 预取标记表项 |
| ct_lsu_pfu_sdb_entry | ct_lsu_pfu_sdb_entry.v | 流检测表项 |
| ct_lsu_pfu_sdb_cmp | ct_lsu_pfu_sdb_cmp.v | 流检测比较 |
| ct_lsu_pfu_pfb_l1sm | ct_lsu_pfu_pfb_l1sm.v | L1预取状态机 |
| ct_lsu_pfu_pfb_l2sm | ct_lsu_pfu_pfb_l2sm.v | L2预取状态机 |
| ct_lsu_pfu_pfb_tsm | ct_lsu_pfu_pfb_tsm.v | 预取训练状态机 |

### 4.6 其他模块

| 模块名称 | 文件 | 功能描述 |
|---------|------|---------|
| ct_lsu_ctrl | ct_lsu_ctrl.v | LSU 控制逻辑 |
| ct_lsu_amr | ct_lsu_amr.v | 原子操作寄存器 |
| ct_lsu_lm | ct_lsu_lm.v | 锁定机制 |
| ct_lsu_bus_arb | ct_lsu_bus_arb.v | 总线仲裁 |
| ct_lsu_cache_buffer | ct_lsu_cache_buffer.v | 缓存缓冲 |
| ct_lsu_idfifo_8 | ct_lsu_idfifo_8.v | ID FIFO |
| ct_lsu_idfifo_entry | ct_lsu_idfifo_entry.v | ID FIFO表项 |
| ct_lsu_rot_data | ct_lsu_rot_data.v | 数据旋转 |
| ct_lsu_sd_ex1 | ct_lsu_sd_ex1.v | Store数据EX1 |
| ct_lsu_spec_fail_predict | ct_lsu_spec_fail_predict.v | 推测失败预测 |

## 5. 访存流水线

### 5.1 Load 流水线

```
┌────────┬────────┬────────┬────────┐
│   AG   │   DA   │   DC   │   WB   │
│地址生成 │数据访问 │数据缓存 │ 写回   │
├────────┼────────┼────────┼────────┤
│基地址  │TLB翻译 │Cache读 │数据对齐│
│偏移量  │Tag比较 │数据选择│结果写回│
│地址计算│命中判断 │错误检测│异常处理│
└────────┴────────┴────────┴────────┘
```

### 5.2 Store 流水线

```
┌────────┬────────┬────────┬────────┐
│   AG   │   DA   │   DC   │   WB   │
│地址生成 │数据访问 │数据缓存 │ 写回   │
├────────┼────────┼────────┼────────┤
│基地址  │TLB翻译 │Cache写 │提交确认│
│偏移量  │Tag比较 │数据写入│SQ更新  │
│地址计算│命中判断 │脏位更新│WMB处理 │
└────────┴────────┴────────┴────────┘
```

## 6. D-Cache 配置

| 参数 | 值 |
|-----|-----|
| 容量 | 32KB / 64KB |
| 组相联 | 4-way |
| 行大小 | 64B |
| 替换策略 | PLRU |
| 写策略 | Write-Back |
| 一致性 | MESI 协议 |

## 7. 内存一致性

### 7.1 支持的操作

| 操作类型 | 描述 |
|---------|------|
| Load | 普通加载 |
| Store | 普通存储 |
| AMO | 原子内存操作 |
| LR/SC | 保留加载/条件存储 |
| Fence | 内存屏障 |

### 7.2 一致性协议

- 支持 MESI 协议
- 支持 Snoop 操作
- 支持缓存行无效化

## 8. 设计要点

1. **乱序访存**: 支持 Load 乱序执行
2. **Store-Load 前递**: Store 数据可前递给后续 Load
3. **内存一致性**: 完整支持 RISC-V 内存模型
4. **原子操作**: 支持完整 AMO 指令集
5. **预取**: 硬件预取支持

---

*文档版本: 1.0*
*创建日期: 2026-03-09*
