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

// ============================================================
// Module: ct_vfmau_fclass
// Description: Floating-point classification unit for RVV1.0
//              Supports: vfclass.v
// Modification date: 2026-04-10
// ============================================================

// &ModuleBeg; @23
module ct_vfmau_fclass(
  class_operand,
  class_result
);

// &Ports; @24
input   [63:0] class_operand;    // Input operand (FP format)
output  [7:0] class_result;     // Classification result

// vfclass encoding:
// [7] negative infinity
// [6] negative normal number
// [5] negative subnormal number
// [4] negative zero
// [3] positive zero
// [2] positive subnormal number
// [1] positive normal number
// [0] positive infinity

// &Regs; @25
reg     [7:0] result;

// &Wires; @26
wire    [63:0] class_operand;
wire    [7:0] class_result;

// FP format: [63] sign, [62:52] exp, [51:0] frac
wire           sign;
wire   [10:0] exp;
wire   [51:0] frac;

// Special value detection
wire           exp_all_1;
wire           exp_all_0;
wire           frac_all_0;
wire           is_nan;
wire           is_inf;
wire           is_zero;
wire           is_subnormal;
wire           is_normal;

// Extract FP fields
assign sign = class_operand[63];
assign exp[10:0] = class_operand[62:52];
assign frac[51:0] = class_operand[51:0];

// Detect special values
assign exp_all_1 = &exp[10:0];
assign exp_all_0 = ~|exp[10:0];
assign frac_all_0 = ~|frac[51:0];

assign is_nan = exp_all_1 && !frac_all_0;
assign is_inf = exp_all_1 && frac_all_0;
assign is_zero = exp_all_0 && frac_all_0;
assign is_subnormal = exp_all_0 && !frac_all_0;
assign is_normal = !exp_all_0 && !exp_all_1;

// Classification logic
always @(*) begin
  result = 8'b0;

  if (is_nan) begin
    // NaN: no bit set (quiet NaN has MSB of frac set)
    // Signaling NaN would also set this, but vfclass only sets bits for the categories below
    result = 8'b0;
  end else if (is_inf) begin
    // Infinity
    result[sign ? 7 : 0] = 1'b1;
  end else if (is_zero) begin
    // Zero
    result[sign ? 4 : 3] = 1'b1;
  end else if (is_subnormal) begin
    // Subnormal
    result[sign ? 5 : 2] = 1'b1;
  end else if (is_normal) begin
    // Normal
    result[sign ? 6 : 1] = 1'b1;
  end
end

assign class_result = result;

// &ModuleEnd; @100
endmodule
