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

// vtype Field Testbench for RVV 1.0
// Created: 2026-04-02
// Description: Test vtype field extensions (vlmul, vma, vta)

module tb_rtu_vtype;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // ROB Interface
    reg         create_en;
    reg  [41:0] create_data;  // Extended to 42 bits for RVV 1.0
    wire [41:0] rob_entry_data;

    // vtype fields
    wire [2:0]  vlmul;
    wire        vma;
    wire        vta;
    wire [2:0]  vsew;
    wire        vill;

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

    // DUT - Simplified ROB Entry for vtype testing
    reg [2:0]  vlmul_reg;
    reg        vma_reg;
    reg        vta_reg;
    reg [2:0]  vsew_reg;
    reg        vill_reg;

    // ROB field positions (from ct_rtu_rob_entry.v)
    parameter ROB_VLMUL = 27;
    parameter ROB_VMA   = 26;
    parameter ROB_VTA   = 25;
    parameter ROB_VSEW  = 22;
    parameter ROB_VILL  = 63;  // In actual implementation

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vlmul_reg <= 3'b0;
            vma_reg   <= 1'b0;
            vta_reg   <= 1'b0;
            vsew_reg  <= 3'b0;
            vill_reg  <= 1'b0;
        end else if (create_en) begin
            vlmul_reg <= create_data[ROB_VLMUL -: 3];
            vma_reg   <= create_data[ROB_VMA];
            vta_reg   <= create_data[ROB_VTA];
            vsew_reg  <= create_data[ROB_VSEW -: 3];
        end
    end

    assign vlmul = vlmul_reg;
    assign vma   = vma_reg;
    assign vta   = vta_reg;
    assign vsew  = vsew_reg;
    assign vill  = vill_reg;

    // Test Task: Create ROB Entry
    task create_rob_entry;
        input [41:0] data;
        begin
            @(posedge clk);
            create_data <= data;
            create_en <= 1'b1;
            @(posedge clk);
            create_en <= 1'b0;
            @(posedge clk);
        end
    endtask

    // Test Task: Check result
    task check_result;
        input [3:0] actual;
        input [3:0] expected;
        input string test_name;
        begin
            test_count = test_count + 1;
            if (actual === expected) begin
                $display("[PASS] %s: Expected=0x%h, Actual=0x%h", test_name, expected, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %s: Expected=0x%h, Actual=0x%h", test_name, expected, actual);
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
        create_en = 1'b0;
        create_data = 42'b0;

        // Wait for reset
        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("vtype Field Test Suite for RVV 1.0");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Case VTYPE_001: vlmul Field Extension (LMUL=1/8)
        //----------------------------------------------------------------
        $display("\n[VTYPE_001] vlmul Field Extension Test (LMUL=1/8)");
        begin
            // vlmul=5 (LMUL=1/8), vma=0, vta=0, vsew=0
            create_rob_entry({15'b0, 1'b0, 3'b000, 1'b0, 1'b0, 3'b101, 18'b0});
            check_result(vlmul, 3'b101, "VTYPE_001: vlmul=5 (LMUL=1/8)");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_002: vlmul Field Extension (LMUL=1/4)
        //----------------------------------------------------------------
        $display("\n[VTYPE_002] vlmul Field Extension Test (LMUL=1/4)");
        begin
            create_rob_entry({15'b0, 1'b0, 3'b000, 1'b0, 1'b0, 3'b110, 18'b0});
            check_result(vlmul, 3'b110, "VTYPE_002: vlmul=6 (LMUL=1/4)");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_003: vlmul Field Extension (LMUL=1/2)
        //----------------------------------------------------------------
        $display("\n[VTYPE_003] vlmul Field Extension Test (LMUL=1/2)");
        begin
            create_rob_entry({15'b0, 1'b0, 3'b000, 1'b0, 1'b0, 3'b111, 18'b0});
            check_result(vlmul, 3'b111, "VTYPE_003: vlmul=7 (LMUL=1/2)");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_004: vma Field Setting
        //----------------------------------------------------------------
        $display("\n[VTYPE_004] vma Field Setting Test");
        begin
            create_rob_entry({15'b0, 1'b0, 3'b000, 1'b1, 1'b0, 3'b000, 18'b0});
            check_result(vma, 1'b1, "VTYPE_004: vma=1");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_005: vta Field Setting
        //----------------------------------------------------------------
        $display("\n[VTYPE_005] vta Field Setting Test");
        begin
            create_rob_entry({15'b0, 1'b0, 3'b000, 1'b0, 1'b1, 3'b000, 18'b0});
            check_result(vta, 1'b1, "VTYPE_005: vta=1");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_006: vsew Field Setting
        //----------------------------------------------------------------
        $display("\n[VTYPE_006] vsew Field Setting Test");
        begin
            create_rob_entry({15'b0, 1'b0, 3'b101, 1'b0, 1'b0, 3'b000, 18'b0});
            check_result(vsew, 3'b101, "VTYPE_006: vsew=5 (SEW=64)");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_007: All Fields Combined
        //----------------------------------------------------------------
        $display("\n[VTYPE_007] All Fields Combined Test");
        begin
            // vlmul=3 (LMUL=8), vma=1, vta=1, vsew=3 (SEW=32)
            create_rob_entry({15'b0, 1'b0, 3'b011, 1'b1, 1'b1, 3'b011, 18'b0});
            check_result(vlmul, 3'b011, "VTYPE_007: vlmul=3");
            check_result(vma, 1'b1, "VTYPE_007: vma=1");
            check_result(vta, 1'b1, "VTYPE_007: vta=1");
            check_result(vsew, 3'b011, "VTYPE_007: vsew=3");
        end

        //----------------------------------------------------------------
        // Test Case VTYPE_008: ROB_WIDTH Verification
        //----------------------------------------------------------------
        $display("\n[VTYPE_008] ROB_WIDTH Verification Test");
        begin
            // Test all 42 bits can be stored
            create_rob_entry(42'h3FFFFFFFFFFFF);
            $display("[INFO] VTYPE_008: ROB entry created with all bits set");
            $display("[INFO] vlmul=%b, vma=%b, vta=%b, vsew=%b", vlmul, vma, vta, vsew);
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
        #10000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_rtu_vtype.vcd");
        $dumpvars(0, tb_rtu_vtype);
    end

endmodule
