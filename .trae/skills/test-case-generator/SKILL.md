---
name: test-case-generator
description: |
  测试用例生成SKILL。
  基于芯片验证方案和测试点文档生成测试用例，包含功能测试用例、随机测试用例、边界测试用例等。
  当用户需要根据验证方案和测试点生成测试用例时使用此技能。
---

# 测试用例生成

## 功能概述

本SKILL根据验证方案和测试点文档生成测试用例代码。

## 使用场景

- 验证方案和测试点文档已完成，需要生成测试用例
- 需要生成功能测试用例
- 需要生成随机约束测试用例
- 需要生成边界测试用例

## 工作流程

### Step 1: 收集输入

1. 读取验证方案
2. 读取测试点文档
3. 确认测试平台结构

### Step 2: 分析测试点

从测试点中提取测试用例需求：

**功能测试用例**：
- 直接测试点
- 序列测试

**随机测试用例**：
- 随机约束生成
- 组合覆盖

**边界测试用例**：
- 边界值测试
- 极端条件测试

### Step 3: 生成测试用例

## 测试用例模板

### 3.1 功能测试用例

```systemverilog
class func_test_001 extends uvm_test;
    `uvm_component_utils(func_test_001)
    
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
        
        // 测试：正常中断响应
        seq = my_sequence::type_id::create("seq");
        seq.transaction_count = 1;
        
        // 配置中断使能
        // 触发中断
        // 检查响应
        assert(seq.randomize() with {
            seq.addr == 'h00;
            seq.data == 'h1;
        });
        
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if (uvm_report_server::get_server().get_severity_count(UVM_ERROR) == 0) begin
            `uvm_info("TEST_PASS", "func_test_001 PASSED", UVM_LOW)
        end else begin
            `uvm_error("TEST_FAIL", "func_test_001 FAILED")
        end
    endfunction
endclass
```

### 3.2 随机测试用例

```systemverilog
class random_test_001 extends uvm_test;
    `uvm_component_utils(random_test_001)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        my_random_sequence seq;
        phase.raise_objection(this);
        
        seq = my_random_sequence::type_id::create("seq");
        seq.transaction_count = 1000;
        assert(seq.randomize());
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("TEST_SUMMARY", $sformatf("Random test completed"), UVM_LOW)
    endfunction
endclass

class my_random_sequence extends uvm_sequence#(my_transaction);
    `uvm_object_utils(my_random_sequence)
    
    int transaction_count = 100;
    
    constraint addr_c {
        addr inside {['h00:'hFF]};
    }
    
    constraint data_c {
        data inside {['h0:'hFF]};
    }
    
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

### 3.3 边界测试用例

```systemverilog
class boundary_test_001 extends uvm_test;
    `uvm_component_utils(boundary_test_001)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endtask
    
    task run_phase(uvm_phase phase);
        my_transaction tr;
        phase.raise_objection(this);
        
        // 测试边界值
        tr = my_transaction::type_id::create("tr");
        tr.addr = 'h00;  // 最小地址
        tr.data = 'h00;  // 最小数据
        start_item(tr);
        finish_item(tr);
        
        tr = my_transaction::type_id::create("tr");
        tr.addr = 'hFF;  // 最大地址
        tr.data = 'hFF;  // 最大数据
        start_item(tr);
        finish_item(tr);
        
        phase.drop_objection(this);
    endtask
endclass
```

### 3.4 异常测试用例

```systemverilog
class error_test_001 extends uvm_test;
    `uvm_component_utils(error_test_001)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        my_transaction tr;
        phase.raise_objection(this);
        
        // 测试：中断禁用时触发中断
        // 配置中断禁用
        // 触发中断
        // 验证不响应
        
        phase.drop_objection(this);
    endtask
endclass
```

### 3.5 序列测试用例

```systemverilog
class sequence_test_001 extends uvm_test;
    `uvm_component_utils(sequence_test_001)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        my_intr_sequence seq;
        phase.raise_objection(this);
        
        // 测试：中断嵌套序列
        seq = my_intr_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask
endclass

class my_intr_sequence extends uvm_sequence#(my_transaction);
    `uvm_object_utils(my_intr_sequence)
    
    task body;
        my_transaction tr;
        
        // 触发低优先级中断
        tr = my_transaction::type_id::create("tr");
        tr.addr = 'h10;
        tr.data = 'h1;
        start_item(tr);
        finish_item(tr);
        #1000;
        
        // 触发高优先级中断
        tr = my_transaction::type_id::create("tr");
        tr.addr = 'h11;
        tr.data = 'h2;
        start_item(tr);
        finish_item(tr);
    endtask
endclass
```

## 测试用例分类

### 功能测试用例

| 用例ID | 描述 | 测试点 | 预期结果 |
|--------|------|--------|----------|
| func_001 | 正常中断响应 | TP-001 | 中断正确响应 |
| func_002 | 中断嵌套 | TP-002 | 嵌套正确 |

### 随机测试用例

| 用例ID | 描述 | 约束 |
|--------|------|------|
| rand_001 | 随机地址数据 | 有效范围 |
| rand_002 | 随机序列 | 组合覆盖 |

### 边界测试用例

| 用例ID | 描述 | 边界值 |
|--------|------|--------|
| bnd_001 | 最小值测试 | addr=0, data=0 |
| bnd_002 | 最大值测试 | addr=255, data=255 |

### 异常测试用例

| 用例ID | 描述 | 异常条件 |
|--------|------|----------|
| err_001 | 中断禁用测试 | mstatus.MIE=0 |
| err_002 | 超时测试 | 超时周期 |

## 生成测试用例步骤

### Step 1: 创建测试用例基类

```systemverilog
class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        phase.drop_objection(this);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction
endclass
```

### Step 2: 实现具体测试用例

继承基类实现各个测试用例。

### Step 3: 生成测试用例清单

```markdown
## 测试用例清单

| 用例ID | 类型 | 描述 | 优先级 | 状态 |
|--------|------|------|--------|------|
| func_001 | 功能 | 正常中断响应 | 高 | 待实现 |
| func_002 | 功能 | 中断嵌套 | 高 | 待实现 |
| rand_001 | 随机 | 随机约束测试 | 中 | 待实现 |
| bnd_001 | 边界 | 边界值测试 | 中 | 待实现 |
| err_001 | 异常 | 中断禁用测试 | 高 | 待实现 |
```

## 输出格式

### 1. 测试用例代码

SystemVerilog格式的测试用例代码。

### 2. 测试用例说明

测试用例说明文档，包含：
- 用例描述
- 前置条件
- 测试步骤
- 预期结果

### 3. 测试用例清单

测试用例汇总表。

## 示例

### 输入（测试点）

```markdown
#### TP-001: 正常中断响应
- 描述: 验证外部中断能够被正确响应
- 优先级: 高
- 关联需求: REQ-ICU-001
```

### 输出（测试用例）

```systemverilog
class func_test_interrupt_response extends uvm_test;
    `uvm_component_utils(func_test_interrupt_response)
    
    my_env env;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = my_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        uvm_sequence#(my_transaction) seq;
        phase.raise_objection(this);
        
        // 配置中断使能
        // 触发外部中断
        // 验证中断响应
        
        phase.drop_objection(this);
    endtask
endclass
```

## 注意事项

1. **覆盖测试点**：每个测试点都要有对应测试用例
2. **优先级合理**：根据优先级分配测试资源
3. **可重复**：测试用例要可重复运行
4. **独立性好**：测试用例之间要相互独立

## 相关SKILL

- `verification-plan-generator`: 验证方案生成
- `test-point-generator`: 测试点生成
- `testbench-generator`: 测试平台生成
- `chip-design-orchestrator`: 调度整个芯片设计流程
