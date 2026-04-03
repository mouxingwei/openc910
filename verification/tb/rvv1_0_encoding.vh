// RVV 1.0 Instruction Encoding Definitions
// Generated using RISC-V assembler conventions
// Created: 2026-04-02
// Reference: RISC-V Vector Extension v1.0 Specification

`ifndef RVV1_0_ENCODING_VH
`define RVV1_0_ENCODING_VH

//=================================================================
// Vector Configuration Instructions
//=================================================================

// vsetivli rd, uimm, vtype
// Format: [31:30]=11, [29:28]=zimm[9:8], [27:26]=reserved, [25:23]=zimm[7:5](vsew),
//        [22]=zimm[8], [21:20]=zimm[4:3](vlmul[4:3]), [19:15]=uimm[4:0], [14:12]=111,
//        [11:7]=rd, [6:0]=1010111
// Note: For vsetivli, AVL is in uimm field (bits [19:15])

// vsetivli x0, 8, e32, m1, ta, ma
// vsew=010 (e32), vlmul=000 (m1), vta=0, vma=0
// zimm[9:0] = {vma, vta, vsew[2:0], vlmul[2:0]} = 0_0_010_000 = 0x020
`define VSETIVLI_X0_8_E32_M1_TA_MA  32'hC08007D7

// vsetivli x0, 15, e64, m2, ta, ma
// vsew=011 (e64), vlmul=001 (m2), vta=0, vma=0
`define VSETIVLI_X0_15_E64_M2_TA_MA 32'hC0C007D7

// vsetivli x0, 4, e32, mf8, ta, ma
// vsew=010 (e32), vlmul=101 (mf8), vta=0, vma=0
`define VSETIVLI_X0_4_E32_MF8_TA_MA 32'hC0A007D7

// vsetivli x0, 4, e32, mf4, ta, ma
// vsew=010 (e32), vlmul=110 (mf4), vta=0, vma=0
`define VSETIVLI_X0_4_E32_MF4_TA_MA 32'hC0C007D7

// vsetivli x0, 4, e32, mf2, ta, ma
// vsew=010 (e32), vlmul=111 (mf2), vta=0, vma=0
`define VSETIVLI_X0_4_E32_MF2_TA_MA 32'hC0E007D7

// vsetivli x0, 8, e32, m1, tu, mu
// vma=1, vta=1, vsew=010, vlmul=000
`define VSETIVLI_X0_8_E32_M1_TU_MU  32'hC58007D7

// vsetivli x1, 8, e32, m1, ta, ma
`define VSETIVLI_X1_8_E32_M1_TA_MA  32'hC08087D7

//=================================================================
// vsetvli Instructions
//=================================================================

// vsetvli rd, rs1, vtype
// Format: [31:30]=00/01/10, [29:28]=zimm[9:8], [27:26]=reserved, [25:23]=zimm[7:5](vsew),
//        [22]=zimm[8], [21:20]=zimm[4:3], [19:15]=rs1, [14:12]=111,
//        [11:7]=rd, [6:0]=1010111

// vsetvli x0, a0, e32, m1, ta, ma
`define VSETVLI_X0_A0_E32_M1_TA_MA  32'h00807057

// vsetvli x1, a0, e64, m2, ta, ma
`define VSETVLI_X1_A0_E64_M2_TA_MA  32'h01807057

//=================================================================
// vsetvl Instructions
//=================================================================

// vsetvl rd, rs1, rs2
// Format: [31:30]=10, [29:25]=00000, [24:20]=rs2, [19:15]=rs1, [14:12]=111,
//        [11:7]=rd, [6:0]=1010111

// vsetvl x0, a0, a1
`define VSETVL_X0_A0_A1  32'h80007057

//=================================================================
// Approximate Compute Instructions
//=================================================================

// vfrece7.v vd, vs2, vm
// Format: [31:26]=000000, [25]=vm, [24:20]=vs2, [19:15]=00000, [14:12]=011,
//        [11:7]=vd, [6:0]=1010111

// vfrece7.v v1, v2
`define VFRECE7_V1_V2  32'h02002757

// vfrece7.v v0, v1
`define VFRECE7_V0_V1  32'h01002557

// vfrsqrte7.v vd, vs2, vm
// Format: [31:26]=000000, [25]=vm, [24:20]=vs2, [19:15]=00000, [14:12]=101,
//        [11:7]=vd, [6:0]=1010111

// vfrsqrte7.v v1, v2
`define VFRSQRT7_V1_V2  32'h02002D57

// vfrsqrte7.v v0, v1
`define VFRSQRT7_V0_V1  32'h01002B57

//=================================================================
// FOF Load Instructions
//=================================================================

// vleff.v vd, (rs1), vm
// Format: [31:27]=00100, [26:25]=vm, [24:20]=00000, [19:15]=rs1, [14:12]=000,
//        [11:7]=vd, [6:0]=0000111

// vleff.v v0, 0(x1)
`define VLEFF_V0_X1  32'h02002007

// vleff.v v1, 0(x2)
`define VLEFF_V1_X2  32'h04002107

// vleff.v v0, 0(x0)
`define VLEFF_V0_X0  32'h00002007

//=================================================================
// Vector Load Instructions (for comparison)
//=================================================================

// vle32.v vd, (rs1), vm
// Format: [31:27]=00100, [26:25]=vm, [24:20]=00000, [19:15]=rs1, [14:12]=000,
//        [11:7]=vd, [6:0]=0000111

// vle32.v v0, 0(x1)
`define VLE32_V0_X1  32'h02002007

//=================================================================
// Vector Arithmetic Instructions
//=================================================================

// vadd.vv vd, vs1, vs2, vm
// Format: [31:26]=000000, [25]=vm, [24:20]=vs2, [19:15]=vs1, [14:12]=000,
//        [11:7]=vd, [6:0]=1010111

// vadd.vv v0, v1, v2
`define VADD_VV_V0_V1_V2  32'h02100057

//=================================================================
// CSR Addresses
//=================================================================

`define CSR_VSTART  12'h008
`define CSR_VXSAT   12'h009
`define CSR_VXRM    12'h00A
`define CSR_VCSR    12'h00F
`define CSR_VTYPE   12'hC21
`define CSR_VLENB   12'hC22

//=================================================================
// vtype Field Layout
//=================================================================

// vtype register layout (RVV 1.0):
// [63]    : vill
// [62:8]  : Reserved (should be 0)
// [7]     : vma
// [6]     : vta
// [5:3]   : vsew[2:0]
// [2:0]   : vlmul[2:0]

`define VTYPE_VILL_BIT    63
`define VTYPE_VMA_BIT     7
`define VTYPE_VTA_BIT     6
`define VTYPE_VSEW_MSB    5
`define VTYPE_VSEW_LSB    3
`define VTYPE_VLMUL_MSB   2
`define VTYPE_VLMUL_LSB   0

//=================================================================
// vlmul Encoding
//=================================================================

`define VLMUL_M1   3'b000  // LMUL = 1
`define VLMUL_M2   3'b001  // LMUL = 2
`define VLMUL_M4   3'b010  // LMUL = 4
`define VLMUL_M8   3'b011  // LMUL = 8
`define VLMUL_MF8  3'b101  // LMUL = 1/8 (fractional)
`define VLMUL_MF4  3'b110  // LMUL = 1/4 (fractional)
`define VLMUL_MF2  3'b111  // LMUL = 1/2 (fractional)

//=================================================================
// vsew Encoding
//=================================================================

`define VSEW_E8   3'b000  // SEW = 8
`define VSEW_E16  3'b001  // SEW = 16
`define VSEW_E32  3'b010  // SEW = 32
`define VSEW_E64  3'b011  // SEW = 64

//=================================================================
// Test vtype Values
//=================================================================

// vtype for e32, m1, ta, ma
`define VTYPE_E32_M1_TA_MA  64'h0000000000000000

// vtype for e32, m1, tu, mu
`define VTYPE_E32_M1_TU_MU  64'h00000000000000C0

// vtype for e64, m2, ta, ma
`define VTYPE_E64_M2_TA_MA  64'h0000000000000008

// vtype for e32, mf8, ta, ma (fractional LMUL)
`define VTYPE_E32_MF8_TA_MA 64'h0000000000000005

// vtype for e32, mf4, ta, ma (fractional LMUL)
`define VTYPE_E32_MF4_TA_MA 64'h0000000000000006

// vtype for e32, mf2, ta, ma (fractional LMUL)
`define VTYPE_E32_MF2_TA_MA 64'h0000000000000007

// vtype with vill=1 (illegal)
`define VTYPE_ILLEGAL        64'h8000000000000000

`endif // RVV1_0_ENCODING_VH
