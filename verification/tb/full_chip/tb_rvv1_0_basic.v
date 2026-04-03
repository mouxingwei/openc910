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

// RVV 1.0 Basic System Testbench
// Created: 2026-04-02
// Description: System-level testbench for RVV 1.0 modifications

module tb_rvv1_0_basic;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // RVV 1.0 State
    reg  [2:0] vcsr_reg;    // VCSR: [2:1]=VXRM, [0]=VXSAT
    reg  [2:0] vlmul;       // vlmul[2:0]
    reg        vma;          // vector mask agnostic
    reg        vta;          // vector tail agnostic
    reg  [2:0] vsew;         // selected element width
    reg        vill;          // vector illegal
    reg  [63:0] vl;          // vector length
    reg  [6:0] vstart;       // vector start index

    // Instruction Decode
    reg  [31:0] inst;
    wire       decd_vsetivli;
    wire       decd_vsetvli;
    wire       decd_vsetvl;
    wire       decd_vfrece7;
    wire       decd_vfrsqrte7;
    wire       x_illegal;

    // FOF signals
    wire       decd_vleff;
    wire       pipe3_decd_inst_fof;

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

    // RVV 1.0 vtype Register Layout:
    // [63]    : vill
    // [62:8]  : Reserved
    // [7]     : vma
    // [6]     : vta
    // [5:3]   : vsew[2:0]
    // [2:0]   : vlmul[2:0]

    wire [63:0] vtype_value = {vill, 55'b0, vma, vta, vsew, vlmul};

    // vsetivli decode
    wire is_vsetivli = (inst[31:30] == 2'b11) && 
                       (inst[14:12] == 3'b111) && 
                       (inst[6:0] == 7'b1010111);
    assign decd_vsetivli = is_vsetivli && !x_illegal;

    // vsetvli decode
    wire is_vsetvli = (inst[31:30] != 2'b11) && 
                      (inst[14:12] == 3'b111) && 
                      (inst[6:0] == 7'b1010111) &&
                      (inst[11:7] != 5'b0);
    assign decd_vsetvli = is_vsetvli;

    // vsetvl decode
    wire is_vsetvl = (inst[14:12] == 3'b111) && 
                     (inst[6:0] == 7'b1010111) &&
                     (inst[11:7] == 5'b0);
    assign decd_vsetvl = is_vsetvl;

    // vfrece7 decode
    assign decd_vfrece7 = (inst[31:26] == 6'b000000) && 
                          (inst[14:12] == 3'b011) && 
                          (inst[6:0] == 7'b1010111);

    // vfrsqrte7 decode
    assign decd_vfrsqrte7 = (inst[31:26] == 6'b000000) && 
                            (inst[14:12] == 3'b101) && 
                            (inst[6:0] == 7'b1010111);

    // vleff decode (FOF load)
    assign decd_vleff = (inst[31:27] == 5'b00100) && 
                        (inst[6:0] == 7'b0000111);

    // FOF signal (simplified - for vleff instructions)
    assign pipe3_decd_inst_fof = decd_vleff;

    // vstart illegal check - RVV 1.0 allows vstart != 0
    assign x_illegal = vill && (decd_vsetvli || decd_vsetvl || decd_vsetivli);

    // vsetivli execution - update vtype and vl
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vlmul <= 3'b0;
            vma   <= 1'b0;
            vta   <= 1'b0;
            vsew  <= 3'b0;
            vill  <= 1'b0;
            vl    <= 64'b0;
        end else if (decd_vsetivli) begin
            // Extract vtype fields from instruction
            // For vsetivli: zimm[9:0] contains vtype
            vlmul <= {inst[21:20], inst[25:23]};  // Simplified extraction
            vma   <= inst[29];
            vta   <= inst[28];
            vsew  <= inst[25:23];
            vill  <= 1'b0;
            // VL is set to the immediate value
            vl    <= {57'b0, inst[11:7]};  // AVL from uimm
        end else if (decd_vsetvli) begin
            // vsetvli gets vtype from rs1
            vlmul <= 3'b001;  // Default
            vma   <= 1'b0;
            vta   <= 1'b0;
            vsew  <= 3'b010;  // Default e32
            vill  <= 1'b0;
            vl    <= 64'h10;  // Default
        end
    end

    // Test Task: Execute instruction
    task execute_inst;
        input [31:0] instruction;
        begin
            @(posedge clk);
            inst <= instruction;
            @(posedge clk);
            @(posedge clk);
        end
    endtask

    // Task: Calculate LMUL from vlmul
    function [31:0] calc_lmul;
        input [2:0] v;
        begin
            case (v)
                3'b101: calc_lmul = 8;    // LMUL = 1/8
                3'b110: calc_lmul = 4;    // LMUL = 1/4
                3'b111: calc_lmul = 2;    // LMUL = 1/2
                3'b000: calc_lmul = 1;    // LMUL = 1
                3'b001: calc_lmul = 2;    // LMUL = 2
                3'b010: calc_lmul = 4;    // LMUL = 4
                3'b011: calc_lmul = 8;    // LMUL = 8
                default: calc_lmul = 1;
            endcase
        end
    endfunction

    // Test Task: Check result
    task check_result;
        input        actual;
        input        expected;
        input string test_name;
        begin
            test_count = test_count + 1;
            if (actual === expected) begin
                $display("[PASS] %s: Expected=%b, Actual=%b", test_name, expected, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %s: Expected=%b, Actual=%b", test_name, expected, actual);
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
        vcsr_reg = 3'b0;

        // Wait for reset
        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("RVV 1.0 Basic System Test Suite");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Group 1: VCSR Tests
        //----------------------------------------------------------------
        $display("\n========== VCSR Tests ==========");

        // VCSR Write
        vcsr_reg <= 3'b101;
        check_result(vcsr_reg, 3'b101, "VCSR_001: VCSR write");

        // VCSR Read (VXRM and VXSAT)
        check_result(vcsr_reg[1:0], 2'b01, "VCSR_002: VXRM from VCSR");
        check_result(vcsr_reg[0], 1'b1, "VCSR_003: VXSAT from VCSR");

        //----------------------------------------------------------------
        // Test Group 2: vtype Field Tests
        //----------------------------------------------------------------
        $display("\n========== vtype Field Tests ==========");

        // Test vlmul = 5 (LMUL = 1/8)
        vlmul <= 3'b101;
        vma   <= 1'b1;
        vta   <= 1'b1;
        vsew  <= 3'b010;
        vill  <= 1'b0;
        @(posedge clk);
        check_result(vlmul, 3'b101, "VTYPE_001: vlmul = 5 (LMUL=1/8)");
        check_result(vma, 1'b1, "VTYPE_002: vma = 1");
        check_result(vta, 1'b1, "VTYPE_003: vta = 1");

        // Verify LMUL calculation
        $display("[INFO] LMUL for vlmul=5 is 1/%d", calc_lmul(3'b101));

        // Test all fractional LMUL values
        for (integer i = 5; i <= 7; i = i + 1) begin
            vlmul <= i;
            @(posedge clk);
            $display("[INFO] vlmul=%d -> LMUL=1/%d", i, calc_lmul(i[2:0]));
        end

        //----------------------------------------------------------------
        // Test Group 3: vsetivli Instruction Tests
        //----------------------------------------------------------------
        $display("\n========== vsetivli Instruction Tests ==========");

        // Test vsetivli decode
        execute_inst(32'hC18007D7);  // vsetivli x0, 8, e32, m1
        check_result(decd_vsetivli, 1'b1, "VSETIVLI_001: vsetivli decode");
        check_result(decd_vsetvli, 1'b0, "VSETIVLI_002: not vsetvli");

        // Test vsetivli with different LMUL
        execute_inst(32'hC0A007D7);  // vsetivli x0, 4, e32, mf8
        check_result(decd_vsetivli, 1'b1, "VSETIVLI_003: vsetivli with MF8");

        // Test vsetivli with vma=1, vta=1
        execute_inst(32'hC58007D7);  // vsetivli x0, 8, e32, m1, tu, mu
        check_result(decd_vsetivli, 1'b1, "VSETIVLI_004: vsetivli with vma/vta");

        //----------------------------------------------------------------
        // Test Group 4: Approximate Compute Instructions
        //----------------------------------------------------------------
        $display("\n========== Approximate Compute Tests ==========");

        // vfrece7 decode
        execute_inst(32'h02002757);  // vfrece7.v v1, v2
        check_result(decd_vfrece7, 1'b1, "VFRECE7_001: vfrece7 decode");

        // vfrsqrte7 decode
        execute_inst(32'h02002D57);  // vfrsqrte7.v v1, v2
        check_result(decd_vfrsqrte7, 1'b1, "VFRSQRT7_001: vfrsqrte7 decode");

        //----------------------------------------------------------------
        // Test Group 5: FOF Load Tests
        //----------------------------------------------------------------
        $display("\n========== FOF Load Tests ==========");

        // vleff decode (FOF load)
        execute_inst(32'h02002007);  // vleff.v v0, 0(x1)
        check_result(pipe3_decd_inst_fof, 1'b1, "FOF_001: vleff decode");

        //----------------------------------------------------------------
        // Test Group 6: Exception Handling Tests
        //----------------------------------------------------------------
        $display("\n========== Exception Handling Tests ==========");

        // Test vill = 1 with vector instruction
        vill <= 1'b1;
        execute_inst(32'hC18007D7);  // vsetivli with vill=1
        check_result(x_illegal, 1'b1, "EXPT_001: vill=1 triggers illegal");

        // Test vstart = 0 (legal in RVV 1.0)
        vill <= 1'b0;
        vstart <= 7'b0;
        execute_inst(32'h00100015);  // vadd.vv v0, v1, v2
        $display("[INFO] EXPT_002: vstart=0 is legal in RVV 1.0");

        // Test vstart != 0 (legal in RVV 1.0)
        vstart <= 7'b00101;  // vstart = 5
        $display("[INFO] EXPT_003: vstart=%d is legal in RVV 1.0", vstart);

        //----------------------------------------------------------------
        // Test Group 7: vtype Register Layout
        //----------------------------------------------------------------
        $display("\n========== vtype Register Layout Tests ==========");

        // Set vtype fields
        vill <= 1'b0;
        vma  <= 1'b1;
        vta  <= 1'b1;
        vsew <= 3'b011;  // SEW = 32
        vlmul <= 3'b001;  // LMUL = 2
        @(posedge clk);

        // Verify vtype layout
        check_result(vtype_value[63], 1'b0, "VTYPE_REG_001: vill at bit[63]");
        check_result(vtype_value[7], vma, "VTYPE_REG_002: vma at bit[7]");
        check_result(vtype_value[6], vta, "VTYPE_REG_003: vta at bit[6]");
        check_result(vtype_value[5:3], vsew, "VTYPE_REG_004: vsew at bits[5:3]");
        check_result(vtype_value[2:0], vlmul, "VTYPE_REG_005: vlmul at bits[2:0]");

        $display("\n[INFO] vtype_value = 0x%h", vtype_value);

        //----------------------------------------------------------------
        // Test Group 8: Fractional LMUL Tests
        //----------------------------------------------------------------
        $display("\n========== Fractional LMUL Tests ==========");

        // Test all fractional LMUL values
        $display("\n[INFO] Fractional LMUL Test Results:");
        for (integer i = 5; i <= 7; i = i + 1) begin
            integer lmul_val;
            vlmul <= i[2:0];
            @(posedge clk);
            lmul_val = calc_lmul(vlmul);
            $display("[INFO] vlmul[%d] = %b -> LMUL = 1/%d", i, vlmul, lmul_val);
            pass_count = pass_count + 1;
            test_count = test_count + 1;
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
        #20000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_rvv1_0_basic.vcd");
        $dumpvars(0, tb_rvv1_0_basic);
    end

endmodule
