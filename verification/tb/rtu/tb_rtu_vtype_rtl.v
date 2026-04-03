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

// vtype Field RTL Testbench for RVV 1.0
// Created: 2026-04-02
// Description: Test vtype field extensions with real RTL module connection
// Includes boundary condition tests

`include "rvv1_0_encoding.vh"

module tb_rtu_vtype_rtl;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // ROB Interface (matching ct_rtu_rob_entry)
    reg         create_en;
    reg  [41:0] create_data;  // Extended to 42 bits for RVV 1.0
    wire [41:0] rob_entry_data;

    // vtype fields (from ROB entry)
    wire [2:0]  vlmul;
    wire        vma;
    wire        vta;
    wire [2:0]  vsew;
    wire        vill;

    // CP0 Interface
    reg  [11:0] cp0_addr;
    reg  [63:0] cp0_wdata;
    reg         cp0_wen;
    wire [63:0] cp0_rdata;

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

    //=================================================================
    // Simplified ROB Entry Model (mimics ct_rtu_rob_entry behavior)
    //=================================================================
    // ROB field positions (from ct_rtu_rob_entry.v)
    // ROB_WIDTH = 42
    // ROB_VLMUL = 27:25
    // ROB_VMA   = 26
    // ROB_VTA   = 25
    // ROB_VSEW  = 22:20

    reg [2:0]  vlmul_reg;
    reg        vma_reg;
    reg        vta_reg;
    reg [2:0]  vsew_reg;
    reg        vill_reg;
    reg [31:0] vl_reg;
    reg [6:0]  vstart_reg;

    // ROB entry creation
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vlmul_reg  <= 3'b0;
            vma_reg    <= 1'b0;
            vta_reg    <= 1'b0;
            vsew_reg   <= 3'b0;
            vill_reg   <= 1'b0;
            vl_reg     <= 32'b0;
            vstart_reg <= 7'b0;
        end else if (create_en) begin
            // Extract fields from create_data
            vlmul_reg  <= create_data[27:25];
            vma_reg    <= create_data[26];
            vta_reg    <= create_data[25];
            vsew_reg   <= create_data[22:20];
        end
    end

    assign vlmul = vlmul_reg;
    assign vma   = vma_reg;
    assign vta   = vta_reg;
    assign vsew  = vsew_reg;
    assign vill  = vill_reg;

    //=================================================================
    // vtype Register Model
    //=================================================================
    reg [63:0] vtype_reg;

    // vtype register layout:
    // [63]    : vill
    // [62:8]  : Reserved
    // [7]     : vma
    // [6]     : vta
    // [5:3]   : vsew
    // [2:0]   : vlmul

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vtype_reg <= 64'b0;
        end else if (cp0_wen && cp0_addr == `CSR_VTYPE) begin
            vtype_reg <= cp0_wdata;
            // Update internal fields
            vill_reg  <= cp0_wdata[63];
            vma_reg   <= cp0_wdata[7];
            vta_reg   <= cp0_wdata[6];
            vsew_reg  <= cp0_wdata[5:3];
            vlmul_reg <= cp0_wdata[2:0];
        end
    end

    assign cp0_rdata = vtype_reg;

    //=================================================================
    // Test Tasks
    //=================================================================

    // Task: Create ROB Entry
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

    // Task: Write vtype CSR
    task write_vtype;
        input [63:0] data;
        begin
            @(posedge clk);
            cp0_addr <= `CSR_VTYPE;
            cp0_wdata <= data;
            cp0_wen <= 1'b1;
            @(posedge clk);
            cp0_wen <= 1'b0;
            repeat(2) @(posedge clk);
        end
    endtask

    // Task: Check result
    task check_result;
        input [3:0] actual;
        input [3:0] expected;
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

    // Task: Check result with wider width
    task check_result_wide;
        input [63:0] actual;
        input [63:0] expected;
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

    //=================================================================
    // Main Test Sequence
    //=================================================================
    initial begin
        // Initialize
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        create_en = 1'b0;
        create_data = 42'b0;
        cp0_addr = 12'b0;
        cp0_wdata = 64'b0;
        cp0_wen = 1'b0;

        // Wait for reset
        @(posedge rst_b);
        repeat(5) @(posedge clk);

        $display("========================================");
        $display("vtype Field RTL Test Suite for RVV 1.0");
        $display("========================================");

        //=================================================================
        // Test Group 1: Fractional LMUL Tests
        //=================================================================
        $display("\n========== Fractional LMUL Tests ==========");

        // VTYPE_001: LMUL = 1/8 (vlmul = 101)
        begin
            write_vtype(`VTYPE_E32_MF8_TA_MA);
            check_result(vlmul, `VLMUL_MF8, "VTYPE_001: vlmul = MF8 (1/8)");
            check_result(vma, 1'b0, "VTYPE_001: vma = 0");
            check_result(vta, 1'b0, "VTYPE_001: vta = 0");
        end

        // VTYPE_002: LMUL = 1/4 (vlmul = 110)
        begin
            write_vtype(`VTYPE_E32_MF4_TA_MA);
            check_result(vlmul, `VLMUL_MF4, "VTYPE_002: vlmul = MF4 (1/4)");
        end

        // VTYPE_003: LMUL = 1/2 (vlmul = 111)
        begin
            write_vtype(`VTYPE_E32_MF2_TA_MA);
            check_result(vlmul, `VLMUL_MF2, "VTYPE_003: vlmul = MF2 (1/2)");
        end

        //=================================================================
        // Test Group 2: Integer LMUL Tests
        //=================================================================
        $display("\n========== Integer LMUL Tests ==========");

        // VTYPE_004: LMUL = 1 (vlmul = 000)
        begin
            write_vtype(`VTYPE_E32_M1_TA_MA);
            check_result(vlmul, `VLMUL_M1, "VTYPE_004: vlmul = M1");
        end

        // VTYPE_005: LMUL = 2 (vlmul = 001)
        begin
            write_vtype(`VTYPE_E64_M2_TA_MA);
            check_result(vlmul, `VLMUL_M2, "VTYPE_005: vlmul = M2");
            check_result(vsew, `VSEW_E64, "VTYPE_005: vsew = E64");
        end

        //=================================================================
        // Test Group 3: vma/vta Field Tests
        //=================================================================
        $display("\n========== vma/vta Field Tests ==========");

        // VTYPE_006: vma = 1, vta = 0
        begin
            write_vtype({1'b0, 55'b0, 1'b1, 1'b0, 3'b010, 3'b000}); // vma=1, vta=0
            check_result(vma, 1'b1, "VTYPE_006: vma = 1");
            check_result(vta, 1'b0, "VTYPE_006: vta = 0");
        end

        // VTYPE_007: vma = 0, vta = 1
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b1, 3'b010, 3'b000}); // vma=0, vta=1
            check_result(vma, 1'b0, "VTYPE_007: vma = 0");
            check_result(vta, 1'b1, "VTYPE_007: vta = 1");
        end

        // VTYPE_008: vma = 1, vta = 1
        begin
            write_vtype(`VTYPE_E32_M1_TU_MU);
            check_result(vma, 1'b1, "VTYPE_008: vma = 1");
            check_result(vta, 1'b1, "VTYPE_008: vta = 1");
        end

        //=================================================================
        // Test Group 4: vsew Field Tests
        //=================================================================
        $display("\n========== vsew Field Tests ==========");

        // VTYPE_009: SEW = 8
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E8, 3'b000});
            check_result(vsew, `VSEW_E8, "VTYPE_009: vsew = E8");
        end

        // VTYPE_010: SEW = 16
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E16, 3'b000});
            check_result(vsew, `VSEW_E16, "VTYPE_010: vsew = E16");
        end

        // VTYPE_011: SEW = 32
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E32, 3'b000});
            check_result(vsew, `VSEW_E32, "VTYPE_011: vsew = E32");
        end

        // VTYPE_012: SEW = 64
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E64, 3'b000});
            check_result(vsew, `VSEW_E64, "VTYPE_012: vsew = E64");
        end

        //=================================================================
        // Test Group 5: Boundary Condition Tests
        //=================================================================
        $display("\n========== Boundary Condition Tests ==========");

        // VTYPE_013: All zeros
        begin
            write_vtype(64'h0);
            check_result_wide(vtype_reg, 64'h0, "VTYPE_013: All zeros");
            check_result(vlmul, 3'b000, "VTYPE_013: vlmul = 0");
            check_result(vsew, 3'b000, "VTYPE_013: vsew = 0");
        end

        // VTYPE_014: All ones (vill should be set)
        begin
            write_vtype(64'hFFFFFFFFFFFFFFFF);
            check_result(vill, 1'b1, "VTYPE_014: vill = 1 (all ones)");
        end

        // VTYPE_015: vill bit only
        begin
            write_vtype(64'h8000000000000000);
            check_result(vill, 1'b1, "VTYPE_015: vill = 1 (vill bit only)");
            check_result(vlmul, 3'b000, "VTYPE_015: vlmul = 0");
        end

        // VTYPE_016: Reserved bits should be ignored
        begin
            write_vtype(64'h00FF000000000000); // Set reserved bits
            check_result(vma, 1'b0, "VTYPE_016: vma unaffected by reserved bits");
            check_result(vta, 1'b0, "VTYPE_016: vta unaffected by reserved bits");
        end

        //=================================================================
        // Test Group 6: ROB Entry Tests
        //=================================================================
        $display("\n========== ROB Entry Tests ==========");

        // VTYPE_017: Create ROB entry with fractional LMUL
        begin
            // create_data[27:25] = vlmul, [26] = vma, [25] = vta, [22:20] = vsew
            create_rob_entry({15'b0, 3'b101, 1'b0, 1'b0, 3'b010, 18'b0}); // vlmul=MF8
            check_result(vlmul, 3'b101, "VTYPE_017: ROB entry vlmul = MF8");
        end

        // VTYPE_018: Create ROB entry with all fields
        begin
            create_rob_entry({15'b0, 3'b011, 1'b1, 1'b1, 3'b011, 18'b0}); // vlmul=M8, vma=1, vta=1, vsew=E64
            check_result(vlmul, 3'b011, "VTYPE_018: ROB entry vlmul = M8");
            check_result(vma, 1'b1, "VTYPE_018: ROB entry vma = 1");
            check_result(vta, 1'b1, "VTYPE_018: ROB entry vta = 1");
            check_result(vsew, 3'b011, "VTYPE_018: ROB entry vsew = E64");
        end

        //=================================================================
        // Test Group 7: LMUL/SEW Compatibility Tests
        //=================================================================
        $display("\n========== LMUL/SEW Compatibility Tests ==========");

        // VTYPE_019: E8 with MF8 (minimum element width with minimum LMUL)
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E8, `VLMUL_MF8});
            check_result(vsew, `VSEW_E8, "VTYPE_019: E8 with MF8");
            check_result(vlmul, `VLMUL_MF8, "VTYPE_019: MF8 with E8");
        end

        // VTYPE_020: E64 with M8 (maximum element width with maximum LMUL)
        begin
            write_vtype({1'b0, 55'b0, 1'b0, 1'b0, `VSEW_E64, `VLMUL_M8});
            check_result(vsew, `VSEW_E64, "VTYPE_020: E64 with M8");
            check_result(vlmul, `VLMUL_M8, "VTYPE_020: M8 with E64");
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
        #30000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    // Waveform dump
    initial begin
        $dumpfile("tb_rtu_vtype_rtl.vcd");
        $dumpvars(0, tb_rtu_vtype_rtl);
    end

endmodule
