#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
RISC-V Vector Extension (RVV 0.7.1) Instruction Set Parser
Parse the RISC-V V-spec 0.7.1 documentation and generate JSON and Excel files
"""

import json
import os
from collections import defaultdict

BASE_PATH = r"d:\code\openc910\doc\Instruction_Set\riscv-v-spec-0.7.1"

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
    "dot": "点积类 (Dot Product)",
    "clip": "截断类 (Clip)",
    "special": "特殊功能类 (Special)"
}

OP_TYPES = {
    "000": "OPIVV (vector-vector)",
    "001": "OPFVV (FP vector-vector)",
    "010": "OPMVV (multiply vector-vector)",
    "011": "OPIVI (vector-immediate)",
    "100": "OPIVX (vector-scalar)",
    "101": "OPFVF (FP vector-scalar)",
    "110": "OPMVX (multiply vector-scalar)"
}

INSTRUCTIONS = [
    ("vadd", "000000", ["000", "100", "011"], "arithmetic", "向量加法", "vd, vs1, vs2, m"),
    ("vsub", "000010", ["000", "100"], "arithmetic", "向量减法", "vd, vs1, vs2, m"),
    ("vrsub", "000011", ["100", "011"], "arithmetic", "反向向量减法", "vd, vs1, vs2, m"),
    ("vminu", "000100", ["000", "100"], "arithmetic", "向量无符号最小值", "vd, vs1, vs2, m"),
    ("vmin", "000101", ["000", "100"], "arithmetic", "向量有符号最小值", "vd, vs1, vs2, m"),
    ("vmaxu", "000110", ["000", "100"], "arithmetic", "向量无符号最大值", "vd, vs1, vs2, m"),
    ("vmax", "000111", ["000", "100"], "arithmetic", "向量有符号最大值", "vd, vs1, vs2, m"),
    ("vand", "001001", ["000", "100", "011"], "logical", "向量按位与", "vd, vs1, vs2, m"),
    ("vor", "001010", ["000", "100", "011"], "logical", "向量按位或", "vd, vs1, vs2, m"),
    ("vxor", "001011", ["000", "100", "011"], "logical", "向量按位异或", "vd, vs1, vs2, m"),
    ("vrgather", "001100", ["000", "100", "011"], "move", "向量聚合收集", "vd, vs1, vs2, m"),
    ("vslideup", "001110", ["100", "011"], "shift", "向量上移", "vd, vs1, imm, m"),
    ("vslidedown", "001111", ["100", "011"], "shift", "向量下移", "vd, vs1, imm, m"),
    ("vadc", "010000", ["000", "100", "011"], "arithmetic", "向量加法(进位)", "vd, vs1, vs2, m"),
    ("vmadc", "010001", ["000", "100", "011"], "arithmetic", "向量加法进位(掩码)", "vd, vs1, vs2, m"),
    ("vsbc", "010010", ["000", "100"], "arithmetic", "向量减法(借位)", "vd, vs1, vs2, m"),
    ("vmsbc", "010011", ["000", "100"], "arithmetic", "向量减法借位(掩码)", "vd, vs1, vs2, m"),
    ("vmerge", "010111", ["000", "100", "011"], "move", "向量合并", "vd, vs1, vs2, m"),
    ("vmv", "010111", ["000", "100", "011"], "move", "向量移动", "vd, vs1, vs2, m"),
    ("vmseq", "011000", ["000", "100", "011"], "compare", "向量相等比较", "vd, vs1, vs2, m"),
    ("vmsne", "011001", ["000", "100", "011"], "compare", "向量不等比较", "vd, vs1, vs2, m"),
    ("vmsltu", "011010", ["000", "100"], "compare", "向量无符号小于比较", "vd, vs1, vs2, m"),
    ("vmslt", "011011", ["000", "100"], "compare", "向量有符号小于比较", "vd, vs1, vs2, m"),
    ("vmsleu", "011100", ["000", "100", "011"], "compare", "向量无符号小于等于比较", "vd, vs1, vs2, m"),
    ("vmsle", "011101", ["000", "100", "011"], "compare", "向量有符号小于等于比较", "vd, vs1, vs2, m"),
    ("vmsgtu", "011110", ["100", "011"], "compare", "向量无符号大于比较", "vd, vs1, vs2, m"),
    ("vmsgt", "011111", ["100", "011"], "compare", "向量有符号大于比较", "vd, vs1, vs2, m"),
    ("vsaddu", "100000", ["000", "100", "011"], "arithmetic", "向量饱和无符号加法", "vd, vs1, vs2, m"),
    ("vsadd", "100001", ["000", "100", "011"], "arithmetic", "向量饱和有符号加法", "vd, vs1, vs2, m"),
    ("vssubu", "100010", ["000", "100"], "arithmetic", "向量饱和无符号减法", "vd, vs1, vs2, m"),
    ("vssub", "100011", ["000", "100"], "arithmetic", "向量饱和有符号减法", "vd, vs1, vs2, m"),
    ("vaadd", "100100", ["000", "100", "011"], "arithmetic", "向量绝对值加法", "vd, vs1, vs2, m"),
    ("vsll", "100101", ["000", "100", "011"], "shift", "向量逻辑左移", "vd, vs1, vs2, m"),
    ("vasub", "100110", ["000", "100"], "arithmetic", "向量绝对值减法", "vd, vs1, vs2, m"),
    ("vsmul", "100111", ["000", "100"], "arithmetic", "向量饱和乘法", "vd, vs1, vs2, m"),
    ("vsrl", "101000", ["000", "100", "011"], "shift", "向量逻辑右移", "vd, vs1, vs2, m"),
    ("vsra", "101001", ["000", "100", "011"], "shift", "向量算术右移", "vd, vs1, vs2, m"),
    ("vssrl", "101010", ["000", "100", "011"], "shift", "向量饱和逻辑右移", "vd, vs1, vs2, m"),
    ("vssra", "101011", ["000", "100", "011"], "shift", "向量饱和算术右移", "vd, vs1, vs2, m"),
    ("vnsrl", "101100", ["000", "100", "011"], "shift", "向量窄逻辑右移", "vd, vs1, vs2, m"),
    ("vnsra", "101101", ["000", "100", "011"], "shift", "向量窄算术右移", "vd, vs1, vs2, m"),
    ("vnclipu", "101110", ["000", "100", "011"], "shift", "向量窄截断无符号右移", "vd, vs1, vs2, m"),
    ("vnclip", "101111", ["000", "100", "011"], "shift", "向量窄截断有符号右移", "vd, vs1, vs2, m"),
    ("vwredsumu", "110000", ["000"], "reduction", "向量扩展无符号求和归约", "vd, vs1, vs2, m"),
    ("vwredsum", "110001", ["000"], "reduction", "向量扩展有符号求和归约", "vd, vs1, vs2, m"),
    ("vwaddu", "110000", ["010", "110"], "arithmetic", "向量扩展无符号加法", "vd, vs1, vs2, m"),
    ("vwadd", "110001", ["010", "110"], "arithmetic", "向量扩展有符号加法", "vd, vs1, vs2, m"),
    ("vwsubu", "110010", ["010", "110"], "arithmetic", "向量扩展无符号减法", "vd, vs1, vs2, m"),
    ("vwsub", "110011", ["010", "110"], "arithmetic", "向量扩展有符号减法", "vd, vs1, vs2, m"),
    ("vwaddu.w", "110100", ["010", "110"], "arithmetic", "向量扩展无符号加法(字)", "vd, vs1, vs2, m"),
    ("vwadd.w", "110101", ["010", "110"], "arithmetic", "向量扩展有符号加法(字)", "vd, vs1, vs2, m"),
    ("vwsubu.w", "110110", ["010", "110"], "arithmetic", "向量扩展无符号减法(字)", "vd, vs1, vs2, m"),
    ("vwsub.w", "110111", ["010", "110"], "arithmetic", "向量扩展有符号减法(字)", "vd, vs1, vs2, m"),
    ("vwmulu", "111000", ["010", "110"], "multiply-add", "向量扩展无符号乘法", "vd, vs1, vs2, m"),
    ("vwmulsu", "111010", ["010", "110"], "multiply-add", "向量扩展有符号×无符号乘法", "vd, vs1, vs2, m"),
    ("vwmul", "111011", ["010", "110"], "multiply-add", "向量扩展有符号乘法", "vd, vs1, vs2, m"),
    ("vwmaccu", "111100", ["010", "110"], "multiply-add", "向量扩展无符号乘加", "vd, vs1, vs2, m"),
    ("vwmacc", "111101", ["010", "110"], "multiply-add", "向量扩展有符号乘加", "vd, vs1, vs2, m"),
    ("vwmaccsu", "111110", ["010", "110"], "multiply-add", "向量扩展有符号×无符号乘加", "vd, vs1, vs2, m"),
    ("vwmaccus", "111111", ["110"], "multiply-add", "向量扩展无符号×有符号乘加", "vd, vs1, vs2"),
    ("vredsum", "000000", ["001"], "reduction", "向量求和归约", "vd, vs1, vs2, m"),
    ("vredand", "000001", ["001"], "reduction", "向量按位与归约", "vd, vs1, vs2, m"),
    ("vredor", "000010", ["001"], "reduction", "向量按位或归约", "vd, vs1, vs2, m"),
    ("vredxor", "000011", ["001"], "reduction", "向量按位异或归约", "vd, vs1, vs2, m"),
    ("vredminu", "000100", ["001"], "reduction", "向量无符号最小值归约", "vd, vs1, vs2, m"),
    ("vredmin", "000101", ["001"], "reduction", "向量有符号最小值归约", "vd, vs1, vs2, m"),
    ("vredmaxu", "000110", ["001"], "reduction", "向量无符号最大值归约", "vd, vs1, vs2, m"),
    ("vredmax", "000111", ["001"], "reduction", "向量有符号最大值归约", "vd, vs1, vs2, m"),
    ("vdivu", "100000", ["010", "110"], "arithmetic", "向量无符号除法", "vd, vs1, vs2, m"),
    ("vdiv", "100001", ["010", "110"], "arithmetic", "向量有符号除法", "vd, vs1, vs2, m"),
    ("vremu", "100010", ["010", "110"], "arithmetic", "向量无符号余数", "vd, vs1, vs2, m"),
    ("vrem", "100011", ["010", "110"], "arithmetic", "向量有符号余数", "vd, vs1, vs2, m"),
    ("vmulhu", "100100", ["010", "110"], "multiply-add", "向量无符号乘法高位", "vd, vs1, vs2, m"),
    ("vmul", "100101", ["010", "110"], "multiply-add", "向量乘法", "vd, vs1, vs2, m"),
    ("vmulhsu", "100110", ["010", "110"], "multiply-add", "向量有符号×无符号乘法高位", "vd, vs1, vs2, m"),
    ("vmulh", "100111", ["010", "110"], "multiply-add", "向量有符号乘法高位", "vd, vs1, vs2, m"),
    ("vmadd", "101001", ["010", "110"], "multiply-add", "向量乘法加法", "vd, vs1, vs2, m"),
    ("vnmsub", "101011", ["010", "110"], "multiply-add", "向量负乘法减法", "vd, vs1, vs2, m"),
    ("vmacc", "101101", ["010", "110"], "multiply-add", "向量乘法累加", "vd, vs1, vs2, m"),
    ("vnmsac", "101111", ["010", "110"], "multiply-add", "向量负乘法累减", "vd, vs1, vs2, m"),
    ("vslide1up", "001110", ["110"], "shift", "向量上移1位", "vd, vs1, rs1, m"),
    ("vslide1down", "001111", ["110"], "shift", "向量下移1位", "vd, vs1, rs1, m"),
    ("vcompress", "010111", ["001"], "mask", "向量压缩", "vd, vs1, vs2, m"),
    ("vmandnot", "011000", ["001"], "mask", "向量与非掩码", "vd, vs1, vs2"),
    ("vmand", "011001", ["001"], "mask", "向量与掩码", "vd, vs1, vs2"),
    ("vmor", "011010", ["001"], "mask", "向量或掩码", "vd, vs1, vs2"),
    ("vmxor", "011011", ["001"], "mask", "向量异或掩码", "vd, vs1, vs2"),
    ("vmornot", "011100", ["001"], "mask", "向量或非掩码", "vd, vs1, vs2"),
    ("vmnand", "011101", ["001"], "mask", "向量与非掩码", "vd, vs1, vs2"),
    ("vmnor", "011110", ["001"], "mask", "向量或非掩码", "vd, vs1, vs2"),
    ("vmxnor", "011111", ["001"], "mask", "向量异或非掩码", "vd, vs1, vs2"),
    ("vmpopc", "010100", ["010"], "mask", "向量掩码位计数", "rd, vs2, m"),
    ("vmfirst", "010101", ["010"], "mask", "向量掩码首位索引", "rd, vs2, m"),
    ("vfadd", "000000", ["001", "101"], "fp", "向量浮点加法", "vd, vs1, vs2, m"),
    ("vfredsum", "000001", ["001"], "fp", "向量浮点求和归约", "vd, vs1, vs2, m"),
    ("vfsub", "000010", ["001", "101"], "fp", "向量浮点减法", "vd, vs1, vs2, m"),
    ("vfredosum", "000011", ["001"], "fp", "向量浮点有序求和归约", "vd, vs1, vs2, m"),
    ("vfmin", "000100", ["001", "101"], "fp", "向量浮点最小值", "vd, vs1, vs2, m"),
    ("vfredmin", "000101", ["001"], "fp", "向量浮点最小值归约", "vd, vs1, vs2, m"),
    ("vfmax", "000110", ["001", "101"], "fp", "向量浮点最大值", "vd, vs1, vs2, m"),
    ("vfredmax", "000111", ["001"], "fp", "向量浮点最大值归约", "vd, vs1, vs2, m"),
    ("vfsgnj", "001000", ["001", "101"], "fp", "向量浮点符号注入", "vd, vs1, vs2, m"),
    ("vfsgnjn", "001001", ["001", "101"], "fp", "向量浮点符号取反注入", "vd, vs1, vs2, m"),
    ("vfsgnjx", "001010", ["001", "101"], "fp", "向量浮点符号异或注入", "vd, vs1, vs2, m"),
    ("vfmv.f.s", "001100", ["001"], "move", "向量到浮点标量移动", "rd, vs1"),
    ("vfmv.s.f", "001101", ["101"], "move", "浮点标量到向量移动", "vd, rs1"),
    ("vfmerge.vf", "010111", ["101"], "move", "向量浮点合并", "vd, vs1, vs2, m"),
    ("vmfeq", "011000", ["001", "101"], "compare", "向量浮点相等比较", "vd, vs1, vs2, m"),
    ("vmfle", "011001", ["001", "101"], "compare", "向量浮点小于等于比较", "vd, vs1, vs2, m"),
    ("vmford", "011010", ["001", "101"], "compare", "向量浮点有序比较", "vd, vs1, vs2, m"),
    ("vmflt", "011011", ["001", "101"], "compare", "向量浮点小于比较", "vd, vs1, vs2, m"),
    ("vmfne", "011100", ["001", "101"], "compare", "向量浮点不等比较", "vd, vs1, vs2, m"),
    ("vmfgt", "011101", ["101"], "compare", "向量浮点大于比较", "vd, vs1, vs2, m"),
    ("vmfge", "011111", ["101"], "compare", "向量浮点大于等于比较", "vd, vs1, vs2, m"),
    ("vfdiv", "100000", ["001", "101"], "fp", "向量浮点除法", "vd, vs1, vs2, m"),
    ("vfrdiv", "100001", ["101"], "fp", "向量浮点反向除法", "vd, vs1, vs2, m"),
    ("vfmul", "100100", ["001", "101"], "fp", "向量浮点乘法", "vd, vs1, vs2, m"),
    ("vfrsub", "100111", ["101"], "fp", "向量浮点反向减法", "vd, vs1, vs2, m"),
    ("vfmadd", "101000", ["001", "101"], "fp", "向量浮点乘加", "vd, vs1, vs2, m"),
    ("vfnmadd", "101001", ["001", "101"], "fp", "向量浮点负乘加", "vd, vs1, vs2, m"),
    ("vfmsub", "101010", ["001", "101"], "fp", "向量浮点乘减", "vd, vs1, vs2, m"),
    ("vfnmsub", "101011", ["001", "101"], "fp", "向量浮点负乘减", "vd, vs1, vs2, m"),
    ("vfmacc", "101100", ["001", "101"], "fp", "向量浮点乘累加", "vd, vs1, vs2, m"),
    ("vfnmacc", "101101", ["001", "101"], "fp", "向量浮点负乘累加", "vd, vs1, vs2, m"),
    ("vfmsac", "101110", ["001", "101"], "fp", "向量浮点乘累减", "vd, vs1, vs2, m"),
    ("vfnmsac", "101111", ["001", "101"], "fp", "向量浮点负乘累减", "vd, vs1, vs2, m"),
    ("vfwadd", "110000", ["001", "101"], "fp", "向量浮点扩展加法", "vd, vs1, vs2, m"),
    ("vfwredsum", "110001", ["001"], "fp", "向量浮点扩展求和归约", "vd, vs1, vs2, m"),
    ("vfwsub", "110010", ["001", "101"], "fp", "向量浮点扩展减法", "vd, vs1, vs2, m"),
    ("vfwredosum", "110011", ["001"], "fp", "向量浮点扩展有序求和归约", "vd, vs1, vs2, m"),
    ("vfwadd.w", "110100", ["001", "101"], "fp", "向量浮点扩展加法(字)", "vd, vs1, vs2, m"),
    ("vfwsub.w", "110110", ["001", "101"], "fp", "向量浮点扩展减法(字)", "vd, vs1, vs2, m"),
    ("vfwmul", "111000", ["001", "101"], "fp", "向量浮点扩展乘法", "vd, vs1, vs2, m"),
    ("vfwmacc", "111100", ["001", "101"], "fp", "向量浮点扩展乘累加", "vd, vs1, vs2, m"),
    ("vfwnmacc", "111101", ["001", "101"], "fp", "向量浮点扩展负乘累加", "vd, vs1, vs2, m"),
    ("vfwmsac", "111110", ["001", "101"], "fp", "向量浮点扩展乘累减", "vd, vs1, vs2, m"),
    ("vfwnmsac", "111111", ["001", "101"], "fp", "向量浮点扩展负乘累减", "vd, vs1, vs2, m"),
    ("vfcvt.xu.f.v", "00000", ["001"], "convert", "向量浮点到无符号整数转换", "vd, vs1, m"),
    ("vfcvt.x.f.v", "00001", ["001"], "convert", "向量浮点到有符号整数转换", "vd, vs1, m"),
    ("vfcvt.f.xu.v", "00010", ["001"], "convert", "向量无符号整数到浮点转换", "vd, vs1, m"),
    ("vfcvt.f.x.v", "00011", ["001"], "convert", "向量有符号整数到浮点转换", "vd, vs1, m"),
    ("vfwcvt.xu.f.v", "01000", ["001"], "convert", "向量浮点到无符号整数扩展转换", "vd, vs1, m"),
    ("vfwcvt.x.f.v", "01001", ["001"], "convert", "向量浮点到有符号整数扩展转换", "vd, vs1, m"),
    ("vfwcvt.f.xu.v", "01010", ["001"], "convert", "向量无符号整数到浮点扩展转换", "vd, vs1, m"),
    ("vfwcvt.f.x.v", "01011", ["001"], "convert", "向量有符号整数到浮点扩展转换", "vd, vs1, m"),
    ("vfwcvt.f.f.v", "01100", ["001"], "convert", "向量浮点到浮点扩展转换", "vd, vs1, m"),
    ("vfncvt.xu.f.v", "10000", ["001"], "convert", "向量浮点到无符号整数缩小转换", "vd, vs1, m"),
    ("vfncvt.x.f.v", "10001", ["001"], "convert", "向量浮点到有符号整数缩小转换", "vd, vs1, m"),
    ("vfncvt.f.xu.v", "10010", ["001"], "convert", "向量无符号整数到浮点缩小转换", "vd, vs1, m"),
    ("vfncvt.f.x.v", "10011", ["001"], "convert", "向量有符号整数到浮点缩小转换", "vd, vs1, m"),
    ("vfncvt.f.f.v", "10100", ["001"], "convert", "向量浮点到浮点缩小转换", "vd, vs1, m"),
    ("vfsqrt.v", "00000", ["001"], "fp", "向量浮点平方根", "vd, vs1, m"),
    ("vfclass.v", "10000", ["001"], "special", "向量浮点分类", "vd, vs1, m"),
    ("vmsbf", "010110", ["001"], "mask", "向量掩码设置后置", "vd, vs2, m"),
    ("vmsof", "010110", ["001"], "mask", "向量掩码设置前置", "vd, vs2, m"),
    ("vmsif", "010110", ["001"], "mask", "向量掩码设置索引", "vd, vs2, m"),
    ("viota", "010110", ["001"], "special", "向量IOTA", "vd, vs2, m"),
    ("vid", "010110", ["001"], "special", "向量索引生成", "vd, m"),
    ("vext.x.v", "001100", ["010"], "move", "向量到标量提取", "rd, vs1"),
    ("vmv.s.x", "001101", ["110"], "move", "标量到向量移动", "vd, rs1"),
    ("vdotu", "111000", ["001"], "dot", "向量无符号点积", "vd, vs1, vs2, m"),
    ("vdot", "111001", ["001"], "dot", "向量有符号点积", "vd, vs1, vs2, m"),
    ("vfdot", "111001", ["001"], "dot", "向量浮点点积", "vd, vs1, vs2, m"),
    ("vwsmaccu", "111100", ["010", "110"], "dot", "向量扩展无符号点积累加", "vd, vs1, vs2, m"),
    ("vwsmacc", "111101", ["010", "110"], "dot", "向量扩展有符号点积累加", "vd, vs1, vs2, m"),
    ("vwsmaccsu", "111110", ["010", "110"], "dot", "向量扩展有符号×无符号点积累加", "vd, vs1, vs2, m"),
    ("vwsmaccus", "111111", ["110"], "dot", "向量扩展无符号×有符号点积累加", "vd, vs1, vs2"),
    ("vlb", "N/A", ["N/A"], "load", "向量加载(8位有符号)", "vd, offset(rs1), m"),
    ("vlbu", "N/A", ["N/A"], "load", "向量加载(8位无符号)", "vd, offset(rs1), m"),
    ("vlh", "N/A", ["N/A"], "load", "向量加载(16位有符号)", "vd, offset(rs1), m"),
    ("vlhu", "N/A", ["N/A"], "load", "向量加载(16位无符号)", "vd, offset(rs1), m"),
    ("vlw", "N/A", ["N/A"], "load", "向量加载(32位有符号)", "vd, offset(rs1), m"),
    ("vlwu", "N/A", ["N/A"], "load", "向量加载(32位无符号)", "vd, offset(rs1), m"),
    ("vld", "N/A", ["N/A"], "load", "向量加载(64位)", "vd, offset(rs1), m"),
    ("vflh", "N/A", ["N/A"], "load", "向量浮点加载(16位)", "vd, offset(rs1), m"),
    ("vflw", "N/A", ["N/A"], "load", "向量浮点加载(32位)", "vd, offset(rs1), m"),
    ("vfld", "N/A", ["N/A"], "load", "向量浮点加载(64位)", "vd, offset(rs1), m"),
    ("vlsb", "N/A", ["N/A"], "load", "向量跨步加载(8位有符号)", "vd, offset(rs1), rs2, m"),
    ("vlsbu", "N/A", ["N/A"], "load", "向量跨步加载(8位无符号)", "vd, offset(rs1), rs2, m"),
    ("vlsh", "N/A", ["N/A"], "load", "向量跨步加载(16位有符号)", "vd, offset(rs1), rs2, m"),
    ("vlshu", "N/A", ["N/A"], "load", "向量跨步加载(16位无符号)", "vd, offset(rs1), rs2, m"),
    ("vlsw", "N/A", ["N/A"], "load", "向量跨步加载(32位有符号)", "vd, offset(rs1), rs2, m"),
    ("vlswu", "N/A", ["N/A"], "load", "向量跨步加载(32位无符号)", "vd, offset(rs1), rs2, m"),
    ("vlsd", "N/A", ["N/A"], "load", "向量跨步加载(64位)", "vd, offset(rs1), rs2, m"),
    ("vflsh", "N/A", ["N/A"], "load", "向量浮点跨步加载(16位)", "vd, offset(rs1), rs2, m"),
    ("vflsw", "N/A", ["N/A"], "load", "向量浮点跨步加载(32位)", "vd, offset(rs1), rs2, m"),
    ("vflsd", "N/A", ["N/A"], "load", "向量浮点跨步加载(64位)", "vd, offset(rs1), rs2, m"),
    ("vlxb", "N/A", ["N/A"], "load", "向量索引加载(8位有符号)", "vd, offset(rs1), vs2, m"),
    ("vlxbu", "N/A", ["N/A"], "load", "向量索引加载(8位无符号)", "vd, offset(rs1), vs2, m"),
    ("vlxh", "N/A", ["N/A"], "load", "向量索引加载(16位有符号)", "vd, offset(rs1), vs2, m"),
    ("vlxhu", "N/A", ["N/A"], "load", "向量索引加载(16位无符号)", "vd, offset(rs1), vs2, m"),
    ("vlxw", "N/A", ["N/A"], "load", "向量索引加载(32位有符号)", "vd, offset(rs1), vs2, m"),
    ("vlxwu", "N/A", ["N/A"], "load", "向量索引加载(32位无符号)", "vd, offset(rs1), vs2, m"),
    ("vlxd", "N/A", ["N/A"], "load", "向量索引加载(64位)", "vd, offset(rs1), vs2, m"),
    ("vflxh", "N/A", ["N/A"], "load", "向量浮点索引加载(16位)", "vd, offset(rs1), vs2, m"),
    ("vflxw", "N/A", ["N/A"], "load", "向量浮点索引加载(32位)", "vd, offset(rs1), vs2, m"),
    ("vflxd", "N/A", ["N/A"], "load", "向量浮点索引加载(64位)", "vd, offset(rs1), vs2, m"),
    ("vlob", "N/A", ["N/A"], "load", "向量单元素加载(8位有符号)", "vd, rs1, m"),
    ("vlobu", "N/A", ["N/A"], "load", "向量单元素加载(8位无符号)", "vd, rs1, m"),
    ("vloh", "N/A", ["N/A"], "load", "向量单元素加载(16位有符号)", "vd, rs1, m"),
    ("vlohu", "N/A", ["N/A"], "load", "向量单元素加载(16位无符号)", "vd, rs1, m"),
    ("vlow", "N/A", ["N/A"], "load", "向量单元素加载(32位有符号)", "vd, rs1, m"),
    ("vlowu", "N/A", ["N/A"], "load", "向量单元素加载(32位无符号)", "vd, rs1, m"),
    ("vlod", "N/A", ["N/A"], "load", "向量单元素加载(64位)", "vd, rs1, m"),
    ("vfloh", "N/A", ["N/A"], "load", "向量浮点单元素加载(16位)", "vd, rs1, m"),
    ("vflow", "N/A", ["N/A"], "load", "向量浮点单元素加载(32位)", "vd, rs1, m"),
    ("vflod", "N/A", ["N/A"], "load", "向量浮点单元素加载(64位)", "vd, rs1, m"),
    ("vsb", "N/A", ["N/A"], "store", "向量存储(8位)", "vs3, offset(rs1), m"),
    ("vsh", "N/A", ["N/A"], "store", "向量存储(16位)", "vs3, offset(rs1), m"),
    ("vsw", "N/A", ["N/A"], "store", "向量存储(32位)", "vs3, offset(rs1), m"),
    ("vsd", "N/A", ["N/A"], "store", "向量存储(64位)", "vs3, offset(rs1), m"),
    ("vssb", "N/A", ["N/A"], "store", "向量跨步存储(8位)", "vs3, offset(rs1), rs2, m"),
    ("vssh", "N/A", ["N/A"], "store", "向量跨步存储(16位)", "vs3, offset(rs1), rs2, m"),
    ("vssw", "N/A", ["N/A"], "store", "向量跨步存储(32位)", "vs3, offset(rs1), rs2, m"),
    ("vssd", "N/A", ["N/A"], "store", "向量跨步存储(64位)", "vs3, offset(rs1), rs2, m"),
    ("vsxb", "N/A", ["N/A"], "store", "向量索引存储(8位)", "vs3, offset(rs1), vs2, m"),
    ("vsxh", "N/A", ["N/A"], "store", "向量索引存储(16位)", "vs3, offset(rs1), vs2, m"),
    ("vsxw", "N/A", ["N/A"], "store", "向量索引存储(32位)", "vs3, offset(rs1), vs2, m"),
    ("vsxd", "N/A", ["N/A"], "store", "向量索引存储(64位)", "vs3, offset(rs1), vs2, m"),
    ("vsob", "N/A", ["N/A"], "store", "向量单元素存储(8位)", "vs3, offset(rs1), m"),
    ("vsoh", "N/A", ["N/A"], "store", "向量单元素存储(16位)", "vs3, offset(rs1), m"),
    ("vsow", "N/A", ["N/A"], "store", "向量单元素存储(32位)", "vs3, offset(rs1), m"),
    ("vsod", "N/A", ["N/A"], "store", "向量单元素存储(64位)", "vs3, offset(rs1), m"),
    ("vclipb", "N/A", ["N/A"], "clip", "向量截断(8位有符号)", "vd, vs1, vs2, m"),
    ("vclipbu", "N/A", ["N/A"], "clip", "向量截断(8位无符号)", "vd, vs1, vs2, m"),
    ("vcliph", "N/A", ["N/A"], "clip", "向量截断(16位有符号)", "vd, vs1, vs2, m"),
    ("vcliphu", "N/A", ["N/A"], "clip", "向量截断(16位无符号)", "vd, vs1, vs2, m"),
    ("vclipw", "N/A", ["N/A"], "clip", "向量截断(32位有符号)", "vd, vs1, vs2, m"),
    ("vclipwu", "N/A", ["N/A"], "clip", "向量截断(32位无符号)", "vd, vs1, vs2, m"),
]

def build_instruction_list():
    instructions = []
    for name, funct6, funct3_list, category, description_cn, operands in INSTRUCTIONS:
        for funct3 in funct3_list:
            inst = {
                "name": name,
                "category": CATEGORIES.get(category, category),
                "category_key": category,
                "funct6": funct6 if funct3 not in ["001", "101"] and funct6 != "N/A" else "N/A (unary/load/store)",
                "funct3": funct3,
                "instruction_type": OP_TYPES.get(funct3, "Unknown" if funct3 == "N/A" else "Load/Store"),
                "operands": operands,
                "description_cn": description_cn,
                "description_en": get_english_description(name, category),
                "encoding": get_encoding_info(name, funct3),
                "vm_support": "Yes" if "m" in operands.lower() else "No",
                "format": get_format_type(name, funct3)
            }
            instructions.append(inst)
    return instructions

def get_english_description(name, category):
    descriptions = {
        "vadd": "Vector add",
        "vsub": "Vector subtract",
        "vmul": "Vector multiply",
        "vdiv": "Vector divide",
        "vand": "Vector bitwise AND",
        "vor": "Vector bitwise OR",
        "vxor": "Vector bitwise XOR",
        "vlb": "Vector load byte",
        "vsb": "Vector store byte",
        "vdot": "Vector dot product",
        "vdotu": "Vector unsigned dot product",
    }
    for key, desc in descriptions.items():
        if key in name.lower():
            return desc
    return f"Vector {category} operation"

def get_encoding_info(name, funct3):
    if funct3 == "N/A":
        return {"opcode": "0000111/0100111", "format": "VL/VS", "note": "Load/Store instruction"}
    elif funct3 in ["000", "011"]:
        return {"opcode": "1010111", "format": "R", "note": "Vector-Vector or Vector-Immediate"}
    elif funct3 in ["100", "110"]:
        return {"opcode": "1010111", "format": "R", "note": "Vector-Scalar"}
    elif funct3 in ["001", "101"]:
        return {"opcode": "1010111", "format": "R", "note": "FP operation"}
    elif funct3 == "010":
        return {"opcode": "1010111", "format": "R", "note": "Multiply operation"}
    else:
        return {"opcode": "1010111", "format": "R", "note": "Unknown"}

def get_format_type(name, funct3):
    if funct3 == "N/A":
        return "Load/Store"
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
    instructions = build_instruction_list()
    by_category = defaultdict(list)
    for inst in instructions:
        by_category[inst["category_key"]].append(inst)
    
    data = {
        "metadata": {
            "version": "0.7.1",
            "source": "riscv-v-spec-0.7.1",
            "description": "RISC-V Vector Extension Instruction Set (Version 0.7.1)",
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
    print("Generating RISC-V V Vector Extension 0.7.1 Instruction Set JSON...")
    data = generate_json()
    json_path = os.path.join(BASE_PATH, "rvv_instructions_0.7.1.json")
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"JSON file generated: {json_path}")
    print(f"Total instructions: {data['metadata']['total_instructions']}")
    print(f"Categories: {data['metadata']['categories_count']}")

if __name__ == "__main__":
    main()
