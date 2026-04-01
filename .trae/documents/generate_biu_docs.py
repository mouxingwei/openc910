#!/usr/bin/env python3
"""
BIU Module Document Generator
生成BIU模块的详细方案文档
"""

import os
import sys
import subprocess

BIU_MODULES = [
    {"name": "ct_biu_top", "path": r"biu\rtl\ct_biu_top.v"},
    {"name": "ct_biu_req_arbiter", "path": r"biu\rtl\ct_biu_req_arbiter.v"},
    {"name": "ct_biu_read_channel", "path": r"biu\rtl\ct_biu_read_channel.v"},
    {"name": "ct_biu_write_channel", "path": r"biu\rtl\ct_biu_write_channel.v"},
    {"name": "ct_biu_snoop_channel", "path": r"biu\rtl\ct_biu_snoop_channel.v"},
    {"name": "ct_biu_lowpower", "path": r"biu\rtl\ct_biu_lowpower.v"},
    {"name": "ct_biu_csr_req_arbiter", "path": r"biu\rtl\ct_biu_csr_req_arbiter.v"},
    {"name": "ct_biu_other_io_sync", "path": r"biu\rtl\ct_biu_other_io_sync.v"},
]

def main():
    base_path = r"d:\code\openc910\C910_RTL_FACTORY\gen_rtl"
    output_dir = r"d:\code\openc910\docs"
    script_path = r"d:\code\openc910\.trae\documents\doc_generator_full.py"
    
    os.makedirs(output_dir, exist_ok=True)
    
    sys.path.insert(0, r'd:\code\openc910\.trae\documents')
    from doc_generator_full import DocGenerator
    
    generator = DocGenerator(output_dir, base_path)
    
    print("=" * 60)
    print("BIU Module Document Generator")
    print("=" * 60)
    print(f"Output directory: {output_dir}")
    print(f"Total modules: {len(BIU_MODULES)}")
    print()
    
    success_count = 0
    for i, mod_info in enumerate(BIU_MODULES, 1):
        print(f"[{i}/{len(BIU_MODULES)}] Processing: {mod_info['name']}")
        
        file_path = os.path.join(base_path, mod_info['path'])
        if not os.path.exists(file_path):
            print(f"    ERROR: File not found: {file_path}")
            continue
        
        result = generator.generate_docs(file_path, level=0)
        if result:
            print(f"    SUCCESS: Generated {result}_top.md")
            success_count += 1
        else:
            print(f"    FAILED: Could not parse module")
    
    print()
    print("=" * 60)
    print(f"Summary: {success_count}/{len(BIU_MODULES)} modules processed successfully")
    print("=" * 60)
    
    print("\nGenerating docx files...")
    js_files = [f for f in os.listdir(output_dir) if f.startswith('gen_') and f.endswith('_docx.js')]
    for js_file in js_files:
        js_path = os.path.join(output_dir, js_file)
        print(f"  Running: {js_file}")
        try:
            subprocess.run(['node', js_path], capture_output=True, cwd=output_dir)
        except Exception as e:
            print(f"    Error: {e}")
    
    print("\nDone!")

if __name__ == '__main__':
    main()
