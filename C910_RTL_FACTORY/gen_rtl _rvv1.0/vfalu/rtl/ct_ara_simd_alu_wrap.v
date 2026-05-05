/*Copyright 2019-2021 T-Head Semiconductor Co., Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

//==========================================================
//              Ara SIMD ALU Compatible Wrapper
//==========================================================
// P0 RVV1.0 integer ALU path.
// The operation encoding follows the existing C910 RVV decode fields and the
// datapath semantics are aligned with Ara's 64-bit lane SIMD ALU.

module ct_ara_simd_alu_wrap(
  ara_alu_result,
  ara_alu_vld,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_imm0,
  dp_vfalu_ex1_pipex_mask,
  dp_vfalu_ex1_pipex_mtvr_src0,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  dp_vfalu_ex1_pipex_srcf2,
  dp_vfalu_ex1_pipex_sel,
  dp_vfalu_ex1_pipex_vimm,
  dp_vfalu_ex1_pipex_vimm_vld,
  forever_cpuclk
);

input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [2 :0]  dp_vfalu_ex1_pipex_imm0;
input   [63:0]  dp_vfalu_ex1_pipex_mask;
input   [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input   [63:0]  dp_vfalu_ex1_pipex_srcf2;
input   [2 :0]  dp_vfalu_ex1_pipex_sel;
input   [4 :0]  dp_vfalu_ex1_pipex_vimm;
input           dp_vfalu_ex1_pipex_vimm_vld;
input           forever_cpuclk;
output  [63:0]  ara_alu_result;
output          ara_alu_vld;

reg     [63:0]  ara_alu_ex2_result;
reg     [63:0]  ara_alu_ex3_result;
reg             ara_alu_ex2_vld;
reg             ara_alu_ex3_vld;

wire    [19:0]  func;
wire    [17:0]  func_op;
wire    [1 :0]  sew;
wire    [63:0]  src0;
wire    [63:0]  src1;
wire    [63:0]  src1_imm;
wire    [63:0]  src1_scalar;
wire    [63:0]  src2;
wire    [63:0]  v0_mask;
wire            opivx;
wire            opivi;
wire            opmul_fmt;

wire            op_vadd;
wire            op_vsub;
wire            op_vadc;
wire            op_vmadc;
wire            op_vsbc;
wire            op_vmsbc;
wire            op_vsaddu;
wire            op_vsadd;
wire            op_vssubu;
wire            op_vssub;
wire            op_vaadd;
wire            op_vasub;
wire            op_vmul;
wire            op_vmulh;
wire            op_vmulhu;
wire            op_vmulhsu;
wire            op_vsmul;
wire            op_vand;
wire            op_vor;
wire            op_vxor;
wire            op_vmand;
wire            op_vmnand;
wire            op_vmandn;
wire            op_vmxor;
wire            op_vmnxor;
wire            op_vmorr;
wire            op_vmnorr;
wire            op_vmorrn;
wire            op_vseq;
wire            op_vsne;
wire            op_vslt;
wire            op_vsltu;
wire            op_vsle;
wire            op_vsleu;
wire            op_vmin;
wire            op_vminu;
wire            op_vmax;
wire            op_vmaxu;
wire            op_vmov;
wire            op_vmerge;
wire            op_vsll;
wire            op_vsrl;
wire            op_vsra;
wire    [63:0]  ex1_result;
wire            ex1_vld;
wire            supported_op;

assign func[19:0] = dp_vfalu_ex1_pipex_func[19:0];
assign func_op[17:0] = func[17:0];
assign sew[1:0]   = func[19:18];
assign src0[63:0] = dp_vfalu_ex1_pipex_srcf0[63:0];
assign opivx      = (dp_vfalu_ex1_pipex_imm0[2:0] == 3'b100)
                 || (dp_vfalu_ex1_pipex_imm0[2:0] == 3'b110);
assign opivi      = (dp_vfalu_ex1_pipex_imm0[2:0] == 3'b011)
                 && dp_vfalu_ex1_pipex_vimm_vld;
assign opmul_fmt  = (dp_vfalu_ex1_pipex_imm0[2:0] == 3'b010)
                 || (dp_vfalu_ex1_pipex_imm0[2:0] == 3'b110);
assign src1_scalar[63:0] = scalar_bcast(dp_vfalu_ex1_pipex_mtvr_src0[63:0], sew);
assign src1_imm[63:0]    = imm_bcast(dp_vfalu_ex1_pipex_vimm[4:0], sew);
assign src1[63:0] = opivi ? src1_imm[63:0]
                 : opivx ? src1_scalar[63:0]
                         : dp_vfalu_ex1_pipex_srcf1[63:0];
assign src2[63:0] = dp_vfalu_ex1_pipex_srcf2[63:0];
assign v0_mask[63:0] = dp_vfalu_ex1_pipex_mask[63:0];

// Existing C910 RVV integer func layout, with func[19:18] reused for SEW.
// Use exact supported op matching so incomplete VALU opcodes do not commit a
// placeholder result.
assign op_vadd   = (func_op[17:0] == 18'h00020);
assign op_vsub   = (func_op[17:0] == 18'h00000);
assign op_vadc   = (func_op[17:0] == 18'h00030);
assign op_vmadc  = (func_op[17:0] == 18'h00038);
assign op_vsbc   = (func_op[17:0] == 18'h00010);
assign op_vmsbc  = (func_op[17:0] == 18'h00018);
assign op_vsaddu = (func_op[17:0] == 18'h00021);
assign op_vsadd  = (func_op[17:0] == 18'h00025);
assign op_vssubu = (func_op[17:0] == 18'h00001);
assign op_vssub  = (func_op[17:0] == 18'h00005) && !opmul_fmt;
assign op_vaadd  = (func_op[17:0] == 18'h00026);
assign op_vasub  = (func_op[17:0] == 18'h00006);
assign op_vmul   = (func_op[17:0] == 18'h00008);
assign op_vmulh  = (func_op[17:0] == 18'h00007);
assign op_vmulhu = (func_op[17:0] == 18'h00004);
assign op_vmulhsu= (func_op[17:0] == 18'h00005) && opmul_fmt;
assign op_vsmul  = (func_op[17:0] == 18'h00467);
assign op_vand   = (func_op[17:0] == 18'h00084);
assign op_vor    = (func_op[17:0] == 18'h00104);
assign op_vxor   = (func_op[17:0] == 18'h00204);
assign op_vmand  = (func_op[17:0] == 18'h00088);
assign op_vmnand = (func_op[17:0] == 18'h00488);
assign op_vmandn = (func_op[17:0] == 18'h00888);
assign op_vmxor  = (func_op[17:0] == 18'h00208);
assign op_vmnxor = (func_op[17:0] == 18'h00608);
assign op_vmorr  = (func_op[17:0] == 18'h00108);
assign op_vmnorr = (func_op[17:0] == 18'h00508);
assign op_vmorrn = (func_op[17:0] == 18'h00908);
assign op_vseq   = (func_op[17:0] == 18'h0004c);
assign op_vsne   = (func_op[17:0] == 18'h00044);
assign op_vsltu  = (func_op[17:0] == 18'h00050);
assign op_vslt   = (func_op[17:0] == 18'h00054);
assign op_vsleu  = (func_op[17:0] == 18'h00058);
assign op_vsle   = (func_op[17:0] == 18'h0005c);
assign op_vminu  = (func_op[17:0] == 18'h00460);
assign op_vmin   = (func_op[17:0] == 18'h00464);
assign op_vmaxu  = (func_op[17:0] == 18'h00060);
assign op_vmax   = (func_op[17:0] == 18'h00064);
assign op_vmerge = (func_op[17:0] == 18'h00404);
assign op_vmov   = (func_op[17:0] == 18'h00804);
assign op_vsll   =  func[17] &&  func[0];
assign op_vsrl   =  func[17] && !func[3] && !func[0];
assign op_vsra   =  func[17] &&  func[3] && !func[0];

assign supported_op = op_vadd
                   || op_vsub
                   || op_vadc
                   || op_vmadc
                   || op_vsbc
                   || op_vmsbc
                   || op_vsaddu
                   || op_vsadd
                   || op_vssubu
                   || op_vssub
                   || op_vaadd
                   || op_vasub
                   || op_vmul
                   || op_vmulh
                   || op_vmulhu
                   || op_vmulhsu
                   || op_vsmul
                   || op_vand
                   || op_vor
                   || op_vxor
                   || op_vmand
                   || op_vmnand
                   || op_vmandn
                   || op_vmxor
                   || op_vmnxor
                   || op_vmorr
                   || op_vmnorr
                   || op_vmorrn
                   || op_vseq
                   || op_vsne
                   || op_vsltu
                   || op_vslt
                   || op_vsleu
                   || op_vsle
                   || op_vminu
                   || op_vmin
                   || op_vmaxu
                   || op_vmax
                   || op_vmerge
                   || op_vmov
                   || op_vsll
                   || op_vsrl
                   || op_vsra;

assign ex1_vld = dp_vfalu_ex1_pipex_sel[2] && supported_op;

assign ex1_result[63:0] =
       ({64{op_vadd}}   & simd_add(src0, src1, sew))
     | ({64{op_vsub}}   & simd_sub(src0, src1, sew))
     | ({64{op_vadc}}   & simd_adc(src0, src1, v0_mask, sew))
     | ({64{op_vmadc}}  & simd_add_carry(src0, src1, v0_mask, sew))
     | ({64{op_vsbc}}   & simd_sbc(src0, src1, v0_mask, sew))
     | ({64{op_vmsbc}}  & simd_sub_borrow(src0, src1, v0_mask, sew))
     | ({64{op_vsaddu}} & simd_sat_add_u(src0, src1, sew))
     | ({64{op_vsadd}}  & simd_sat_add_s(src0, src1, sew))
     | ({64{op_vssubu}} & simd_sat_sub_u(src0, src1, sew))
     | ({64{op_vssub}}  & simd_sat_sub_s(src0, src1, sew))
     | ({64{op_vaadd}}  & simd_avg_add_s(src0, src1, sew))
     | ({64{op_vasub}}  & simd_avg_sub_s(src0, src1, sew))
     | ({64{op_vmul}}   & simd_mul_low(src0, src1, sew))
     | ({64{op_vmulh}}  & simd_mul_high(src0, src1, sew, 1'b1, 1'b1))
     | ({64{op_vmulhu}} & simd_mul_high(src0, src1, sew, 1'b0, 1'b0))
     | ({64{op_vmulhsu}}& simd_mul_high(src0, src1, sew, 1'b1, 1'b0))
     | ({64{op_vsmul}}  & simd_smul_round_sat(src0, src1, sew))
     | ({64{op_vand}}   & (src0 & src1))
     | ({64{op_vor}}    & (src0 | src1))
     | ({64{op_vxor}}   & (src0 ^ src1))
     | ({64{op_vmand}}  & (src0 & src1))
     | ({64{op_vmnand}} & ~(src0 & src1))
     | ({64{op_vmandn}} & (src0 & ~src1))
     | ({64{op_vmxor}}  & (src0 ^ src1))
     | ({64{op_vmnxor}} & ~(src0 ^ src1))
     | ({64{op_vmorr}}  & (src0 | src1))
     | ({64{op_vmnorr}} & ~(src0 | src1))
     | ({64{op_vmorrn}} & (src0 | ~src1))
     | ({64{op_vseq}}   & simd_cmp_eq(src0, src1, sew))
     | ({64{op_vsne}}   & simd_cmp_ne(src0, src1, sew))
     | ({64{op_vsltu}}  & simd_cmp_ltu(src0, src1, sew))
     | ({64{op_vslt}}   & simd_cmp_lt(src0, src1, sew))
     | ({64{op_vsleu}}  & simd_cmp_leu(src0, src1, sew))
     | ({64{op_vsle}}   & simd_cmp_le(src0, src1, sew))
     | ({64{op_vminu}}  & simd_minmax(src0, src1, sew, 1'b0, 1'b0))
     | ({64{op_vmin}}   & simd_minmax(src0, src1, sew, 1'b1, 1'b0))
     | ({64{op_vmaxu}}  & simd_minmax(src0, src1, sew, 1'b0, 1'b1))
     | ({64{op_vmax}}   & simd_minmax(src0, src1, sew, 1'b1, 1'b1))
     | ({64{op_vmerge}} & simd_merge(src0, src1, v0_mask, sew))
     | ({64{op_vmov}}   & src1)
     | ({64{op_vsll}}   & simd_sll(src0, src1, sew))
     | ({64{op_vsrl}}   & simd_srl(src0, src1, sew))
     | ({64{op_vsra}}   & simd_sra(src0, src1, sew));

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b) begin
    ara_alu_ex2_result[63:0] <= 64'b0;
    ara_alu_ex2_vld          <= 1'b0;
    ara_alu_ex3_result[63:0] <= 64'b0;
    ara_alu_ex3_vld          <= 1'b0;
  end
  else begin
    ara_alu_ex2_result[63:0] <= ex1_result[63:0];
    ara_alu_ex2_vld          <= ex1_vld;
    ara_alu_ex3_result[63:0] <= ara_alu_ex2_result[63:0];
    ara_alu_ex3_vld          <= ara_alu_ex2_vld;
  end
end

assign ara_alu_result[63:0] = ara_alu_ex3_result[63:0];
assign ara_alu_vld          = ara_alu_ex3_vld;

function [63:0] simd_add;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_add = {a[63:56] + b[63:56], a[55:48] + b[55:48],
                         a[47:40] + b[47:40], a[39:32] + b[39:32],
                         a[31:24] + b[31:24], a[23:16] + b[23:16],
                         a[15:8]  + b[15:8],  a[7:0]   + b[7:0]};
      2'b01: simd_add = {a[63:48] + b[63:48], a[47:32] + b[47:32],
                         a[31:16] + b[31:16], a[15:0]  + b[15:0]};
      2'b10: simd_add = {a[63:32] + b[63:32], a[31:0] + b[31:0]};
      default: simd_add = a + b;
    endcase
end
endfunction

function [63:0] scalar_bcast;
  input [63:0] scalar;
  input [1 :0] eew;
begin
  case(eew)
    2'b00: scalar_bcast = {8{scalar[7:0]}};
    2'b01: scalar_bcast = {4{scalar[15:0]}};
    2'b10: scalar_bcast = {2{scalar[31:0]}};
    default: scalar_bcast = scalar[63:0];
  endcase
end
endfunction

function [63:0] imm_bcast;
  input [4 :0] imm;
  input [1 :0] eew;
  reg   [7 :0] imm8;
  reg   [15:0] imm16;
  reg   [31:0] imm32;
  reg   [63:0] imm64;
begin
  imm8  = {{3{imm[4]}}, imm[4:0]};
  imm16 = {{11{imm[4]}}, imm[4:0]};
  imm32 = {{27{imm[4]}}, imm[4:0]};
  imm64 = {{59{imm[4]}}, imm[4:0]};
  case(eew)
    2'b00: imm_bcast = {8{imm8}};
    2'b01: imm_bcast = {4{imm16}};
    2'b10: imm_bcast = {2{imm32}};
    default: imm_bcast = imm64;
  endcase
end
endfunction

function [63:0] simd_sub;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sub = {a[63:56] - b[63:56], a[55:48] - b[55:48],
                         a[47:40] - b[47:40], a[39:32] - b[39:32],
                         a[31:24] - b[31:24], a[23:16] - b[23:16],
                         a[15:8]  - b[15:8],  a[7:0]   - b[7:0]};
      2'b01: simd_sub = {a[63:48] - b[63:48], a[47:32] - b[47:32],
                         a[31:16] - b[31:16], a[15:0]  - b[15:0]};
      2'b10: simd_sub = {a[63:32] - b[63:32], a[31:0] - b[31:0]};
      default: simd_sub = a - b;
    endcase
  end
endfunction

function [63:0] simd_adc;
  input [63:0] a;
  input [63:0] b;
  input [63:0] mask;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_adc = {a[63:56] + b[63:56] + mask[7], a[55:48] + b[55:48] + mask[6],
                         a[47:40] + b[47:40] + mask[5], a[39:32] + b[39:32] + mask[4],
                         a[31:24] + b[31:24] + mask[3], a[23:16] + b[23:16] + mask[2],
                         a[15:8]  + b[15:8]  + mask[1], a[7:0]   + b[7:0]   + mask[0]};
      2'b01: simd_adc = {a[63:48] + b[63:48] + mask[3], a[47:32] + b[47:32] + mask[2],
                         a[31:16] + b[31:16] + mask[1], a[15:0]  + b[15:0]  + mask[0]};
      2'b10: simd_adc = {a[63:32] + b[63:32] + mask[1], a[31:0] + b[31:0] + mask[0]};
      default: simd_adc = a + b + mask[0];
    endcase
  end
endfunction

function [63:0] simd_sbc;
  input [63:0] a;
  input [63:0] b;
  input [63:0] mask;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sbc = {a[63:56] - b[63:56] - mask[7], a[55:48] - b[55:48] - mask[6],
                         a[47:40] - b[47:40] - mask[5], a[39:32] - b[39:32] - mask[4],
                         a[31:24] - b[31:24] - mask[3], a[23:16] - b[23:16] - mask[2],
                         a[15:8]  - b[15:8]  - mask[1], a[7:0]   - b[7:0]   - mask[0]};
      2'b01: simd_sbc = {a[63:48] - b[63:48] - mask[3], a[47:32] - b[47:32] - mask[2],
                         a[31:16] - b[31:16] - mask[1], a[15:0]  - b[15:0]  - mask[0]};
      2'b10: simd_sbc = {a[63:32] - b[63:32] - mask[1], a[31:0] - b[31:0] - mask[0]};
      default: simd_sbc = a - b - mask[0];
    endcase
  end
endfunction

function [63:0] simd_add_carry;
  input [63:0] a;
  input [63:0] b;
  input [63:0] mask;
  input [1 :0] eew;
  reg   [7 :0] carry;
  begin
    carry = 8'b0;
    case(eew)
      2'b00: begin
        carry[0] = ({1'b0, a[7:0]}   + {1'b0, b[7:0]}   + mask[0]) >> 8;
        carry[1] = ({1'b0, a[15:8]}  + {1'b0, b[15:8]}  + mask[1]) >> 8;
        carry[2] = ({1'b0, a[23:16]} + {1'b0, b[23:16]} + mask[2]) >> 8;
        carry[3] = ({1'b0, a[31:24]} + {1'b0, b[31:24]} + mask[3]) >> 8;
        carry[4] = ({1'b0, a[39:32]} + {1'b0, b[39:32]} + mask[4]) >> 8;
        carry[5] = ({1'b0, a[47:40]} + {1'b0, b[47:40]} + mask[5]) >> 8;
        carry[6] = ({1'b0, a[55:48]} + {1'b0, b[55:48]} + mask[6]) >> 8;
        carry[7] = ({1'b0, a[63:56]} + {1'b0, b[63:56]} + mask[7]) >> 8;
      end
      2'b01: begin
        carry[0] = ({1'b0, a[15:0]}  + {1'b0, b[15:0]}  + mask[0]) >> 16;
        carry[1] = ({1'b0, a[31:16]} + {1'b0, b[31:16]} + mask[1]) >> 16;
        carry[2] = ({1'b0, a[47:32]} + {1'b0, b[47:32]} + mask[2]) >> 16;
        carry[3] = ({1'b0, a[63:48]} + {1'b0, b[63:48]} + mask[3]) >> 16;
      end
      2'b10: begin
        carry[0] = ({1'b0, a[31:0]}  + {1'b0, b[31:0]}  + mask[0]) >> 32;
        carry[1] = ({1'b0, a[63:32]} + {1'b0, b[63:32]} + mask[1]) >> 32;
      end
      default: carry[0] = ({1'b0, a} + {1'b0, b} + mask[0]) >> 64;
    endcase
    simd_add_carry = {56'b0, carry};
  end
endfunction

function [63:0] simd_sub_borrow;
  input [63:0] a;
  input [63:0] b;
  input [63:0] mask;
  input [1 :0] eew;
  reg   [7 :0] borrow;
  begin
    borrow = 8'b0;
    case(eew)
      2'b00: begin
        borrow[0] = ({1'b0, a[7:0]}   < ({1'b0, b[7:0]}   + mask[0]));
        borrow[1] = ({1'b0, a[15:8]}  < ({1'b0, b[15:8]}  + mask[1]));
        borrow[2] = ({1'b0, a[23:16]} < ({1'b0, b[23:16]} + mask[2]));
        borrow[3] = ({1'b0, a[31:24]} < ({1'b0, b[31:24]} + mask[3]));
        borrow[4] = ({1'b0, a[39:32]} < ({1'b0, b[39:32]} + mask[4]));
        borrow[5] = ({1'b0, a[47:40]} < ({1'b0, b[47:40]} + mask[5]));
        borrow[6] = ({1'b0, a[55:48]} < ({1'b0, b[55:48]} + mask[6]));
        borrow[7] = ({1'b0, a[63:56]} < ({1'b0, b[63:56]} + mask[7]));
      end
      2'b01: begin
        borrow[0] = ({1'b0, a[15:0]}  < ({1'b0, b[15:0]}  + mask[0]));
        borrow[1] = ({1'b0, a[31:16]} < ({1'b0, b[31:16]} + mask[1]));
        borrow[2] = ({1'b0, a[47:32]} < ({1'b0, b[47:32]} + mask[2]));
        borrow[3] = ({1'b0, a[63:48]} < ({1'b0, b[63:48]} + mask[3]));
      end
      2'b10: begin
        borrow[0] = ({1'b0, a[31:0]}  < ({1'b0, b[31:0]}  + mask[0]));
        borrow[1] = ({1'b0, a[63:32]} < ({1'b0, b[63:32]} + mask[1]));
      end
      default: borrow[0] = ({1'b0, a} < ({1'b0, b} + mask[0]));
    endcase
    simd_sub_borrow = {56'b0, borrow};
  end
endfunction

function [63:0] simd_sat_add_u;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sat_add_u = {sat_add_u8(a[63:56], b[63:56]), sat_add_u8(a[55:48], b[55:48]),
                               sat_add_u8(a[47:40], b[47:40]), sat_add_u8(a[39:32], b[39:32]),
                               sat_add_u8(a[31:24], b[31:24]), sat_add_u8(a[23:16], b[23:16]),
                               sat_add_u8(a[15:8],  b[15:8]),  sat_add_u8(a[7:0],   b[7:0])};
      2'b01: simd_sat_add_u = {sat_add_u16(a[63:48], b[63:48]), sat_add_u16(a[47:32], b[47:32]),
                               sat_add_u16(a[31:16], b[31:16]), sat_add_u16(a[15:0],  b[15:0])};
      2'b10: simd_sat_add_u = {sat_add_u32(a[63:32], b[63:32]), sat_add_u32(a[31:0], b[31:0])};
      default: simd_sat_add_u = sat_add_u64(a, b);
    endcase
end
endfunction

function [63:0] simd_mul_low;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_mul_low = {mul_low_u8(a[63:56], b[63:56]), mul_low_u8(a[55:48], b[55:48]),
                             mul_low_u8(a[47:40], b[47:40]), mul_low_u8(a[39:32], b[39:32]),
                             mul_low_u8(a[31:24], b[31:24]), mul_low_u8(a[23:16], b[23:16]),
                             mul_low_u8(a[15:8],  b[15:8]),  mul_low_u8(a[7:0],   b[7:0])};
      2'b01: simd_mul_low = {mul_low_u16(a[63:48], b[63:48]), mul_low_u16(a[47:32], b[47:32]),
                             mul_low_u16(a[31:16], b[31:16]), mul_low_u16(a[15:0],  b[15:0])};
      2'b10: simd_mul_low = {mul_low_u32(a[63:32], b[63:32]), mul_low_u32(a[31:0], b[31:0])};
      default: simd_mul_low = a * b;
    endcase
  end
endfunction

function [63:0] simd_mul_high;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  input        a_signed;
  input        b_signed;
  begin
    case(eew)
      2'b00: simd_mul_high = {mul_high_8(a[63:56], b[63:56], a_signed, b_signed),
                              mul_high_8(a[55:48], b[55:48], a_signed, b_signed),
                              mul_high_8(a[47:40], b[47:40], a_signed, b_signed),
                              mul_high_8(a[39:32], b[39:32], a_signed, b_signed),
                              mul_high_8(a[31:24], b[31:24], a_signed, b_signed),
                              mul_high_8(a[23:16], b[23:16], a_signed, b_signed),
                              mul_high_8(a[15:8],  b[15:8],  a_signed, b_signed),
                              mul_high_8(a[7:0],   b[7:0],   a_signed, b_signed)};
      2'b01: simd_mul_high = {mul_high_16(a[63:48], b[63:48], a_signed, b_signed),
                              mul_high_16(a[47:32], b[47:32], a_signed, b_signed),
                              mul_high_16(a[31:16], b[31:16], a_signed, b_signed),
                              mul_high_16(a[15:0],  b[15:0],  a_signed, b_signed)};
      2'b10: simd_mul_high = {mul_high_32(a[63:32], b[63:32], a_signed, b_signed),
                              mul_high_32(a[31:0],  b[31:0],  a_signed, b_signed)};
      default: simd_mul_high = mul_high_64(a, b, a_signed, b_signed);
    endcase
end
endfunction

function [63:0] simd_smul_round_sat;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_smul_round_sat = {smul_round_sat_8(a[63:56], b[63:56]),
                                    smul_round_sat_8(a[55:48], b[55:48]),
                                    smul_round_sat_8(a[47:40], b[47:40]),
                                    smul_round_sat_8(a[39:32], b[39:32]),
                                    smul_round_sat_8(a[31:24], b[31:24]),
                                    smul_round_sat_8(a[23:16], b[23:16]),
                                    smul_round_sat_8(a[15:8],  b[15:8]),
                                    smul_round_sat_8(a[7:0],   b[7:0])};
      2'b01: simd_smul_round_sat = {smul_round_sat_16(a[63:48], b[63:48]),
                                    smul_round_sat_16(a[47:32], b[47:32]),
                                    smul_round_sat_16(a[31:16], b[31:16]),
                                    smul_round_sat_16(a[15:0],  b[15:0])};
      2'b10: simd_smul_round_sat = {smul_round_sat_32(a[63:32], b[63:32]),
                                    smul_round_sat_32(a[31:0],  b[31:0])};
      default: simd_smul_round_sat = smul_round_sat_64(a, b);
    endcase
  end
endfunction

function [63:0] simd_sat_add_s;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sat_add_s = {sat_add_s8(a[63:56], b[63:56]), sat_add_s8(a[55:48], b[55:48]),
                               sat_add_s8(a[47:40], b[47:40]), sat_add_s8(a[39:32], b[39:32]),
                               sat_add_s8(a[31:24], b[31:24]), sat_add_s8(a[23:16], b[23:16]),
                               sat_add_s8(a[15:8],  b[15:8]),  sat_add_s8(a[7:0],   b[7:0])};
      2'b01: simd_sat_add_s = {sat_add_s16(a[63:48], b[63:48]), sat_add_s16(a[47:32], b[47:32]),
                               sat_add_s16(a[31:16], b[31:16]), sat_add_s16(a[15:0],  b[15:0])};
      2'b10: simd_sat_add_s = {sat_add_s32(a[63:32], b[63:32]), sat_add_s32(a[31:0], b[31:0])};
      default: simd_sat_add_s = sat_add_s64(a, b);
    endcase
  end
endfunction

function [63:0] simd_sat_sub_u;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sat_sub_u = {sat_sub_u8(a[63:56], b[63:56]), sat_sub_u8(a[55:48], b[55:48]),
                               sat_sub_u8(a[47:40], b[47:40]), sat_sub_u8(a[39:32], b[39:32]),
                               sat_sub_u8(a[31:24], b[31:24]), sat_sub_u8(a[23:16], b[23:16]),
                               sat_sub_u8(a[15:8],  b[15:8]),  sat_sub_u8(a[7:0],   b[7:0])};
      2'b01: simd_sat_sub_u = {sat_sub_u16(a[63:48], b[63:48]), sat_sub_u16(a[47:32], b[47:32]),
                               sat_sub_u16(a[31:16], b[31:16]), sat_sub_u16(a[15:0],  b[15:0])};
      2'b10: simd_sat_sub_u = {sat_sub_u32(a[63:32], b[63:32]), sat_sub_u32(a[31:0], b[31:0])};
      default: simd_sat_sub_u = sat_sub_u64(a, b);
    endcase
  end
endfunction

function [63:0] simd_sat_sub_s;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sat_sub_s = {sat_sub_s8(a[63:56], b[63:56]), sat_sub_s8(a[55:48], b[55:48]),
                               sat_sub_s8(a[47:40], b[47:40]), sat_sub_s8(a[39:32], b[39:32]),
                               sat_sub_s8(a[31:24], b[31:24]), sat_sub_s8(a[23:16], b[23:16]),
                               sat_sub_s8(a[15:8],  b[15:8]),  sat_sub_s8(a[7:0],   b[7:0])};
      2'b01: simd_sat_sub_s = {sat_sub_s16(a[63:48], b[63:48]), sat_sub_s16(a[47:32], b[47:32]),
                               sat_sub_s16(a[31:16], b[31:16]), sat_sub_s16(a[15:0],  b[15:0])};
      2'b10: simd_sat_sub_s = {sat_sub_s32(a[63:32], b[63:32]), sat_sub_s32(a[31:0], b[31:0])};
      default: simd_sat_sub_s = sat_sub_s64(a, b);
    endcase
  end
endfunction

function [63:0] simd_avg_add_s;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_avg_add_s = {avg_add_s8(a[63:56], b[63:56]), avg_add_s8(a[55:48], b[55:48]),
                               avg_add_s8(a[47:40], b[47:40]), avg_add_s8(a[39:32], b[39:32]),
                               avg_add_s8(a[31:24], b[31:24]), avg_add_s8(a[23:16], b[23:16]),
                               avg_add_s8(a[15:8],  b[15:8]),  avg_add_s8(a[7:0],   b[7:0])};
      2'b01: simd_avg_add_s = {avg_add_s16(a[63:48], b[63:48]), avg_add_s16(a[47:32], b[47:32]),
                               avg_add_s16(a[31:16], b[31:16]), avg_add_s16(a[15:0],  b[15:0])};
      2'b10: simd_avg_add_s = {avg_add_s32(a[63:32], b[63:32]), avg_add_s32(a[31:0], b[31:0])};
      default: simd_avg_add_s = avg_add_s64(a, b);
    endcase
  end
endfunction

function [63:0] simd_avg_sub_s;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_avg_sub_s = {avg_sub_s8(a[63:56], b[63:56]), avg_sub_s8(a[55:48], b[55:48]),
                               avg_sub_s8(a[47:40], b[47:40]), avg_sub_s8(a[39:32], b[39:32]),
                               avg_sub_s8(a[31:24], b[31:24]), avg_sub_s8(a[23:16], b[23:16]),
                               avg_sub_s8(a[15:8],  b[15:8]),  avg_sub_s8(a[7:0],   b[7:0])};
      2'b01: simd_avg_sub_s = {avg_sub_s16(a[63:48], b[63:48]), avg_sub_s16(a[47:32], b[47:32]),
                               avg_sub_s16(a[31:16], b[31:16]), avg_sub_s16(a[15:0],  b[15:0])};
      2'b10: simd_avg_sub_s = {avg_sub_s32(a[63:32], b[63:32]), avg_sub_s32(a[31:0], b[31:0])};
      default: simd_avg_sub_s = avg_sub_s64(a, b);
    endcase
  end
endfunction

function [63:0] simd_sll;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sll = {a[63:56] << b[58:56], a[55:48] << b[50:48],
                         a[47:40] << b[42:40], a[39:32] << b[34:32],
                         a[31:24] << b[26:24], a[23:16] << b[18:16],
                         a[15:8]  << b[10:8],  a[7:0]   << b[2:0]};
      2'b01: simd_sll = {a[63:48] << b[51:48], a[47:32] << b[35:32],
                         a[31:16] << b[19:16], a[15:0]  << b[3:0]};
      2'b10: simd_sll = {a[63:32] << b[36:32], a[31:0] << b[4:0]};
      default: simd_sll = a << b[5:0];
    endcase
  end
endfunction

function [63:0] simd_merge;
  input [63:0] vs2;
  input [63:0] vs1;
  input [63:0] mask;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_merge = {
        mask[7] ? vs1[63:56] : vs2[63:56],
        mask[6] ? vs1[55:48] : vs2[55:48],
        mask[5] ? vs1[47:40] : vs2[47:40],
        mask[4] ? vs1[39:32] : vs2[39:32],
        mask[3] ? vs1[31:24] : vs2[31:24],
        mask[2] ? vs1[23:16] : vs2[23:16],
        mask[1] ? vs1[15:8]  : vs2[15:8],
        mask[0] ? vs1[7:0]   : vs2[7:0]};
      2'b01: simd_merge = {
        mask[3] ? vs1[63:48] : vs2[63:48],
        mask[2] ? vs1[47:32] : vs2[47:32],
        mask[1] ? vs1[31:16] : vs2[31:16],
        mask[0] ? vs1[15:0]  : vs2[15:0]};
      2'b10: simd_merge = {
        mask[1] ? vs1[63:32] : vs2[63:32],
        mask[0] ? vs1[31:0]  : vs2[31:0]};
      default: simd_merge = mask[0] ? vs1[63:0] : vs2[63:0];
    endcase
  end
endfunction

function [63:0] simd_srl;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_srl = {a[63:56] >> b[58:56], a[55:48] >> b[50:48],
                         a[47:40] >> b[42:40], a[39:32] >> b[34:32],
                         a[31:24] >> b[26:24], a[23:16] >> b[18:16],
                         a[15:8]  >> b[10:8],  a[7:0]   >> b[2:0]};
      2'b01: simd_srl = {a[63:48] >> b[51:48], a[47:32] >> b[35:32],
                         a[31:16] >> b[19:16], a[15:0]  >> b[3:0]};
      2'b10: simd_srl = {a[63:32] >> b[36:32], a[31:0] >> b[4:0]};
      default: simd_srl = a >> b[5:0];
    endcase
  end
endfunction

function [63:0] simd_sra;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    case(eew)
      2'b00: simd_sra = {$signed(a[63:56]) >>> b[58:56], $signed(a[55:48]) >>> b[50:48],
                         $signed(a[47:40]) >>> b[42:40], $signed(a[39:32]) >>> b[34:32],
                         $signed(a[31:24]) >>> b[26:24], $signed(a[23:16]) >>> b[18:16],
                         $signed(a[15:8])  >>> b[10:8],  $signed(a[7:0])   >>> b[2:0]};
      2'b01: simd_sra = {$signed(a[63:48]) >>> b[51:48], $signed(a[47:32]) >>> b[35:32],
                         $signed(a[31:16]) >>> b[19:16], $signed(a[15:0])  >>> b[3:0]};
      2'b10: simd_sra = {$signed(a[63:32]) >>> b[36:32], $signed(a[31:0]) >>> b[4:0]};
      default: simd_sra = $signed(a) >>> b[5:0];
    endcase
  end
endfunction

function [63:0] simd_cmp_eq;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_eq = simd_cmp_common(a, b, eew, 3'd0);
  end
endfunction

function [63:0] simd_cmp_ne;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_ne = simd_cmp_common(a, b, eew, 3'd1);
  end
endfunction

function [63:0] simd_cmp_ltu;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_ltu = simd_cmp_common(a, b, eew, 3'd2);
  end
endfunction

function [63:0] simd_cmp_lt;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_lt = simd_cmp_common(a, b, eew, 3'd3);
  end
endfunction

function [63:0] simd_cmp_leu;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_leu = simd_cmp_common(a, b, eew, 3'd4);
  end
endfunction

function [63:0] simd_cmp_le;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  begin
    simd_cmp_le = simd_cmp_common(a, b, eew, 3'd5);
  end
endfunction

function [63:0] simd_cmp_common;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  input [2 :0] cmp_op;
  reg   [7 :0] mask;
  begin
    mask = 8'b0;
    case(eew)
      2'b00: begin
        mask[0] = cmp_lane8(a[7:0], b[7:0], cmp_op);
        mask[1] = cmp_lane8(a[15:8], b[15:8], cmp_op);
        mask[2] = cmp_lane8(a[23:16], b[23:16], cmp_op);
        mask[3] = cmp_lane8(a[31:24], b[31:24], cmp_op);
        mask[4] = cmp_lane8(a[39:32], b[39:32], cmp_op);
        mask[5] = cmp_lane8(a[47:40], b[47:40], cmp_op);
        mask[6] = cmp_lane8(a[55:48], b[55:48], cmp_op);
        mask[7] = cmp_lane8(a[63:56], b[63:56], cmp_op);
      end
      2'b01: begin
        mask[0] = cmp_lane16(a[15:0], b[15:0], cmp_op);
        mask[1] = cmp_lane16(a[31:16], b[31:16], cmp_op);
        mask[2] = cmp_lane16(a[47:32], b[47:32], cmp_op);
        mask[3] = cmp_lane16(a[63:48], b[63:48], cmp_op);
      end
      2'b10: begin
        mask[0] = cmp_lane32(a[31:0], b[31:0], cmp_op);
        mask[1] = cmp_lane32(a[63:32], b[63:32], cmp_op);
      end
      default: mask[0] = cmp_lane64(a, b, cmp_op);
    endcase
    simd_cmp_common = {56'b0, mask};
  end
endfunction

function cmp_lane8;
  input [7:0] a;
  input [7:0] b;
  input [2:0] op;
  begin
    case(op)
      3'd0: cmp_lane8 = (a == b);
      3'd1: cmp_lane8 = (a != b);
      3'd2: cmp_lane8 = (a < b);
      3'd3: cmp_lane8 = ($signed(a) < $signed(b));
      3'd4: cmp_lane8 = (a <= b);
      default: cmp_lane8 = ($signed(a) <= $signed(b));
    endcase
  end
endfunction

function cmp_lane16;
  input [15:0] a;
  input [15:0] b;
  input [2 :0] op;
  begin
    case(op)
      3'd0: cmp_lane16 = (a == b);
      3'd1: cmp_lane16 = (a != b);
      3'd2: cmp_lane16 = (a < b);
      3'd3: cmp_lane16 = ($signed(a) < $signed(b));
      3'd4: cmp_lane16 = (a <= b);
      default: cmp_lane16 = ($signed(a) <= $signed(b));
    endcase
  end
endfunction

function cmp_lane32;
  input [31:0] a;
  input [31:0] b;
  input [2 :0] op;
  begin
    case(op)
      3'd0: cmp_lane32 = (a == b);
      3'd1: cmp_lane32 = (a != b);
      3'd2: cmp_lane32 = (a < b);
      3'd3: cmp_lane32 = ($signed(a) < $signed(b));
      3'd4: cmp_lane32 = (a <= b);
      default: cmp_lane32 = ($signed(a) <= $signed(b));
    endcase
  end
endfunction

function cmp_lane64;
  input [63:0] a;
  input [63:0] b;
  input [2 :0] op;
  begin
    case(op)
      3'd0: cmp_lane64 = (a == b);
      3'd1: cmp_lane64 = (a != b);
      3'd2: cmp_lane64 = (a < b);
      3'd3: cmp_lane64 = ($signed(a) < $signed(b));
      3'd4: cmp_lane64 = (a <= b);
      default: cmp_lane64 = ($signed(a) <= $signed(b));
    endcase
  end
endfunction

function [63:0] simd_minmax;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] eew;
  input        is_signed;
  input        is_max;
  begin
    case(eew)
      2'b00: simd_minmax = {
        minmax8(a[63:56], b[63:56], is_signed, is_max),
        minmax8(a[55:48], b[55:48], is_signed, is_max),
        minmax8(a[47:40], b[47:40], is_signed, is_max),
        minmax8(a[39:32], b[39:32], is_signed, is_max),
        minmax8(a[31:24], b[31:24], is_signed, is_max),
        minmax8(a[23:16], b[23:16], is_signed, is_max),
        minmax8(a[15:8],  b[15:8],  is_signed, is_max),
        minmax8(a[7:0],   b[7:0],   is_signed, is_max)};
      2'b01: simd_minmax = {
        minmax16(a[63:48], b[63:48], is_signed, is_max),
        minmax16(a[47:32], b[47:32], is_signed, is_max),
        minmax16(a[31:16], b[31:16], is_signed, is_max),
        minmax16(a[15:0],  b[15:0],  is_signed, is_max)};
      2'b10: simd_minmax = {
        minmax32(a[63:32], b[63:32], is_signed, is_max),
        minmax32(a[31:0],  b[31:0],  is_signed, is_max)};
      default: simd_minmax = minmax64(a, b, is_signed, is_max);
    endcase
  end
endfunction

function [7:0] minmax8;
  input [7:0] a;
  input [7:0] b;
  input       is_signed;
  input       is_max;
  reg         take_b;
  begin
    take_b = is_signed ? (is_max ? ($signed(b) > $signed(a)) : ($signed(b) < $signed(a)))
                       : (is_max ? (b > a) : (b < a));
    minmax8 = take_b ? b : a;
  end
endfunction

function [15:0] minmax16;
  input [15:0] a;
  input [15:0] b;
  input        is_signed;
  input        is_max;
  reg          take_b;
  begin
    take_b = is_signed ? (is_max ? ($signed(b) > $signed(a)) : ($signed(b) < $signed(a)))
                       : (is_max ? (b > a) : (b < a));
    minmax16 = take_b ? b : a;
  end
endfunction

function [31:0] minmax32;
  input [31:0] a;
  input [31:0] b;
  input        is_signed;
  input        is_max;
  reg          take_b;
  begin
    take_b = is_signed ? (is_max ? ($signed(b) > $signed(a)) : ($signed(b) < $signed(a)))
                       : (is_max ? (b > a) : (b < a));
    minmax32 = take_b ? b : a;
  end
endfunction

function [63:0] minmax64;
  input [63:0] a;
  input [63:0] b;
  input        is_signed;
  input        is_max;
  reg          take_b;
  begin
    take_b = is_signed ? (is_max ? ($signed(b) > $signed(a)) : ($signed(b) < $signed(a)))
                       : (is_max ? (b > a) : (b < a));
    minmax64 = take_b ? b : a;
  end
endfunction

function [7:0] sat_add_u8;
  input [7:0] a;
  input [7:0] b;
  reg   [8:0] sum;
  begin
    sum = {1'b0, a} + {1'b0, b};
    sat_add_u8 = sum[8] ? 8'hff : sum[7:0];
  end
endfunction

function [15:0] sat_add_u16;
  input [15:0] a;
  input [15:0] b;
  reg   [16:0] sum;
  begin
    sum = {1'b0, a} + {1'b0, b};
    sat_add_u16 = sum[16] ? 16'hffff : sum[15:0];
  end
endfunction

function [31:0] sat_add_u32;
  input [31:0] a;
  input [31:0] b;
  reg   [32:0] sum;
  begin
    sum = {1'b0, a} + {1'b0, b};
    sat_add_u32 = sum[32] ? 32'hffff_ffff : sum[31:0];
  end
endfunction

function [63:0] sat_add_u64;
  input [63:0] a;
  input [63:0] b;
  reg   [64:0] sum;
  begin
    sum = {1'b0, a} + {1'b0, b};
    sat_add_u64 = sum[64] ? 64'hffff_ffff_ffff_ffff : sum[63:0];
  end
endfunction

function [7:0] sat_sub_u8;
  input [7:0] a;
  input [7:0] b;
  begin
    sat_sub_u8 = (a < b) ? 8'h00 : a - b;
  end
endfunction

function [15:0] sat_sub_u16;
  input [15:0] a;
  input [15:0] b;
  begin
    sat_sub_u16 = (a < b) ? 16'h0000 : a - b;
  end
endfunction

function [31:0] sat_sub_u32;
  input [31:0] a;
  input [31:0] b;
  begin
    sat_sub_u32 = (a < b) ? 32'h0000_0000 : a - b;
  end
endfunction

function [63:0] sat_sub_u64;
  input [63:0] a;
  input [63:0] b;
  begin
    sat_sub_u64 = (a < b) ? 64'h0000_0000_0000_0000 : a - b;
  end
endfunction

function [7:0] sat_add_s8;
  input [7:0] a;
  input [7:0] b;
  reg   [7:0] sum;
  begin
    sum = a + b;
    if(!a[7] && !b[7] && sum[7])
      sat_add_s8 = 8'h7f;
    else if(a[7] && b[7] && !sum[7])
      sat_add_s8 = 8'h80;
    else
      sat_add_s8 = sum;
  end
endfunction

function [15:0] sat_add_s16;
  input [15:0] a;
  input [15:0] b;
  reg   [15:0] sum;
  begin
    sum = a + b;
    if(!a[15] && !b[15] && sum[15])
      sat_add_s16 = 16'h7fff;
    else if(a[15] && b[15] && !sum[15])
      sat_add_s16 = 16'h8000;
    else
      sat_add_s16 = sum;
  end
endfunction

function [31:0] sat_add_s32;
  input [31:0] a;
  input [31:0] b;
  reg   [31:0] sum;
  begin
    sum = a + b;
    if(!a[31] && !b[31] && sum[31])
      sat_add_s32 = 32'h7fff_ffff;
    else if(a[31] && b[31] && !sum[31])
      sat_add_s32 = 32'h8000_0000;
    else
      sat_add_s32 = sum;
  end
endfunction

function [63:0] sat_add_s64;
  input [63:0] a;
  input [63:0] b;
  reg   [63:0] sum;
  begin
    sum = a + b;
    if(!a[63] && !b[63] && sum[63])
      sat_add_s64 = 64'h7fff_ffff_ffff_ffff;
    else if(a[63] && b[63] && !sum[63])
      sat_add_s64 = 64'h8000_0000_0000_0000;
    else
      sat_add_s64 = sum;
  end
endfunction

function [7:0] sat_sub_s8;
  input [7:0] a;
  input [7:0] b;
  reg   [7:0] diff;
  begin
    diff = a - b;
    if(!a[7] && b[7] && diff[7])
      sat_sub_s8 = 8'h7f;
    else if(a[7] && !b[7] && !diff[7])
      sat_sub_s8 = 8'h80;
    else
      sat_sub_s8 = diff;
  end
endfunction

function [15:0] sat_sub_s16;
  input [15:0] a;
  input [15:0] b;
  reg   [15:0] diff;
  begin
    diff = a - b;
    if(!a[15] && b[15] && diff[15])
      sat_sub_s16 = 16'h7fff;
    else if(a[15] && !b[15] && !diff[15])
      sat_sub_s16 = 16'h8000;
    else
      sat_sub_s16 = diff;
  end
endfunction

function [31:0] sat_sub_s32;
  input [31:0] a;
  input [31:0] b;
  reg   [31:0] diff;
  begin
    diff = a - b;
    if(!a[31] && b[31] && diff[31])
      sat_sub_s32 = 32'h7fff_ffff;
    else if(a[31] && !b[31] && !diff[31])
      sat_sub_s32 = 32'h8000_0000;
    else
      sat_sub_s32 = diff;
  end
endfunction

function [63:0] sat_sub_s64;
  input [63:0] a;
  input [63:0] b;
  reg   [63:0] diff;
  begin
    diff = a - b;
    if(!a[63] && b[63] && diff[63])
      sat_sub_s64 = 64'h7fff_ffff_ffff_ffff;
    else if(a[63] && !b[63] && !diff[63])
      sat_sub_s64 = 64'h8000_0000_0000_0000;
    else
      sat_sub_s64 = diff;
  end
endfunction

function [7:0] avg_add_s8;
  input [7:0] a;
  input [7:0] b;
  reg signed [8:0] sum;
  begin
    sum = $signed({a[7], a}) + $signed({b[7], b}) + 9'sd1;
    sum = sum >>> 1;
    avg_add_s8 = sum[7:0];
  end
endfunction

function [15:0] avg_add_s16;
  input [15:0] a;
  input [15:0] b;
  reg signed [16:0] sum;
  begin
    sum = $signed({a[15], a}) + $signed({b[15], b}) + 17'sd1;
    sum = sum >>> 1;
    avg_add_s16 = sum[15:0];
  end
endfunction

function [31:0] avg_add_s32;
  input [31:0] a;
  input [31:0] b;
  reg signed [32:0] sum;
  begin
    sum = $signed({a[31], a}) + $signed({b[31], b}) + 33'sd1;
    sum = sum >>> 1;
    avg_add_s32 = sum[31:0];
  end
endfunction

function [63:0] avg_add_s64;
  input [63:0] a;
  input [63:0] b;
  reg signed [64:0] sum;
  begin
    sum = $signed({a[63], a}) + $signed({b[63], b}) + 65'sd1;
    sum = sum >>> 1;
    avg_add_s64 = sum[63:0];
  end
endfunction

function [7:0] avg_sub_s8;
  input [7:0] a;
  input [7:0] b;
  reg signed [8:0] diff;
  begin
    diff = $signed({a[7], a}) - $signed({b[7], b}) + 9'sd1;
    diff = diff >>> 1;
    avg_sub_s8 = diff[7:0];
  end
endfunction

function [15:0] avg_sub_s16;
  input [15:0] a;
  input [15:0] b;
  reg signed [16:0] diff;
  begin
    diff = $signed({a[15], a}) - $signed({b[15], b}) + 17'sd1;
    diff = diff >>> 1;
    avg_sub_s16 = diff[15:0];
  end
endfunction

function [31:0] avg_sub_s32;
  input [31:0] a;
  input [31:0] b;
  reg signed [32:0] diff;
  begin
    diff = $signed({a[31], a}) - $signed({b[31], b}) + 33'sd1;
    diff = diff >>> 1;
    avg_sub_s32 = diff[31:0];
  end
endfunction

function [63:0] avg_sub_s64;
  input [63:0] a;
  input [63:0] b;
  reg signed [64:0] diff;
  begin
    diff = $signed({a[63], a}) - $signed({b[63], b}) + 65'sd1;
    diff = diff >>> 1;
    avg_sub_s64 = diff[63:0];
end
endfunction

function [7:0] mul_low_u8;
  input [7:0] a;
  input [7:0] b;
  reg [15:0] prod;
begin
  prod = a * b;
  mul_low_u8 = prod[7:0];
end
endfunction

function [15:0] mul_low_u16;
  input [15:0] a;
  input [15:0] b;
  reg [31:0] prod;
begin
  prod = a * b;
  mul_low_u16 = prod[15:0];
end
endfunction

function [31:0] mul_low_u32;
  input [31:0] a;
  input [31:0] b;
  reg [63:0] prod;
begin
  prod = a * b;
  mul_low_u32 = prod[31:0];
end
endfunction

function [7:0] mul_high_8;
  input [7:0] a;
  input [7:0] b;
  input       a_signed;
  input       b_signed;
  reg signed [15:0] prod_s;
  reg        [15:0] prod_u;
begin
  prod_s = (a_signed ? $signed(a) : $signed({1'b0, a}))
         * (b_signed ? $signed(b) : $signed({1'b0, b}));
  prod_u = a * b;
  mul_high_8 = (a_signed || b_signed) ? prod_s[15:8] : prod_u[15:8];
end
endfunction

function [15:0] mul_high_16;
  input [15:0] a;
  input [15:0] b;
  input        a_signed;
  input        b_signed;
  reg signed [31:0] prod_s;
  reg        [31:0] prod_u;
begin
  prod_s = (a_signed ? $signed(a) : $signed({1'b0, a}))
         * (b_signed ? $signed(b) : $signed({1'b0, b}));
  prod_u = a * b;
  mul_high_16 = (a_signed || b_signed) ? prod_s[31:16] : prod_u[31:16];
end
endfunction

function [31:0] mul_high_32;
  input [31:0] a;
  input [31:0] b;
  input        a_signed;
  input        b_signed;
  reg signed [63:0] prod_s;
  reg        [63:0] prod_u;
begin
  prod_s = (a_signed ? $signed(a) : $signed({1'b0, a}))
         * (b_signed ? $signed(b) : $signed({1'b0, b}));
  prod_u = a * b;
  mul_high_32 = (a_signed || b_signed) ? prod_s[63:32] : prod_u[63:32];
end
endfunction

function [63:0] mul_high_64;
  input [63:0] a;
  input [63:0] b;
  input        a_signed;
  input        b_signed;
  reg signed [127:0] prod_s;
  reg        [127:0] prod_u;
begin
  prod_s = (a_signed ? $signed(a) : $signed({1'b0, a}))
         * (b_signed ? $signed(b) : $signed({1'b0, b}));
  prod_u = a * b;
  mul_high_64 = (a_signed || b_signed) ? prod_s[127:64] : prod_u[127:64];
end
endfunction

function [7:0] smul_round_sat_8;
  input [7:0] a;
  input [7:0] b;
  reg signed [15:0] prod;
  reg signed [16:0] rnd;
begin
  prod = $signed(a) * $signed(b);
  rnd = $signed({prod[15], prod}) + 17'sd64;
  rnd = rnd >>> 7;
  smul_round_sat_8 = (a == 8'h80 && b == 8'h80) ? 8'h7f : rnd[7:0];
end
endfunction

function [15:0] smul_round_sat_16;
  input [15:0] a;
  input [15:0] b;
  reg signed [31:0] prod;
  reg signed [32:0] rnd;
begin
  prod = $signed(a) * $signed(b);
  rnd = $signed({prod[31], prod}) + 33'sd16384;
  rnd = rnd >>> 15;
  smul_round_sat_16 = (a == 16'h8000 && b == 16'h8000) ? 16'h7fff : rnd[15:0];
end
endfunction

function [31:0] smul_round_sat_32;
  input [31:0] a;
  input [31:0] b;
  reg signed [63:0] prod;
  reg signed [64:0] rnd;
begin
  prod = $signed(a) * $signed(b);
  rnd = $signed({prod[63], prod}) + 65'sd1073741824;
  rnd = rnd >>> 31;
  smul_round_sat_32 = (a == 32'h80000000 && b == 32'h80000000) ? 32'h7fffffff : rnd[31:0];
end
endfunction

function [63:0] smul_round_sat_64;
  input [63:0] a;
  input [63:0] b;
  reg signed [127:0] prod;
  reg signed [128:0] rnd;
begin
  prod = $signed(a) * $signed(b);
  rnd = $signed({prod[127], prod}) + 129'sd4611686018427387904;
  rnd = rnd >>> 63;
  smul_round_sat_64 = (a == 64'h8000000000000000 && b == 64'h8000000000000000)
                    ? 64'h7fffffffffffffff : rnd[63:0];
end
endfunction

endmodule
