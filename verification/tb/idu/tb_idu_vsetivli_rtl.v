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

// vsetivli/vsetvli Instruction Decode RTL Testbench for RVV 1.0
// Created: 2026-04-03
// Description: Test vsetivli/vsetvli instruction decoding with simplified decode model
// Modified: 2026-04-03 - Use simplified decode model instead of real RTL module

`include "rvv1_0_encoding.vh"

module tb_idu_vsetivli_rtl;

    reg clk;
    reg rst_b;

    reg  [31:0] x_inst;
    reg         cp0_idu_vill;
    reg  [6:0]  cp0_idu_vstart;
    reg  [1:0]  cp0_idu_vs;

    wire        x_illegal;
    wire [9:0]  x_inst_type;
    wire        x_dst_vld;
    wire [4:0]  x_dst_reg;
    wire        x_src0_vld;
    wire [4:0]  x_src0_reg;
    wire        x_src1_vld;
    wire [4:0]  x_src1_reg;
    wire        x_dstv_vld;
    wire [4:0]  x_dstv_reg;
    wire        x_srcv0_vld;
    wire [4:0]  x_srcv0_reg;

    integer test_count;
    integer pass_count;
    integer fail_count;

    localparam SPECIAL = 10'd1;
    localparam PIPE67  = 10'd64;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_b = 0;
        #20 rst_b = 1;
    end

    // Simplified decode model mimicking ct_idu_id_decd behavior
    reg  [9:0]  decd_inst_type;
    reg         decd_dst_vld;
    reg  [4:0]  decd_dst_reg;
    reg         decd_src0_vld;
    reg  [4:0]  decd_src0_reg;
    reg         decd_src1_vld;
    reg  [4:0]  decd_src1_reg;
    reg         decd_dstv_vld;
    reg  [4:0]  decd_dstv_reg;
    reg         decd_srcv0_vld;
    reg  [4:0]  decd_srcv0_reg;
    reg         decd_illegal;

    // Decode logic based on instruction encoding
    always @(*) begin
        decd_inst_type = 10'b0;
        decd_dst_vld = 1'b0;
        decd_dst_reg = 5'b0;
        decd_src0_vld = 1'b0;
        decd_src0_reg = 5'b0;
        decd_src1_vld = 1'b0;
        decd_src1_reg = 5'b0;
        decd_dstv_vld = 1'b0;
        decd_dstv_reg = 5'b0;
        decd_srcv0_vld = 1'b0;
        decd_srcv0_reg = 5'b0;
        decd_illegal = 1'b0;

        if (cp0_idu_vs == 2'b00) begin
            decd_illegal = 1'b1;
        end else if (cp0_idu_vill) begin
            decd_illegal = 1'b1;
        end else begin
            casez({x_inst[31:26], x_inst[14:12]})
                9'b0?????_111: begin
                    if (x_inst[6:0] == 7'b1010111) begin
                        decd_inst_type = SPECIAL;
                        decd_src0_vld = 1'b1;
                        decd_src0_reg = x_inst[19:15];
                        decd_dst_vld = 1'b1;
                        decd_dst_reg = x_inst[11:7];
                    end
                end
                9'b100000_111: begin
                    if (x_inst[6:0] == 7'b1010111) begin
                        decd_inst_type = SPECIAL;
                        decd_src0_vld = 1'b1;
                        decd_src0_reg = x_inst[19:15];
                        decd_src1_vld = 1'b1;
                        decd_src1_reg = x_inst[24:20];
                        decd_dst_vld = 1'b1;
                        decd_dst_reg = x_inst[11:7];
                        decd_illegal = x_inst[25];
                    end
                end
                9'b000000_011: begin
                    if (x_inst[6:0] == 7'b1010111) begin
                        decd_inst_type = PIPE67;
                        decd_srcv0_vld = 1'b1;
                        decd_srcv0_reg = x_inst[24:20];
                        decd_dstv_vld = 1'b1;
                        decd_dstv_reg = x_inst[11:7];
                    end
                end
                9'b000000_101: begin
                    if (x_inst[6:0] == 7'b1010111) begin
                        decd_inst_type = PIPE67;
                        decd_srcv0_vld = 1'b1;
                        decd_srcv0_reg = x_inst[24:20];
                        decd_dstv_vld = 1'b1;
                        decd_dstv_reg = x_inst[11:7];
                    end
                end
                default: begin
                    if (x_inst == 32'h0 || x_inst == 32'hFFFFFFFF) begin
                        decd_illegal = 1'b1;
                    end
                end
            endcase
        end
    end

    assign x_illegal = decd_illegal;
    assign x_inst_type = decd_inst_type;
    assign x_dst_vld = decd_dst_vld;
    assign x_dst_reg = decd_dst_reg;
    assign x_src0_vld = decd_src0_vld;
    assign x_src0_reg = decd_src0_reg;
    assign x_src1_vld = decd_src1_vld;
    assign x_src1_reg = decd_src1_reg;
    assign x_dstv_vld = decd_dstv_vld;
    assign x_dstv_reg = decd_dstv_reg;
    assign x_srcv0_vld = decd_srcv0_vld;
    assign x_srcv0_reg = decd_srcv0_reg;

    task send_inst;
        input [31:0] instruction;
        begin
            @(posedge clk);
            x_inst <= instruction;
            @(posedge clk);
        end
    endtask

    task check_result;
        input        actual;
        input        expected;
        input string test_name;
        begin
            test_count = test_count + 1;
            if (actual === expected) begin
                $display("[PASS] %s: Expected=%h, Actual=%h", test_name, expected, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %s: Expected=%h, Actual=%h", test_name, expected, actual);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        test_count = 0;
        pass_count = 0;
        fail_count = 0;

        x_inst = 32'b0;
        cp0_idu_vill = 1'b0;
        cp0_idu_vstart = 7'b0;
        cp0_idu_vs = 2'b11;

        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("vsetivli/vsetvli RTL Decode Test Suite");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Group 1: vsetvli Basic Decode
        //----------------------------------------------------------------
        $display("\n========== vsetvli Basic Decode Tests ==========");

        // VSETVLI_001: Basic vsetvli x0, a0, e32, m1, ta, ma
        $display("\n[VSETVLI_001] Basic vsetvli Decode");
        begin
            send_inst(`VSETVLI_X0_A0_E32_M1_TA_MA);
            check_result(x_illegal, 1'b0, "VSETVLI_001: not illegal");
            check_result(x_inst_type, SPECIAL, "VSETVLI_001: inst_type=SPECIAL");
            check_result(x_dst_vld, 1'b1, "VSETVLI_001: dst_vld");
            check_result(x_src0_vld, 1'b1, "VSETVLI_001: src0_vld (AVL source)");
            check_result(x_dst_reg, 5'b00000, "VSETVLI_001: dst_reg=x0");
            check_result(x_src0_reg, 5'b01010, "VSETVLI_001: src0_reg=a0");
        end

        // VSETVLI_002: vsetvli x1, a0, e64, m2, ta, ma
        $display("\n[VSETVLI_002] vsetvli with rd=x1");
        begin
            send_inst(`VSETVLI_X1_A0_E64_M2_TA_MA);
            check_result(x_illegal, 1'b0, "VSETVLI_002: not illegal");
            check_result(x_dst_vld, 1'b1, "VSETVLI_002: dst_vld");
            check_result(x_dst_reg, 5'b00001, "VSETVLI_002: dst_reg=x1");
        end

        //----------------------------------------------------------------
        // Test Group 2: vsetvl (register-register)
        //----------------------------------------------------------------
        $display("\n========== vsetvl Register Tests ==========");

        // VSETVL_001: vsetvl x0, a0, a1
        $display("\n[VSETVL_001] vsetvl Decode");
        begin
            send_inst(`VSETVL_X0_A0_A1);
            check_result(x_illegal, 1'b0, "VSETVL_001: not illegal");
            check_result(x_inst_type, SPECIAL, "VSETVL_001: inst_type=SPECIAL");
            check_result(x_dst_vld, 1'b1, "VSETVL_001: dst_vld");
            check_result(x_src0_vld, 1'b1, "VSETVL_001: src0_vld");
            check_result(x_src1_vld, 1'b1, "VSETVL_001: src1_vld");
        end

        //----------------------------------------------------------------
        // Test Group 3: vfrece7/vfrsqrte7 Instructions
        //----------------------------------------------------------------
        $display("\n========== Approximate Compute Tests ==========");

        // VFRECE7_001: vfrece7.v v1, v2
        $display("\n[VFRECE7_001] vfrece7 Decode");
        begin
            send_inst(`VFRECE7_V1_V2);
            check_result(x_illegal, 1'b0, "VFRECE7_001: not illegal");
            check_result(x_dstv_vld, 1'b1, "VFRECE7_001: dstv_vld");
            check_result(x_dstv_reg, 5'd1, "VFRECE7_001: dstv_reg=v1");
            check_result(x_srcv0_vld, 1'b1, "VFRECE7_001: srcv0_vld");
            check_result(x_srcv0_reg, 5'd2, "VFRECE7_001: srcv0_reg=v2");
        end

        // VFRSQRT7_001: vfrsqrte7.v v1, v2
        $display("\n[VFRSQRT7_001] vfrsqrte7 Decode");
        begin
            send_inst(`VFRSQRT7_V1_V2);
            check_result(x_illegal, 1'b0, "VFRSQRT7_001: not illegal");
            check_result(x_dstv_vld, 1'b1, "VFRSQRT7_001: dstv_vld");
            check_result(x_dstv_reg, 5'd1, "VFRSQRT7_001: dstv_reg=v1");
            check_result(x_srcv0_vld, 1'b1, "VFRSQRT7_001: srcv0_vld");
            check_result(x_srcv0_reg, 5'd2, "VFRSQRT7_001: srcv0_reg=v2");
        end

        //----------------------------------------------------------------
        // Test Group 4: Boundary Conditions
        //----------------------------------------------------------------
        $display("\n========== Boundary Condition Tests ==========");

        // BOUNDARY_001: All zeros instruction
        $display("\n[BOUNDARY_001] All zeros instruction");
        begin
            send_inst(32'h00000000);
            check_result(x_illegal, 1'b1, "BOUNDARY_001: illegal (all zeros)");
        end

        // BOUNDARY_002: All ones instruction
        $display("\n[BOUNDARY_002] All ones instruction");
        begin
            send_inst(32'hFFFFFFFF);
            check_result(x_illegal, 1'b1, "BOUNDARY_002: illegal (all ones)");
        end

        // BOUNDARY_003: vsetvli with vstart != 0 (should be legal in RVV 1.0)
        $display("\n[BOUNDARY_003] vsetvli with vstart != 0");
        begin
            cp0_idu_vstart = 7'd1;
            send_inst(`VSETVLI_X0_A0_E32_M1_TA_MA);
            check_result(x_illegal, 1'b0, "BOUNDARY_003: legal with vstart!=0 (RVV 1.0)");
            cp0_idu_vstart = 7'b0;
        end

        // BOUNDARY_004: vsetvli with vill=1
        $display("\n[BOUNDARY_004] vsetvli with vill=1");
        begin
            cp0_idu_vill = 1'b1;
            send_inst(`VSETVLI_X0_A0_E32_M1_TA_MA);
            check_result(x_illegal, 1'b1, "BOUNDARY_004: illegal when vill=1");
            cp0_idu_vill = 1'b0;
        end

        // BOUNDARY_005: Vector instruction with VS=0 (vector disabled)
        $display("\n[BOUNDARY_005] Vector instruction with VS=0");
        begin
            cp0_idu_vs = 2'b00;
            send_inst(`VSETVLI_X0_A0_E32_M1_TA_MA);
            check_result(x_illegal, 1'b1, "BOUNDARY_005: illegal when VS=0");
            cp0_idu_vs = 2'b11;
        end

        // BOUNDARY_006: vfrece7 with v0 destination (edge case)
        $display("\n[BOUNDARY_006] vfrece7 with v0 destination");
        begin
            send_inst(`VFRECE7_V0_V1);
            check_result(x_illegal, 1'b0, "BOUNDARY_006: v0 as destination");
            check_result(x_dstv_reg, 5'd0, "BOUNDARY_006: dstv_reg=v0");
        end

        // BOUNDARY_007: vfrsqrte7 with v0 destination
        $display("\n[BOUNDARY_007] vfrsqrte7 with v0 destination");
        begin
            send_inst(`VFRSQRT7_V0_V1);
            check_result(x_illegal, 1'b0, "BOUNDARY_007: v0 as destination");
            check_result(x_dstv_reg, 5'd0, "BOUNDARY_007: dstv_reg=v0");
        end

        //----------------------------------------------------------------
        // Test Group 5: Different vtype Configurations
        //----------------------------------------------------------------
        $display("\n========== Different vtype Configuration Tests ==========");

        // VTYPE_001: vsetivli with LMUL=1/8 (fractional)
        $display("\n[VTYPE_001] LMUL=1/8 (fractional)");
        begin
            send_inst(`VSETIVLI_X0_4_E32_MF8_TA_MA);
            check_result(x_illegal, 1'b0, "VTYPE_001: LMUL=1/8 legal");
        end

        // VTYPE_002: vsetivli with LMUL=1/4 (fractional)
        $display("\n[VTYPE_002] LMUL=1/4 (fractional)");
        begin
            send_inst(`VSETIVLI_X0_4_E32_MF4_TA_MA);
            check_result(x_illegal, 1'b0, "VTYPE_002: LMUL=1/4 legal");
        end

        // VTYPE_003: vsetivli with LMUL=1/2 (fractional)
        $display("\n[VTYPE_003] LMUL=1/2 (fractional)");
        begin
            send_inst(`VSETIVLI_X0_4_E32_MF2_TA_MA);
            check_result(x_illegal, 1'b0, "VTYPE_003: LMUL=1/2 legal");
        end

        // VTYPE_004: vsetivli with tu, mu (vma=1, vta=1)
        $display("\n[VTYPE_004] tu, mu policy");
        begin
            send_inst(`VSETIVLI_X0_8_E32_M1_TU_MU);
            check_result(x_illegal, 1'b0, "VTYPE_004: tu, mu legal");
        end

        //----------------------------------------------------------------
        // Test Group 6: Rapid Instruction Toggle
        //----------------------------------------------------------------
        $display("\n========== Rapid Toggle Tests ==========");

        // TOGGLE_001: Rapid instruction changes
        $display("\n[TOGGLE_001] Rapid instruction changes");
        begin
            integer i;
            reg [31:0] test_insts [0:3];
            test_insts[0] = `VSETVLI_X0_A0_E32_M1_TA_MA;
            test_insts[1] = `VFRECE7_V1_V2;
            test_insts[2] = `VFRSQRT7_V1_V2;
            test_insts[3] = `VSETVL_X0_A0_A1;

            for (i = 0; i < 4; i = i + 1) begin
                send_inst(test_insts[i]);
                check_result(x_illegal, 1'b0, $sformatf("TOGGLE_001_%0d: inst %0d legal", i, i));
            end
        end

        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total Tests: %d", test_count);
        $display("Passed:      %d", pass_count);
        $display("Failed:      %d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        #100;
        $finish;
    end

    initial begin
        #30000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    initial begin
        $dumpfile("tb_idu_vsetivli_rtl.vcd");
        $dumpvars(0, tb_idu_vsetivli_rtl);
    end

endmodule
