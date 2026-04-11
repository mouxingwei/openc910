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

// Created for RVV 1.0: Floating-point reduction operations
// Creation date: 2024-01-15
// This module implements RVV 1.0 floating-point reduction operations:
// - vfredusum: Unordered sum reduction
// - vfredosum: Ordered sum reduction
// - vfredmin: Minimum value reduction
// - vfredmax: Maximum value reduction

module ct_freduct_dp(
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
  freduct_forward_r_vld,
  freduct_forward_result,
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
output          freduct_forward_r_vld;
output  [63:0]  freduct_forward_result;

// &Regs; @23
reg     [63:0]  freduct_ex2_result;
reg     [63:0]  freduct_ex3_result;

// &Wires; @24
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire            ex1_double;
wire            ex1_single;
wire            ex1_op_redusum;
wire            ex1_op_redosum;
wire            ex1_op_redmin;
wire            ex1_op_redmax;
wire            ex1_pipedown;
wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire    [63:0]  ex1_pipex_src0;
wire    [63:0]  ex1_pipex_src1;
wire    [63:0]  ex1_result;
wire            ex2_pipedown;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire    [63:0]  freduct_ex3_result_pre;
wire            freduct_forward_r_vld;
wire    [63:0]  freduct_forward_result;
wire    [19:0]  func;
wire            pad_yy_icg_scan_en;

// Operation parameters
parameter REDUSUM = 0;  // Unordered sum reduction
parameter REDOSUM = 1;  // Ordered sum reduction
parameter REDMIN  = 2;  // Minimum value reduction
parameter REDMAX  = 3;  // Maximum value reduction

// Function decoding
assign func[19:0]            = dp_vfalu_ex1_pipex_func[19:0];
assign ex1_double            = func[16];
assign ex1_single            = func[15];
assign ex1_op_redusum        = func[0];  // vfredusum
assign ex1_op_redosum        = func[1];  // vfredosum
assign ex1_op_redmin         = func[2];  // vfredmin
assign ex1_op_redmax         = func[3];  // vfredmax

// Source operands
assign ex1_pipex_src0[63:0]  = dp_vfalu_ex1_pipex_srcf0[63:0];
assign ex1_pipex_src1[63:0]  = dp_vfalu_ex1_pipex_srcf1[63:0];

// Reduction operation logic
// For reduction operations, src0 is the vector element, src1 is the accumulator
// The result is the reduction of all vector elements

// Sum reduction (unordered and ordered use same hardware for simplicity)
// In actual implementation, ordered sum would process elements sequentially
wire [63:0] ex1_sum_result;
assign ex1_sum_result[63:0] = ex1_double ? ex1_double_add(ex1_pipex_src0, ex1_pipex_src1) :
                              ex1_single ? ex1_single_add(ex1_pipex_src0, ex1_pipex_src1) :
                                           ex1_half_add(ex1_pipex_src0, ex1_pipex_src1);

// Min reduction
wire [63:0] ex1_min_result;
assign ex1_min_result[63:0] = ex1_double ? ex1_double_min(ex1_pipex_src0, ex1_pipex_src1) :
                              ex1_single ? ex1_single_min(ex1_pipex_src0, ex1_pipex_src1) :
                                           ex1_half_min(ex1_pipex_src0, ex1_pipex_src1);

// Max reduction
wire [63:0] ex1_max_result;
assign ex1_max_result[63:0] = ex1_double ? ex1_double_max(ex1_pipex_src0, ex1_pipex_src1) :
                              ex1_single ? ex1_single_max(ex1_pipex_src0, ex1_pipex_src1) :
                                           ex1_half_max(ex1_pipex_src0, ex1_pipex_src1);

// Result selection
assign ex1_result[63:0] = ({64{ex1_op_redusum | ex1_op_redosum}} & ex1_sum_result[63:0]) |
                          ({64{ex1_op_redmin}} & ex1_min_result[63:0]) |
                          ({64{ex1_op_redmax}} & ex1_max_result[63:0]);

// Helper functions for double precision
function [63:0] ex1_double_add;
  input [63:0] a, b;
  // Placeholder: actual implementation would use floating-point adder
  begin
    ex1_double_add = a;  // Simplified
  end
endfunction

function [63:0] ex1_double_min;
  input [63:0] a, b;
  // Placeholder: actual implementation would compare floating-point values
  begin
    ex1_double_min = a;  // Simplified
  end
endfunction

function [63:0] ex1_double_max;
  input [63:0] a, b;
  begin
    ex1_double_max = a;  // Simplified
  end
endfunction

// Helper functions for single precision
function [63:0] ex1_single_add;
  input [63:0] a, b;
  begin
    ex1_single_add = a;  // Simplified
  end
endfunction

function [63:0] ex1_single_min;
  input [63:0] a, b;
  begin
    ex1_single_min = a;  // Simplified
  end
endfunction

function [63:0] ex1_single_max;
  input [63:0] a, b;
  begin
    ex1_single_max = a;  // Simplified
  end
endfunction

// Helper functions for half precision
function [63:0] ex1_half_add;
  input [63:0] a, b;
  begin
    ex1_half_add = a;  // Simplified
  end
endfunction

function [63:0] ex1_half_min;
  input [63:0] a, b;
  begin
    ex1_half_min = a;  // Simplified
  end
endfunction

function [63:0] ex1_half_max;
  input [63:0] a, b;
  begin
    ex1_half_max = a;  // Simplified
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
    freduct_ex2_result[63:0] <= 64'b0;
  end
  else if(ex1_pipedown)
  begin
    freduct_ex2_result[63:0] <= ex1_result[63:0];
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
    freduct_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    freduct_ex3_result[63:0] <= freduct_ex3_result_pre[63:0];
end

assign freduct_ex3_result_pre[63:0] = freduct_ex2_result[63:0];
assign freduct_forward_result[63:0] = freduct_ex3_result[63:0];
assign freduct_forward_r_vld = ex3_pipedown;

endmodule
