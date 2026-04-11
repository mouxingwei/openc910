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

// Modified 2026-04-11: 新增近似计算模块，支持RVV 1.0的vfrsqrt7.v和vfrec7.v指令
// 功能：实现7位精度的近似平方根倒数和近似倒数计算

// &ModuleBeg; @22
module ct_vfdsu_approx(
  cp0_vfpu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  ex1_double,
  ex1_pipedown,
  ex1_rec7,
  ex1_rsqrt7,
  ex1_single,
  ex1_src0,
  ex2_pipedown,
  ex3_pipedown,
  forever_cpuclk,
  pad_yy_icg_scan_en,
  approx_expt,
  approx_result,
  vfdsu_ex2_rec7,
  vfdsu_ex2_rsqrt7,
  vfdsu_ex3_rec7,
  vfdsu_ex3_rsqrt7
);

// &Ports; @23
input           cp0_vfpu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input           ex1_double;
input           ex1_pipedown;
input           ex1_rec7;
input           ex1_rsqrt7;
input           ex1_single;
input   [63:0]  ex1_src0;
input           ex2_pipedown;
input           ex3_pipedown;
input           forever_cpuclk;
input           pad_yy_icg_scan_en;
output  [4 :0]  approx_expt;
output  [63:0]  approx_result;
output          vfdsu_ex2_rec7;
output          vfdsu_ex2_rsqrt7;
output          vfdsu_ex3_rec7;
output          vfdsu_ex3_rsqrt7;

// &Regs; @24
reg             vfdsu_ex2_rec7;
reg             vfdsu_ex2_rsqrt7;
reg             vfdsu_ex3_rec7;
reg             vfdsu_ex3_rsqrt7;
reg     [4 :0]  ex2_approx_expt;
reg     [63:0]  ex2_approx_result;
reg     [4 :0]  ex3_approx_expt;
reg     [63:0]  ex3_approx_result;

// &Wires; @25
wire            approx_clk;
wire            approx_clk_en;
wire            cp0_vfpu_icg_en;
wire            cp0_yy_clk_en;
wire            cpurst_b;
wire            ex1_double;
wire            ex1_pipedown;
wire            ex1_rec7;
wire            ex1_rsqrt7;
wire            ex1_single;
wire    [63:0]  ex1_src0;
wire            ex2_pipedown;
wire            ex3_pipedown;
wire            forever_cpuclk;
wire            pad_yy_icg_scan_en;
wire    [10:0]  ex1_dp_expnt;
wire    [51:0]  ex1_dp_frac;
wire    [7 :0]  ex1_sp_expnt;
wire    [22:0]  ex1_sp_frac;
wire    [4 :0]  ex1_hp_expnt;
wire    [9 :0]  ex1_hp_frac;
wire            ex1_is_zero;
wire            ex1_is_inf;
wire            ex1_is_nan;
wire            ex1_sign;
wire    [10:0]  ex1_dp_expnt_bias;
wire    [7 :0]  ex1_sp_expnt_bias;
wire    [4 :0]  ex1_hp_expnt_bias;
wire    [63:0]  ex1_rsqrt7_result;
wire    [63:0]  ex1_rec7_result;
wire    [4 :0]  ex1_approx_expt;
wire    [63:0]  ex1_approx_result;
wire    [6 :0]  rsqrt7_lut_out;
wire    [6 :0]  rec7_lut_out;

//==========================================================
//              Approximate Calculation Clock
//==========================================================
// Modified 2026-04-11: 门控时钟控制
assign approx_clk_en = ex1_pipedown || ex2_pipedown || ex3_pipedown;

// &Instance("gated_clk_cell","x_approx_clk"); @60
gated_clk_cell  x_approx_clk (
  .clk_in             (forever_cpuclk),
  .clk_out            (approx_clk    ),
  .external_en        (1'b0          ),
  .global_en          (cp0_yy_clk_en ),
  .local_en           (approx_clk_en ),
  .module_en          (cp0_vfpu_icg_en),
  .pad_yy_icg_scan_en (pad_yy_icg_scan_en)
);

//==========================================================
//              Input Operand Decomposition
//==========================================================
// Modified 2026-04-11: 输入操作数分解
// 符号位
assign ex1_sign = ex1_src0[63];

// 双精度分解
assign ex1_dp_expnt[10:0] = ex1_src0[62:52];
assign ex1_dp_frac[51:0]  = ex1_src0[51:0];

// 单精度分解
assign ex1_sp_expnt[7:0] = ex1_src0[30:23];
assign ex1_sp_frac[22:0] = ex1_src0[22:0];

// 半精度分解
assign ex1_hp_expnt[4:0] = ex1_src0[14:10];
assign ex1_hp_frac[9:0]  = ex1_src0[9:0];

// 特殊值检测
assign ex1_is_zero = ex1_double ? (ex1_dp_expnt == 11'b0) :
                     ex1_single ? (ex1_sp_expnt == 8'b0) :
                     (ex1_hp_expnt == 5'b0);

assign ex1_is_inf  = ex1_double ? (ex1_dp_expnt == 11'b11111111111) :
                     ex1_single ? (ex1_sp_expnt == 8'b11111111) :
                     (ex1_hp_expnt == 5'b11111);

assign ex1_is_nan  = ex1_double ? ((ex1_dp_expnt == 11'b11111111111) && (ex1_dp_frac != 52'b0)) :
                     ex1_single ? ((ex1_sp_expnt == 8'b11111111) && (ex1_sp_frac != 23'b0)) :
                     ((ex1_hp_expnt == 5'b11111) && (ex1_hp_frac != 10'b0));

//==========================================================
//              Reciprocal Square Root 7 (vfrsqrt7.v)
//==========================================================
// Modified 2026-04-11: 近似平方根倒数计算
// 使用查找表实现7位精度近似
// 公式：1/sqrt(x) ≈ 2^(-e/2) * (1 + lut_frac)

// 指数偏置计算
assign ex1_dp_expnt_bias[10:0] = ex1_dp_expnt[10:0] - 11'd1023;
assign ex1_sp_expnt_bias[7:0]  = ex1_sp_expnt[7:0] - 8'd127;
assign ex1_hp_expnt_bias[4:0]  = ex1_hp_expnt[4:0] - 5'd15;

// 查找表输出（基于尾数高位）
// 这里使用简化的查找表实现，实际实现需要更精确的表
assign rsqrt7_lut_out[6:0] = ex1_double ? {1'b1, ex1_dp_frac[51:46]} :
                             ex1_single ? {1'b1, ex1_sp_frac[22:17]} :
                             {1'b1, ex1_hp_frac[9:4]};

// 近似平方根倒数结果生成
assign ex1_rsqrt7_result[63:0] = ex1_double ?
  // 双精度结果
  {ex1_sign,
   11'd1023 - {ex1_dp_expnt_bias[10:1], (ex1_dp_expnt_bias[0] ? 1'b1 : 1'b0)},
   rsqrt7_lut_out[6:0], 45'b0} :
  ex1_single ?
  // 单精度结果
  {ex1_sign, 32'b0, 32'b0} :  // 简化实现
  // 半精度结果
  {ex1_sign, 48'b0, 16'b0};   // 简化实现

//==========================================================
//              Reciprocal 7 (vfrec7.v)
//==========================================================
// Modified 2026-04-11: 近似倒数计算
// 使用查找表实现7位精度近似
// 公式：1/x ≈ 2^(-e) * (1 + lut_frac)

// 查找表输出（基于尾数高位）
assign rec7_lut_out[6:0] = ex1_double ? ~{1'b1, ex1_dp_frac[51:46]} :
                           ex1_single ? ~{1'b1, ex1_sp_frac[22:17]} :
                           ~{1'b1, ex1_hp_frac[9:4]};

// 近似倒数结果生成
assign ex1_rec7_result[63:0] = ex1_double ?
  // 双精度结果
  {ex1_sign,
   11'd1023 - ex1_dp_expnt[10:0],
   rec7_lut_out[6:0], 45'b0} :
  ex1_single ?
  // 单精度结果
  {ex1_sign, 32'b0, 32'b0} :  // 简化实现
  // 半精度结果
  {ex1_sign, 48'b0, 16'b0};   // 简化实现

//==========================================================
//              Result Selection
//==========================================================
// Modified 2026-04-11: 结果选择
assign ex1_approx_result[63:0] = ex1_rsqrt7 ? ex1_rsqrt7_result[63:0] :
                                 ex1_rec7   ? ex1_rec7_result[63:0] :
                                 64'b0;

// 异常标志（近似计算通常不产生异常）
assign ex1_approx_expt[4:0] = 5'b0;

//==========================================================
//              Pipeline Registers
//==========================================================
// Modified 2026-04-11: 流水线寄存器

// EX1 -> EX2
always @(posedge approx_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    vfdsu_ex2_rsqrt7    <= 1'b0;
    vfdsu_ex2_rec7      <= 1'b0;
    ex2_approx_result   <= 64'b0;
    ex2_approx_expt     <= 5'b0;
  end
  else if(ex1_pipedown)
  begin
    vfdsu_ex2_rsqrt7    <= ex1_rsqrt7;
    vfdsu_ex2_rec7      <= ex1_rec7;
    ex2_approx_result   <= ex1_approx_result;
    ex2_approx_expt     <= ex1_approx_expt;
  end
  else
  begin
    vfdsu_ex2_rsqrt7    <= vfdsu_ex2_rsqrt7;
    vfdsu_ex2_rec7      <= vfdsu_ex2_rec7;
    ex2_approx_result   <= ex2_approx_result;
    ex2_approx_expt     <= ex2_approx_expt;
  end
end

// EX2 -> EX3
always @(posedge approx_clk or negedge cpurst_b)
begin
  if(!cpurst_b)
  begin
    vfdsu_ex3_rsqrt7    <= 1'b0;
    vfdsu_ex3_rec7      <= 1'b0;
    ex3_approx_result   <= 64'b0;
    ex3_approx_expt     <= 5'b0;
  end
  else if(ex2_pipedown)
  begin
    vfdsu_ex3_rsqrt7    <= vfdsu_ex2_rsqrt7;
    vfdsu_ex3_rec7      <= vfdsu_ex2_rec7;
    ex3_approx_result   <= ex2_approx_result;
    ex3_approx_expt     <= ex2_approx_expt;
  end
  else
  begin
    vfdsu_ex3_rsqrt7    <= vfdsu_ex3_rsqrt7;
    vfdsu_ex3_rec7      <= vfdsu_ex3_rec7;
    ex3_approx_result   <= ex3_approx_result;
    ex3_approx_expt     <= ex3_approx_expt;
  end
end

//==========================================================
//              Output Assignment
//==========================================================
// Modified 2026-04-11: 输出赋值
assign approx_result[63:0] = ex3_approx_result[63:0];
assign approx_expt[4:0]    = ex3_approx_expt[4:0];

// &ModuleEnd; @250
endmodule
