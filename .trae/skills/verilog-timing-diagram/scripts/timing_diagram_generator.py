#!/usr/bin/env python3
"""
Verilog Timing Diagram Generator
从 Verilog 源文件生成模块接口时序图
输出格式：
1. Markdown文件 - 使用Mermaid Sequence Diagram
2. WaveDrom JSON文件 - 用于波形描述
3. PNG图片 - 使用WaveDrom CLI导出
"""

import re
import os
import json
import subprocess
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass, field
from enum import Enum


class SignalType(Enum):
    CLOCK = "clock"
    RESET = "reset"
    VALID = "valid"
    READY = "ready"
    REQUEST = "request"
    ACKNOWLEDGE = "acknowledge"
    DATA = "data"
    ADDRESS = "address"
    ENABLE = "enable"
    STATUS = "status"
    OTHER = "other"


class TimingPatternType(Enum):
    VALID_READY = "valid_ready"
    REQ_ACK = "req_ack"
    FIFO_WRITE = "fifo_write"
    FIFO_READ = "fifo_read"
    SRAM = "sram"
    AXI_WRITE = "axi_write"
    AXI_READ = "axi_read"
    APB = "apb"
    RESET = "reset"


@dataclass
class Port:
    name: str
    direction: str
    msb: int
    lsb: int
    width: int
    signal_type: SignalType = SignalType.OTHER


@dataclass
class TimingPattern:
    pattern_type: TimingPatternType
    signals: List[str]
    description: str
    clock_domain: str = ""


class TimingDiagramGenerator:
    def __init__(self):
        self.signal_keywords = {
            'clock': ['clk', 'clock', 'sys_clk', 'cpuclk', 'forever_cpuclk', 'pll_clk'],
            'reset': ['rst', 'reset', 'rst_b', 'rst_n', 'cpurst_b', 'rstn', 'reset_n', 'reset_b'],
            'valid': ['valid', 'vld', '_vld', 'valid_i', 'valid_o'],
            'ready': ['ready', 'rdy', '_rdy', 'ready_i', 'ready_o'],
            'request': ['req', 'request', '_req', 'req_i', 'req_o'],
            'acknowledge': ['ack', 'acknowledge', '_ack', 'ack_i', 'ack_o'],
            'data': ['data', 'wdata', 'rdata', 'din', 'dout', 'dat', 'w_dat', 'r_dat'],
            'address': ['addr', 'address', 'awaddr', 'araddr', 'paddr'],
            'enable': ['en', 'enable', '_en', 'we', 're', 'wr_en', 'rd_en', 'wen', 'ren'],
            'status': ['full', 'empty', 'done', 'busy', 'error', 'status', 'complete'],
            'axi_aw': ['awvalid', 'awready', 'awaddr', 'awlen', 'awsize', 'awburst', 'awlock', 'awcache', 'awprot', 'awqos', 'awregion', 'awuser', 'awid'],
            'axi_w': ['wvalid', 'wready', 'wdata', 'wstrb', 'wlast', 'wuser', 'wid'],
            'axi_b': ['bvalid', 'bready', 'bresp', 'bid'],
            'axi_ar': ['arvalid', 'arready', 'araddr', 'arlen', 'arsize', 'arburst', 'arlock', 'arcache', 'arprot', 'arqos', 'arregion', 'aruser', 'arid'],
            'axi_r': ['rvalid', 'rready', 'rdata', 'rresp', 'rlast', 'ruser', 'rid'],
            'apb': ['psel', 'penable', 'pwrite', 'paddr', 'pwdata', 'prdata', 'pready', 'pslverr', 'pprot', 'pstrb'],
        }
        
        self.patterns = {
            'module': re.compile(r'module\s+(\w+)\s*(?:#\s*\((.*?)\))?\s*\((.*?)\);', re.DOTALL),
            'endmodule': re.compile(r'endmodule'),
            'port': re.compile(r'(input|output|inout)\s+(?:wire\s+|reg\s+)?(?:\[(\d+):(\d+)\]\s+)?(\w+)'),
            'assign': re.compile(r'assign\s+(\w+)\s*=\s*(.+?)\s*;'),
            'always': re.compile(r'always\s*@\s*\((.*?)\)\s*begin(.*?)end', re.DOTALL),
        }
    
    def load_file(self, file_path: str) -> Optional[str]:
        if not os.path.exists(file_path):
            return None
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            return f.read()
    
    def classify_signal(self, signal_name: str) -> SignalType:
        name_lower = signal_name.lower()
        
        if any(kw in name_lower for kw in self.signal_keywords['clock']):
            return SignalType.CLOCK
        
        reset_keywords = ['rst', 'reset', 'rst_b', 'rst_n', 'rstn', 'reset_n', 'reset_b']
        if any(name_lower == kw or name_lower.startswith(kw + '_') or name_lower.endswith('_' + kw) or ('_' + kw + '_') in name_lower for kw in reset_keywords):
            return SignalType.RESET
        
        if any(kw in name_lower for kw in self.signal_keywords['valid']):
            return SignalType.VALID
        
        if any(kw in name_lower for kw in self.signal_keywords['ready']):
            return SignalType.READY
        
        if any(kw in name_lower for kw in self.signal_keywords['request']):
            return SignalType.REQUEST
        
        if any(kw in name_lower for kw in self.signal_keywords['acknowledge']):
            return SignalType.ACKNOWLEDGE
        
        if any(kw in name_lower for kw in self.signal_keywords['data']):
            return SignalType.DATA
        
        if any(kw in name_lower for kw in self.signal_keywords['address']):
            return SignalType.ADDRESS
        
        if any(kw in name_lower for kw in self.signal_keywords['enable']):
            return SignalType.ENABLE
        
        if any(kw in name_lower for kw in self.signal_keywords['status']):
            return SignalType.STATUS
        
        return SignalType.OTHER
    
    def parse_ports(self, content: str) -> List[Port]:
        ports = []
        module_match = self.patterns['module'].search(content)
        if not module_match:
            return ports
        
        port_section = module_match.group(3) or ""
        
        for match in self.patterns['port'].finditer(port_section):
            direction = match.group(1)
            msb = int(match.group(2)) if match.group(2) else 0
            lsb = int(match.group(3)) if match.group(3) else 0
            name = match.group(4)
            width = msb - lsb + 1 if match.group(2) else 1
            signal_type = self.classify_signal(name)
            
            ports.append(Port(
                name=name,
                direction=direction,
                msb=msb,
                lsb=lsb,
                width=width,
                signal_type=signal_type
            ))
        
        if ports:
            return ports
        
        port_names = re.findall(r'(\w+)\s*(?:,|\))', port_section)
        if port_names:
            endmodule_match = self.patterns['endmodule'].search(content)
            module_body_end = endmodule_match.start() if endmodule_match else len(content)
            module_body = content[module_match.end():module_body_end]
            
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
                    signal_type = self.classify_signal(name)
                    ports.append(Port(
                        name=name,
                        direction=port_info['direction'],
                        msb=port_info['msb'],
                        lsb=port_info['lsb'],
                        width=port_info['width'],
                        signal_type=signal_type
                    ))
        
        return ports
    
    def detect_timing_patterns(self, ports: List[Port], content: str = "") -> List[TimingPattern]:
        patterns = []
        port_dict = {p.name: p for p in ports}
        
        valid_signals = [p for p in ports if p.signal_type == SignalType.VALID]
        ready_signals = [p for p in ports if p.signal_type == SignalType.READY]
        req_signals = [p for p in ports if p.signal_type == SignalType.REQUEST]
        ack_signals = [p for p in ports if p.signal_type == SignalType.ACKNOWLEDGE]
        data_signals = [p for p in ports if p.signal_type == SignalType.DATA]
        enable_signals = [p for p in ports if p.signal_type == SignalType.ENABLE]
        status_signals = [p for p in ports if p.signal_type == SignalType.STATUS]
        
        matched_pairs = set()
        
        for v in valid_signals:
            for r in ready_signals:
                v_base = v.name.lower().replace('valid', '').replace('vld', '').rstrip('_')
                r_base = r.name.lower().replace('ready', '').replace('rdy', '').rstrip('_')
                
                if v_base == r_base and v_base:
                    pair_key = (v.name, r.name)
                    if pair_key not in matched_pairs:
                        matched_pairs.add(pair_key)
                        related_data = [d.name for d in data_signals 
                                       if v_base in d.name.lower() or d.name.lower() in v_base]
                        signals = [v.name, r.name] + related_data[:1]
                        patterns.append(TimingPattern(
                            pattern_type=TimingPatternType.VALID_READY,
                            signals=signals,
                            description=f"{v.name} 和 {r.name} 构成 Valid-Ready 握手协议"
                        ))
        
        for req in req_signals:
            for ack in ack_signals:
                req_base = req.name.lower().replace('req', '').replace('request', '')
                ack_base = ack.name.lower().replace('ack', '').replace('acknowledge', '')
                if req_base == ack_base or req_base in ack_base or ack_base in req_base:
                    patterns.append(TimingPattern(
                        pattern_type=TimingPatternType.REQ_ACK,
                        signals=[req.name, ack.name],
                        description=f"{req.name} 和 {ack.name} 构成请求-响应协议"
                    ))
        
        wr_en_signals = [p for p in enable_signals if 'wr' in p.name.lower() or 'write' in p.name.lower()]
        rd_en_signals = [p for p in enable_signals if 'rd' in p.name.lower() or 'read' in p.name.lower()]
        full_signals = [p for p in status_signals if 'full' in p.name.lower()]
        empty_signals = [p for p in status_signals if 'empty' in p.name.lower()]
        
        for wr_en in wr_en_signals:
            for full in full_signals:
                patterns.append(TimingPattern(
                    pattern_type=TimingPatternType.FIFO_WRITE,
                    signals=[wr_en.name, full.name],
                    description=f"{wr_en.name} 和 {full.name} 构成 FIFO 写接口"
                ))
        
        for rd_en in rd_en_signals:
            for empty in empty_signals:
                patterns.append(TimingPattern(
                    pattern_type=TimingPatternType.FIFO_READ,
                    signals=[rd_en.name, empty.name],
                    description=f"{rd_en.name} 和 {empty.name} 构成 FIFO 读接口"
                ))
        
        awvalid = [p for p in ports if 'awvalid' in p.name.lower()]
        awready = [p for p in ports if 'awready' in p.name.lower()]
        wvalid = [p for p in ports if 'wvalid' in p.name.lower() and 'aw' not in p.name.lower()]
        wready = [p for p in ports if 'wready' in p.name.lower() and 'aw' not in p.name.lower()]
        
        if awvalid and awready and wvalid and wready:
            signals = [awvalid[0].name, awready[0].name, wvalid[0].name, wready[0].name]
            patterns.append(TimingPattern(
                pattern_type=TimingPatternType.AXI_WRITE,
                signals=signals,
                description="AXI 写通道"
            ))
        
        arvalid = [p for p in ports if 'arvalid' in p.name.lower()]
        arready = [p for p in ports if 'arready' in p.name.lower()]
        rvalid = [p for p in ports if 'rvalid' in p.name.lower() and 'ar' not in p.name.lower()]
        rready = [p for p in ports if 'rready' in p.name.lower() and 'ar' not in p.name.lower()]
        
        if arvalid and arready and rvalid and rready:
            signals = [arvalid[0].name, arready[0].name, rvalid[0].name, rready[0].name]
            patterns.append(TimingPattern(
                pattern_type=TimingPatternType.AXI_READ,
                signals=signals,
                description="AXI 读通道"
            ))
        
        psel = [p for p in ports if 'psel' in p.name.lower()]
        penable = [p for p in ports if 'penable' in p.name.lower()]
        pwrite = [p for p in ports if 'pwrite' in p.name.lower()]
        
        if psel and penable:
            signals = [psel[0].name, penable[0].name]
            if pwrite:
                signals.append(pwrite[0].name)
            patterns.append(TimingPattern(
                pattern_type=TimingPatternType.APB,
                signals=signals,
                description="APB 传输协议"
            ))
        
        reset_signals = [p for p in ports if p.signal_type == SignalType.RESET]
        if reset_signals:
            patterns.append(TimingPattern(
                pattern_type=TimingPatternType.RESET,
                signals=[reset_signals[0].name],
                description="复位时序"
            ))
        
        return patterns
    
    def generate_wavedrom_valid_ready(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        valid_name = pattern.signals[0]
        ready_name = pattern.signals[1]
        data_name = pattern.signals[2] if len(pattern.signals) > 2 else None
        
        signals.append({"name": valid_name, "wave": "01..0......"})
        signals.append({"name": ready_name, "wave": "0..1.0....."})
        
        if data_name:
            signals.append({"name": data_name, "wave": "x..=.x.....", "data": ["D0"]})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} Valid-Ready 握手时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_req_ack(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        req_name = pattern.signals[0]
        ack_name = pattern.signals[1]
        
        signals.append({"name": req_name, "wave": "01..0......"})
        signals.append({"name": ack_name, "wave": "0...1.0...."})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} Req-Ack 请求响应时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_fifo_write(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        wr_en_name = pattern.signals[0]
        full_name = pattern.signals[1]
        
        signals.append({"name": wr_en_name, "wave": "01.0.1.0..."})
        signals.append({"name": full_name, "wave": "0..........."})
        
        wr_data = next((p for p in ports if 'wr_data' in p.name.lower() or 'wdata' in p.name.lower()), None)
        if wr_data:
            signals.append({"name": wr_data.name, "wave": "x.=.x.=.x..", "data": ["D0", "D1"]})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} FIFO 写操作时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_fifo_read(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        rd_en_name = pattern.signals[0]
        empty_name = pattern.signals[1]
        
        signals.append({"name": rd_en_name, "wave": "01.0.1.0..."})
        signals.append({"name": empty_name, "wave": "0..........."})
        
        rd_data = next((p for p in ports if 'rd_data' in p.name.lower() or 'rdata' in p.name.lower()), None)
        if rd_data:
            signals.append({"name": rd_data.name, "wave": "x..=.x.=.x.", "data": ["Q0", "Q1"]})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} FIFO 读操作时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_axi_write(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..................."})
        
        awvalid = pattern.signals[0]
        awready = pattern.signals[1]
        wvalid = pattern.signals[2]
        wready = pattern.signals[3]
        
        signals.append({"name": awvalid, "wave": "01..........0......"})
        signals.append({"name": awready, "wave": "0.1.0.............."})
        
        awaddr = next((p for p in ports if 'awaddr' in p.name.lower()), None)
        if awaddr:
            signals.append({"name": awaddr.name, "wave": "x.=.x..............", "data": ["ADDR"]})
        
        signals.append({"name": wvalid, "wave": "0....01..0.........."})
        signals.append({"name": wready, "wave": "0......1.0.........."})
        
        wdata = next((p for p in ports if 'wdata' in p.name.lower() and 'aw' not in p.name.lower()), None)
        if wdata:
            signals.append({"name": wdata.name, "wave": "x......=.x.........", "data": ["DATA"]})
        
        bvalid = next((p for p in ports if 'bvalid' in p.name.lower()), None)
        bready = next((p for p in ports if 'bready' in p.name.lower()), None)
        if bvalid:
            signals.append({"name": bvalid, "wave": "0..........01.0...."})
        if bready:
            signals.append({"name": bready, "wave": "0............1.0..."})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} AXI 写通道时序"},
            "config": {"hscale": 1.5}
        }
    
    def generate_wavedrom_axi_read(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..................."})
        
        arvalid = pattern.signals[0]
        arready = pattern.signals[1]
        rvalid = pattern.signals[2]
        rready = pattern.signals[3]
        
        signals.append({"name": arvalid, "wave": "01..........0......"})
        signals.append({"name": arready, "wave": "0.1.0.............."})
        
        araddr = next((p for p in ports if 'araddr' in p.name.lower()), None)
        if araddr:
            signals.append({"name": araddr.name, "wave": "x.=.x..............", "data": ["ADDR"]})
        
        signals.append({"name": rvalid, "wave": "0..........01.0...."})
        signals.append({"name": rready, "wave": "0............1.0..."})
        
        rdata = next((p for p in ports if 'rdata' in p.name.lower() and 'ar' not in p.name.lower()), None)
        if rdata:
            signals.append({"name": rdata.name, "wave": "x..........=.x.....", "data": ["DATA"]})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} AXI 读通道时序"},
            "config": {"hscale": 1.5}
        }
    
    def generate_wavedrom_apb(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        psel = pattern.signals[0]
        penable = pattern.signals[1]
        pwrite = pattern.signals[2] if len(pattern.signals) > 2 else None
        
        signals.append({"name": psel, "wave": "01........0"})
        signals.append({"name": penable, "wave": "0.1......0."})
        
        if pwrite:
            signals.append({"name": pwrite, "wave": "0..........."})
        
        paddr = next((p for p in ports if 'paddr' in p.name.lower()), None)
        if paddr:
            signals.append({"name": paddr.name, "wave": "x.=.........", "data": ["ADDR"]})
        
        pwdata = next((p for p in ports if 'pwdata' in p.name.lower()), None)
        if pwdata:
            signals.append({"name": pwdata.name, "wave": "x..=.......", "data": ["DATA"]})
        
        prdata = next((p for p in ports if 'prdata' in p.name.lower()), None)
        if prdata:
            signals.append({"name": prdata.name, "wave": "x..........", "data": []})
        
        pready = next((p for p in ports if 'pready' in p.name.lower()), None)
        if pready:
            signals.append({"name": pready, "wave": "1..........."})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} APB 传输时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_reset(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> Dict:
        signals = []
        
        clock = next((p for p in ports if p.signal_type == SignalType.CLOCK), None)
        if clock:
            signals.append({"name": clock.name, "wave": "p..........."})
        
        rst_name = pattern.signals[0]
        if '_b' in rst_name.lower() or '_n' in rst_name.lower():
            signals.append({"name": rst_name, "wave": "01.........."})
        else:
            signals.append({"name": rst_name, "wave": "10.........."})
        
        data_signals = [p for p in ports if p.signal_type == SignalType.DATA][:2]
        for data in data_signals:
            signals.append({"name": data.name, "wave": "x..=.==.=..", "data": ["D0", "D1", "D2"]})
        
        return {
            "signal": signals,
            "head": {"text": f"{module_name} 复位时序"},
            "config": {"hscale": 2}
        }
    
    def generate_wavedrom_json(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        generators = {
            TimingPatternType.VALID_READY: self.generate_wavedrom_valid_ready,
            TimingPatternType.REQ_ACK: self.generate_wavedrom_req_ack,
            TimingPatternType.FIFO_WRITE: self.generate_wavedrom_fifo_write,
            TimingPatternType.FIFO_READ: self.generate_wavedrom_fifo_read,
            TimingPatternType.AXI_WRITE: self.generate_wavedrom_axi_write,
            TimingPatternType.AXI_READ: self.generate_wavedrom_axi_read,
            TimingPatternType.APB: self.generate_wavedrom_apb,
            TimingPatternType.RESET: self.generate_wavedrom_reset,
        }
        
        generator = generators.get(pattern.pattern_type)
        if generator:
            wavedrom_dict = generator(pattern, ports, module_name)
            return json.dumps(wavedrom_dict, ensure_ascii=False, indent=2)
        
        return ""
    
    def generate_mermaid_valid_ready(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Testbench/上游模块")
        lines.append(f"    participant DUT as {module_name}")
        lines.append("")
        
        valid_name = pattern.signals[0]
        ready_name = pattern.signals[1]
        data_name = pattern.signals[2] if len(pattern.signals) > 2 else None
        
        lines.append(f"    Note over TB,DUT: Valid-Ready 握手协议时序")
        lines.append("")
        lines.append(f"    TB->>DUT: {valid_name}=1")
        if data_name:
            lines.append(f"    TB->>DUT: {data_name}=D0")
        lines.append(f"    DUT-->>TB: {ready_name}=0 (未就绪)")
        lines.append("    Note over DUT: 内部处理中...")
        lines.append(f"    DUT-->>TB: {ready_name}=1 (就绪)")
        lines.append("    Note over TB,DUT: 握手成功，数据传输完成")
        lines.append(f"    TB->>DUT: {valid_name}=0")
        lines.append("    Note over TB,DUT: 传输结束")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_req_ack(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Testbench/上游模块")
        lines.append(f"    participant DUT as {module_name}")
        lines.append("")
        
        req_name = pattern.signals[0]
        ack_name = pattern.signals[1]
        
        lines.append(f"    Note over TB,DUT: Req-Ack 请求响应协议时序")
        lines.append("")
        lines.append(f"    TB->>DUT: {req_name}=1")
        lines.append("    Note over DUT: 处理请求...")
        lines.append(f"    DUT-->>TB: {ack_name}=1")
        lines.append("    Note over TB,DUT: 请求处理完成")
        lines.append(f"    TB->>DUT: {req_name}=0")
        lines.append(f"    DUT-->>TB: {ack_name}=0")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_fifo_write(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Testbench/上游模块")
        lines.append(f"    participant DUT as {module_name}")
        lines.append("")
        
        wr_en_name = pattern.signals[0]
        full_name = pattern.signals[1]
        
        wr_data = next((p for p in ports if 'wr_data' in p.name.lower() or 'wdata' in p.name.lower()), None)
        
        lines.append(f"    Note over TB,DUT: FIFO 写操作时序")
        lines.append("")
        lines.append(f"    DUT-->>TB: {full_name}=0 (未满)")
        lines.append(f"    TB->>DUT: {wr_en_name}=1")
        if wr_data:
            lines.append(f"    TB->>DUT: {wr_data.name}=D0")
        lines.append("    Note over DUT: 写入数据")
        lines.append(f"    TB->>DUT: {wr_en_name}=0")
        lines.append("")
        lines.append(f"    DUT-->>TB: {full_name}=0 (未满)")
        lines.append(f"    TB->>DUT: {wr_en_name}=1")
        if wr_data:
            lines.append(f"    TB->>DUT: {wr_data.name}=D1")
        lines.append("    Note over DUT: 写入数据")
        lines.append(f"    TB->>DUT: {wr_en_name}=0")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_fifo_read(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Testbench/上游模块")
        lines.append(f"    participant DUT as {module_name}")
        lines.append("")
        
        rd_en_name = pattern.signals[0]
        empty_name = pattern.signals[1]
        
        rd_data = next((p for p in ports if 'rd_data' in p.name.lower() or 'rdata' in p.name.lower()), None)
        
        lines.append(f"    Note over TB,DUT: FIFO 读操作时序")
        lines.append("")
        lines.append(f"    DUT-->>TB: {empty_name}=0 (非空)")
        lines.append(f"    TB->>DUT: {rd_en_name}=1")
        lines.append("    Note over DUT: 读取数据")
        if rd_data:
            lines.append(f"    DUT-->>TB: {rd_data.name}=Q0")
        lines.append(f"    TB->>DUT: {rd_en_name}=0")
        lines.append("")
        lines.append(f"    DUT-->>TB: {empty_name}=0 (非空)")
        lines.append(f"    TB->>DUT: {rd_en_name}=1")
        if rd_data:
            lines.append(f"    DUT-->>TB: {rd_data.name}=Q1")
        lines.append(f"    TB->>DUT: {rd_en_name}=0")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_axi_write(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Master")
        lines.append(f"    participant DUT as {module_name} (Slave)")
        lines.append("")
        
        awvalid = pattern.signals[0]
        awready = pattern.signals[1]
        wvalid = pattern.signals[2]
        wready = pattern.signals[3]
        
        awaddr = next((p for p in ports if 'awaddr' in p.name.lower()), None)
        wdata = next((p for p in ports if 'wdata' in p.name.lower() and 'aw' not in p.name.lower()), None)
        bvalid = next((p for p in ports if 'bvalid' in p.name.lower()), None)
        bready = next((p for p in ports if 'bready' in p.name.lower()), None)
        
        lines.append(f"    Note over TB,DUT: AXI 写通道时序")
        lines.append("")
        lines.append("    rect rgb(200, 220, 240)")
        lines.append("    Note right of TB: 地址通道")
        lines.append(f"    TB->>DUT: {awvalid}=1")
        if awaddr:
            lines.append(f"    TB->>DUT: {awaddr.name}=ADDR")
        lines.append(f"    DUT-->>TB: {awready}=1")
        lines.append("    Note over TB,DUT: 地址握手成功")
        lines.append(f"    TB->>DUT: {awvalid}=0")
        lines.append("    end")
        lines.append("")
        lines.append("    rect rgb(220, 240, 200)")
        lines.append("    Note right of TB: 数据通道")
        lines.append(f"    TB->>DUT: {wvalid}=1")
        if wdata:
            lines.append(f"    TB->>DUT: {wdata.name}=DATA")
        lines.append(f"    DUT-->>TB: {wready}=1")
        lines.append("    Note over TB,DUT: 数据握手成功")
        lines.append(f"    TB->>DUT: {wvalid}=0")
        lines.append("    end")
        lines.append("")
        if bvalid:
            lines.append("    rect rgb(240, 220, 200)")
            lines.append("    Note right of TB: 响应通道")
            lines.append(f"    DUT-->>TB: {bvalid}=1, bresp=OKAY")
            if bready:
                lines.append(f"    TB->>DUT: {bready}=1")
            lines.append("    Note over TB,DUT: 写响应完成")
            lines.append("    end")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_axi_read(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as Master")
        lines.append(f"    participant DUT as {module_name} (Slave)")
        lines.append("")
        
        arvalid = pattern.signals[0]
        arready = pattern.signals[1]
        rvalid = pattern.signals[2]
        rready = pattern.signals[3]
        
        araddr = next((p for p in ports if 'araddr' in p.name.lower()), None)
        rdata = next((p for p in ports if 'rdata' in p.name.lower() and 'ar' not in p.name.lower()), None)
        
        lines.append(f"    Note over TB,DUT: AXI 读通道时序")
        lines.append("")
        lines.append("    rect rgb(200, 220, 240)")
        lines.append("    Note right of TB: 地址通道")
        lines.append(f"    TB->>DUT: {arvalid}=1")
        if araddr:
            lines.append(f"    TB->>DUT: {araddr.name}=ADDR")
        lines.append(f"    DUT-->>TB: {arready}=1")
        lines.append("    Note over TB,DUT: 地址握手成功")
        lines.append(f"    TB->>DUT: {arvalid}=0")
        lines.append("    end")
        lines.append("")
        lines.append("    rect rgb(220, 240, 200)")
        lines.append("    Note right of TB: 数据通道")
        lines.append(f"    DUT-->>TB: {rvalid}=1")
        if rdata:
            lines.append(f"    DUT-->>TB: {rdata.name}=DATA")
        lines.append(f"    TB->>DUT: {rready}=1")
        lines.append("    Note over TB,DUT: 读数据握手成功")
        lines.append("    end")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_apb(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant TB as APB Master")
        lines.append(f"    participant DUT as {module_name} (APB Slave)")
        lines.append("")
        
        psel = pattern.signals[0]
        penable = pattern.signals[1]
        pwrite = pattern.signals[2] if len(pattern.signals) > 2 else None
        
        paddr = next((p for p in ports if 'paddr' in p.name.lower()), None)
        pwdata = next((p for p in ports if 'pwdata' in p.name.lower()), None)
        prdata = next((p for p in ports if 'prdata' in p.name.lower()), None)
        pready = next((p for p in ports if 'pready' in p.name.lower()), None)
        
        lines.append(f"    Note over TB,DUT: APB 传输时序")
        lines.append("")
        lines.append("    rect rgb(200, 220, 240)")
        lines.append("    Note right of TB: SETUP 阶段")
        lines.append(f"    TB->>DUT: {psel}=1, {penable}=0")
        if paddr:
            lines.append(f"    TB->>DUT: {paddr.name}=ADDR")
        if pwrite:
            lines.append(f"    TB->>DUT: {pwrite.name}=1 (写操作)")
        if pwdata:
            lines.append(f"    TB->>DUT: {pwdata.name}=DATA")
        lines.append("    end")
        lines.append("")
        lines.append("    rect rgb(220, 240, 200)")
        lines.append("    Note right of TB: ACCESS 阶段")
        lines.append(f"    TB->>DUT: {penable}=1")
        if pready:
            lines.append(f"    DUT-->>TB: {pready}=1")
        if prdata:
            lines.append(f"    DUT-->>TB: {prdata.name}=DATA (读操作)")
        lines.append("    Note over TB,DUT: 传输完成")
        lines.append("    end")
        lines.append("")
        lines.append("    rect rgb(240, 240, 240)")
        lines.append("    Note right of TB: IDLE 阶段")
        lines.append(f"    TB->>DUT: {psel}=0, {penable}=0")
        lines.append("    end")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_reset(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        lines = ["```mermaid", "sequenceDiagram"]
        
        lines.append("    participant SYS as 系统")
        lines.append(f"    participant DUT as {module_name}")
        lines.append("")
        
        rst_name = pattern.signals[0]
        is_active_low = '_b' in rst_name.lower() or '_n' in rst_name.lower()
        
        lines.append(f"    Note over SYS,DUT: 复位时序 ({'低电平有效' if is_active_low else '高电平有效'})")
        lines.append("")
        
        if is_active_low:
            lines.append(f"    SYS->>DUT: {rst_name}=0 (复位有效)")
            lines.append("    Note over DUT: 模块处于复位状态")
            lines.append("    Note over DUT: 寄存器初始化...")
            lines.append(f"    SYS->>DUT: {rst_name}=1 (复位释放)")
        else:
            lines.append(f"    SYS->>DUT: {rst_name}=1 (复位有效)")
            lines.append("    Note over DUT: 模块处于复位状态")
            lines.append("    Note over DUT: 寄存器初始化...")
            lines.append(f"    SYS->>DUT: {rst_name}=0 (复位释放)")
        
        lines.append("    Note over DUT: 开始正常工作")
        lines.append("    DUT-->>SYS: 模块就绪")
        
        lines.append("```")
        return '\n'.join(lines)
    
    def generate_mermaid_sequence(self, pattern: TimingPattern, ports: List[Port], module_name: str) -> str:
        generators = {
            TimingPatternType.VALID_READY: self.generate_mermaid_valid_ready,
            TimingPatternType.REQ_ACK: self.generate_mermaid_req_ack,
            TimingPatternType.FIFO_WRITE: self.generate_mermaid_fifo_write,
            TimingPatternType.FIFO_READ: self.generate_mermaid_fifo_read,
            TimingPatternType.AXI_WRITE: self.generate_mermaid_axi_write,
            TimingPatternType.AXI_READ: self.generate_mermaid_axi_read,
            TimingPatternType.APB: self.generate_mermaid_apb,
            TimingPatternType.RESET: self.generate_mermaid_reset,
        }
        
        generator = generators.get(pattern.pattern_type)
        if generator:
            return generator(pattern, ports, module_name)
        
        return ""
    
    def export_png(self, wavedrom_json: str, output_path: str) -> bool:
        try:
            json_path = output_path.replace('.png', '_temp.json')
            with open(json_path, 'w', encoding='utf-8') as f:
                f.write(wavedrom_json)
            
            result = subprocess.run(
                ['wavedrom', '-i', json_path, '-o', output_path],
                capture_output=True,
                text=True,
                timeout=30
            )
            
            if os.path.exists(json_path):
                os.remove(json_path)
            
            if result.returncode == 0:
                return True
            else:
                print(f"WaveDrom CLI 错误: {result.stderr}")
                return False
        except FileNotFoundError:
            print("未找到 wavedrom CLI，请安装: npm install -g wavedrom-cli")
            return False
        except subprocess.TimeoutExpired:
            print("WaveDrom CLI 超时")
            return False
        except Exception as e:
            print(f"导出 PNG 失败: {e}")
            return False
    
    def generate_timing_diagrams(self, file_path: str, module_name: str = None, 
                                  output_dir: str = None, export_png: bool = False) -> Dict:
        content = self.load_file(file_path)
        if not content:
            return {"error": "无法读取文件"}
        
        module_match = self.patterns['module'].search(content)
        if not module_match:
            return {"error": "未找到模块定义"}
        
        actual_module_name = module_match.group(1)
        
        ports = self.parse_ports(content)
        patterns = self.detect_timing_patterns(ports, content)
        
        if not patterns:
            return {
                "module": actual_module_name,
                "patterns": [],
                "timing_diagrams": [],
                "message": "未检测到标准时序模式"
            }
        
        timing_diagrams = []
        
        for pattern in patterns:
            wavedrom_json = self.generate_wavedrom_json(pattern, ports, actual_module_name)
            mermaid_sequence = self.generate_mermaid_sequence(pattern, ports, actual_module_name)
            
            diagram = {
                "pattern_type": pattern.pattern_type.value,
                "description": pattern.description,
                "signals": pattern.signals,
                "wavedrom_json": wavedrom_json,
                "mermaid_sequence": mermaid_sequence
            }
            
            timing_diagrams.append(diagram)
        
        return {
            "module": actual_module_name,
            "patterns": [
                {
                    "type": p.pattern_type.value,
                    "signals": p.signals,
                    "description": p.description
                }
                for p in patterns
            ],
            "timing_diagrams": timing_diagrams,
            "ports": [{"name": p.name, "direction": p.direction, "type": p.signal_type.value} for p in ports]
        }
    
    def generate_markdown_file(self, result: Dict) -> str:
        lines = [f"# {result['module']} 接口时序图", ""]
        
        if not result.get("patterns"):
            lines.append("未检测到标准时序模式。")
            return '\n'.join(lines)
        
        lines.append("## 时序模式说明")
        lines.append("")
        lines.append("| 模式类型 | 相关信号 | 描述 |")
        lines.append("|----------|----------|------|")
        
        for pattern in result["patterns"]:
            signals_str = ', '.join(pattern["signals"])
            lines.append(f"| {pattern['type']} | {signals_str} | {pattern['description']} |")
        
        lines.append("")
        
        for i, diagram in enumerate(result.get("timing_diagrams", []), 1):
            lines.append(f"## 时序图 {i}: {diagram['description']}")
            lines.append("")
            lines.append("### Mermaid 序列图")
            lines.append("")
            lines.append(diagram["mermaid_sequence"])
            lines.append("")
        
        return '\n'.join(lines)
    
    def save_output_files(self, result: Dict, output_dir: str, export_png: bool = True) -> Dict[str, str]:
        os.makedirs(output_dir, exist_ok=True)
        
        module_name = result['module']
        base_name = f"{module_name}_timing"
        
        output_files = {}
        
        md_path = os.path.join(output_dir, f"{base_name}.md")
        md_content = self.generate_markdown_file(result)
        with open(md_path, 'w', encoding='utf-8') as f:
            f.write(md_content)
        output_files['md_path'] = md_path
        
        if result.get("timing_diagrams"):
            json_path = os.path.join(output_dir, f"{base_name}.json")
            wavedrom_data = {
                "module": module_name,
                "timing_diagrams": []
            }
            
            for diagram in result["timing_diagrams"]:
                try:
                    wavedrom_data["timing_diagrams"].append({
                        "pattern_type": diagram["pattern_type"],
                        "description": diagram["description"],
                        "wavedrom": json.loads(diagram["wavedrom_json"])
                    })
                except json.JSONDecodeError:
                    pass
            
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(wavedrom_data, f, ensure_ascii=False, indent=2)
            output_files['json_path'] = json_path
            
            if export_png:
                png_path = os.path.join(output_dir, f"{base_name}.png")
                first_diagram = result["timing_diagrams"][0]
                if self.export_png(first_diagram["wavedrom_json"], png_path):
                    output_files['png_path'] = png_path
        
        return output_files


def generate_timing_diagram(file_path: str, module_name: str = None,
                           output_dir: str = None, export_png: bool = False) -> Dict:
    generator = TimingDiagramGenerator()
    return generator.generate_timing_diagrams(file_path, module_name, output_dir, export_png)


def save_timing_files(file_path: str, output_dir: str, export_png: bool = True) -> Dict:
    generator = TimingDiagramGenerator()
    result = generator.generate_timing_diagrams(file_path, export_png=export_png, output_dir=output_dir)
    
    if "error" in result:
        return result
    
    return generator.save_output_files(result, output_dir, export_png)


if __name__ == '__main__':
    import sys
    
    if len(sys.argv) < 2:
        print("用法: python timing_diagram_generator.py <verilog_file> [--output-dir <dir>] [--no-png]")
        print("")
        print("参数:")
        print("  <verilog_file>    Verilog源文件路径")
        print("  --output-dir <dir> 输出目录 (默认: 当前目录)")
        print("  --no-png          不生成PNG文件")
        print("")
        print("输出文件:")
        print("  {module}_timing.md   - Mermaid序列图 (Markdown格式)")
        print("  {module}_timing.json - WaveDrom JSON文件")
        print("  {module}_timing.png  - PNG波形图 (需要安装wavedrom-cli)")
        sys.exit(1)
    
    file_path = sys.argv[1]
    export_png = '--no-png' not in sys.argv
    
    output_dir = '.'
    if '--output-dir' in sys.argv:
        idx = sys.argv.index('--output-dir')
        if idx + 1 < len(sys.argv):
            output_dir = sys.argv[idx + 1]
    
    result = save_timing_files(file_path, output_dir, export_png)
    
    if "error" in result:
        print(f"错误: {result['error']}")
        sys.exit(1)
    
    print("生成完成:")
    for key, path in result.items():
        print(f"  {key}: {path}")
