#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
IDU IS阶段模块文档批量生成脚本
为所有IS相关模块生成详细的设计文档
"""

import os
import sys
import json
import subprocess
import re
from pathlib import Path
from datetime import datetime

# IS模块列表（按重要性排序）
IS_MODULES = [
    # 控制和数据通路模块
    ("ct_idu_is_ctrl.v", "IS控制模块", "high"),
    ("ct_idu_is_dp.v", "IS数据通路模块", "high"),
    
    # AIQ模块
    ("ct_idu_is_aiq0.v", "ALU发射队列0", "medium"),
    ("ct_idu_is_aiq0_entry.v", "ALU发射队列0表项", "medium"),
    ("ct_idu_is_aiq1.v", "ALU发射队列1", "medium"),
    ("ct_idu_is_aiq1_entry.v", "ALU发射队列1表项", "medium"),
    
    # BIQ模块
    ("ct_idu_is_biq.v", "分支发射队列", "medium"),
    ("ct_idu_is_biq_entry.v", "分支发射队列表项", "medium"),
    
    # LSIQ模块
    ("ct_idu_is_lsiq.v", "加载存储发射队列", "medium"),
    ("ct_idu_is_lsiq_entry.v", "加载存储发射队列表项", "medium"),
    
    # SDIQ模块
    ("ct_idu_is_sdiq.v", "特殊除法发射队列", "medium"),
    ("ct_idu_is_sdiq_entry.v", "特殊除法发射队列表项", "medium"),
    
    # VIQ模块
    ("ct_idu_is_viq0.v", "向量发射队列0", "medium"),
    ("ct_idu_is_viq0_entry.v", "向量发射队列0表项", "medium"),
    ("ct_idu_is_viq1.v", "向量发射队列1", "medium"),
    ("ct_idu_is_viq1_entry.v", "向量发射队列1表项", "medium"),
    
    # 辅助模块
    ("ct_idu_is_pipe_entry.v", "流水线表项", "low"),
    ("ct_idu_is_aiq_lch_rdy_1.v", "AIQ锁存就绪控制1", "low"),
    ("ct_idu_is_aiq_lch_rdy_2.v", "AIQ锁存就绪控制2", "low"),
    ("ct_idu_is_aiq_lch_rdy_3.v", "AIQ锁存就绪控制3", "low"),
]

def get_module_info(verilog_file):
    """提取Verilog模块的基本信息"""
    module_name = Path(verilog_file).stem
    
    # 读取文件内容
    with open(verilog_file, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # 提取模块名
    import re
    module_match = re.search(r'module\s+(\w+)\s*\(', content)
    if module_match:
        module_name = module_match.group(1)
    
    # 提取端口信息
    ports = []
    port_pattern = r'(input|output|inout)\s+(?:wire\s+)?(?:\[(\d+):(\d+)\]\s+)?(\w+)'
    for match in re.finditer(port_pattern, content):
        direction = match.group(1)
        msb = match.group(2)
        lsb = match.group(3)
        name = match.group(4)
        width = int(msb) - int(lsb) + 1 if msb and lsb else 1
        ports.append({
            'name': name,
            'direction': direction,
            'width': width
        })
    
    return {
        'module_name': module_name,
        'ports': ports,
        'file_path': verilog_file
    }

def generate_markdown_doc(module_info, description, output_dir):
    """生成Markdown格式的文档"""
    module_name = module_info['module_name']
    ports = module_info['ports']
    
    md_content = f"""# {module_name} 模块设计文档

## 1. 模块概述

### 1.1 基本信息

| 属性 | 值 |
|------|-----|
| 模块名称 | {module_name} |
| 文件路径 | {module_info['file_path']} |
| 功能描述 | {description} |
| 生成日期 | {datetime.now().strftime('%Y-%m-%d')} |

### 1.2 功能描述

{description}

### 1.3 设计特点

- 支持多发射队列管理
- 高效的指令调度机制
- 低功耗设计

## 2. 模块接口说明

### 2.1 输入端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
"""
    
    # 添加输入端口
    for port in ports:
        if port['direction'] == 'input':
            md_content += f"| {port['name']} | {port['direction']} | {port['width']} | - |\n"
    
    md_content += """
### 2.2 输出端口

| 信号名 | 方向 | 位宽 | 描述 |
|--------|------|------|------|
"""
    
    # 添加输出端口
    for port in ports:
        if port['direction'] == 'output':
            md_content += f"| {port['name']} | {port['direction']} | {port['width']} | - |\n"
    
    md_content += """
## 3. 模块框图

```mermaid
graph TD
    A[输入接口] --> B[{module_name}]
    B --> C[输出接口]
    B --> D[内部逻辑]
```

## 4. 模块实现方案

### 4.1 流水线设计

该模块属于IDU IS阶段，负责指令发射控制。

### 4.2 关键逻辑描述

- 指令队列管理
- 发射仲裁逻辑
- 相关性检查

## 5. 内部关键信号列表

### 5.1 寄存器信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| - | - | - |

### 5.2 线网信号

| 信号名 | 位宽 | 描述 |
|--------|------|------|
| - | - | - |

## 6. 修订历史

| 版本 | 日期 | 作者 | 说明 |
|------|------|------|------|
| 1.0 | {datetime.now().strftime('%Y-%m-%d')} | Auto-generated | 初始版本 |
""".format(module_name=module_name)
    
    # 写入文件
    output_file = Path(output_dir) / f"{module_name}.md"
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    return str(output_file)

def main():
    """主函数"""
    # 设置路径
    rtl_dir = Path("d:/code/openc910/C910_RTL_FACTORY/gen_rtl/idu/rtl")
    doc_dir = Path("d:/code/openc910/doc/design_docs/idu")
    
    # 确保输出目录存在
    doc_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 60)
    print("IDU IS阶段模块文档批量生成")
    print("=" * 60)
    
    success_count = 0
    failed_count = 0
    
    for verilog_file, description, priority in IS_MODULES:
        file_path = rtl_dir / verilog_file
        
        if not file_path.exists():
            print(f"⚠️  文件不存在: {verilog_file}")
            failed_count += 1
            continue
        
        try:
            print(f"\n📝 处理: {verilog_file} ({description})")
            
            # 提取模块信息
            module_info = get_module_info(str(file_path))
            
            # 生成Markdown文档
            md_file = generate_markdown_doc(module_info, description, str(doc_dir))
            
            print(f"✅ 生成文档: {md_file}")
            success_count += 1
            
        except Exception as e:
            print(f"❌ 处理失败: {verilog_file}, 错误: {str(e)}")
            failed_count += 1
    
    print("\n" + "=" * 60)
    print(f"文档生成完成！")
    print(f"成功: {success_count} 个")
    print(f"失败: {failed_count} 个")
    print("=" * 60)

if __name__ == "__main__":
    main()
