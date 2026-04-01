#!/usr/bin/env python3
"""
RISC-V向量扩展规范v0.7.1与v1.0详细对比分析脚本
"""

import json
import re
from pathlib import Path
from collections import defaultdict

def load_extracted_data(version):
    """加载提取的JSON数据"""
    json_path = f"d:\\code\\openc910\\doc\\Instruction_Set\\riscv-v-spec-{version}-extracted.json"
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def extract_key_sections(text_content):
    """从文本内容中提取关键章节"""
    sections = {}
    
    # 定义要提取的关键章节
    key_sections = [
        "Implementation-defined Constant Parameters",
        "Vector Extension Programmer's Model",
        "Vector type register",
        "Vector Length Register",
        "Vector Start Index CSR",
        "Vector Fixed-Point",
        "Mapping of Vector Elements",
        "Vector Instruction Formats",
        "Configuration-Setting Instructions",
        "Vector Loads and Stores",
        "Vector Arithmetic",
        "Vector Integer Arithmetic",
        "Vector Floating-Point",
        "Vector Reduction",
        "Vector Mask",
        "Vector Permutation",
        "Exception Handling",
        "Standard Vector Extensions"
    ]
    
    current_section = None
    current_content = []
    
    for page_data in text_content:
        text = page_data['text']
        lines = text.split('\n')
        
        for line in lines:
            # 检查是否是章节标题
            for section_name in key_sections:
                if section_name.lower() in line.lower():
                    if current_section:
                        sections[current_section] = '\n'.join(current_content)
                    current_section = section_name
                    current_content = [line]
                    break
            else:
                if current_section:
                    current_content.append(line)
    
    if current_section:
        sections[current_section] = '\n'.join(current_content)
    
    return sections

def compare_csrs(v1_data, v071_data):
    """对比CSR定义"""
    print("\n" + "="*80)
    print("CSR寄存器对比")
    print("="*80)
    
    # 从表格中提取CSR信息
    v1_tables = v1_data.get('tables', [])
    v071_tables = v071_data.get('tables', [])
    
    print("\nv1.0 CSR表格数量:", len(v1_tables))
    print("v0.7.1 CSR表格数量:", len(v071_tables))
    
    # 查找CSR定义表格
    for i, table in enumerate(v1_tables[:5]):  # 检查前5个表格
        if table['data'] and len(table['data']) > 0:
            first_row = table['data'][0]
            if first_row and any('CSR' in str(cell) or 'Address' in str(cell) for cell in first_row if cell):
                print(f"\nv1.0 表格 {i} (第{table['page']}页):")
                for row in table['data'][:10]:  # 只显示前10行
                    print("  ", row)

def compare_instructions(v1_text, v071_text):
    """对比指令集"""
    print("\n" + "="*80)
    print("指令集对比")
    print("="*80)
    
    # 提取指令列表章节
    v1_instructions = []
    v071_instructions = []
    
    # 查找"Vector Instruction Listing"章节
    for page_data in v1_text:
        if "Vector Instruction Listing" in page_data['text']:
            v1_instructions.append(page_data['text'])
    
    for page_data in v071_text:
        if "Vector Instruction Listing" in page_data['text']:
            v071_instructions.append(page_data['text'])
    
    print(f"\nv1.0 指令列表页数: {len(v1_instructions)}")
    print(f"v0.7.1 指令列表页数: {len(v071_instructions)}")

def analyze_architecture_differences(v1_data, v071_data):
    """分析架构差异"""
    print("\n" + "="*80)
    print("架构定义差异分析")
    print("="*80)
    
    v1_text = v1_data.get('full_text', [])
    v071_text = v071_data.get('full_text', [])
    
    # 提取关键章节
    v1_sections = extract_key_sections(v1_text)
    v071_sections = extract_key_sections(v071_text)
    
    print(f"\nv1.0 提取的关键章节数: {len(v1_sections)}")
    print(f"v0.7.1 提取的关键章节数: {len(v071_sections)}")
    
    # 对比实现参数章节
    if "Implementation-defined Constant Parameters" in v1_sections:
        v1_impl = v1_sections["Implementation-defined Constant Parameters"]
        print("\n--- v1.0 实现参数章节 ---")
        print(v1_impl[:500])
    
    if "Implementation-defined Constant Parameters" in v071_sections:
        v071_impl = v071_sections["Implementation-defined Constant Parameters"]
        print("\n--- v0.7.1 实现参数章节 ---")
        print(v071_impl[:500])

def generate_diff_report():
    """生成差异报告"""
    print("="*80)
    print("RISC-V向量扩展规范 v0.7.1 vs v1.0 详细对比分析")
    print("="*80)
    
    # 加载数据
    v1_data = load_extracted_data("v1.0")
    v071_data = load_extracted_data("v0.7.1")
    
    print(f"\n文档基本信息:")
    print(f"v1.0: {len(v1_data.get('full_text', []))} 页, {len(v1_data.get('tables', []))} 个表格")
    print(f"v0.7.1: {len(v071_data.get('full_text', []))} 页, {len(v071_data.get('tables', []))} 个表格")
    
    # 执行各项对比分析
    compare_csrs(v1_data, v071_data)
    analyze_architecture_differences(v1_data, v071_data)
    compare_instructions(v1_data.get('full_text', []), v071_data.get('full_text', []))
    
    print("\n" + "="*80)
    print("对比分析完成")
    print("="*80)

if __name__ == "__main__":
    generate_diff_report()
