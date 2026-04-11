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

// Modified 2026-04-11: 新增向量控制模块，支持RVV 1.0向量扩展
// 功能：向量迭代控制、掩码处理、vl/vstart管理

// &ModuleBeg; @22
module ct_vfdsu_vector_ctrl(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  element_done,
  element_exception,
  ex1_is_vector,
  ex1_mask,
  ex1_pipedown,
  ex1_vm,
  ex1_vl,
  ex1_vstart,
  forever_cpuclk,
  pad_yy_icg_scan_en,
  rtu_yy_xx_flush,
  vector_ctrl_clk,
  element_active,
  element_idx,
  element_mask,
  next_vstart,
  vector_done
);

// &Ports; @23
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input           element_done;
input           element_exception;
input           ex1_is_vector;
input   [63:0]  ex1_mask;
input           ex1_pipedown;
input           ex1_vm;
input   [6 :0]  ex1_vl;
input   [6 :0]  ex1_vstart;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
input           rtu_yy_xx_flush;
output          vector_ctrl_clk;
output          element_active;
output  [6 :0]  element_idx;
output          element_mask;
output  [6 :0]  next_vstart;
output          vector_done;

// &Regs; @24
reg     [6 :0]  current_element_idx;
reg     [6 :0]  current_vl;
reg     [6 :0]  current_vstart;
reg             vector_active;

// &Wires; @25
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire            element_done;
wire            element_exception;
wire            element_mask_bit;
wire            ex1_is_vector;
wire    [63:0]  ex1_mask;
wire            ex1_pipedown;
wire            ex1_vm;
wire    [6 :0]  ex1_vl;
wire    [6 :0]  ex1_vstart;
wire            forever_cpuclk;
wire            pad_yy_icg_scan_en;
wire            rtu_yy_xx_flush;
wire            vector_ctrl_clk;
wire            vector_ctrl_clk_en;

//==========================================================
//              Vector Control Clock
//==========================================================
// Modified 2026-04-11: 门控时钟控制
assign vector_ctrl_clk_en = ex1_pipedown || 
                            vector_active || 
                            rtu_yy_xx_flush;

// &Instance("gated_clk_cell","x_vector_ctrl_clk"); @40
gated_clk_cell  x_vector_ctrl_clk (
  .clk_in             (forever_cpuclk    ),
  .clk_out            (vector_ctrl_clk   ),
  .external_en        (1'b0              ),
  .global_en          (cp0_yy_clk_en     ),
  .local_en           (vector_ctrl_clk_en),
  .module_en          (cp0_vfpu_icg_en   ),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//==========================================================
//              Vector Active State
//==========================================================
// Modified 2026-04-11: 向量操作活跃状态
always @(posedge vector_ctrl_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    vector_active <= 1'b0;
  else if(rtu_yy_xx_flush)
    vector_active <= 1'b0;
  else if(ex1_pipedown && ex1_is_vector)
    vector_active <= 1'b1;
  else if(vector_done)
    vector_active <= 1'b0;
  else
    vector_active <= vector_active;
end

//==========================================================
//              Vector Length (vl) Register
//==========================================================
// Modified 2026-04-11: 向量长度寄存器
always @(posedge vector_ctrl_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    current_vl[6:0] <= 7'b0;
  else if(rtu_yy_xx_flush)
    current_vl[6:0] <= 7'b0;
  else if(ex1_pipedown && ex1_is_vector)
    current_vl[6:0] <= ex1_vl[6:0];
  else
    current_vl[6:0] <= current_vl[6:0];
end

//==========================================================
//              Vector Start (vstart) Register
//==========================================================
// Modified 2026-04-11: 向量起始位置寄存器
always @(posedge vector_ctrl_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    current_vstart[6:0] <= 7'b0;
  else if(rtu_yy_xx_flush)
    current_vstart[6:0] <= 7'b0;
  else if(ex1_pipedown && ex1_is_vector)
    current_vstart[6:0] <= ex1_vstart[6:0];
  else if(element_done && !element_exception)
    current_vstart[6:0] <= current_vstart[6:0] + 7'b1;
  else
    current_vstart[6:0] <= current_vstart[6:0];
end

//==========================================================
//              Element Index Counter
//==========================================================
// Modified 2026-04-11: 元素索引计数器
always @(posedge vector_ctrl_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
    current_element_idx[6:0] <= 7'b0;
  else if(rtu_yy_xx_flush)
    current_element_idx[6:0] <= 7'b0;
  else if(ex1_pipedown && ex1_is_vector)
    current_element_idx[6:0] <= ex1_vstart[6:0];
  else if(element_done && vector_active)
    current_element_idx[6:0] <= current_element_idx[6:0] + 7'b1;
  else
    current_element_idx[6:0] <= current_element_idx[6:0];
end

assign element_idx[6:0] = current_element_idx[6:0];

//==========================================================
//              Mask Processing
//==========================================================
// Modified 2026-04-11: 掩码处理
// 从掩码寄存器中提取当前元素的掩码位
assign element_mask_bit = ex1_mask[current_element_idx[5:0]];

// 掩码输出：当vm=1时，所有元素都活跃；当vm=0时，根据掩码位决定
assign element_mask = element_mask_bit;

// 元素是否活跃：vm=1或掩码位为1
assign element_active = ex1_vm | element_mask_bit;

//==========================================================
//              Vector Done Signal
//==========================================================
// Modified 2026-04-11: 向量操作完成信号
// 当元素索引达到vl-1且当前元素处理完成时，向量操作完成
assign vector_done = (current_element_idx[6:0] >= current_vl[6:0] - 7'b1) && 
                     element_done && 
                     vector_active;

//==========================================================
//              Next vstart Value
//==========================================================
// Modified 2026-04-11: 更新的vstart值，用于异常恢复
assign next_vstart[6:0] = element_exception ? current_vstart[6:0] + 7'b1 : 7'b0;

// &ModuleEnd; @180
endmodule
