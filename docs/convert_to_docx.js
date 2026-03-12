const fs = require('fs');
const path = require('path');
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber, LevelFormat } = require('docx');

const docsDir = path.join(__dirname);

function parseMarkdown(content) {
    const lines = content.split('\n');
    const elements = [];
    let currentTable = null;
    let inCodeBlock = false;
    let codeContent = [];
    let codeLang = '';
    
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        if (line.startsWith('```')) {
            if (inCodeBlock) {
                if (codeContent.length > 0) {
                    elements.push({
                        type: 'code',
                        lang: codeLang,
                        content: codeContent.join('\n')
                    });
                }
                inCodeBlock = false;
                codeContent = [];
                codeLang = '';
            } else {
                inCodeBlock = true;
                codeLang = line.slice(3).trim();
            }
            continue;
        }
        
        if (inCodeBlock) {
            codeContent.push(line);
            continue;
        }
        
        if (line.startsWith('|') && line.includes('|')) {
            if (!currentTable) {
                currentTable = { headers: [], rows: [] };
            }
            const cells = line.split('|').filter(c => c.trim()).map(c => c.trim());
            if (line.match(/^\|[-:\s|]+\|$/)) {
                continue;
            }
            if (currentTable.headers.length === 0) {
                currentTable.headers = cells;
            } else {
                currentTable.rows.push(cells);
            }
            continue;
        }
        
        if (currentTable) {
            elements.push({ type: 'table', ...currentTable });
            currentTable = null;
        }
        
        if (line.startsWith('# ')) {
            elements.push({ type: 'h1', content: line.slice(2) });
        } else if (line.startsWith('## ')) {
            elements.push({ type: 'h2', content: line.slice(3) });
        } else if (line.startsWith('### ')) {
            elements.push({ type: 'h3', content: line.slice(4) });
        } else if (line.startsWith('#### ')) {
            elements.push({ type: 'h4', content: line.slice(5) });
        } else if (line.trim().startsWith('- ')) {
            elements.push({ type: 'bullet', content: line.trim().slice(2) });
        } else if (line.trim().match(/^\d+\.\s/)) {
            elements.push({ type: 'number', content: line.trim().replace(/^\d+\.\s/, '') });
        } else if (line.trim()) {
            elements.push({ type: 'paragraph', content: line });
        }
    }
    
    if (currentTable) {
        elements.push({ type: 'table', ...currentTable });
    }
    
    if (inCodeBlock && codeContent.length > 0) {
        elements.push({
            type: 'code',
            lang: codeLang,
            content: codeContent.join('\n')
        });
    }
    
    return elements;
}

function createDocxFromElements(elements, moduleName) {
    const border = { style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" };
    const borders = { top: border, bottom: border, left: border, right: border };
    
    const children = [];
    
    for (const elem of elements) {
        switch (elem.type) {
            case 'h1':
                children.push(new Paragraph({
                    heading: HeadingLevel.HEADING_1,
                    children: [new TextRun({ text: elem.content, bold: true, size: 32 })]
                }));
                break;
            case 'h2':
                children.push(new Paragraph({
                    heading: HeadingLevel.HEADING_2,
                    children: [new TextRun({ text: elem.content, bold: true, size: 28 })]
                }));
                break;
            case 'h3':
                children.push(new Paragraph({
                    heading: HeadingLevel.HEADING_3,
                    children: [new TextRun({ text: elem.content, bold: true, size: 24 })]
                }));
                break;
            case 'h4':
                children.push(new Paragraph({
                    heading: HeadingLevel.HEADING_4,
                    children: [new TextRun({ text: elem.content, bold: true, size: 22 })]
                }));
                break;
            case 'paragraph':
                children.push(new Paragraph({
                    children: [new TextRun({ text: elem.content, size: 22 })]
                }));
                break;
            case 'bullet':
                children.push(new Paragraph({
                    bullet: { level: 0 },
                    children: [new TextRun({ text: elem.content, size: 22 })]
                }));
                break;
            case 'number':
                children.push(new Paragraph({
                    numbering: { reference: 'numbers', level: 0 },
                    children: [new TextRun({ text: elem.content, size: 22 })]
                }));
                break;
            case 'code':
                const codeLines = elem.content.split('\n');
                for (const codeLine of codeLines) {
                    children.push(new Paragraph({
                        children: [new TextRun({ 
                            text: codeLine || ' ', 
                            font: 'Courier New', 
                            size: 18 
                        })]
                    }));
                }
                break;
            case 'table':
                if (elem.headers && elem.headers.length > 0) {
                    const colCount = elem.headers.length;
                    const colWidth = Math.floor(9360 / colCount);
                    const columnWidths = Array(colCount).fill(colWidth);
                    
                    const rows = [];
                    rows.push(new TableRow({
                        children: elem.headers.map(h => new TableCell({
                            borders,
                            width: { size: colWidth, type: WidthType.DXA },
                            shading: { fill: "D5E8F0", type: ShadingType.CLEAR },
                            children: [new Paragraph({
                                children: [new TextRun({ text: h, bold: true, size: 22 })]
                            })]
                        }))
                    }));
                    
                    for (const row of elem.rows) {
                        rows.push(new TableRow({
                            children: row.map(cell => new TableCell({
                                borders,
                                width: { size: colWidth, type: WidthType.DXA },
                                children: [new Paragraph({
                                    children: [new TextRun({ text: cell, size: 22 })]
                                })]
                            }))
                        }));
                    }
                    
                    children.push(new Table({
                        width: { size: 9360, type: WidthType.DXA },
                        columnWidths,
                        rows
                    }));
                    children.push(new Paragraph({ children: [] }));
                }
                break;
        }
    }
    
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
                  paragraph: { spacing: { before: 80, after: 80 }, outlineLevel: 3 } },
            ]
        },
        numbering: {
            config: [
                { reference: "bullets",
                  levels: [{ level: 0, format: LevelFormat.BULLET, text: "•", alignment: AlignmentType.LEFT,
                    style: { paragraph: { indent: { left: 720, hanging: 360 } } } }] },
                { reference: "numbers",
                  levels: [{ level: 0, format: LevelFormat.DECIMAL, text: "%1.", alignment: AlignmentType.LEFT,
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
                    children: [new TextRun({ text: `OpenC910 ${moduleName} 模块文档`, size: 18 })]
                })] })
            },
            footers: {
                default: new Footer({ children: [new Paragraph({
                    alignment: AlignmentType.CENTER,
                    children: [
                        new TextRun({ text: "第 ", size: 18 }),
                        new TextRun({ children: [PageNumber.CURRENT], size: 18 }),
                        new TextRun({ text: " 页", size: 18 })
                    ]
                })] })
            },
            children
        }]
    });
    
    return doc;
}

async function convertAllDocs() {
    const files = fs.readdirSync(docsDir).filter(f => f.endsWith('.md') && !f.includes('_block_diagram') && !f.includes('_pipeline'));
    
    for (const file of files) {
        const inputPath = path.join(docsDir, file);
        const outputPath = path.join(docsDir, file.replace('.md', '.docx'));
        
        if (fs.existsSync(outputPath)) {
            console.log(`跳过已存在: ${outputPath}`);
            continue;
        }
        
        try {
            const content = fs.readFileSync(inputPath, 'utf8');
            const elements = parseMarkdown(content);
            const moduleName = file.replace('.md', '').replace(/_/g, ' ');
            const doc = createDocxFromElements(elements, moduleName);
            
            const buffer = await Packer.toBuffer(doc);
            fs.writeFileSync(outputPath, buffer);
            console.log(`已生成: ${outputPath}`);
        } catch (err) {
            console.error(`转换失败 ${file}: ${err.message}`);
        }
    }
    
    console.log('\n转换完成!');
}

convertAllDocs().catch(console.error);
