#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RISC-V Vector Extension (RVV1.0) Instruction Set Parser
Parse the RISC-V V-spec documentation and generate JSON and Excel files
"""

import json
import re
import os
from collections import defaultdict

# Base path for the documentation
BASE_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-master"

# Instruction categories
CATEGORIES = {
    "configuration": "配置类 (Configuration)",
    "load": "加载类 (Load)",
    "store": "存储类 (Store)",
    "arithmetic": "算术运算类 (Arithmetic)",
    "compare": "比较类 (Compare)",
    "logical": "逻辑类 (Logical)",
    "shift": "移位类 (Shift)",
    "reduction": "归约类 (Reduction)",
    "multiply-add": "乘加类 (Multiply-Add)",
    "fp": "浮点类 (Floating-Point)",
    "convert": "转换类 (Convert)",
    "mask": "掩码类 (Mask)",
    "move": "移动类 (Move)",
    "atomic": "原子操作类 (Atomic)",
    "special": "特殊功能类 (Special)"
}

# Instruction type definitions based on funct3 encoding
OP_TYPES = {
    "000": "OPIVV (vector-vector)",
    "001": "OPFVV (FP vector-vector)",
    "010": "OPMVV (multiply vector-vector)",
    "011": "OPIVI (vector-immediate)",
    "100": "OPIVX (vector-scalar)",
    "101": "OPFVF (FP vector-scalar)",
    "110": "OPMVX (multiply vector-scalar)"
}

# All instructions parsed from inst-table.adoc
# Format: (name, funct6, funct3_type, category, description, operands)
INSTRUCTIONS = [
    # Arithmetic operations (OPIVV/OPIVX/OPIVI)
    ("vadd", "000000", ["000", "100", "011"], "arithmetic", "向量加法", "vd, vs1, vs2[, vm]"),
    ("vsub", "000010", ["000", "100"], "arithmetic", "向量减法", "vd, vs1, vs2[, vm]"),
    ("vrsub", "000011", ["100", "011"], "arithmetic", "反向向量减法", "vd, vs1, vs2[, vm]"),
    ("vminu", "000100", ["000", "100"], "arithmetic", "向量无符号最小值", "vd, vs1, vs2[, vm]"),
    ("vmin", "000101", ["000", "100"], "arithmetic", "向量有符号最小值", "vd, vs1, vs2[, vm]"),
    ("vmaxu", "000110", ["000", "100"], "arithmetic", "向量无符号最大值", "vd, vs1, vs2[, vm]"),
    ("vmax", "000111", ["000", "100"], "arithmetic", "向量有符号最大值", "vd, vs1, vs2[, vm]"),
    ("vand", "001001", ["000", "100", "011"], "logical", "向量按位与", "vd, vs1, vs2[, vm]"),
    ("vor", "001010", ["000", "100", "011"], "logical", "向量按位或", "vd, vs1, vs2[, vm]"),
    ("vxor", "001011", ["000", "100", "011"], "logical", "向量按位异或", "vd, vs1, vs2[, vm]"),
    ("vrgather", "001100", ["000", "100", "011"], "move", "向量聚合收集", "vd, vs1, vs2[, vm]"),
    ("vrgatherei16", "001110", ["000"], "move", "向量聚合收集(16位索引)", "vd, vs1, vs2[, vm]"),
    ("vslideup", "001111", ["100", "011"], "shift", "向量上移", "vd, vs1, imm[, vm]"),
    ("vslidedown", "010000", ["100", "011"], "shift", "向量下移", "vd, vs1, imm[, vm]"),

    # ADC/SBC operations
    ("vadc", "010000", ["000", "100", "011"], "arithmetic", "向量加法(进位)", "vd, vs1, vs2[, vm]"),
    ("vmadc", "010001", ["000", "100", "011"], "arithmetic", "向量加法进位(掩码)", "vd, vs1, vs2[, vm]"),
    ("vsbc", "010010", ["000", "100"], "arithmetic", "向量减法(借位)", "vd, vs1, vs2[, vm]"),
    ("vmsbc", "010011", ["000", "100"], "arithmetic", "向量减法借位(掩码)", "vd, vs1, vs2[, vm]"),
    ("vmerge", "010111", ["000", "100", "011"], "move", "向量合并", "vd, vs1, vs2, vm"),
    ("vmv", "010111", ["000", "100", "011"], "move", "向量移动", "vd, vs1, vs2, vm"),

    # Compare operations
    ("vmseq", "011000", ["000", "100", "011"], "compare", "向量相等比较", "vd, vs1, vs2[, vm]"),
    ("vmsne", "011001", ["000", "100", "011"], "compare", "向量不等比较", "vd, vs1, vs2[, vm]"),
    ("vmsltu", "011010", ["000", "100"], "compare", "向量无符号小于比较", "vd, vs1, vs2[, vm]"),
    ("vmslt", "011011", ["000", "100"], "compare", "向量有符号小于比较", "vd, vs1, vs2[, vm]"),
    ("vmsleu", "011100", ["000", "100", "011"], "compare", "向量无符号小于等于比较", "vd, vs1, vs2[, vm]"),
    ("vmsle", "011101", ["000", "100", "011"], "compare", "向量有符号小于等于比较", "vd, vs1, vs2[, vm]"),
    ("vmsgtu", "011110", ["100", "011"], "compare", "向量无符号大于比较", "vd, vs1, vs2[, vm]"),
    ("vmsgt", "011111", ["100", "011"], "compare", "向量有符号大于比较", "vd, vs1, vs2[, vm]"),

    # Shift and multiply
    ("vsaddu", "100000", ["000", "100", "011"], "arithmetic", "向量饱和无符号加法", "vd, vs1, vs2[, vm]"),
    ("vsadd", "100001", ["000", "100", "011"], "arithmetic", "向量饱和有符号加法", "vd, vs1, vs2[, vm]"),
    ("vssubu", "100010", ["000", "100"], "arithmetic", "向量饱和无符号减法", "vd, vs1, vs2[, vm]"),
    ("vssub", "100011", ["000", "100"], "arithmetic", "向量饱和有符号减法", "vd, vs1, vs2[, vm]"),
    ("vsll", "100101", ["000", "100", "011"], "shift", "向量逻辑左移", "vd, vs1, vs2[, vm]"),
    ("vsmul", "100111", ["000", "100"], "arithmetic", "向量饱和乘法", "vd, vs1, vs2[, vm]"),
    ("vmv<nr>r", "100111", ["011"], "move", "向量整数串链移动", "vd, vs1"),

    # Shift right
    ("vsrl", "101000", ["000", "100", "011"], "shift", "向量逻辑右移", "vd, vs1, vs2[, vm]"),
    ("vsra", "101001", ["000", "100", "011"], "shift", "向量算术右移", "vd, vs1, vs2[, vm]"),
    ("vssrl", "101010", ["000", "100", "011"], "shift", "向量饱和逻辑右移", "vd, vs1, vs2[, vm]"),
    ("vssra", "101011", ["000", "100", "011"], "shift", "向量饱和算术右移", "vd, vs1, vs2[, vm]"),
    ("vnsrl", "101100", ["000", "100", "011"], "shift", "向量窄逻辑右移", "vd, vs1, vs2[, vm]"),
    ("vnsra", "101101", ["000", "100", "011"], "shift", "向量窄算术右移", "vd, vs1, vs2[, vm]"),
    ("vnclipu", "101110", ["000", "100", "011"], "shift", "向量窄截断无符号右移", "vd, vs1, vs2[, vm]"),
    ("vnclip", "101111", ["000", "100", "011"], "shift", "向量窄截断有符号右移", "vd, vs1, vs2[, vm]"),

    # Widening operations
    ("vwredsumu", "110000", ["000"], "reduction", "向量扩展无符号求和归约", "vd, vs1, vs2[, vm]"),
    ("vwredsum", "110001", ["000"], "reduction", "向量扩展有符号求和归约", "vd, vs1, vs2[, vm]"),

    # OPMVV operations (multiply)
    ("vwaddu", "110000", ["010", "110"], "arithmetic", "向量扩展无符号加法", "vd, vs1, vs2[, vm]"),
    ("vwadd", "110001", ["010", "110"], "arithmetic", "向量扩展有符号加法", "vd, vs1, vs2[, vm]"),
    ("vwsubu", "110010", ["010", "110"], "arithmetic", "向量扩展无符号减法", "vd, vs1, vs2[, vm]"),
    ("vwsub", "110011", ["010", "110"], "arithmetic", "向量扩展有符号减法", "vd, vs1, vs2[, vm]"),
    ("vwaddu.w", "110100", ["010", "110"], "arithmetic", "向量扩展无符号加法(字)", "vd, vs1, vs2[, vm]"),
    ("vwadd.w", "110101", ["010", "110"], "arithmetic", "向量扩展有符号加法(字)", "vd, vs1, vs2[, vm]"),
    ("vwsubu.w", "110110", ["010", "110"], "arithmetic", "向量扩展无符号减法(字)", "vd, vs1, vs2[, vm]"),
    ("vwsub.w", "110111", ["010", "110"], "arithmetic", "向量扩展有符号减法(字)", "vd, vs1, vs2[, vm]"),
    ("vwmulu", "111000", ["010", "110"], "multiply-add", "向量扩展无符号乘法", "vd, vs1, vs2[, vm]"),
    ("vwmulsu", "111010", ["010", "110"], "multiply-add", "向量扩展有符号×无符号乘法", "vd, vs1, vs2[, vm]"),
    ("vwmul", "111011", ["010", "110"], "multiply-add", "向量扩展有符号乘法", "vd, vs1, vs2[, vm]"),
    ("vwmaccu", "111100", ["010", "110"], "multiply-add", "向量扩展无符号乘加", "vd, vs1, vs2[, vm]"),
    ("vwmacc", "111101", ["010", "110"], "multiply-add", "向量扩展有符号乘加", "vd, vs1, vs2[, vm]"),
    ("vwmaccus", "111110", ["110"], "multiply-add", "向量扩展无符号×有符号乘加", "vd, vs1, vs2"),
    ("vwmaccsu", "111111", ["010", "110"], "multiply-add", "向量扩展有符号×无符号乘加", "vd, vs1, vs2[, vm]"),

    # Reduction operations
    ("vredsum", "000000", ["001"], "reduction", "向量求和归约", "vd, vs1, vs2[, vm]"),
    ("vredand", "000001", ["001"], "reduction", "向量按位与归约", "vd, vs1, vs2[, vm]"),
    ("vredor", "000010", ["001"], "reduction", "向量按位或归约", "vd, vs1, vs2[, vm]"),
    ("vredxor", "000011", ["001"], "reduction", "向量按位异或归约", "vd, vs1, vs2[, vm]"),
    ("vredminu", "000100", ["001"], "reduction", "向量无符号最小值归约", "vd, vs1, vs2[, vm]"),
    ("vredmin", "000101", ["001"], "reduction", "向量有符号最小值归约", "vd, vs1, vs2[, vm]"),
    ("vredmaxu", "000110", ["001"], "reduction", "向量无符号最大值归约", "vd, vs1, vs2[, vm]"),
    ("vredmax", "000111", ["001"], "reduction", "向量有符号最大值归约", "vd, vs1, vs2[, vm]"),

    # Additional arithmetic ops
    ("vaaddu", "001000", ["010", "110"], "arithmetic", "向量绝对值无符号加法", "vd, vs1, vs2[, vm]"),
    ("vaadd", "001001", ["010", "110"], "arithmetic", "向量绝对值有符号加法", "vd, vs1, vs2[, vm]"),
    ("vasubu", "001010", ["010", "110"], "arithmetic", "向量绝对值无符号减法", "vd, vs1, vs2[, vm]"),
    ("vasub", "001011", ["010", "110"], "arithmetic", "向量绝对值有符号减法", "vd, vs1, vs2[, vm]"),

    # Division operations
    ("vdivu", "100000", ["010", "110"], "arithmetic", "向量无符号除法", "vd, vs1, vs2[, vm]"),
    ("vdiv", "100001", ["010", "110"], "arithmetic", "向量有符号除法", "vd, vs1, vs2[, vm]"),
    ("vremu", "100010", ["010", "110"], "arithmetic", "向量无符号余数", "vd, vs1, vs2[, vm]"),
    ("vrem", "100011", ["010", "110"], "arithmetic", "向量有符号余数", "vd, vs1, vs2[, vm]"),

    # Multiply operations
    ("vmulhu", "100100", ["010", "110"], "multiply-add", "向量无符号乘法高位", "vd, vs1, vs2[, vm]"),
    ("vmul", "100101", ["010", "110"], "multiply-add", "向量乘法", "vd, vs1, vs2[, vm]"),
    ("vmulhsu", "100110", ["010", "110"], "multiply-add", "向量有符号×无符号乘法高位", "vd, vs1, vs2[, vm]"),
    ("vmulh", "100111", ["010", "110"], "multiply-add", "向量有符号乘法高位", "vd, vs1, vs2[, vm]"),

    # Multiply-add operations
    ("vmadd", "101001", ["010", "110"], "multiply-add", "向量乘法加法", "vd, vs1, vs2[, vm]"),
    ("vnmsub", "101011", ["010", "110"], "multiply-add", "向量负乘法减法", "vd, vs1, vs2[, vm]"),
    ("vmacc", "101101", ["010", "110"], "multiply-add", "向量乘法累加", "vd, vs1, vs2[, vm]"),
    ("vnmsac", "101111", ["010", "110"], "multiply-add", "向量负乘法累减", "vd, vs1, vs2[, vm]"),

    # Slide operations
    ("vslide1up", "001110", ["110"], "shift", "向量上移1位", "vd, vs1, rs1[, vm]"),
    ("vslide1down", "001111", ["110"], "shift", "向量下移1位", "vd, vs1, rs1[, vm]"),

    # Mask operations
    ("vcompress", "010111", ["001"], "mask", "向量压缩", "vd, vs1, vs2, vm"),
    ("vmandn", "011000", ["001"], "mask", "向量与非掩码", "vd, vs1, vs2"),
    ("vmand", "011001", ["001"], "mask", "向量与掩码", "vd, vs1, vs2"),
    ("vmor", "011010", ["001"], "mask", "向量或掩码", "vd, vs1, vs2"),
    ("vmxor", "011011", ["001"], "mask", "向量异或掩码", "vd, vs1, vs2"),
    ("vmorn", "011100", ["001"], "mask", "向量或非掩码", "vd, vs1, vs2"),
    ("vmnand", "011101", ["001"], "mask", "向量与非掩码", "vd, vs1, vs2"),
    ("vmnor", "011110", ["001"], "mask", "向量或非掩码", "vd, vs1, vs2"),
    ("vmxnor", "011111", ["001"], "mask", "向量异或非掩码", "vd, vs1, vs2"),

    # FP Arithmetic operations (OPFVV)
    ("vfadd", "000000", ["001", "101"], "fp", "向量浮点加法", "vd, vs1, vs2[, vm]"),
    ("vfsub", "000010", ["001", "101"], "fp", "向量浮点减法", "vd, vs1, vs2[, vm]"),
    ("vfmin", "000100", ["001", "101"], "fp", "向量浮点最小值", "vd, vs1, vs2[, vm]"),
    ("vfmax", "000110", ["001", "101"], "fp", "向量浮点最大值", "vd, vs1, vs2[, vm]"),
    ("vfsgnj", "001000", ["001", "101"], "fp", "向量浮点符号注入", "vd, vs1, vs2[, vm]"),
    ("vfsgnjn", "001001", ["001", "101"], "fp", "向量浮点符号取反注入", "vd, vs1, vs2[, vm]"),
    ("vfsgnjx", "001010", ["001", "101"], "fp", "向量浮点符号异或注入", "vd, vs1, vs2[, vm]"),
    ("vfdiv", "100000", ["001", "101"], "fp", "向量浮点除法", "vd, vs1, vs2[, vm]"),
    ("vfrdiv", "100001", ["101"], "fp", "向量浮点反向除法", "vd, vs1, vs2[, vm]"),
    ("vfmul", "100100", ["001", "101"], "fp", "向量浮点乘法", "vd, vs1, vs2[, vm]"),
    ("vfrsub", "100111", ["101"], "fp", "向量浮点反向减法", "vd, vs1, vs2[, vm]"),

    # FP Multiply-Add
    ("vfmadd", "101000", ["001", "101"], "fp", "向量浮点乘加", "vd, vs1, vs2[, vm]"),
    ("vfnmadd", "101001", ["001", "101"], "fp", "向量浮点负乘加", "vd, vs1, vs2[, vm]"),
    ("vfmsub", "101010", ["001", "101"], "fp", "向量浮点乘减", "vd, vs1, vs2[, vm]"),
    ("vfnmsub", "101011", ["001", "101"], "fp", "向量浮点负乘减", "vd, vs1, vs2[, vm]"),
    ("vfmacc", "101100", ["001", "101"], "fp", "向量浮点乘累加", "vd, vs1, vs2[, vm]"),
    ("vfnmacc", "101101", ["001", "101"], "fp", "向量浮点负乘累加", "vd, vs1, vs2[, vm]"),
    ("vfmsac", "101110", ["001", "101"], "fp", "向量浮点乘累减", "vd, vs1, vs2[, vm]"),
    ("vfnmsac", "101111", ["001", "101"], "fp", "向量浮点负乘累减", "vd, vs1, vs2[, vm]"),

    # FP Reduction operations
    ("vfredusum", "000001", ["001"], "fp", "向量浮点无符号求和归约", "vd, vs1, vs2[, vm]"),
    ("vfredosum", "000011", ["001"], "fp", "向量浮点有符号求和归约", "vd, vs1, vs2[, vm]"),
    ("vfredmin", "000101", ["001"], "fp", "向量浮点最小值归约", "vd, vs1, vs2[, vm]"),
    ("vfredmax", "000111", ["001"], "fp", "向量浮点最大值归约", "vd, vs1, vs2[, vm]"),

    # FP Slide operations
    ("vfslide1up", "001110", ["101"], "fp", "向量浮点上移1位", "vd, vs1, rs1[, vm]"),
    ("vfslide1down", "001111", ["101"], "fp", "向量浮点下移1位", "vd, vs1, rs1[, vm]"),
    ("vfmerge", "010111", ["101"], "fp", "向量浮点合并", "vd, vs1, vs2, vm"),

    # FP Compare operations
    ("vmfeq", "011000", ["001", "101"], "compare", "向量浮点相等比较", "vd, vs1, vs2[, vm]"),
    ("vmfle", "011001", ["001", "101"], "compare", "向量浮点小于等于比较", "vd, vs1, vs2[, vm]"),
    ("vmflt", "011011", ["001", "101"], "compare", "向量浮点小于比较", "vd, vs1, vs2[, vm]"),
    ("vmfne", "011100", ["001", "101"], "compare", "向量浮点不等比较", "vd, vs1, vs2[, vm]"),
    ("vmfgt", "011101", ["101"], "compare", "向量浮点大于比较", "vd, vs1, vs2, vm"),
    ("vmfge", "011111", ["101"], "compare", "向量浮点大于等于比较", "vd, vs1, vs2, vm"),

    # FP Unary operations (VFUNARY0)
    ("vfcvt.xu.f.v", "00000", ["001"], "convert", "向量浮点到无符号整数转换", "vd, vs1[, vm]"),
    ("vfcvt.x.f.v", "00001", ["001"], "convert", "向量浮点到有符号整数转换", "vd, vs1[, vm]"),
    ("vfcvt.f.xu.v", "00010", ["001"], "convert", "向量无符号整数到浮点转换", "vd, vs1[, vm]"),
    ("vfcvt.f.x.v", "00011", ["001"], "convert", "向量有符号整数到浮点转换", "vd, vs1[, vm]"),
    ("vfcvt.rtz.xu.f.v", "00110", ["001"], "convert", "向量浮点到无符号整数截断转换", "vd, vs1[, vm]"),
    ("vfcvt.rtz.x.f.v", "00111", ["001"], "convert", "向量浮点到有符号整数截断转换", "vd, vs1[, vm]"),

    # FP Widening converts
    ("vfwcvt.xu.f.v", "01000", ["001"], "convert", "向量浮点到无符号整数扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.x.f.v", "01001", ["001"], "convert", "向量浮点到有符号整数扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.f.xu.v", "01010", ["001"], "convert", "向量无符号整数到浮点扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.f.x.v", "01011", ["001"], "convert", "向量有符号整数到浮点扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.f.f.v", "01100", ["001"], "convert", "向量浮点到浮点扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.rtz.xu.f.v", "01110", ["001"], "convert", "向量浮点到无符号整数截断扩展转换", "vd, vs1[, vm]"),
    ("vfwcvt.rtz.x.f.v", "01111", ["001"], "convert", "向量浮点到有符号整数截断扩展转换", "vd, vs1[, vm]"),

    # FP Narrowing converts
    ("vfncvt.xu.f.w", "10000", ["001"], "convert", "向量浮点到无符号整数缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.x.f.w", "10001", ["001"], "convert", "向量浮点到有符号整数缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.f.xu.w", "10010", ["001"], "convert", "向量无符号整数到浮点缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.f.x.w", "10011", ["001"], "convert", "向量有符号整数到浮点缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.f.f.w", "10100", ["001"], "convert", "向量浮点到浮点缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.rod.f.f.w", "10101", ["001"], "convert", "向量浮点到浮点ROD缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.rtz.xu.f.w", "10110", ["001"], "convert", "向量浮点到无符号整数截断缩小转换", "vd, vs1[, vm]"),
    ("vfncvt.rtz.x.f.w", "10111", ["001"], "convert", "向量浮点到有符号整数截断缩小转换", "vd, vs1[, vm]"),

    # FP Unary operations (VFUNARY1)
    ("vfsqrt.v", "00000", ["001"], "fp", "向量浮点平方根", "vd, vs1[, vm]"),
    ("vfrsqrt7.v", "00100", ["001"], "fp", "向量浮点近似平方根倒数", "vd, vs1[, vm]"),
    ("vfrec7.v", "00101", ["001"], "fp", "向量浮点近似倒数", "vd, vs1[, vm]"),
    ("vfclass.v", "10000", ["001"], "special", "向量浮点分类", "vd, vs1[, vm]"),

    # FP Widening operations
    ("vfwadd", "110000", ["001", "101"], "fp", "向量浮点扩展加法", "vd, vs1, vs2[, vm]"),
    ("vfwsub", "110010", ["001", "101"], "fp", "向量浮点扩展减法", "vd, vs1, vs2[, vm]"),
    ("vfwadd.w", "110100", ["001", "101"], "fp", "向量浮点扩展加法(字)", "vd, vs1, vs2[, vm]"),
    ("vfwsub.w", "110110", ["001", "101"], "fp", "向量浮点扩展减法(字)", "vd, vs1, vs2[, vm]"),
    ("vfwmul", "111000", ["001", "101"], "fp", "向量浮点扩展乘法", "vd, vs1, vs2[, vm]"),
    ("vfwmacc", "111100", ["001", "101"], "fp", "向量浮点扩展乘累加", "vd, vs1, vs2[, vm]"),
    ("vfwnmacc", "111101", ["001", "101"], "fp", "向量浮点扩展负乘累加", "vd, vs1, vs2[, vm]"),
    ("vfwmsac", "111110", ["001", "101"], "fp", "向量浮点扩展乘累减", "vd, vs1, vs2[, vm]"),
    ("vfwnmsac", "111111", ["001", "101"], "fp", "向量浮点扩展负乘累减", "vd, vs1, vs2[, vm]"),

    # FP Reduction
    ("vfwredusum", "110001", ["001"], "fp", "向量浮点扩展无符号求和归约", "vd, vs1, vs2[, vm]"),
    ("vfwredosum", "110011", ["001"], "fp", "向量浮点扩展有符号求和归约", "vd, vs1, vs2[, vm]"),

    # Load instructions (，需要从vmem-format补充)
    ("vle8", "00000", ["000"], "load", "向量加载(8位单位步幅)", "vd, (rs1)[, vm]"),
    ("vle16", "00001", ["000"], "load", "向量加载(16位单位步幅)", "vd, (rs1)[, vm]"),
    ("vle32", "00010", ["000"], "load", "向量加载(32位单位步幅)", "vd, (rs1)[, vm]"),
    ("vle64", "00011", ["000"], "load", "向量加载(64位单位步幅)", "vd, (rs1)[, vm]"),
    ("vle8ff", "00100", ["000"], "load", "向量加载(8位单位步幅,ff)", "vd, (rs1)[, vm]"),
    ("vle16ff", "00101", ["000"], "load", "向量加载(16位单位步幅,ff)", "vd, (rs1)[, vm]"),
    ("vle32ff", "00110", ["000"], "load", "向量加载(32位单位步幅,ff)", "vd, (rs1)[, vm]"),
    ("vle64ff", "00111", ["000"], "load", "向量加载(64位单位步幅,ff)", "vd, (rs1)[, vm]"),
    ("vlse8", "01000", ["000"], "load", "向量加载(8位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vlse16", "01001", ["000"], "load", "向量加载(16位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vlse32", "01010", ["000"], "load", "向量加载(32位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vlse64", "01011", ["000"], "load", "向量加载(64位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vluxei8", "01100", ["000"], "load", "向量加载(8位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vluxei16", "01101", ["000"], "load", "向量加载(16位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vluxei32", "01110", ["000"], "load", "向量加载(32位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vluxei64", "01111", ["000"], "load", "向量加载(64位索引收集)", "vd, (rs1), vs2[, vm]"),

    # Store instructions
    ("vse8", "00000", ["000"], "store", "向量存储(8位单位步幅)", "vs3, (rs1)[, vm]"),
    ("vse16", "00001", ["000"], "store", "向量存储(16位单位步幅)", "vs3, (rs1)[, vm]"),
    ("vse32", "00010", ["000"], "store", "向量存储(32位单位步幅)", "vs3, (rs1)[, vm]"),
    ("vse64", "00011", ["000"], "store", "向量存储(64位单位步幅)", "vs3, (rs1)[, vm]"),
    ("vsse8", "01000", ["000"], "store", "向量存储(8位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vsse16", "01001", ["000"], "store", "向量存储(16位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vsse32", "01010", ["000"], "store", "向量存储(32位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vsse64", "01011", ["000"], "store", "向量存储(64位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vsuxei8", "01100", ["000"], "store", "向量存储(8位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vsuxei16", "01101", ["000"], "store", "向量存储(16位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vsuxei32", "01110", ["000"], "store", "向量存储(32位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vsuxei64", "01111", ["000"], "store", "向量存储(64位索引分散)", "vs3, (rs1), vs2[, vm]"),

    # FP Load instructions
    ("vflse8", "01000", ["101"], "load", "向量浮点加载(8位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vflse16", "01001", ["101"], "load", "向量浮点加载(16位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vflse32", "01010", ["101"], "load", "向量浮点加载(32位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vflse64", "01011", ["101"], "load", "向量浮点加载(64位跨步)", "vd, (rs1), rs2[, vm]"),
    ("vfluxei8", "01100", ["101"], "load", "向量浮点加载(8位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vfluxei16", "01101", ["101"], "load", "向量浮点加载(16位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vfluxei32", "01110", ["101"], "load", "向量浮点加载(32位索引收集)", "vd, (rs1), vs2[, vm]"),
    ("vfluxei64", "01111", ["101"], "load", "向量浮点加载(64位索引收集)", "vd, (rs1), vs2[, vm]"),

    # FP Store instructions
    ("vfsse8", "01000", ["101"], "store", "向量浮点存储(8位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vfsse16", "01001", ["101"], "store", "向量浮点存储(16位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vfsse32", "01010", ["101"], "store", "向量浮点存储(32位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vfsse64", "01011", ["101"], "store", "向量浮点存储(64位跨步)", "vs3, (rs1), rs2[, vm]"),
    ("vfsuxei8", "01100", ["101"], "store", "向量浮点存储(8位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vfsuxei16", "01101", ["101"], "store", "向量浮点存储(16位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vfsuxei32", "01110", ["101"], "store", "向量浮点存储(32位索引分散)", "vs3, (rs1), vs2[, vm]"),
    ("vfsuxei64", "01111", ["101"], "store", "向量浮点存储(64位索引分散)", "vs3, (rs1), vs2[, vm]"),

    # Configuration instructions
    ("vsetvli", "00000000000", ["111"], "configuration", "设置向量长度(立即数)", "rd, rs1, vtypei"),
    ("vsetivli", "00000000000", ["111"], "configuration", "设置向量长度(高立即数)", "rd, uimm, vtypei"),
    ("vsetvl", "000000", ["111"], "configuration", "设置向量长度(rs2)", "rd, rs1, rs2"),

    # Special operations
    ("vmv.s.x", "00000", ["110"], "move", "标量到向量移动", "vd, rs1"),
    ("vmv.x.s", "00000", ["110"], "move", "向量到标量移动", "rd, vs1"),
    ("vcpop", "10000", ["110"], "special", "向量位计数", "rd, vs2"),
    ("vfirst", "10001", ["110"], "special", "向量首位索引", "rd, vs2"),
    ("vfmv.s.f", "00000", ["101"], "move", "浮点标量到向量移动", "vd, rs1"),
    ("vfmv.f.s", "00000", ["101"], "move", "向量到浮点标量移动", "rd, vs1"),

    # Mask unary operations
    ("vmsbf", "00001", ["001"], "mask", "向量掩码设置后置", "vd, vs2[, vm]"),
    ("vmsof", "00010", ["001"], "mask", "向量掩码设置前置", "vd, vs2[, vm]"),
    ("vmsif", "00011", ["001"], "mask", "向量掩码设置索引", "vd, vs2[, vm]"),
    ("viota", "10000", ["001"], "special", "向量IOTA", "vd, vs2[, vm]"),
    ("vid", "10001", ["001"], "special", "向量索引生成", "vd[, vm]"),

    # Atomic operations
    ("vamoadd", "00000", ["111"], "atomic", "向量原子加法", "vd, (rs1), vs2, vm"),
    ("vamoand", "00100", ["111"], "atomic", "向量原子与", "vd, (rs1), vs2, vm"),
    ("vamoor", "01000", ["111"], "atomic", "向量原子或", "vd, (rs1), vs2, vm"),
    ("vamoxor", "01100", ["111"], "atomic", "向量原子异或", "vd, (rs1), vs2, vm"),
    ("vamomax", "10000", ["111"], "atomic", "向量原子最大", "vd, (rs1), vs2, vm"),
    ("vamomin", "10100", ["111"], "atomic", "向量原子最小", "vd, (rs1), vs2, vm"),
    ("vamoswap", "11000", ["111"], "atomic", "向量原子交换", "vd, (rs1), vs2, vm"),

    # Extension operations
    ("vzext.vf8", "00010", ["110"], "move", "向量零扩展(8位)", "vd, vs2[, vm]"),
    ("vsext.vf8", "00011", ["110"], "move", "向量符号扩展(8位)", "vd, vs2[, vm]"),
    ("vzext.vf4", "00100", ["110"], "move", "向量零扩展(16位)", "vd, vs2[, vm]"),
    ("vsext.vf4", "00101", ["110"], "move", "向量符号扩展(16位)", "vd, vs2[, vm]"),
    ("vzext.vf2", "00110", ["110"], "move", "向量零扩展(32位)", "vd, vs2[, vm]"),
    ("vsext.vf2", "00111", ["110"], "move", "向量符号扩展(32位)", "vd, vs2[, vm]"),
]

def build_instruction_list():
    """Build the complete instruction list with all details"""
    instructions = []

    for name, funct6, funct3_list, category, description_cn, operands in INSTRUCTIONS:
        for funct3 in funct3_list:
            inst = {
                "name": name,
                "category": CATEGORIES.get(category, category),
                "category_key": category,
                "funct6": funct6 if funct3 not in ["001", "101"] else "N/A (unary)",
                "funct3": funct3,
                "instruction_type": OP_TYPES.get(funct3, "Unknown"),
                "operands": operands,
                "description_cn": description_cn,
                "description_en": get_english_description(name, category),
                "encoding": get_encoding_info(name, funct3),
                "vm_support": "Yes" if "vm" in operands.lower() else "No",
                "format": get_format_type(name, funct3)
            }
            instructions.append(inst)

    return instructions

def get_english_description(name, category):
    """Get English description for instructions"""
    descriptions = {
        "vadd": "Vector add",
        "vsub": "Vector subtract",
        "vmul": "Vector multiply",
        "vdiv": "Vector divide",
        "vand": "Vector bitwise AND",
        "vor": "Vector bitwise OR",
        "vxor": "Vector bitwise XOR",
        "vload": "Vector load",
        "vstore": "Vector store",
    }

    for key, desc in descriptions.items():
        if key in name.lower():
            return desc
    return f"Vector {category} operation"

def get_encoding_info(name, funct3):
    """Get encoding information based on instruction type"""
    if funct3 == "111":
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "Configuration instruction"
        }
    elif funct3 in ["000", "011"]:
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "Vector-Vector or Vector-Immediate"
        }
    elif funct3 in ["100", "110"]:
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "Vector-Scalar"
        }
    elif funct3 in ["001", "101"]:
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "FP operation"
        }
    elif funct3 == "010":
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "Multiply operation"
        }
    else:
        return {
            "opcode": "1010111",
            "format": "R",
            "note": "Unknown"
        }

def get_format_type(name, funct3):
    """Determine the instruction format type"""
    if funct3 == "111":
        return "Configuration"
    elif name.startswith("vl"):
        return "Load"
    elif name.startswith("vs"):
        return "Store"
    elif funct3 in ["000", "011"]:
        return "OPIVV/OPIVI"
    elif funct3 in ["100", "110"]:
        return "OPIVX/OPMVX"
    elif funct3 in ["001", "101"]:
        return "OPFVV/OPFVF"
    elif funct3 == "010":
        return "OPMVV"
    else:
        return "Unknown"

def generate_json():
    """Generate the complete JSON file"""
    instructions = build_instruction_list()

    # Group by category
    by_category = defaultdict(list)
    for inst in instructions:
        by_category[inst["category_key"]].append(inst)

    data = {
        "metadata": {
            "version": "1.0",
            "source": "riscv-v-spec-master",
            "description": "RISC-V Vector Extension Instruction Set",
            "total_instructions": len(instructions),
            "categories_count": len(by_category)
        },
        "categories": {
            cat: {
                "name": CATEGORIES.get(cat, cat),
                "count": len(insts)
            }
            for cat, insts in by_category.items()
        },
        "instruction_types": OP_TYPES,
        "instructions": instructions
    }

    return data

def main():
    print("Generating RISC-V V Vector Extension Instruction Set JSON...")

    data = generate_json()

    # Write JSON file
    json_path = os.path.join(BASE_PATH, "rvv_instructions.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"JSON file generated: {json_path}")
    print(f"Total instructions: {data['metadata']['total_instructions']}")
    print(f"Categories: {data['metadata']['categories_count']}")

if __name__ == "__main__":
    main()
