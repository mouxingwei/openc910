const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber, LevelFormat } = require('docx');
const fs = require('fs');
const path = require('path');

const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };

function createTable(rows, columnWidths) {
    if (rows.length === 0) return null;
    const numCols = rows[0].length;
    const widths = columnWidths || Array(numCols).fill(Math.floor(9360 / numCols));
    
    const tableRows = rows.map((row, rowIdx) => {
        const cells = row.map((cell, colIdx) => {
            return new TableCell({
                borders,
                width: { size: widths[colIdx] || Math.floor(9360 / numCols), type: WidthType.DXA },
                shading: rowIdx === 0 ? { fill: "D5E8F0", type: ShadingType.CLEAR } : undefined,
                margins: { top: 80, bottom: 80, left: 120, right: 120 },
                children: [new Paragraph({ 
                    children: [new TextRun({ text: cell, bold: rowIdx === 0, size: 20 })]
                })]
            });
        });
        return new TableRow({ children: cells });
    });
    
    return new Table({
        width: { size: 9360, type: WidthType.DXA },
        columnWidths: widths,
        rows: tableRows
    });
}

function createHeading1(text) {
    return new Paragraph({
        heading: HeadingLevel.HEADING_1,
        children: [new TextRun({ text, bold: true, size: 32 })]
    });
}

function createHeading2(text) {
    return new Paragraph({
        heading: HeadingLevel.HEADING_2,
        children: [new TextRun({ text, bold: true, size: 28 })]
    });
}

function createHeading3(text) {
    return new Paragraph({
        heading: HeadingLevel.HEADING_3,
        children: [new TextRun({ text, bold: true, size: 24 })]
    });
}

function createHeading4(text) {
    return new Paragraph({
        heading: HeadingLevel.HEADING_4,
        children: [new TextRun({ text, bold: true, size: 22 })]
    });
}

function createParagraph(text) {
    return new Paragraph({
        children: [new TextRun({ text, size: 22 })]
    });
}

function createBullet(text) {
    return new Paragraph({
        bullet: { level: 0 },
        children: [new TextRun({ text, size: 22 })]
    });
}

function createAsciiDiagram(lines) {
    return new Paragraph({
        children: [new TextRun({ text: lines.join('\n'), font: "Courier New", size: 18 })]
    });
}

function createEmptyParagraph() {
    return new Paragraph({ children: [] });
}

const children = [
    createHeading1("IU (Integer Unit) 整数单元"),
    createEmptyParagraph(),
    
    createHeading2("1. 模块功能说明"),
    createParagraph("IU (Integer Unit) 是 OpenC910 处理器的整数执行单元，负责执行所有整数运算、分支处理和特殊指令。IU 采用多发射架构，支持乱序执行，是处理器性能的关键组件。"),
    createEmptyParagraph(),
    
    createHeading3("主要功能"),
    createBullet("整数运算: 执行加、减、逻辑运算、移位等整数操作"),
    createBullet("分支处理: 执行分支指令，计算分支目标，处理分支误预测"),
    createBullet("乘法运算: 执行整数乘法，支持 65×65 位乘法"),
    createBullet("除法运算: 执行整数除法和取余，采用基数16 SRT 算法"),
    createBullet("特殊指令: 执行 CSR 访问、系统调用、vsetvli 等特殊指令"),
    createBullet("向量寄存器传输: 支持 MTVR/MFVR 指令进行标量-向量寄存器数据传输"),
    createEmptyParagraph(),
    
    createHeading3("主要特性"),
    createTable([
        ["特性", "描述"],
        ["ALU 数量", "2 个 (Pipe0, Pipe1)"],
        ["ALU 延迟", "1 周期 (大部分运算)"],
        ["乘法器延迟", "3-4 周期"],
        ["除法器延迟", "可变 (SRT 算法)"],
        ["分支单元", "1 个 (Pipe2)"],
        ["PC FIFO 深度", "16 条目"],
        ["支持指令集", "RV64IMAC + RVV 扩展"]
    ], [3000, 6360]),
    createEmptyParagraph(),
    
    createHeading2("2. 模块接口说明"),
    createHeading3("2.1 接口列表"),
    createEmptyParagraph(),
    
    createHeading4("与 IDU (译码单元) 的接口 - Pipe0 (ALU)"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["idu_iu_rf_pipe0_sel", "I", "1", "Pipe0 选择信号"],
        ["idu_iu_rf_pipe0_gateclk_sel", "I", "1", "Pipe0 门控时钟选择"],
        ["idu_iu_rf_pipe0_src0", "I", "64", "Pipe0 源操作数0"],
        ["idu_iu_rf_pipe0_src1", "I", "64", "Pipe0 源操作数1"],
        ["idu_iu_rf_pipe0_src2", "I", "64", "Pipe0 源操作数2"],
        ["idu_iu_rf_pipe0_func", "I", "5", "Pipe0 功能码"],
        ["idu_iu_rf_pipe0_imm", "I", "6", "Pipe0 立即数"],
        ["idu_iu_rf_pipe0_dst_preg", "I", "7", "Pipe0 目标物理寄存器"],
        ["idu_iu_rf_pipe0_dst_vld", "I", "1", "Pipe0 目标有效"],
        ["idu_iu_rf_pipe0_iid", "I", "7", "Pipe0 指令ID"],
        ["idu_iu_rf_pipe0_vl", "I", "8", "Pipe0 向量长度"],
        ["idu_iu_rf_pipe0_vlmul", "I", "2", "Pipe0 向量乘数"],
        ["idu_iu_rf_pipe0_vsew", "I", "3", "Pipe0 向量元素宽度"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 IDU (译码单元) 的接口 - Pipe1 (ALU/MULT)"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["idu_iu_rf_pipe1_sel", "I", "1", "Pipe1 选择信号"],
        ["idu_iu_rf_pipe1_src0", "I", "64", "Pipe1 源操作数0"],
        ["idu_iu_rf_pipe1_src1", "I", "64", "Pipe1 源操作数1"],
        ["idu_iu_rf_pipe1_src2", "I", "64", "Pipe1 源操作数2"],
        ["idu_iu_rf_pipe1_func", "I", "5", "Pipe1 功能码"],
        ["idu_iu_rf_pipe1_mult_func", "I", "8", "Pipe1 乘法功能码"],
        ["idu_iu_rf_pipe1_dst_preg", "I", "7", "Pipe1 目标物理寄存器"],
        ["idu_iu_rf_pipe1_iid", "I", "7", "Pipe1 指令ID"],
        ["idu_iu_rf_mult_sel", "I", "1", "乘法选择信号"],
        ["idu_iu_rf_pipe1_mla_src2_preg", "I", "7", "MLA 源2物理寄存器"],
        ["idu_iu_rf_pipe1_mla_src2_vld", "I", "1", "MLA 源2有效"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 IDU (译码单元) 的接口 - Pipe2 (BJU)"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["idu_iu_rf_bju_sel", "I", "1", "BJU 选择信号"],
        ["idu_iu_rf_pipe2_func", "I", "8", "Pipe2 功能码"],
        ["idu_iu_rf_pipe2_src0", "I", "64", "Pipe2 源操作数0"],
        ["idu_iu_rf_pipe2_src1", "I", "64", "Pipe2 源操作数1"],
        ["idu_iu_rf_pipe2_iid", "I", "7", "Pipe2 指令ID"],
        ["idu_iu_rf_pipe2_offset", "I", "21", "Pipe2 分支偏移量"],
        ["idu_iu_rf_pipe2_pcall", "I", "1", "PCALL 指令标志"],
        ["idu_iu_rf_pipe2_rts", "I", "1", "RTS 指令标志"],
        ["idu_iu_rf_pipe2_length", "I", "1", "分支长度标志"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 IFU (取指单元) 的接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["iu_ifu_chgflw_vld", "O", "1", "控制流改变有效"],
        ["iu_ifu_chgflw_pc", "O", "63", "控制流改变目标PC"],
        ["iu_ifu_mispred_stall", "O", "1", "分支误预测暂停"],
        ["iu_ifu_bht_check_vld", "O", "1", "BHT 检查有效"],
        ["iu_ifu_bht_pred", "O", "1", "BHT 预测值"],
        ["iu_ifu_cur_pc", "O", "39", "当前PC"],
        ["iu_ifu_pcfifo_full", "O", "1", "PC FIFO 满"],
        ["ifu_iu_pcfifo_create0_en", "I", "1", "PC FIFO 创建0使能"],
        ["ifu_iu_pcfifo_create0_cur_pc", "I", "40", "当前PC"],
        ["ifu_iu_pcfifo_create0_tar_pc", "I", "40", "目标PC"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 RTU (提交单元) 的接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["iu_rtu_pipe0_cmplt", "O", "1", "Pipe0 完成"],
        ["iu_rtu_pipe0_iid", "O", "7", "Pipe0 指令ID"],
        ["iu_rtu_pipe0_expt_vld", "O", "1", "Pipe0 异常有效"],
        ["iu_rtu_pipe0_expt_vec", "O", "5", "Pipe0 异常向量"],
        ["iu_rtu_pipe0_flush", "O", "1", "Pipe0 冲刷"],
        ["iu_rtu_pipe1_cmplt", "O", "1", "Pipe1 完成"],
        ["iu_rtu_pipe2_cmplt", "O", "1", "Pipe2 (分支) 完成"],
        ["iu_rtu_pipe2_bht_mispred", "O", "1", "BHT 误预测"],
        ["iu_rtu_pipe2_jmp_mispred", "O", "1", "跳转误预测"],
        ["rtu_yy_xx_flush", "I", "1", "全局冲刷"],
        ["rtu_iu_flush_fe", "I", "1", "前端冲刷"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 IDU 的前递接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["iu_idu_ex1_pipe0_fwd_preg", "O", "7", "Pipe0 前递物理寄存器"],
        ["iu_idu_ex1_pipe0_fwd_preg_data", "O", "64", "Pipe0 前递数据"],
        ["iu_idu_ex1_pipe0_fwd_preg_vld", "O", "1", "Pipe0 前递有效"],
        ["iu_idu_ex1_pipe1_fwd_preg", "O", "7", "Pipe1 前递物理寄存器"],
        ["iu_idu_ex1_pipe1_fwd_preg_data", "O", "64", "Pipe1 前递数据"],
        ["iu_idu_ex1_pipe1_fwd_preg_vld", "O", "1", "Pipe1 前递有效"],
        ["iu_idu_ex2_pipe0_wb_preg", "O", "7", "Pipe0 写回物理寄存器"],
        ["iu_idu_ex2_pipe0_wb_preg_data", "O", "64", "Pipe0 写回数据"],
        ["iu_idu_ex2_pipe0_wb_preg_vld", "O", "1", "Pipe0 写回有效"],
        ["iu_idu_ex2_pipe1_wb_preg", "O", "7", "Pipe1 写回物理寄存器"],
        ["iu_idu_ex2_pipe1_wb_preg_data", "O", "64", "Pipe1 写回数据"],
        ["iu_idu_ex2_pipe1_wb_preg_vld", "O", "1", "Pipe1 写回有效"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 CP0 (协处理器) 的接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["cp0_iu_icg_en", "I", "1", "时钟门控使能"],
        ["cp0_iu_vl", "I", "8", "向量长度"],
        ["cp0_iu_vill", "I", "1", "向量非法"],
        ["cp0_iu_vstart", "I", "7", "向量起始位置"],
        ["cp0_iu_div_entry_disable", "I", "1", "除法条目禁用"],
        ["cp0_yy_priv_mode", "I", "2", "特权模式"],
        ["cp0_yy_clk_en", "I", "1", "时钟使能"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 VFPU (向量浮点单元) 的接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["iu_vfpu_ex1_pipe0_mtvr_vld", "O", "1", "Pipe0 MTVR 指令有效"],
        ["iu_vfpu_ex1_pipe0_mtvr_vreg", "O", "7", "Pipe0 MTVR 目标向量寄存器"],
        ["iu_vfpu_ex1_pipe0_mtvr_inst", "O", "5", "Pipe0 MTVR 指令类型"],
        ["iu_vfpu_ex1_pipe0_mtvr_vl", "O", "8", "Pipe0 MTVR 向量长度"],
        ["iu_vfpu_ex2_pipe0_mtvr_src0", "O", "64", "Pipe0 MTVR 源数据"],
        ["vfpu_iu_ex2_pipe6_mfvr_data", "I", "64", "Pipe6 MFVR 数据"],
        ["vfpu_iu_ex2_pipe6_mfvr_data_vld", "I", "1", "Pipe6 MFVR 有效"],
        ["vfpu_iu_ex2_pipe6_mfvr_preg", "I", "7", "Pipe6 MFVR 物理寄存器"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("与 HAD (硬件调试) 的接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["iu_had_debug_info", "O", "10", "调试信息"],
        ["had_idu_wbbr_data", "I", "64", "写回旁路数据"],
        ["had_idu_wbbr_vld", "I", "1", "写回旁路有效"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading4("系统接口"),
    createTable([
        ["信号名", "方向", "位宽", "描述"],
        ["forever_cpuclk", "I", "1", "CPU 时钟"],
        ["cpurst_b", "I", "1", "复位信号 (低有效)"],
        ["mmu_xx_mmu_en", "I", "1", "MMU 使能"],
        ["pad_yy_icg_scan_en", "I", "1", "扫描使能"],
        ["iu_yy_xx_cancel", "O", "1", "取消信号"]
    ], [3500, 800, 800, 4260]),
    createEmptyParagraph(),
    
    createHeading3("2.2 模块参数"),
    createTable([
        ["参数名", "默认值", "描述"],
        ["ALU_SEL", "21", "ALU 选择信号位宽"]
    ], [3000, 2000, 4360]),
    createEmptyParagraph(),
    
    createHeading2("3. 模块框图"),
    createParagraph("IU 模块框图 (ASCII 艺术):"),
    createEmptyParagraph(),
    createAsciiDiagram([
        "┌─────────────────────────────────────────────────────────────────────┐",
        "│                         IU Top (整数单元顶层)                        │",
        "│                                                                     │",
        "│  ┌─────────────────────┐    ┌─────────────────────┐                │",
        "│  │      ALU 单元        │    │      乘除单元        │                │",
        "│  │  ┌───────┐ ┌───────┐│    │  ┌───────┐ ┌───────┐│                │",
        "│  │  │ Pipe0 │ │ Pipe1 ││    │  │ MULT  │ │ DIV   ││                │",
        "│  │  │ (ALU) │ │(ALU)  ││    │  │(乘法) │ │(除法) ││                │",
        "│  │  └───────┘ └───────┘│    │  └───────┘ └───────┘│                │",
        "│  └─────────────────────┘    └─────────────────────┘                │",
        "│                                                                     │",
        "│  ┌─────────────────────┐    ┌─────────────────────┐                │",
        "│  │      分支单元        │    │     特殊指令单元     │                │",
        "│  │  ┌───────────────┐  │    │  ┌───────────────┐  │                │",
        "│  │  │   BJU (Pipe2) │  │    │  │   SPECIAL     │  │                │",
        "│  │  └───────────────┘  │    │  └───────────────┘  │                │",
        "│  └─────────────────────┘    └─────────────────────┘                │",
        "│                                                                     │",
        "│  ┌─────────────────────────────────────────────────────────────┐   │",
        "│  │                        总线单元                               │   │",
        "│  │    ┌───────────────┐          ┌───────────────┐              │   │",
        "│  │    │  CBUS (控制)  │          │  RBUS (结果)  │              │   │",
        "│  │    └───────────────┘          └───────────────┘              │   │",
        "│  └─────────────────────────────────────────────────────────────┘   │",
        "└─────────────────────────────────────────────────────────────────────┘"
    ]),
    createEmptyParagraph(),
    
    createHeading2("4. 模块实现方案"),
    createHeading3("4.1 执行流水线架构"),
    createParagraph("IU 采用多条独立的执行流水线，支持并行执行："),
    createEmptyParagraph(),
    createAsciiDiagram([
        "┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐",
        "│   RF    │──►│   EX1   │──►│   EX2   │──►│   WB    │   Pipe0 (ALU)",
        "└─────────┘   └─────────┘   └─────────┘   └─────────┘",
        "",
        "┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐",
        "│   RF    │──►│   EX1   │──►│   EX2   │──►│   EX3   │──►│   EX4   │   Pipe1 (MULT)",
        "└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘",
        "",
        "┌─────────┐   ┌─────────┐   ┌─────────┐",
        "│   RF    │──►│   EX1   │──►│   EX2   │                                 Pipe2 (BJU)",
        "└─────────┘   └─────────┘   └─────────┘",
        "",
        "┌─────────┐   ┌─────────────┐   ┌─────────┐",
        "│   RF    │──►│  迭代循环... │──►│   WB    │                                 DIV (除法器)",
        "└─────────┘   └─────────────┘   └─────────┘"
    ]),
    createEmptyParagraph(),
    createParagraph("各级功能说明："),
    createTable([
        ["流水线", "阶段", "功能描述"],
        ["Pipe0", "EX1", "ALU 运算执行"],
        ["Pipe0", "EX2", "结果写回、前递"],
        ["Pipe1", "EX1", "ALU 运算执行 / 乘法 Booth 编码"],
        ["Pipe1", "EX2", "乘法部分积压缩"],
        ["Pipe1", "EX3", "乘法最终加法"],
        ["Pipe1", "EX4", "乘法结果写回"],
        ["Pipe2", "EX1", "分支目标计算"],
        ["Pipe2", "EX2", "分支结果确认、误预测处理"],
        ["DIV", "迭代", "SRT 除法迭代 (可变周期)"],
        ["DIV", "WB", "除法结果写回"]
    ], [2000, 1500, 5860]),
    createEmptyParagraph(),
    
    createHeading3("4.2 ALU 实现方案"),
    createParagraph("ALU 支持以下运算类型："),
    createTable([
        ["类型", "操作", "延迟"],
        ["加减法", "ADD, ADDI, SUB", "1 周期"],
        ["逻辑运算", "AND, OR, XOR, ANDI, ORI, XORI", "1 周期"],
        ["移位运算", "SLL, SRL, SRA, SLLI, SRLI, SRAI", "1 周期"],
        ["比较运算", "SLT, SLTI, SLTU, SLTIU", "1 周期"],
        ["条件分支", "BEQ, BNE, BLT, BGE, BLTU, BGEU", "1 周期"]
    ], [2500, 4500, 2360]),
    createEmptyParagraph(),
    
    createHeading3("4.3 乘法器实现方案"),
    createParagraph("乘法器特性："),
    createBullet("支持 65×65 位乘法"),
    createBullet("采用 Booth 编码算法"),
    createBullet("3 级流水线结构"),
    createBullet("支持 MLA (乘累加) 指令"),
    createBullet("支持 SIMD 操作"),
    createEmptyParagraph(),
    
    createHeading3("4.4 除法器实现方案 (SRT 基数16)"),
    createTable([
        ["特性", "描述"],
        ["算法", "SRT 基数16"],
        ["每次迭代", "产生 4 位商"],
        ["迭代次数", "可变 (取决于操作数)"],
        ["支持指令", "DIV, DIVU, REM, REMU, DIVW, DIVUW, REMW, REMUW"],
        ["异常处理", "除零异常"]
    ], [3000, 6360]),
    createEmptyParagraph(),
    
    createHeading3("4.5 分支处理单元 (BJU)"),
    createParagraph("BJU 负责："),
    createBullet("分支目标计算"),
    createBullet("分支条件判断"),
    createBullet("分支误预测检测"),
    createBullet("PC FIFO 管理 (16 条目)"),
    createBullet("与 IFU 的分支预测器交互"),
    createEmptyParagraph(),
    
    createHeading3("4.6 结果总线 (RBUS)"),
    createParagraph("RBUS 负责："),
    createBullet("收集各执行单元的结果"),
    createBullet("前递数据到 IDU"),
    createBullet("写回数据到物理寄存器堆"),
    createBullet("支持多份复制用于软错误防护"),
    createEmptyParagraph(),
    
    createHeading3("4.7 控制总线 (CBUS)"),
    createParagraph("CBUS 负责："),
    createBullet("收集各执行单元的完成信号"),
    createBullet("异常信号仲裁"),
    createBullet("生成到 RTU 的控制信号"),
    createEmptyParagraph(),
    
    createHeading2("5. 内部关键信号列表"),
    createTable([
        ["信号名", "位宽", "描述"],
        ["alu_rbus_ex1_pipe0_data", "64", "ALU Pipe0 结果数据"],
        ["alu_rbus_ex1_pipe0_data_vld", "1", "ALU Pipe0 结果有效"],
        ["alu_rbus_ex1_pipe0_fwd_data", "64", "ALU Pipe0 前递数据"],
        ["alu_rbus_ex1_pipe0_fwd_vld", "1", "ALU Pipe0 前递有效"],
        ["alu_rbus_ex1_pipe0_preg", "7", "ALU Pipe0 物理寄存器"],
        ["alu_rbus_ex1_pipe1_data", "64", "ALU Pipe1 结果数据"],
        ["alu_rbus_ex1_pipe1_fwd_data", "64", "ALU Pipe1 前递数据"],
        ["mult_rbus_ex3_data_vld", "1", "乘法 EX3 结果有效"],
        ["mult_rbus_ex3_preg", "7", "乘法 EX3 物理寄存器"],
        ["mult_rbus_ex4_data", "64", "乘法 EX4 结果数据"],
        ["mult_rbus_ex4_data_vld", "1", "乘法 EX4 结果有效"],
        ["div_rbus_data", "64", "除法结果数据"],
        ["div_rbus_pipe0_data_vld", "1", "除法结果有效"],
        ["div_rbus_preg", "7", "除法物理寄存器"],
        ["div_top_div_no_idle", "1", "除法器非空闲"],
        ["div_top_div_wf_wb", "1", "除法器等待写回"],
        ["bju_cbus_ex2_pipe2_abnormal", "1", "BJU 异常标志"],
        ["bju_cbus_ex2_pipe2_bht_mispred", "1", "BHT 误预测"],
        ["bju_cbus_ex2_pipe2_jmp_mispred", "1", "跳转误预测"],
        ["bju_cbus_ex2_pipe2_iid", "7", "BJU 指令ID"],
        ["bju_special_pc", "40", "特殊指令 PC"],
        ["bju_top_pcfifo_full", "1", "PC FIFO 满"],
        ["bju_top_mispred_iid", "7", "误预测指令ID"],
        ["special_cbus_ex1_abnormal", "1", "特殊指令异常"],
        ["special_cbus_ex1_expt_vld", "1", "特殊指令异常有效"],
        ["special_cbus_ex1_expt_vec", "5", "特殊指令异常向量"],
        ["special_rbus_ex1_data", "64", "特殊指令结果数据"],
        ["special_rbus_ex1_data_vld", "1", "特殊指令结果有效"]
    ], [4000, 1200, 4160]),
    createEmptyParagraph(),
    
    createHeading2("6. 模块表项设置"),
    createTable([
        ["表项名称", "域段内容", "RAM资源"],
        ["PC FIFO", "PC[39:0], Target[39:0], BHT info, ChkIdx[24:0]", "16×48"],
        ["Div Entry", "Dividend[63:0], Divisor[63:0], Quotient[63:0], State", "8×128"]
    ], [2500, 4500, 2360]),
    createEmptyParagraph(),
    
    createHeading2("7. 子模块方案"),
    createTable([
        ["子模块名称", "功能描述", "文档链接"],
        ["ct_iu_alu", "算术逻辑单元 (Pipe0/Pipe1)", "alu.md"],
        ["ct_iu_bju", "分支处理单元 (Pipe2)", "bju.md"],
        ["ct_iu_mult", "乘法器", "mult.md"],
        ["ct_iu_div", "除法器", "div.md"],
        ["ct_iu_special", "特殊指令处理单元", "special.md"],
        ["ct_iu_cbus", "控制总线", "cbus.md"],
        ["ct_iu_rbus", "结果总线", "rbus.md"]
    ], [3000, 4000, 2360]),
    createEmptyParagraph(),
    
    createHeading2("8. 可测试性设计"),
    createHeading3("8.1 扫描链设计"),
    createBullet("所有触发器支持扫描链插入"),
    createBullet("除法器支持单独测试模式"),
    createBullet("乘法器支持单独测试模式"),
    createEmptyParagraph(),
    
    createHeading3("8.2 调试支持"),
    createBullet("支持 HAD (Hardware Assisted Debug) 接口"),
    createBullet("支持除法器状态读取"),
    createBullet("支持分支误预测信息输出"),
    createParagraph("调试信息输出 (iu_had_debug_info):"),
    createBullet("bit[0]: PC FIFO 满状态"),
    createBullet("bit[1]: 除法器非空闲"),
    createBullet("bit[2]: 除法器等待写回"),
    createBullet("bit[9:3]: 误预测指令ID"),
    createEmptyParagraph(),
    
    createHeading3("8.3 性能计数"),
    createBullet("ALU 指令计数"),
    createBullet("乘法指令计数"),
    createBullet("除法指令计数"),
    createBullet("分支指令计数"),
    createBullet("分支误预测计数"),
    createBullet("PC FIFO 满周期"),
    createEmptyParagraph(),
    
    createHeading3("8.4 时钟门控"),
    createBullet("支持 ALU 门控时钟 (idu_iu_rf_pipe0/1_gateclk_sel)"),
    createBullet("支持乘法器门控时钟 (idu_iu_rf_mult_gateclk_sel)"),
    createBullet("支持除法器门控时钟 (idu_iu_rf_div_gateclk_sel)"),
    createBullet("支持 BJU 门控时钟 (idu_iu_rf_bju_gateclk_sel)"),
    createBullet("支持特殊指令门控时钟 (idu_iu_rf_special_gateclk_sel)"),
    createEmptyParagraph(),
    
    createParagraph("─────────────────────────────────────────────────────────────"),
    createParagraph("文档生成时间: 2026-03-11"),
    createParagraph("基于 OpenC910 RTL 代码自动生成")
];

const doc = new Document({
    styles: {
        default: { document: { run: { font: "Arial", size: 22 } } },
        paragraphStyles: [
            { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
              run: { size: 32, bold: true, font: "Arial" },
              paragraph: { spacing: { before: 240, after: 240 }, outlineLevel: 0 } },
            { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
              run: { size: 28, bold: true, font: "Arial" },
              paragraph: { spacing: { before: 180, after: 180 }, outlineLevel: 1 } },
            { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
              run: { size: 24, bold: true, font: "Arial" },
              paragraph: { spacing: { before: 120, after: 120 }, outlineLevel: 2 } },
            { id: "Heading4", name: "Heading 4", basedOn: "Normal", next: "Normal", quickFormat: true,
              run: { size: 22, bold: true, font: "Arial" },
              paragraph: { spacing: { before: 100, after: 100 }, outlineLevel: 3 } },
        ]
    },
    numbering: {
        config: [{
            reference: "bullets",
            levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
                style: { paragraph: { indent: { left: 720, hanging: 360 } } } }]
        }]
    },
    sections: [{
        properties: {
            page: { margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } }
        },
        headers: {
            default: new Header({ children: [new Paragraph({ 
                children: [new TextRun({ text: "OpenC910 模块文档 - IU (Integer Unit)", size: 18 })]
            })] })
        },
        footers: {
            default: new Footer({ children: [new Paragraph({
                alignment: AlignmentType.CENTER,
                children: [new TextRun({ text: "第 ", size: 18 }), new TextRun({ children: [PageNumber.CURRENT], size: 18 }), new TextRun({ text: " 页", size: 18 })]
            })] })
        },
        children: children
    }]
});

Packer.toBuffer(doc).then(buffer => {
    fs.writeFileSync(path.join(__dirname, 'iu_top.docx'), buffer);
    console.log('Generated: iu_top.docx');
});
