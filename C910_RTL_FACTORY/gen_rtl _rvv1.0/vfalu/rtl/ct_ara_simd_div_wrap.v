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
//              RVV SIMD Integer Divide Wrapper
//==========================================================
// One element is completed per cycle.  The 64-bit vector slice is injected
// back into the existing pipe6 VFDSU-like writeback path when all elements
// in the slice have completed.

module ct_ara_simd_div_wrap(
  cpurst_b,
  ctrl_ex1_pipe6_eu_sel,
  ctrl_ex1_pipe6_inst_vld,
  dp_vfalu_ex1_pipe6_func,
  dp_vfalu_ex1_pipe6_imm0,
  dp_vfalu_ex1_pipe6_mtvr_src0,
  dp_vfalu_ex1_pipe6_srcf0,
  dp_vfalu_ex1_pipe6_srcf1,
  dp_vfdsu_ex1_pipe6_dst_vreg,
  forever_cpuclk,
  rtu_yy_xx_flush,
  vdivu_vfpu_ex1_pipe6_dst_vreg,
  vdivu_vfpu_ex1_pipe6_result,
  vdivu_vfpu_ex1_pipe6_result_vld,
  vdivu_vfpu_pipe6_req_for_bubble,
  vdivu_vfpu_pipe6_vdiv_busy
);

input           cpurst_b;
input   [11:0]  ctrl_ex1_pipe6_eu_sel;
input           ctrl_ex1_pipe6_inst_vld;
input   [19:0]  dp_vfalu_ex1_pipe6_func;
input   [2 :0]  dp_vfalu_ex1_pipe6_imm0;
input   [63:0]  dp_vfalu_ex1_pipe6_mtvr_src0;
input   [63:0]  dp_vfalu_ex1_pipe6_srcf0;
input   [63:0]  dp_vfalu_ex1_pipe6_srcf1;
input   [6 :0]  dp_vfdsu_ex1_pipe6_dst_vreg;
input           forever_cpuclk;
input           rtu_yy_xx_flush;
output  [6 :0]  vdivu_vfpu_ex1_pipe6_dst_vreg;
output  [63:0]  vdivu_vfpu_ex1_pipe6_result;
output          vdivu_vfpu_ex1_pipe6_result_vld;
output          vdivu_vfpu_pipe6_req_for_bubble;
output          vdivu_vfpu_pipe6_vdiv_busy;

parameter IDLE  = 2'b00;
parameter RUN   = 2'b01;
parameter WB    = 2'b10;

parameter OP_VDIVU = 18'h00010;
parameter OP_VDIV  = 18'h00050;
parameter OP_VREMU = 18'h00020;
parameter OP_VREM  = 18'h00060;

reg     [1 :0]  div_state;
reg     [1 :0]  div_sew;
reg     [2 :0]  div_elem_idx;
reg     [2 :0]  div_elem_last;
reg     [6 :0]  div_dst_vreg;
reg     [17:0]  div_func_op;
reg     [63:0]  div_src0;
reg     [63:0]  div_src1;
reg     [63:0]  div_result;
reg             div_result_vld;

wire    [17:0]  start_func_op;
wire    [1 :0]  start_sew;
wire            start_op_vdivu;
wire            start_op_vdiv;
wire            start_op_vremu;
wire            start_op_vrem;
wire            start_op_vld;
wire            start_opvx;
wire    [63:0]  start_src1;
wire            div_signed;
wire            div_rem;
wire    [63:0]  div_elem_result;

assign start_func_op[17:0] = dp_vfalu_ex1_pipe6_func[17:0];
assign start_sew[1:0]      = dp_vfalu_ex1_pipe6_func[19:18];
assign start_op_vdivu      = (start_func_op[17:0] == OP_VDIVU);
assign start_op_vdiv       = (start_func_op[17:0] == OP_VDIV);
assign start_op_vremu      = (start_func_op[17:0] == OP_VREMU);
assign start_op_vrem       = (start_func_op[17:0] == OP_VREM);
assign start_op_vld        = ctrl_ex1_pipe6_inst_vld
                           && ctrl_ex1_pipe6_eu_sel[11]
                           && (div_state[1:0] == IDLE)
                           && (start_op_vdivu || start_op_vdiv
                               || start_op_vremu || start_op_vrem);
assign start_opvx          = (dp_vfalu_ex1_pipe6_imm0[2:0] == 3'b100)
                          || (dp_vfalu_ex1_pipe6_imm0[2:0] == 3'b110);
assign start_src1[63:0]    = start_opvx
                            ? scalar_bcast(dp_vfalu_ex1_pipe6_mtvr_src0[63:0],
                                           start_sew[1:0])
                            : dp_vfalu_ex1_pipe6_srcf1[63:0];

assign div_signed          = (div_func_op[17:0] == OP_VDIV)
                          || (div_func_op[17:0] == OP_VREM);
assign div_rem             = (div_func_op[17:0] == OP_VREMU)
                          || (div_func_op[17:0] == OP_VREM);
assign div_elem_result[63:0] = calc_elem(div_src0[63:0],
                                         div_src1[63:0],
                                         div_elem_idx[2:0],
                                         div_sew[1:0],
                                         div_signed,
                                         div_rem);

assign vdivu_vfpu_ex1_pipe6_dst_vreg[6:0] = div_dst_vreg[6:0];
assign vdivu_vfpu_ex1_pipe6_result[63:0]  = div_result[63:0];
assign vdivu_vfpu_ex1_pipe6_result_vld    = div_result_vld;
assign vdivu_vfpu_pipe6_req_for_bubble    = div_result_vld;
assign vdivu_vfpu_pipe6_vdiv_busy         = (div_state[1:0] != IDLE)
                                          || start_op_vld;

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    div_state[1:0]      <= IDLE;
    div_sew[1:0]        <= 2'b0;
    div_elem_idx[2:0]   <= 3'b0;
    div_elem_last[2:0]  <= 3'b0;
    div_dst_vreg[6:0]   <= 7'b0;
    div_func_op[17:0]   <= 18'b0;
    div_src0[63:0]      <= 64'b0;
    div_src1[63:0]      <= 64'b0;
    div_result[63:0]    <= 64'b0;
    div_result_vld      <= 1'b0;
  end
  else if(rtu_yy_xx_flush)
  begin
    div_state[1:0]      <= IDLE;
    div_result_vld      <= 1'b0;
  end
  else
  begin
    div_result_vld <= 1'b0;
    case(div_state[1:0])
      IDLE:
      begin
        if(start_op_vld)
        begin
          div_state[1:0]      <= RUN;
          div_sew[1:0]        <= start_sew[1:0];
          div_elem_idx[2:0]   <= 3'b0;
          div_elem_last[2:0]  <= elem_last(start_sew[1:0]);
          div_dst_vreg[6:0]   <= dp_vfdsu_ex1_pipe6_dst_vreg[6:0];
          div_func_op[17:0]   <= start_func_op[17:0];
          div_src0[63:0]      <= dp_vfalu_ex1_pipe6_srcf0[63:0];
          div_src1[63:0]      <= start_src1[63:0];
          div_result[63:0]    <= 64'b0;
        end
      end
      RUN:
      begin
        div_result[63:0] <= insert_elem(div_result[63:0],
                                        div_elem_result[63:0],
                                        div_elem_idx[2:0],
                                        div_sew[1:0]);
        if(div_elem_idx[2:0] == div_elem_last[2:0])
        begin
          div_state[1:0] <= WB;
          div_result_vld <= 1'b1;
        end
        else
          div_elem_idx[2:0] <= div_elem_idx[2:0] + 3'b001;
      end
      WB:
      begin
        div_state[1:0] <= IDLE;
      end
      default:
      begin
        div_state[1:0] <= IDLE;
      end
    endcase
  end
end

function [2:0] elem_last;
  input [1:0] sew;
  begin
    case(sew[1:0])
      2'b00: elem_last[2:0] = 3'd7;
      2'b01: elem_last[2:0] = 3'd3;
      2'b10: elem_last[2:0] = 3'd1;
      default: elem_last[2:0] = 3'd0;
    endcase
  end
endfunction

function [63:0] scalar_bcast;
  input [63:0] scalar;
  input [1 :0] sew;
  begin
    case(sew[1:0])
      2'b00: scalar_bcast[63:0] = {8{scalar[7:0]}};
      2'b01: scalar_bcast[63:0] = {4{scalar[15:0]}};
      2'b10: scalar_bcast[63:0] = {2{scalar[31:0]}};
      default: scalar_bcast[63:0] = scalar[63:0];
    endcase
  end
endfunction

function [63:0] calc_elem;
  input [63:0] src0;
  input [63:0] src1;
  input [2 :0] elem_idx;
  input [1 :0] sew;
  input        signed_op;
  input        rem_op;
  begin
    case(sew[1:0])
      2'b00: calc_elem[63:0] = {56'b0,
                                divrem8(get8(src0[63:0], elem_idx[2:0]),
                                        get8(src1[63:0], elem_idx[2:0]),
                                        signed_op, rem_op)};
      2'b01: calc_elem[63:0] = {48'b0,
                                divrem16(get16(src0[63:0], elem_idx[1:0]),
                                         get16(src1[63:0], elem_idx[1:0]),
                                         signed_op, rem_op)};
      2'b10: calc_elem[63:0] = {32'b0,
                                divrem32(get32(src0[63:0], elem_idx[0]),
                                         get32(src1[63:0], elem_idx[0]),
                                         signed_op, rem_op)};
      default: calc_elem[63:0] = divrem64(src0[63:0], src1[63:0],
                                          signed_op, rem_op);
    endcase
  end
endfunction

function [63:0] insert_elem;
  input [63:0] base;
  input [63:0] elem;
  input [2 :0] elem_idx;
  input [1 :0] sew;
  reg   [63:0] result;
  begin
    result[63:0] = base[63:0];
    case(sew[1:0])
      2'b00:
      begin
        case(elem_idx[2:0])
          3'd0: result[7 :0 ] = elem[7:0];
          3'd1: result[15:8 ] = elem[7:0];
          3'd2: result[23:16] = elem[7:0];
          3'd3: result[31:24] = elem[7:0];
          3'd4: result[39:32] = elem[7:0];
          3'd5: result[47:40] = elem[7:0];
          3'd6: result[55:48] = elem[7:0];
          default: result[63:56] = elem[7:0];
        endcase
      end
      2'b01:
      begin
        case(elem_idx[1:0])
          2'd0: result[15:0 ] = elem[15:0];
          2'd1: result[31:16] = elem[15:0];
          2'd2: result[47:32] = elem[15:0];
          default: result[63:48] = elem[15:0];
        endcase
      end
      2'b10:
      begin
        if(elem_idx[0])
          result[63:32] = elem[31:0];
        else
          result[31:0]  = elem[31:0];
      end
      default:
      begin
        result[63:0] = elem[63:0];
      end
    endcase
    insert_elem[63:0] = result[63:0];
  end
endfunction

function [7:0] get8;
  input [63:0] data;
  input [2 :0] elem_idx;
  begin
    case(elem_idx[2:0])
      3'd0: get8[7:0] = data[7 :0 ];
      3'd1: get8[7:0] = data[15:8 ];
      3'd2: get8[7:0] = data[23:16];
      3'd3: get8[7:0] = data[31:24];
      3'd4: get8[7:0] = data[39:32];
      3'd5: get8[7:0] = data[47:40];
      3'd6: get8[7:0] = data[55:48];
      default: get8[7:0] = data[63:56];
    endcase
  end
endfunction

function [15:0] get16;
  input [63:0] data;
  input [1 :0] elem_idx;
  begin
    case(elem_idx[1:0])
      2'd0: get16[15:0] = data[15:0 ];
      2'd1: get16[15:0] = data[31:16];
      2'd2: get16[15:0] = data[47:32];
      default: get16[15:0] = data[63:48];
    endcase
  end
endfunction

function [31:0] get32;
  input [63:0] data;
  input        elem_idx;
  begin
    if(elem_idx)
      get32[31:0] = data[63:32];
    else
      get32[31:0] = data[31:0];
  end
endfunction

function [7:0] divrem8;
  input [7:0] src0;
  input [7:0] src1;
  input       signed_op;
  input       rem_op;
  reg signed [7:0] src0_s;
  reg signed [7:0] src1_s;
  begin
    src0_s = src0[7:0];
    src1_s = src1[7:0];
    if(src1[7:0] == 8'b0)
      divrem8[7:0] = rem_op ? src0[7:0] : 8'hff;
    else if(signed_op && (src0[7:0] == 8'h80) && (src1[7:0] == 8'hff))
      divrem8[7:0] = rem_op ? 8'b0 : src0[7:0];
    else if(signed_op)
      divrem8[7:0] = rem_op ? (src0_s % src1_s) : (src0_s / src1_s);
    else
      divrem8[7:0] = rem_op ? (src0[7:0] % src1[7:0])
                             : (src0[7:0] / src1[7:0]);
  end
endfunction

function [15:0] divrem16;
  input [15:0] src0;
  input [15:0] src1;
  input        signed_op;
  input        rem_op;
  reg signed [15:0] src0_s;
  reg signed [15:0] src1_s;
  begin
    src0_s = src0[15:0];
    src1_s = src1[15:0];
    if(src1[15:0] == 16'b0)
      divrem16[15:0] = rem_op ? src0[15:0] : 16'hffff;
    else if(signed_op && (src0[15:0] == 16'h8000) && (src1[15:0] == 16'hffff))
      divrem16[15:0] = rem_op ? 16'b0 : src0[15:0];
    else if(signed_op)
      divrem16[15:0] = rem_op ? (src0_s % src1_s) : (src0_s / src1_s);
    else
      divrem16[15:0] = rem_op ? (src0[15:0] % src1[15:0])
                               : (src0[15:0] / src1[15:0]);
  end
endfunction

function [31:0] divrem32;
  input [31:0] src0;
  input [31:0] src1;
  input        signed_op;
  input        rem_op;
  reg signed [31:0] src0_s;
  reg signed [31:0] src1_s;
  begin
    src0_s = src0[31:0];
    src1_s = src1[31:0];
    if(src1[31:0] == 32'b0)
      divrem32[31:0] = rem_op ? src0[31:0] : 32'hffff_ffff;
    else if(signed_op && (src0[31:0] == 32'h8000_0000)
            && (src1[31:0] == 32'hffff_ffff))
      divrem32[31:0] = rem_op ? 32'b0 : src0[31:0];
    else if(signed_op)
      divrem32[31:0] = rem_op ? (src0_s % src1_s) : (src0_s / src1_s);
    else
      divrem32[31:0] = rem_op ? (src0[31:0] % src1[31:0])
                               : (src0[31:0] / src1[31:0]);
  end
endfunction

function [63:0] divrem64;
  input [63:0] src0;
  input [63:0] src1;
  input        signed_op;
  input        rem_op;
  reg signed [63:0] src0_s;
  reg signed [63:0] src1_s;
  begin
    src0_s = src0[63:0];
    src1_s = src1[63:0];
    if(src1[63:0] == 64'b0)
      divrem64[63:0] = rem_op ? src0[63:0] : 64'hffff_ffff_ffff_ffff;
    else if(signed_op && (src0[63:0] == 64'h8000_0000_0000_0000)
            && (src1[63:0] == 64'hffff_ffff_ffff_ffff))
      divrem64[63:0] = rem_op ? 64'b0 : src0[63:0];
    else if(signed_op)
      divrem64[63:0] = rem_op ? (src0_s % src1_s) : (src0_s / src1_s);
    else
      divrem64[63:0] = rem_op ? (src0[63:0] % src1[63:0])
                               : (src0[63:0] / src1[63:0]);
  end
endfunction

endmodule
