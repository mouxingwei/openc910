#!/usr/bin/env python3
"""
Verilog File Tree Generator
从 Verilog 源文件生成文件列表和模块例化树
输出格式：
1. 文件列表 - .f格式和JSON格式
2. 模块例化树 - Mermaid图、ASCII树、JSON格式
"""

import re
import os
import json
from typing import Dict, List, Set, Tuple, Optional
from dataclasses import dataclass, field
from collections import defaultdict, deque


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
    'timescale', 'resetall', 'celldefine', 'endcelldefine', 'protect',
    'endprotect', 'protected', 'endprotected', 'expand_vectornets',
    'noexpand_vectornets', 'autoexpand_vectornets', 'remove_gatename',
    'noremove_gatename', 'remove_netname', 'noremove_netname',
    'accelerate', 'noaccelerate', 'unconnected_drive', 'nounconnected_drive',
    'uselib', 'disable', 'fork', 'join', 'join_any', 'join_none',
    'wait', 'event', 'force', 'release', 'assign', 'deassign',
    'highz0', 'highz1', 'strong0', 'strong1', 'pull0', 'pull1', 'weak0', 'weak1',
    'small', 'medium', 'large'
}


@dataclass
class InstanceInfo:
    module_name: str
    instance_name: str
    line_number: int
    connections: Dict[str, str] = field(default_factory=dict)
    parameters: Dict[str, str] = field(default_factory=dict)


@dataclass
class ModuleInfo:
    name: str
    file_path: str
    line_number: int
    instances: List[InstanceInfo] = field(default_factory=list)
    ports: List[str] = field(default_factory=list)
    parameters: List[str] = field(default_factory=list)


@dataclass
class ModuleNode:
    module_name: str
    instance_name: str
    file_path: str
    children: List['ModuleNode'] = field(default_factory=list)
    level: int = 0


class FileTreeGenerator:
    def __init__(self):
        self.module_pattern = re.compile(
            r'module\s+(\w+)\s*(?:#\s*\((.*?)\))?\s*\((.*?)\)\s*;',
            re.DOTALL
        )
        self.endmodule_pattern = re.compile(r'endmodule')
        self.instantiation_pattern = re.compile(
            r'(\w+)\s*(?:#\s*\((.*?)\)\s*)?(\w+)\s*\((.*?)\)\s*;',
            re.DOTALL
        )
        self.port_connection_pattern = re.compile(
            r'\.(\w+)\s*\(\s*([^)]*)\s*\)'
        )
        self.parameter_pattern = re.compile(
            r'\.(\w+)\s*\(\s*([^)]*)\s*\)'
        )
        self.comment_pattern = re.compile(
            r'//.*?$|/\*.*?\*/',
            re.DOTALL | re.MULTILINE
        )
        
        self.modules: Dict[str, ModuleInfo] = {}
        self.file_to_module: Dict[str, str] = {}
        self.module_to_file: Dict[str, str] = {}
    
    def remove_comments(self, content: str) -> str:
        return self.comment_pattern.sub('', content)
    
    def load_file(self, file_path: str) -> Optional[str]:
        if not os.path.exists(file_path):
            return None
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            return f.read()
    
    def parse_module_definition(self, content: str, file_path: str) -> List[ModuleInfo]:
        modules = []
        clean_content = self.remove_comments(content)
        
        for match in self.module_pattern.finditer(clean_content):
            module_name = match.group(1)
            params_str = match.group(2) or ""
            ports_str = match.group(3) or ""
            line_number = clean_content[:match.start()].count('\n') + 1
            
            ports = []
            for port_match in re.finditer(r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[(\d+):(\d+)\]\s+)?(\w+)', ports_str):
                ports.append(port_match.group(4))
            
            parameters = []
            if params_str:
                for param_match in self.parameter_pattern.finditer(params_str):
                    parameters.append(param_match.group(1))
            
            module_info = ModuleInfo(
                name=module_name,
                file_path=file_path,
                line_number=line_number,
                ports=ports,
                parameters=parameters
            )
            modules.append(module_info)
        
        return modules
    
    def parse_instantiations(self, content: str) -> List[InstanceInfo]:
        instances = []
        clean_content = self.remove_comments(content)
        
        module_starts = set()
        for match in self.module_pattern.finditer(clean_content):
            module_starts.add(match.start())
        
        for match in self.instantiation_pattern.finditer(clean_content):
            potential_module = match.group(1)
            params_str = match.group(2) or ""
            instance_name = match.group(3)
            connections_str = match.group(4) or ""
            
            if potential_module.lower() in VERILOG_KEYWORDS:
                continue
            
            if potential_module in ('input', 'output', 'inout', 'wire', 'reg', 'logic', 'integer', 'real', 'time'):
                continue
            
            line_number = clean_content[:match.start()].count('\n') + 1
            
            connections = {}
            for conn_match in self.port_connection_pattern.finditer(connections_str):
                port_name = conn_match.group(1)
                signal_name = conn_match.group(2).strip()
                connections[port_name] = signal_name
            
            parameters = {}
            if params_str:
                for param_match in self.parameter_pattern.finditer(params_str):
                    param_name = param_match.group(1)
                    param_value = param_match.group(2).strip()
                    parameters[param_name] = param_value
            
            instance = InstanceInfo(
                module_name=potential_module,
                instance_name=instance_name,
                line_number=line_number,
                connections=connections,
                parameters=parameters
            )
            instances.append(instance)
        
        return instances
    
    def parse_verilog_file(self, file_path: str) -> List[ModuleInfo]:
        content = self.load_file(file_path)
        if not content:
            return []
        
        modules = self.parse_module_definition(content, file_path)
        
        for module in modules:
            clean_content = self.remove_comments(content)
            
            module_start = 0
            module_end = len(clean_content)
            
            for match in self.module_pattern.finditer(clean_content):
                if match.group(1) == module.name:
                    module_start = match.end()
                    break
            
            end_match = self.endmodule_pattern.search(clean_content, module_start)
            if end_match:
                module_end = end_match.start()
            
            module_body = clean_content[module_start:module_end]
            module.instances = self.parse_instantiations(module_body)
        
        return modules
    
    def scan_directory(self, directory: str, extensions: List[str] = None) -> List[str]:
        if extensions is None:
            extensions = ['.v', '.sv', '.vh']
        
        files = []
        for root, dirs, filenames in os.walk(directory):
            for filename in filenames:
                if any(filename.endswith(ext) for ext in extensions):
                    files.append(os.path.join(root, filename))
        
        return files
    
    def build_module_database(self, files: List[str]):
        for file_path in files:
            modules = self.parse_verilog_file(file_path)
            for module in modules:
                if module.name in self.modules:
                    print(f"警告: 模块 {module.name} 在多个文件中定义: {self.modules[module.name].file_path} 和 {file_path}")
                else:
                    self.modules[module.name] = module
                    self.module_to_file[module.name] = file_path
                    self.file_to_module[file_path] = module.name
    
    def build_dependency_graph(self) -> Dict[str, Set[str]]:
        dependencies = defaultdict(set)
        
        for module_name, module_info in self.modules.items():
            for instance in module_info.instances:
                if instance.module_name in self.modules:
                    dependencies[module_name].add(instance.module_name)
        
        return dependencies
    
    def detect_cycles(self, dependencies: Dict[str, Set[str]]) -> List[List[str]]:
        visited = set()
        rec_stack = set()
        cycles = []
        
        def dfs(node, path):
            visited.add(node)
            rec_stack.add(node)
            
            for neighbor in dependencies.get(node, []):
                if neighbor not in visited:
                    result = dfs(neighbor, path + [neighbor])
                    if result:
                        return result
                elif neighbor in rec_stack:
                    cycle_start = path.index(neighbor)
                    return path[cycle_start:] + [neighbor]
            
            rec_stack.remove(node)
            return None
        
        for node in dependencies:
            if node not in visited:
                cycle = dfs(node, [node])
                if cycle:
                    cycles.append(cycle)
        
        return cycles
    
    def calculate_compile_order(self, dependencies: Dict[str, Set[str]]) -> List[Tuple[str, int]]:
        in_degree = defaultdict(int)
        all_modules = set(self.modules.keys())
        
        for module in all_modules:
            if module not in in_degree:
                in_degree[module] = 0
        
        for module, deps in dependencies.items():
            for dep in deps:
                in_degree[module] += 1
        
        reverse_deps = defaultdict(set)
        for module, deps in dependencies.items():
            for dep in deps:
                reverse_deps[dep].add(module)
        
        queue = deque()
        for module in all_modules:
            if in_degree[module] == 0:
                queue.append((module, 0))
        
        result = []
        visited = set()
        
        while queue:
            module, level = queue.popleft()
            if module in visited:
                continue
            
            visited.add(module)
            result.append((module, level))
            
            for dependent in reverse_deps.get(module, []):
                in_degree[dependent] -= 1
                if in_degree[dependent] == 0:
                    queue.append((dependent, level + 1))
        
        for module in all_modules:
            if module not in visited:
                result.append((module, -1))
        
        return result
    
    def find_top_modules(self) -> List[str]:
        instantiated = set()
        for module_info in self.modules.values():
            for instance in module_info.instances:
                if instance.module_name in self.modules:
                    instantiated.add(instance.module_name)
        
        top_modules = [m for m in self.modules.keys() if m not in instantiated]
        return top_modules
    
    def build_instance_tree(self, top_module: str, visited: Set[str] = None, level: int = 0) -> Optional[ModuleNode]:
        if visited is None:
            visited = set()
        
        if top_module not in self.modules:
            return None
        
        if top_module in visited:
            return ModuleNode(
                module_name=top_module,
                instance_name="(循环引用)",
                file_path=self.module_to_file.get(top_module, ""),
                children=[],
                level=level
            )
        
        visited = visited | {top_module}
        module_info = self.modules[top_module]
        
        node = ModuleNode(
            module_name=top_module,
            instance_name=top_module,
            file_path=module_info.file_path,
            children=[],
            level=level
        )
        
        for instance in module_info.instances:
            if instance.module_name in self.modules:
                child = self.build_instance_tree(
                    instance.module_name,
                    visited,
                    level + 1
                )
                if child:
                    child.instance_name = instance.instance_name
                    node.children.append(child)
        
        return node
    
    def generate_filelist_text(self, compile_order: List[Tuple[str, int]]) -> str:
        lines = []
        lines.append(f"# Module dependency ordered file list")
        lines.append(f"# Total modules: {len(compile_order)}")
        lines.append("")
        
        current_level = -1
        for module, level in compile_order:
            if level != current_level:
                current_level = level
                if level >= 0:
                    lines.append(f"# Level {level}")
            
            file_path = self.module_to_file.get(module, f"{module}.v")
            lines.append(file_path)
        
        return '\n'.join(lines)
    
    def generate_filelist_json(self, compile_order: List[Tuple[str, int]], 
                                dependencies: Dict[str, Set[str]], top_module: str) -> str:
        data = {
            "top_module": top_module,
            "total_modules": len(compile_order),
            "compile_order": [
                {
                    "module": module,
                    "file": self.module_to_file.get(module, f"{module}.v"),
                    "level": level
                }
                for module, level in compile_order
            ],
            "dependencies": {
                module: list(deps) 
                for module, deps in dependencies.items()
            }
        }
        return json.dumps(data, ensure_ascii=False, indent=2)
    
    def generate_tree_mermaid(self, node: ModuleNode) -> str:
        lines = ["```mermaid", "graph TD"]
        
        def add_nodes(n: ModuleNode, parent_id: str = None, node_counter: List[int] = [0]):
            node_id = f"N{node_counter[0]}"
            node_counter[0] += 1
            
            label = f"{n.module_name}"
            if n.instance_name != n.module_name:
                label = f"{n.module_name}\\n({n.instance_name})"
            
            lines.append(f'    {node_id}["{label}"]')
            
            if parent_id is not None:
                lines.append(f"    {parent_id} --> {node_id}")
            
            for child in n.children:
                add_nodes(child, node_id, node_counter)
        
        add_nodes(node)
        lines.append("```")
        
        return '\n'.join(lines)
    
    def generate_tree_ascii(self, node: ModuleNode) -> str:
        lines = []
        
        def add_node(n: ModuleNode, prefix: str = "", is_last: bool = True):
            connector = "└── " if is_last else "├── "
            instance_info = f" ({n.instance_name})" if n.instance_name != n.module_name else ""
            lines.append(f"{prefix}{connector}{n.module_name}{instance_info}")
            
            new_prefix = prefix + ("    " if is_last else "│   ")
            for i, child in enumerate(n.children):
                add_node(child, new_prefix, i == len(n.children) - 1)
        
        lines.append(node.module_name)
        for i, child in enumerate(node.children):
            add_node(child, "", i == len(node.children) - 1)
        
        return '\n'.join(lines)
    
    def generate_tree_json(self, node: ModuleNode) -> str:
        def node_to_dict(n: ModuleNode) -> dict:
            return {
                "module": n.module_name,
                "instance_name": n.instance_name,
                "file": n.file_path,
                "level": n.level,
                "children": [node_to_dict(c) for c in n.children]
            }
        
        return json.dumps(node_to_dict(node), ensure_ascii=False, indent=2)
    
    def generate(self, input_path: str, top_module: str = None, 
                  output_dir: str = None) -> Dict:
        if os.path.isfile(input_path):
            files = [input_path]
        elif os.path.isdir(input_path):
            files = self.scan_directory(input_path)
        else:
            return {"error": f"输入路径不存在: {input_path}"}
        
        self.build_module_database(files)
        
        if not self.modules:
            return {"error": "未找到任何模块定义"}
        
        dependencies = self.build_dependency_graph()
        
        cycles = self.detect_cycles(dependencies)
        if cycles:
            print(f"警告: 检测到循环依赖: {cycles}")
        
        if top_module is None:
            top_modules = self.find_top_modules()
            if not top_modules:
                return {"error": "无法确定顶层模块，请手动指定"}
            if len(top_modules) > 1:
                print(f"发现多个顶层模块: {top_modules}，使用第一个: {top_modules[0]}")
            top_module = top_modules[0]
        elif top_module not in self.modules:
            return {"error": f"顶层模块未找到: {top_module}"}
        
        compile_order = self.calculate_compile_order(dependencies)
        instance_tree = self.build_instance_tree(top_module)
        
        result = {
            "top_module": top_module,
            "total_modules": len(self.modules),
            "modules": list(self.modules.keys()),
            "dependencies": {k: list(v) for k, v in dependencies.items()},
            "cycles": cycles
        }
        
        if output_dir:
            os.makedirs(output_dir, exist_ok=True)
            output_files = {}
            
            filelist_path = os.path.join(output_dir, f"{top_module}_filelist.f")
            filelist_content = self.generate_filelist_text(compile_order)
            with open(filelist_path, 'w', encoding='utf-8') as f:
                f.write(filelist_content)
            output_files['filelist'] = filelist_path
            
            filelist_json_path = os.path.join(output_dir, f"{top_module}_filelist.json")
            filelist_json = self.generate_filelist_json(compile_order, dependencies, top_module)
            with open(filelist_json_path, 'w', encoding='utf-8') as f:
                f.write(filelist_json)
            output_files['filelist_json'] = filelist_json_path
            
            if instance_tree:
                tree_md_path = os.path.join(output_dir, f"{top_module}_tree.md")
                tree_md = self.generate_tree_mermaid(instance_tree)
                with open(tree_md_path, 'w', encoding='utf-8') as f:
                    f.write(tree_md)
                output_files['tree_md'] = tree_md_path
                
                tree_txt_path = os.path.join(output_dir, f"{top_module}_tree.txt")
                tree_txt = self.generate_tree_ascii(instance_tree)
                with open(tree_txt_path, 'w', encoding='utf-8') as f:
                    f.write(tree_txt)
                output_files['tree_txt'] = tree_txt_path
                
                tree_json_path = os.path.join(output_dir, f"{top_module}_tree.json")
                tree_json = self.generate_tree_json(instance_tree)
                with open(tree_json_path, 'w', encoding='utf-8') as f:
                    f.write(tree_json)
                output_files['tree_json'] = tree_json_path
            
            result['output_files'] = output_files
        
        return result


def generate_file_tree(input_path: str, top_module: str = None,
                       output_dir: str = None) -> Dict:
    generator = FileTreeGenerator()
    return generator.generate(input_path, top_module, output_dir)


if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("用法: python file_tree_generator.py <verilog_file_or_dir> [options]")
        print("")
        print("参数:")
        print("  <verilog_file_or_dir>  Verilog文件或目录路径")
        print("")
        print("选项:")
        print("  --top-module <name>    指定顶层模块名")
        print("  --output-dir <dir>     输出目录")
        print("")
        print("输出文件:")
        print("  {module}_filelist.f    - 文件列表 (文本格式)")
        print("  {module}_filelist.json - 文件列表 (JSON格式)")
        print("  {module}_tree.md       - 例化树 (Mermaid格式)")
        print("  {module}_tree.txt      - 例化树 (ASCII格式)")
        print("  {module}_tree.json     - 例化树 (JSON格式)")
        sys.exit(1)
    
    input_path = sys.argv[1]
    top_module = None
    output_dir = None
    
    if '--top-module' in sys.argv:
        idx = sys.argv.index('--top-module')
        if idx + 1 < len(sys.argv):
            top_module = sys.argv[idx + 1]
    
    if '--output-dir' in sys.argv:
        idx = sys.argv.index('--output-dir')
        if idx + 1 < len(sys.argv):
            output_dir = sys.argv[idx + 1]
    
    result = generate_file_tree(input_path, top_module, output_dir)
    
    if "error" in result:
        print(f"错误: {result['error']}")
        sys.exit(1)
    
    print(f"顶层模块: {result['top_module']}")
    print(f"模块总数: {result['total_modules']}")
    
    if result.get('cycles'):
        print(f"警告: 检测到循环依赖: {result['cycles']}")
    
    if result.get('output_files'):
        print("\n生成完成:")
        for key, path in result['output_files'].items():
            print(f"  {key}: {path}")
