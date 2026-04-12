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

// Created for RVV 1.0 VPERM (Vector Permutation) unit
// VPERM handles gather, slide, extract, compress operations
// Modification date: 2026-04-12

// &ModuleBeg; @22
module ct_vperm_dp(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_mtvr_src0,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
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

// &Ports; @23
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input           ex1_pipedown;
input           ex2_pipedown;
input           ex3_pipedown;
input           ex4_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          vperm_forward_r_vld;
output  [63:0]  vperm_forward_result;
output  [63:0]  vperm_mfvr_data;

// &Regs; @24
reg     [63:0]  vperm_ex2_result;
reg     [63:0]  vperm_ex3_result;
reg     [63:0]  vperm_ex4_result;

// &Wires; @25
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire    [19:0]  func;

// VPERM operation decode signals
wire            ex1_op_vext;
wire            ex1_op_vslideup;
wire            ex1_op_vslidedown;
wire            ex1_op_vslide1up;
wire            ex1_op_vslide1down;
wire            ex1_op_vrgathervv;
wire            ex1_op_vrgathervk;
wire            ex1_op_vcompress;

wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire            ex1_pipedown;
wire    [63:0]  ex1_pipex_src0;
wire    [63:0]  ex1_pipex_src1;
wire    [63:0]  ex1_pipex_mtvr_src0;
wire    [63:0]  ex1_result;
wire    [63:0]  ex2_pipex_src0;
wire    [63:0]  ex2_pipex_src1;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            ex2_pipedown;
wire            ex3_pipe_clk;
wire            ex3_pipe_clk_en;
wire            ex3_pipedown;
wire            ex4_pipedown;
wire            forever_cpuclk;
wire            vperm_forward_r_vld;
wire    [63:0]  vperm_forward_result;
wire    [63:0]  vperm_mfvr_data;
wire            pad_yy_icg_scan_en;

// Intermediate result wires
wire    [63:0]  ex1_vext_result;
wire    [63:0]  ex1_vslideup_result;
wire    [63:0]  ex1_vslidedown_result;
wire    [63:0]  ex1_vslide1up_result;
wire    [63:0]  ex1_vslide1down_result;
wire    [63:0]  ex1_vrgathervv_result;
wire    [63:0]  ex1_vrgathervk_result;
wire    [63:0]  ex1_vcompress_result;

// Operation parameters (matching IDU definitions)
parameter VEXT        = 20'b0000_0000_0000_0000_0001;
parameter VSLIDEUP    = 20'b0000_0000_0000_0100_1000;
parameter VSLIDEDOWN = 20'b0000_0000_0000_0010_1000;
parameter VSLIDE1UP   = 20'b0000_0000_0000_0101_0000;
parameter VSLIDE1DOWN = 20'b0000_0000_0000_0011_0000;
parameter VRGATHERVV  = 20'b0000_0000_0000_0000_1000;
parameter VRGATHERVK  = 20'b0000_0000_0100_0000_1000;
parameter VCOMPRESS   = 20'b0000_0000_0000_0000_1100;

//=====================ins_type generate====================
assign func[19:0] = dp_vfalu_ex1_pipex_func[19:0];

// Slide operations
assign ex1_op_vslideup    = func[10] && func[6] && !func[8] && !func[9];
assign ex1_op_vslidedown  = func[9] && func[6] && !func[8] && !func[10];
assign ex1_op_vslide1up   = func[10] && func[8] && !func[9];
assign ex1_op_vslide1down = func[9] && func[8] && !func[10];

// Gather operations
assign ex1_op_vrgathervv  = func[8] && !func[12];
assign ex1_op_vrgathervk  = func[12] && func[8];

// Extract and compress
assign ex1_op_vext        = func[0];
assign ex1_op_vcompress   = func[9] && func[8] && func[2];

// Input operands
assign ex1_pipex_src0[63:0] = dp_vfalu_ex1_pipex_srcf0[63:0];
assign ex1_pipex_src1[63:0] = dp_vfalu_ex1_pipex_srcf1[63:0];
assign ex1_pipex_mtvr_src0[63:0] = dp_vfalu_ex1_pipex_mtvr_src0[63:0];

//===================== Extract Operation ====================
// VEXT: vd = vs2[rs1] (extract element at index rs1)
assign ex1_vext_result[63:0] = extract_element(ex1_pipex_src1[63:0],
                                                 ex1_pipex_mtvr_src0[5:0]);

//===================== Slide Operations ====================
// VSLIDEUP: vd[i+offset] = vs2[i] for i < VLMAX-offset
// offset is from vs1 (or immediate)
assign ex1_vslideup_result[63:0] = slideup(ex1_pipex_src0, ex1_pipex_src1, 16'h0);

// VSLIDEDOWN: vd[i] = vs2[i+offset] for i < VLMAX-offset
assign ex1_vslidedown_result[63:0] = slidedown(ex1_pipex_src0, ex1_pipex_src1, 16'h0);

// VSLIDE1UP: vd[i+1] = vs2[i] for i < VLMAX-1
assign ex1_vslide1up_result[63:0] = slideup(ex1_pipex_src0, 64'h1, 16'h0);

// VSLIDE1DOWN: vd[i] = vs2[i+1] for i < VLMAX-1
assign ex1_vslide1down_result[63:0] = slidedown(ex1_pipex_src0, 64'h1, 16'h0);

//===================== Gather Operations ====================
// VRGATHERVV: vd[i] = vs2[vs1[i]]
assign ex1_vrgathervv_result[63:0] = gather_vv(ex1_pipex_src0, ex1_pipex_src1);

// VRGATHERVK: vd[i] = vs2[vs1] (scalar index)
assign ex1_vrgathervk_result[63:0] = gather_vk(ex1_pipex_src0, ex1_pipex_mtvr_src0[5:0]);

//===================== Compress Operation ====================
// VCOMPRESS: compress elements according to mask
// Simplified - actual needs mask input
assign ex1_vcompress_result[63:0] = ex1_pipex_src0[63:0];

//===================== Result Selection ====================
assign ex1_result[63:0] =
    {64{ex1_op_vext}}        & ex1_vext_result[63:0]        |
    {64{ex1_op_vslideup}}    & ex1_vslideup_result[63:0]    |
    {64{ex1_op_vslidedown}}  & ex1_vslidedown_result[63:0]  |
    {64{ex1_op_vslide1up}}   & ex1_vslide1up_result[63:0]   |
    {64{ex1_op_vslide1down}} & ex1_vslide1down_result[63:0]|
    {64{ex1_op_vrgathervv}}  & ex1_vrgathervv_result[63:0] |
    {64{ex1_op_vrgathervk}}  & ex1_vrgathervk_result[63:0] |
    {64{ex1_op_vcompress}}   & ex1_vcompress_result[63:0];

// MFVR data output (for scalar read)
assign vperm_mfvr_data[63:0] = ex1_result[63:0];

//=======================Pipe to EX2========================
gated_clk_cell  x_ex1_pipe_clk (
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
    vperm_ex2_result[63:0] <= 64'b0;
  end
  else if(ex1_pipedown)
  begin
    vperm_ex2_result[63:0] <= ex1_result[63:0];
  end
  else
  begin
    vperm_ex2_result[63:0] <= vperm_ex2_result[63:0];
  end
end

//=======================Pipe to EX3========================
gated_clk_cell  x_ex2_pipe_clk (
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
    vperm_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    vperm_ex3_result[63:0] <= vperm_ex2_result[63:0];
  else
    vperm_ex3_result[63:0] <= vperm_ex3_result[63:0];
end

//=======================Pipe to EX4========================
gated_clk_cell  x_ex3_pipe_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (ex3_pipe_clk      ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (ex3_pipe_clk_en   ),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

assign ex3_pipe_clk_en = ex3_pipedown;

always @(posedge ex3_pipe_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vperm_ex4_result[63:0] <= 64'b0;
  else if(ex3_pipedown)
    vperm_ex4_result[63:0] <= vperm_ex3_result[63:0];
  else
    vperm_ex4_result[63:0] <= vperm_ex4_result[63:0];
end

assign vperm_forward_result[63:0] = vperm_ex4_result[63:0];
assign vperm_forward_r_vld        = ex4_pipedown;

//===================== Helper Functions ====================
// extract_element: Extract element at index from 64-bit vector (4x16-bit elements)
function [63:0] extract_element;
  input [63:0] src;
  input [5:0] index;
  begin
    case(index[5:2])
      4'b0000: extract_element = {48'b0, src[15:0]};
      4'b0001: extract_element = {48'b0, src[31:16]};
      4'b0010: extract_element = {48'b0, src[47:32]};
      4'b0011: extract_element = {48'b0, src[63:48]};
      default: extract_element = 64'b0;
    endcase
  end
endfunction

// slideup: Shift elements up by offset, fill lower with zeros
function [63:0] slideup;
  input [63:0] src;
  input [63:0] offset;
  input [15:0] vl;
  reg [63:0] result;
  integer i;
  begin
    result = 64'b0;
    for (i = 0; i < 64; i = i + 1) begin
      if ((i + offset[5:0]) < 64) begin
        result[i] = src[i + offset[5:0]];
      end
    end
    slideup = result;
  end
endfunction

// slidedown: Shift elements down by offset, fill upper with zeros
function [63:0] slidedown;
  input [63:0] src;
  input [63:0] offset;
  input [15:0] vl;
  reg [63:0] result;
  integer i;
  begin
    result = 64'b0;
    for (i = 0; i < 64; i = i + 1) begin
      if ((i >= offset[5:0]) && (i < 64)) begin
        result[i] = src[i - offset[5:0]];
      end
    end
    slidedown = result;
  end
endfunction

// gather_vv: Vector-vector gather - vd[i] = vs2[vs1[i]]
// vs1 contains indices, vs2 is source
function [63:0] gather_vv;
  input [63:0] vs2;
  input [63:0] vs1;
  reg [63:0] result;
  integer i;
  integer idx;
  begin
    result = 64'b0;
    for (i = 0; i < 16; i = i + 1) begin
      idx = vs1[i*4 +: 4];
      if (idx < 16) begin
        result[i*4 +: 4] = vs2[idx*4 +: 4];
      end
    end
    gather_vv = result;
  end
endfunction

// gather_vk: Vector-scalar gather - vd[i] = vs2[index]
function [63:0] gather_vk;
  input [63:0] vs2;
  input [5:0] index;
  begin
    case(index[5:2])
      4'b0000: gather_vk = {48'b0, vs2[15:0]};
      4'b0001: gather_vk = {48'b0, vs2[31:16]};
      4'b0010: gather_vk = {48'b0, vs2[47:32]};
      4'b0011: gather_vk = {48'b0, vs2[63:48]};
      default: gather_vk = 64'b0;
    endcase
  end
endfunction

// &ModuleEnd; @380
endmodule
