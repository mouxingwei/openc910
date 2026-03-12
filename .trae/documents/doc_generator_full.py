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

MODULE_PREFIX_MAP = {
    'ct_ifu': '取指单元 (Instruction Fetch Unit)',
    'ct_idu': '译码单元 (Instruction Decode Unit)',
    'ct_iu': '整数执行单元 (Integer Execution Unit)',
    'ct_lsu': '访存单元 (Load/Store Unit)',
    'ct_mmu': '内存管理单元 (Memory Management Unit)',
    'ct_vfpu': '向量浮点单元 (Vector Floating Point Unit)',
    'ct_rtu': '退休单元 (Retirement Unit)',
    'ct_cp0': '协处理器0 (Coprocessor 0)',
    'ct_biu': '总线接口单元 (Bus Interface Unit)',
    'ct_had': '硬件调试 (Hardware Debug)',
    'ct_hpcp': '硬件性能计数器 (Hardware Performance Counter)',
    'ct_pmp': '物理内存保护 (Physical Memory Protection)',
    'ct_rst': '复位控制 (Reset Control)',
    'ct_clk': '时钟控制 (Clock Control)',
    'ct_core': '处理器核心 (Processor Core)',
    'ct_top': '顶层模块 (Top Module)',
}

MODULE_SUFFIX_MAP = {
    '_top': '顶层模块',
    '_ctrl': '控制逻辑',
    '_dp': '数据通路',
    '_dec': '译码逻辑',
    '_enc': '编码逻辑',
    '_arb': '仲裁器',
    '_buf': '缓冲器',
    '_fifo': '先进先出队列',
    '_reg': '寄存器文件',
    '_ram': '随机存取存储器',
    '_rom': '只读存储器',
    '_alu': '算术逻辑单元',
    '_mul': '乘法器',
    '_div': '除法器',
    '_addrgen': '地址生成',
    '_pcgen': 'PC生成',
    '_bht': '分支历史表',
    '_btb': '分支目标缓冲',
    '_ras': '返回地址栈',
    '_tlb': '地址转换缓冲',
    '_cache': '缓存',
    '_ag': '地址生成',
    '_wb': '写回',
    '_rob': '重排序缓冲',
    '_iq': '发射队列',
    '_lq': '加载队列',
    '_sq': '存储队列',
    '_rf': '寄存器文件',
    '_is': '发射级',
    '_id': '译码级',
    '_ir': '寄存器重命名',
    '_lfb': '填充缓冲',
    '_wmb': '写合并缓冲',
    '_rb': '读缓冲',
    '_vb': '有效位缓冲',
    '_pfu': '预取单元',
    '_sfp': '简单跳转预测',
    '_l0_btb': 'L0分支目标缓冲',
    '_ind_btb': '间接分支目标缓冲',
    '_precode': '预译码',
    '_decd': '译码',
    '_aiq': 'ALU发射队列',
    '_biq': '分支发射队列',
    '_lsiq': '访存发射队列',
    '_sdiq': '特殊发射队列',
    '_viq': '向量发射队列',
    '_pst': '物理寄存器状态表',
    '_retire': '退休',
    '_lpmd': '低功耗管理',
    '_iui': '接口',
    '_regs': '寄存器',
    '_csr': '控制状态寄存器',
    '_channel': '通道',
    '_read': '读',
    '_write': '写',
    '_snoop': '监听',
    '_req': '请求',
    '_lowpower': '低功耗',
    '_io_sync': 'IO同步',
    '_event': '事件',
    '_cnt': '计数器',
    '_adder': '加法器',
    '_trace': '跟踪',
    '_bkpt': '断点',
    '_dbg': '调试',
    '_ddc': '调试数据控制',
    '_pcfifo': 'PC先进先出',
    '_acc': '访问控制',
    '_sysmap': '系统映射',
    '_ptw': '页表遍历',
    '_dutlb': '数据微TLB',
    '_iutlb': '指令微TLB',
    '_jtlb': '联合TLB',
    '_tlboper': 'TLB操作',
    '_oper': '操作',
}

SIGNAL_KEYWORD_MAP = {
    'clk': '时钟信号',
    'clock': '时钟信号',
    'rst': '复位信号',
    'reset': '复位信号',
    'req': '请求信号',
    'request': '请求信号',
    'ack': '应答信号',
    'acknowledge': '应答信号',
    'valid': '有效信号',
    'vld': '有效信号',
    'ready': '就绪信号',
    'rdy': '就绪信号',
    'enable': '使能信号',
    'en': '使能信号',
    'addr': '地址信号',
    'address': '地址信号',
    'data': '数据信号',
    'dat': '数据信号',
    'cmd': '命令信号',
    'command': '命令信号',
    'status': '状态信号',
    'stat': '状态信号',
    'ctrl': '控制信号',
    'control': '控制信号',
    'cfg': '配置信号',
    'config': '配置信号',
    'interrupt': '中断信号',
    'irq': '中断信号',
    'exception': '异常信号',
    'excp': '异常信号',
    'wen': '写使能',
    'ren': '读使能',
    'we': '写使能',
    're': '读使能',
    'sel': '选择信号',
    'select': '选择信号',
    'mask': '掩码信号',
    'tag': '标签信号',
    'index': '索引信号',
    'offset': '偏移信号',
    'pc': '程序计数器',
    'inst': '指令信号',
    'instr': '指令信号',
    'imm': '立即数',
    'immidiate': '立即数',
    'result': '结果信号',
    'output': '输出信号',
    'input': '输入信号',
    'in': '输入信号',
    'out': '输出信号',
    'src': '源信号',
    'dst': '目标信号',
    'dest': '目标信号',
    'src1': '源操作数1',
    'src2': '源操作数2',
    'op': '操作码',
    'opcode': '操作码',
    'func': '功能码',
    'funct': '功能码',
    'pred': '预测信号',
    'predict': '预测信号',
    'hit': '命中信号',
    'miss': '未命中信号',
    'flush': '刷新信号',
    'stall': '暂停信号',
    'bubble': '气泡信号',
    'kill': '取消信号',
    'cancel': '取消信号',
    'fwd': '前递信号',
    'forward': '前递信号',
    'bypass': '旁路信号',
    'wakeup': '唤醒信号',
    'sleep': '休眠信号',
    'gate': '门控信号',
    'lock': '锁定信号',
    'grant': '授权信号',
    'gnt': '授权信号',
    'share': '共享信号',
    'exclusive': '独占信号',
    'dirty': '脏位信号',
    'clean': '清洁信号',
    'error': '错误信号',
    'err': '错误信号',
    'fail': '失败信号',
    'success': '成功信号',
    'done': '完成信号',
    'complete': '完成信号',
    'start': '开始信号',
    'begin': '开始信号',
    'end': '结束信号',
    'finish': '结束信号',
    'cnt': '计数器',
    'counter': '计数器',
    'ptr': '指针',
    'pointer': '指针',
    'head': '头指针',
    'tail': '尾指针',
    'empty': '空标志',
    'full': '满标志',
    'overflow': '溢出标志',
    'underflow': '下溢标志',
    'wrap': '回绕信号',
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

    def infer_module_description(self, module_name: str, ports: List[Port], 
                                  instances: List[Instance], comments: Dict) -> str:
        if comments.get('header'):
            header = comments['header']
            header = re.sub(r'\s+', ' ', header).strip()
            if len(header) > 20:
                return header[:500]
        
        base_desc = ""
        for prefix, desc in MODULE_PREFIX_MAP.items():
            if module_name.startswith(prefix):
                base_desc = desc
                break
        
        suffix_desc = ""
        for suffix, desc in MODULE_SUFFIX_MAP.items():
            if module_name.endswith(suffix):
                suffix_desc = desc
                break
        
        signal_hints = set()
        for port in ports[:20]:
            port_lower = port.name.lower()
            for keyword, hint in SIGNAL_KEYWORD_MAP.items():
                if keyword in port_lower:
                    signal_hints.add(hint)
                    break
        
        submodule_hints = set()
        for inst in instances[:10]:
            for prefix, desc in MODULE_PREFIX_MAP.items():
                if inst.module.startswith(prefix):
                    submodule_hints.add(desc.split('(')[0].strip())
                    break
        
        parts = []
        if base_desc:
            parts.append(base_desc)
        if suffix_desc and suffix_desc != '顶层模块':
            parts.append(f"({suffix_desc})")
        
        if signal_hints:
            signal_str = "、".join(list(signal_hints)[:5])
            parts.append(f"主要信号: {signal_str}")
        
        if submodule_hints and not base_desc:
            sub_str = "、".join(list(submodule_hints)[:3])
            parts.append(f"包含: {sub_str}")
        
        if parts:
            return "，".join(parts)
        return f"{module_name} 模块"

    def infer_port_description(self, port_name: str, port_direction: str, port_width: int) -> str:
        port_lower = port_name.lower()
        
        for keyword, desc in SIGNAL_KEYWORD_MAP.items():
            if keyword in port_lower:
                return desc
        
        patterns = [
            (r'.*_clk\b', '时钟信号'),
            (r'.*_rst\b', '复位信号'),
            (r'.*_en\b', '使能信号'),
            (r'.*_vld\b', '有效指示'),
            (r'.*_rdy\b', '就绪指示'),
            (r'.*_req\b', '请求信号'),
            (r'.*_ack\b', '应答信号'),
            (r'.*_addr\b', '地址信号'),
            (r'.*_data\b', '数据信号'),
            (r'.*_wen\b', '写使能'),
            (r'.*_ren\b', '读使能'),
            (r'.*_sel\b', '选择信号'),
            (r'.*_we\b', '写使能'),
            (r'.*_re\b', '读使能'),
            (r'^clk', '时钟信号'),
            (r'^rst', '复位信号'),
            (r'^en', '使能信号'),
        ]
        
        for pattern, desc in patterns:
            if re.search(pattern, port_lower):
                return desc
        
        return ""

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
        description = self.parser.infer_module_description(
            module.name, module.ports, module.instances, module.comments
        )
        lines.append(description)
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
            port_desc = self.parser.infer_port_description(port.name, port.direction, port.width)
            lines.append(f"| {port.name} | input | {port.width} | {port_desc} |")
        if len(input_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(input_ports)}个输入端口 |")
        lines.append("")
        
        lines.append("### 2.2 输出端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in output_ports[:30]:
            port_desc = self.parser.infer_port_description(port.name, port.direction, port.width)
            lines.append(f"| {port.name} | output | {port.width} | {port_desc} |")
        if len(output_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(output_ports)}个输出端口 |")
        lines.append("")
        
        if inout_ports:
            lines.append("### 2.3 双向端口")
            lines.append("")
            lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
            lines.append("|--------|------|------|------|")
            for port in inout_ports:
                port_desc = self.parser.infer_port_description(port.name, port.direction, port.width)
                lines.append(f"| {port.name} | inout | {port.width} | {port_desc} |")
            lines.append("")
        
        if module.parameters:
            lines.append("### 2.4 参数列表")
            lines.append("")
            lines.append("| 参数名 | 默认值 | 位宽 | 描述 |")
            lines.append("|--------|--------|------|------|")
            for param in module.parameters:
                lines.append(f"| {param.name} | {param.default_value} | {param.width} | |")
            lines.append("")
        
        lines.append("### 2.5 接口时序图")
        lines.append("")
        lines.append("```mermaid")
        lines.append("sequenceDiagram")
        lines.append("    participant M as 主机")
        lines.append("    participant S as 从机")
        lines.append("    M->>S: req")
        lines.append("    S->>M: ack")
        lines.append("    M->>S: data")
        lines.append("```")
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
                inst_desc = ""
                for prefix, desc in MODULE_PREFIX_MAP.items():
                    if inst.module.startswith(prefix):
                        inst_desc = desc.split('(')[0].strip()
                        break
                lines.append(f"| 1 | {inst.module} | {inst.name} | {inst_desc} |")
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
