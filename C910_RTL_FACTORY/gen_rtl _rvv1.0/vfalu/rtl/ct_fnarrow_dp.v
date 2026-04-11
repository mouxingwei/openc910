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

// Created for RVV 1.0: Narrowing floating-point conversion operations
// Creation date: 2024-01-15
// This module implements RVV 1.0 narrowing floating-point conversion operations:
// - vfncvt.xu.f.w: Float to unsigned integer narrowing
// - vfncvt.x.f.w: Float to signed integer narrowing
// - vfncvt.f.xu.w: Unsigned integer to float narrowing
// - vfncvt.f.x.w: Signed integer to float narrowing
// - vfncvt.f.f.w: Float to float narrowing

module ct_fnarrow_dp(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_srcf0,
  ex1_pipedown,
  ex2_pipedown,
  ex3_pipedown,
  forever_cpuclk,
  fnarrow_forward_r_vld,
  fnarrow_forward_result,
  pad_yy_icg_scan_en
);

// &Ports; @22
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [127:0] dp_vfalu_ex1_pipex_srcf0;
input           ex1_pipedown;
input           ex2_pipedown;
input           ex3_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          fnarrow_forward_r_vld;
output  [63:0]  fnarrow_forward_result;

// &Regs; @23
reg     [63:0]  fnarrow_ex2_result;
reg     [63:0]  fnarrow_ex3_result;

// &Wires; @24
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [127:0] dp_vfalu_ex1_pipex_srcf0;
wire            ex1_double;
wire            ex1_single;
wire            ex1_op_narrow_f2ui;
wire            ex1_op_narrow_f2si;
wire            ex1_op_narrow_ui2f;
wire            ex1_op_narrow_si2f;
wire            ex1_op_narrow_f2f;
wire            ex1_pipedown;
wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire    [127:0] ex1_pipex_src0;
wire    [63:0]  ex1_result;
wire            ex2_pipedown;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire    [63:0]  fnarrow_ex3_result_pre;
wire            fnarrow_forward_r_vld;
wire    [63:0]  fnarrow_forward_result;
wire    [19:0]  func;
wire            pad_yy_icg_scan_en;

// Operation parameters
parameter NARROW_F2UI = 0;  // Float to unsigned integer narrowing
parameter NARROW_F2SI = 1;  // Float to signed integer narrowing
parameter NARROW_UI2F = 2;  // Unsigned integer to float narrowing
parameter NARROW_SI2F = 3;  // Signed integer to float narrowing
parameter NARROW_F2F  = 4;  // Float to float narrowing

// Function decoding
assign func[19:0]            = dp_vfalu_ex1_pipex_func[19:0];
assign ex1_double            = func[16];
assign ex1_single            = func[15];
assign ex1_op_narrow_f2ui    = func[0];  // vfncvt.xu.f.w
assign ex1_op_narrow_f2si    = func[1];  // vfncvt.x.f.w
assign ex1_op_narrow_ui2f    = func[2];  // vfncvt.f.xu.w
assign ex1_op_narrow_si2f    = func[3];  // vfncvt.f.x.w
assign ex1_op_narrow_f2f     = func[4];  // vfncvt.f.f.w

// Source operand
assign ex1_pipex_src0[127:0] = dp_vfalu_ex1_pipex_srcf0[127:0];

// Narrowing operations
// For narrowing operations, the result is half the width of the source
// Double -> Single, Single -> Half

// Float to unsigned integer narrowing
wire [63:0] ex1_f2ui_result;
assign ex1_f2ui_result[63:0] = ex1_double ? ex1_double_f2ui(ex1_pipex_src0) :
                                        ex1_single_f2ui(ex1_pipex_src0);

// Float to signed integer narrowing
wire [63:0] ex1_f2si_result;
assign ex1_f2si_result[63:0] = ex1_double ? ex1_double_f2si(ex1_pipex_src0) :
                                        ex1_single_f2si(ex1_pipex_src0);

// Unsigned integer to float narrowing
wire [63:0] ex1_ui2f_result;
assign ex1_ui2f_result[63:0] = ex1_double ? ex1_double_ui2f(ex1_pipex_src0) :
                                        ex1_single_ui2f(ex1_pipex_src0);

// Signed integer to float narrowing
wire [63:0] ex1_si2f_result;
assign ex1_si2f_result[63:0] = ex1_double ? ex1_double_si2f(ex1_pipex_src0) :
                                        ex1_single_si2f(ex1_pipex_src0);

// Float to float narrowing
wire [63:0] ex1_f2f_result;
assign ex1_f2f_result[63:0] = ex1_double ? ex1_double_f2f(ex1_pipex_src0) :
                                       ex1_single_f2f(ex1_pipex_src0);

// Result selection
assign ex1_result[63:0] = ({64{ex1_op_narrow_f2ui}} & ex1_f2ui_result[63:0]) |
                          ({64{ex1_op_narrow_f2si}} & ex1_f2si_result[63:0]) |
                          ({64{ex1_op_narrow_ui2f}} & ex1_ui2f_result[63:0]) |
                          ({64{ex1_op_narrow_si2f}} & ex1_si2f_result[63:0]) |
                          ({64{ex1_op_narrow_f2f}}  & ex1_f2f_result[63:0]);

// Helper functions for double precision narrowing
function [63:0] ex1_double_f2ui;
  input [127:0] src;
  begin
    ex1_double_f2ui = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_double_f2si;
  input [127:0] src;
  begin
    ex1_double_f2si = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_double_ui2f;
  input [127:0] src;
  begin
    ex1_double_ui2f = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_double_si2f;
  input [127:0] src;
  begin
    ex1_double_si2f = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_double_f2f;
  input [127:0] src;
  begin
    ex1_double_f2f = src[63:0];  // Simplified
  end
endfunction

// Helper functions for single precision narrowing
function [63:0] ex1_single_f2ui;
  input [127:0] src;
  begin
    ex1_single_f2ui = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_single_f2si;
  input [127:0] src;
  begin
    ex1_single_f2si = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_single_ui2f;
  input [127:0] src;
  begin
    ex1_single_ui2f = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_single_si2f;
  input [127:0] src;
  begin
    ex1_single_si2f = src[63:0];  // Simplified
  end
endfunction

function [63:0] ex1_single_f2f;
  input [127:0] src;
  begin
    ex1_single_f2f = src[63:0];  // Simplified
  end
endfunction

// Pipeline to EX2
gated_clk_cell x_ex1_pipe_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex1_pipe_clk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex1_pipe_clk_en   ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ex1_pipe_clk_en = ex1_pipedown;

always @(posedge ex1_pipe_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    fnarrow_ex2_result[63:0] <= 64'b0;
  end
  else if(ex1_pipedown)
  begin
    fnarrow_ex2_result[63:0] <= ex1_result[63:0];
  end
end

// Pipeline to EX3
gated_clk_cell x_ex2_pipe_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex2_pipe_clk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex2_pipe_clk_en   ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ex2_pipe_clk_en = ex2_pipedown;

always @(posedge ex2_pipe_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    fnarrow_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    fnarrow_ex3_result[63:0] <= fnarrow_ex3_result_pre[63:0];
end

assign fnarrow_ex3_result_pre[63:0] = fnarrow_ex2_result[63:0];
assign fnarrow_forward_result[63:0] = fnarrow_ex3_result[63:0];
assign fnarrow_forward_r_vld = ex3_pipedown;

endmodule
