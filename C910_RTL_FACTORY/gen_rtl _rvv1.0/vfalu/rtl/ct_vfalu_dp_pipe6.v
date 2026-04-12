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

// &ModuleBeg; @22
module ct_vfalu_dp_pipe6(
  dp_vfalu_ex1_pipex_sel,
  fadd_ereg_ex3_forward_r_vld,
  fadd_ereg_ex3_result,
  fadd_forward_r_vld,
  fadd_forward_result,
  fadd_mfvr_cmp_result,
  fspu_forward_r_vld,
  fspu_forward_result,
  fspu_mfvr_data,
  // Added for RVV 1.0 VMISC/VPERM
  // Modification date: 2026-04-12
  vmisc_forward_r_vld,
  vmisc_forward_result,
  vmisc_mfvr_data,
  vperm_forward_r_vld,
  vperm_forward_result,
  vperm_mfvr_data,
  pipex_dp_ex1_vfalu_mfvr_data,
  pipex_dp_ex3_vfalu_ereg_data,
  pipex_dp_ex3_vfalu_freg_data
);

// &Ports; @23
input   [2 :0]  dp_vfalu_ex1_pipex_sel;
input           fadd_ereg_ex3_forward_r_vld;
input   [4 :0]  fadd_ereg_ex3_result;
input           fadd_forward_r_vld;
input   [63:0]  fadd_forward_result;
input   [63:0]  fadd_mfvr_cmp_result;
input           fspu_forward_r_vld;
input   [63:0]  fspu_forward_result;
input   [63:0]  fspu_mfvr_data;
// Added for RVV 1.0 VMISC/VPERM
// Modification date: 2026-04-12
input           vmisc_forward_r_vld;
input   [63:0]  vmisc_forward_result;
input   [63:0]  vmisc_mfvr_data;
input           vperm_forward_r_vld;
input   [63:0]  vperm_forward_result;
input   [63:0]  vperm_mfvr_data;
output  [63:0]  pipex_dp_ex1_vfalu_mfvr_data;
output  [4 :0]  pipex_dp_ex3_vfalu_ereg_data;
output  [63:0]  pipex_dp_ex3_vfalu_freg_data; 

// &Regs; @24
reg     [63:0]  pipex_dp_ex3_vfalu_freg_data; 

// &Wires; @25
wire    [2 :0]  dp_vfalu_ex1_pipex_sel;
wire            fadd_ereg_ex3_forward_r_vld;
wire    [4 :0]  fadd_ereg_ex3_result;
wire            fadd_forward_r_vld;
wire    [63:0]  fadd_forward_result;
wire    [63:0]  fadd_mfvr_cmp_result;
wire            fspu_forward_r_vld;
wire    [63:0]  fspu_forward_result;
wire    [63:0]  fspu_mfvr_data;
// Added for RVV 1.0 VMISC/VPERM
// Modification date: 2026-04-12
wire            vmisc_forward_r_vld;
wire    [63:0]  vmisc_forward_result;
wire    [63:0]  vmisc_mfvr_data;
wire            vperm_forward_r_vld;
wire    [63:0]  vperm_forward_result;
wire    [63:0]  vperm_mfvr_data;
wire    [63:0]  pipex_dp_ex1_vfalu_mfvr_data;
wire    [4 :0]  pipex_dp_ex3_vfalu_ereg_data; 


//assign pipex_dp_ex3_vfalu_expt_vec[4:0]    = 5'd30;
// &Force("output","pipex_dp_ex3_vfalu_ereg_data"); @28
assign pipex_dp_ex3_vfalu_ereg_data[4:0]   = {5{fadd_ereg_ex3_forward_r_vld}} & fadd_ereg_ex3_result[4:0];
// Modified for RVV 1.0: Added VMISC/VPERM MFVR data selection
// Modification date: 2026-04-12
assign pipex_dp_ex1_vfalu_mfvr_data[63:0]  = {64{dp_vfalu_ex1_pipex_sel[1]}} & fadd_mfvr_cmp_result[63:0] |
                                             {64{dp_vfalu_ex1_pipex_sel[0]}} & fspu_mfvr_data[63:0] |
                                             {64{vmisc_forward_r_vld}} & vmisc_mfvr_data[63:0] |
                                             {64{vperm_forward_r_vld}} & vperm_mfvr_data[63:0];
// &Force("bus","dp_vfalu_ex1_pipex_sel",2,0);                                           @32
// &CombBeg; @34
// &CombEnd; @40
// &CombBeg; @42
// &CombEnd; @48
// &CombBeg; @56
// Modified for RVV 1.0: Added VMISC/VPERM result selection
// Modification date: 2026-04-12
always @( fspu_forward_result[63:0]
       or fspu_forward_r_vld
       or fadd_forward_r_vld
       or fadd_forward_result[63:0]
       or vmisc_forward_r_vld
       or vmisc_forward_result[63:0]
       or vperm_forward_r_vld
       or vperm_forward_result[63:0])
begin
  case({fadd_forward_r_vld,fspu_forward_r_vld,vmisc_forward_r_vld,vperm_forward_r_vld})
    4'b1000   : pipex_dp_ex3_vfalu_freg_data[63:0] = fadd_forward_result[63:0];
    4'b0100   : pipex_dp_ex3_vfalu_freg_data[63:0] = fspu_forward_result[63:0];
    4'b0010   : pipex_dp_ex3_vfalu_freg_data[63:0] = vmisc_forward_result[63:0];
    4'b0001   : pipex_dp_ex3_vfalu_freg_data[63:0] = vperm_forward_result[63:0];
    default : pipex_dp_ex3_vfalu_freg_data[63:0] = {64{1'bx}};
  endcase
// &CombEnd;   @62
end

// &ModuleEnd; @65
endmodule


