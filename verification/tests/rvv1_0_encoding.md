# RVV 1.0 Instruction Encoding Reference
# Generated using RISC-V assembler conventions
# Created: 2026-04-02

## vsetivli Instruction Encoding

vsetivli rd, uimm, vtypei

Format:
| 31-30 | 29-28 | 27-26 | 25-23 | 22 | 21-20 | 19-15 | 14-12 | 11-7 | 6-0 |
|-------|-------|-------|-------|----|----|-------|-------|------|-----|
| uimm[5:4] | vtypei[9:8] | vtypei[7:5] | vtypei[4:3] | rd | 111 | uimm[4:0] | 1010111 |

vtypei fields:
- vtypei[2:0] = vlmul (LMUL setting)
- vtypei[5:3] = vsew (SEW setting)
- vtypei[6] = vta (tail agnostic)
- vtypei[7] = vma (mask agnostic)

### vlmul encoding:
| Value | LMUL |
|-------|------|
| 000 | 1 |
| 001 | 2 |
| 010 | 4 |
| 011 | 8 |
| 101 | 1/8 |
| 110 | 1/4 |
| 111 | 1/2 |

### vsew encoding:
| Value | SEW |
|-------|-----|
| 000 | 8 |
| 001 | 16 |
| 010 | 32 |
| 011 | 64 |
| 100 | 128 |
| 101 | 256 |

### Example encodings:

# vsetivli x0, 8, e32, m1, ta, ma
# uimm=8, vsew=010(32), vlmul=000(1), vta=0, vma=0
# Binary: 11_00_000_010_00000_111_01000_1010111
# Hex: 0xC08007D7

# vsetivli x0, 4, e32, mf8, ta, ma  
# uimm=4, vsew=010(32), vlmul=101(1/8), vta=0, vma=0
# Binary: 11_00_000_010_00000_111_00100_1010111
# Hex: 0xC08003D7

# vsetivli x0, 16, e64, m1, tu, mu
# uimm=16, vsew=011(64), vlmul=000(1), vta=1, vma=1
# Binary: 11_11_000_011_00000_111_10000_1010111
# Hex: 0xF0C010D7

## vsetvli Instruction Encoding

vsetvli rd, rs1, vtypei

Format:
| 31-30 | 29-28 | 27-26 | 25-23 | 22 | 21-20 | 19-15 | 14-12 | 11-7 | 6-0 |
|-------|-------|-------|-------|----|----|-------|-------|------|-----|
| 0 | vtypei[9:8] | vtypei[7:5] | vtypei[4:3] | rs1 | 111 | rd | 1010111 |

### Example encodings:

# vsetvli x0, a0, e32, m1, ta, ma
# rs1=x10(a0), rd=x0, vsew=010, vlmul=000
# Binary: 00_00_000_010_01010_111_00000_1010111
# Hex: 0x0080A057

## vfrece7 Instruction Encoding

vfrece7.v vd, vs2, vm

Format:
| 31-26 | 25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |
|-------|----|----|-------|-------|------|-----|
| 000000 | vm | vs2 | vd | 011 | vd | 1010111 |

### Example encodings:

# vfrece7.v v1, v2
# vs2=v2(00010), vd=v1(00001), vm=1
# Binary: 000000_1_00010_00001_011_00001_1010111
# Hex: 0x0280B057

## vfrsqrte7 Instruction Encoding

vfrsqrte7.v vd, vs2, vm

Format:
| 31-26 | 25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |
|-------|----|----|-------|-------|------|-----|
| 000000 | vm | vs2 | vd | 101 | vd | 1010111 |

### Example encodings:

# vfrsqrte7.v v1, v2
# vs2=v2(00010), vd=v1(00001), vm=1
# Binary: 000000_1_00010_00001_101_00001_1010111
# Hex: 0x0280D057

## FOF Load Instructions (vleff)

vleff.v vd, (rs1), vm

Format:
| 31-27 | 26-25 | 24-20 | 19-15 | 14-12 | 11-7 | 6-0 |
|-------|-------|-------|-------|-------|------|-----|
| 00100 | lumop | vs2 | rs1 | width | vd | 0000111 |

For vleff: lumop = 10000 (FOF)

### Example encodings:

# vle32ff.v v0, (x1)
# rs1=x1, vd=v0, width=010(32)
# Binary: 00100_10000_00000_00001_010_00000_0000111
# Hex: 0x1200A007

## CSR Addresses

| CSR | Address |
|-----|---------|
| vstart | 0x008 |
| vxsat | 0x009 |
| vxrm | 0x00A |
| vcsr | 0x00F |
| vtype | 0xC21 |
| vlenb | 0xC22 |

## vtype Register Layout (RVV 1.0)

| Bit | Field |
|-----|-------|
| 63 | vill |
| 62:8 | Reserved (0) |
| 7 | vma |
| 6 | vta |
| 5:3 | vsew |
| 2:0 | vlmul |

## VCSR Register Layout

| Bit | Field |
|-----|-------|
| 2:1 | vxrm |
| 0 | vxsat |
