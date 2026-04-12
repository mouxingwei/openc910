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

module ct_vmisc_top(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_sel,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
  forever_cpuclk,
  pad_yy_icg_scan_en,
  vmisc_forward_r_vld,
  vmisc_forward_result,
  vmisc_mfvr_data
);

// &Ports; @24
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input   [19:0]  dp_vfalu_ex1_pipex_func;
input   [2:0]   dp_vfalu_ex1_pipex_sel;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          vmisc_forward_r_vld;
output  [63:0]  vmisc_forward_result;
output  [63:0]  vmisc_mfvr_data;

// &Regs; @25

// &Wires; @26
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire    [19:0]  dp_vfalu_ex1_pipex_func;
wire    [2:0]   dp_vfalu_ex1_pipex_sel;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf0;
wire    [63:0]  dp_vfalu_ex1_pipex_srcf1;
wire            ex1_pipedown;
wire            ex2_pipedown;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire            vmisc_forward_r_vld;
wire    [63:0]  vmisc_forward_result;
wire    [63:0]  vmisc_mfvr_data;
wire            pad_yy_icg_scan_en;


// &Instance("ct_vmisc_ctrl"); @28
ct_vmisc_ctrl  x_ct_vmisc_ctrl (
  .cp0_vfpu_icg_en        (cp0_vfpu_icg_en       ),
  .cp0_yy_clk_en          (cp0_yy_clk_en         ),
  .cpurst_b               (cpurst_b              ),
  .dp_vfalu_ex1_pipex_sel (dp_vfalu_ex1_pipex_sel),
  .ex1_pipedown           (ex1_pipedown          ),
  .ex2_pipedown           (ex2_pipedown          ),
  .ex3_pipedown           (ex3_pipedown          ),
  .forever_cpuclk         (forever_cpuclk        ),
  .pad_yy_icg_scan_en    (pad_yy_icg_scan_en    )
);

// &Instance("ct_vmisc_dp"); @29
ct_vmisc_dp  x_ct_vmisc_dp (
  .cp0_vfpu_icg_en              (cp0_vfpu_icg_en             ),
  .cp0_yy_clk_en                (cp0_yy_clk_en               ),
  .cpurst_b                     (cpurst_b                    ),
  .dp_vfalu_ex1_pipex_func      (dp_vfalu_ex1_pipex_func     ),
  .dp_vfalu_ex1_pipex_srcf0     (dp_vfalu_ex1_pipex_srcf0   ),
  .dp_vfalu_ex1_pipex_srcf1     (dp_vfalu_ex1_pipex_srcf1   ),
  .ex1_pipedown                 (ex1_pipedown                ),
  .ex2_pipedown                 (ex2_pipedown                ),
  .ex3_pipedown                 (ex3_pipedown                ),
  .forever_cpuclk               (forever_cpuclk              ),
  .pad_yy_icg_scan_en          (pad_yy_icg_scan_en          ),
  .vmisc_forward_r_vld          (vmisc_forward_r_vld         ),
  .vmisc_forward_result         (vmisc_forward_result        ),
  .vmisc_mfvr_data             (vmisc_mfvr_data             )
);


// &ModuleEnd; @31
endmodule
