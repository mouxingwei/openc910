#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RISC-V Vector Extension Version Diff Tool
Compare RVV 0.7.1 and 1.0 instruction sets and update 1.0 files with diff info
"""

import json
import os
from collections import defaultdict

V071_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1\rvv_instructions_0.7.1.json"
V10_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0\rvv_instructions.json"
V10_OUTPUT_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-1.0\rvv_instructions.json"

NAME_MAPPING_071_TO_10 = {
    "vlb": "vle8", "vlbu": "vle8",
    "vlh": "vle16", "vlhu": "vle16",
    "vlw": "vle32", "vlwu": "vle32",
    "vld": "vle64",
    "vsb": "vse8", "vsh": "vse16",
    "vsw": "vse32", "vsd": "vse64",
    "vlsb": "vlse8", "vlsbu": "vlse8",
    "vlsh": "vlse16", "vlshu": "vlse16",
    "vlsw": "vlse32", "vlswu": "vlse32",
    "vlsd": "vlse64",
    "vlxb": "vluxei8", "vlxbu": "vluxei8",
    "vlxh": "vluxei16", "vlxhu": "vluxei16",
    "vlxw": "vluxei32", "vlxwu": "vluxei32",
    "vlxd": "vluxei64",
    "vssb": "vsse8", "vssh": "vsse16",
    "vssw": "vsse32", "vssd": "vsse64",
    "vsxb": "vsuxei8", "vsxh": "vsuxei16",
    "vsxw": "vsuxei32", "vsxd": "vsuxei64",
    "vmpopc": "vcpop", "vmfirst": "vfirst",
    "vclipb": "vnclip", "vclipbu": "vnclip",
    "vcliph": "vnclip", "vcliphu": "vnclip",
    "vclipw": "vnclip", "vclipwu": "vnclip",
    "vlob": "vl1re8", "vlobu": "vl1re8",
    "vloh": "vl1re16", "vlohu": "vl1re16",
    "vlow": "vl1re32", "vlowu": "vl1re32",
    "vlod": "vl1re64",
    "vsob": "vs1r", "vsoh": "vs1r",
    "vsow": "vs1r", "vsod": "vs1r",
    "vflh": "vle16", "vflw": "vle32", "vfld": "vle64",
    "vflsh": "vlse16", "vflsw": "vlse32", "vflsd": "vlse64",
    "vflxh": "vluxei16", "vflxw": "vluxei32", "vflxd": "vluxei64",
    "vfloh": "vl1re16", "vflow": "vl1re32", "vflod": "vl1re64",
}

def load_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def build_instruction_index(instructions):
    index = {}
    name_index = defaultdict(list)
    
    for inst in instructions:
        key = (inst['name'], inst.get('funct6', ''), inst.get('funct3', ''))
        index[key] = inst
        name_index[inst['name']].append(inst)
    
    return index, name_index

def find_matching_inst_071(inst_10, v071_name_index):
    name_10 = inst_10['name']
    
    if name_10 in v071_name_index:
        for inst_071 in v071_name_index[name_10]:
            if inst_071.get('funct6') == inst_10.get('funct6') and \
               inst_071.get('funct3') == inst_10.get('funct3'):
                return inst_071
    
    for old_name, new_name in NAME_MAPPING_071_TO_10.items():
        if new_name == name_10 and old_name in v071_name_index:
            for inst_071 in v071_name_index[old_name]:
                return inst_071
    
    return None

def detect_diff(inst_071, inst_10):
    if inst_071 is None:
        return {
            "type": "新增",
            "v071_name": None,
            "details": "1.0版本新增指令"
        }
    
    changes = []
    
    if inst_071['name'] != inst_10['name']:
        changes.append(f"名称: {inst_071['name']} -> {inst_10['name']}")
    
    if inst_071.get('operands', '') != inst_10.get('operands', ''):
        changes.append(f"操作数: {inst_071.get('operands', '')} -> {inst_10.get('operands', '')}")
    
    if inst_071.get('description_cn', '') != inst_10.get('description_cn', ''):
        changes.append(f"描述: {inst_071.get('description_cn', '')} -> {inst_10.get('description_cn', '')}")
    
    if inst_071.get('category_key', '') != inst_10.get('category_key', ''):
        changes.append(f"分类: {inst_071.get('category_key', '')} -> {inst_10.get('category_key', '')}")
    
    if changes:
        return {
            "type": "修改",
            "v071_name": inst_071['name'],
            "details": "; ".join(changes)
        }
    
    return {
        "type": "无变化",
        "v071_name": inst_071['name'],
        "details": ""
    }

def find_removed_instructions(v071_index, v10_index, v10_name_index):
    removed = []
    
    for key, inst_071 in v071_index.items():
        name_071 = inst_071['name']
        name_10 = NAME_MAPPING_071_TO_10.get(name_071, name_071)
        
        found = False
        if name_071 in v10_name_index:
            for inst_10 in v10_name_index[name_071]:
                if inst_10.get('funct6') == inst_071.get('funct6'):
                    found = True
                    break
        
        if not found and name_10 in v10_name_index:
            for inst_10 in v10_name_index[name_10]:
                found = True
                break
        
        if not found:
            removed.append({
                "name": inst_071['name'],
                "category": inst_071.get('category', ''),
                "category_key": inst_071.get('category_key', ''),
                "funct6": inst_071.get('funct6', ''),
                "funct3": inst_071.get('funct3', ''),
                "instruction_type": inst_071.get('instruction_type', ''),
                "operands": inst_071.get('operands', ''),
                "description_cn": inst_071.get('description_cn', ''),
                "description_en": inst_071.get('description_en', ''),
                "diff_info": {
                    "type": "删除",
                    "v10_name": NAME_MAPPING_071_TO_10.get(name_071, None),
                    "details": "1.0版本移除指令"
                }
            })
    
    return removed

def main():
    print("Loading RVV 0.7.1 data...")
    v071_data = load_json(V071_PATH)
    v071_index, v071_name_index = build_instruction_index(v071_data['instructions'])
    
    print("Loading RVV 1.0 data...")
    v10_data = load_json(V10_PATH)
    v10_index, v10_name_index = build_instruction_index(v10_data['instructions'])
    
    print("Analyzing differences...")
    
    updated_instructions = []
    stats = {"新增": 0, "修改": 0, "无变化": 0}
    
    for inst_10 in v10_data['instructions']:
        inst_071 = find_matching_inst_071(inst_10, v071_name_index)
        diff_info = detect_diff(inst_071, inst_10)
        
        updated_inst = inst_10.copy()
        updated_inst['diff_info'] = diff_info
        updated_instructions.append(updated_inst)
        
        stats[diff_info['type']] += 1
    
    removed_instructions = find_removed_instructions(v071_index, v10_index, v10_name_index)
    stats["删除"] = len(removed_instructions)
    
    print(f"Stats: {stats}")
    
    diff_summary = {
        "total_added": stats["新增"],
        "total_removed": stats["删除"],
        "total_modified": stats["修改"],
        "total_unchanged": stats["无变化"],
        "added_categories": ["configuration", "atomic"],
        "removed_categories": ["dot", "clip"],
        "major_changes": [
            "加载/存储指令命名规范化 (vlb->vle8, vsb->vse8等)",
            "新增Fault-Only-First加载指令 (vle8ff等)",
            "新增向量配置指令 (vsetvli, vsetivli, vsetvl)",
            "新增原子操作指令 (vamoswap, vamoadd等)",
            "移除点积指令 (vdotu, vdot, vwsmacc*)",
            "移除截断指令 (vclipb, vcliph, vclipw)",
            "掩码指令重命名 (vmpopc->vcpop, vmfirst->vfirst)"
        ]
    }
    
    v10_data['instructions'] = updated_instructions
    v10_data['removed_instructions'] = removed_instructions
    v10_data['diff_summary'] = diff_summary
    
    print(f"Writing updated JSON to {V10_OUTPUT_PATH}...")
    with open(V10_OUTPUT_PATH, 'w', encoding='utf-8') as f:
        json.dump(v10_data, f, ensure_ascii=False, indent=2)
    
    print("Done!")
    print(f"  新增: {stats['新增']}")
    print(f"  删除: {stats['删除']}")
    print(f"  修改: {stats['修改']}")
    print(f"  无变化: {stats['无变化']}")

if __name__ == "__main__":
    main()
