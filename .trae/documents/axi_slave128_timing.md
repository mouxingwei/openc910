# axi_slave128 接口时序图

## 时序模式说明

| 模式类型 | 相关信号 | 描述 |
|----------|----------|------|
| valid_ready | arvalid_s0, arready_s0 | arvalid_s0 和 arready_s0 构成 Valid-Ready 握手协议 |
| valid_ready | awvalid_s0, awready_s0 | awvalid_s0 和 awready_s0 构成 Valid-Ready 握手协议 |
| valid_ready | bvalid_s0, bready_s0 | bvalid_s0 和 bready_s0 构成 Valid-Ready 握手协议 |
| valid_ready | rvalid_s0, rready_s0 | rvalid_s0 和 rready_s0 构成 Valid-Ready 握手协议 |
| axi_read | arvalid_s0, arready_s0, rvalid_s0, rready_s0 | AXI 读通道 |
| reset | pad_cpu_rst_b | 复位时序 |

## 时序图 1: arvalid_s0 和 arready_s0 构成 Valid-Ready 握手协议

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant TB as Testbench/上游模块
    participant DUT as axi_slave128

    Note over TB,DUT: Valid-Ready 握手协议时序

    TB->>DUT: arvalid_s0=1
    DUT-->>TB: arready_s0=0 (未就绪)
    Note over DUT: 内部处理中...
    DUT-->>TB: arready_s0=1 (就绪)
    Note over TB,DUT: 握手成功，数据传输完成
    TB->>DUT: arvalid_s0=0
    Note over TB,DUT: 传输结束
```

## 时序图 2: awvalid_s0 和 awready_s0 构成 Valid-Ready 握手协议

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant TB as Testbench/上游模块
    participant DUT as axi_slave128

    Note over TB,DUT: Valid-Ready 握手协议时序

    TB->>DUT: awvalid_s0=1
    DUT-->>TB: awready_s0=0 (未就绪)
    Note over DUT: 内部处理中...
    DUT-->>TB: awready_s0=1 (就绪)
    Note over TB,DUT: 握手成功，数据传输完成
    TB->>DUT: awvalid_s0=0
    Note over TB,DUT: 传输结束
```

## 时序图 3: bvalid_s0 和 bready_s0 构成 Valid-Ready 握手协议

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant TB as Testbench/上游模块
    participant DUT as axi_slave128

    Note over TB,DUT: Valid-Ready 握手协议时序

    TB->>DUT: bvalid_s0=1
    DUT-->>TB: bready_s0=0 (未就绪)
    Note over DUT: 内部处理中...
    DUT-->>TB: bready_s0=1 (就绪)
    Note over TB,DUT: 握手成功，数据传输完成
    TB->>DUT: bvalid_s0=0
    Note over TB,DUT: 传输结束
```

## 时序图 4: rvalid_s0 和 rready_s0 构成 Valid-Ready 握手协议

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant TB as Testbench/上游模块
    participant DUT as axi_slave128

    Note over TB,DUT: Valid-Ready 握手协议时序

    TB->>DUT: rvalid_s0=1
    DUT-->>TB: rready_s0=0 (未就绪)
    Note over DUT: 内部处理中...
    DUT-->>TB: rready_s0=1 (就绪)
    Note over TB,DUT: 握手成功，数据传输完成
    TB->>DUT: rvalid_s0=0
    Note over TB,DUT: 传输结束
```

## 时序图 5: AXI 读通道

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant TB as Master
    participant DUT as axi_slave128 (Slave)

    Note over TB,DUT: AXI 读通道时序

    rect rgb(200, 220, 240)
    Note right of TB: 地址通道
    TB->>DUT: arvalid_s0=1
    TB->>DUT: araddr_s0=ADDR
    DUT-->>TB: arready_s0=1
    Note over TB,DUT: 地址握手成功
    TB->>DUT: arvalid_s0=0
    end

    rect rgb(220, 240, 200)
    Note right of TB: 数据通道
    DUT-->>TB: rvalid_s0=1
    DUT-->>TB: rdata_s0=DATA
    TB->>DUT: rready_s0=1
    Note over TB,DUT: 读数据握手成功
    end
```

## 时序图 6: 复位时序

### Mermaid 序列图

```mermaid
sequenceDiagram
    participant SYS as 系统
    participant DUT as axi_slave128

    Note over SYS,DUT: 复位时序 (低电平有效)

    SYS->>DUT: pad_cpu_rst_b=0 (复位有效)
    Note over DUT: 模块处于复位状态
    Note over DUT: 寄存器初始化...
    SYS->>DUT: pad_cpu_rst_b=1 (复位释放)
    Note over DUT: 开始正常工作
    DUT-->>SYS: 模块就绪
```
