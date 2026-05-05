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
//              RVV 1.0 Integer Reduction Data Path
//==========================================================

module ct_freduct_dp(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_eu_sel,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_iid,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  ex1_pipedown,
  ex2_pipedown,
  ex3_pipedown,
  forever_cpuclk,
  freduct_forward_r_vld,
  freduct_forward_result,
  pad_yy_icg_scan_en
);

input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [11:0]  dp_vfalu_ex1_pipex_eu_sel;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [6 :0]  dp_vfalu_ex1_pipex_iid;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input           ex1_pipedown;
input           ex2_pipedown;
input           ex3_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          freduct_forward_r_vld;
output  [63:0]  freduct_forward_result;

parameter VREDAND   = 18'h00018;
parameter VREDORR   = 18'h00028;
parameter VREDXOR   = 18'h00048;
parameter VREDSUM   = 18'h00080;
parameter VREDMAXU  = 18'h00100;
parameter VREDMAX   = 18'h00500;
parameter VREDMINU  = 18'h00200;
parameter VREDMIN   = 18'h00600;
parameter VWREDSUMU = 18'h00880;
parameter VWREDSUM  = 18'h00c80;

reg     [63:0]  freduct_ex2_result;
reg     [63:0]  freduct_ex3_result;
reg     [63:0]  reduct_accum;
reg     [17:0]  prev_func_op;
reg     [6 :0]  prev_iid;
reg     [1 :0]  prev_sew;
reg             prev_vld;

wire    [17:0]  func_op;
wire    [1 :0]  sew;
wire            new_stream;
wire            op_vredand;
wire            op_vredorr;
wire            op_vredxor;
wire            op_vredsum;
wire            op_vredmaxu;
wire            op_vredmax;
wire            op_vredminu;
wire            op_vredmin;
wire            op_vwredsumu;
wire            op_vwredsum;
wire            signed_op;
wire            widen_op;
wire    [63:0]  seed_value;
wire    [63:0]  accum_in;
wire    [63:0]  ex1_result;

assign func_op[17:0] = dp_vfalu_ex1_pipex_func[17:0];
assign sew[1:0]      = dp_vfalu_ex1_pipex_func[19:18];
assign new_stream    = !prev_vld
                    || (prev_iid[6:0] != dp_vfalu_ex1_pipex_iid[6:0])
                    || (prev_func_op[17:0] != func_op[17:0])
                    || (prev_sew[1:0] != sew[1:0]);

assign op_vredand   = (func_op[17:0] == VREDAND);
assign op_vredorr   = (func_op[17:0] == VREDORR);
assign op_vredxor   = (func_op[17:0] == VREDXOR);
assign op_vredsum   = (func_op[17:0] == VREDSUM);
assign op_vredmaxu  = (func_op[17:0] == VREDMAXU);
assign op_vredmax   = (func_op[17:0] == VREDMAX);
assign op_vredminu  = (func_op[17:0] == VREDMINU);
assign op_vredmin   = (func_op[17:0] == VREDMIN);
assign op_vwredsumu = (func_op[17:0] == VWREDSUMU);
assign op_vwredsum  = (func_op[17:0] == VWREDSUM);

assign signed_op = op_vredmax || op_vredmin || op_vwredsum;
assign widen_op  = op_vwredsumu || op_vwredsum;
assign seed_value[63:0] = get_elem(dp_vfalu_ex1_pipex_srcf1[63:0], 3'b0, widen_op ? next_sew(sew[1:0]) : sew[1:0]);
assign accum_in[63:0]   = new_stream ? seed_value[63:0] : reduct_accum[63:0];
assign ex1_result[63:0] = reduce_slice(dp_vfalu_ex1_pipex_srcf0[63:0],
                                       accum_in[63:0],
                                       sew[1:0],
                                       func_op[17:0],
                                       signed_op,
                                       widen_op);

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    reduct_accum[63:0]  <= 64'b0;
    prev_func_op[17:0]  <= 18'b0;
    prev_iid[6:0]       <= 7'b0;
    prev_sew[1:0]       <= 2'b0;
    prev_vld            <= 1'b0;
  end
  else if(ex1_pipedown)
  begin
    reduct_accum[63:0]  <= ex1_result[63:0];
    prev_func_op[17:0]  <= func_op[17:0];
    prev_iid[6:0]       <= dp_vfalu_ex1_pipex_iid[6:0];
    prev_sew[1:0]       <= sew[1:0];
    prev_vld            <= 1'b1;
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    freduct_ex2_result[63:0] <= 64'b0;
  else if(ex1_pipedown)
    freduct_ex2_result[63:0] <= ex1_result[63:0];
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    freduct_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    freduct_ex3_result[63:0] <= freduct_ex2_result[63:0];
end

assign freduct_forward_result[63:0] = freduct_ex3_result[63:0];
assign freduct_forward_r_vld        = ex3_pipedown;

function [1:0] next_sew;
  input [1:0] sew;
  begin
    case(sew[1:0])
      2'b00: next_sew[1:0] = 2'b01;
      2'b01: next_sew[1:0] = 2'b10;
      default: next_sew[1:0] = 2'b11;
    endcase
  end
endfunction

function [3:0] elems_per_slice;
  input [1:0] sew;
  begin
    case(sew[1:0])
      2'b00: elems_per_slice[3:0] = 4'd8;
      2'b01: elems_per_slice[3:0] = 4'd4;
      2'b10: elems_per_slice[3:0] = 4'd2;
      default: elems_per_slice[3:0] = 4'd1;
    endcase
  end
endfunction

function [63:0] reduce_slice;
  input [63:0] src;
  input [63:0] accum;
  input [1 :0] sew;
  input [17:0] func_op;
  input        signed_op;
  input        widen_op;
  reg   [63:0] result;
  reg   [1 :0] out_sew;
  integer i;
  integer elems;
  begin
    result = accum[63:0];
    out_sew = widen_op ? next_sew(sew[1:0]) : sew[1:0];
    elems = elems_per_slice(sew[1:0]);
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems)
        result = reduce_elem(result[63:0],
                             get_elem(src[63:0], i[2:0], sew[1:0]),
                             out_sew[1:0],
                             func_op[17:0],
                             signed_op,
                             widen_op);
    end
    reduce_slice[63:0] = set_elem(64'b0, result[63:0], 3'b0, out_sew[1:0]);
  end
endfunction

function [63:0] reduce_elem;
  input [63:0] accum;
  input [63:0] elem;
  input [1 :0] sew;
  input [17:0] func_op;
  input        signed_op;
  input        widen_op;
  reg   [63:0] ext_elem;
  begin
    ext_elem[63:0] = widen_op ? extend_elem(elem[63:0], prev_narrow_sew(sew[1:0]), signed_op)
                              : elem[63:0];
    case(func_op[17:0])
      VREDAND:   reduce_elem[63:0] = accum[63:0] & ext_elem[63:0];
      VREDORR:   reduce_elem[63:0] = accum[63:0] | ext_elem[63:0];
      VREDXOR:   reduce_elem[63:0] = accum[63:0] ^ ext_elem[63:0];
      VREDMAXU:  reduce_elem[63:0] = elem_gt(accum, ext_elem, sew, 1'b0) ? accum : ext_elem;
      VREDMAX:   reduce_elem[63:0] = elem_gt(accum, ext_elem, sew, 1'b1) ? accum : ext_elem;
      VREDMINU:  reduce_elem[63:0] = elem_lt(accum, ext_elem, sew, 1'b0) ? accum : ext_elem;
      VREDMIN:   reduce_elem[63:0] = elem_lt(accum, ext_elem, sew, 1'b1) ? accum : ext_elem;
      default:   reduce_elem[63:0] = elem_add(accum, ext_elem, sew);
    endcase
  end
endfunction

function [1:0] prev_narrow_sew;
  input [1:0] sew;
  begin
    case(sew[1:0])
      2'b01: prev_narrow_sew[1:0] = 2'b00;
      2'b10: prev_narrow_sew[1:0] = 2'b01;
      default: prev_narrow_sew[1:0] = 2'b10;
    endcase
  end
endfunction

function [63:0] elem_add;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] sew;
  begin
    case(sew[1:0])
      2'b00: elem_add[63:0] = {56'b0, a[7:0] + b[7:0]};
      2'b01: elem_add[63:0] = {48'b0, a[15:0] + b[15:0]};
      2'b10: elem_add[63:0] = {32'b0, a[31:0] + b[31:0]};
      default: elem_add[63:0] = a[63:0] + b[63:0];
    endcase
  end
endfunction

function elem_gt;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] sew;
  input        signed_op;
  begin
    case(sew[1:0])
      2'b00: elem_gt = signed_op ? ($signed(a[7:0]) > $signed(b[7:0])) : (a[7:0] > b[7:0]);
      2'b01: elem_gt = signed_op ? ($signed(a[15:0]) > $signed(b[15:0])) : (a[15:0] > b[15:0]);
      2'b10: elem_gt = signed_op ? ($signed(a[31:0]) > $signed(b[31:0])) : (a[31:0] > b[31:0]);
      default: elem_gt = signed_op ? ($signed(a[63:0]) > $signed(b[63:0])) : (a[63:0] > b[63:0]);
    endcase
  end
endfunction

function elem_lt;
  input [63:0] a;
  input [63:0] b;
  input [1 :0] sew;
  input        signed_op;
  begin
    case(sew[1:0])
      2'b00: elem_lt = signed_op ? ($signed(a[7:0]) < $signed(b[7:0])) : (a[7:0] < b[7:0]);
      2'b01: elem_lt = signed_op ? ($signed(a[15:0]) < $signed(b[15:0])) : (a[15:0] < b[15:0]);
      2'b10: elem_lt = signed_op ? ($signed(a[31:0]) < $signed(b[31:0])) : (a[31:0] < b[31:0]);
      default: elem_lt = signed_op ? ($signed(a[63:0]) < $signed(b[63:0])) : (a[63:0] < b[63:0]);
    endcase
  end
endfunction

function [63:0] extend_elem;
  input [63:0] elem;
  input [1 :0] sew;
  input        signed_op;
  begin
    case(sew[1:0])
      2'b00: extend_elem[63:0] = signed_op ? {{56{elem[7]}}, elem[7:0]} : {56'b0, elem[7:0]};
      2'b01: extend_elem[63:0] = signed_op ? {{48{elem[15]}}, elem[15:0]} : {48'b0, elem[15:0]};
      2'b10: extend_elem[63:0] = signed_op ? {{32{elem[31]}}, elem[31:0]} : {32'b0, elem[31:0]};
      default: extend_elem[63:0] = elem[63:0];
    endcase
  end
endfunction

function [63:0] get_elem;
  input [63:0] data;
  input [2 :0] idx;
  input [1 :0] sew;
  begin
    case(sew[1:0])
      2'b00: get_elem[63:0] = {56'b0, get8(data[63:0], idx[2:0])};
      2'b01: get_elem[63:0] = {48'b0, get16(data[63:0], idx[1:0])};
      2'b10: get_elem[63:0] = {32'b0, get32(data[63:0], idx[0])};
      default: get_elem[63:0] = data[63:0];
    endcase
  end
endfunction

function [63:0] set_elem;
  input [63:0] base;
  input [63:0] elem;
  input [2 :0] idx;
  input [1 :0] sew;
  reg   [63:0] result;
  begin
    result[63:0] = base[63:0];
    case(sew[1:0])
      2'b00:
        case(idx[2:0])
          3'd0: result[7 :0 ] = elem[7:0];
          3'd1: result[15:8 ] = elem[7:0];
          3'd2: result[23:16] = elem[7:0];
          3'd3: result[31:24] = elem[7:0];
          3'd4: result[39:32] = elem[7:0];
          3'd5: result[47:40] = elem[7:0];
          3'd6: result[55:48] = elem[7:0];
          default: result[63:56] = elem[7:0];
        endcase
      2'b01:
        case(idx[1:0])
          2'd0: result[15:0 ] = elem[15:0];
          2'd1: result[31:16] = elem[15:0];
          2'd2: result[47:32] = elem[15:0];
          default: result[63:48] = elem[15:0];
        endcase
      2'b10:
        if(idx[0])
          result[63:32] = elem[31:0];
        else
          result[31:0] = elem[31:0];
      default:
        result[63:0] = elem[63:0];
    endcase
    set_elem[63:0] = result[63:0];
  end
endfunction

function [7:0] get8;
  input [63:0] data;
  input [2 :0] idx;
  begin
    case(idx[2:0])
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
  input [1 :0] idx;
  begin
    case(idx[1:0])
      2'd0: get16[15:0] = data[15:0 ];
      2'd1: get16[15:0] = data[31:16];
      2'd2: get16[15:0] = data[47:32];
      default: get16[15:0] = data[63:48];
    endcase
  end
endfunction

function [31:0] get32;
  input [63:0] data;
  input        idx;
  begin
    get32[31:0] = idx ? data[63:32] : data[31:0];
  end
endfunction

endmodule
