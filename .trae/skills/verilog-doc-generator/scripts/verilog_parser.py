#!/usr/bin/env python3
"""
Verilog Parser Module
Parses Verilog source files and extracts module information.
"""

import re
import os
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass, field


@dataclass
class Port:
    name: str
    direction: str
    msb: int
    lsb: int
    width: int
    description: str = ""


@dataclass
class Parameter:
    name: str
    default_value: str
    msb: int = -1
    lsb: int = -1
    width: int = 1
    description: str = ""


@dataclass
class Signal:
    name: str
    signal_type: str
    msb: int
    lsb: int
    width: int
    description: str = ""


@dataclass
class Instance:
    module_name: str
    instance_name: str
    connections: Dict[str, str]
    parameters: Dict[str, str] = field(default_factory=dict)


@dataclass
class AlwaysBlock:
    sensitivity: str
    body: str
    block_type: str
    description: str = ""


@dataclass
class StateMachine:
    state_reg: str
    states: List[str]
    transitions: Dict[Tuple[str, str], str]
    state_width: int


@dataclass
class Pipeline:
    stages: List[str]
    stage_signals: Dict[str, List[str]]
    control_signals: Dict[str, str]


@dataclass
class Module:
    name: str
    file_path: str
    ports: List[Port]
    parameters: List[Parameter]
    signals: List[Signal]
    instances: List[Instance]
    always_blocks: List[AlwaysBlock]
    assigns: List[Tuple[str, str]]
    comments: Dict[str, str]
    state_machines: List[StateMachine]
    pipelines: List[Pipeline]
    header_comment: str = ""


class VerilogParser:
    def __init__(self):
        self.patterns = {
            'module': re.compile(
                r'module\s+(\w+)\s*(?:#\s*\((.*?)\))?\s*\((.*?)\);',
                re.DOTALL
            ),
            'endmodule': re.compile(r'endmodule'),
            'port': re.compile(
                r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[(\d+):(\d+)\]\s+)?(\w+)'
            ),
            'parameter': re.compile(
                r'parameter\s+(?:\[(\d+):(\d+)\]\s+)?(\w+)\s*=\s*([^;,]+)'
            ),
            'localparam': re.compile(
                r'localparam\s+(?:\[(\d+):(\d+)\]\s+)?(\w+)\s*=\s*([^;,]+)'
            ),
            'wire': re.compile(
                r'wire\s+(?:\[(\d+):(\d+)\]\s+)?(\w+(?:\s*,\s*\w+)*)\s*;'
            ),
            'reg': re.compile(
                r'reg\s+(?:\[(\d+):(\d+)\]\s+)?(\w+(?:\s*,\s*\w+)*)\s*;'
            ),
            'instance': re.compile(
                r'(\w+)\s+(?:#\s*\((.*?)\)\s+)?(\w+)\s*\((.*?)\)\s*;',
                re.DOTALL
            ),
            'always': re.compile(
                r'always\s*@\s*\((.*?)\)\s*begin(.*?)end',
                re.DOTALL
            ),
            'always_ff': re.compile(
                r'always_ff\s*@\s*\((.*?)\)\s*begin(.*?)end',
                re.DOTALL
            ),
            'always_comb': re.compile(
                r'always_comb\s*begin(.*?)end',
                re.DOTALL
            ),
            'assign': re.compile(
                r'assign\s+(\w+)\s*=\s*(.+?)\s*;'
            ),
            'comment_line': re.compile(r'//(.*)$'),
            'comment_block': re.compile(r'/\*(.*?)\*/', re.DOTALL),
            'state_reg': re.compile(
                r'reg\s+(?:\[(\d+):(\d+)\]\s+)?(\w*(?:state|st|cs|ns)\w*)',
                re.IGNORECASE
            ),
            'case': re.compile(
                r'case\s*\((\w+)\)(.*?)endcase',
                re.DOTALL
            ),
            'if_else': re.compile(
                r'if\s*\((.*?)\)\s*(?:begin\s*(.*?)\s*end)?(?:\s*else\s*(?:if\s*\(.*?\)\s*(?:begin\s*.*?\s*end)?)*)*(?:\s*else\s*(?:begin\s*(.*?)\s*end)?)?',
                re.DOTALL
            ),
        }
    
    def parse_file(self, file_path: str) -> Optional[Module]:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        return self.parse_content(content, file_path)
    
    def parse_content(self, content: str, file_path: str = "") -> Optional[Module]:
        module_match = self.patterns['module'].search(content)
        if not module_match:
            return None
        
        module_name = module_match.group(1)
        param_section = module_match.group(2) or ""
        port_section = module_match.group(3) or ""
        
        module_end = self.patterns['endmodule'].search(content)
        module_body_start = module_match.end()
        module_body_end = module_end.start() if module_end else len(content)
        module_body = content[module_body_start:module_body_end]
        
        header_comment = self._extract_header_comment(content[:module_match.start()])
        
        ports = self._parse_ports(port_section)
        parameters = self._parse_parameters(param_section)
        localparams = self._parse_localparams(module_body)
        parameters.extend(localparams)
        
        signals = self._parse_signals(module_body)
        instances = self._parse_instances(module_body)
        always_blocks = self._parse_always_blocks(module_body)
        assigns = self._parse_assigns(module_body)
        comments = self._extract_comments(module_body)
        
        state_machines = self._detect_state_machines(module_body, always_blocks)
        pipelines = self._detect_pipelines(module_body, signals)
        
        return Module(
            name=module_name,
            file_path=file_path,
            ports=ports,
            parameters=parameters,
            signals=signals,
            instances=instances,
            always_blocks=always_blocks,
            assigns=assigns,
            comments=comments,
            state_machines=state_machines,
            pipelines=pipelines,
            header_comment=header_comment
        )
    
    def _extract_header_comment(self, content: str) -> str:
        comments = []
        for match in self.patterns['comment_block'].finditer(content):
            comments.append(match.group(1).strip())
        for match in self.patterns['comment_line'].finditer(content):
            comments.append(match.group(1).strip())
        return '\n'.join(comments) if comments else ""
    
    def _parse_ports(self, port_section: str) -> List[Port]:
        ports = []
        for match in self.patterns['port'].finditer(port_section):
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
        return ports
    
    def _parse_parameters(self, param_section: str) -> List[Parameter]:
        parameters = []
        for match in self.patterns['parameter'].finditer(param_section):
            msb = int(match.group(1)) if match.group(1) else -1
            lsb = int(match.group(2)) if match.group(2) else -1
            name = match.group(3)
            value = match.group(4).strip()
            width = msb - lsb + 1 if msb >= 0 else 1
            
            parameters.append(Parameter(
                name=name,
                default_value=value,
                msb=msb,
                lsb=lsb,
                width=width
            ))
        return parameters
    
    def _parse_localparams(self, body: str) -> List[Parameter]:
        localparams = []
        for match in self.patterns['localparam'].finditer(body):
            msb = int(match.group(1)) if match.group(1) else -1
            lsb = int(match.group(2)) if match.group(2) else -1
            name = match.group(3)
            value = match.group(4).strip()
            width = msb - lsb + 1 if msb >= 0 else 1
            
            localparams.append(Parameter(
                name=name,
                default_value=value,
                msb=msb,
                lsb=lsb,
                width=width
            ))
        return localparams
    
    def _parse_signals(self, body: str) -> List[Signal]:
        signals = []
        
        for match in self.patterns['wire'].finditer(body):
            msb = int(match.group(1)) if match.group(1) else 0
            lsb = int(match.group(2)) if match.group(2) else 0
            names = match.group(3).split(',')
            width = msb - lsb + 1 if match.group(1) else 1
            
            for name in names:
                name = name.strip()
                if name:
                    signals.append(Signal(
                        name=name,
                        signal_type='wire',
                        msb=msb,
                        lsb=lsb,
                        width=width
                    ))
        
        for match in self.patterns['reg'].finditer(body):
            msb = int(match.group(1)) if match.group(1) else 0
            lsb = int(match.group(2)) if match.group(2) else 0
            names = match.group(3).split(',')
            width = msb - lsb + 1 if match.group(1) else 1
            
            for name in names:
                name = name.strip()
                if name:
                    signals.append(Signal(
                        name=name,
                        signal_type='reg',
                        msb=msb,
                        lsb=lsb,
                        width=width
                    ))
        
        return signals
    
    def _parse_instances(self, body: str) -> List[Instance]:
        instances = []
        for match in self.patterns['instance'].finditer(body):
            module_name = match.group(1)
            param_str = match.group(2) or ""
            instance_name = match.group(3)
            conn_str = match.group(4) or ""
            
            connections = {}
            for conn in conn_str.split(','):
                conn = conn.strip()
                if '.' in conn:
                    port_match = re.match(r'\.(\w+)\s*\((.+?)\)', conn)
                    if port_match:
                        connections[port_match.group(1)] = port_match.group(2).strip()
            
            parameters = {}
            if param_str:
                for param in param_str.split(','):
                    param = param.strip()
                    if '.' in param:
                        param_match = re.match(r'\.(\w+)\s*\((.+?)\)', param)
                        if param_match:
                            parameters[param_match.group(1)] = param_match.group(2).strip()
            
            instances.append(Instance(
                module_name=module_name,
                instance_name=instance_name,
                connections=connections,
                parameters=parameters
            ))
        
        return instances
    
    def _parse_always_blocks(self, body: str) -> List[AlwaysBlock]:
        blocks = []
        
        for match in self.patterns['always'].finditer(body):
            sensitivity = match.group(1).strip()
            block_body = match.group(2).strip()
            block_type = self._determine_always_type(sensitivity)
            
            blocks.append(AlwaysBlock(
                sensitivity=sensitivity,
                body=block_body,
                block_type=block_type
            ))
        
        for match in self.patterns['always_ff'].finditer(body):
            sensitivity = match.group(1).strip()
            block_body = match.group(2).strip()
            
            blocks.append(AlwaysBlock(
                sensitivity=sensitivity,
                body=block_body,
                block_type='sequential'
            ))
        
        for match in self.patterns['always_comb'].finditer(body):
            block_body = match.group(1).strip()
            
            blocks.append(AlwaysBlock(
                sensitivity='*',
                body=block_body,
                block_type='combinational'
            ))
        
        return blocks
    
    def _determine_always_type(self, sensitivity: str) -> str:
        if 'posedge' in sensitivity or 'negedge' in sensitivity:
            return 'sequential'
        elif sensitivity == '*':
            return 'combinational'
        else:
            return 'mixed'
    
    def _parse_assigns(self, body: str) -> List[Tuple[str, str]]:
        assigns = []
        for match in self.patterns['assign'].finditer(body):
            lhs = match.group(1)
            rhs = match.group(2)
            assigns.append((lhs, rhs))
        return assigns
    
    def _extract_comments(self, body: str) -> Dict[str, str]:
        comments = {}
        
        for match in self.patterns['comment_line'].finditer(body):
            comment = match.group(1).strip()
            pos = match.start()
            comments[f'line_{pos}'] = comment
        
        for match in self.patterns['comment_block'].finditer(body):
            comment = match.group(1).strip()
            pos = match.start()
            comments[f'block_{pos}'] = comment
        
        return comments
    
    def _detect_state_machines(self, body: str, always_blocks: List[AlwaysBlock]) -> List[StateMachine]:
        state_machines = []
        
        state_regs = []
        for match in self.patterns['state_reg'].finditer(body):
            state_regs.append(match.group(3))
        
        for state_reg in state_regs:
            states = set()
            transitions = {}
            state_width = 1
            
            for block in always_blocks:
                if block.block_type == 'sequential':
                    case_match = self.patterns['case'].search(block.body)
                    if case_match:
                        case_var = case_match.group(1)
                        if case_var == state_reg or state_reg in case_var:
                            case_body = case_match.group(2)
                            
                            state_pattern = re.compile(r"(\w+)\s*:\s*begin.*?(\w+)\s*<=", re.DOTALL)
                            for sm in state_pattern.finditer(case_body):
                                current_state = sm.group(1)
                                next_state = sm.group(2)
                                states.add(current_state)
                                states.add(next_state)
                                transitions[(current_state, next_state)] = ""
            
            if states:
                state_machines.append(StateMachine(
                    state_reg=state_reg,
                    states=list(states),
                    transitions=transitions,
                    state_width=state_width
                ))
        
        return state_machines
    
    def _detect_pipelines(self, body: str, signals: List[Signal]) -> List[Pipeline]:
        pipelines = []
        
        pipe_patterns = [
            r'(pipe\d+)',
            r'(ex\d+)',
            r'(id\d+)',
            r'(if\d+)',
            r'(mem\d+)',
            r'(wb\d+)',
            r'(s\d+)',
            r'(e\d+)'
        ]
        
        stage_signals = {}
        for signal in signals:
            for pattern in pipe_patterns:
                match = re.search(pattern, signal.name, re.IGNORECASE)
                if match:
                    stage = match.group(1).upper()
                    if stage not in stage_signals:
                        stage_signals[stage] = []
                    stage_signals[stage].append(signal.name)
                    break
        
        control_signals = {}
        for signal in signals:
            if 'valid' in signal.name.lower():
                control_signals[signal.name] = 'valid'
            elif 'ready' in signal.name.lower():
                control_signals[signal.name] = 'ready'
            elif 'stall' in signal.name.lower():
                control_signals[signal.name] = 'stall'
            elif 'flush' in signal.name.lower():
                control_signals[signal.name] = 'flush'
        
        if stage_signals:
            stages = sorted(stage_signals.keys(), key=lambda x: int(re.search(r'\d+', x).group()) if re.search(r'\d+', x) else 0)
            pipelines.append(Pipeline(
                stages=stages,
                stage_signals=stage_signals,
                control_signals=control_signals
            ))
        
        return pipelines


def parse_verilog_files(file_paths: List[str]) -> List[Module]:
    parser = VerilogParser()
    modules = []
    
    for file_path in file_paths:
        if os.path.exists(file_path):
            module = parser.parse_file(file_path)
            if module:
                modules.append(module)
    
    return modules


def find_verilog_files(directory: str) -> List[str]:
    verilog_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(('.v', '.sv', '.vh', '.svh')):
                verilog_files.append(os.path.join(root, file))
    return verilog_files


if __name__ == '__main__':
    import sys
    if len(sys.argv) > 1:
        files = sys.argv[1:]
        modules = parse_verilog_files(files)
        for module in modules:
            print(f"Module: {module.name}")
            print(f"  Ports: {len(module.ports)}")
            print(f"  Parameters: {len(module.parameters)}")
            print(f"  Signals: {len(module.signals)}")
            print(f"  Instances: {len(module.instances)}")
            print(f"  State Machines: {len(module.state_machines)}")
            print(f"  Pipelines: {len(module.pipelines)}")
