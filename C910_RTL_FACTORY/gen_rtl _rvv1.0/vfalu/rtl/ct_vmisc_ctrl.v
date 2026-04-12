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

// Created for RVV 1.0 VMISC (Vector Miscellaneous) unit
// VMISC handles bitwise logical, mask operations, count/find operations
// Modification date: 2026-04-12

// &ModuleBeg; @22
module ct_vmisc_ctrl(
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

// &Ports; @23
input          cp0_vfpu_icg_en;
input          cp0_yy_clk_en;
input          cpurst_b;
input   [2:0]  dp_vfalu_ex1_pipex_sel;
input          forever_cpuclk;
input          pad_yy_icg_scan_en;
output         ex1_pipedown;
output         ex2_pipedown;
output         ex3_pipedown;

// &Regs; @24
reg            ex2_pipedown;
reg            ex3_pipedown;

// &Wires; @25
wire           cp0_vfpu_icg_en;
wire           cp0_yy_clk_en;
wire           cpurst_b;
wire    [2:0]  dp_vfalu_ex1_pipex_sel;
wire           ex1_pipedown;
wire           ex1_vld_clk;
wire           ex1_vld_clk_en;
wire           ex2_vld_clk;
wire           ex2_vld_clk_en;
wire           forever_cpuclk;
wire           pad_yy_icg_scan_en;


//EX1 Control
assign ex1_pipedown = dp_vfalu_ex1_pipex_sel[0];


//EX2 Control
//gate clk
gated_clk_cell  x_ex1_vld_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex1_vld_clk       ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex1_vld_clk_en    ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ex1_vld_clk_en = ex1_pipedown || ex2_pipedown;
always @(posedge ex1_vld_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ex2_pipedown <= 1'b0;
  else if(ex1_pipedown)
    ex2_pipedown <= 1'b1;
  else
    ex2_pipedown <= 1'b0;
end

//EX3 Control
//gate clk
gated_clk_cell  x_ex2_vld_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex2_vld_clk       ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex2_vld_clk_en    ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ex2_vld_clk_en = ex2_pipedown || ex3_pipedown;
always @(posedge ex2_vld_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    ex3_pipedown <= 1'b0;
  else if(ex2_pipedown)
    ex3_pipedown <= 1'b1;
  else
    ex3_pipedown <= 1'b0;
end

// &ModuleEnd; @79
endmodule
