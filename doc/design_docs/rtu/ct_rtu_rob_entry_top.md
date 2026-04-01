# ct_rtu_rob_entry 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | ct_rtu_rob_entry |
| 文件路径 | C910_RTL_FACTORY/gen_rtl/rtu/rtl/ct_rtu_rob_entry.v |
| 功能描述 | ROB (Re-Order Buffer) 条目模块，存储单条指令的执行状态信息 |
| 设计特点 | 支持指令创建、完成、退休操作，包含完整的指令状态管理 |

### 1.2 功能描述

ct_rtu_rob_entry 是 ROB 的基本存储单元，每个条目存储一条指令的完整状态信息，包括：

- **指令有效性**：条目是否被占用
- **完成状态**：指令是否执行完成及完成计数
- **指令属性**：分支跳转、加载存储、异常屏蔽等
- **向量扩展信息**：VL、VSEW、VLMUL 等向量相关状态
- **调试信息**：断点信息、PC 偏移等

### 1.3 设计特点

- **多端口创建支持**：支持 4 个创建端口（create0~create3），实现每周期最多 4 条指令入队
- **完成计数机制**：支持折叠指令（1/2/3 折叠），通过完成计数器跟踪指令完成状态
- **时钟门控优化**：采用多个门控时钟域，降低功耗
- **LSU 特殊处理**：对 Load/Store 指令的特殊状态更新（断点、非投机访问）

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| cp0_rtu_icg_en | input | 1 | CP0 模块时钟门控使能 |
| cp0_yy_clk_en | input | 1 | CP0 全局时钟使能 |
| cpurst_b | input | 1 | 系统复位信号（低有效） |
| forever_cpuclk | input | 1 | CPU 主时钟 |
| idu_rtu_rob_create0_data | input | 40 | 创建端口 0 数据 |
| idu_rtu_rob_create1_data | input | 40 | 创建端口 1 数据 |
| idu_rtu_rob_create2_data | input | 40 | 创建端口 2 数据 |
| idu_rtu_rob_create3_data | input | 40 | 创建端口 3 数据 |
| lsu_misc_cmplt_gateclk_en | input | 1 | LSU 完成门控使能 |
| lsu_rtu_wb_pipe3_bkpta_data | input | 1 | LSU Pipe3 数据断点 A |
| lsu_rtu_wb_pipe3_bkptb_data | input | 1 | LSU Pipe3 数据断点 B |
| lsu_rtu_wb_pipe3_no_spec_hit | input | 1 | LSU Pipe3 非投机命中 |
| lsu_rtu_wb_pipe3_no_spec_mispred | input | 1 | LSU Pipe3 非投机误预测 |
| lsu_rtu_wb_pipe3_no_spec_miss | input | 1 | LSU Pipe3 非投机未命中 |
| lsu_rtu_wb_pipe4_bkpta_data | input | 1 | LSU Pipe4 数据断点 A |
| lsu_rtu_wb_pipe4_bkptb_data | input | 1 | LSU Pipe4 数据断点 B |
| lsu_rtu_wb_pipe4_no_spec_hit | input | 1 | LSU Pipe4 非投机命中 |
| lsu_rtu_wb_pipe4_no_spec_mispred | input | 1 | LSU Pipe4 非投机误预测 |
| lsu_rtu_wb_pipe4_no_spec_miss | input | 1 | LSU Pipe4 非投机未命中 |
| pad_yy_icg_scan_en | input | 1 | 扫描测试使能 |
| retire_rob_flush | input | 1 | 退休刷新信号 |
| retire_rob_flush_gateclk | input | 1 | 退休刷新门控时钟 |
| x_cmplt_gateclk_vld | input | 1 | 完成门控有效 |
| x_cmplt_vld | input | 7 | 完成有效向量（对应 7 个执行管道） |
| x_create_dp_en | input | 1 | 创建数据通路使能 |
| x_create_en | input | 1 | 创建使能 |
| x_create_gateclk_en | input | 1 | 创建门控使能 |
| x_create_sel | input | 4 | 创建端口选择信号 |
| x_pop_en | input | 1 | 条目弹出使能 |

### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
| x_read_data | output | 40 | 条目读出数据 |

## 3. 参数定义

### 3.1 ROB 数据宽度参数

| 参数名 | 值 | 描述 |
|--------|-----|------|
| ROB_WIDTH | 40 | ROB 条目数据总宽度 |

### 3.2 ROB 数据域定义

| 参数名 | 值 | 描述 |
|--------|-----|------|
| ROB_VL_PRED | 39 | VL 预测标志位 |
| ROB_VL | 38 | VL 值起始位（[38:31] 共 8 位） |
| ROB_VEC_DIRTY | 30 | 向量寄存器脏标志 |
| ROB_VSETVLI | 29 | VSETVLI 指令标志 |
| ROB_VSEW | 28 | VSEW 值起始位（[28:26] 共 3 位） |
| ROB_VLMUL | 25 | VLMUL 值起始位（[25:24] 共 2 位） |
| ROB_NO_SPEC_MISPRED | 23 | 非投机误预测标志 |
| ROB_NO_SPEC_MISS | 22 | 非投机未命中标志 |
| ROB_NO_SPEC_HIT | 21 | 非投机命中标志 |
| ROB_LOAD | 20 | Load 指令标志 |
| ROB_FP_DIRTY | 19 | 浮点寄存器脏标志 |
| ROB_INST_NUM | 18 | 指令编号起始位（[18:17] 共 2 位） |
| ROB_BKPTB_INST | 16 | 指令断点 B 标志 |
| ROB_BKPTA_INST | 15 | 指令断点 A 标志 |
| ROB_BKPTB_DATA | 14 | 数据断点 B 标志 |
| ROB_BKPTA_DATA | 13 | 数据断点 A 标志 |
| ROB_STORE | 12 | Store 指令标志 |
| ROB_RAS | 11 | RAS (Return Address Stack) 标志 |
| ROB_PCFIFO | 10 | PC FIFO 标志 |
| ROB_BJU | 9 | 分支跳转单元标志 |
| ROB_INTMASK | 8 | 中断屏蔽标志 |
| ROB_SPLIT | 7 | 分裂指令标志 |
| ROB_PC_OFFSET | 6 | PC 偏移起始位（[6:4] 共 3 位） |
| ROB_CMPLT_CNT | 3 | 完成计数起始位（[3:2] 共 2 位） |
| ROB_CMPLT | 1 | 完成标志 |
| ROB_VLD | 0 | 有效标志 |

## 4. 模块框图

```mermaid
graph TB
    subgraph 输入接口
        CREATE[创建接口<br/>create0~3_data<br/>create_sel/en/dp_en]
        CMPLT[完成接口<br/>cmplt_vld[6:0]<br/>pipe0~7完成信号]
        LSU[LSU接口<br/>pipe3/4断点/非投机信号]
        CTRL[控制信号<br/>flush/pop/gateclk]
    end

    subgraph 时钟门控
        ENTRY_CLK[entry_clk<br/>条目主时钟]
        CREATE_CLK[create_clk<br/>创建数据时钟]
        LSU_CLK[lsu_cmplt_clk<br/>LSU完成时钟]
    end

    subgraph 核心寄存器
        VLD_REG[有效寄存器<br/>vld]
        CMPLT_REG[完成寄存器<br/>cmplt/cmplt_cnt]
        INST_INFO[指令信息<br/>pc_offset/split/intmask<br/>bju/pcfifo/ras/store]
        VEC_INFO[向量信息<br/>vl/vlmul/vsew<br/>vsetvli/vec_dirty]
        BKPT_INFO[断点信息<br/>bkpta/bkptb<br/>inst/data]
        SPEC_INFO[非投机信息<br/>no_spec_hit/miss/mispred]
    end

    subgraph 输出接口
        READ_DATA[x_read_data<br/>40位条目数据]
    end

    CREATE --> CREATE_CLK
    CMPLT --> ENTRY_CLK
    LSU --> LSU_CLK
    CTRL --> ENTRY_CLK

    CREATE_CLK --> INST_INFO
    CREATE_CLK --> VEC_INFO
    CREATE_CLK --> BKPT_INFO

    ENTRY_CLK --> VLD_REG
    ENTRY_CLK --> CMPLT_REG

    LSU_CLK --> BKPT_INFO
    LSU_CLK --> SPEC_INFO

    VLD_REG --> READ_DATA
    CMPLT_REG --> READ_DATA
    INST_INFO --> READ_DATA
    VEC_INFO --> READ_DATA
    BKPT_INFO --> READ_DATA
    SPEC_INFO --> READ_DATA
```

## 5. 关键逻辑说明

### 5.1 条目创建逻辑

**功能描述**：从 4 个创建端口中选择一个端口的数据写入条目。

**实现方式**：
- 根据 `x_create_sel[3:0]` 选择对应的创建端口数据
- 支持 4 种选择：create0(4'b0001)、create1(4'b0010)、create2(4'b0100)、create3(4'b1000)
- 使用 `x_create_en` 触发写入操作

**关键代码**：
```verilog
always @(*) begin
  case (x_create_sel[3:0])
    4'h1   : x_create_data = idu_rtu_rob_create0_data;
    4'h2   : x_create_data = idu_rtu_rob_create1_data;
    4'h4   : x_create_data = idu_rtu_rob_create2_data;
    4'h8   : x_create_data = idu_rtu_rob_create3_data;
    default: x_create_data = {ROB_WIDTH{1'bx}};
  endcase
end
```

### 5.2 完成计数机制

**功能描述**：支持折叠指令的完成跟踪，通过计数器判断指令是否全部完成。

**折叠指令类型**：
- **1 折叠指令**：需要 1 个微操作完成
- **2 折叠指令**：需要 2 个微操作完成
- **3 折叠指令**：需要 3 个微操作完成

**完成判断逻辑**：
```verilog
// 1 折叠指令完成：1 个 pipe 完成且计数器为 1
cmplt_1_fold_inst = x_cmplt_vld[0] && !x_cmplt_vld[1] && ...

// 完成更新值
cmplt_updt_val = 
     (cmplt_1_fold_inst) && (cmplt_cnt_with_create == 2'd1)
  || (cmplt_2_fold_inst) && (cmplt_cnt_with_create == 2'd2)
  || (cmplt_3_fold_inst)
  || (|x_cmplt_vld[4:2]);  // 其他指令直接完成
```

**计数器更新**：
- 创建时初始化为指令的折叠数
- 每次完成减去完成的微操作数
- 计数器归零时设置完成标志

### 5.3 LSU 特殊处理

**功能描述**：Load/Store 指令的特殊状态更新，包括数据断点和非投机访问结果。

**处理内容**：
1. **数据断点**：从 LSU Pipe3/4 接收断点触发信号
2. **非投机访问结果**：
   - `no_spec_hit`：非投机访问命中
   - `no_spec_miss`：非投机访问未命中
   - `no_spec_mispred`：非投机误预测

**更新逻辑**：
```verilog
assign bkpta_data_updt_val = x_cmplt_vld[3] && lsu_rtu_wb_pipe3_bkpta_data
                          || x_cmplt_vld[4] && lsu_rtu_wb_pipe4_bkpta_data;

always @(posedge lsu_cmplt_clk or negedge cpurst_b) begin
  if(!cpurst_b) begin
    bkpta_data <= 1'b0;
    ...
  end
  else if(|x_cmplt_vld[4:3]) begin
    bkpta_data <= bkpta_data_updt_val;
    ...
  end
end
```

### 5.4 时钟门控策略

**设计目标**：降低功耗，仅在需要时激活时钟。

**时钟域划分**：

| 时钟域 | 使能条件 | 用途 |
|--------|----------|------|
| entry_clk | flush/create/cmplt/pop | 条目主时钟，控制有效位和完成状态 |
| create_clk | create_gateclk_en | 创建数据时钟，写入指令信息 |
| lsu_cmplt_clk | create_gateclk_en OR lsu_misc_cmplt_gateclk_en | LSU 完成时钟，更新断点和非投机状态 |

**门控单元实例化**：
```verilog
gated_clk_cell x_entry_gated_clk (
  .clk_in     (forever_cpuclk),
  .clk_out    (entry_clk),
  .global_en  (cp0_yy_clk_en),
  .local_en   (entry_clk_en),
  .module_en  (cp0_rtu_icg_en)
);
```

## 6. 内部信号列表

### 6.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| vld | 1 | 条目有效标志 |
| cmplt | 1 | 指令完成标志 |
| cmplt_cnt | 2 | 完成计数器 |
| pc_offset | 3 | PC 偏移值 |
| split | 1 | 分裂指令标志 |
| intmask | 1 | 中断屏蔽标志 |
| bju | 1 | 分支跳转单元标志 |
| pcfifo | 1 | PC FIFO 标志 |
| ras | 1 | RAS 标志 |
| store | 1 | Store 指令标志 |
| bkpta_inst | 1 | 指令断点 A 标志 |
| bkptb_inst | 1 | 指令断点 B 标志 |
| inst_num | 2 | 指令编号 |
| fp_dirty | 1 | 浮点寄存器脏标志 |
| load | 1 | Load 指令标志 |
| vlmul | 2 | VLMUL 值 |
| vsew | 3 | VSEW 值 |
| vsetvli | 1 | VSETVLI 指令标志 |
| vec_dirty | 1 | 向量寄存器脏标志 |
| vl | 8 | VL 值 |
| vl_pred | 1 | VL 预测标志 |
| bkpta_data | 1 | 数据断点 A 标志 |
| bkptb_data | 1 | 数据断点 B 标志 |
| no_spec_hit | 1 | 非投机命中标志 |
| no_spec_miss | 1 | 非投机未命中标志 |
| no_spec_mispred | 1 | 非投机误预测标志 |

### 6.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| x_create_data | 40 | 创建数据 |
| entry_clk_en | 1 | 条目时钟使能 |
| create_clk_en | 1 | 创建时钟使能 |
| lsu_cmplt_clk_en | 1 | LSU 完成时钟使能 |
| entry_clk | 1 | 条目门控时钟 |
| create_clk | 1 | 创建门控时钟 |
| lsu_cmplt_clk | 1 | LSU 完成门控时钟 |
| cmplt_1_fold_inst | 1 | 1 折叠指令完成标志 |
| cmplt_2_fold_inst | 1 | 2 折叠指令完成标志 |
| cmplt_3_fold_inst | 1 | 3 折叠指令完成标志 |
| cmplt_cnt_cmplt_exist | 2 | 完成后的计数器值 |
| cmplt_cnt_with_create | 2 | 包含创建的计数器值 |
| cmplt_updt_val | 1 | 完成更新值 |
| bkpta_data_updt_val | 1 | 数据断点 A 更新值 |
| bkptb_data_updt_val | 1 | 数据断点 B 更新值 |
| no_spec_hit_updt_val | 1 | 非投机命中更新值 |
| no_spec_miss_updt_val | 1 | 非投机未命中更新值 |
| no_spec_mispred_updt_val | 1 | 非投机误预测更新值 |

## 7. 数据结构定义

### 7.1 ROB 条目数据格式（40 位）

| 位域 | 名称 | 描述 |
|------|------|------|
| [39] | VL_PRED | VL 预测标志 |
| [38:31] | VL | 向量长度寄存器值 |
| [30] | VEC_DIRTY | 向量寄存器脏标志 |
| [29] | VSETVLI | VSETVLI 指令标志 |
| [28:26] | VSEW | 向量元素宽度 |
| [25:24] | VLMUL | 向量寄存器分组 |
| [23] | NO_SPEC_MISPRED | 非投机误预测 |
| [22] | NO_SPEC_MISS | 非投机未命中 |
| [21] | NO_SPEC_HIT | 非投机命中 |
| [20] | LOAD | Load 指令标志 |
| [19] | FP_DIRTY | 浮点寄存器脏标志 |
| [18:17] | INST_NUM | 指令编号 |
| [16] | BKPTB_INST | 指令断点 B |
| [15] | BKPTA_INST | 指令断点 A |
| [14] | BKPTB_DATA | 数据断点 B |
| [13] | BKPTA_DATA | 数据断点 A |
| [12] | STORE | Store 指令标志 |
| [11] | RAS | RAS 标志 |
| [10] | PCFIFO | PC FIFO 标志 |
| [9] | BJU | 分支跳转单元标志 |
| [8] | INTMASK | 中断屏蔽标志 |
| [7] | SPLIT | 分裂指令标志 |
| [6:4] | PC_OFFSET | PC 偏移值 |
| [3:2] | CMPLT_CNT | 完成计数器 |
| [1] | CMPLT | 完成标志 |
| [0] | VLD | 有效标志 |

## 8. 设计要点

### 8.1 折叠指令支持

**背景**：某些复杂指令（如向量指令）可能需要多个微操作完成，ROB 条目需要跟踪所有微操作的完成状态。

**实现方式**：
- 创建时设置 `cmplt_cnt` 为微操作数量
- 每个微操作完成时递减计数器
- 计数器归零时设置 `cmplt` 标志

### 8.2 时钟门控优化

**优化策略**：
- **分级门控**：不同数据域使用不同时钟，减少不必要的时钟翻转
- **条件激活**：仅在相关操作发生时激活时钟
- **LSU 独立时钟**：LSU 完成更新使用独立时钟域

### 8.3 断点处理

**断点类型**：
- **指令断点**：在指令创建时设置，基于 PC 匹配
- **数据断点**：在 LSU 执行时触发，基于访存地址匹配

**处理流程**：
1. 指令断点在创建时写入条目
2. 数据断点在 LSU 完成时更新
3. 退休时输出断点信息给调试模块

## 9. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | 2026-04-01 | Auto-generated | 初始版本 |
