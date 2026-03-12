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
            new Paragraph({ heading: HeadingLevel.HEADING_1, children: [new TextRun("ct_had_ctrl 模块设计文档")] }),
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
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("ct_had_ctrl")] })] })
                    ]}),
                    new TableRow({ children: [
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("文件路径")] })] }),
                        new TableCell({ borders, children: [new Paragraph({ children: [new TextRun("had\rtl\ct_had_ctrl.v")] })] })
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("biu_had_sdb_req_b")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkpta_ctrl_data_req")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkpta_ctrl_data_req_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkpta_ctrl_inst_req")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkpta_ctrl_inst_req_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkpta_ctrl_xx_ack")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkptb_ctrl_data_req")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkptb_ctrl_data_req_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkptb_ctrl_inst_req")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkptb_ctrl_inst_req_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("bkptb_ctrl_xx_ack")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ddc_xx_update_ir")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("event_ctrl_enter_dbg")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("event_ctrl_exit_dbg")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("event_ctrl_had_clk_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("forever_coreclk")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ir_ctrl_exit_dbg_reg")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ir_ctrl_had_clk_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("input")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
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
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_bkpta_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_bkpta_en_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_bkptb_en")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_bkptb_en_raw")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_dbgfifo_ren")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_event_dbgenter")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_event_dbgexit")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_pcfifo_ren")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_pcfifo_wen")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_pipefifo_ren")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_pipefifo_wen")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_bkpta_vld")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_bkptb_vld")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_exit_dbg")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_freeze_pcfifo")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_set_sqa")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_set_sqb")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_update_adro")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_update_dro")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("")] })] })
                    ] }),
                    new TableRow({ children: [
                        new TableCell({ borders, width: { size: 4680, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("ctrl_regs_update_mbo")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("output")] })] }),
                        new TableCell({ borders, width: { size: 1560, type: WidthType.DXA }, children: [new Paragraph({ children: [new TextRun("1")] })] }),
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
    fs.writeFileSync("d:/code/openc910/.trae/documents/ct_had_ctrl_top.docx", buffer);
    console.log("Generated: ct_had_ctrl_top.docx");
});
