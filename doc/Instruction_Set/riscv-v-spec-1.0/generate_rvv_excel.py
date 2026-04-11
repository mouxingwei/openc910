#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RISC-V Vector Extension (RVV1.0) Excel Generator
Generate Excel file from RVV instruction JSON
"""

import json
import os
import sys

# Install required packages
os.system("pip install pandas openpyxl -q")

import pandas as pd

BASE_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master"
JSON_PATH = os.path.join(BASE_PATH, "rvv_instructions.json")

def load_json_data():
    """Load JSON data"""
    with open(JSON_PATH, 'r', encoding='utf-8') as f:
        return json.load(f)

def create_instruction_dataframe(data):
    """Create pandas DataFrame for instructions"""
    instructions = data['instructions']

    df_data = []
    for inst in instructions:
        df_data.append({
            '指令名': inst['name'],
            '分类键': inst['category_key'],
            '指令类型': inst['instruction_type'],
            '分类': inst['category'],
            'funct3': inst['funct3'],
            'funct6/Imm': inst['funct6'],
            '操作数': inst['operands'],
            '中文描述': inst['description_cn'],
            '英文描述': inst['description_en'],
            '掩码支持': inst['vm_support'],
            '编码格式': inst['encoding']['format'],
            '操作码': inst['encoding']['opcode'],
            '格式类型': inst['format']
        })

    return pd.DataFrame(df_data)

def create_category_summary(data):
    """Create category summary DataFrame"""
    categories = data['categories']

    summary_data = []
    for cat_key, cat_info in categories.items():
        summary_data.append({
            '分类键': cat_key,
            '分类名称': cat_info['name'],
            '指令数量': cat_info['count']
        })

    return pd.DataFrame(summary_data)

def create_encoding_reference(data):
    """Create encoding reference DataFrame"""
    instructions = data['instructions']

    enc_data = []
    for inst in instructions:
        enc_data.append({
            '指令名': inst['name'],
            'funct3': inst['funct3'],
            'funct6': inst['funct6'],
            '类型': inst['instruction_type'],
            '格式': inst['format'],
            '操作数': inst['operands']
        })

    return pd.DataFrame(enc_data)

def generate_excel(data):
    """Generate Excel file with multiple sheets"""
    # Create DataFrames
    df_instructions = create_instruction_dataframe(data)
    df_summary = create_category_summary(data)
    df_encoding = create_encoding_reference(data)

    # Sort by instruction name
    df_instructions = df_instructions.sort_values('指令名')
    df_encoding = df_encoding.sort_values('指令名')

    # Write to Excel with multiple sheets
    excel_path = os.path.join(BASE_PATH, "rvv_instructions.xlsx")

    with pd.ExcelWriter(excel_path, engine='openpyxl') as writer:
        df_summary.to_excel(writer, sheet_name='分类总览', index=False)
        df_instructions.to_excel(writer, sheet_name='指令总表', index=False)
        df_encoding.to_excel(writer, sheet_name='编码参考', index=False)

        # Add category detail sheets
        categories = data['categories']
        for cat_key, cat_info in categories.items():
            cat_df = df_instructions[df_instructions.get('分类键') == cat_key] if '分类键' in df_instructions.columns else df_instructions[df_instructions['category_key'] == cat_key]
            if len(cat_df) > 0:
                sheet_name = cat_key[:31]  # Excel sheet name limit
                cat_df.to_excel(writer, sheet_name=sheet_name, index=False)

    print(f"Excel file generated: {excel_path}")
    return excel_path

def main():
    print("Generating RISC-V V Vector Extension Excel file...")

    # Load JSON data
    data = load_json_data()

    # Generate Excel
    excel_path = generate_excel(data)

    print(f"Excel file created: {excel_path}")
    print(f"Total instructions: {data['metadata']['total_instructions']}")
    print(f"Categories: {data['metadata']['categories_count']}")

if __name__ == "__main__":
    main()
