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

// Created for RVV 1.0: Narrowing conversion control module
// Creation date: 2024-01-15

module ct_fnarrow_ctrl(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_sel,
  ex1_pipedown,
  ex2_pipedown,
  ex3_pipedown,
  forever_cpuclk,
  pad_yy_icg_scan_en
);

// &Ports; @22
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [2:0]   dp_vfalu_ex1_pipex_sel;
output          ex1_pipedown;
output          ex2_pipedown;
output          ex3_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;

// &Regs; @23
reg             ex2_pipedown_reg;
reg             ex3_pipedown_reg;

// &Wires; @24
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [2:0]   dp_vfalu_ex1_pipex_sel;
wire            ex1_pipedown;
wire            ex2_pipedown;
wire            ex3_pipedown;
wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            forever_cpuclk;
wire            pad_yy_icg_scan_en;

// Pipeline control signals
// Modified 2024-01-15: ex1_pipedown is combinational logic (same as ct_fspu_ctrl)
assign ex1_pipedown = dp_vfalu_ex1_pipex_sel[0];
assign ex2_pipedown = ex2_pipedown_reg;
assign ex3_pipedown = ex3_pipedown_reg;

// EX1 pipeline clock enable
assign ex1_pipe_clk_en = ex1_pipedown || ex2_pipedown;

// EX1 pipeline register
gated_clk_cell x_ex1_pipe_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex1_pipe_clk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex1_pipe_clk_en   ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

always @(posedge ex1_pipe_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ex2_pipedown_reg <= 1'b0;
  else if(ex1_pipedown)
    ex2_pipedown_reg <= 1'b1;
  else
    ex2_pipedown_reg <= 1'b0;
end

// EX2 pipeline clock enable
assign ex2_pipe_clk_en = ex2_pipedown || ex3_pipedown;

// EX2 pipeline register
gated_clk_cell x_ex2_pipe_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex2_pipe_clk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex2_pipe_clk_en   ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

always @(posedge ex2_pipe_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ex3_pipedown_reg <= 1'b0;
  else if(ex2_pipedown)
    ex3_pipedown_reg <= 1'b1;
  else
    ex3_pipedown_reg <= 1'b0;
end

endmodule
