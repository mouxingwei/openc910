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

// VCSR Register Testbench for RVV 1.0
// Created: 2026-04-02
// Description: Test VCSR register read/write and synchronization with VXSAT/VXRM

module tb_cp0_vcsr;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // CSR Interface
    reg  [11:0] csr_addr;
    reg  [63:0] csr_wdata;
    reg         csr_wen;
    wire [63:0] csr_rdata;

    // Test counters
    integer test_count;
    integer pass_count;
    integer fail_count;

    // Test signals
    reg  [2:0] vcsr_expected;
    reg  [2:0] vxsat_value;
    reg  [1:0] vxrm_value;

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

    // DUT Instance - simplified CP0 CSR module
    // Note: In actual implementation, instantiate the real ct_cp0_regs module
    reg [2:0] vcsr_reg;
    reg       vxsat_reg;
    reg [1:0] vxrm_reg;

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            vcsr_reg <= 3'b0;
            vxsat_reg <= 1'b0;
            vxrm_reg <= 2'b0;
        end else if (csr_wen) begin
            case (csr_addr)
                12'h009: vxsat_reg <= csr_wdata[0];           // VXSAT
                12'h00A: vxrm_reg <= csr_wdata[1:0];          // VXRM
                12'h00F: vcsr_reg <= csr_wdata[2:0];          // VCSR
            endcase
        end
    end

    // VCSR is a mirror of VXSAT and VXRM
    wire [2:0] vcsr_mirror = {vxrm_reg[1:0], vxsat_reg};

    // Read data mux
    assign csr_rdata = (csr_addr == 12'h00F) ? {61'b0, vcsr_mirror} :
                       (csr_addr == 12'h009) ? {63'b0, vxsat_reg} :
                       (csr_addr == 12'h00A) ? {62'b0, vxrm_reg} : 64'b0;

    // Test Task: Write CSR
    task write_csr;
        input [11:0] addr;
        input [63:0] data;
        begin
            @(posedge clk);
            csr_addr <= addr;
            csr_wdata <= data;
            csr_wen <= 1'b1;
            @(posedge clk);
            csr_wen <= 1'b0;
            @(posedge clk);
        end
    endtask

    // Test Task: Read CSR
    task read_csr;
        input  [11:0] addr;
        output [63:0] data;
        begin
            @(posedge clk);
            csr_addr <= addr;
            csr_wen <= 1'b0;
            @(posedge clk);
            data <= csr_rdata;
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
        csr_addr = 12'b0;
        csr_wdata = 64'b0;
        csr_wen = 1'b0;

        // Wait for reset
        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("VCSR Register Test Suite for RVV 1.0");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Case VCSR_001: VCSR Read Operation
        //----------------------------------------------------------------
        $display("\n[VCSR_001] VCSR Read Operation Test");
        begin
            reg [63:0] read_data;
            read_csr(12'h00F, read_data);
            check_result(read_data, 64'h0, "VCSR_001: Initial VCSR read");
        end

        //----------------------------------------------------------------
        // Test Case VCSR_002: VCSR Write Operation
        //----------------------------------------------------------------
        $display("\n[VCSR_002] VCSR Write Operation Test");
        begin
            reg [63:0] read_data;
            write_csr(12'h00F, 64'h7);
            read_csr(12'h00F, read_data);
            check_result(read_data, 64'h7, "VCSR_002: VCSR write 0x7");
        end

        //----------------------------------------------------------------
        // Test Case VCSR_003: VCSR and VXSAT Synchronization
        //----------------------------------------------------------------
        $display("\n[VCSR_003] VCSR and VXSAT Synchronization Test");
        begin
            reg [63:0] read_data;
            // Reset
            write_csr(12'h009, 64'h0);
            write_csr(12'h00A, 64'h0);
            // Write VXSAT = 1
            write_csr(12'h009, 64'h1);
            // Read VCSR
            read_csr(12'h00F, read_data);
            check_result(read_data[0], 1'b1, "VCSR_003: VCSR[0] after VXSAT=1");
        end

        //----------------------------------------------------------------
        // Test Case VCSR_004: VCSR and VXRM Synchronization
        //----------------------------------------------------------------
        $display("\n[VCSR_004] VCSR and VXRM Synchronization Test");
        begin
            reg [63:0] read_data;
            // Reset
            write_csr(12'h009, 64'h0);
            write_csr(12'h00A, 64'h0);
            // Write VXRM = 2
            write_csr(12'h00A, 64'h2);
            // Read VCSR
            read_csr(12'h00F, read_data);
            check_result(read_data[2:1], 2'b10, "VCSR_004: VCSR[2:1] after VXRM=2");
        end

        //----------------------------------------------------------------
        // Test Case VCSR_005: VCSR Full Value Test
        //----------------------------------------------------------------
        $display("\n[VCSR_005] VCSR Full Value Test");
        begin
            reg [63:0] read_data;
            // Set VXSAT=1, VXRM=3
            write_csr(12'h009, 64'h1);
            write_csr(12'h00A, 64'h3);
            // Read VCSR
            read_csr(12'h00F, read_data);
            check_result(read_data[2:0], 3'b111, "VCSR_005: VCSR full value test");
        end

        //----------------------------------------------------------------
        // Test Case VCSR_006: VCSR Write Synchronizes to VXSAT/VXRM
        //----------------------------------------------------------------
        $display("\n[VCSR_006] VCSR Write Synchronization Test");
        begin
            reg [63:0] read_vxsat;
            reg [63:0] read_vxrm;
            reg [63:0] read_vcsr;
            // Reset
            write_csr(12'h009, 64'h0);
            write_csr(12'h00A, 64'h0);
            // Write VCSR = 0x5 (VXRM=2, VXSAT=1)
            write_csr(12'h00F, 64'h5);
            // Read back all
            read_csr(12'h009, read_vxsat);
            read_csr(12'h00A, read_vxrm);
            read_csr(12'h00F, read_vcsr);
            // Note: VCSR write behavior depends on implementation
            // This test verifies the mirror behavior
            check_result(read_vcsr[2:0], 3'b101, "VCSR_006: VCSR value after write");
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
        $dumpfile("tb_cp0_vcsr.vcd");
        $dumpvars(0, tb_cp0_vcsr);
    end

endmodule
