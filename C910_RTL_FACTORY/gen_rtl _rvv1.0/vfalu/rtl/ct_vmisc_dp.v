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
module ct_vmisc_dp(
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
  pad_yy_icg_scan_en,
  vmisc_forward_r_vld,
  vmisc_forward_result,
  vmisc_mfvr_data
);

// &Ports; @23
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
output          vmisc_forward_r_vld;
output  [63:0]  vmisc_forward_result;
output  [63:0]  vmisc_mfvr_data;

// &Regs; @24
reg     [63:0]  vmisc_ex2_result;
reg     [63:0]  vmisc_ex3_result;

// &Wires; @25
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire    [19:0]  func;

// VMISC operation decode signals
wire            ex1_op_vand;
wire            ex1_op_vorr;
wire            ex1_op_vxor;
wire            ex1_op_vmand;
wire            ex1_op_vmnand;
wire            ex1_op_vmandn;
wire            ex1_op_vmxor;
wire            ex1_op_vmor;
wire            ex1_op_vmnor;
wire            ex1_op_vmorn;
wire            ex1_op_vmpop;
wire            ex1_op_vmfirst;
wire            ex1_op_vmunary0;
wire            ex1_op_vmerge;
wire            ex1_op_vmov;

wire            ex1_pipe_clk;
wire            ex1_pipe_clk_en;
wire            ex1_pipedown;
wire    [63:0]  ex1_pipex_src0;
wire    [63:0]  ex1_pipex_src1;
wire    [63:0]  ex1_result;
wire            ex2_pipe_clk;
wire            ex2_pipe_clk_en;
wire            ex2_pipedown;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire            vmisc_forward_r_vld;
wire    [63:0]  vmisc_forward_result;
wire    [63:0]  vmisc_mfvr_data;
wire            pad_yy_icg_scan_en;

// Intermediate result wires
wire    [63:0]  ex1_vand_result;
wire    [63:0]  ex1_vorr_result;
wire    [63:0]  ex1_vxor_result;
wire    [63:0]  ex1_vmand_result;
wire    [63:0]  ex1_vmnand_result;
wire    [63:0]  ex1_vmandn_result;
wire    [63:0]  ex1_vmxor_result;
wire    [63:0]  ex1_vmor_result;
wire    [63:0]  ex1_vmnor_result;
wire    [63:0]  ex1_vmorn_result;
wire    [63:0]  ex1_vmerge_result;
wire    [63:0]  ex1_vmpop_result;
wire    [63:0]  ex1_vmfirst_result;
wire    [63:0]  ex1_vmunary0_result;
wire    [63:0]  ex1_vmov_result;

// Operation parameters (matching IDU definitions)
parameter VAND     = 20'b0000_0000_0000_1000_0100;
parameter VORR     = 20'b0000_0000_0001_0000_0100;
parameter VXOR     = 20'b0000_0000_0010_0000_0100;
parameter VMGE     = 20'b0000_0000_0100_0000_0100;
parameter VMOV     = 20'b0000_0000_1000_0000_0100;
parameter VMAND    = 20'b0000_0000_0000_1000_1000;
parameter VMNAND   = 20'b0000_0000_0100_1000_1000;
parameter VMANDN   = 20'b0000_0000_1000_1000_1000;
parameter VMXOR    = 20'b0000_0000_0010_0000_1000;
parameter VMNXOR   = 20'b0000_0000_0110_0000_1000;
parameter VMORR    = 20'b0000_0000_0001_0000_1000;
parameter VMNORR   = 20'b0000_0000_0101_0000_1000;
parameter VMORRN   = 20'b0000_0000_1001_0000_1000;
parameter VMPOP    = 20'b0000_0000_0000_0011_0000;
parameter VMFIRST  = 20'b0000_0000_0000_0101_0000;
parameter VMUNARY0 = 20'b0000_0000_0000_1001_0000;

//=====================ins_type generate====================
assign func[19:0] = dp_vfalu_ex1_pipex_func[19:0];

// Bitwise logical operations (vs2 & vs1, vs2 | vs1, vs2 ^ vs1)
assign ex1_op_vand = func[8] && func[2];
assign ex1_op_vorr = func[9] && func[2];
assign ex1_op_vxor = func[10] && func[2];

// Mask operations
assign ex1_op_vmand   = func[8] && func[3] && func[0];
assign ex1_op_vmnand  = func[12] && func[3] && func[0];
assign ex1_op_vmandn  = func[13] && func[3] && func[0];
assign ex1_op_vmxor   = func[10] && func[3] && func[0];
assign ex1_op_vmor    = func[9] && func[3] && func[0];
assign ex1_op_vmnor   = func[11] && func[3] && func[0];
assign ex1_op_vmorn   = func[13] && func[3] && func[0];

// Count/Find operations
assign ex1_op_vmpop   = func[8] && func[9] && func[4];
assign ex1_op_vmfirst = func[8] && func[10] && func[4];
assign ex1_op_vmunary0= func[8] && func[11] && func[4];

// Merge/Mov operations
assign ex1_op_vmerge  = func[10] && func[6];
assign ex1_op_vmov    = func[11] && func[6];

// Input operands
assign ex1_pipex_src0[63:0] = dp_vfalu_ex1_pipex_srcf0[63:0];
assign ex1_pipex_src1[63:0] = dp_vfalu_ex1_pipex_srcf1[63:0];

//===================== Bitwise Logic Operations ====================
// VAND: result = vs2 & vs1
assign ex1_vand_result[63:0] = ex1_pipex_src0[63:0] & ex1_pipex_src1[63:0];

// VORR: result = vs2 | vs1
assign ex1_vorr_result[63:0] = ex1_pipex_src0[63:0] | ex1_pipex_src1[63:0];

// VXOR: result = vs2 ^ vs1
assign ex1_vxor_result[63:0] = ex1_pipex_src0[63:0] ^ ex1_pipex_src1[63:0];

//===================== Mask Operations ====================
// VMAND: mask[i] = vs2[i] AND vs1[i]
assign ex1_vmand_result[63:0] = ex1_pipex_src0[63:0] & ex1_pipex_src1[63:0];

// VMNAND: mask[i] = NOT (vs2[i] AND vs1[i])
assign ex1_vmnand_result[63:0] = ~(ex1_pipex_src0[63:0] & ex1_pipex_src1[63:0]);

// VMANDN: mask[i] = vs2[i] AND NOT vs1[i]
assign ex1_vmandn_result[63:0] = ex1_pipex_src0[63:0] & ~ex1_pipex_src1[63:0];

// VMXOR: mask[i] = vs2[i] XOR vs1[i]
assign ex1_vmxor_result[63:0] = ex1_pipex_src0[63:0] ^ ex1_pipex_src1[63:0];

// VMOR: mask[i] = vs2[i] OR vs1[i]
assign ex1_vmor_result[63:0] = ex1_pipex_src0[63:0] | ex1_pipex_src1[63:0];

// VMNOR: mask[i] = NOT (vs2[i] OR vs1[i])
assign ex1_vmnor_result[63:0] = ~(ex1_pipex_src0[63:0] | ex1_pipex_src1[63:0]);

// VMORN: mask[i] = vs2[i] OR NOT vs1[i]
assign ex1_vmorn_result[63:0] = ex1_pipex_src0[63:0] | ~ex1_pipex_src1[63:0];

//===================== Merge/Mov Operations ====================
// VMERGE: vd[i] = (v0.mask[i]) ? vs1[i] : vs2[i]
// Simplified implementation - actual needs mask input
assign ex1_vmerge_result[63:0] = ex1_pipex_src0[63:0];

// VMOV: vd = vs2 (simple move)
assign ex1_vmov_result[63:0] = ex1_pipex_src0[63:0];

//===================== Count/Find Operations ====================
// VMPOP: Count number of set bits in mask register
// Returns count in least significant bits
assign ex1_vmpop_result[63:0] = {56'b0, popcount(ex1_pipex_src0[7:0])};

// VMFIRST: Find index of first set bit
// Returns index or -1 if none set
assign ex1_vmfirst_result[63:0] = find_first_set(ex1_pipex_src0[7:0]);

// VMUNARY0: vmsbf, vmsif, vmsof, viota, vid operations
// Simplified - actual implementation depends on specific sub-function
assign ex1_vmunary0_result[63:0] = ex1_pipex_src0[63:0];

//===================== Result Selection ====================
assign ex1_result[63:0] =
    {64{ex1_op_vand}}     & ex1_vand_result[63:0]  |
    {64{ex1_op_vorr}}     & ex1_vorr_result[63:0]  |
    {64{ex1_op_vxor}}     & ex1_vxor_result[63:0]  |
    {64{ex1_op_vmand}}    & ex1_vmand_result[63:0] |
    {64{ex1_op_vmnand}}   & ex1_vmnand_result[63:0]|
    {64{ex1_op_vmandn}}   & ex1_vmandn_result[63:0]|
    {64{ex1_op_vmxor}}    & ex1_vmxor_result[63:0] |
    {64{ex1_op_vmor}}     & ex1_vmor_result[63:0] |
    {64{ex1_op_vmnor}}    & ex1_vmnor_result[63:0]|
    {64{ex1_op_vmorn}}    & ex1_vmorn_result[63:0]|
    {64{ex1_op_vmerge}}   & ex1_vmerge_result[63:0]|
    {64{ex1_op_vmov}}     & ex1_vmov_result[63:0]  |
    {64{ex1_op_vmpop}}    & ex1_vmpop_result[63:0] |
    {64{ex1_op_vmfirst}}  & ex1_vmfirst_result[63:0]|
    {64{ex1_op_vmunary0}} & ex1_vmunary0_result[63:0];

// MFVR data output (for scalar read)
assign vmisc_mfvr_data[63:0] = ex1_result[63:0];

//=======================Pipe to EX2========================
//gate clk
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
    vmisc_ex2_result[63:0] <= 64'b0;
  end
  else if(ex1_pipedown)
  begin
    vmisc_ex2_result[63:0] <= ex1_result[63:0];
  end
  else
  begin
    vmisc_ex2_result[63:0] <= vmisc_ex2_result[63:0];
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
    vmisc_ex3_result[63:0] <= 64'b0;
  else if(ex2_pipedown)
    vmisc_ex3_result[63:0] <= vmisc_ex2_result[63:0];
  else
    vmisc_ex3_result[63:0] <= vmisc_ex3_result[63:0];
end

assign vmisc_forward_result[63:0] = vmisc_ex3_result[63:0];
assign vmisc_forward_r_vld        = ex3_pipedown;

//===================== Helper Functions ====================
// popcount: Count number of 1s in input
function [7:0] popcount;
  input [7:0] data;
  integer i;
  begin
    popcount = 8'b0;
    for (i = 0; i < 8; i = i + 1) begin
      popcount = popcount + data[i];
    end
  end
endfunction

// find_first_set: Return index of first 1 bit, or -1 (0xFF) if none
function [63:0] find_first_set;
  input [7:0] data;
  integer i;
  begin
    find_first_set = 64'hFFFFFFFFFFFFFFFF; // Default: all 1s (-1)
    for (i = 0; i < 8; i = i + 1) begin
      if (data[i]) begin
        find_first_set = i;
      end
    end
  end
endfunction

// &ModuleEnd; @280
endmodule
