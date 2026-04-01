#!/usr/bin/env python3
"""
RISC-V向量扩展规范PDF内容提取脚本
用于提取v0.7.1和v1.0版本的关键技术信息
"""

import pdfplumber
import json
import sys
from pathlib import Path

def extract_pdf_content(pdf_path, output_json):
    """
    提取PDF文件的关键内容
    
    Args:
        pdf_path: PDF文件路径
        output_json: 输出JSON文件路径
    """
    print(f"正在处理: {pdf_path}")
    
    content = {
        "metadata": {},
        "toc": [],
        "sections": {},
        "tables": [],
        "key_definitions": {}
    }
    
    try:
        with pdfplumber.open(pdf_path) as pdf:
            # 提取元数据
            if pdf.metadata:
                content["metadata"] = {
                    "title": pdf.metadata.get("title", ""),
                    "author": pdf.metadata.get("author", ""),
                    "subject": pdf.metadata.get("subject", ""),
                    "creator": pdf.metadata.get("creator", ""),
                    "producer": pdf.metadata.get("producer", ""),
                    "creation_date": str(pdf.metadata.get("creation_date", "")),
                    "mod_date": str(pdf.metadata.get("mod_date", ""))
                }
            
            print(f"总页数: {len(pdf.pages)}")
            
            # 提取每一页的内容
            all_text = []
            for i, page in enumerate(pdf.pages):
                print(f"  处理第 {i+1}/{len(pdf.pages)} 页...", end='\r')
                
                # 提取文本
                text = page.extract_text()
                if text:
                    all_text.append({
                        "page": i + 1,
                        "text": text
                    })
                
                # 提取表格
                tables = page.extract_tables()
                if tables:
                    for j, table in enumerate(tables):
                        if table and len(table) > 0:
                            content["tables"].append({
                                "page": i + 1,
                                "table_index": j,
                                "data": table
                            })
            
            print(f"\n已提取 {len(all_text)} 页文本")
            print(f"已提取 {len(content['tables'])} 个表格")
            
            # 保存完整文本
            content["full_text"] = all_text
            
            # 保存到JSON文件
            with open(output_json, 'w', encoding='utf-8') as f:
                json.dump(content, f, ensure_ascii=False, indent=2)
            
            print(f"已保存到: {output_json}")
            
            # 同时保存纯文本版本
            txt_output = output_json.replace('.json', '.txt')
            with open(txt_output, 'w', encoding='utf-8') as f:
                for page_data in all_text:
                    f.write(f"\n{'='*80}\n")
                    f.write(f"第 {page_data['page']} 页\n")
                    f.write(f"{'='*80}\n\n")
                    f.write(page_data['text'])
                    f.write("\n")
            
            print(f"已保存文本到: {txt_output}")
            
            return content
            
    except Exception as e:
        print(f"错误: {str(e)}")
        import traceback
        traceback.print_exc()
        return None

def main():
    # PDF文件路径
    pdf_files = {
        "v1.0": r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0.pdf",
        "v0.7.1": r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1.pdf"
    }
    
    # 提取每个PDF的内容
    for version, pdf_path in pdf_files.items():
        if Path(pdf_path).exists():
            output_json = f"d:\\code\\openc910\\doc\\Instruction_Set\\riscv-v-spec-{version}-extracted.json"
            print(f"\n{'='*80}")
            print(f"处理版本: {version}")
            print(f"{'='*80}")
            extract_pdf_content(pdf_path, output_json)
        else:
            print(f"文件不存在: {pdf_path}")

if __name__ == "__main__":
    main()
