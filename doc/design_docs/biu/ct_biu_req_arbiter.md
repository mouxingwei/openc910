# ct_biu_req_arbiter 模块详细设计方案

## 1. 模块概述

### 1.1 模块名称
`ct_biu_req_arbiter` - 总线请求仲裁器模块

### 1.2 功能描述
`ct_biu_req_arbiter` 是BIU的请求仲裁模块，负责对来自LSU和IFU的总线请求进行仲裁。该模块实现多请求源的优先级管理和公平调度，确保总线请求的有序处理。

### 1.3 主要特性
- 多请求源仲裁
- IFU/LSU请求优先级管理
- 读/写请求分离仲裁
- 公平调度机制
- 饥饿防止

## 2. 模块框图

```
                    ┌─────────────────────────────────────────────────────────────────────────────────┐
                    │                        ct_biu_req_arbiter                                      │
                    │                                                                                  │
    lsu_biu_ar_req  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        读请求仲裁                                        │    │
    ifu_biu_ar_req  │  │                                                                          │    │
    ──────────────────►│  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
                    │  │   IFU请求     │    │   LSU请求     │    │   仲裁逻辑    │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  │  • ar_valid   │    │  • ar_valid   │    │  • 优先级选择 │           │    │
                    │  │  • ar_addr    │    │  • ar_addr    │    │  • 公平调度   │           │    │
                    │  │  • ar_id      │    │  • ar_id      │    │  • 饥饿防止   │           │    │
                    │  │               │    │               │    │               │           │    │
                    │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
    lsu_biu_aw_req  │  ┌─────────────────────────────────────────────────────────────────────────┐    │
    ──────────────────►│                        写请求仲裁                                        │    │
                    │  │                                                                          │    │
                    │  │  ┌───────────────┐    ┌───────────────┐    ┌───────────────┐           │    │
                    │  │  │  Victim请求  │    │   Store请求   │    │   仲裁逻辑    │           │    │
                    │  │  │               │    │               │    │               │           │    │
                    │  │  │  • aw_valid   │    │  • aw_valid   │    │  • 优先级选择 │           │    │
                    │  │  │  • aw_addr    │    │  • aw_addr    │    │  • 写数据关联 │           │    │
                    │  │  │               │    │               │    │               │           │    │
                    │  │  └───────────────┘    └───────────────┘    └───────────────┘           │    │
                    │  │                                                                          │    │
                    │  └─────────────────────────────────────────────────────────────────────────┘    │
                    │                              │                                                  │
                    │                              ▼                                                  │
                    │  输出信号:                                                                        │
                    │  ┌──────────────────────────────────────────────────────────────────────────┐  │
                    │  │ arb_read_* | arb_write_* | grant_* | ready_*                            │  │
                    │  └──────────────────────────────────────────────────────────────────────────┘  │
                    └─────────────────────────────────────────────────────────────────────────────────┘
```

## 3. 接口定义

### 3.1 输入信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `forever_coreclk` | 1 | 永久核心时钟 |
| `cpurst_b` | 1 | 全局复位信号，低有效 |
| `lsu_biu_ar_req` | 1 | LSU读请求 |
| `lsu_biu_ar_addr[39:0]` | 40 | LSU读地址 |
| `lsu_biu_ar_id[3:0]` | 4 | LSU读ID |
| `lsu_biu_ar_size[2:0]` | 3 | LSU读大小 |
| `lsu_biu_ar_len[3:0]` | 4 | LSU读长度 |
| `lsu_biu_ar_lock` | 1 | LSU读锁 |
| `lsu_biu_ar_cache[3:0]` | 4 | LSU读缓存属性 |
| `lsu_biu_ar_prot[2:0]` | 3 | LSU读保护属性 |
| `ifu_biu_ar_req` | 1 | IFU读请求 |
| `ifu_biu_ar_addr[39:0]` | 40 | IFU读地址 |
| `ifu_biu_ar_id[3:0]` | 4 | IFU读ID |
| `lsu_biu_aw_req` | 1 | LSU写地址请求 |
| `lsu_biu_aw_addr[39:0]` | 40 | LSU写地址 |
| `lsu_biu_w_req` | 1 | LSU写数据请求 |

### 3.2 输出信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| `biu_lsu_ar_grant` | 1 | LSU读授权 |
| `biu_ifu_ar_grant` | 1 | IFU读授权 |
| `arb_read_req` | 1 | 仲裁后读请求 |
| `arb_read_addr[39:0]` | 40 | 仲裁后读地址 |
| `arb_read_id[3:0]` | 4 | 仲裁后读ID |
| `biu_lsu_aw_grant` | 1 | LSU写授权 |
| `arb_write_req` | 1 | 仲裁后写请求 |
| `arb_write_addr[39:0]` | 40 | 仲裁后写地址 |

## 4. 仲裁策略

### 4.1 读请求优先级

```
优先级从高到低:
1. IFU请求 (指令获取)
2. LSU请求 (数据访问)
```

### 4.2 写请求优先级

```
优先级从高到低:
1. Victim请求 (Cache驱逐)
2. Store请求 (存储操作)
```

### 4.3 公平调度

```verilog
// 轮询调度计数器
always @(posedge clk or negedge cpurst_b) begin
    if (!cpurst_b)
        round_robin_cnt <= 2'b0;
    else if (grant_valid)
        round_robin_cnt <= round_robin_cnt + 1'b1;
end

// 防止饥饿
// 当低优先级请求等待超过阈值时，临时提升优先级
assign starvation_prevent = (wait_cnt > STARVATION_THRESHOLD);
```

## 5. 关键逻辑设计

### 5.1 读请求仲裁

```verilog
always @(*) begin
    case (read_arb_state)
        IDLE: begin
            if (ifu_ar_req && !lsu_starvation)
                read_grant = IFU_GRANT;
            else if (lsu_ar_req)
                read_grant = LSU_GRANT;
            else
                read_grant = NO_GRANT;
        end
        IFU_ACTIVE: begin
            if (ifu_ar_req)
                read_grant = IFU_GRANT;
            else if (lsu_ar_req)
                read_grant = LSU_GRANT;
            else
                read_grant = NO_GRANT;
        end
        // ...
    endcase
end
```

### 5.2 写请求仲裁

```verilog
always @(*) begin
    case (write_arb_state)
        IDLE: begin
            if (victim_aw_req)
                write_grant = VICTIM_GRANT;
            else if (store_aw_req)
                write_grant = STORE_GRANT;
            else
                write_grant = NO_GRANT;
        end
        // ...
    endcase
end
```

## 6. 时序图

### 6.1 读请求仲裁时序

```
时钟:        T1      T2      T3      T4
            ┌───────┬───────┬───────┬───────┐
ifu_ar_req  ────────┐               ┌───────
                    └───────────────┘
lsu_ar_req  ────────────────┐       ┌───────
                            └───────┘
            
grant:      IFU     IFU     LSU     LSU
            
arb_read_req─────────────────────────
```

## 7. 设计要点

### 7.1 饥饿防止
- 设置等待计数器
- 超过阈值时提升优先级

### 7.2 死锁避免
- 读写通道独立仲裁
- 避免资源竞争

### 7.3 公平性
- 轮询调度
- 动态优先级调整

## 8. 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 1.0 | - | 初始版本 |
