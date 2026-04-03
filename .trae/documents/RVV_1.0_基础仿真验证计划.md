# RVV 1.0 基础仿真验证计划

## 文档信息

* **文档版本**: 1.0

* **创建日期**: 2026-04-02

* **目标**: 验证RVV 1.0升级修改的正确性

* **验证范围**: C910\_RTL\_FACTORY\gen\_rtl \_rvv1.0

***

## 1. 验证目标

### 1.1 主要目标

1. 验证CSR寄存器修改的正确性
2. 验证vtype字段扩展的正确性
3. 验证新增指令解码的正确性
4. 验证FOF加载支持的正确性
5. 验证异常处理修改的正确性

### 1.2 验证策略

* 采用**增量验证**策略：从底层模块到系统级逐步验证

* 采用**对比验证**策略：与RVV 0.7.1行为对比

* 采用**边界验证**策略：重点验证边界条件

***

## 2. 验证环境准备

### 2.1 仿真工具

* **主要工具**:  Verilator /IVerilog

* **波形查看**: Verdi / GTKWave

* **覆盖率工具**: VCS Coverage / Verilator Coverage

### 2.2 测试平台文件

需要创建/修改以下验证文件：

| 文件路径                                          | 功能描述         | 优先级 |
| --------------------------------------------- | ------------ | --- |
| `verification/tb/cp0/tb_cp0_vcsr.v`           | VCSR寄存器测试    | 高   |
| `verification/tb/rtu/tb_rtu_vtype.v`          | vtype字段测试    | 高   |
| `verification/tb/idu/tb_idu_vsetivli.v`       | vsetivli指令测试 | 高   |
| `verification/tb/lsu/tb_lsu_fof.v`            | FOF加载测试      | 中   |
| `verification/tb/full_chip/tb_rvv1_0_basic.v` | 系统级基础测试      | 高   |

### 2.3 编译脚本修改

需要修改编译脚本以包含新的RTL文件：

```tcl
# 在编译脚本中添加
set RTL_PATH "../C910_RTL_FACTORY/gen_rtl _rvv1.0"
vlog +incdir+$RTL_PATH/cp0/rtl $RTL_PATH/cp0/rtl/*.v
vlog +incdir+$RTL_PATH/rtu/rtl $RTL_PATH/rtu/rtl/*.v
vlog +incdir+$RTL_PATH/idu/rtl $RTL_PATH/idu/rtl/*.v
vlog +incdir+$RTL_PATH/lsu/rtl $RTL_PATH/lsu/rtl/*.v
```

***

## 3. 模块级验证计划

### 3.1 CSR寄存器验证

#### 3.1.1 VCSR寄存器测试

**测试用例**:

| 用例ID      | 测试内容         | 测试步骤                 | 预期结果               |
| --------- | ------------ | -------------------- | ------------------ |
| VCSR\_001 | VCSR读操作      | 1. 读取VCSR地址0x00F     | 返回{VXRM, VXSAT}镜像值 |
| VCSR\_002 | VCSR写操作      | 1. 写入VCSR值0x7        | VCSR\[2:0]=0x7     |
| VCSR\_003 | VCSR与VXSAT同步 | 1. 写VXSAT=1 2. 读VCSR | VCSR\[0]=1         |
| VCSR\_004 | VCSR与VXRM同步  | 1. 写VXRM=2 2. 读VCSR  | VCSR\[2:1]=2       |

**测试代码框架**:

```verilog
module tb_cp0_vcsr;
  reg clk, rst_b;
  reg [11:0] csr_addr;
  reg [63:0] csr_wdata;
  reg csr_wen;
  wire [63:0] csr_rdata;

  // 测试VCSR读写
  initial begin
    // VCSR_001: 读操作
    csr_addr = 12'h00F;
    csr_wen = 0;
    #10;
    $display("VCSR Read: 0x%h", csr_rdata);
    
    // VCSR_002: 写操作
    csr_wdata = 64'h7;
    csr_wen = 1;
    #10;
    csr_wen = 0;
    #10;
    
    // 验证写入成功
    if (csr_rdata[2:0] === 3'h7)
      $display("VCSR_002 PASS");
    else
      $display("VCSR_002 FAIL");
  end
endmodule
```

#### 3.1.2 vtype字段测试

**测试用例**:

| 用例ID       | 测试内容      | 测试步骤                    | 预期结果               |
| ---------- | --------- | ----------------------- | ------------------ |
| VTYPE\_001 | vlmul字段扩展 | 1. 设置vlmul=5 (LMUL=1/8) | vlmul\[2:0]=3'b101 |
| VTYPE\_002 | vma字段设置   | 1. 设置vma=1              | vtype\[7]=1        |
| VTYPE\_003 | vta字段设置   | 1. 设置vta=1              | vtype\[6]=1        |
| VTYPE\_004 | vtype完整布局 | 1. 设置完整vtype值           | 字段位置正确             |

***

### 3.2 ROB模块验证

#### 3.2.1 ROB条目扩展测试

**测试用例**:

| 用例ID     | 测试内容         | 测试步骤              | 预期结果     |
| -------- | ------------ | ----------------- | -------- |
| ROB\_001 | ROB\_WIDTH扩展 | 1. 创建ROB条目        | 数据宽度为42位 |
| ROB\_002 | vlmul存储      | 1. 写入vlmul=3'b101 | 正确存储3位值  |
| ROB\_003 | vma存储        | 1. 写入vma=1        | 正确存储vma  |
| ROB\_004 | vta存储        | 1. 写入vta=1        | 正确存储vta  |

***

### 3.3 指令解码验证

#### 3.3.1 vsetivli指令测试

**测试用例**:

| 用例ID          | 测试内容  | 测试指令                       | 预期结果             |
| ------------- | ----- | -------------------------- | ---------------- |
| VSETIVLI\_001 | 基本解码  | `vsetivli x0, 8, e32, m1`  | decd\_vsetivli=1 |
| VSETIVLI\_002 | 立即数提取 | `vsetivli x1, 15, e64, m2` | 正确提取zimm字段       |
| VSETIVLI\_003 | 非法检测  | 非法编码                       | x\_illegal=1     |

**测试代码框架**:

```verilog
module tb_idu_vsetivli;
  reg [31:0] inst;
  wire decd_vsetivli;
  wire x_illegal;
  
  // vsetivli编码: bit[31:30]=11, funct3=111, opcode=1010111
  initial begin
    // VSETIVLI_001
    inst = 32'hC18007D7; // vsetivli x0, 8, e32, m1
    #10;
    if (decd_vsetivli && !x_illegal)
      $display("VSETIVLI_001 PASS");
    else
      $display("VSETIVLI_001 FAIL");
  end
endmodule
```

#### 3.3.2 近似计算指令测试

**测试用例**:

| 用例ID          | 测试内容        | 测试指令                 | 预期结果              |
| ------------- | ----------- | -------------------- | ----------------- |
| VFRECE7\_001  | vfrece7解码   | `vfrece7.v v1, v2`   | decd\_vfrece7=1   |
| VFRSQRT7\_001 | vfrsqrte7解码 | `vfrsqrte7.v v1, v2` | decd\_vfrsqrte7=1 |

***

### 3.4 FOF加载验证

#### 3.4.1 FOF信号传递测试

**测试用例**:

| 用例ID     | 测试内容     | 测试步骤           | 预期结果                     |
| -------- | -------- | -------------- | ------------------------ |
| FOF\_001 | IDU解码    | 1. 输入FOF加载指令   | pipe3\_decd\_inst\_fof=1 |
| FOF\_002 | LD\_AG传递 | 1. FOF指令进入AG阶段 | ld\_ag\_inst\_fof=1      |
| FOF\_003 | LD\_DC传递 | 1. FOF指令进入DC阶段 | ld\_dc\_inst\_fof=1      |
| FOF\_004 | LD\_DA传递 | 1. FOF指令进入DA阶段 | ld\_da\_inst\_fof=1      |

#### 3.4.2 FOF异常处理测试

**测试用例**:

| 用例ID     | 测试内容  | 测试步骤             | 预期结果        |
| -------- | ----- | ---------------- | ----------- |
| FOF\_005 | 首元素成功 | 1. FOF加载，首元素地址有效 | 正常加载，不触发异常  |
| FOF\_006 | 首元素失败 | 1. FOF加载，首元素地址无效 | 停止加载，更新vl   |
| FOF\_007 | vl更新  | 1. FOF加载部分成功     | vl=成功加载的元素数 |

***

### 3.5 异常处理验证

#### 3.5.1 vstart异常测试

**测试用例**:

| 用例ID        | 测试内容       | 测试步骤                | 预期结果      |
| ----------- | ---------- | ------------------- | --------- |
| VSTART\_001 | vstart=0   | 1. vstart=0执行向量指令   | 正常执行      |
| VSTART\_002 | vstart!=0  | 1. vstart=5执行向量指令   | 从元素5开始执行  |
| VSTART\_003 | vstart>=vl | 1. vstart>=vl执行向量指令 | 不执行，不触发异常 |

#### 3.5.2 vill异常测试

**测试用例**:

| 用例ID      | 测试内容   | 测试步骤            | 预期结果     |
| --------- | ------ | --------------- | -------- |
| VILL\_001 | vill=0 | 1. vill=0执行向量指令 | 正常执行     |
| VILL\_002 | vill=1 | 1. vill=1执行向量指令 | 触发非法指令异常 |

***

## 4. 系统级验证计划

### 4.1 基础功能测试

#### 4.1.1 向量配置测试

**测试程序**:

```asm
# 测试vsetvli指令
vsetvli t0, a0, e32, m1, ta, ma
csrr t1, vtype    # 验证vtype字段
csrr t2, vl       # 验证vl值

# 测试vsetivli指令
vsetivli t0, 8, e32, m1, ta, ma
csrr t1, vtype    # 验证vtype字段
csrr t2, vl       # 验证vl=8

# 测试vsetvl指令
vsetvl t0, a0, a1 # a1包含vtype值
csrr t1, vtype
csrr t2, vl
```

#### 4.1.2 分数LMUL测试

**测试程序**:

```asm
# 测试LMUL=1/8
li a0, 16
vsetivli t0, 16, e32, mf8, ta, ma
vadd.vv v0, v1, v2  # 应使用v0的一部分

# 测试LMUL=1/4
vsetivli t0, 16, e32, mf4, ta, ma
vadd.vv v0, v1, v2

# 测试LMUL=1/2
vsetivli t0, 16, e32, mf2, ta, ma
vadd.vv v0, v1, v2
```

#### 4.1.3 VCSR测试

**测试程序**:

```asm
# 测试VCSR读写
li t0, 0x7
csrw vcsr, t0     # 写VCSR
csrr t1, vcsr     # 读VCSR
csrr t2, vxsat    # 验证VXSAT同步
csrr t3, vxrm     # 验证VXRM同步
```

### 4.2 回归测试

#### 4.2.1 兼容性测试

* 运行现有RVV 0.7.1测试用例

* 验证向后兼容性

* 检查性能回归

#### 4.2.2 覆盖率目标

| 覆盖率类型 | 目标值  | 说明        |
| ----- | ---- | --------- |
| 代码覆盖率 | ≥95% | 行、分支、条件覆盖 |
| 功能覆盖率 | ≥90% | 关键功能点覆盖   |
| 断言覆盖率 | ≥95% | 所有断言被触发   |

***

## 5. 验证执行步骤

### 5.1 阶段一：环境搭建（1天）

1. 创建测试目录结构
2. 修改编译脚本
3. 创建基础测试平台
4. 验证仿真环境

### 5.2 阶段二：模块级验证（3天）

1. 执行CSR寄存器测试
2. 执行ROB模块测试
3. 执行指令解码测试
4. 执行FOF加载测试
5. 执行异常处理测试

### 5.3 阶段三：系统级验证（2天）

1. 执行基础功能测试
2. 执行分数LMUL测试
3. 执行VCSR测试
4. 执行回归测试

### 5.4 阶段四：覆盖率分析（1天）

1. 收集覆盖率数据
2. 分析覆盖率缺口
3. 补充测试用例
4. 达成覆盖率目标

***

## 6. 验证交付物

### 6.1 测试文件

* [ ] tb\_cp0\_vcsr.v - VCSR测试

* [ ] tb\_rtu\_vtype.v - vtype测试

* [ ] tb\_idu\_vsetivli.v - vsetivli测试

* [ ] tb\_lsu\_fof.v - FOF测试

* [ ] tb\_rvv1\_0\_basic.v - 系统级测试

### 6.2 测试程序

* [ ] rvv1\_0\_vsetivli\_test.S - vsetivli测试程序

* [ ] rvv1\_0\_vcsr\_test.S - VCSR测试程序

* [ ] rvv1\_0\_fof\_test.S - FOF测试程序

* [ ] rvv1\_0\_fractional\_lmul\_test.S - 分数LMUL测试

### 6.3 验证报告

* [ ] 模块级验证报告

* [ ] 系统级验证报告

* [ ] 覆盖率报告

* [ ] 问题追踪表

***

## 7. 风险与缓解

| 风险项      | 风险等级 | 缓解措施           |
| -------- | ---- | -------------- |
| 仿真环境不兼容  | 中    | 提前验证编译脚本       |
| 测试用例覆盖不足 | 中    | 参考RISC-V官方测试套件 |
| 回归问题     | 低    | 建立回归测试机制       |

***

## 8. 附录

### 8.1 测试指令编码参考

```
vsetivli:  [31:30]=11, [29:28]=uimm[5:4], [27:26]=zimm[9:8], 
           [25:23]=zimm[7:5], [22]=zimm[8], [21:20]=zimm[4:3],
           [19:15]=rd, [14:12]=111, [11:7]=uimm[4:0], [6:0]=1010111

vfrece7:   [31:26]=000000, [25]=vm, [24:20]=vs2, [19:15]=vd,
           [14:12]=011, [11:7]=vd, [6:0]=1010111

vfrsqrte7: [31:26]=000000, [25]=vm, [24:20]=vs2, [19:15]=vd,
           [14:12]=101, [11:7]=vd, [6:0]=1010111
```

### 8.2 参考文档

1. RISC-V向量扩展规范v1.0
2. OpenC910用户手册
3. RVV\_0.7.1\_to\_1.0\_升级计划.md
4. RVV\_1.0\_修改记录.md

***

**文档结束**
