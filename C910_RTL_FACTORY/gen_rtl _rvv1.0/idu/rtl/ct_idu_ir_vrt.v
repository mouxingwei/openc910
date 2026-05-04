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

//==========================================================
//                 Vector Rename Table
//==========================================================
// P0 RVV1.0 implementation:
//   - 32 architectural vector registers, single physical vreg mapping.
//   - 4-way rename write, in-packet RAW/WAW bypass.
//   - v0 mask source read through srcvm.
//   - reset/recover mapping support.
//   - ready/wb update from existing LSU/VFPU/RF vector destination paths.
//
// LMUL/EMUL group rename is intentionally left for the next development
// stage; the current interface still carries one physical vreg per dst.

module ct_idu_ir_vrt(
  cp0_idu_icg_en,
  cp0_yy_clk_en,
  cpurst_b,
  ctrl_ir_stall,
  ctrl_rt_inst0_vld,
  ctrl_rt_inst1_vld,
  ctrl_rt_inst2_vld,
  ctrl_rt_inst3_vld,
  ctrl_xx_rf_pipe6_vmla_lch_vld_dupx,
  ctrl_xx_rf_pipe7_vmla_lch_vld_dupx,
  dp_vrt_inst0_dst_vreg,
  dp_vrt_inst0_dstv_reg,
  dp_vrt_inst0_dstv_vld,
  dp_vrt_inst0_srcv0_reg,
  dp_vrt_inst0_srcv0_vld,
  dp_vrt_inst0_srcv1_reg,
  dp_vrt_inst0_srcv1_vld,
  dp_vrt_inst0_srcv2_vld,
  dp_vrt_inst0_srcvm_vld,
  dp_vrt_inst0_vmla,
  dp_vrt_inst1_dst_vreg,
  dp_vrt_inst1_dstv_reg,
  dp_vrt_inst1_dstv_vld,
  dp_vrt_inst1_srcv0_reg,
  dp_vrt_inst1_srcv0_vld,
  dp_vrt_inst1_srcv1_reg,
  dp_vrt_inst1_srcv1_vld,
  dp_vrt_inst1_srcv2_vld,
  dp_vrt_inst1_srcvm_vld,
  dp_vrt_inst1_vmla,
  dp_vrt_inst2_dst_vreg,
  dp_vrt_inst2_dstv_reg,
  dp_vrt_inst2_dstv_vld,
  dp_vrt_inst2_srcv0_reg,
  dp_vrt_inst2_srcv0_vld,
  dp_vrt_inst2_srcv1_reg,
  dp_vrt_inst2_srcv1_vld,
  dp_vrt_inst2_srcv2_vld,
  dp_vrt_inst2_srcvm_vld,
  dp_vrt_inst2_vmla,
  dp_vrt_inst3_dst_vreg,
  dp_vrt_inst3_dstv_reg,
  dp_vrt_inst3_dstv_vld,
  dp_vrt_inst3_srcv0_reg,
  dp_vrt_inst3_srcv0_vld,
  dp_vrt_inst3_srcv1_reg,
  dp_vrt_inst3_srcv1_vld,
  dp_vrt_inst3_srcv2_vld,
  dp_vrt_inst3_srcvm_vld,
  dp_vrt_inst3_vmla,
  dp_xx_rf_pipe6_dst_vreg_dupx,
  dp_xx_rf_pipe7_dst_vreg_dupx,
  forever_cpuclk,
  ifu_xx_sync_reset,
  lsu_idu_ag_pipe3_vload_inst_vld,
  lsu_idu_ag_pipe3_vreg_dupx,
  lsu_idu_dc_pipe3_vload_inst_vld_dupx,
  lsu_idu_dc_pipe3_vreg_dupx,
  lsu_idu_wb_pipe3_wb_vreg_dupx,
  lsu_idu_wb_pipe3_wb_vreg_vld_dupx,
  pad_yy_icg_scan_en,
  rtu_idu_flush_fe,
  rtu_idu_flush_is,
  rtu_idu_rt_recover_vreg,
  rtu_yy_xx_flush,
  vfpu_idu_ex1_pipe6_data_vld_dupx,
  vfpu_idu_ex1_pipe6_fmla_data_vld_dupx,
  vfpu_idu_ex1_pipe6_vreg_dupx,
  vfpu_idu_ex1_pipe7_data_vld_dupx,
  vfpu_idu_ex1_pipe7_fmla_data_vld_dupx,
  vfpu_idu_ex1_pipe7_vreg_dupx,
  vfpu_idu_ex2_pipe6_data_vld_dupx,
  vfpu_idu_ex2_pipe6_fmla_data_vld_dupx,
  vfpu_idu_ex2_pipe6_vreg_dupx,
  vfpu_idu_ex2_pipe7_data_vld_dupx,
  vfpu_idu_ex2_pipe7_fmla_data_vld_dupx,
  vfpu_idu_ex2_pipe7_vreg_dupx,
  vfpu_idu_ex3_pipe6_data_vld_dupx,
  vfpu_idu_ex3_pipe6_vreg_dupx,
  vfpu_idu_ex3_pipe7_data_vld_dupx,
  vfpu_idu_ex3_pipe7_vreg_dupx,
  vfpu_idu_ex5_pipe6_wb_vreg_dupx,
  vfpu_idu_ex5_pipe6_wb_vreg_vld_dupx,
  vfpu_idu_ex5_pipe7_wb_vreg_dupx,
  vfpu_idu_ex5_pipe7_wb_vreg_vld_dupx,
  vrt_dp_inst01_srcv2_match,
  vrt_dp_inst02_srcv2_match,
  vrt_dp_inst03_srcv2_match,
  vrt_dp_inst0_rel_vreg,
  vrt_dp_inst0_srcv0_data,
  vrt_dp_inst0_srcv1_data,
  vrt_dp_inst0_srcv2_data,
  vrt_dp_inst0_srcvm_data,
  vrt_dp_inst12_srcv2_match,
  vrt_dp_inst13_srcv2_match,
  vrt_dp_inst1_rel_vreg,
  vrt_dp_inst1_srcv0_data,
  vrt_dp_inst1_srcv1_data,
  vrt_dp_inst1_srcv2_data,
  vrt_dp_inst1_srcvm_data,
  vrt_dp_inst23_srcv2_match,
  vrt_dp_inst2_rel_vreg,
  vrt_dp_inst2_srcv0_data,
  vrt_dp_inst2_srcv1_data,
  vrt_dp_inst2_srcv2_data,
  vrt_dp_inst2_srcvm_data,
  vrt_dp_inst3_rel_vreg,
  vrt_dp_inst3_srcv0_data,
  vrt_dp_inst3_srcv1_data,
  vrt_dp_inst3_srcv2_data,
  vrt_dp_inst3_srcvm_data
);

input           cp0_idu_icg_en;
input           cp0_yy_clk_en;
input           cpurst_b;
input           ctrl_ir_stall;
input           ctrl_rt_inst0_vld;
input           ctrl_rt_inst1_vld;
input           ctrl_rt_inst2_vld;
input           ctrl_rt_inst3_vld;
input           ctrl_xx_rf_pipe6_vmla_lch_vld_dupx;
input           ctrl_xx_rf_pipe7_vmla_lch_vld_dupx;
input   [5 :0]  dp_vrt_inst0_dst_vreg;
input   [5 :0]  dp_vrt_inst0_dstv_reg;
input           dp_vrt_inst0_dstv_vld;
input   [5 :0]  dp_vrt_inst0_srcv0_reg;
input           dp_vrt_inst0_srcv0_vld;
input   [5 :0]  dp_vrt_inst0_srcv1_reg;
input           dp_vrt_inst0_srcv1_vld;
input           dp_vrt_inst0_srcv2_vld;
input           dp_vrt_inst0_srcvm_vld;
input           dp_vrt_inst0_vmla;
input   [5 :0]  dp_vrt_inst1_dst_vreg;
input   [5 :0]  dp_vrt_inst1_dstv_reg;
input           dp_vrt_inst1_dstv_vld;
input   [5 :0]  dp_vrt_inst1_srcv0_reg;
input           dp_vrt_inst1_srcv0_vld;
input   [5 :0]  dp_vrt_inst1_srcv1_reg;
input           dp_vrt_inst1_srcv1_vld;
input           dp_vrt_inst1_srcv2_vld;
input           dp_vrt_inst1_srcvm_vld;
input           dp_vrt_inst1_vmla;
input   [5 :0]  dp_vrt_inst2_dst_vreg;
input   [5 :0]  dp_vrt_inst2_dstv_reg;
input           dp_vrt_inst2_dstv_vld;
input   [5 :0]  dp_vrt_inst2_srcv0_reg;
input           dp_vrt_inst2_srcv0_vld;
input   [5 :0]  dp_vrt_inst2_srcv1_reg;
input           dp_vrt_inst2_srcv1_vld;
input           dp_vrt_inst2_srcv2_vld;
input           dp_vrt_inst2_srcvm_vld;
input           dp_vrt_inst2_vmla;
input   [5 :0]  dp_vrt_inst3_dst_vreg;
input   [5 :0]  dp_vrt_inst3_dstv_reg;
input           dp_vrt_inst3_dstv_vld;
input   [5 :0]  dp_vrt_inst3_srcv0_reg;
input           dp_vrt_inst3_srcv0_vld;
input   [5 :0]  dp_vrt_inst3_srcv1_reg;
input           dp_vrt_inst3_srcv1_vld;
input           dp_vrt_inst3_srcv2_vld;
input           dp_vrt_inst3_srcvm_vld;
input           dp_vrt_inst3_vmla;
input   [6 :0]  dp_xx_rf_pipe6_dst_vreg_dupx;
input   [6 :0]  dp_xx_rf_pipe7_dst_vreg_dupx;
input           forever_cpuclk;
input           ifu_xx_sync_reset;
input           lsu_idu_ag_pipe3_vload_inst_vld;
input   [6 :0]  lsu_idu_ag_pipe3_vreg_dupx;
input           lsu_idu_dc_pipe3_vload_inst_vld_dupx;
input   [6 :0]  lsu_idu_dc_pipe3_vreg_dupx;
input   [6 :0]  lsu_idu_wb_pipe3_wb_vreg_dupx;
input           lsu_idu_wb_pipe3_wb_vreg_vld_dupx;
input           pad_yy_icg_scan_en;
input           rtu_idu_flush_fe;
input           rtu_idu_flush_is;
input   [191:0] rtu_idu_rt_recover_vreg;
input           rtu_yy_xx_flush;
input           vfpu_idu_ex1_pipe6_data_vld_dupx;
input           vfpu_idu_ex1_pipe6_fmla_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex1_pipe6_vreg_dupx;
input           vfpu_idu_ex1_pipe7_data_vld_dupx;
input           vfpu_idu_ex1_pipe7_fmla_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex1_pipe7_vreg_dupx;
input           vfpu_idu_ex2_pipe6_data_vld_dupx;
input           vfpu_idu_ex2_pipe6_fmla_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex2_pipe6_vreg_dupx;
input           vfpu_idu_ex2_pipe7_data_vld_dupx;
input           vfpu_idu_ex2_pipe7_fmla_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex2_pipe7_vreg_dupx;
input           vfpu_idu_ex3_pipe6_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex3_pipe6_vreg_dupx;
input           vfpu_idu_ex3_pipe7_data_vld_dupx;
input   [6 :0]  vfpu_idu_ex3_pipe7_vreg_dupx;
input   [6 :0]  vfpu_idu_ex5_pipe6_wb_vreg_dupx;
input           vfpu_idu_ex5_pipe6_wb_vreg_vld_dupx;
input   [6 :0]  vfpu_idu_ex5_pipe7_wb_vreg_dupx;
input           vfpu_idu_ex5_pipe7_wb_vreg_vld_dupx;
output          vrt_dp_inst01_srcv2_match;
output          vrt_dp_inst02_srcv2_match;
output          vrt_dp_inst03_srcv2_match;
output  [6 :0]  vrt_dp_inst0_rel_vreg;
output  [8 :0]  vrt_dp_inst0_srcv0_data;
output  [8 :0]  vrt_dp_inst0_srcv1_data;
output  [9 :0]  vrt_dp_inst0_srcv2_data;
output  [8 :0]  vrt_dp_inst0_srcvm_data;
output          vrt_dp_inst12_srcv2_match;
output          vrt_dp_inst13_srcv2_match;
output  [6 :0]  vrt_dp_inst1_rel_vreg;
output  [8 :0]  vrt_dp_inst1_srcv0_data;
output  [8 :0]  vrt_dp_inst1_srcv1_data;
output  [9 :0]  vrt_dp_inst1_srcv2_data;
output  [8 :0]  vrt_dp_inst1_srcvm_data;
output          vrt_dp_inst23_srcv2_match;
output  [6 :0]  vrt_dp_inst2_rel_vreg;
output  [8 :0]  vrt_dp_inst2_srcv0_data;
output  [8 :0]  vrt_dp_inst2_srcv1_data;
output  [9 :0]  vrt_dp_inst2_srcv2_data;
output  [8 :0]  vrt_dp_inst2_srcvm_data;
output  [6 :0]  vrt_dp_inst3_rel_vreg;
output  [8 :0]  vrt_dp_inst3_srcv0_data;
output  [8 :0]  vrt_dp_inst3_srcv1_data;
output  [9 :0]  vrt_dp_inst3_srcv2_data;
output  [8 :0]  vrt_dp_inst3_srcvm_data;

reg     [6 :0]  vreg_map [0:31];
reg             vreg_rdy [0:31];
reg             vreg_wb  [0:31];
reg             vreg_mla_rdy [0:31];

integer         i;

wire            vrt_recover_updt_vld;
wire            vrt_write0_en;
wire            vrt_write1_en;
wire            vrt_write2_en;
wire            vrt_write3_en;

assign vrt_recover_updt_vld = ifu_xx_sync_reset || rtu_yy_xx_flush;

assign vrt_write0_en = ctrl_rt_inst0_vld
                       && !ctrl_ir_stall
                       && !vrt_recover_updt_vld
                       && dp_vrt_inst0_dstv_vld;
assign vrt_write1_en = ctrl_rt_inst1_vld
                       && !ctrl_ir_stall
                       && !vrt_recover_updt_vld
                       && dp_vrt_inst1_dstv_vld;
assign vrt_write2_en = ctrl_rt_inst2_vld
                       && !ctrl_ir_stall
                       && !vrt_recover_updt_vld
                       && dp_vrt_inst2_dstv_vld;
assign vrt_write3_en = ctrl_rt_inst3_vld
                       && !ctrl_ir_stall
                       && !vrt_recover_updt_vld
                       && dp_vrt_inst3_dstv_vld;

function [6:0] recover_vreg;
  input [4:0] arch_reg;
  begin
    case(arch_reg[4:0])
      5'd0:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[5:0]};
      5'd1:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[11:6]};
      5'd2:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[17:12]};
      5'd3:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[23:18]};
      5'd4:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[29:24]};
      5'd5:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[35:30]};
      5'd6:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[41:36]};
      5'd7:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[47:42]};
      5'd8:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[53:48]};
      5'd9:  recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[59:54]};
      5'd10: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[65:60]};
      5'd11: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[71:66]};
      5'd12: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[77:72]};
      5'd13: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[83:78]};
      5'd14: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[89:84]};
      5'd15: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[95:90]};
      5'd16: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[101:96]};
      5'd17: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[107:102]};
      5'd18: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[113:108]};
      5'd19: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[119:114]};
      5'd20: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[125:120]};
      5'd21: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[131:126]};
      5'd22: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[137:132]};
      5'd23: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[143:138]};
      5'd24: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[149:144]};
      5'd25: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[155:150]};
      5'd26: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[161:156]};
      5'd27: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[167:162]};
      5'd28: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[173:168]};
      5'd29: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[179:174]};
      5'd30: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[185:180]};
      5'd31: recover_vreg = {1'b0, rtu_idu_rt_recover_vreg[191:186]};
      default: recover_vreg = 7'b0;
    endcase
  end
endfunction

function ready_hit;
  input [6:0] cur_vreg;
  begin
    ready_hit =
          (ctrl_xx_rf_pipe6_vmla_lch_vld_dupx
           && (cur_vreg == dp_xx_rf_pipe6_dst_vreg_dupx))
       || (ctrl_xx_rf_pipe7_vmla_lch_vld_dupx
           && (cur_vreg == dp_xx_rf_pipe7_dst_vreg_dupx))
       || (lsu_idu_ag_pipe3_vload_inst_vld
           && (cur_vreg == lsu_idu_ag_pipe3_vreg_dupx))
       || (lsu_idu_dc_pipe3_vload_inst_vld_dupx
           && (cur_vreg == lsu_idu_dc_pipe3_vreg_dupx))
       || (lsu_idu_wb_pipe3_wb_vreg_vld_dupx
           && (cur_vreg == lsu_idu_wb_pipe3_wb_vreg_dupx))
       || (vfpu_idu_ex1_pipe6_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe6_vreg_dupx))
       || (vfpu_idu_ex1_pipe6_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe6_vreg_dupx))
       || (vfpu_idu_ex1_pipe7_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe7_vreg_dupx))
       || (vfpu_idu_ex1_pipe7_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe7_vreg_dupx))
       || (vfpu_idu_ex2_pipe6_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe6_vreg_dupx))
       || (vfpu_idu_ex2_pipe6_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe6_vreg_dupx))
       || (vfpu_idu_ex2_pipe7_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe7_vreg_dupx))
       || (vfpu_idu_ex2_pipe7_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe7_vreg_dupx))
       || (vfpu_idu_ex3_pipe6_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex3_pipe6_vreg_dupx))
       || (vfpu_idu_ex3_pipe7_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex3_pipe7_vreg_dupx))
       || (vfpu_idu_ex5_pipe6_wb_vreg_vld_dupx
           && (cur_vreg == vfpu_idu_ex5_pipe6_wb_vreg_dupx))
       || (vfpu_idu_ex5_pipe7_wb_vreg_vld_dupx
           && (cur_vreg == vfpu_idu_ex5_pipe7_wb_vreg_dupx));
  end
endfunction

function wb_hit;
  input [6:0] cur_vreg;
  begin
    wb_hit =
          (lsu_idu_wb_pipe3_wb_vreg_vld_dupx
           && (cur_vreg == lsu_idu_wb_pipe3_wb_vreg_dupx))
       || (vfpu_idu_ex5_pipe6_wb_vreg_vld_dupx
           && (cur_vreg == vfpu_idu_ex5_pipe6_wb_vreg_dupx))
       || (vfpu_idu_ex5_pipe7_wb_vreg_vld_dupx
           && (cur_vreg == vfpu_idu_ex5_pipe7_wb_vreg_dupx));
  end
endfunction

function mla_hit;
  input [6:0] cur_vreg;
  begin
    mla_hit =
          (ctrl_xx_rf_pipe6_vmla_lch_vld_dupx
           && (cur_vreg == dp_xx_rf_pipe6_dst_vreg_dupx))
       || (ctrl_xx_rf_pipe7_vmla_lch_vld_dupx
           && (cur_vreg == dp_xx_rf_pipe7_dst_vreg_dupx))
       || (vfpu_idu_ex1_pipe6_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe6_vreg_dupx))
       || (vfpu_idu_ex1_pipe7_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex1_pipe7_vreg_dupx))
       || (vfpu_idu_ex2_pipe6_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe6_vreg_dupx))
       || (vfpu_idu_ex2_pipe7_fmla_data_vld_dupx
           && (cur_vreg == vfpu_idu_ex2_pipe7_vreg_dupx));
  end
endfunction

always @(posedge forever_cpuclk or negedge cpurst_b) begin
  if(!cpurst_b) begin
    for(i = 0; i < 32; i = i + 1) begin
      vreg_map[i]     <= {2'b0, i[4:0]};
      vreg_rdy[i]     <= 1'b1;
      vreg_wb[i]      <= 1'b1;
      vreg_mla_rdy[i] <= 1'b1;
    end
  end
  else if(vrt_recover_updt_vld) begin
    for(i = 0; i < 32; i = i + 1) begin
      vreg_map[i]     <= ifu_xx_sync_reset ? {2'b0, i[4:0]} : recover_vreg(i[4:0]);
      vreg_rdy[i]     <= 1'b1;
      vreg_wb[i]      <= 1'b1;
      vreg_mla_rdy[i] <= 1'b1;
    end
  end
  else begin
    for(i = 0; i < 32; i = i + 1) begin
      if(ready_hit(vreg_map[i]))
        vreg_rdy[i] <= 1'b1;
      if(wb_hit(vreg_map[i]))
        vreg_wb[i] <= 1'b1;
      if(mla_hit(vreg_map[i]))
        vreg_mla_rdy[i] <= 1'b1;
    end

    if(vrt_write0_en) begin
      vreg_map[dp_vrt_inst0_dstv_reg[4:0]]     <= {1'b0, dp_vrt_inst0_dst_vreg[5:0]};
      vreg_rdy[dp_vrt_inst0_dstv_reg[4:0]]     <= 1'b0;
      vreg_wb[dp_vrt_inst0_dstv_reg[4:0]]      <= 1'b0;
      vreg_mla_rdy[dp_vrt_inst0_dstv_reg[4:0]] <= !dp_vrt_inst0_vmla;
    end
    if(vrt_write1_en) begin
      vreg_map[dp_vrt_inst1_dstv_reg[4:0]]     <= {1'b0, dp_vrt_inst1_dst_vreg[5:0]};
      vreg_rdy[dp_vrt_inst1_dstv_reg[4:0]]     <= 1'b0;
      vreg_wb[dp_vrt_inst1_dstv_reg[4:0]]      <= 1'b0;
      vreg_mla_rdy[dp_vrt_inst1_dstv_reg[4:0]] <= !dp_vrt_inst1_vmla;
    end
    if(vrt_write2_en) begin
      vreg_map[dp_vrt_inst2_dstv_reg[4:0]]     <= {1'b0, dp_vrt_inst2_dst_vreg[5:0]};
      vreg_rdy[dp_vrt_inst2_dstv_reg[4:0]]     <= 1'b0;
      vreg_wb[dp_vrt_inst2_dstv_reg[4:0]]      <= 1'b0;
      vreg_mla_rdy[dp_vrt_inst2_dstv_reg[4:0]] <= !dp_vrt_inst2_vmla;
    end
    if(vrt_write3_en) begin
      vreg_map[dp_vrt_inst3_dstv_reg[4:0]]     <= {1'b0, dp_vrt_inst3_dst_vreg[5:0]};
      vreg_rdy[dp_vrt_inst3_dstv_reg[4:0]]     <= 1'b0;
      vreg_wb[dp_vrt_inst3_dstv_reg[4:0]]      <= 1'b0;
      vreg_mla_rdy[dp_vrt_inst3_dstv_reg[4:0]] <= !dp_vrt_inst3_vmla;
    end
  end
end

function [6:0] rel_after_inst0;
  input [5:0] arch_reg;
  begin
    rel_after_inst0 = vreg_map[arch_reg[4:0]];
  end
endfunction

function [6:0] rel_after_inst1;
  input [5:0] arch_reg;
  begin
    if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      rel_after_inst1 = {1'b0, dp_vrt_inst0_dst_vreg[5:0]};
    else
      rel_after_inst1 = vreg_map[arch_reg[4:0]];
  end
endfunction

function [6:0] rel_after_inst2;
  input [5:0] arch_reg;
  begin
    if(vrt_write1_en && (arch_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]))
      rel_after_inst2 = {1'b0, dp_vrt_inst1_dst_vreg[5:0]};
    else if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      rel_after_inst2 = {1'b0, dp_vrt_inst0_dst_vreg[5:0]};
    else
      rel_after_inst2 = vreg_map[arch_reg[4:0]];
  end
endfunction

function [6:0] rel_after_inst3;
  input [5:0] arch_reg;
  begin
    if(vrt_write2_en && (arch_reg[4:0] == dp_vrt_inst2_dstv_reg[4:0]))
      rel_after_inst3 = {1'b0, dp_vrt_inst2_dst_vreg[5:0]};
    else if(vrt_write1_en && (arch_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]))
      rel_after_inst3 = {1'b0, dp_vrt_inst1_dst_vreg[5:0]};
    else if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      rel_after_inst3 = {1'b0, dp_vrt_inst0_dst_vreg[5:0]};
    else
      rel_after_inst3 = vreg_map[arch_reg[4:0]];
  end
endfunction

function [9:0] src_lookup0;
  input       src_vld;
  input [5:0] arch_reg;
  begin
    if(!src_vld)
      src_lookup0 = {1'b1, 7'b0, 1'b1, 1'b1};
    else
      src_lookup0 = {vreg_mla_rdy[arch_reg[4:0]],
                     vreg_map[arch_reg[4:0]],
                     vreg_wb[arch_reg[4:0]],
                     vreg_rdy[arch_reg[4:0]]};
  end
endfunction

function [9:0] src_lookup1;
  input       src_vld;
  input [5:0] arch_reg;
  begin
    if(!src_vld)
      src_lookup1 = {1'b1, 7'b0, 1'b1, 1'b1};
    else if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      src_lookup1 = {!dp_vrt_inst0_vmla, {1'b0, dp_vrt_inst0_dst_vreg[5:0]}, 1'b0, 1'b0};
    else
      src_lookup1 = {vreg_mla_rdy[arch_reg[4:0]],
                     vreg_map[arch_reg[4:0]],
                     vreg_wb[arch_reg[4:0]],
                     vreg_rdy[arch_reg[4:0]]};
  end
endfunction

function [9:0] src_lookup2;
  input       src_vld;
  input [5:0] arch_reg;
  begin
    if(!src_vld)
      src_lookup2 = {1'b1, 7'b0, 1'b1, 1'b1};
    else if(vrt_write1_en && (arch_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]))
      src_lookup2 = {!dp_vrt_inst1_vmla, {1'b0, dp_vrt_inst1_dst_vreg[5:0]}, 1'b0, 1'b0};
    else if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      src_lookup2 = {!dp_vrt_inst0_vmla, {1'b0, dp_vrt_inst0_dst_vreg[5:0]}, 1'b0, 1'b0};
    else
      src_lookup2 = {vreg_mla_rdy[arch_reg[4:0]],
                     vreg_map[arch_reg[4:0]],
                     vreg_wb[arch_reg[4:0]],
                     vreg_rdy[arch_reg[4:0]]};
  end
endfunction

function [9:0] src_lookup3;
  input       src_vld;
  input [5:0] arch_reg;
  begin
    if(!src_vld)
      src_lookup3 = {1'b1, 7'b0, 1'b1, 1'b1};
    else if(vrt_write2_en && (arch_reg[4:0] == dp_vrt_inst2_dstv_reg[4:0]))
      src_lookup3 = {!dp_vrt_inst2_vmla, {1'b0, dp_vrt_inst2_dst_vreg[5:0]}, 1'b0, 1'b0};
    else if(vrt_write1_en && (arch_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]))
      src_lookup3 = {!dp_vrt_inst1_vmla, {1'b0, dp_vrt_inst1_dst_vreg[5:0]}, 1'b0, 1'b0};
    else if(vrt_write0_en && (arch_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]))
      src_lookup3 = {!dp_vrt_inst0_vmla, {1'b0, dp_vrt_inst0_dst_vreg[5:0]}, 1'b0, 1'b0};
    else
      src_lookup3 = {vreg_mla_rdy[arch_reg[4:0]],
                     vreg_map[arch_reg[4:0]],
                     vreg_wb[arch_reg[4:0]],
                     vreg_rdy[arch_reg[4:0]]};
  end
endfunction

wire [9:0] inst0_srcv0_lookup;
wire [9:0] inst0_srcv1_lookup;
wire [9:0] inst0_srcv2_lookup;
wire [9:0] inst0_srcvm_lookup;
wire [9:0] inst1_srcv0_lookup;
wire [9:0] inst1_srcv1_lookup;
wire [9:0] inst1_srcv2_lookup;
wire [9:0] inst1_srcvm_lookup;
wire [9:0] inst2_srcv0_lookup;
wire [9:0] inst2_srcv1_lookup;
wire [9:0] inst2_srcv2_lookup;
wire [9:0] inst2_srcvm_lookup;
wire [9:0] inst3_srcv0_lookup;
wire [9:0] inst3_srcv1_lookup;
wire [9:0] inst3_srcv2_lookup;
wire [9:0] inst3_srcvm_lookup;

// Current VRT interface does not carry srcv2 register index.  The RVV
// branch uses srcv1 as the conservative srcv2 address until IR DP grows a
// dedicated srcv2_reg port.
assign inst0_srcv0_lookup = src_lookup0(dp_vrt_inst0_srcv0_vld, dp_vrt_inst0_srcv0_reg);
assign inst0_srcv1_lookup = src_lookup0(dp_vrt_inst0_srcv1_vld, dp_vrt_inst0_srcv1_reg);
assign inst0_srcv2_lookup = src_lookup0(dp_vrt_inst0_srcv2_vld, dp_vrt_inst0_srcv1_reg);
assign inst0_srcvm_lookup = src_lookup0(dp_vrt_inst0_srcvm_vld, 6'd0);

assign inst1_srcv0_lookup = src_lookup1(dp_vrt_inst1_srcv0_vld, dp_vrt_inst1_srcv0_reg);
assign inst1_srcv1_lookup = src_lookup1(dp_vrt_inst1_srcv1_vld, dp_vrt_inst1_srcv1_reg);
assign inst1_srcv2_lookup = src_lookup1(dp_vrt_inst1_srcv2_vld, dp_vrt_inst1_srcv1_reg);
assign inst1_srcvm_lookup = src_lookup1(dp_vrt_inst1_srcvm_vld, 6'd0);

assign inst2_srcv0_lookup = src_lookup2(dp_vrt_inst2_srcv0_vld, dp_vrt_inst2_srcv0_reg);
assign inst2_srcv1_lookup = src_lookup2(dp_vrt_inst2_srcv1_vld, dp_vrt_inst2_srcv1_reg);
assign inst2_srcv2_lookup = src_lookup2(dp_vrt_inst2_srcv2_vld, dp_vrt_inst2_srcv1_reg);
assign inst2_srcvm_lookup = src_lookup2(dp_vrt_inst2_srcvm_vld, 6'd0);

assign inst3_srcv0_lookup = src_lookup3(dp_vrt_inst3_srcv0_vld, dp_vrt_inst3_srcv0_reg);
assign inst3_srcv1_lookup = src_lookup3(dp_vrt_inst3_srcv1_vld, dp_vrt_inst3_srcv1_reg);
assign inst3_srcv2_lookup = src_lookup3(dp_vrt_inst3_srcv2_vld, dp_vrt_inst3_srcv1_reg);
assign inst3_srcvm_lookup = src_lookup3(dp_vrt_inst3_srcvm_vld, 6'd0);

assign vrt_dp_inst0_srcv0_data[8:0] = inst0_srcv0_lookup[8:0];
assign vrt_dp_inst0_srcv1_data[8:0] = inst0_srcv1_lookup[8:0];
assign vrt_dp_inst0_srcv2_data[9:0] = inst0_srcv2_lookup[9:0];
assign vrt_dp_inst0_srcvm_data[8:0] = inst0_srcvm_lookup[8:0];

assign vrt_dp_inst1_srcv0_data[8:0] = inst1_srcv0_lookup[8:0];
assign vrt_dp_inst1_srcv1_data[8:0] = inst1_srcv1_lookup[8:0];
assign vrt_dp_inst1_srcv2_data[9:0] = inst1_srcv2_lookup[9:0];
assign vrt_dp_inst1_srcvm_data[8:0] = inst1_srcvm_lookup[8:0];

assign vrt_dp_inst2_srcv0_data[8:0] = inst2_srcv0_lookup[8:0];
assign vrt_dp_inst2_srcv1_data[8:0] = inst2_srcv1_lookup[8:0];
assign vrt_dp_inst2_srcv2_data[9:0] = inst2_srcv2_lookup[9:0];
assign vrt_dp_inst2_srcvm_data[8:0] = inst2_srcvm_lookup[8:0];

assign vrt_dp_inst3_srcv0_data[8:0] = inst3_srcv0_lookup[8:0];
assign vrt_dp_inst3_srcv1_data[8:0] = inst3_srcv1_lookup[8:0];
assign vrt_dp_inst3_srcv2_data[9:0] = inst3_srcv2_lookup[9:0];
assign vrt_dp_inst3_srcvm_data[8:0] = inst3_srcvm_lookup[8:0];

assign vrt_dp_inst0_rel_vreg[6:0] = rel_after_inst0(dp_vrt_inst0_dstv_reg);
assign vrt_dp_inst1_rel_vreg[6:0] = rel_after_inst1(dp_vrt_inst1_dstv_reg);
assign vrt_dp_inst2_rel_vreg[6:0] = rel_after_inst2(dp_vrt_inst2_dstv_reg);
assign vrt_dp_inst3_rel_vreg[6:0] = rel_after_inst3(dp_vrt_inst3_dstv_reg);

assign vrt_dp_inst01_srcv2_match = ctrl_rt_inst1_vld
                                   && dp_vrt_inst1_srcv2_vld
                                   && vrt_write0_en
                                   && (dp_vrt_inst1_srcv1_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]);
assign vrt_dp_inst02_srcv2_match = ctrl_rt_inst2_vld
                                   && dp_vrt_inst2_srcv2_vld
                                   && vrt_write0_en
                                   && (dp_vrt_inst2_srcv1_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]);
assign vrt_dp_inst03_srcv2_match = ctrl_rt_inst3_vld
                                   && dp_vrt_inst3_srcv2_vld
                                   && vrt_write0_en
                                   && (dp_vrt_inst3_srcv1_reg[4:0] == dp_vrt_inst0_dstv_reg[4:0]);
assign vrt_dp_inst12_srcv2_match = ctrl_rt_inst2_vld
                                   && dp_vrt_inst2_srcv2_vld
                                   && vrt_write1_en
                                   && (dp_vrt_inst2_srcv1_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]);
assign vrt_dp_inst13_srcv2_match = ctrl_rt_inst3_vld
                                   && dp_vrt_inst3_srcv2_vld
                                   && vrt_write1_en
                                   && (dp_vrt_inst3_srcv1_reg[4:0] == dp_vrt_inst1_dstv_reg[4:0]);
assign vrt_dp_inst23_srcv2_match = ctrl_rt_inst3_vld
                                   && dp_vrt_inst3_srcv2_vld
                                   && vrt_write2_en
                                   && (dp_vrt_inst3_srcv1_reg[4:0] == dp_vrt_inst2_dstv_reg[4:0]);

// Preserve legacy unused signal references in the generated RTL branch.
wire _unused_vrt_inputs;
assign _unused_vrt_inputs = cp0_idu_icg_en
                             || cp0_yy_clk_en
                             || pad_yy_icg_scan_en
                             || rtu_idu_flush_fe
                             || rtu_idu_flush_is;

endmodule
