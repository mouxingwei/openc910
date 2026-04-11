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
// Module: ct_vfmau_fsign
// Description: Floating-point sign injection unit for RVV1.0
//              Supports: vfsgnj, vfsgnjn, vfsgnjx
// Modification date: 2026-04-10
// ============================================================

// &ModuleBeg; @23
module ct_vfmau_fsign(
  sign_op_a,
  sign_op_b,
  sign_mode,
  result
);

// &Ports; @24
// sign_mode: 00=vfsgnj (join), 01=vfsgnjn (join negated), 10=vfsgnjx (join xor)
input   [1:0]  sign_mode;      // Sign injection mode
input   [63:0] sign_op_a;      // First operand (FP format) - provides exponent and mantissa
input   [63:0] sign_op_b;      // Second operand (FP format) - provides sign
output  [63:0] result;         // Result with new sign

// &Regs; @25

// &Wires; @26
wire    [1:0]  sign_mode;
wire    [63:0] sign_op_a;
wire    [63:0] sign_op_b;
wire    [63:0] result;

wire           a_sign;
wire           b_sign;
wire           result_sign;

// Extract signs from operands
assign a_sign = sign_op_a[63];
assign b_sign = sign_op_b[63];

// Generate result sign based on mode
// vfsgnj:  result_sign = b_sign (join signs)
// vfsgnjn: result_sign = ~b_sign (join negated signs)
// vfsgnjx: result_sign = a_sign ^ b_sign (join xor signs)
assign result_sign = (sign_mode == 2'b00) ? b_sign :      // vfsgnj
                    (sign_mode == 2'b01) ? ~b_sign :       // vfsgnjn
                    (a_sign ^ b_sign);                      // vfsgnjx

// Construct result: new sign + original exponent and mantissa from op_a
assign result[63] = result_sign;
assign result[62:0] = sign_op_a[62:0];

// &ModuleEnd; @65
endmodule
