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

// Created for RVV 1.0: Floating-point reduction operations top module
// Creation date: 2024-01-15
// This module is the top-level wrapper for floating-point reduction operations

module ct_freduct_top(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  dp_vfalu_ex1_pipex_func,
  dp_vfalu_ex1_pipex_sel,
  dp_vfalu_ex1_pipex_srcf0,
  dp_vfalu_ex1_pipex_srcf1,
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
input   [2:0]   dp_vfalu_ex1_pipex_sel;
input   [63:0]  dp_vfalu_ex1_pipex_srcf0;
input   [63:0]  dp_vfalu_ex1_pipex_srcf1;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output          freduct_forward_r_vld;
output  [63:0]  freduct_forward_result;

// &Wires; @24
wire            ex1_pipedown;
wire            ex2_pipedown;
wire            ex3_pipedown;

// Instance of control module
ct_freduct_ctrl x_ct_freduct_ctrl (
  .cp0_vfpu_icg_en        (cp0_vfpu_icg_en       ),
  .cp0_yy_clk_en          (cp0_yy_clk_en         ),
  .cpurst_b               (cpurst_b              ),
  .dp_vfalu_ex1_pipex_sel (dp_vfalu_ex1_pipex_sel),
  .ex1_pipedown           (ex1_pipedown          ),
  .ex2_pipedown           (ex2_pipedown          ),
  .ex3_pipedown           (ex3_pipedown          ),
  .forever_cpuclk         (forever_cpuclk        ),
  .pad_yy_icg_scan_en     (pad_yy_icg_scan_en    )
);

// Instance of data path module
ct_freduct_dp x_ct_freduct_dp (
  .cp0_vfpu_icg_en          (cp0_vfpu_icg_en         ),
  .cp0_yy_clk_en            (cp0_yy_clk_en           ),
  .cpurst_b                 (cpurst_b                ),
  .dp_vfalu_ex1_pipex_func  (dp_vfalu_ex1_pipex_func ),
  .dp_vfalu_ex1_pipex_srcf0 (dp_vfalu_ex1_pipex_srcf0),
  .dp_vfalu_ex1_pipex_srcf1 (dp_vfalu_ex1_pipex_srcf1),
  .ex1_pipedown             (ex1_pipedown            ),
  .ex2_pipedown             (ex2_pipedown            ),
  .ex3_pipedown             (ex3_pipedown            ),
  .forever_cpuclk           (forever_cpuclk          ),
  .freduct_forward_r_vld    (freduct_forward_r_vld   ),
  .freduct_forward_result   (freduct_forward_result  ),
  .pad_yy_icg_scan_en       (pad_yy_icg_scan_en      )
);

endmodule
