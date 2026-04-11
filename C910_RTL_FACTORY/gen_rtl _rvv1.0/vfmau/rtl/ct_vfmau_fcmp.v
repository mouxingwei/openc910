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
// Module: ct_vfmau_fcmp
// Description: Floating-point comparison unit for RVV1.0
//              Supports: vmfeq, vmfne, vmflt, vmfle, vmfgt, vmfge
// Modification date: 2026-04-10
// ============================================================

// &ModuleBeg; @23
module ct_vfmau_fcmp(
  cmp_a,
  cmp_b,
  cmp_mode,
  cmp_result,
  fp_class_a,
  fp_class_b,
  special_case
);

// &Ports; @24
input         cmp_mode;           // 0: normal compare, 1: lt compare (for vmflt/vmfle)
input   [63:0] cmp_a;            // First operand (FP format)
input   [63:0] cmp_b;            // Second operand (FP format)
output        cmp_result;        // Comparison result
output  [7:0] fp_class_a;        // Classification of operand A
output  [7:0] fp_class_b;        // Classification of operand B
output        special_case;      // Special case (NaN, inf, etc.)

// &Regs; @25
reg     [7:0] class_a;           // Classification result A
reg     [7:0] class_b;           // Classification result B
reg           result;             // Comparison result

// &Wires; @26
wire    [63:0] cmp_a;
wire    [63:0] cmp_b;
wire          cmp_mode;
wire    [7:0] fp_class_a;
wire    [7:0] fp_class_b;
wire          special_case;

// FP format: [63] sign, [62:52] exp, [51:0] frac
// Sign bit
wire          a_sign;
wire          b_sign;
// Exponent bits
wire   [10:0] a_exp;
wire   [10:0] b_exp;
// Fraction bits
wire   [51:0] a_frac;
wire   [51:0] b_frac;

// Special value detection
wire          a_exp_all_1;      // NaN or Inf
wire          a_exp_all_0;      // Zero or subnormal
wire          b_exp_all_1;
wire          b_exp_all_0;
wire          a_frac_all_0;     // Exact zero
wire          b_frac_all_0;
wire          a_is_nan;
wire          b_is_nan;
wire          a_is_inf;
wire          b_is_inf;
wire          a_is_zero;
wire          b_is_zero;
wire          a_is_subnormal;
wire          b_is_subnormal;

// Comparison wires
wire          a_lt_b;           // A < B (ordered)
wire          a_eq_b;           // A == B
wire          unordered;         // NaN involved in comparison

// Extract FP fields
assign a_sign = cmp_a[63];
assign b_sign = cmp_b[63];
assign a_exp[10:0] = cmp_a[62:52];
assign b_exp[10:0] = cmp_b[62:52];
assign a_frac[51:0] = cmp_a[51:0];
assign b_frac[51:0] = cmp_b[51:0];

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
assign a_is_subnormal = a_exp_all_0 && !a_frac_all_0;
assign b_is_subnormal = b_exp_all_0 && !b_frac_all_0;

// Special case output - true if either operand is NaN
assign special_case = a_is_nan || b_is_nan;

// Classification result encoding (vfclass.v format)
// [7]: negative infinity
// [6]: negative normal
// [5]: negative subnormal
// [4]: negative zero
// [3]: positive zero
// [2]: positive subnormal
// [1]: positive normal
// [0]: positive infinity
always @(*) begin
  class_a = 8'b0;
  if (a_is_nan) begin
    class_a = 8'b0;  // NaN not classified in vfclass
  end else if (a_is_inf && a_sign) begin
    class_a[7] = 1'b1;  // negative infinity
  end else if (a_is_zero && a_sign) begin
    class_a[4] = 1'b1;  // negative zero
  end else if (a_is_subnormal && a_sign) begin
    class_a[5] = 1'b1;  // negative subnormal
  end else if (a_sign) begin
    class_a[6] = 1'b1;  // negative normal
  end else if (a_is_zero) begin
    class_a[3] = 1'b1;  // positive zero
  end else if (a_is_subnormal) begin
    class_a[2] = 1'b1;  // positive subnormal
  end else if (a_is_inf) begin
    class_a[0] = 1'b1;  // positive infinity
  end else begin
    class_a[1] = 1'b1;  // positive normal
  end
end

always @(*) begin
  class_b = 8'b0;
  if (b_is_nan) begin
    class_b = 8'b0;
  end else if (b_is_inf && b_sign) begin
    class_b[7] = 1'b1;
  end else if (b_is_zero && b_sign) begin
    class_b[4] = 1'b1;
  end else if (b_is_subnormal && b_sign) begin
    class_b[5] = 1'b1;
  end else if (b_sign) begin
    class_b[6] = 1'b1;
  end else if (b_is_zero) begin
    class_b[3] = 1'b1;
  end else if (b_is_subnormal) begin
    class_b[2] = 1'b1;
  end else if (b_is_inf) begin
    class_b[0] = 1'b1;
  end else begin
    class_b[1] = 1'b1;
  end
end

// Comparison logic for ordered comparisons (vmfeq, vmflt, vmfle, etc.)
// For vmfeq: result = (a == b) && !unordered
// For vmfne: result = (a != b) || unordered
// For vmflt: result = (a < b) && !unordered
// For vmfle: result = (a <= b) && !unordered
// For vmfgt: result = (b < a) && !unordered
// For vmfge: result = (b <= a) && !unordered

assign unordered = a_is_nan || b_is_nan;

// Basic comparison
assign a_eq_b = !unordered && (a_exp == b_exp) && (a_frac == b_frac);

// For A < B: consider special cases
assign a_lt_b = !unordered && (
    // Different signs
    (a_sign && !b_sign && !(a_is_zero && b_is_zero)) ||
    // Same sign, both positive
    (!a_sign && !b_sign && (
        (a_exp < b_exp) ||
        (a_exp == b_exp && a_frac < b_frac)
    )) ||
    // Same sign, both negative (closer to zero is larger)
    (a_sign && b_sign && (
        (a_exp > b_exp) ||
        (a_exp == b_exp && a_frac > b_frac)
    ))
);

// Comparison result based on mode
// cmp_mode = 0: equality check (vmfeq, vmfne)
// cmp_mode = 1: less-than check (vmflt, vmfle, vmfgt, vmfge)
always @(*) begin
  if (unordered) begin
    // For unordered comparisons, result depends on instruction
    result = 1'b0;  // Default for vmflt/vmfle/vmfgt/vmfge with NaN
  end else if (cmp_mode == 1'b0) begin
    // Equality comparison mode
    result = a_eq_b;
  end else begin
    // Less-than comparison mode
    result = a_lt_b;
  end
end

assign cmp_result = result;
assign fp_class_a = class_a;
assign fp_class_b = class_b;

// &ModuleEnd; @180
endmodule
