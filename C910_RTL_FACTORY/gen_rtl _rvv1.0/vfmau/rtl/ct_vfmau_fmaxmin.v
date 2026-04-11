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
// Module: ct_vfmau_fmaxmin
// Description: Floating-point max/min unit for RVV1.0
//              Supports: vfmax, vfmin
// Modification date: 2026-04-10
// ============================================================

// &ModuleBeg; @23
module ct_vfmau_fmaxmin(
  maxmin_a,
  maxmin_b,
  maxmin_mode,
  result,
  special_case
);

// &Ports; @24
// maxmin_mode: 0=vfmin, 1=vfmax
input          maxmin_mode;      // 0: min, 1: max
input   [63:0] maxmin_a;       // First operand (FP format)
input   [63:0] maxmin_b;       // Second operand (FP format)
output  [63:0] result;         // Result (min or max)
output         special_case;    // Special case (NaN, etc.)

// &Regs; @25

// &Wires; @26
wire           maxmin_mode;
wire    [63:0] maxmin_a;
wire    [63:0] maxmin_b;
wire    [63:0] result;
wire           special_case;

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

// Comparison result
wire           a_lt_b;
wire           a_eq_b;
wire           unordered;
wire           select_a;

// Extract FP fields
assign a_sign = maxmin_a[63];
assign b_sign = maxmin_b[63];
assign a_exp[10:0] = maxmin_a[62:52];
assign b_exp[10:0] = maxmin_b[62:52];
assign a_frac[51:0] = maxmin_a[51:0];
assign b_frac[51:0] = maxmin_b[51:0];

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

assign unordered = a_is_nan || b_is_nan;
assign special_case = unordered;

// IEEE 754: max/min rules:
// - If either operand is NaN, result is canonical NaN
// - If one operand is NaN, result is the other operand
// - If both are +0 and -0, result is +0 for min, -0 for max
// - Otherwise, compare values (considering sign)

assign a_eq_b = (a_exp == b_exp) && (a_frac == b_frac);

// A < B comparison considering special cases
assign a_lt_b =
    // Different signs: negative < positive (except for zero)
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
    ));

// For max: select A if A > B
// For min: select A if A < B
assign select_a = maxmin_mode ? a_lt_b : !a_lt_b;

// Generate result
assign result = select_a ? maxmin_a : maxmin_b;

// &ModuleEnd; @130
endmodule
