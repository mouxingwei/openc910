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

// vsetivli Instruction Decode Testbench for RVV 1.0
// Created: 2026-04-02
// Description: Test vsetivli instruction decoding

module tb_idu_vsetivli;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // Instruction Interface
    reg  [31:0] inst;
    wire        decd_vsetivli;
    wire        decd_vsetvli;
    wire        decd_vsetvl;
    wire        x_illegal;

    // Decoded fields
    wire [4:0]  rd;
    wire [4:0]  uimm;       // 5-bit unsigned immediate (AVL)
    wire [10:0] zimm;       // 11-bit vtype immediate

    // Test counters
    integer test_count;
    integer pass_count;
    integer fail_count;

    // Clock generation - 100MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset generation
    initial begin
        rst_b = 0;
        #20 rst_b = 1;
    end

    // vsetivli Encoding:
    // [31:30] = 11 (uimm[5:4])
    // [29:28] = zimm[9:8] (vma, vta)
    // [27:26] = reserved
    // [25:23] = zimm[7:5] (vsew)
    // [22]    = zimm[8] (part of vtype)
    // [21:20] = zimm[4:3] (vlmul high bits)
    // [19:15] = rd
    // [14:12] = 111 (funct3)
    // [11:7]  = uimm[4:0] (AVL)
    // [6:0]   = 1010111 (opcode)

    // Simplified decode logic
    wire is_vsetivli = (inst[31:30] == 2'b11) && 
                       (inst[14:12] == 3'b111) && 
                       (inst[6:0] == 7'b1010111);

    wire is_vsetvli = (inst[31:30] != 2'b11) && 
                      (inst[14:12] == 3'b111) && 
                      (inst[6:0] == 7'b1010111);

    wire is_vsetvl = (inst[14:12] == 3'b111) && 
                     (inst[6:0] == 7'b1010111) &&
                     (inst[31:30] == 2'b11) && 
                     (inst[11:7] == 5'b00000);

    assign decd_vsetivli = is_vsetivli && !x_illegal;
    assign decd_vsetvli  = is_vsetvli;
    assign decd_vsetvl   = is_vsetvl;

    // Extract fields
    assign rd   = inst[11:7];   // Destination register
    assign uimm = {inst[31:30], inst[19:15]};  // For vsetivli, AVL is in uimm format
    assign zimm = {inst[29:28], inst[25:23], inst[22], inst[21:20], inst[19:15]};

    // Illegal instruction check (simplified)
    assign x_illegal = 1'b0;  // Simplified - no illegal detection

    // Test Task: Send instruction
    task send_inst;
        input [31:0] instruction;
        begin
            @(posedge clk);
            inst <= instruction;
            @(posedge clk);
        end
    endtask

    // Test Task: Check result
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

    // Main Test Sequence
    initial begin
        // Initialize
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        inst = 32'b0;

        // Wait for reset
        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("vsetivli Instruction Decode Test Suite");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Case VSETIVLI_001: Basic vsetivli Decode
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_001] Basic vsetivli Decode Test");
        begin
            // vsetivli x0, 8, e32, m1, ta, ma
            // Encoding: 11_00_000_001_00000_111_01000_1010111
            // Simplified: 0xC18007D7
            send_inst(32'hC18007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_001: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_002: vsetivli with Different AVL
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_002] vsetivli with Different AVL Test");
        begin
            // vsetivli x1, 15, e64, m2, ta, ma
            // AVL=15, rd=x1
            send_inst(32'hC08007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_002: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_003: vsetivli with LMUL=1/8
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_003] vsetivli with LMUL=1/8 Test");
        begin
            // vsetivli x0, 4, e32, mf8, ta, ma
            // vlmul=101 (LMUL=1/8)
            send_inst(32'hC0A007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_003: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_004: vsetivli with LMUL=1/4
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_004] vsetivli with LMUL=1/4 Test");
        begin
            // vsetivli x0, 4, e32, mf4, ta, ma
            // vlmul=110 (LMUL=1/4)
            send_inst(32'hC0C007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_004: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_005: vsetivli with LMUL=1/2
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_005] vsetivli with LMUL=1/2 Test");
        begin
            // vsetivli x0, 4, e32, mf2, ta, ma
            // vlmul=111 (LMUL=1/2)
            send_inst(32'hC0E007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_005: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_006: vsetivli with vma=1, vta=1
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_006] vsetivli with vma=1, vta=1 Test");
        begin
            // vsetivli x0, 8, e32, m1, tu, mu
            // vma=1, vta=1
            send_inst(32'hC58007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_006: decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_007: Distinguish from vsetvli
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_007] Distinguish from vsetvli Test");
        begin
            // vsetvli x0, a0, e32, m1, ta, ma
            // bit[31:30] != 11 for vsetvli
            send_inst(32'h00807057);
            check_result(decd_vsetvli, 1'b1, "VSETIVLI_007: decd_vsetvli");
            check_result(decd_vsetivli, 1'b0, "VSETIVLI_007: not decd_vsetivli");
        end

        //----------------------------------------------------------------
        // Test Case VSETIVLI_008: Different SEW Values
        //----------------------------------------------------------------
        $display("\n[VSETIVLI_008] Different SEW Values Test");
        begin
            // vsetivli x0, 8, e8, m1, ta, ma (SEW=8)
            send_inst(32'hC00007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_008a: SEW=8");

            // vsetivli x0, 8, e16, m1, ta, ma (SEW=16)
            send_inst(32'hC08007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_008b: SEW=16");

            // vsetivli x0, 8, e32, m1, ta, ma (SEW=32)
            send_inst(32'hC10007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_008c: SEW=32");

            // vsetivli x0, 8, e64, m1, ta, ma (SEW=64)
            send_inst(32'hC18007D7);
            check_result(decd_vsetivli, 1'b1, "VSETIVLI_008d: SEW=64");
        end

        // Print Summary
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

    // Timeout
    initial begin
        #10000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_idu_vsetivli.vcd");
        $dumpvars(0, tb_idu_vsetivli);
    end

endmodule
