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

module ct_vperm_top(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_eu_sel,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_iid,
  dp_vfalu_ex1_pipex_imm0,
  dp_vfalu_ex1_pipex_mask,
  dp_vfalu_ex1_pipex_mtvr_src0,
  dp_vfalu_ex1_pipex_sel,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  dp_vfalu_ex1_pipex_srcf2,
  dp_vfalu_ex1_pipex_vimm,
  dp_vfalu_ex1_pipex_vimm_vld,
  forever_cpuclk,
  pad_yy_icg_scan_en,
  vperm_forward_r_vld,
  vperm_forward_result,
  vperm_mfvr_data
);

// &Ports; @24
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [11:0]  dp_vfalu_ex1_pipex_eu_sel;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [6 :0]  dp_vfalu_ex1_pipex_iid;
input   [2 :0]  dp_vfalu_ex1_pipex_imm0;
input   [63:0]  dp_vfalu_ex1_pipex_mask;
input   [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
input   [2:0]   dp_vfalu_ex1_pipex_sel;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input   [63:0]  dp_vfalu_ex1_pipex_srcf2;
input   [4 :0]  dp_vfalu_ex1_pipex_vimm;
input           dp_vfalu_ex1_pipex_vimm_vld;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          vperm_forward_r_vld;
output  [63:0]  vperm_forward_result;
output  [63:0]  vperm_mfvr_data;

// &Regs; @25

// &Wires; @26
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [11:0]  dp_vfalu_ex1_pipex_eu_sel;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [6 :0]  dp_vfalu_ex1_pipex_iid;
wire    [2 :0]  dp_vfalu_ex1_pipex_imm0;
wire    [63:0]  dp_vfalu_ex1_pipex_mask;
wire    [63:0]  dp_vfalu_ex1_pipex_mtvr_src0;
wire    [2:0]   dp_vfalu_ex1_pipex_sel;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf2;
wire    [4 :0]  dp_vfalu_ex1_pipex_vimm;
wire            dp_vfalu_ex1_pipex_vimm_vld;
wire            ex1_pipedown;
wire            ex2_pipedown;
wire            ex3_pipedown;
wire            ex4_pipedown;
wire            forever_cpuclk;
wire            vperm_forward_r_vld;
wire    [63:0]  vperm_forward_result;
wire    [63:0]  vperm_mfvr_data;
wire            pad_yy_icg_scan_en;


// &Instance("ct_vperm_ctrl"); @28
ct_vperm_ctrl  x_ct_vperm_ctrl (
  .cp0_vfpu_icg_en        (cp0_vfpu_icg_en       ),
  .cp0_yy_clk_en          (cp0_yy_clk_en         ),
  .cpurst_b               (cpurst_b              ),
  .dp_vfalu_ex1_pipex_eu_sel(dp_vfalu_ex1_pipex_eu_sel),
  .dp_vfalu_ex1_pipex_sel (dp_vfalu_ex1_pipex_sel),
  .ex1_pipedown           (ex1_pipedown          ),
  .ex2_pipedown           (ex2_pipedown          ),
  .ex3_pipedown           (ex3_pipedown          ),
  .ex4_pipedown           (ex4_pipedown          ),
  .forever_cpuclk         (forever_cpuclk        ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en    )
);

// &Instance("ct_vperm_dp"); @29
ct_vperm_dp  x_ct_vperm_dp (
  .cp0_vfpu_icg_en              (cp0_vfpu_icg_en             ),
  .cp0_yy_clk_en                (cp0_yy_clk_en               ),
  .cpurst_b                     (cpurst_b                    ),
  .dp_vfalu_ex1_pipex_func      (dp_vfalu_ex1_pipex_func     ),
  .dp_vfalu_ex1_pipex_iid       (dp_vfalu_ex1_pipex_iid      ),
  .dp_vfalu_ex1_pipex_imm0      (dp_vfalu_ex1_pipex_imm0     ),
  .dp_vfalu_ex1_pipex_mask      (dp_vfalu_ex1_pipex_mask     ),
  .dp_vfalu_ex1_pipex_mtvr_src0 (dp_vfalu_ex1_pipex_mtvr_src0),
  .dp_vfalu_ex1_pipex_srcf0     (dp_vfalu_ex1_pipex_srcf0   ),
  .dp_vfalu_ex1_pipex_srcf1     (dp_vfalu_ex1_pipex_srcf1   ),
  .dp_vfalu_ex1_pipex_srcf2     (dp_vfalu_ex1_pipex_srcf2   ),
  .dp_vfalu_ex1_pipex_vimm      (dp_vfalu_ex1_pipex_vimm    ),
  .dp_vfalu_ex1_pipex_vimm_vld  (dp_vfalu_ex1_pipex_vimm_vld),
  .ex1_pipedown                 (ex1_pipedown                ),
  .ex2_pipedown                 (ex2_pipedown                ),
  .ex3_pipedown                 (ex3_pipedown                ),
  .ex4_pipedown                 (ex4_pipedown                ),
  .forever_cpuclk               (forever_cpuclk              ),
  .pad_yy_icg_scan_en          (pad_yy_icg_scan_en          ),
  .vperm_forward_r_vld          (vperm_forward_r_vld         ),
  .vperm_forward_result         (vperm_forward_result        ),
  .vperm_mfvr_data             (vperm_mfvr_data             )
);


// &ModuleEnd; @31
endmodule
