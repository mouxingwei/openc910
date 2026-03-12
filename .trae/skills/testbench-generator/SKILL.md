---
name: testbench-generator
description: |
  测试平台生成SKILL。
  基于芯片验证方案生成测试平台，包含UVM测试平台结构、driver、monitor、scoreboard、sequence等组件。
  当用户需要根据验证方案生成测试平台时使用此技能。
---

# 测试平台生成

## 功能概述

本SKILL根据验证方案生成UVM测试平台代码。

## 使用场景

- 验证方案已完成，需要生成测试平台
- 需要生成符合UVM规范的测试平台
- 需要生成可重用的测试平台组件

## 工作流程

### Step 1: 收集输入

1. 读取验证方案
2. 确认验证模块的接口信号
3. 了解验证环境要求

### Step 2: 分析验证需求

从验证方案中提取：

**接口信息**：
- 信号名称和方向
- 协议类型
- 数据宽度

**验证组件**：
- 需要哪些agent
- 需要哪些scoreboard
- 需要哪些reference model

### Step 3: 生成测试平台

按UVM规范生成测试平台代码：

## 测试平台结构

```
tb_top/
├── env/
│   ├── my_env.sv
│   ├── my_agent.sv
│   ├── my_driver.sv
│   ├── my_monitor.sv
│   ├── my_sequencer.sv
│   ├── my_scoreboard.sv
│   └── my_coverage.sv
├── tests/
│   ├── base_test.sv
│   ├── my_test.sv
│   └── sequences/
│       ├── my_sequence.sv
│       └── my_item.sv
├── agent_pkg.sv
├── env_pkg.sv
├── tests_pkg.sv
└── tb_top.sv
```

### Step 4: 生成关键组件

#### 4.1 测试平台顶层

```systemverilog
module tb_top;
    import uvm_pkg::*;
    
    logic clk;
    logic rst_n;
    
    // DUT实例
    dut dut_inst (.*);
    
    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // 复位生成
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
    end
    
    // UVM配置
    initial begin
        uvm_config_db#(virtual interface dut_if)::set(null, "uvm_test_top", "vif", dut_if_inst);
        run_test();
    end
endmodule
```

#### 4.2 Environment

```systemverilog
class my_env extends uvm_env;
    `uvm_component_utils(my_env)
    
    my_agent agent;
    my_scoreboard scoreboard;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = my_agent::type_id::create("agent", this);
        scoreboard = my_scoreboard::type_id::create("scoreboard", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agent.mon.item_collected_port.connect(scoreboard.item_collected_export);
    endfunction
endclass
```

#### 4.3 Agent

```systemverilog
class my_agent extends uvm_agent;
    `uvm_component_utils(my_agent)
    
    my_sequencer sequencer;
    my_driver driver;
    my_monitor monitor;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = my_sequencer::type_id::create("sequencer", this);
        driver = my_driver::type_id::create("driver", this);
        monitor = my_monitor::type_id::create("monitor", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass
```

#### 4.4 Driver

```systemverilog
class my_driver extends uvm_driver#(my_transaction);
    `uvm_component_utils(my_driver)
    
    virtual dut_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface must be set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            drive_transaction(req);
            seq_item_port.item_done();
        end
    endtask
    
    virtual protected task drive_transaction(my_transaction tr);
        @(posedge vif.clk);
        vif.valid <= 1'b1;
        vif.data <= tr.data;
        wait(vif.ready == 1'b1);
        @(posedge vif.clk);
        vif.valid <= 1'b0;
    endtask
endclass
```

#### 4.5 Monitor

```systemverilog
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor)
    
    uvm_analysis_port#(my_transaction) item_collected_port;
    virtual dut_if vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "virtual interface must be set")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if (vif.valid) begin
                my_transaction tr;
                tr = my_transaction::type_id::create("tr");
                tr.data = vif.data;
                item_collected_port.write(tr);
            end
        end
    endtask
endclass
```

#### 4.6 Scoreboard

```systemverilog
class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(my_scoreboard)
    
    uvm_analysis_export#(my_transaction) item_collected_export;
    my_transaction expect_queue[$];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_export = new("item_collected_export", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_collected_export.connect(analysis_export);
    endfunction
    
    virtual function void write(my_transaction tr);
        if (expect_queue.size() > 0) begin
            my_transaction exp_tr;
            exp_tr = expect_queue.pop_front();
            if (tr.data == exp_tr.data) begin
                `uvm_info("SCB_PASS", $sformatf("Match: %0d", tr.data), UVM_LOW)
            end else begin
                `uvm_error("SCB_FAIL", $sformatf("Mismatch: got %0d, exp %0d", tr.data, exp_tr.data))
            end
        end
    endfunction
endclass
```

#### 4.7 Sequence Item

```systemverilog
class my_transaction extends uvm_sequence_item;
    `uvm_object_utils(my_transaction)
    
    rand logic [31:0] data;
    rand logic [7:0] addr;
    
    constraint data_c {
        data inside {[0:'hFF]};
    }
    
    function new(string name = "my_transaction");
        super.new(name);
    endfunction
    
    function string convert2string();
        return $sformatf("addr=%h, data=%h", addr, data);
    endfunction
endclass
```

#### 4.8 Sequence

```systemverilog
class my_sequence extends uvm_sequence#(my_transaction);
    `uvm_object_utils(my_sequence)
    
    int transaction_count;
    
    function new(string name = "my_sequence");
        super.new(name);
        transaction_count = 10;
    endfunction
    
    task body;
        repeat(transaction_count) begin
            my_transaction tr;
            tr = my_transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        end
    endtask
endclass
```

#### 4.9 Test

```systemverilog
class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        my_sequence seq;
        phase.raise_objection(this);
        seq = my_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        phase.drop_objection(this);
    endtask
endclass
```

### Step 5: 生成Makefile

```makefile
UVM_HOME = /path/to/uvm
VCS_HOME = /path/to/vcs

compile:
    vcs -sverilog -ntb_opts uvm-1.2 \
        -f filelist.f \
        -R -gui

run:
    ./simv +UVM_TESTNAME=my_test

regress:
    make run TEST=base_test
    make run TEST=my_test
```

### Step 6: 质量检查

**规范性检查**：
- [ ] 符合UVM规范
- [ ] 代码风格统一
- [ ] 注释完整

**完整性检查**：
- [ ] 所有组件已生成
- [ ] 接口定义正确
- [ ] 连接关系正确

### Step 7: 输出代码

输出SystemVerilog格式的测试平台代码。

## 输出格式

### 1. 目录结构

```
project/
├── tb_top.sv
├── dut_if.sv
├── packages/
│   ├── agent_pkg.sv
│   ├── env_pkg.sv
│   └── test_pkg.sv
├── env/
│   ├── my_env.sv
│   ├── my_agent.sv
│   ├── my_driver.sv
│   ├── my_monitor.sv
│   ├── my_sequencer.sv
│   └── my_scoreboard.sv
├── sequences/
│   ├── my_sequence.sv
│   └── my_transaction.sv
├── tests/
│   ├── base_test.sv
│   └── my_test.sv
└── Makefile
```

### 2. 文件清单

| 文件 | 描述 |
|------|------|
| tb_top.sv | 测试平台顶层 |
| dut_if.sv | DUT接口定义 |
| my_env.sv | UVM环境 |
| my_agent.sv | UVM Agent |
| my_driver.sv | UVM Driver |
| my_monitor.sv | UVM Monitor |
| my_sequencer.sv | UVM Sequencer |
| my_scoreboard.sv | UVM Scoreboard |
| my_transaction.sv | Transaction定义 |
| my_sequence.sv | Sequence定义 |
| my_test.sv | Test定义 |

## 示例

### 输入（验证方案）

```markdown
## 验证环境

验证平台采用UVM架构：
- Agent: 1个
- Driver: 1个
- Monitor: 1个
- Scoreboard: 1个

接口信号：
- clk: 时钟
- rst_n: 复位
- valid: 有效信号
- ready: 就绪信号
- data: 数据信号
```

### 输出（测试平台结构）

生成完整的UVM测试平台代码。

## 注意事项

1. **符合规范**：严格按照UVM规范编写
2. **模块化**：组件要模块化设计
3. **可重用**：设计要具有可重用性
4. **可配置**：提供足够的配置接口

## 相关SKILL

- `verification-plan-generator`: 验证方案生成
- `test-point-generator`: 测试点生成
- `test-case-generator`: 测试用例生成
- `chip-design-orchestrator`: 调度整个芯片设计流程
