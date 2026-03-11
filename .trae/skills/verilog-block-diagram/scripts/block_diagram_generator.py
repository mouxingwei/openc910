#!/usr/bin/env python3
"""
Verilog Block Diagram Generator
从 Verilog 源文件生成模块框图，支持 Mermaid 和 ASCII 格式
"""

import re
import os
from typing import Dict, List, Tuple, Optional, Set
from dataclasses import dataclass, field
from enum import Enum


class SignalPriority(Enum):
    HIGH = 1
    MEDIUM = 2
    LOW = 3


@dataclass
class Port:
    name: str
    direction: str
    msb: int
    lsb: int
    width: int
    description: str = ""


@dataclass
class Connection:
    source_instance: str
    source_port: str
    target_instance: str
    target_port: str
    signal_name: str
    width: int = 1


@dataclass
class ModuleNode:
    module_name: str
    instance_name: str
    level: int
    ports: List[Port] = field(default_factory=list)
    sub_instances: List['ModuleNode'] = field(default_factory=list)
    connections: List[Connection] = field(default_factory=list)
    port_connections: Dict[str, str] = field(default_factory=dict)
    file_path: str = ""


@dataclass
class HierarchyInfo:
    module_name: str
    instance_name: str
    parameters: Dict[str, str]
    port_connections: Dict[str, str]


class BlockDiagramGenerator:
    def __init__(self, max_depth: int = 3, max_sub_instances: int = 10):
        self.max_depth = max_depth
        self.max_sub_instances = max_sub_instances
        self.module_cache: Dict[str, str] = {}
        self.parsed_modules: Dict[str, ModuleNode] = {}
        
        self.verilog_keywords = {
            'begin', 'end', 'if', 'else', 'case', 'endcase', 'for', 'while',
            'repeat', 'forever', 'fork', 'join', 'generate', 'endgenerate',
            'always', 'always_ff', 'always_comb', 'assign', 'initial', 'final',
            'wire', 'reg', 'input', 'output', 'inout', 'parameter', 'localparam',
            'genvar', 'integer', 'real', 'time', 'realtime', 'tri', 'wand', 'wor',
            'triand', 'trior', 'tri0', 'tri1', 'supply0', 'supply1', 'trireg',
            'function', 'endfunction', 'task', 'endtask', 'specify', 'endspecify',
            'primitive', 'endprimitive', 'table', 'endtable', 'ifdef', 'ifndef',
            'else', 'elsif', 'endif', 'include', 'define', 'undef', 'default',
            'posedge', 'negedge', 'edge', 'or', 'and', 'nand', 'nor', 'xor', 'xnor',
            'buf', 'not', 'bufif0', 'bufif1', 'notif0', 'notif1', 'pullup', 'pulldown',
            'cmos', 'nmos', 'pmos', 'rcmos', 'rnmos', 'rpmos', 'rtran', 'rtranif0',
            'rtranif1', 'tran', 'tranif0', 'tranif1', 'wait', 'disable', 'deassign',
            'force', 'release', 'event', 'while', 'forever', 'repeat', 'wait',
            'disable', 'trigger', 'wait_order', 'randcase', 'randsequence', 'return',
            'break', 'continue', 'do', 'foreach', 'inside', 'with', 'type', 'void',
            'shortint', 'longint', 'byte', 'bit', 'logic', 'int', 'shortreal',
            'string', 'chandle', 'event', 'real', 'time', 'struct', 'packed',
            'union', 'enum', 'class', 'endclass', 'virtual', 'extends', 'this',
            'super', 'protected', 'local', 'static', 'automatic', 'const', 'rand',
            'randc', 'constraint', 'endconstraint', 'covergroup', 'endgroup',
            'coverpoint', 'cross', 'bins', 'illegal_bins', 'ignore_bins', 'option',
            'program', 'endprogram', 'interface', 'endinterface', 'clocking',
            'endclocking', 'modport', 'package', 'endpackage', 'import', 'export'
        }
        
        self.signal_keywords = {
            'high': ['clk', 'clock', 'rst', 'reset', 'rst_b', 'rst_n', 
                     'data', 'addr', 'wdata', 'rdata', 'din', 'dout',
                     'instruction', 'pc', 'imem', 'dmem'],
            'medium': ['valid', 'ready', 'enable', 'en', 'stall', 'flush',
                       'done', 'error', 'busy', 'status', 'ack', 'req'],
            'low': ['cfg', 'config', 'mode', 'sel', 'debug', 'test', 'scan']
        }
        
        self.patterns = {
            'module': re.compile(
                r'module\s+(\w+)\s*(?:#\s*\((.*?)\))?\s*\((.*?)\);',
                re.DOTALL
            ),
            'module_simple': re.compile(
                r'module\s+(\w+)\s*\((.*?)\);',
                re.DOTALL
            ),
            'module_header': re.compile(
                r'module\s+(\w+)\s*\(',
                re.DOTALL
            ),
            'endmodule': re.compile(r'endmodule'),
            'instance': re.compile(
                r'(\w+)\s+(?:#\s*\((.*?)\)\s+)?(\w+)\s*\((.*?)\)\s*;',
                re.DOTALL
            ),
            'port_def': re.compile(
                r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[(\d+):(\d+)\]\s+)?(\w+)'
            ),
            'port_conn': re.compile(r'\.(\w+)\s*\(\s*([^,)]+)\s*\)'),
        }
    
    def load_file(self, file_path: str) -> Optional[str]:
        if not os.path.exists(file_path):
            return None
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            return f.read()
    
    def find_verilog_files(self, directory: str) -> List[str]:
        verilog_files = []
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.endswith(('.v', '.sv', '.vh', '.svh')):
                    verilog_files.append(os.path.join(root, file))
        return verilog_files
    
    def build_module_cache(self, files: List[str]) -> None:
        for file_path in files:
            content = self.load_file(file_path)
            if content:
                module_match = self.patterns['module'].search(content)
                if module_match:
                    module_name = module_match.group(1)
                    self.module_cache[module_name] = file_path
    
    def get_signal_priority(self, signal_name: str) -> SignalPriority:
        signal_lower = signal_name.lower()
        for keyword in self.signal_keywords['high']:
            if keyword in signal_lower:
                return SignalPriority.HIGH
        for keyword in self.signal_keywords['medium']:
            if keyword in signal_lower:
                return SignalPriority.MEDIUM
        for keyword in self.signal_keywords['low']:
            if keyword in signal_lower:
                return SignalPriority.LOW
        return SignalPriority.MEDIUM
    
    def parse_module_ports(self, content: str) -> List[Port]:
        ports = []
        module_header_match = self.patterns['module_header'].search(content)
        if not module_header_match:
            return ports
        
        module_start = module_header_match.end()
        endmodule_match = self.patterns['endmodule'].search(content)
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
        
        for match in self.patterns['port_def'].finditer(port_section):
            direction = match.group(1)
            msb = int(match.group(2)) if match.group(2) else 0
            lsb = int(match.group(3)) if match.group(3) else 0
            name = match.group(4)
            width = msb - lsb + 1 if match.group(2) else 1
            
            ports.append(Port(
                name=name,
                direction=direction,
                msb=msb,
                lsb=lsb,
                width=width
            ))
        
        if ports:
            return ports
        
        port_names = re.findall(r'(\w+)\s*(?:,|\))', port_section)
        if port_names:
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
                declared_ports[name] = {
                    'direction': direction,
                    'msb': msb,
                    'lsb': lsb,
                    'width': width
                }
            
            for name in port_names:
                name = name.strip()
                if name and name in declared_ports:
                    port_info = declared_ports[name]
                    ports.append(Port(
                        name=name,
                        direction=port_info['direction'],
                        msb=port_info['msb'],
                        lsb=port_info['lsb'],
                        width=port_info['width']
                    ))
        
        return ports
    
    def parse_instances(self, content: str, current_level: int) -> List[HierarchyInfo]:
        instances = []
        if current_level >= self.max_depth:
            return instances
        
        module_match = self.patterns['module'].search(content)
        if not module_match:
            return instances
        
        module_end = self.patterns['endmodule'].search(content)
        module_body_start = module_match.end()
        module_body_end = module_end.start() if module_end else len(content)
        module_body = content[module_body_start:module_body_end]
        
        for match in self.patterns['instance'].finditer(module_body):
            module_name = match.group(1)
            param_str = match.group(2) or ""
            instance_name = match.group(3)
            conn_str = match.group(4) or ""
            
            if module_name.lower() in self.verilog_keywords:
                continue
            
            if not conn_str.strip() or '.' not in conn_str:
                continue
            
            parameters = {}
            if param_str:
                for param_match in self.patterns['port_conn'].finditer(param_str):
                    parameters[param_match.group(1)] = param_match.group(2).strip()
            
            port_connections = {}
            for conn_match in self.patterns['port_conn'].finditer(conn_str):
                port_connections[conn_match.group(1)] = conn_match.group(2).strip()
            
            if not port_connections:
                continue
            
            instances.append(HierarchyInfo(
                module_name=module_name,
                instance_name=instance_name,
                parameters=parameters,
                port_connections=port_connections
            ))
        
        return instances
    
    def parse_hierarchy(self, file_path: str, module_name: str = None) -> Optional[ModuleNode]:
        content = self.load_file(file_path)
        if not content:
            return None
        
        module_header_match = self.patterns['module_header'].search(content)
        if not module_header_match:
            return None
        
        actual_module_name = module_header_match.group(1)
        
        if module_name and actual_module_name != module_name:
            return None
        
        ports = self.parse_module_ports(content)
        
        root = ModuleNode(
            module_name=actual_module_name,
            instance_name=actual_module_name,
            level=0,
            ports=ports,
            file_path=file_path
        )
        
        instances = self.parse_instances(content, 0)
        
        for inst_info in instances:
            sub_module_file = self.module_cache.get(inst_info.module_name)
            sub_content = None
            if sub_module_file:
                sub_content = self.load_file(sub_module_file)
            
            sub_node = ModuleNode(
                module_name=inst_info.module_name,
                instance_name=inst_info.instance_name,
                level=1,
                port_connections=inst_info.port_connections,
                file_path=sub_module_file or ""
            )
            
            if sub_content and root.level < self.max_depth - 1:
                sub_instances = self.parse_instances(sub_content, 1)
                for sub_inst_info in sub_instances:
                    leaf_node = ModuleNode(
                        module_name=sub_inst_info.module_name,
                        instance_name=sub_inst_info.instance_name,
                        level=2,
                        port_connections=sub_inst_info.port_connections,
                        file_path=self.module_cache.get(sub_inst_info.module_name, "")
                    )
                    sub_node.sub_instances.append(leaf_node)
            
            root.sub_instances.append(sub_node)
        
        return root
    
    def extract_connections(self, root: ModuleNode) -> List[Connection]:
        connections = []
        
        for sub in root.sub_instances:
            for port_name, signal_name in sub.port_connections.items():
                is_input = False
                for port in sub.ports:
                    if port.name == port_name and port.direction == 'input':
                        is_input = True
                        break
                
                conn = Connection(
                    source_instance=root.instance_name if is_input else sub.instance_name,
                    source_port=port_name if not is_input else "",
                    target_instance=sub.instance_name if is_input else root.instance_name,
                    target_port=port_name if is_input else "",
                    signal_name=signal_name,
                    width=1
                )
                connections.append(conn)
        
        return connections
    
    def generate_mermaid(self, root: ModuleNode) -> str:
        lines = ["```mermaid", "graph TB"]
        
        def add_subgraph(node: ModuleNode, indent: str = "    "):
            node_id = self._sanitize_id(node.instance_name)
            node_label = node.module_name
            
            sub_count = len(node.sub_instances)
            if node.sub_instances and node.level < self.max_depth - 1:
                lines.append(f'{indent}subgraph {node_id}["{node_label}"]')
                shown_count = 0
                for sub in node.sub_instances:
                    if shown_count >= self.max_sub_instances:
                        lines.append(f'{indent}    more_{node_id}["... ({sub_count - shown_count} more)"]')
                        break
                    add_subgraph(sub, indent + "    ")
                    shown_count += 1
                lines.append(f'{indent}end')
            else:
                lines.append(f'{indent}{node_id}["{node_label}"]')
        
        if root.sub_instances:
            lines.append(f'    subgraph {self._sanitize_id(root.instance_name)}["{root.module_name}"]')
            shown_count = 0
            for sub in root.sub_instances:
                if shown_count >= self.max_sub_instances:
                    lines.append(f'        more_{self._sanitize_id(root.instance_name)}["... ({len(root.sub_instances) - shown_count} more)"]')
                    break
                add_subgraph(sub, "        ")
                shown_count += 1
            lines.append('    end')
        else:
            lines.append(f'    {self._sanitize_id(root.instance_name)}["{root.module_name}"]')
        
        connections = self._get_internal_connections(root)
        for conn in connections:
            source_id = self._sanitize_id(conn['source'])
            target_id = self._sanitize_id(conn['target'])
            label = conn['label']
            lines.append(f'    {source_id} -->|{label}| {target_id}')
        
        input_ports = [p for p in root.ports if p.direction == 'input']
        output_ports = [p for p in root.ports if p.direction == 'output']
        
        for port in input_ports[:5]:
            port_id = self._sanitize_id(f"input_{port.name}")
            lines.append(f'    {port_id}["{port.name}"]')
            lines.append(f'    {port_id} --> {self._sanitize_id(root.instance_name)}')
        
        for port in output_ports[:5]:
            port_id = self._sanitize_id(f"output_{port.name}")
            lines.append(f'    {port_id}["{port.name}"]')
            lines.append(f'    {self._sanitize_id(root.instance_name)} --> {port_id}')
        
        lines.append("```")
        return '\n'.join(lines)
    
    def _sanitize_id(self, name: str) -> str:
        return re.sub(r'[^a-zA-Z0-9_]', '_', name)
    
    def _get_internal_connections(self, root: ModuleNode) -> List[Dict]:
        connections = []
        
        if len(root.sub_instances) >= 2:
            for i in range(len(root.sub_instances) - 1):
                source = root.sub_instances[i]
                target = root.sub_instances[i + 1]
                connections.append({
                    'source': source.instance_name,
                    'target': target.instance_name,
                    'label': 'data'
                })
        
        return connections
    
    def generate_ascii(self, root: ModuleNode) -> str:
        lines = []
        
        box_width = 60
        lines.append('┌' + '─' * (box_width - 2) + '┐')
        lines.append('│' + self._center_text(root.module_name, box_width - 2) + '│')
        
        if root.sub_instances:
            sub_modules = root.sub_instances[:self.max_sub_instances]
            num_subs = len(sub_modules)
            total_subs = len(root.sub_instances)
            
            if total_subs > self.max_sub_instances:
                lines.append('│' + self._center_text(f'(显示 {num_subs}/{total_subs} 个子模块)', box_width - 2) + '│')
            
            max_display_subs = min(num_subs, 5)
            display_subs = sub_modules[:max_display_subs]
            
            sub_box_width = (box_width - 4 - (max_display_subs - 1) * 3) // max_display_subs
            sub_box_width = max(sub_box_width, 12)
            
            top_line = '│  ┌' + '┐  ┌'.join(['─' * (sub_box_width - 2)] * max_display_subs) + '┐  │'
            lines.append(top_line)
            
            name_line = '│  │'
            for sub in display_subs:
                name = sub.module_name[:sub_box_width - 4]
                name_line += self._center_text(name, sub_box_width - 2) + '│  │'
            lines.append(name_line[:-4] + '│  │')
            
            bottom_line = '│  └' + '┘  └'.join(['─' * (sub_box_width - 2)] * max_display_subs) + '┘  │'
            lines.append(bottom_line)
            
            if max_display_subs > 1:
                conn_line = '│  '
                for i in range(max_display_subs - 1):
                    conn_line += ' ' * (sub_box_width - 2) + '──►'
                conn_line += ' ' * (sub_box_width - 2) + '  │'
                lines.append(conn_line)
        
        input_ports = [p for p in root.ports if p.direction == 'input'][:3]
        output_ports = [p for p in root.ports if p.direction == 'output'][:3]
        
        if input_ports:
            input_text = ', '.join([p.name for p in input_ports])
            lines.append('│  ' + input_text + ' ' * (box_width - 4 - len(input_text)) + '│')
            lines.append('│  ▲' + ' ' * (box_width - 5) + '│')
        
        if output_ports:
            output_text = ', '.join([p.name for p in output_ports])
            lines.append('│' + ' ' * (box_width - 4 - len(output_text)) + output_text + '  │')
            lines.append('│' + ' ' * (box_width - 5) + '▼' + '  │')
        
        lines.append('└' + '─' * (box_width - 2) + '┘')
        
        return '\n'.join(lines)
    
    def _center_text(self, text: str, width: int) -> str:
        if len(text) >= width:
            return text[:width]
        padding = (width - len(text)) // 2
        return ' ' * padding + text + ' ' * (width - len(text) - padding)
    
    def generate_hierarchy_table(self, root: ModuleNode) -> str:
        lines = ["| 层级 | 模块名 | 实例名 | 说明 |", "|------|--------|--------|------|"]
        
        lines.append(f"| 0 | {root.module_name} | {root.instance_name} | 顶层模块 |")
        
        shown_count = 0
        for sub in root.sub_instances:
            if shown_count >= self.max_sub_instances:
                lines.append(f"| 1 | ... | ... | 还有 {len(root.sub_instances) - shown_count} 个子模块 |")
                break
            lines.append(f"| 1 | {sub.module_name} | {sub.instance_name} | 子模块 |")
            leaf_count = 0
            for leaf in sub.sub_instances:
                if leaf_count >= 5:
                    lines.append(f"| 2 | ... | ... | 还有 {len(sub.sub_instances) - leaf_count} 个孙模块 |")
                    break
                lines.append(f"| 2 | {leaf.module_name} | {leaf.instance_name} | 孙模块 |")
                leaf_count += 1
            shown_count += 1
        
        return '\n'.join(lines)
    
    def generate_connection_table(self, root: ModuleNode) -> str:
        lines = ["| 源模块 | 信号名 | 位宽 | 目标模块 |", "|--------|--------|------|----------|"]
        
        for sub in root.sub_instances:
            for port_name, signal_name in sub.port_connections.items():
                priority = self.get_signal_priority(signal_name)
                if priority != SignalPriority.LOW:
                    lines.append(f"| {root.module_name} | {signal_name} | - | {sub.instance_name} |")
                    break
        
        return '\n'.join(lines)
    
    def generate_markdown_doc(self, root: ModuleNode) -> str:
        sections = [
            f"# {root.module_name} 模块框图",
            "",
            "## 1. 模块层次结构",
            "",
            self.generate_hierarchy_table(root),
            "",
            "## 2. 模块框图 (Mermaid)",
            "",
            self.generate_mermaid(root),
            "",
            "## 3. 主要数据连线",
            "",
            self.generate_connection_table(root),
            "",
            "## 4. ASCII 框图 (Word兼容)",
            "",
            "```",
            self.generate_ascii(root),
            "```",
        ]
        
        return '\n'.join(sections)


def generate_block_diagram(file_path: str, module_name: str = None, 
                          search_dirs: List[str] = None) -> Tuple[str, str, str]:
    generator = BlockDiagramGenerator(max_depth=3)
    
    if search_dirs:
        all_files = []
        for d in search_dirs:
            all_files.extend(generator.find_verilog_files(d))
        generator.build_module_cache(all_files)
    
    root = generator.parse_hierarchy(file_path, module_name)
    if not root:
        return "", "", ""
    
    md_content = generator.generate_markdown_doc(root)
    mermaid_content = generator.generate_mermaid(root)
    ascii_content = generator.generate_ascii(root)
    
    return md_content, mermaid_content, ascii_content


if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("用法: python block_diagram_generator.py <verilog_file> [--output-dir <dir>]")
        sys.exit(1)
    
    file_path = sys.argv[1]
    module_name = None
    output_dir = None
    
    i = 2
    while i < len(sys.argv):
        if sys.argv[i] == '--output-dir' and i + 1 < len(sys.argv):
            output_dir = sys.argv[i + 1]
            i += 2
        else:
            if module_name is None:
                module_name = sys.argv[i]
            i += 1
    
    search_dirs = [os.path.dirname(file_path)]
    
    generator = BlockDiagramGenerator(max_depth=3)
    
    all_files = generator.find_verilog_files(os.path.dirname(file_path))
    generator.build_module_cache(all_files)
    
    root = generator.parse_hierarchy(file_path, module_name)
    
    if not root:
        print("无法解析模块")
        sys.exit(1)
    
    md_content = generator.generate_markdown_doc(root)
    mermaid_content = generator.generate_mermaid(root)
    ascii_content = generator.generate_ascii(root)
    
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)
        
        module_name_actual = root.module_name
        
        md_path = os.path.join(output_dir, f"{module_name_actual}_block_diagram.md")
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        mmd_path = os.path.join(output_dir, f"{module_name_actual}_block_diagram.mmd")
        with open(mmd_path, 'w', encoding='utf-8') as f:
            f.write(mermaid_content)
        
        print(f"生成完成:")
        print(f"  md: {md_path}")
        print(f"  mmd: {mmd_path}")
    else:
        print(md_content)
