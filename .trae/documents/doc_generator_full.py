#!/usr/bin/env python3
"""
Verilog Module Document Generator
根据verilog-doc-generator SKILL规范生成完整的模块设计文档
支持Markdown和Word格式输出
"""

import os
import re
import json
import sys
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class Port:
    name: str
    direction: str
    width: int
    description: str = ""

@dataclass
class Parameter:
    name: str
    default_value: str
    width: int = 1
    description: str = ""

@dataclass
class Instance:
    module: str
    name: str
    connections: Dict[str, str] = field(default_factory=dict)

@dataclass
class Signal:
    name: str
    type: str
    width: int
    description: str = ""

@dataclass
class AlwaysBlock:
    sensitivity: str
    body: str

@dataclass
class Assign:
    lhs: str
    rhs: str

@dataclass
class ModuleInfo:
    name: str
    file_path: str
    ports: List[Port] = field(default_factory=list)
    parameters: List[Parameter] = field(default_factory=list)
    instances: List[Instance] = field(default_factory=list)
    signals: List[Signal] = field(default_factory=list)
    always_blocks: List[AlwaysBlock] = field(default_factory=list)
    assigns: List[Assign] = field(default_factory=list)
    comments: Dict = field(default_factory=dict)

VERILOG_KEYWORDS = {
    'module', 'endmodule', 'input', 'output', 'inout', 'wire', 'reg',
    'always', 'assign', 'begin', 'end', 'if', 'else', 'case', 'endcase',
    'casex', 'casez', 'for', 'while', 'repeat', 'forever', 'initial',
    'parameter', 'localparam', 'defparam', 'generate', 'endgenerate',
    'genvar', 'function', 'endfunction', 'task', 'endtask', 'specify',
    'endspecify', 'primitive', 'endprimitive', 'table', 'endtable',
    'posedge', 'negedge', 'or', 'and', 'not', 'xor', 'nand', 'nor', 'xnor',
    'buf', 'tran', 'rtran', 'pullup', 'pulldown', 'supply0', 'supply1',
    'tri', 'triand', 'trior', 'trireg', 'tri0', 'tri1', 'wand', 'wor',
    'real', 'realtime', 'time', 'integer', 'signed', 'unsigned',
    'default', 'define', 'ifdef', 'ifndef', 'else', 'endif', 'include',
    'timescale', 'resetall', 'celldefine', 'endcelldefine'
}

class VerilogParser:
    def __init__(self):
        self.comment_pattern = re.compile(r'//.*?$|/\*.*?\*/', re.DOTALL | re.MULTILINE)
        self.module_pattern = re.compile(r'module\s+(\w+)\s*(?:#\s*\((.*?)\))?\s*\((.*?)\)\s*;', re.DOTALL)
        self.endmodule_pattern = re.compile(r'endmodule')
        self.port_decl_pattern = re.compile(r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[([^\]]+)\]\s+)?(\w+)\s*;')
        self.param_pattern = re.compile(r'parameter\s+(?:\[([^\]]+)\]\s+)?(\w+)\s*=\s*([^,;]+)')
        self.inst_pattern = re.compile(r'(\w+)\s*(?:#\s*\((.*?)\)\s*)?(\w+)\s*\(([^;]*)\)\s*;', re.DOTALL)
        self.wire_pattern = re.compile(r'wire\s+(?:\[([^\]]+)\]\s+)?(\w+(?:\s*,\s*\w+)*)')
        self.reg_pattern = re.compile(r'reg\s+(?:\[([^\]]+)\]\s+)?(\w+(?:\s*,\s*\w+)*)')
        self.always_pattern = re.compile(r'always\s*@\s*\(([^)]*)\)\s*(begin\s*(.*?)\s*end|[^b][^e][^g][^i][^n].*?)', re.DOTALL)
        self.assign_pattern = re.compile(r'assign\s+(\w+)\s*=\s*([^;]+);')

    def remove_comments(self, content: str) -> str:
        return self.comment_pattern.sub('', content)

    def parse_width(self, width_str: str) -> int:
        if not width_str:
            return 1
        if ':' in width_str:
            nums = re.findall(r'\d+', width_str)
            if len(nums) >= 2:
                return abs(int(nums[0]) - int(nums[1])) + 1
        return 1

    def parse_file(self, file_path: str) -> Optional[ModuleInfo]:
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading file {file_path}: {e}")
            return None

        clean_content = self.remove_comments(content)
        
        module_match = self.module_pattern.search(clean_content)
        if not module_match:
            return None

        module_name = module_match.group(1)
        
        module_start = module_match.end()
        end_match = self.endmodule_pattern.search(clean_content, module_start)
        module_end = end_match.start() if end_match else len(clean_content)
        module_body = clean_content[module_start:module_end]

        ports = []
        port_names_in_list = []
        ports_str = module_match.group(3) or ""
        for name_match in re.finditer(r'(\w+)\s*(?:,|\)|$)', ports_str):
            port_names_in_list.append(name_match.group(1))

        for match in self.port_decl_pattern.finditer(module_body):
            direction = match.group(1)
            width_str = match.group(2)
            name = match.group(3)
            width = self.parse_width(width_str)
            ports.append(Port(name=name, direction=direction, width=width))

        ordered_ports = []
        for pname in port_names_in_list:
            for p in ports:
                if p.name == pname:
                    ordered_ports.append(p)
                    break
        ports = ordered_ports if ordered_ports else ports

        parameters = []
        params_str = module_match.group(2) or ""
        for match in self.param_pattern.finditer(params_str):
            width_str = match.group(1)
            name = match.group(2)
            value = match.group(3).strip()
            width = self.parse_width(width_str)
            parameters.append(Parameter(name=name, default_value=value, width=width))

        for match in self.param_pattern.finditer(module_body):
            name = match.group(2)
            if not any(p.name == name for p in parameters):
                value = match.group(3).strip()
                width_str = match.group(1)
                width = self.parse_width(width_str)
                parameters.append(Parameter(name=name, default_value=value, width=width))

        instances = []
        for match in self.inst_pattern.finditer(module_body):
            mod_type = match.group(1)
            inst_name = match.group(3)
            
            if mod_type.lower() in VERILOG_KEYWORDS:
                continue
            if mod_type in ('input', 'output', 'inout', 'wire', 'reg', 'logic'):
                continue
            
            connections = {}
            conn_str = match.group(4) or ""
            for conn_match in re.finditer(r'\.(\w+)\s*\(([^)]*)\)', conn_str):
                connections[conn_match.group(1)] = conn_match.group(2).strip()
            
            instances.append(Instance(module=mod_type, name=inst_name, connections=connections))

        signals = []
        for match in self.wire_pattern.finditer(module_body):
            width_str = match.group(1)
            width = self.parse_width(width_str)
            for name in match.group(2).split(','):
                name = name.strip()
                if name and not any(p.name == name for p in ports):
                    signals.append(Signal(name=name, type='wire', width=width))

        for match in self.reg_pattern.finditer(module_body):
            width_str = match.group(1)
            width = self.parse_width(width_str)
            for name in match.group(2).split(','):
                name = name.strip()
                if name and not any(p.name == name for p in ports):
                    signals.append(Signal(name=name, type='reg', width=width))

        always_blocks = []
        for match in self.always_pattern.finditer(module_body):
            sensitivity = match.group(1).strip()
            body = match.group(3) if match.group(3) else ""
            always_blocks.append(AlwaysBlock(sensitivity=sensitivity, body=body[:500]))

        assigns = []
        for match in self.assign_pattern.finditer(module_body):
            assigns.append(Assign(lhs=match.group(1), rhs=match.group(2).strip()))

        comments = {'header': '', 'inline': {}}
        header_match = re.search(r'/\*\*(.*?)\*/', content, re.DOTALL)
        if header_match:
            header = header_match.group(1).strip()
            header = re.sub(r'^\s*\*\s?', '', header, flags=re.MULTILINE)
            comments['header'] = header

        return ModuleInfo(
            name=module_name,
            file_path=file_path,
            ports=ports,
            parameters=parameters,
            instances=instances,
            signals=signals,
            always_blocks=always_blocks,
            assigns=assigns,
            comments=comments
        )

class DocGenerator:
    def __init__(self, output_dir: str, base_path: str = ""):
        self.output_dir = output_dir
        self.base_path = base_path
        self.parser = VerilogParser()
        os.makedirs(output_dir, exist_ok=True)

    def get_relative_path(self, file_path: str) -> str:
        if self.base_path and file_path.startswith(self.base_path):
            return file_path[len(self.base_path):].lstrip(os.sep)
        return os.path.basename(file_path)

    def generate_mermaid_block_diagram(self, module: ModuleInfo) -> str:
        lines = ["```mermaid", "graph TB"]
        
        input_ports = [p for p in module.ports if p.direction == 'input'][:10]
        output_ports = [p for p in module.ports if p.direction == 'output'][:10]
        
        lines.append(f'    subgraph inputs["输入端口"]')
        for i, p in enumerate(input_ports):
            lines.append(f'        IN{i}["{p.name}<br/>{p.width}bit"]')
        lines.append('    end')
        
        lines.append(f'    subgraph module["{module.name}"]')
        lines.append(f'        CORE["核心逻辑"]')
        lines.append('    end')
        
        lines.append(f'    subgraph outputs["输出端口"]')
        for i, p in enumerate(output_ports):
            lines.append(f'        OUT{i}["{p.name}<br/>{p.width}bit"]')
        lines.append('    end')
        
        for i in range(min(len(input_ports), 5)):
            lines.append(f'    IN{i} --> CORE')
        for i in range(min(len(output_ports), 5)):
            lines.append(f'    CORE --> OUT{i}')
        
        if module.instances:
            lines.append(f'    subgraph submodules["子模块"]')
            for i, inst in enumerate(module.instances[:8]):
                lines.append(f'        SUB{i}["{inst.module}<br/>({inst.name})"]')
            lines.append('    end')
            lines.append('    CORE --> submodules')
        
        lines.append("```")
        return '\n'.join(lines)

    def generate_mermaid_instance_tree(self, instances: List[Instance], max_depth: int = 3) -> str:
        lines = ["```mermaid", "graph TD"]
        
        def add_inst(inst_list: List[Instance], parent_id: str, depth: int, counter: List[int]):
            if depth > max_depth:
                return
            for inst in inst_list[:15]:
                node_id = f"N{counter[0]}"
                counter[0] += 1
                label = f"{inst.module}\\n({inst.name})"
                lines.append(f'    {node_id}["{label}"]')
                lines.append(f'    {parent_id} --> {node_id}')
        
        if instances:
            root_id = "ROOT"
            lines.append(f'    {root_id}["当前模块"]')
            add_inst(instances, root_id, 1, [0])
        
        lines.append("```")
        return '\n'.join(lines)

    def generate_markdown(self, module: ModuleInfo, level: int = 0, 
                         instance_tree: Dict = None, submodule_docs: List[str] = None) -> str:
        lines = []
        
        lines.append(f"# {module.name} 模块设计文档")
        lines.append("")
        
        lines.append("## 1. 模块概述")
        lines.append("")
        lines.append("### 1.1 基本信息")
        lines.append("")
        lines.append("| 属性 | 值 |")
        lines.append("|------|-----|")
        lines.append(f"| 模块名称 | {module.name} |")
        lines.append(f"| 文件路径 | {self.get_relative_path(module.file_path)} |")
        lines.append(f"| 层级 | Level {level} |")
        if module.parameters:
            params_str = ", ".join([f"{p.name}={p.default_value}" for p in module.parameters[:5]])
            if len(module.parameters) > 5:
                params_str += "..."
            lines.append(f"| 参数 | {params_str} |")
        lines.append("")
        
        lines.append("### 1.2 功能描述")
        lines.append("")
        if module.comments.get('header'):
            lines.append(module.comments['header'][:500])
        else:
            lines.append(f"{module.name} 模块的功能描述。")
        lines.append("")
        
        lines.append("### 1.3 设计特点")
        lines.append("")
        features = []
        if module.instances:
            features.append(f"- 包含 {len(module.instances)} 个子模块实例")
        if module.always_blocks:
            features.append(f"- 包含 {len(module.always_blocks)} 个 always 块")
        if module.assigns:
            features.append(f"- 包含 {len(module.assigns)} 个 assign 语句")
        if module.parameters:
            features.append(f"- 可配置参数: {len(module.parameters)} 个")
        if features:
            lines.extend(features)
        else:
            lines.append("- 基础模块")
        lines.append("")
        
        lines.append("## 2. 模块接口说明")
        lines.append("")
        
        input_ports = [p for p in module.ports if p.direction == 'input']
        output_ports = [p for p in module.ports if p.direction == 'output']
        inout_ports = [p for p in module.ports if p.direction == 'inout']
        
        lines.append("### 2.1 输入端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in input_ports[:30]:
            lines.append(f"| {port.name} | input | {port.width} | |")
        if len(input_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(input_ports)}个输入端口 |")
        lines.append("")
        
        lines.append("### 2.2 输出端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in output_ports[:30]:
            lines.append(f"| {port.name} | output | {port.width} | |")
        if len(output_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(output_ports)}个输出端口 |")
        lines.append("")
        
        if inout_ports:
            lines.append("### 2.3 双向端口")
            lines.append("")
            lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
            lines.append("|--------|------|------|------|")
            for port in inout_ports:
                lines.append(f"| {port.name} | inout | {port.width} | |")
            lines.append("")
        
        if module.parameters:
            lines.append("### 2.4 参数列表")
            lines.append("")
            lines.append("| 参数名 | 默认值 | 位宽 | 描述 |")
            lines.append("|--------|--------|------|------|")
            for param in module.parameters:
                lines.append(f"| {param.name} | {param.default_value} | {param.width} | |")
            lines.append("")
        
        lines.append("## 3. 模块框图")
        lines.append("")
        lines.append("### 3.1 模块架构图")
        lines.append("")
        lines.append(self.generate_mermaid_block_diagram(module))
        lines.append("")
        
        lines.append("### 3.2 主要数据连线")
        lines.append("")
        if module.instances:
            lines.append("| 源模块 | 目标模块 | 信号名 | 位宽 | 说明 |")
            lines.append("|--------|----------|--------|------|------|")
            for inst in module.instances[:10]:
                for port, signal in list(inst.connections.items())[:3]:
                    lines.append(f"| {module.name} | {inst.module} | {port} | - | |")
        else:
            lines.append("无子模块连接。")
        lines.append("")
        
        lines.append("## 4. 模块实现方案")
        lines.append("")
        
        lines.append("### 4.1 关键逻辑描述")
        lines.append("")
        if module.always_blocks:
            lines.append("**Always 块列表:**")
            lines.append("")
            for i, ab in enumerate(module.always_blocks[:5]):
                lines.append(f"```verilog")
                lines.append(f"always @({ab.sensitivity}) begin")
                lines.append(f"  // ...")
                lines.append(f"end")
                lines.append(f"```")
                lines.append("")
        else:
            lines.append("无关键 always 块。")
        lines.append("")
        
        if module.assigns:
            lines.append("**Assign 语句列表:**")
            lines.append("")
            lines.append("| 目标信号 | 源表达式 |")
            lines.append("|----------|----------|")
            for a in module.assigns[:15]:
                lines.append(f"| {a.lhs} | {a.rhs} |")
            if len(module.assigns) > 15:
                lines.append(f"| ... | 共{len(module.assigns)}条assign语句 |")
            lines.append("")
        
        lines.append("## 5. 内部关键信号列表")
        lines.append("")
        
        wire_signals = [s for s in module.signals if s.type == 'wire']
        reg_signals = [s for s in module.signals if s.type == 'reg']
        
        lines.append("### 5.1 寄存器信号")
        lines.append("")
        if reg_signals:
            lines.append("| 信号名 | 位宽 | 描述 |")
            lines.append("|--------|------|------|")
            for sig in reg_signals[:20]:
                lines.append(f"| {sig.name} | {sig.width} | |")
            if len(reg_signals) > 20:
                lines.append(f"| ... | ... | 共{len(reg_signals)}个寄存器信号 |")
        else:
            lines.append("无寄存器信号。")
        lines.append("")
        
        lines.append("### 5.2 线网信号")
        lines.append("")
        if wire_signals:
            lines.append("| 信号名 | 位宽 | 描述 |")
            lines.append("|--------|------|------|")
            for sig in wire_signals[:20]:
                lines.append(f"| {sig.name} | {sig.width} | |")
            if len(wire_signals) > 20:
                lines.append(f"| ... | ... | 共{len(wire_signals)}个线网信号 |")
        else:
            lines.append("无线网信号。")
        lines.append("")
        
        lines.append("## 6. 子模块方案")
        lines.append("")
        
        if module.instances:
            lines.append("### 6.1 模块例化层次结构")
            lines.append("")
            lines.append(self.generate_mermaid_instance_tree(module.instances))
            lines.append("")
            
            lines.append("### 6.2 子模块列表")
            lines.append("")
            lines.append("| 层级 | 模块名 | 实例名 | 功能描述 |")
            lines.append("|------|--------|--------|----------|")
            for inst in module.instances[:20]:
                lines.append(f"| 1 | {inst.module} | {inst.name} | |")
            if len(module.instances) > 20:
                lines.append(f"| ... | ... | ... | 共{len(module.instances)}个实例 |")
            lines.append("")
            
            if submodule_docs:
                lines.append("### 6.3 子模块文档链接")
                lines.append("")
                for doc_name in submodule_docs:
                    lines.append(f"- [{doc_name}](./{doc_name})")
                lines.append("")
        else:
            lines.append("无子模块。")
            lines.append("")
        
        lines.append("## 7. 修订历史")
        lines.append("")
        lines.append("| 版本 | 日期 | 作者 | 说明 |")
        lines.append("|------|------|------|------|")
        lines.append(f"| 1.0 | {datetime.now().strftime('%Y-%m-%d')} | Auto-generated | 初始版本 |")
        lines.append("")
        
        return '\n'.join(lines)

    def generate_docx_js(self, module: ModuleInfo, level: int = 0) -> str:
        input_ports = [p for p in module.ports if p.direction == 'input'][:20]
        output_ports = [p for p in module.ports if p.direction == 'output'][:20]
        
        def gen_port_rows(ports):
            rows = []
            for p in ports:
                rows.append(f'new TableRow({{ children: [')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 4680, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{p.name}")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{p.direction}")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{p.width}")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 1560, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("")] }})] }})')
                rows.append(f'] }}),')
            return '\n                    '.join(rows)
        
        def gen_inst_rows(instances):
            rows = []
            for inst in instances[:15]:
                rows.append(f'new TableRow({{ children: [')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 2340, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("1")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 2340, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{inst.module}")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 2340, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("{inst.name}")] }})] }}),')
                rows.append(f'    new TableCell({{ borders, width: {{ size: 2340, type: WidthType.DXA }}, children: [new Paragraph({{ children: [new TextRun("")] }})] }})')
                rows.append(f'] }}),')
            return '\n                    '.join(rows)
        
        js = f'''const {{ Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        HeadingLevel, AlignmentType, WidthType, BorderStyle, ShadingType,
        Header, Footer, PageNumber }} = require('docx');
const fs = require('fs');

const border = {{ style: BorderStyle.SINGLE, size: 1, color: "CCCCCC" }};
const borders = {{ top: border, bottom: border, left: border, right: border }};

const doc = new Document({{
    styles: {{
        default: {{ document: {{ run: {{ font: "Arial", size: 24 }} }} }},
        paragraphStyles: [
            {{ id: "Heading1", name: "Heading 1", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 32, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 240, after: 240 }} }} }},
            {{ id: "Heading2", name: "Heading 2", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 28, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 180, after: 180 }} }} }},
            {{ id: "Heading3", name: "Heading 3", basedOn: "Normal", next: "Normal", quickFormat: true,
                run: {{ size: 26, bold: true, font: "Arial" }},
                paragraph: {{ spacing: {{ before: 120, after: 120 }} }} }},
        ]
    }},
    sections: [{{
        properties: {{
            page: {{ size: {{ width: 12240, height: 15840 }}, margin: {{ top: 1440, right: 1440, bottom: 1440, left: 1440 }} }}
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
            new Paragraph({{ heading: HeadingLevel.HEADING_1, children: [new TextRun("{module.name} 模块设计文档")] }}),
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
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("模块名称")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("{module.name}")] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("文件路径")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("{self.get_relative_path(module.file_path)}")] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("层级")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("Level {level}")] }})] }})
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
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "信号名", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "方向", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "位宽", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "描述", bold: true }})] }})] }})
                    ]}}),
                    {gen_port_rows(input_ports)}
                ]
            }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_3, children: [new TextRun("2.2 输出端口")] }}),
            new Table({{
                width: {{ size: 9360, type: WidthType.DXA }},
                columnWidths: [4680, 1560, 1560, 1560],
                rows: [
                    new TableRow({{ children: [
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "信号名", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "方向", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "位宽", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "描述", bold: true }})] }})] }})
                    ]}}),
                    {gen_port_rows(output_ports)}
                ]
            }}),
            new Paragraph({{ heading: HeadingLevel.HEADING_2, children: [new TextRun("3. 子模块列表")] }}),
            {''.join([
                f'new Table({{ width: {{ size: 9360, type: WidthType.DXA }}, columnWidths: [2340, 2340, 2340, 2340], rows: [',
                f'    new TableRow({{ children: [',
                f'        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "层级", bold: true }})] }})] }}),',
                f'        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "模块名", bold: true }})] }})] }}),',
                f'        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "实例名", bold: true }})] }})] }}),',
                f'        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "功能描述", bold: true }})] }})] }})',
                f'    ]}}),',
                gen_inst_rows(module.instances) if module.instances else '',
                f']}}),'
            ]) if module.instances else 'new Paragraph({ children: [new TextRun("无子模块")] }),'}
            new Paragraph({{ heading: HeadingLevel.HEADING_2, children: [new TextRun("4. 修订历史")] }}),
            new Table({{
                width: {{ size: 9360, type: WidthType.DXA }},
                columnWidths: [2340, 2340, 2340, 2340],
                rows: [
                    new TableRow({{ children: [
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "版本", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "日期", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "作者", bold: true }})] }})] }}),
                        new TableCell({{ borders, shading: {{ fill: "E8F4FC", type: ShadingType.CLEAR }}, children: [new Paragraph({{ children: [new TextRun({{ text: "说明", bold: true }})] }})] }})
                    ]}}),
                    new TableRow({{ children: [
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("1.0")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("{datetime.now().strftime('%Y-%m-%d')}")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("Auto-generated")] }})] }}),
                        new TableCell({{ borders, children: [new Paragraph({{ children: [new TextRun("初始版本")] }})] }})
                    ]}})
                ]
            }})
        ]
    }}]
}});

Packer.toBuffer(doc).then(buffer => {{
    fs.writeFileSync("{self.output_dir.replace(chr(92), '/')}/{module.name}_top.docx", buffer);
    console.log("Generated: {module.name}_top.docx");
}});
'''
        return js

    def generate_docs(self, file_path: str, level: int = 0, submodule_docs: List[str] = None) -> Optional[str]:
        module = self.parser.parse_file(file_path)
        if not module:
            print(f"Failed to parse: {file_path}")
            return None
        
        md_content = self.generate_markdown(module, level, submodule_docs=submodule_docs)
        md_path = os.path.join(self.output_dir, f"{module.name}_top.md")
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        print(f"Generated MD: {md_path}")
        
        js_content = self.generate_docx_js(module, level)
        js_path = os.path.join(self.output_dir, f"gen_{module.name}_docx.js")
        with open(js_path, 'w', encoding='utf-8') as f:
            f.write(js_content)
        
        return module.name

def load_instance_tree(json_path: str) -> Dict:
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def extract_modules_by_level(tree: Dict, target_level: int, current_level: int = 0) -> List[Dict]:
    modules = []
    if current_level == target_level:
        modules.append({
            'name': tree['module'],
            'file': tree['file'],
            'instance': tree.get('instance_name', tree['module']),
            'level': current_level
        })
    
    if current_level < target_level and 'children' in tree:
        for child in tree['children']:
            modules.extend(extract_modules_by_level(child, target_level, current_level + 1))
    
    return modules

def main():
    base_path = r"d:\code\openc910\C910_RTL_FACTORY\gen_rtl"
    output_dir = r"d:\code\openc910\.trae\documents"
    tree_json_path = r"d:\code\openc910\.trae\documents\ct_top_tree.json"
    
    print("Loading instance tree...")
    tree = load_instance_tree(tree_json_path)
    
    generator = DocGenerator(output_dir, base_path)
    
    print("\n=== Generating Level 0 documents ===")
    level0_modules = extract_modules_by_level(tree, 0)
    for mod_info in level0_modules:
        print(f"\nProcessing: {mod_info['name']}")
        generator.generate_docs(mod_info['file'], level=0)
    
    print("\n=== Generating Level 1 documents ===")
    level1_modules = extract_modules_by_level(tree, 1)
    for mod_info in level1_modules:
        print(f"\nProcessing: {mod_info['name']}")
        generator.generate_docs(mod_info['file'], level=1)
    
    print("\n=== Generating Level 2 documents ===")
    level2_modules = extract_modules_by_level(tree, 2)
    for mod_info in level2_modules:
        print(f"\nProcessing: {mod_info['name']}")
        generator.generate_docs(mod_info['file'], level=2)
    
    print("\n=== Summary ===")
    print(f"Level 0: {len(level0_modules)} modules")
    print(f"Level 1: {len(level1_modules)} modules")
    print(f"Level 2: {len(level2_modules)} modules")
    print(f"Total: {len(level0_modules) + len(level1_modules) + len(level2_modules)} modules")
    print("\nDone!")

if __name__ == '__main__':
    main()
