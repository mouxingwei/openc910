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
            new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("ct_cp0_top 模块设计文档")] }),
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
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("ct_cp0_top")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("文件路径")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("cp0\rtl\ct_cp0_top.v")] })] })
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_apb_base")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("40")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_cmplt")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_coreid")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("3")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_me_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_ms_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_mt_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_rdata")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("128")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_rvba")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("40")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_se_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_ss_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_cp0_st_int")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_yy_xx_no_op")] })] }),
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("forever_cpuclk")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("had_cp0_xx_dbg")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("hpcp_cp0_cmplt")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("hpcp_cp0_data")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("hpcp_cp0_int_vld")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("hpcp_cp0_sce")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("idu_cp0_fesr_acc_updt_val")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("7")] })] }),
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_biu_icg_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_biu_lpmd_b")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_biu_op")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("16")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_biu_sel")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_biu_wdata")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_had_cpuid_0")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("32")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_had_debug_info")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("4")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_had_lpmd_b")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_had_trace_pm_wdata")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("2")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_had_trace_pm_wen")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_icg_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_index")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("12")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_int_disable")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_mcntwen")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("32")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_op")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("4")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_pmdm")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_pmds")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_pmdu")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_sel")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("cp0_hpcp_src0")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("64")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                ]
            }),
            new Paragraph({ heading: HeadingLevel.HEADING_2, children: [new TextRun("3. 子模块列表")] }),
            new Table({ width: { size: 9360, type: WidthType.DXA }, columnWidths: [2340, 2340, 2340, 2340], rows: [    new TableRow({ children: [        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "层级", bold: true })] })] }),        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "模块名", bold: true })] })] }),        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "实例名", bold: true })] })] }),        new TableCell({ borders, shading: { fill: "E8F4FC", type: ShadingType.CLEAR }, children: [new Paragraph({ children: [new TextRun({ text: "功能描述", bold: true })] })] })    ]}),new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_cp0_iui")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_cp0_iui")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_cp0_regs")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_cp0_regs")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ct_cp0_lpmd")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("x_ct_cp0_lpmd")] })] }),
                        new TableCell({ borders, width: { size: 2340, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),]}),
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
    fs.writeFileSync("d:/code/openc910/.trae/documents/ct_cp0_top_top.docx", buffer);
    console.log("Generated: ct_cp0_top_top.docx");
});
