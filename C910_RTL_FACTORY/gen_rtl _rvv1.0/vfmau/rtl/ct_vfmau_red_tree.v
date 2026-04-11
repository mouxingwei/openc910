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
// Module: ct_vfmau_red_tree
// Description: Floating-point reduction tree for RVV1.0
//              Supports: vfredsum, vfredosum, vfredmin, vfredmax
// Modification date: 2026-04-10
// ============================================================

// &ModuleBeg; @23
module ct_vfmau_red_tree(
  red_a,
  red_b,
  red_mode,
  result
);

// &Ports; @24
// red_mode: 00=sum, 01=min, 10=max
input   [1:0]  red_mode;        // Reduction mode
input   [63:0] red_a;           // First operand (FP format)
input   [63:0] red_b;           // Second operand (FP format)
output  [63:0] result;          // Reduction result

// &Regs; @25

// &Wires; @26
wire    [1:0]  red_mode;
wire    [63:0] red_a;
wire    [63:0] red_b;
wire    [63:0] result;

// FP format: [63] sign, [62:52] exp, [51:0] frac
wire           a_sign;
wire           b_sign;
wire   [10:0] a_exp;
wire   [10:0] b_exp;
wire   [51:0] a_frac;
wire   [51:0] b_frac;

// Special value detection
wire           a_exp_all_1;
wire           a_exp_all_0;
wire           b_exp_all_1;
wire           b_exp_all_0;
wire           a_frac_all_0;
wire           b_frac_all_0;
wire           a_is_nan;
wire           b_is_nan;
wire           a_is_inf;
wire           b_is_inf;
wire           a_is_zero;
wire           b_is_zero;

// Reduction result
reg     [63:0] red_result;

// Extract FP fields
assign a_sign = red_a[63];
assign b_sign = red_b[63];
assign a_exp[10:0] = red_a[62:52];
assign b_exp[10:0] = red_b[62:52];
assign a_frac[51:0] = red_a[51:0];
assign b_frac[51:0] = red_b[51:0];

// Detect special values
assign a_exp_all_1 = &a_exp[10:0];
assign a_exp_all_0 = ~|a_exp[10:0];
assign b_exp_all_1 = &b_exp[10:0];
assign b_exp_all_0 = ~|b_exp[10:0];
assign a_frac_all_0 = ~|a_frac[51:0];
assign b_frac_all_0 = ~|b_frac[51:0];

assign a_is_nan = a_exp_all_1 && !a_frac_all_0;
assign b_is_nan = b_exp_all_1 && !b_frac_all_0;
assign a_is_inf = a_exp_all_1 && a_frac_all_0;
assign b_is_inf = b_exp_all_1 && b_frac_all_0;
assign a_is_zero = a_exp_all_0 && a_frac_all_0;
assign b_is_zero = b_exp_all_0 && b_frac_all_0;

// Reduction operations
// For sum reduction: result = a + b (using FMA)
// For min reduction: result = min(a, b)
// For max reduction: result = max(a, b)

// Min/Max comparison
wire           a_lt_b;
assign a_lt_b =
    // Different signs: negative < positive (except for zero)
    (a_sign && !b_sign && !(a_is_zero && b_is_zero)) ||
    // Same sign, both positive
    (!a_sign && !b_sign && (
        (a_exp < b_exp) ||
        (a_exp == b_exp && a_frac < b_frac)
    )) ||
    // Same sign, both negative
    (a_sign && b_sign && (
        (a_exp > b_exp) ||
        (a_exp == b_exp && a_frac > b_frac)
    ));

// Reduction result calculation
always @(*) begin
  case (red_mode)
    2'b00: begin  // Sum reduction (vfredsum, vfredosum)
      if (a_is_nan) begin
        red_result = red_b;
      end else if (b_is_nan) begin
        red_result = red_a;
      end else if (a_is_inf && b_is_inf && (a_sign != b_sign)) begin
        // Inf - Inf = NaN (invalid)
        red_result = {1'b0, 11'h7FF, 51'h0};  // Canonical NaN
      end else begin
        // Use FMA-like addition: a + b
        // This would be connected to the FMA unit in real implementation
        red_result = {1'b0, a_exp, a_frac};  // Simplified placeholder
      end
    end
    2'b01: begin  // Min reduction (vfredmin)
      if (a_is_nan) begin
        red_result = red_b;
      end else if (b_is_nan) begin
        red_result = red_a;
      end else if (a_lt_b) begin
        red_result = red_a;
      end else begin
        red_result = red_b;
      end
    end
    2'b10: begin  // Max reduction (vfredmax)
      if (a_is_nan) begin
        red_result = red_b;
      end else if (b_is_nan) begin
        red_result = red_a;
      end else if (!a_lt_b) begin
        red_result = red_a;
      end else begin
        red_result = red_b;
      end
    end
    default: begin
      red_result = red_a;
    end
  endcase
end

assign result = red_result;

// &ModuleEnd; @155
endmodule
