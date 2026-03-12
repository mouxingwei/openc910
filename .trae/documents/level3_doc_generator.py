#!/usr/bin/env python3
"""
Level 3 Document Generator for OpenC910
批量生成Level 3模块设计文档
"""

import os
import re
from typing import Dict, List, Optional
from dataclasses import dataclass

MODULES_LEVEL_3 = [
    {"name": "ct_ifu_addrgen", "path": "ifu/rtl/ct_ifu_addrgen.v", "desc": "IFU地址生成"},
    {"name": "ct_ifu_bht", "path": "ifu/rtl/ct_ifu_bht.v", "desc": "分支历史表"},
    {"name": "ct_ifu_btb", "path": "ifu/rtl/ct_ifu_btb.v", "desc": "分支目标缓冲"},
    {"name": "ct_ifu_l0_btb", "path": "ifu/rtl/ct_ifu_l0_btb.v", "desc": "L0 BTB"},
    {"name": "ct_ifu_sfp", "path": "ifu/rtl/ct_ifu_sfp.v", "desc": "简单跳转预测"},
    {"name": "ct_ifu_ibctrl", "path": "ifu/rtl/ct_ifu_ibctrl.v", "desc": "指令缓冲控制"},
    {"name": "ct_ifu_ibdp", "path": "ifu/rtl/ct_ifu_ibdp.v", "desc": "指令缓冲数据通路"},
    {"name": "ct_ifu_ibuf", "path": "ifu/rtl/ct_ifu_ibuf.v", "desc": "指令缓冲"},
    {"name": "ct_ifu_pcgen", "path": "ifu/rtl/ct_ifu_pcgen.v", "desc": "PC生成"},
    {"name": "ct_ifu_ipctrl", "path": "ifu/rtl/ct_ifu_ipctrl.v", "desc": "预取控制"},
    {"name": "ct_ifu_ipdp", "path": "ifu/rtl/ct_ifu_ipdp.v", "desc": "预取数据通路"},
    {"name": "ct_ifu_ifctrl", "path": "ifu/rtl/ct_ifu_ifctrl.v", "desc": "取指控制"},
    {"name": "ct_ifu_ifdp", "path": "ifu/rtl/ct_ifu_ifdp.v", "desc": "取指数据通路"},
    {"name": "ct_ifu_ras", "path": "ifu/rtl/ct_ifu_ras.v", "desc": "返回地址栈"},
    {"name": "ct_ifu_vector", "path": "ifu/rtl/ct_ifu_vector.v", "desc": "向量处理"},
    {"name": "ct_ifu_lbuf", "path": "ifu/rtl/ct_ifu_lbuf.v", "desc": "行缓冲"},
    {"name": "ct_ifu_decd_normal", "path": "ifu/rtl/ct_ifu_decd_normal.v", "desc": "正常译码"},
    {"name": "ct_ifu_precode", "path": "ifu/rtl/ct_ifu_precode.v", "desc": "预译码"},
    {"name": "ct_ifu_ind_btb", "path": "ifu/rtl/ct_ifu_ind_btb.v", "desc": "间接BTB"},
    
    {"name": "ct_idu_is_ctrl", "path": "idu/rtl/ct_idu_is_ctrl.v", "desc": "发射控制"},
    {"name": "ct_idu_is_dp", "path": "idu/rtl/ct_idu_is_dp.v", "desc": "发射数据通路"},
    {"name": "ct_idu_is_aiq0", "path": "idu/rtl/ct_idu_is_aiq0.v", "desc": "发射队列AIQ0"},
    {"name": "ct_idu_is_aiq1", "path": "idu/rtl/ct_idu_is_aiq1.v", "desc": "发射队列AIQ1"},
    {"name": "ct_idu_is_biq", "path": "idu/rtl/ct_idu_is_biq.v", "desc": "发射队列BIQ"},
    {"name": "ct_idu_is_lsiq", "path": "idu/rtl/ct_idu_is_lsiq.v", "desc": "发射队列LSIQ"},
    {"name": "ct_idu_is_sdiq", "path": "idu/rtl/ct_idu_is_sdiq.v", "desc": "发射队列SDIQ"},
    {"name": "ct_idu_is_viq0", "path": "idu/rtl/ct_idu_is_viq0.v", "desc": "发射队列VIQ0"},
    {"name": "ct_idu_is_viq1", "path": "idu/rtl/ct_idu_is_viq1.v", "desc": "发射队列VIQ1"},
    {"name": "ct_idu_id_ctrl", "path": "idu/rtl/ct_idu_id_ctrl.v", "desc": "译码控制"},
    {"name": "ct_idu_id_dp", "path": "idu/rtl/ct_idu_id_dp.v", "desc": "译码数据通路"},
    {"name": "ct_idu_id_decd", "path": "idu/rtl/ct_idu_id_decd.v", "desc": "指令译码"},
    {"name": "ct_idu_ir_ctrl", "path": "idu/rtl/ct_idu_ir_ctrl.v", "desc": "寄存器重命名控制"},
    {"name": "ct_idu_ir_dp", "path": "idu/rtl/ct_idu_ir_dp.v", "desc": "寄存器重命名数据通路"},
    {"name": "ct_idu_rf_ctrl", "path": "idu/rtl/ct_idu_rf_ctrl.v", "desc": "寄存器文件控制"},
    {"name": "ct_idu_rf_dp", "path": "idu/rtl/ct_idu_rf_dp.v", "desc": "寄存器文件数据通路"},
    {"name": "ct_idu_rf_fwd", "path": "idu/rtl/ct_idu_rf_fwd.v", "desc": "前递控制"},
    
    {"name": "ct_iu_alu", "path": "iu/rtl/ct_iu_alu.v", "desc": "算术逻辑单元"},
    {"name": "ct_iu_bju", "path": "iu/rtl/ct_iu_bju.v", "desc": "跳转单元"},
    {"name": "ct_iu_div", "path": "iu/rtl/ct_iu_div.v", "desc": "除法单元"},
    {"name": "ct_iu_mult", "path": "iu/rtl/ct_iu_mult.v", "desc": "乘法单元"},
    {"name": "ct_iu_special", "path": "iu/rtl/ct_iu_special.v", "desc": "特殊操作单元"},
    {"name": "ct_iu_cbus", "path": "iu/rtl/ct_iu_cbus.v", "desc": "C总线接口"},
    {"name": "ct_iu_rbus", "path": "iu/rtl/ct_iu_rbus.v", "desc": "R总线接口"},
    
    {"name": "ct_vfpu_ctrl", "path": "vfpu/rtl/ct_vfpu_ctrl.v", "desc": "VFPU控制"},
    {"name": "ct_vfpu_dp", "path": "vfpu/rtl/ct_vfpu_dp.v", "desc": "VFPU数据通路"},
    {"name": "ct_vfpu_cbus", "path": "vfpu/rtl/ct_vfpu_cbus.v", "desc": "VFPU C总线"},
    {"name": "ct_vfpu_rbus", "path": "vfpu/rtl/ct_vfpu_rbus.v", "desc": "VFPU R总线"},
    
    {"name": "ct_lsu_ctrl", "path": "lsu/rtl/ct_lsu_ctrl.v", "desc": "LSU控制"},
    {"name": "ct_lsu_amr", "path": "lsu/rtl/ct_lsu_amr.v", "desc": "地址映射寄存器"},
    {"name": "ct_lsu_dcache_top", "path": "lsu/rtl/ct_lsu_dcache_top.v", "desc": "数据Cache顶层"},
    {"name": "ct_lsu_dcache_arb", "path": "lsu/rtl/ct_lsu_dcache_arb.v", "desc": "数据Cache仲裁"},
    {"name": "ct_lsu_lfb", "path": "lsu/rtl/ct_lsu_lfb.v", "desc": "填充缓冲"},
    {"name": "ct_lsu_rb", "path": "lsu/rtl/ct_lsu_rb.v", "desc": "读缓冲"},
    {"name": "ct_lsu_wmb", "path": "lsu/rtl/ct_lsu_wmb.v", "desc": "写合并缓冲"},
    {"name": "ct_lsu_vb", "path": "lsu/rtl/ct_lsu_vb.v", "desc": "有效位缓冲"},
    {"name": "ct_lsu_lq", "path": "lsu/rtl/ct_lsu_lq.v", "desc": "加载队列"},
    {"name": "ct_lsu_sq", "path": "lsu/rtl/ct_lsu_sq.v", "desc": "存储队列"},
    {"name": "ct_lsu_pfu", "path": "lsu/rtl/ct_lsu_pfu.v", "desc": "预取单元"},
    {"name": "ct_lsu_ld_ag", "path": "lsu/rtl/ct_lsu_ld_ag.v", "desc": "加载地址生成"},
    {"name": "ct_lsu_ld_dc", "path": "lsu/rtl/ct_lsu_ld_dc.v", "desc": "加载数据Cache"},
    {"name": "ct_lsu_ld_wb", "path": "lsu/rtl/ct_lsu_ld_wb.v", "desc": "加载写回"},
    {"name": "ct_lsu_st_ag", "path": "lsu/rtl/ct_lsu_st_ag.v", "desc": "存储地址生成"},
    {"name": "ct_lsu_st_dc", "path": "lsu/rtl/ct_lsu_st_dc.v", "desc": "存储数据Cache"},
    {"name": "ct_lsu_st_wb", "path": "lsu/rtl/ct_lsu_st_wb.v", "desc": "存储写回"},
    {"name": "ct_lsu_bus_arb", "path": "lsu/rtl/ct_lsu_bus_arb.v", "desc": "总线仲裁"},
    {"name": "ct_lsu_cache_buffer", "path": "lsu/rtl/ct_lsu_cache_buffer.v", "desc": "Cache缓冲"},
    {"name": "ct_lsu_icc", "path": "lsu/rtl/ct_lsu_icc.v", "desc": "ICC控制"},
    {"name": "ct_lsu_lm", "path": "lsu/rtl/ct_lsu_lm.v", "desc": "本地存储"},
    {"name": "ct_lsu_mcic", "path": "lsu/rtl/ct_lsu_mcic.v", "desc": "MCIC控制"},
    
    {"name": "ct_cp0_regs", "path": "cp0/rtl/ct_cp0_regs.v", "desc": "CP0寄存器"},
    {"name": "ct_cp0_iui", "path": "cp0/rtl/ct_cp0_iui.v", "desc": "CP0接口"},
    {"name": "ct_cp0_lpmd", "path": "cp0/rtl/ct_cp0_lpmd.v", "desc": "低功耗管理"},
    
    {"name": "ct_rtu_rob", "path": "rtu/rtl/ct_rtu_rob.v", "desc": "重排序缓冲"},
    {"name": "ct_rtu_retire", "path": "rtu/rtl/ct_rtu_retire.v", "desc": "退休单元"},
    {"name": "ct_rtu_pst_preg", "path": "rtu/rtl/ct_rtu_pst_preg.v", "desc": "物理寄存器状态表"},
    {"name": "ct_rtu_pst_vreg", "path": "rtu/rtl/ct_rtu_pst_vreg.v", "desc": "向量寄存器状态表"},
    {"name": "ct_rtu_pst_ereg", "path": "rtu/rtl/ct_rtu_pst_ereg.v", "desc": "异常寄存器状态表"},
]

@dataclass
class Port:
    name: str
    direction: str
    width: int

class Level3DocGenerator:
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
        for port in input_ports[:30]:
            lines.append(f"| {port.name} | input | {port.width} | |")
        if len(input_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(input_ports)}个端口 |")
        lines.append("")
        
        lines.append("### 2.2 输出端口")
        lines.append("")
        lines.append("| 信号名 | 方向 | 位宽 | 描述 |")
        lines.append("|--------|------|------|------|")
        for port in output_ports[:30]:
            lines.append(f"| {port.name} | output | {port.width} | |")
        if len(output_ports) > 30:
            lines.append(f"| ... | ... | ... | 共{len(output_ports)}个端口 |")
        lines.append("")
        
        lines.append("## 3. 子模块列表")
        lines.append("")
        if instances:
            lines.append("| 模块名 | 实例名 |")
            lines.append("|--------|--------|")
            for inst in instances[:30]:
                lines.append(f"| {inst['module']} | {inst['instance']} |")
            if len(instances) > 30:
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
        
        return True
    
    def run(self):
        os.makedirs(self.output_dir, exist_ok=True)
        
        print(f"Generating Level 3 modules ({len(MODULES_LEVEL_3)} modules)...")
        success_count = 0
        for module in MODULES_LEVEL_3:
            print(f"\nProcessing: {module['name']}")
            if self.generate_docs(module):
                success_count += 1
        
        print(f"\nDone! Generated {success_count}/{len(MODULES_LEVEL_3)} modules")

if __name__ == '__main__':
    base_path = r"d:\code\openc910\C910_RTL_FACTORY\gen_rtl"
    output_dir = r"d:\code\openc910\.trae\documents\level3"
    
    generator = Level3DocGenerator(base_path, output_dir)
    generator.run()
