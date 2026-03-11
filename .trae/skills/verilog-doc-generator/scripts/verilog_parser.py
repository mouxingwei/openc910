#!/usr/bin/env python3
"""
Verilog 模块解析脚本
使用 Hdlparse 和 Pyverilog 提取模块信息
输出 JSON 格式供文档生成器使用

使用方法:
    python verilog_parser.py <file.v> [--output output.json]

依赖安装:
    pip install pyverilog hdlparse
"""

import json
import sys
import re
import argparse
from pathlib import Path

# 尝试导入解析库
try:
    from hdlparse.verilog_parser import VerilogExtractor
    HDLPARSE_AVAILABLE = True
except ImportError:
    HDLPARSE_AVAILABLE = False
    print("Warning: hdlparse not available, using regex fallback", file=sys.stderr)

try:
    from pyverilog.vparser.parser import parse
    from pyverilog.vparser.ast import *
    PYVERILOG_AVAILABLE = True
except ImportError:
    PYVERILOG_AVAILABLE = False
    print("Warning: pyverilog not available", file=sys.stderr)


def parse_with_hdlparse(code):
    """使用 Hdlparse 提取基础信息"""
    if not HDLPARSE_AVAILABLE:
        return None
    
    vex = VerilogExtractor()
    try:
        modules = vex.extract_modules_from_source(code)
    except Exception as e:
        print(f"Hdlparse error: {e}", file=sys.stderr)
        return None
    
    if not modules:
        return None
    
    mod = modules[0]
    result = {
        'module_name': mod.name,
        'ports': [],
        'parameters': []
    }
    
    for port in mod.ports:
        width = 1
        if port.width:
            if isinstance(port.width, int):
                width = port.width
            elif hasattr(port.width, '__len__') and not isinstance(port.width, str):
                width = port.width
        
        result['ports'].append({
            'name': port.name,
            'direction': port.direction,
            'width': width,
            'description': ''
        })
    
    for param in mod.parameters:
        result['parameters'].append({
            'name': param.name,
            'default_value': param.default_value if param.default_value else '',
            'description': ''
        })
    
    return result


def parse_with_regex(code):
    """正则表达式回退解析"""
    result = {
        'module_name': '',
        'ports': [],
        'parameters': [],
        'instances': [],
        'signals': [],
        'always_blocks': [],
        'assigns': [],
        'comments': {'header': '', 'inline': {}}
    }
    
    # 提取模块名
    mod_match = re.search(r'module\s+(\w+)\s*[#\(]', code)
    if mod_match:
        result['module_name'] = mod_match.group(1)
    
    # 提取参数
    param_pattern = r'parameter\s+(?:\[\s*(\d+)\s*:\s*(\d+)\s*\]\s+)?(\w+)\s*=\s*([^,)]+)'
    for match in re.finditer(param_pattern, code):
        width = 1
        if match.group(1) and match.group(2):
            width = abs(int(match.group(1)) - int(match.group(2))) + 1
        result['parameters'].append({
            'name': match.group(3),
            'default_value': match.group(4).strip(),
            'width': width,
            'description': ''
        })
    
    # 提取端口 - 改进的正则表达式
    port_pattern = r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[([^\]]+)\]\s+)?(\w+)'
    for match in re.finditer(port_pattern, code):
        width = 1
        if match.group(2):
            width_str = match.group(2)
            if ':' in width_str:
                nums = re.findall(r'\d+', width_str)
                if len(nums) >= 2:
                    width = abs(int(nums[0]) - int(nums[1])) + 1
        
        result['ports'].append({
            'name': match.group(3),
            'direction': match.group(1),
            'width': width,
            'description': ''
        })
    
    # 提取模块实例化
    instance_pattern = r'(\w+)\s*(?:#\s*\([^)]*\))?\s*(\w+)\s*\(([^;]*)\);'
    for match in re.finditer(instance_pattern, code):
        module_type = match.group(1)
        instance_name = match.group(2)
        if module_type not in ['module', 'input', 'output', 'inout', 'wire', 'reg', 'parameter', 'localparam', 'assign', 'always', 'initial', 'generate', 'if', 'else', 'case', 'endcase', 'begin', 'end']:
            connections = {}
            port_matches = re.findall(r'\.(\w+)\s*\(([^)]*)\)', match.group(3))
            for pm in port_matches:
                connections[pm[0]] = pm[1].strip()
            result['instances'].append({
                'module': module_type,
                'name': instance_name,
                'connections': connections
            })
    
    # 提取 wire/reg 定义
    wire_pattern = r'wire\s+(?:\[([^\]]+)\]\s+)?(\w+(?:\s*,\s*\w+)*)'
    for match in re.finditer(wire_pattern, code):
        width = 1
        if match.group(1):
            width_str = match.group(1)
            if ':' in width_str:
                nums = re.findall(r'\d+', width_str)
                if len(nums) >= 2:
                    width = abs(int(nums[0]) - int(nums[1])) + 1
        for name in match.group(2).split(','):
            name = name.strip()
            if name:
                result['signals'].append({
                    'name': name,
                    'type': 'wire',
                    'width': width,
                    'description': ''
                })
    
    reg_pattern = r'reg\s+(?:\[([^\]]+)\]\s+)?(\w+(?:\s*,\s*\w+)*)'
    for match in re.finditer(reg_pattern, code):
        width = 1
        if match.group(1):
            width_str = match.group(1)
            if ':' in width_str:
                nums = re.findall(r'\d+', width_str)
                if len(nums) >= 2:
                    width = abs(int(nums[0]) - int(nums[1])) + 1
        for name in match.group(2).split(','):
            name = name.strip()
            if name:
                result['signals'].append({
                    'name': name,
                    'type': 'reg',
                    'width': width,
                    'description': ''
                })
    
    # 提取 always 块
    always_pattern = r'always\s*@\s*\(([^)]*)\)\s*begin([^e]*end)'
    for match in re.finditer(always_pattern, code, re.DOTALL):
        result['always_blocks'].append({
            'sensitivity': match.group(1).strip(),
            'body': match.group(2).strip()[:500]  # 截断过长的内容
        })
    
    # 提取 assign 语句
    assign_pattern = r'assign\s+(\w+)\s*=\s*([^;]+);'
    for match in re.finditer(assign_pattern, code):
        result['assigns'].append({
            'lhs': match.group(1),
            'rhs': match.group(2).strip()
        })
    
    # 提取注释
    result['comments'] = extract_comments(code)
    
    return result


def extract_comments(code):
    """提取注释信息"""
    comments = {
        'header': '',
        'inline': {}
    }
    
    # 提取文件头注释
    header_match = re.search(r'/\*\*(.*?)\*/', code, re.DOTALL)
    if header_match:
        header = header_match.group(1).strip()
        # 清理注释中的星号
        header = re.sub(r'^\s*\*\s?', '', header, flags=re.MULTILINE)
        comments['header'] = header
    
    # 提取行注释
    inline_pattern = r'//\s*(.+)$'
    for match in re.finditer(inline_pattern, code, re.MULTILINE):
        comment = match.group(1).strip()
        if comment and len(comment) > 3:
            # 尝试关联到附近的代码元素
            comments['inline'][comment] = ''
    
    return comments


def parse_with_pyverilog(file_path):
    """使用 Pyverilog 进行深度分析"""
    if not PYVERILOG_AVAILABLE:
        return None
    
    result = {
        'instances': [],
        'signals': [],
        'always_blocks': [],
        'assigns': []
    }
    
    try:
        ast, _ = parse([file_path])
        
        def visit_node(node, depth=0):
            if depth > 100:  # 防止无限递归
                return
            
            # 提取模块实例化
            if isinstance(node, Instance):
                connections = {}
                if hasattr(node, 'portlist') and node.portlist:
                    for item in node.portlist:
                        if isinstance(item, PortArg):
                            connections[item.argname] = str(item.argname)
                
                result['instances'].append({
                    'module': node.module,
                    'name': node.name,
                    'connections': connections
                })
            
            # 提取 always 块
            if isinstance(node, Always):
                sens_list = str(node.sens_list) if hasattr(node, 'sens_list') else ''
                result['always_blocks'].append({
                    'sensitivity': sens_list,
                    'body': ''
                })
            
            # 提取 assign 语句
            if isinstance(node, Assign):
                result['assigns'].append({
                    'lhs': str(node.left) if hasattr(node, 'left') else '',
                    'rhs': str(node.right) if hasattr(node, 'right') else ''
                })
            
            # 提取信号定义
            if isinstance(node, Decl):
                for item in node.list:
                    if isinstance(item, Wire):
                        width = 1
                        if hasattr(item, 'width') and item.width:
                            width = item.width
                        result['signals'].append({
                            'name': item.name,
                            'type': 'wire',
                            'width': width,
                            'description': ''
                        })
                    elif isinstance(item, Reg):
                        width = 1
                        if hasattr(item, 'width') and item.width:
                            width = item.width
                        result['signals'].append({
                            'name': item.name,
                            'type': 'reg',
                            'width': width,
                            'description': ''
                        })
            
            # 递归遍历子节点
            for child in node.children():
                visit_node(child, depth + 1)
        
        visit_node(ast)
        
    except Exception as e:
        print(f"Pyverilog parse error: {e}", file=sys.stderr)
        return None
    
    return result


def parse_verilog(file_path):
    """主解析函数"""
    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        code = f.read()
    
    result = {
        'module_name': '',
        'ports': [],
        'parameters': [],
        'instances': [],
        'signals': [],
        'always_blocks': [],
        'assigns': [],
        'comments': {'header': '', 'inline': {}}
    }
    
    # 优先使用 Hdlparse 提取基础信息
    hdlparse_result = parse_with_hdlparse(code)
    if hdlparse_result:
        result['module_name'] = hdlparse_result['module_name']
        result['ports'] = hdlparse_result['ports']
        result['parameters'] = hdlparse_result['parameters']
    
    # 使用 Pyverilog 进行深度分析
    pyverilog_result = parse_with_pyverilog(file_path)
    if pyverilog_result:
        if not result['instances']:
            result['instances'] = pyverilog_result['instances']
        if not result['signals']:
            result['signals'] = pyverilog_result['signals']
        if not result['always_blocks']:
            result['always_blocks'] = pyverilog_result['always_blocks']
        if not result['assigns']:
            result['assigns'] = pyverilog_result['assigns']
    
    # 如果 Hdlparse 和 Pyverilog 都失败，使用正则表达式
    if not result['module_name']:
        regex_result = parse_with_regex(code)
        result = regex_result
    else:
        # 补充正则表达式提取的内容
        regex_result = parse_with_regex(code)
        if not result['instances']:
            result['instances'] = regex_result.get('instances', [])
        if not result['signals']:
            result['signals'] = regex_result.get('signals', [])
        if not result['always_blocks']:
            result['always_blocks'] = regex_result.get('always_blocks', [])
        if not result['assigns']:
            result['assigns'] = regex_result.get('assigns', [])
        if not result['comments']['header']:
            result['comments'] = regex_result.get('comments', {'header': '', 'inline': {}})
    
    # 添加文件路径
    result['file_path'] = str(file_path)
    
    return result


def main():
    parser = argparse.ArgumentParser(description='Verilog 模块解析脚本')
    parser.add_argument('file', help='Verilog 文件路径')
    parser.add_argument('--output', '-o', help='输出 JSON 文件路径')
    parser.add_argument('--pretty', '-p', action='store_true', help='格式化输出')
    
    args = parser.parse_args()
    
    if not Path(args.file).exists():
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        sys.exit(1)
    
    result = parse_verilog(args.file)
    
    output_json = json.dumps(result, indent=2 if args.pretty else None, ensure_ascii=False)
    
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(output_json)
        print(f"Output written to: {args.output}")
    else:
        print(output_json)


if __name__ == '__main__':
    main()
