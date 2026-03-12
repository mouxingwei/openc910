const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber } = require('docx');
const fs = require('fs');

const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
const borders = { top: border, bottom: border, left: border, right: border };

const doc = new Document({
    styles: {
        default: { document: { run: { font: "Arial", size: 24 } } },
        paragraphStyles: [
            { id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 32, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 240, after: 240 } } },
            { id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 28, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 180, after: 180 } } },
            { id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: { size: 26, bold: true, font: "Arial" },
                paragraph: { spacing: { before: 120, after: 120 } } },
        ]
    },
    sections: [{
        properties: {
            page: { size: { width: 12240, height: 15840 }, margin: { top: 1440, right: 1440, bottom: 1440, left: 1440 } }
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
            new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("ct_pmp_regs 模块设计文档")] }),
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
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("模块名称")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("ct_pmp_regs")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("文件路径")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("pmp\rtl\ct_pmp_regs.v")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("层级")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("Level 2")] })] })
                    ]})
                ]
            }),
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("2. 模块接口说明")] }),
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.1 输入端口")] }),
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [4680, 1560, 1560, 1560],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "信号名", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "方向", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "位宽", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_pmp_wdata")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cpuclk")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cpurst_b")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmp_csr_sel")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("18")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmp_csr_wen")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("18")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                ]
            }),
            new Paragraph({ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.2 输出端口")] }),
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [4680, 1560, 1560, 1560],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "信号名", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "方向", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "位宽", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "描述", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmp_cp0_data")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr0_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr1_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr2_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr3_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr4_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr5_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr6_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpaddr7_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("29")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpcfg0_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("pmpcfg2_value")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                ]
            }),
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("3. 子模块列表")] }),
            new Paragraph({ children: [new TextRun("无子模块")] }),
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("4. 修订历史")] }),
            new Table({
                width: { size: 9360, type: WidthType.DXA },
                columnWidths: [2340, 2340, 2340, 2340],
                rows: [
                    new TableRow({ children: [
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "版本", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "日期", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "作者", bold: true })] })] }),
                        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "说明", bold: true })] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("1.0")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("2026-03-12")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("Auto-generated")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("初始版本")] })] })
                    ]})
                ]
            })
        ]
    }]
});

Packer.toBuffer(doc).then(buffer => {
    fs.writeFileSync("d:/code/openc910/.trae/documents/ct_pmp_regs_top.docx", buffer);
    console.log("Generated: ct_pmp_regs_top.docx");
});
