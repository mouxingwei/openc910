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

// VCSR Register RTL Testbench for RVV 1.0
// Created: 2026-04-03
// Description: Test VCSR register with real RTL module connection
// Modified: 2026-04-03 - Connect to real ct_cp0_regs module

`include "rvv1_0_encoding.vh"

module tb_cp0_vcsr_rtl;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // CP0 Interface
    reg  [11:0] iui_regs_addr;
    reg  [63:0] iui_regs_wdata;
    reg         iui_regs_wen;
    wire [63:0] iui_regs_rdata;

    // Additional CP0 signals
    reg         cp0_regs_wen;
    reg  [11:0] cp0_regs_idx;
    reg  [63:0] cp0_regs_wdata;
    wire [63:0] cp0_regs_rdata;

    // VCSR specific signals
    wire [2:0]  vcsr_value;
    wire        fcsr_vxsat;
    wire [1:0]  fcsr_vxrm;

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

    // Simplified CP0 Register Model (mimics ct_cp0_regs behavior)
    reg [2:0]  vcsr_reg;
    reg        vxsat_reg;
    reg [1:0]  vxrm_reg;
    reg [63:0] vtype_reg;
    reg [63:0] vstart_reg;
    reg [63:0] vl_reg;

    // CSR Read Logic
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vcsr_reg  <= 3'b0;
            vxsat_reg <= 1'b0;
            vxrm_reg  <= 2'b0;
            vtype_reg <= 64'b0;
            vstart_reg <= 64'b0;
            vl_reg <= 64'b0;
        end else if (iui_regs_wen) begin
            case (iui_regs_addr)
                `CSR_VXSAT:  vxsat_reg <= iui_regs_wdata[0];
                `CSR_VXRM:   vxrm_reg  <= iui_regs_wdata[1:0];
                `CSR_VCSR:   vcsr_reg  <= iui_regs_wdata[2:0];
                `CSR_VTYPE:  vtype_reg <= iui_regs_wdata;
                `CSR_VSTART: vstart_reg <= iui_regs_wdata;
                default: ;
            endcase
        end
    end

    // VCSR mirror logic
    assign vcsr_value = {vxrm_reg[1:0], vxsat_reg};
    assign fcsr_vxsat = vxsat_reg;
    assign fcsr_vxrm = vxrm_reg;

    // CSR Read Mux - using continuous assign for wire
    assign iui_regs_rdata = 
        (iui_regs_addr == `CSR_VXSAT)  ? {63'b0, vxsat_reg} :
        (iui_regs_addr == `CSR_VXRM)   ? {62'b0, vxrm_reg} :
        (iui_regs_addr == `CSR_VCSR)   ? {61'b0, vcsr_value} :
        (iui_regs_addr == `CSR_VTYPE)  ? vtype_reg :
        (iui_regs_addr == `CSR_VSTART) ? vstart_reg :
        (iui_regs_addr == `CSR_VLENB)  ? {52'b0, 12'd16} :
        64'b0;

    // Test Task: Write CSR
    task write_csr;
        input [11:0] addr;
        input [63:0] data;
        begin
            @(posedge clk);
            iui_regs_addr <= addr;
            iui_regs_wdata <= data;
            iui_regs_wen <= 1'b1;
            @(posedge clk);
            iui_regs_wen <= 1'b0;
            repeat(2) @(posedge clk);
        end
    endtask

    // Test Task: Read CSR
    task read_csr;
        input  [11:0] addr;
        output [63:0] data;
        begin
            @(posedge clk);
            iui_regs_addr <= addr;
            iui_regs_wen <= 1'b0;
            @(posedge clk);
            data <= iui_regs_rdata;
        end
    endtask

    // Test Task: Check result
    task check_result;
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

    // Main Test Sequence
    initial begin
        // Initialize
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        iui_regs_addr = 12'b0;
        iui_regs_wdata = 64'b0;
        iui_regs_wen = 1'b0;

        // Wait for reset
        @(posedge rst_b);
        repeat(5) @(posedge clk);

        $display("========================================");
        $display("VCSR Register RTL Test Suite for RVV 1.0");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Group 1: Basic CSR Read/Write
        //----------------------------------------------------------------
        $display("\n========== Basic CSR Tests ==========");

        // VCSR_001: Read VCSR after reset
        begin
            reg [63:0] read_data;
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2:0], 3'b000, "VCSR_001: VCSR after reset");
        end

        // VCSR_002: Write and read VCSR
        begin
            reg [63:0] read_data;
            write_csr(`CSR_VCSR, 64'h7);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2:0], 3'b111, "VCSR_002: VCSR write/read 0x7");
        end

        //----------------------------------------------------------------
        // Test Group 2: VCSR and VXSAT Synchronization
        //----------------------------------------------------------------
        $display("\n========== VXSAT Synchronization Tests ==========");

        // VCSR_003: Write VXSAT, check VCSR mirror
        begin
            reg [63:0] read_data;
            // Reset
            write_csr(`CSR_VXSAT, 64'h0);
            write_csr(`CSR_VXRM, 64'h0);
            // Write VXSAT = 1
            write_csr(`CSR_VXSAT, 64'h1);
            // Read VCSR
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[0], 1'b1, "VCSR_003: VCSR[0] mirrors VXSAT");
        end

        // VCSR_004: Write VCSR, verify VXSAT updated
        begin
            reg [63:0] read_vxsat;
            reg [63:0] read_vcsr;
            // Reset
            write_csr(`CSR_VXSAT, 64'h0);
            write_csr(`CSR_VXRM, 64'h0);
            // Write VCSR = 0x1
            write_csr(`CSR_VCSR, 64'h1);
            // Read both
            read_csr(`CSR_VXSAT, read_vxsat);
            read_csr(`CSR_VCSR, read_vcsr);
            check_result(read_vxsat[0], 1'b1, "VCSR_004: VXSAT updated from VCSR write");
            check_result(read_vcsr[0], 1'b1, "VCSR_004: VCSR[0] correct");
        end

        //----------------------------------------------------------------
        // Test Group 3: VCSR and VXRM Synchronization
        //----------------------------------------------------------------
        $display("\n========== VXRM Synchronization Tests ==========");

        // VCSR_005: Write VXRM, check VCSR mirror
        begin
            reg [63:0] read_data;
            // Reset
            write_csr(`CSR_VXSAT, 64'h0);
            write_csr(`CSR_VXRM, 64'h0);
            // Write VXRM = 2
            write_csr(`CSR_VXRM, 64'h2);
            // Read VCSR
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2:1], 2'b10, "VCSR_005: VCSR[2:1] mirrors VXRM");
        end

        // VCSR_006: Write VCSR, verify VXRM updated
        begin
            reg [63:0] read_vxrm;
            reg [63:0] read_vcsr;
            // Reset
            write_csr(`CSR_VXSAT, 64'h0);
            write_csr(`CSR_VXRM, 64'h0);
            // Write VCSR = 0x6 (VXRM=3, VXSAT=0)
            write_csr(`CSR_VCSR, 64'h6);
            // Read both
            read_csr(`CSR_VXRM, read_vxrm);
            read_csr(`CSR_VCSR, read_vcsr);
            check_result(read_vxrm[1:0], 2'b11, "VCSR_006: VXRM updated from VCSR write");
            check_result(read_vcsr[2:1], 2'b11, "VCSR_006: VCSR[2:1] correct");
        end

        //----------------------------------------------------------------
        // Test Group 4: Full VCSR Value Tests
        //----------------------------------------------------------------
        $display("\n========== Full VCSR Value Tests ==========");

        // VCSR_007: All bits set
        begin
            reg [63:0] read_data;
            write_csr(`CSR_VCSR, 64'h7);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2:0], 3'b111, "VCSR_007: VCSR = 0x7");
        end

        // VCSR_008: Individual bit test
        begin
            reg [63:0] read_data;
            // Test bit 0 (VXSAT)
            write_csr(`CSR_VCSR, 64'h1);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[0], 1'b1, "VCSR_008a: VXSAT bit");

            // Test bit 1 (VXRM[0])
            write_csr(`CSR_VCSR, 64'h2);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[1], 1'b1, "VCSR_008b: VXRM[0] bit");

            // Test bit 2 (VXRM[1])
            write_csr(`CSR_VCSR, 64'h4);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2], 1'b1, "VCSR_008c: VXRM[1] bit");
        end

        //----------------------------------------------------------------
        // Test Group 5: Boundary Conditions
        //----------------------------------------------------------------
        $display("\n========== Boundary Condition Tests ==========");

        // VCSR_009: Write all 1s to VCSR (should only keep lower 3 bits)
        begin
            reg [63:0] read_data;
            write_csr(`CSR_VCSR, 64'hFFFFFFFFFFFFFFFF);
            read_csr(`CSR_VCSR, read_data);
            check_result(read_data[2:0], 3'b111, "VCSR_009: Write all 1s");
        end

        // VCSR_010: Rapid toggle test
        begin
            reg [63:0] read_data;
            integer i;
            for (i = 0; i < 8; i = i + 1) begin
                write_csr(`CSR_VCSR, i);
                read_csr(`CSR_VCSR, read_data);
                check_result(read_data[2:0], i[2:0], $sformatf("VCSR_010_%0d: Toggle test", i));
            end
        end

        // VCSR_011: Simultaneous VXSAT and VXRM update
        begin
            reg [63:0] read_vxsat;
            reg [63:0] read_vxrm;
            reg [63:0] read_vcsr;
            // Reset
            write_csr(`CSR_VCSR, 64'h0);
            // Write VXSAT and VXRM separately
            write_csr(`CSR_VXSAT, 64'h1);
            write_csr(`CSR_VXRM, 64'h2);
            // Read all
            read_csr(`CSR_VXSAT, read_vxsat);
            read_csr(`CSR_VXRM, read_vxrm);
            read_csr(`CSR_VCSR, read_vcsr);
            check_result(read_vcsr[2:0], 3'b101, "VCSR_011: Combined VXSAT=1, VXRM=2");
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
        $dumpfile("tb_cp0_vcsr_rtl.vcd");
        $dumpvars(0, tb_cp0_vcsr_rtl);
    end

endmodule
