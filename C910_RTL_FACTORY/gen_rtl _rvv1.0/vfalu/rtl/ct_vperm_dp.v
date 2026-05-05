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
//              RVV 1.0 VPERM Data Path
//==========================================================
// Element-level implementation for the 64-bit VFALU slice.  P2 state keeps
// one previous slice and a small compress carry so slide/gather/compress can
// cross the local 64-bit slice boundary while preserving the existing pipe.

module ct_vperm_dp(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_iid,
  dp_vfalu_ex1_pipex_imm0,
  dp_vfalu_ex1_pipex_mask,
  dp_vfalu_ex1_pipex_mtvr_src0,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  dp_vfalu_ex1_pipex_srcf2,
  dp_vfalu_ex1_pipex_vimm,
  dp_vfalu_ex1_pipex_vimm_vld,
  ex1_pipedown,
  ex2_pipedown,
  ex3_pipedown,
  ex4_pipedown,
  forever_cpuclk,
  pad_yy_icg_scan_en,
  vperm_forward_r_vld,
  vperm_forward_result,
  vperm_mfvr_data
);

input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [6 :0]  dp_vfalu_ex1_pipex_iid;
input   [2 :0]  dp_vfalu_ex1_pipex_imm0;
input   [63:0]  dp_vfalu_ex1_pipex_mask;
input   [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input   [63:0]  dp_vfalu_ex1_pipex_srcf2;
input   [4 :0]  dp_vfalu_ex1_pipex_vimm;
input           dp_vfalu_ex1_pipex_vimm_vld;
input           ex1_pipedown;
input           ex2_pipedown;
input           ex3_pipedown;
input           ex4_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          vperm_forward_r_vld;
output  [63:0]  vperm_forward_result;
output  [63:0]  vperm_mfvr_data;

parameter VEXT        = 18'h00001;
parameter VSLIDEUP    = 18'h00048;
parameter VSLIDEDOWN  = 18'h00028;
parameter VSLIDE1UP   = 18'h00050;
parameter VSLIDE1DOWN = 18'h00030;
parameter VRGATHERVV  = 18'h00008;
parameter VRGATHERVK  = 18'h04008;
parameter VCOMPRESS   = 18'h0000c;

reg     [63:0]  vperm_ex2_result;
reg     [63:0]  vperm_ex3_result;
reg     [63:0]  vperm_ex4_result;
reg     [63:0]  prev_src0;
reg     [17:0]  prev_func_op;
reg     [6 :0]  prev_iid;
reg     [1 :0]  prev_sew;
reg             prev_vld;
reg     [63:0]  compress_carry;
reg     [3 :0]  compress_carry_cnt;

wire    [17:0]  func_op;
wire    [1 :0]  sew;
wire    [3 :0]  elem_cnt;
wire    [5 :0]  scalar_index;
wire            new_stream;
wire            op_vext;
wire            op_vslideup;
wire            op_vslidedown;
wire            op_vslide1up;
wire            op_vslide1down;
wire            op_vrgathervv;
wire            op_vrgathervk;
wire            op_vcompress;
wire    [63:0]  prev_src0_for_calc;
wire    [63:0]  compress_result_next;
wire    [63:0]  compress_carry_next;
wire    [3 :0]  compress_carry_cnt_next;
wire    [63:0]  ex1_result;

assign func_op[17:0] = dp_vfalu_ex1_pipex_func[17:0];
assign sew[1:0]      = dp_vfalu_ex1_pipex_func[19:18];
assign elem_cnt[3:0] = elems_per_slice(sew[1:0]);
assign scalar_index[5:0] = dp_vfalu_ex1_pipex_vimm_vld
                         ? {1'b0, dp_vfalu_ex1_pipex_vimm[4:0]}
                         : dp_vfalu_ex1_pipex_mtvr_src0[5:0];

assign op_vext        = (func_op[17:0] == VEXT);
assign op_vslideup    = (func_op[17:0] == VSLIDEUP);
assign op_vslidedown  = (func_op[17:0] == VSLIDEDOWN);
assign op_vslide1up   = (func_op[17:0] == VSLIDE1UP);
assign op_vslide1down = (func_op[17:0] == VSLIDE1DOWN);
assign op_vrgathervv  = (func_op[17:0] == VRGATHERVV);
assign op_vrgathervk  = (func_op[17:0] == VRGATHERVK);
assign op_vcompress   = (func_op[17:0] == VCOMPRESS);

assign new_stream = !prev_vld
                  || (prev_iid[6:0] != dp_vfalu_ex1_pipex_iid[6:0])
                  || (prev_func_op[17:0] != func_op[17:0])
                  || (prev_sew[1:0] != sew[1:0]);
assign prev_src0_for_calc[63:0] = new_stream ? 64'b0 : prev_src0[63:0];

assign compress_result_next[63:0] =
  compress_pack(dp_vfalu_ex1_pipex_srcf0[63:0],
                dp_vfalu_ex1_pipex_mask[63:0],
                new_stream ? 64'b0 : compress_carry[63:0],
                new_stream ? 4'b0  : compress_carry_cnt[3:0],
                sew[1:0]);
assign compress_carry_next[63:0] =
  compress_tail(dp_vfalu_ex1_pipex_srcf0[63:0],
                dp_vfalu_ex1_pipex_mask[63:0],
                new_stream ? 64'b0 : compress_carry[63:0],
                new_stream ? 4'b0  : compress_carry_cnt[3:0],
                sew[1:0]);
assign compress_carry_cnt_next[3:0] =
  compress_tail_count(dp_vfalu_ex1_pipex_srcf0[63:0],
                      dp_vfalu_ex1_pipex_mask[63:0],
                      new_stream ? 4'b0 : compress_carry_cnt[3:0],
                      sew[1:0]);

assign ex1_result[63:0] =
    ({64{op_vext}}        & extract_scalar(dp_vfalu_ex1_pipex_srcf0[63:0],
                                           scalar_index[5:0], sew[1:0])) |
    ({64{op_vslideup}}    & slideup_cross(dp_vfalu_ex1_pipex_srcf0[63:0],
                                          prev_src0_for_calc[63:0],
                                          scalar_index[5:0], sew[1:0],
                                          64'b0)) |
    ({64{op_vslidedown}}  & slidedown_cross(dp_vfalu_ex1_pipex_srcf0[63:0],
                                            prev_src0_for_calc[63:0],
                                            scalar_index[5:0], sew[1:0],
                                            64'b0)) |
    ({64{op_vslide1up}}   & slideup_cross(dp_vfalu_ex1_pipex_srcf0[63:0],
                                          prev_src0_for_calc[63:0],
                                          6'd1, sew[1:0],
                                          dp_vfalu_ex1_pipex_mtvr_src0[63:0])) |
    ({64{op_vslide1down}} & slidedown_cross(dp_vfalu_ex1_pipex_srcf0[63:0],
                                            prev_src0_for_calc[63:0],
                                            6'd1, sew[1:0],
                                            dp_vfalu_ex1_pipex_mtvr_src0[63:0])) |
    ({64{op_vrgathervv}}  & gather_vv_window(dp_vfalu_ex1_pipex_srcf0[63:0],
                                             prev_src0_for_calc[63:0],
                                             dp_vfalu_ex1_pipex_srcf1[63:0],
                                             sew[1:0])) |
    ({64{op_vrgathervk}}  & gather_scalar_window(dp_vfalu_ex1_pipex_srcf0[63:0],
                                                 prev_src0_for_calc[63:0],
                                                 scalar_index[5:0],
                                                 sew[1:0])) |
    ({64{op_vcompress}}   & compress_result_next[63:0]);

assign vperm_mfvr_data[63:0] = ex1_result[63:0];

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    prev_src0[63:0]        <= 64'b0;
    prev_func_op[17:0]     <= 18'b0;
    prev_iid[6:0]          <= 7'b0;
    prev_sew[1:0]          <= 2'b0;
    prev_vld               <= 1'b0;
    compress_carry[63:0]   <= 64'b0;
    compress_carry_cnt[3:0]<= 4'b0;
  end
  else if(ex1_pipedown)
  begin
    prev_src0[63:0]        <= dp_vfalu_ex1_pipex_srcf0[63:0];
    prev_func_op[17:0]     <= func_op[17:0];
    prev_iid[6:0]          <= dp_vfalu_ex1_pipex_iid[6:0];
    prev_sew[1:0]          <= sew[1:0];
    prev_vld               <= 1'b1;
    if(op_vcompress)
    begin
      compress_carry[63:0]    <= compress_carry_next[63:0];
      compress_carry_cnt[3:0] <= compress_carry_cnt_next[3:0];
    end
    else if(new_stream)
    begin
      compress_carry[63:0]    <= 64'b0;
      compress_carry_cnt[3:0] <= 4'b0;
    end
  end
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vperm_ex2_result[63:0] <= 64'b0;
  else if(ex1_pipedown)
    vperm_ex2_result[63:0] <= ex1_result[63:0];
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vperm_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    vperm_ex3_result[63:0] <= vperm_ex2_result[63:0];
end

always @(posedge forever_cpuclk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vperm_ex4_result[63:0] <= 64'b0;
  else if(ex3_pipedown)
    vperm_ex4_result[63:0] <= vperm_ex3_result[63:0];
end

assign vperm_forward_result[63:0] = vperm_ex4_result[63:0];
assign vperm_forward_r_vld        = ex4_pipedown;

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

function [63:0] extract_scalar;
  input [63:0] src;
  input [5 :0] idx;
  input [1 :0] sew;
  begin
    if(idx[5:0] < elems_per_slice(sew[1:0]))
      extract_scalar[63:0] = get_elem(src[63:0], idx[2:0], sew[1:0]);
    else
      extract_scalar[63:0] = 64'b0;
  end
endfunction

function [63:0] slideup_cross;
  input [63:0] cur_src;
  input [63:0] prev_src;
  input [5 :0] offset;
  input [1 :0] sew;
  input [63:0] scalar_fill;
  reg   [63:0] result;
  integer i;
  integer src_idx;
  integer elems;
  begin
    result = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems)
      begin
        if(offset[5:0] == 6'd1 && i == 0)
          result = set_elem(result, scalar_fill, i[2:0], sew);
        else
        begin
          src_idx = i - offset;
          if(src_idx >= 0)
            result = set_elem(result, get_elem(cur_src, src_idx[2:0], sew), i[2:0], sew);
          else if((src_idx + elems) >= 0)
            result = set_elem(result, get_elem(prev_src, (src_idx + elems) & 3'h7, sew), i[2:0], sew);
        end
      end
    end
    slideup_cross[63:0] = result[63:0];
  end
endfunction

function [63:0] slidedown_cross;
  input [63:0] cur_src;
  input [63:0] prev_src;
  input [5 :0] offset;
  input [1 :0] sew;
  input [63:0] scalar_fill;
  reg   [63:0] result;
  integer i;
  integer src_idx;
  integer elems;
  begin
    result = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems)
      begin
        src_idx = i + offset;
        if(src_idx < elems)
          result = set_elem(result, get_elem(cur_src, src_idx[2:0], sew), i[2:0], sew);
        else if(offset[5:0] == 6'd1 && i == (elems - 1))
          result = set_elem(result, scalar_fill, i[2:0], sew);
        else if((src_idx - elems) < elems)
          result = set_elem(result, get_elem(prev_src, (src_idx - elems) & 3'h7, sew), i[2:0], sew);
      end
    end
    slidedown_cross[63:0] = result[63:0];
  end
endfunction

function [63:0] gather_vv_window;
  input [63:0] cur_src;
  input [63:0] prev_src;
  input [63:0] index_src;
  input [1 :0] sew;
  reg   [63:0] result;
  integer i;
  integer idx;
  integer elems;
  begin
    result = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems)
      begin
        idx = get_elem(index_src, i[2:0], sew);
        if(idx < elems)
          result = set_elem(result, get_elem(cur_src, idx[2:0], sew), i[2:0], sew);
        else if((idx - elems) < elems)
          result = set_elem(result, get_elem(prev_src, (idx - elems) & 3'h7, sew), i[2:0], sew);
      end
    end
    gather_vv_window[63:0] = result[63:0];
  end
endfunction

function [63:0] gather_scalar_window;
  input [63:0] cur_src;
  input [63:0] prev_src;
  input [5 :0] index;
  input [1 :0] sew;
  reg   [63:0] result;
  integer i;
  integer elems;
  begin
    result = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems)
      begin
        if(index < elems)
          result = set_elem(result, get_elem(cur_src, index[2:0], sew), i[2:0], sew);
        else if((index - elems) < elems)
          result = set_elem(result, get_elem(prev_src, (index - elems) & 3'h7, sew), i[2:0], sew);
      end
    end
    gather_scalar_window[63:0] = result[63:0];
  end
endfunction

function [63:0] compress_pack;
  input [63:0] src;
  input [63:0] mask;
  input [63:0] carry;
  input [3 :0] carry_cnt;
  input [1 :0] sew;
  reg   [63:0] result;
  integer i;
  integer out_idx;
  integer elems;
  begin
    result = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    out_idx = 0;
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < carry_cnt && i < elems)
      begin
        result = set_elem(result, get_elem(carry, i[2:0], sew), out_idx[2:0], sew);
        out_idx = out_idx + 1;
      end
    end
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems && elem_mask_bit(mask, i[2:0], sew) && out_idx < elems)
      begin
        result = set_elem(result, get_elem(src, i[2:0], sew), out_idx[2:0], sew);
        out_idx = out_idx + 1;
      end
    end
    compress_pack[63:0] = result[63:0];
  end
endfunction

function [63:0] compress_tail;
  input [63:0] src;
  input [63:0] mask;
  input [63:0] carry;
  input [3 :0] carry_cnt;
  input [1 :0] sew;
  reg   [63:0] tail;
  integer i;
  integer stream_idx;
  integer tail_idx;
  integer elems;
  begin
    tail = 64'b0;
    elems = elems_per_slice(sew[1:0]);
    stream_idx = 0;
    tail_idx = 0;
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < carry_cnt)
      begin
        if(stream_idx >= elems)
        begin
          tail = set_elem(tail, get_elem(carry, i[2:0], sew), tail_idx[2:0], sew);
          tail_idx = tail_idx + 1;
        end
        stream_idx = stream_idx + 1;
      end
    end
    for(i = 0; i < 8; i = i + 1)
    begin
      if(i < elems && elem_mask_bit(mask, i[2:0], sew))
      begin
        if(stream_idx >= elems)
        begin
          tail = set_elem(tail, get_elem(src, i[2:0], sew), tail_idx[2:0], sew);
          tail_idx = tail_idx + 1;
        end
        stream_idx = stream_idx + 1;
      end
    end
    compress_tail[63:0] = tail[63:0];
  end
endfunction

function [3:0] compress_tail_count;
  input [63:0] src;
  input [63:0] mask;
  input [3 :0] carry_cnt;
  input [1 :0] sew;
  integer i;
  integer selected;
  integer elems;
  begin
    elems = elems_per_slice(sew[1:0]);
    selected = carry_cnt;
    for(i = 0; i < 8; i = i + 1)
      if(i < elems && elem_mask_bit(mask, i[2:0], sew))
        selected = selected + 1;
    if(selected > elems)
      compress_tail_count[3:0] = selected - elems;
    else
      compress_tail_count[3:0] = 4'b0;
  end
endfunction

function elem_mask_bit;
  input [63:0] mask;
  input [2 :0] idx;
  input [1 :0] sew;
  begin
    elem_mask_bit = mask[idx];
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
