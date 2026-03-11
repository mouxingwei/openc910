const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber, LevelFormat, PageBreak } = require('docx');
const fs = require('fs');

const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };

const doc = new Document({
    styles: {
        default: { document: { run: { font: "Arial", size: 24 } } },
        paragraphStyles: [
            { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 32, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 240, after: 240 }, outlineLevel: 0 } },
            { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 28, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 180, after: 180 }, outlineLevel: 1 } },
            { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 26, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 120, after: 120 }, outlineLevel: 2 } },
        ]
    },
    numbering: {
        config: [
            { reference: "bullets",
                levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
                    style: { paragraph: { indent: { left: 720, hanging: 360 } } } }] },
        ]
    },
    sections: [{
        properties: {
            page: {
                size: { width: 12240, height: 15840 },
                margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 }
            }
        },
        headers: {
            default: new Header({ children: [new Paragraph({
                alignment: AlignmentType.RIGHT,
                children: [new TextRun({ text: "OpenC910 处理器设计文档", size: 20, color: "666666" })]
            })] })
        },
        footers: {
            default: new Footer({ children: [new Paragraph({
                alignment: AlignmentType.CENTER,
                children: [new TextRun({ text: "第 ", size: 20 }), new TextRun({ children: [PageNumber.CURRENT], size: 20 }), new TextRun({ text: " 页", size: 20 })]
            })] })
        },
        children: [
            new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("ct_top 模块设计文档")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("1. 模块概述")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("1.1 基本信息")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [3120, 6240],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "属性", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 6240, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "值", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("模块名称")] })] }),
                        new TableCell({ borders, width: { size: 6240, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_top")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("文件路径")] })] }),
                        new TableCell({ borders, width: { size: 6240, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("C910_RTL_FACTORY/gen_rtl/cpu/rtl/ct_top.v")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("功能描述")] })] }),
                        new TableCell({ borders, width: { size: 6240, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("OpenC910 处理器顶层模块")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("设计特点")] })] }),
                        new TableCell({ borders, width: { size: 6240, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("RISC-V 64位处理器，支持乱序执行，多发射流水线")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("1.2 功能描述")] }),
            
            new Paragraph({ children: [new TextRun("ct_top 是 OpenC910 处理器的顶层模块，集成了以下主要功能单元：")] }),
            
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "处理器核心 (ct_core)", bold: true }), new TextRun("：包含取指单元、译码单元、执行单元、访存单元等")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "内存管理单元 (ct_mmu_top)", bold: true }), new TextRun("：实现虚拟地址到物理地址的转换")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "物理内存保护 (ct_pmp_top)", bold: true }), new TextRun("：实现物理内存区域的访问控制")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "总线接口单元 (ct_biu_top)", bold: true }), new TextRun("：实现与外部总线的接口")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "硬件调试 (ct_had_private_top)", bold: true }), new TextRun("：支持硬件断点和调试功能")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "性能计数器 (ct_hpcp_top)", bold: true }), new TextRun("：支持性能监控和计数")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "复位控制 (ct_rst_top)", bold: true }), new TextRun("：处理器复位管理")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun({ text: "时钟控制 (ct_clk_top)", bold: true }), new TextRun("：处理器时钟管理")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("1.3 设计特点")] }),
            
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 RISC-V RV64GC 指令集")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("乱序执行，双发射流水线")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 AXI4 总线接口")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持硬件调试和性能监控")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持多核配置")] }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("2. 模块接口说明")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.1 输入端口")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [2340, 1170, 1170, 4680],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "信号名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "方向", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "位宽", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pll_core_clk")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("PLL 时钟输入")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_cpu_rst_b")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("CPU 复位信号（低有效）")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_biu_arready")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 读地址就绪")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_biu_awready")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 写地址就绪")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_biu_rdata")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("128")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 读数据")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_core_hartid")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("3")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("硬件线程 ID")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.2 输出端口")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [2340, 1170, 1170, 4680],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "信号名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "方向", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "位宽", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_pad_arvalid")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 读地址有效")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_pad_araddr")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("40")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 读地址")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_pad_awvalid")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 写地址有效")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_pad_wdata")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("128")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("AXI 写数据")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_pad_mstatus")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("M 状态寄存器")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("3. 模块框图")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("3.1 模块架构图")] }),
            
            new Paragraph({ children: [new TextRun("ct_top 模块包含以下主要子模块：")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [2340, 2340, 4680],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "模块名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "实例名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "功能描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_core")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_core")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("处理器核心")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_mmu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_mmu_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("内存管理单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_pmp_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_pmp_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("物理内存保护")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_biu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_biu_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("总线接口单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_had_private_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_had_private_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("硬件调试")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_hpcp_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_hpcp_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("性能计数器")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_rst_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_rst_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("复位控制")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_clk_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_clk_top")] })] }),
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("时钟控制")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("4. 模块实现方案")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("4.1 流水线设计")] }),
            
            new Paragraph({ children: [new TextRun("OpenC910 采用双发射乱序执行流水线，主要流水线阶段包括：")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [1872, 2340, 1404, 3744],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1872, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "流水线", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "执行单元", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1404, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "级数", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "支持指令", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1872, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("Pipe0")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ALU0/BRU/MUL")] })] }),
                        new TableCell({ borders, width: { size: 1404, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("5-7")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("整数运算、分支、乘法")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1872, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("Pipe1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ALU1/DIV")] })] }),
                        new TableCell({ borders, width: { size: 1404, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("5-40")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("整数运算、除法")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1872, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("Pipe2")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("LSU")] })] }),
                        new TableCell({ borders, width: { size: 1404, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("3-20")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("加载/存储指令")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1872, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("Pipe3")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("VFPU")] })] }),
                        new TableCell({ borders, width: { size: 1404, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("5-15")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("浮点运算")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("4.2 关键逻辑描述")] }),
            
            new Paragraph({ children: [new TextRun({ text: "时钟和复位管理", bold: true })] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持多种时钟源选择")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持时钟门控以降低功耗")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持异步复位和同步释放")] }),
            
            new Paragraph({ children: [new TextRun({ text: "总线接口", bold: true })] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 AXI4 总线协议")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 128 位数据宽度")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持突发传输")] }),
            
            new Paragraph({ children: [new TextRun({ text: "调试支持", bold: true })] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 JTAG 调试接口")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持硬件断点")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持单步执行")] }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("5. 子模块方案")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("5.1 子模块列表")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [936, 2340, 2340, 3744],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "层级", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "模块名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "实例名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "功能描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_core")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_core")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("处理器核心")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_mmu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_mmu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("内存管理单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_biu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_biu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("总线接口单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_ifu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_ifu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("取指单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_idu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_idu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("译码单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_iu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_iu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("整数执行单元")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 936, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_lsu_top")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_lsu_top")] })] }),
                        new TableCell({ borders, width: { size: 3744, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("访存单元")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("6. 可测试性设计")] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("6.1 测试信号")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [3120, 1170, 1170, 3900],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "信号名", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "方向", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "位宽", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 3900, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_yy_scan_mode")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 3900, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("扫描模式使能")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_yy_scan_rst_b")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 3900, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("扫描复位")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_yy_icg_scan_en")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 3900, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ICG 扫描使能")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pad_yy_mbist_mode")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1170, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 3900, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("MBIST 模式")] })] })
                    ]})
                ]
            }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("6.2 调试接口")] }),
            
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持 JTAG 调试接口")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持硬件断点（指令断点和数据断点）")] }),
            new Paragraph({ numbering: { reference: "bullets", level: 0 }, children: [new TextRun("支持外部调试请求")] }),
            
            new Paragraph({ children: [new PageBreak()] }),
            
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("7. 修订历史")] }),
            
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [1560, 2340, 2340, 3120],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "版本", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "日期", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "作者", bold: true })] })] }),
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "说明", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1.0")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2024-01-01")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("T-Head")] })] }),
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("初始版本")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1.1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2024-06-01")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("T-Head")] })] }),
                        new TableCell({ borders, width: { size: 3120, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("添加性能优化")] })] })
                    ]})
                ]
            })
        ]
    }]
});

Packer.toBuffer(doc).then(buffer => {
    fs.writeFileSync("d:/code/openc910/.trae/documents/ct_top_top.docx", buffer);
    console.log("Word文档生成完成: d:/code/openc910/.trae/documents/ct_top_top.docx");
});
