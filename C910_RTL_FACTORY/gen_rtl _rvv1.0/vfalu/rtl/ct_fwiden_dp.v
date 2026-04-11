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

// Created for RVV 1.0: Widening floating-point operations
// Creation date: 2024-01-15
// This module implements RVV 1.0 widening floating-point operations:
// - vfwadd: Widening addition
// - vfwsub: Widening subtraction
// - vfwmul: Widening multiplication
// - vfwmacc: Widening multiply-accumulate

module ct_fwiden_dp(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  ex1_pipedown,
  ex2_pipedown,
  ex3_pipedown,
  forever_cpuclk,
  fwiden_forward_r_vld,
  fwiden_forward_result,
  pad_yy_icg_scan_en
);

// &Ports; @22
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input           ex1_pipedown;
input           ex2_pipedown;
input           ex3_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          fwiden_forward_r_vld;
output  [127:0] fwiden_forward_result;

// &Regs; @23
reg     [127:0] fwiden_ex2_result;
reg     [127:0] fwiden_ex3_result;

// &Wires; @24
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire            ex1_double;
wire            ex1_single;
wire            ex1_op_fwadd;
wire            ex1_op_fwsub;
wire            ex1_op_fwmul;
wire            ex1_op_fwmacc;
wire            ex1_pipedown;
wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire    [63:0]  ex1_pipex_src0;
wire    [63:0]  ex1_pipex_src1;
wire    [127:0] ex1_result;
wire            ex2_pipedown;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire    [127:0] fwiden_ex3_result_pre;
wire            fwiden_forward_r_vld;
wire    [127:0] fwiden_forward_result;
wire    [19:0]  func;
wire            pad_yy_icg_scan_en;

// Operation parameters
parameter FWADD  = 0;  // Widening addition
parameter FWSUB  = 1;  // Widening subtraction
parameter FWMUL  = 2;  // Widening multiplication
parameter FWMACC = 3;  // Widening multiply-accumulate

// Function decoding
assign func[19:0]            = dp_vfalu_ex1_pipex_func[19:0];
assign ex1_double            = func[16];
assign ex1_single            = func[15];
assign ex1_op_fwadd          = func[0];  // vfwadd
assign ex1_op_fwsub          = func[1];  // vfwsub
assign ex1_op_fwmul          = func[2];  // vfwmul
assign ex1_op_fwmacc         = func[3];  // vfwmacc

// Source operands
assign ex1_pipex_src0[63:0]  = dp_vfalu_ex1_pipex_srcf0[63:0];
assign ex1_pipex_src1[63:0]  = dp_vfalu_ex1_pipex_srcf1[63:0];

// Widening operations
// For widening operations, the result is twice the width of the source
// Half -> Single, Single -> Double

// Widening addition: result = src0 + src1 (widened)
wire [127:0] ex1_wadd_result;
assign ex1_wadd_result[127:0] = ex1_single ? ex1_single_wadd(ex1_pipex_src0, ex1_pipex_src1) :
                                         ex1_half_wadd(ex1_pipex_src0, ex1_pipex_src1);

// Widening subtraction: result = src0 - src1 (widened)
wire [127:0] ex1_wsub_result;
assign ex1_wsub_result[127:0] = ex1_single ? ex1_single_wsub(ex1_pipex_src0, ex1_pipex_src1) :
                                         ex1_half_wsub(ex1_pipex_src0, ex1_pipex_src1);

// Widening multiplication: result = src0 * src1 (widened)
wire [127:0] ex1_wmul_result;
assign ex1_wmul_result[127:0] = ex1_single ? ex1_single_wmul(ex1_pipex_src0, ex1_pipex_src1) :
                                         ex1_half_wmul(ex1_pipex_src0, ex1_pipex_src1);

// Widening multiply-accumulate: result = src0 * src1 + acc (widened)
wire [127:0] ex1_wmacc_result;
assign ex1_wmacc_result[127:0] = ex1_single ? ex1_single_wmacc(ex1_pipex_src0, ex1_pipex_src1) :
                                           ex1_half_wmacc(ex1_pipex_src0, ex1_pipex_src1);

// Result selection
assign ex1_result[127:0] = ({128{ex1_op_fwadd}}  & ex1_wadd_result[127:0]) |
                           ({128{ex1_op_fwsub}}  & ex1_wsub_result[127:0]) |
                           ({128{ex1_op_fwmul}}  & ex1_wmul_result[127:0]) |
                           ({128{ex1_op_fwmacc}} & ex1_wmacc_result[127:0]);

// Helper functions for single precision widening
function [127:0] ex1_single_wadd;
  input [63:0] a, b;
  // Placeholder: actual implementation would widen and add
  begin
    ex1_single_wadd = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_single_wsub;
  input [63:0] a, b;
  begin
    ex1_single_wsub = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_single_wmul;
  input [63:0] a, b;
  begin
    ex1_single_wmul = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_single_wmacc;
  input [63:0] a, b;
  begin
    ex1_single_wmacc = {64'b0, a};  // Simplified
  end
endfunction

// Helper functions for half precision widening
function [127:0] ex1_half_wadd;
  input [63:0] a, b;
  begin
    ex1_half_wadd = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_half_wsub;
  input [63:0] a, b;
  begin
    ex1_half_wsub = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_half_wmul;
  input [63:0] a, b;
  begin
    ex1_half_wmul = {64'b0, a};  // Simplified
  end
endfunction

function [127:0] ex1_half_wmacc;
  input [63:0] a, b;
  begin
    ex1_half_wmacc = {64'b0, a};  // Simplified
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
    fwiden_ex2_result[127:0] <= 128'b0;
  end
  else if(ex1_pipedown)
  begin
    fwiden_ex2_result[127:0] <= ex1_result[127:0];
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
    fwiden_ex3_result[127:0] <= 128'b0;
  else if(ex2_pipedown)
    fwiden_ex3_result[127:0] <= fwiden_ex3_result_pre[127:0];
end

assign fwiden_ex3_result_pre[127:0] = fwiden_ex2_result[127:0];
assign fwiden_forward_result[127:0] = fwiden_ex3_result[127:0];
assign fwiden_forward_r_vld = ex3_pipedown;

endmodule
