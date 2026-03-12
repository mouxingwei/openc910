---
name: rtl-code-generator
description: |
  RTL代码生成SKILL。
  基于模块详细方案文档生成Verilog RTL代码，遵循编码规范，支持模块代码生成、寄存器代码生成、状态机代码生成等。
  当用户需要根据设计方案生成Verilog代码时使用此技能。
  参考编码规范：项目现有RTL代码风格
---

# RTL代码生成

## 功能概述

本SKILL根据模块详细方案文档生成符合编码规范的Verilog RTL代码。

## 使用场景

- 模块设计完成，需要生成RTL代码
- 需要生成符合编码规范的Verilog代码
- 需要生成可综合的RTL代码

## 工作流程

### Step 1: 收集输入

1. 读取模块详细方案文档
2. 确认模块的功能、接口、状态机设计
3. 了解项目的编码规范

### Step 2: 分析设计方案

从方案中提取以下信息：

**模块信息**：
- 模块名称
- 模块参数
- 输入输出端口

**功能逻辑**：
- 状态机设计
- 数据处理流程
- 控制逻辑

**实现细节**：
- 存储单元使用
- 流水线设计
- 特殊逻辑

### Step 3: 生成RTL代码

按照以下结构生成代码：

#### 3.1 模块声明

```verilog
module module_name #(
    parameter parameter1 = default_value,
    parameter parameter2 = default_value
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] data_in,
    output wire [31:0] data_out,
    output wire        valid
);
```

#### 3.2 信号定义

```verilog
// 内部信号定义
reg  [31:0] int_data;
wire       int_valid;

// 状态机状态定义
localparam IDLE  = 3'b000;
localparam WORK  = 3'b001;
localparam DONE  = 3'b010;

// 状态寄存器
reg [2:0] state;
reg [2:0] next_state;
```

#### 3.3 组合逻辑

```verilog
// 组合逻辑always块
always @(*) begin
    next_state = state;
    case (state)
        IDLE: begin
            if (start) begin
                next_state = WORK;
            end
        end
        WORK: begin
            if (done) begin
                next_state = DONE;
            end
        end
        default: next_state = IDLE;
    endcase
end
```

#### 3.4 时序逻辑

```verilog
// 时序逻辑always块
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end
```

#### 3.5 输出逻辑

```verilog
// 输出逻辑
assign valid = (state == DONE);
assign data_out = int_data;
```

### Step 4: 代码优化

**编码规范检查**：

1. **命名规范**：
   - 模块名：使用小写字母，单词间用下划线，如 `module_name`
   - 信号名：使用小写字母，如 `data_in`
   - 参数名：使用大写字母，如 `DATA_WIDTH`
   - 常量名：使用大写字母，如 `IDLE`

2. **代码结构**：
   - 一个always块只描述一类逻辑
   - 时序逻辑和组合逻辑分开
   - 避免不必要的锁存器

3. **注释规范**：
   - 模块头部注释
   - 端口注释
   - 关键逻辑注释

### Step 5: 代码生成模板

## RTL代码生成模板

```verilog
//=====================================================================
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: module_name
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
//=====================================================================

module module_name #(
    // Parameter definitions
    parameter PARAM_A = 8,
    parameter PARAM_B = 16
)(
    // Clock and reset
    input  wire        clk,
    input  wire        rst_n,
    
    // Input signals
    input  wire [PARAM_A-1:0] data_in,
    input  wire              valid_in,
    
    // Output signals
    output reg  [PARAM_B-1:0] data_out,
    output reg                valid_out,
    
    // Control signals
    input  wire              start,
    output wire              done
);

    //===========================================================
    // Internal signal definitions
    //===========================================================
    
    // State machine state definition
    localparam [1:0] ST_IDLE  = 2'b00;
    localparam [1:0] ST_WORK  = 2'b01;
    localparam [1:0] ST_DONE  = 2'b10;
    
    // Internal registers
    reg [1:0] state;
    reg [1:0] next_state;
    reg [PARAM_A-1:0] data_buf;
    
    // Internal wires
    wire work_done;
    wire [PARAM_B-1:0] data_processed;

    //===========================================================
    // State machine - next state logic
    //===========================================================
    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                if (start && valid_in) begin
                    next_state = ST_WORK;
                end
            end
            
            ST_WORK: begin
                if (work_done) begin
                    next_state = ST_DONE;
                end
            end
            
            ST_DONE: begin
                next_state = ST_IDLE;
            end
            
            default: next_state = ST_IDLE;
        endcase
    end

    //===========================================================
    // State machine - state register
    //===========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
        end else begin
            state <= next_state;
        end
    end

    //===========================================================
    // Data processing logic
    //===========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buf <= {PARAM_A{1'b0}};
        end else if (state == ST_IDLE && start && valid_in) begin
            data_buf <= data_in;
        end
    end
    
    assign data_processed = {{(PARAM_B-PARAM_A){1'b0}}, data_buf};
    assign work_done = (state == ST_WORK);  // Placeholder

    //===========================================================
    // Output logic
    //===========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out  <= {PARAM_B{1'b0}};
            valid_out <= 1'b0;
        end else begin
            case (state)
                ST_DONE: begin
                    data_out  <= data_processed;
                    valid_out <= 1'b1;
                end
                
                default: begin
                    data_out  <= {PARAM_B{1'b0}};
                    valid_out <= 1'b0;
                end
            endcase
        end
    end
    
    assign done = (state == ST_DONE);

endmodule
```

### Step 6: 代码质量检查

**功能正确性**：
- [ ] 代码实现与设计方案一致
- [ ] 状态机覆盖所有状态
- [ ] 无死锁或无限循环

**编码规范**：
- [ ] 命名规范正确
- [ ] 代码结构清晰
- [ ] 注释充分

**可综合**：
- [ ] 无不可综合语法
- [ ] 时序路径合理
- [ ] 无异步复位问题

### Step 7: 输出代码

输出Verilog RTL代码文件（.v或.sv格式）。

## 输出格式

### 1. Verilog文件

生成 `.v` 或 `.sv` 格式的RTL代码文件。

### 2. 文件头注释

包含以下信息：
- 公司名称
- 工程师
- 创建日期
- 设计名称
- 模块名称
- 项目名称
- 目标器件
- 工具版本
- 描述
- 依赖
- 版本历史

## 示例

### 输入（模块详细方案节选）

```markdown
## 模块：数据处理模块

### 接口定义

| 信号名 | 方向 | 描述 |
|--------|------|------|
| clk | Input | 时钟 |
| rst_n | Input | 复位 |
| data_in | Input[7:0] | 输入数据 |
| start | Input | 启动信号 |
| data_out | Output[15:0] | 输出数据 |
| done | Output | 完成信号 |

### 状态机设计

| 状态 | 描述 |
|------|------|
| IDLE | 空闲状态，等待启动 |
| WORK | 工作状态，处理数据 |
| DONE | 完成状态，输出结果 |
```

### 输出（RTL代码）

```verilog
//=====================================================================
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: data_process_module
// Module Name: data_process
// Project Name: 
// Description: 数据处理模块
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// 
//=====================================================================

module data_process (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [7:0] data_in,
    input  wire       start,
    output wire [15:0] data_out,
    output wire       done
);

    localparam [1:0] ST_IDLE = 2'b00;
    localparam [1:0] ST_WORK = 2'b01;
    localparam [1:0] ST_DONE = 2'b10;
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg [7:0] data_buf;
    
    always @(*) begin
        next_state = state;
        case (state)
            ST_IDLE: begin
                if (start) begin
                    next_state = ST_WORK;
                end
            end
            ST_WORK: begin
                next_state = ST_DONE;
            end
            ST_DONE: begin
                next_state = ST_IDLE;
            end
            default: next_state = ST_IDLE;
        endcase
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ST_IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_buf <= 8'h0;
        end else if (state == ST_IDLE && start) begin
            data_buf <= data_in;
        end
    end
    
    assign data_out = {{8{1'b0}}, data_buf};
    assign done = (state == ST_DONE);

endmodule
```

## 注意事项

1. **遵循编码规范**：严格按照项目编码规范生成代码
2. **设计一致性**：确保代码实现与设计方案一致
3. **可综合**：确保代码可综合，无不可综合语法
4. **模块化**：合理划分模块，保持模块独立性
5. **注释充分**：添加必要的注释，便于理解和维护

## 相关SKILL

- `module-design-generator`: 生成模块详细方案
- `register-manual-generator`: 生成寄存器手册
- `verilog-linter`: 静态检查代码
- `chip-design-orchestrator`: 调度整个芯片设计流程
