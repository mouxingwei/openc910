#!/usr/bin/env python3
"""
Batch Document Generator for OpenC910
批量生成模块设计文档
"""

import os
import re
import json
import subprocess
from typing import Dict, List, Optional
from dataclasses import dataclass
from collections import defaultdict

MODULES_LEVEL_1 = [
    {"name": "ct_core", "path": "cpu/rtl/ct_core.v", "desc": "处理器核心"},
    {"name": "ct_mmu_top", "path": "mmu/rtl/ct_mmu_top.v", "desc": "内存管理单元"},
    {"name": "ct_pmp_top", "path": "pmp/rtl/ct_pmp_top.v", "desc": "物理内存保护"},
    {"name": "ct_biu_top", "path": "biu/rtl/ct_biu_top.v", "desc": "总线接口单元"},
    {"name": "ct_had_private_top", "path": "had/rtl/ct_had_private_top.v", "desc": "硬件调试"},
    {"name": "ct_hpcp_top", "path": "pmu/rtl/ct_hpcp_top.v", "desc": "性能计数器"},
    {"name": "ct_rst_top", "path": "rst/rtl/ct_rst_top.v", "desc": "复位控制"},
    {"name": "ct_clk_top", "path": "clk/rtl/ct_clk_top.v", "desc": "时钟控制"},
]

MODULES_LEVEL_2 = [
    {"name": "ct_ifu_top", "path": "cpu/rtl/ct_ifu_top.v", "desc": "取指单元"},
    {"name": "ct_idu_top", "path": "cpu/rtl/ct_idu_top.v", "desc": "译码单元"},
    {"name": "ct_iu_top", "path": "cpu/rtl/ct_iu_top.v", "desc": "整数执行单元"},
    {"name": "ct_vfpu_top", "path": "cpu/rtl/ct_vfpu_top.v", "desc": "向量浮点单元"},
    {"name": "ct_lsu_top", "path": "cpu/rtl/ct_lsu_top.v", "desc": "访存单元"},
    {"name": "ct_cp0_top", "path": "cpu/rtl/ct_cp0_top.v", "desc": "协处理器 CP0"},
    {"name": "ct_rtu_top", "path": "cpu/rtl/ct_rtu_top.v", "desc": "退休单元"},
]

@dataclass
class Port:
    name: str
    direction: str
    width: int

class BatchDocGenerator:
    def __init__(self, base_path: str, output_dir: str):
        self.base_path = base_path
        self.output_dir = output_dir
        self.verilog_keywords = {
            'module', 'endmodule', 'input', 'output', 'inout', 'wire', 'reg',
            'always', 'assign', 'begin', 'end', 'if', 'else', 'case', 'endcase',
            'for', 'while', 'repeat', 'forever', 'initial', 'parameter', 'localparam',
            'generate', 'endgenerate', 'genvar', 'function', 'endfunction', 'task', 'endtask',
            'posedge', 'negedge', 'or', 'and', 'not', 'xor', 'nand', 'nor', 'xnor',
        }
        
    def load_file(self, file_path: str) -> Optional[str]:
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                return f.read()
        except:
            return None
    
    def parse_ports(self, content: str) -> List[Port]:
        ports = []
        module_match = re.search(r'module\s+\w+\s*\(', content)
        if not module_match:
            return ports
        
        module_start = module_match.end()
        endmodule_match = re.search(r'endmodule', content)
        module_body_end = endmodule_match.start() if endmodule_match else len(content)
        module_body = content[module_start:module_body_end]
        
        paren_count = 0
        port_list_end = 0
        for i, char in enumerate(module_body):
            if char == '(':
                paren_count += 1
            elif char == ')':
                paren_count -= 1
                if paren_count == 0:
                    port_list_end = i
                    break
        
        port_section = module_body[:port_list_end] if port_list_end > 0 else ""
        
        port_names = re.findall(r'(\w+)\s*(?:,|\))', port_section)
        
        port_decl_pattern = re.compile(
            r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[(\d+)\s*:\s*(\d+)\]\s+)?(\w+)\s*;'
        )
        
        declared_ports = {}
        for match in port_decl_pattern.finditer(module_body):
            direction = match.group(1)
            msb = int(match.group(2)) if match.group(2) else 0
            lsb = int(match.group(3)) if match.group(3) else 0
            name = match.group(4)
            width = msb - lsb + 1 if match.group(2) else 1
            declared_ports[name] = {'direction': direction, 'width': width}
        
        for name in port_names:
            name = name.strip()
            if name and name in declared_ports:
                port_info = declared_ports[name]
                ports.append(Port(name=name, direction=port_info['direction'], width=port_info['width']))
        
        return ports
    
    def parse_instances(self, content: str) -> List[Dict]:
        instances = []
        module_start = re.search(r'module\s+\w+\s*\(', content)
        if not module_start:
            return instances
        
        endmodule_match = re.search(r'endmodule', content)
        module_body_end = endmodule_match.start() if endmodule_match else len(content)
        module_body = content[module_start.end():module_body_end]
        
        inst_pattern = re.compile(
            r'(\w+)\s+(?:#\s*\([^)]*\)\s*)?(\w+)\s*\(',
            re.DOTALL
        )
        
        for match in inst_pattern.finditer(module_body):
            module_name = match.group(1)
            instance_name = match.group(2)
            
            if module_name.lower() in self.verilog_keywords:
                continue
            if module_name in ('input', 'output', 'inout', 'wire', 'reg', 'logic'):
                continue
            
            instances.append({
                'module': module_name,
                'instance': instance_name
            })
        
        return instances
    
    def generate_markdown(self, module_info: Dict, ports: List[Port], instances: List[Dict]) -> str:
        lines = []
        lines.append(f"# {module_info['name']} 模块设计文档")
        lines.append("")
        
        lines.append("## 1. 模块概述")
        lines.append("")
        lines.append("### 1.1 基本信息")
        lines.append("")
        lines.append("| 属性 | 值 |")
        lines.append("|------|-----|")
        lines.append(f"| 模块名称 | {module_info['name']} |")
        lines.append(f"| 文件路径 | {module_info['path']} |")
        lines.append(f"| 功能描述 | {module_info['desc']} |")
        lines.append("")
        
        lines.append("## 2. 模块接口说明")
        lines.append("")
        
        input_ports = [p for p in ports if p.direction == 'input']
        output_ports = [p for p in ports if p.direction == 'output']
        
        lines.append("### 2.1 输入端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in input_ports[:20]:
            lines.append(f"| {port.name} | input | {port.width} | |")
        if len(input_ports) > 20:
            lines.append(f"| ... | ... | ... | 共{len(input_ports)}个端口 |")
        lines.append("")
        
        lines.append("### 2.2 输出端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in output_ports[:20]:
            lines.append(f"| {port.name} | output | {port.width} | |")
        if len(output_ports) > 20:
            lines.append(f"| ... | ... | ... | 共{len(output_ports)}个端口 |")
        lines.append("")
        
        lines.append("## 3. 子模块列表")
        lines.append("")
        if instances:
            lines.append("| 模块名 | 实例名 |")
            lines.append("|--------|--------|")
            for inst in instances[:20]:
                lines.append(f"| {inst['module']} | {inst['instance']} |")
            if len(instances) > 20:
                lines.append(f"| ... | 共{len(instances)}个实例 |")
        else:
            lines.append("无子模块")
        lines.append("")
        
        lines.append("## 4. 修订历史")
        lines.append("")
        lines.append("| 版本 | 日期 | 作者 | 说明 |")
        lines.append("|------|------|------|------|")
        lines.append("| 1.0 | 2024-01-01 | T-Head | 初始版本 |")
        lines.append("")
        
        return '\n'.join(lines)
    
    def generate_docx_script(self, module_info: Dict, ports: List[Port], instances: List[Dict]) -> str:
        input_ports = [p for p in ports if p.direction == 'input'][:20]
        output_ports = [p for p in ports if p.direction == 'output'][:20]
        
        script = f'''const {{ Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber, LevelFormat }} = require('docx');
const fs = require('fs');

const border = {{ style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" }};
const borders = {{ top: border, bottom: border, left: border, right: border }};

const doc = new Document({{
    styles: {{
        default: {{ document: {{ run: {{ font: "Arial", size: 24 }} }} }},
        paragraphStyles: [
            {{ id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 32, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 240, after: 240 }}, outlineLevel: 0 }} }},
            {{ id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 28, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 180, after: 180 }}, outlineLevel: 1 }} }},
            {{ id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 26, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 120, after: 120 }}, outlineLevel: 2 }} }},
        ]
    }},
    sections: [{{
        properties: {{
            page: {{
                size: {{ width: 12240, height: 15840 }},
                margin: {{ top: 1440, right: 1440, bottom: 1440, left: 1440 }}
            }}
        }},
        headers: {{
            default: new Header({{ children: [new Paragraph({{
                alignment: AlignmentType.RIGHT,
                children: [new TextRun({{ text: "OpenC910 处理器设计文档", size: 20, color: "666666" }})]
            }})] }})
        }},
        footers: {{
            default: new Footer({{ children: [new Paragraph({{
                alignment: AlignmentType.CENTER,
                children: [new TextRun({{ text: "第 ", size: 20 }}), new TextRun({{ children: [PageNumber.CURRENT], size: 20 }}), new TextRun({{ text: " 页", size: 20 }})]
            }})] }})
        }},
        children: [
            new Paragraph({{ heading: HeadingLevel.HEADING_1, children: [new TextRun("{module_info['name']} 模块设计文档")] }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_2, children: [new TextRun("1. 模块概述")] }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_3, children: [new TextRun("1.1 基本信息")] }}),
            new Table({{
                width: {{ size: 9360, type: WidthType.DXA }},
                columnWidths: [3120, 6240],
                rows: [
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 3120, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "属性", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 6240, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "值", bold: true }})] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 3120, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("模块名称")] }})] }}),
                        new TableCell({{ borders, width: {{ size: 6240, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{module_info['name']}")] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 3120, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("文件路径")] }})] }}),
                        new TableCell({{ borders, width: {{ size: 6240, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{module_info['path']}")] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 3120, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("功能描述")] }})] }}),
                        new TableCell({{ borders, width: {{ size: 6240, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{module_info['desc']}")] }})] }})
                    ]}})
                ]
            }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_2, children: [new TextRun("2. 模块接口说明")] }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.1 输入端口")] }}),
            new Table({{
                width: {{ size: 9360, type: WidthType.DXA }},
                columnWidths: [4680, 1560, 1560, 1560],
                rows: [
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "信号名", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "方向", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "位宽", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "描述", bold: true }})] }})] }})
                    ]}}),
                    {self._generate_port_rows_js(input_ports)}
                ]
            }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.2 输出端口")] }}),
            new Table({{
                width: {{ size: 9360, type: WidthType.DXA }},
                columnWidths: [4680, 1560, 1560, 1560],
                rows: [
                    new TableRow({{ children: [
                        new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "信号名", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "方向", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "位宽", bold: true }})] }})] }}),
                        new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "描述", bold: true }})] }})] }})
                    ]}}),
                    {self._generate_port_rows_js(output_ports)}
                ]
            }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_2, children: [new TextRun("3. 子模块列表")] }}),
            {self._generate_instance_table_js(instances)}
        ]
    }}]
}});

Packer.toBuffer(doc).then(buffer => {{
    fs.writeFileSync("{self.output_dir}/{module_info['name']}_top.docx", buffer);
    console.log("Generated: {module_info['name']}_top.docx");
}});
'''
        return script
    
    def _generate_port_rows_js(self, ports: List[Port]) -> str:
        rows = []
        for port in ports:
            rows.append(f'new TableRow({{ children: [')
            rows.append(f'    new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{port.name}")] }})] }}),')
            rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{port.direction}")] }})] }}),')
            rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{port.width}")] }})] }}),')
            rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("")] }})] }})')
            rows.append(f'] }}),')
        return '\n                    '.join(rows)
    
    def _generate_instance_table_js(self, instances: List[Dict]) -> str:
        if not instances:
            return 'new Paragraph({ children: [new TextRun("无子模块")] })'
        
        rows = ['new Table({{',
                '    width: {{ size: 9360, type: WidthType.DXA }},',
                '    columnWidths: [4680, 4680],',
                '    rows: [',
                '        new TableRow({{ children: [',
                '            new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "模块名", bold: true }})] }})] }}),',
                '            new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "实例名", bold: true }})] }})] }})',
                '        ]}}),']
        
        for inst in instances[:20]:
            rows.append(f'        new TableRow({{ children: [')
            rows.append(f'            new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{inst['module']}")] }})] }}),')
            rows.append(f'            new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{inst['instance']}")] }})] }})')
            rows.append(f'        ]}}),')
        
        rows.append('    ]')
        rows.append('}})')
        
        return '\n            '.join(rows)
    
    def generate_docs(self, module_info: Dict) -> bool:
        file_path = os.path.join(self.base_path, module_info['path'])
        content = self.load_file(file_path)
        
        if not content:
            print(f"Failed to load: {file_path}")
            return False
        
        ports = self.parse_ports(content)
        instances = self.parse_instances(content)
        
        md_content = self.generate_markdown(module_info, ports, instances)
        md_path = os.path.join(self.output_dir, f"{module_info['name']}_top.md")
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        print(f"Generated: {md_path}")
        
        js_content = self.generate_docx_script(module_info, ports, instances)
        js_path = os.path.join(self.output_dir, f"gen_{module_info['name']}_docx.js")
        with open(js_path, 'w', encoding='utf-8') as f:
            f.write(js_content)
        
        try:
            result = subprocess.run(['node', js_path], capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                print(f"Generated: {module_info['name']}_top.docx")
            else:
                print(f"Error generating docx: {result.stderr}")
        except Exception as e:
            print(f"Error running node: {e}")
        
        return True
    
    def run(self):
        os.makedirs(self.output_dir, exist_ok=True)
        
        print("Generating Level 1 modules...")
        for module in MODULES_LEVEL_1:
            print(f"\nProcessing: {module['name']}")
            self.generate_docs(module)
        
        print("\nGenerating Level 2 modules...")
        for module in MODULES_LEVEL_2:
            print(f"\nProcessing: {module['name']}")
            self.generate_docs(module)
        
        print("\nDone!")

if __name__ == '__main__':
    base_path = r"d:\code\openc910\C910_RTL_FACTORY\gen_rtl"
    output_dir = r"d:\code\openc910\.trae\documents"
    
    generator = BatchDocGenerator(base_path, output_dir)
    generator.run()
