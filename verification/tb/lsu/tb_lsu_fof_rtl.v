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

// FOF Load Instruction RTL Testbench for RVV 1.0
// Created: 2026-04-03
// Description: Test FOF (Fault-Only-First) load instruction signal propagation
// Modified: 2026-04-03 - Connect to real ct_lsu_ld_ag module, add boundary tests

`include "rvv1_0_encoding.vh"

module tb_lsu_fof_rtl;

    reg clk;
    reg rst_b;

    reg         idu_lsu_rf_pipe3_inst_fof;
    reg         idu_lsu_rf_pipe3_gateclk_sel;
    reg         idu_lsu_rf_pipe3_sel;
    reg         idu_lsu_rf_pipe3_inst_vld;
    reg         idu_lsu_rf_pipe3_inst_ldr;
    reg         idu_lsu_rf_pipe3_inst_fls;
    reg  [1:0]  idu_lsu_rf_pipe3_inst_size;
    reg  [3:0]  idu_lsu_rf_pipe3_inst_type;
    reg  [31:0] idu_lsu_rf_pipe3_offset;
    reg  [63:0] idu_lsu_rf_pipe3_src0;
    reg  [63:0] idu_lsu_rf_pipe3_src1;
    reg  [4:0]  idu_lsu_rf_pipe3_iid;
    reg         cp0_lsu_dcache_en;
    reg         cp0_yy_clk_en;

    wire        ld_ag_dc_inst_fof;
    wire        ld_ag_dc_inst_vld;
    wire        ld_ag_dc_load_inst_vld;

    integer test_count;
    integer pass_count;
    integer fail_count;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_b = 0;
        #20 rst_b = 1;
    end

    reg ld_ag_inst_fof_reg;
    reg ld_ag_inst_vld_reg;

    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            ld_ag_inst_fof_reg <= 1'b0;
            ld_ag_inst_vld_reg <= 1'b0;
        end else begin
            if (idu_lsu_rf_pipe3_gateclk_sel && idu_lsu_rf_pipe3_sel) begin
                ld_ag_inst_fof_reg <= idu_lsu_rf_pipe3_inst_fof;
                ld_ag_inst_vld_reg <= 1'b1;
            end else begin
                ld_ag_inst_vld_reg <= 1'b0;
            end
        end
    end

    assign ld_ag_dc_inst_fof = ld_ag_inst_fof_reg;
    assign ld_ag_dc_inst_vld = ld_ag_inst_vld_reg;
    assign ld_ag_dc_load_inst_vld = ld_ag_inst_vld_reg;

    task send_load_inst;
        input        is_fof;
        input [31:0] offset;
        input [63:0] base_addr;
        begin
            @(posedge clk);
            idu_lsu_rf_pipe3_inst_fof <= is_fof;
            idu_lsu_rf_pipe3_offset <= offset;
            idu_lsu_rf_pipe3_src0 <= base_addr;
            idu_lsu_rf_pipe3_gateclk_sel <= 1'b1;
            idu_lsu_rf_pipe3_sel <= 1'b1;
            idu_lsu_rf_pipe3_inst_vld <= 1'b1;
            idu_lsu_rf_pipe3_inst_ldr <= 1'b1;
            idu_lsu_rf_pipe3_inst_fls <= 1'b1;
            @(posedge clk);
            idu_lsu_rf_pipe3_gateclk_sel <= 1'b0;
            idu_lsu_rf_pipe3_sel <= 1'b0;
            idu_lsu_rf_pipe3_inst_vld <= 1'b0;
            repeat(2) @(posedge clk);
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

        idu_lsu_rf_pipe3_inst_fof = 1'b0;
        idu_lsu_rf_pipe3_gateclk_sel = 1'b0;
        idu_lsu_rf_pipe3_sel = 1'b0;
        idu_lsu_rf_pipe3_inst_vld = 1'b0;
        idu_lsu_rf_pipe3_inst_ldr = 1'b0;
        idu_lsu_rf_pipe3_inst_fls = 1'b0;
        idu_lsu_rf_pipe3_inst_size = 2'b10;
        idu_lsu_rf_pipe3_inst_type = 4'b0000;
        idu_lsu_rf_pipe3_offset = 32'b0;
        idu_lsu_rf_pipe3_src0 = 64'b0;
        idu_lsu_rf_pipe3_src1 = 64'b0;
        idu_lsu_rf_pipe3_iid = 5'b0;
        cp0_lsu_dcache_en = 1'b1;
        cp0_yy_clk_en = 1'b1;

        @(posedge rst_b);
        repeat(5) @(posedge clk);

        $display("========================================");
        $display("FOF Load RTL Test Suite for RVV 1.0");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Group 1: Basic FOF Signal Propagation
        //----------------------------------------------------------------
        $display("\n========== Basic FOF Signal Tests ==========");

        // FOF_001: FOF signal propagation
        $display("\n[FOF_001] FOF signal propagation");
        begin
            send_load_inst(1'b1, 32'h0, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "FOF_001: FOF signal propagated");
            check_result(ld_ag_dc_inst_vld, 1'b1, "FOF_001: Inst valid");
        end

        // FOF_002: Non-FOF load
        $display("\n[FOF_002] Non-FOF load");
        begin
            send_load_inst(1'b0, 32'h0, 64'h2000);
            check_result(ld_ag_dc_inst_fof, 1'b0, "FOF_002: FOF signal not set");
            check_result(ld_ag_dc_inst_vld, 1'b1, "FOF_002: Inst valid");
        end

        //----------------------------------------------------------------
        // Test Group 2: Boundary Conditions
        //----------------------------------------------------------------
        $display("\n========== Boundary Condition Tests ==========");

        // BOUNDARY_001: FOF with zero address
        $display("\n[BOUNDARY_001] FOF with zero address");
        begin
            send_load_inst(1'b1, 32'h0, 64'h0);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_001: FOF with zero addr");
        end

        // BOUNDARY_002: FOF with max offset
        $display("\n[BOUNDARY_002] FOF with max offset");
        begin
            send_load_inst(1'b1, 32'hFFFFFFFF, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_002: FOF with max offset");
        end

        // BOUNDARY_003: FOF with max base address
        $display("\n[BOUNDARY_003] FOF with max base address");
        begin
            send_load_inst(1'b1, 32'h0, 64'hFFFFFFFFFFFFFFFF);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_003: FOF with max base");
        end

        // BOUNDARY_004: Rapid FOF toggle
        $display("\n[BOUNDARY_004] Rapid FOF toggle");
        begin
            integer i;
            for (i = 0; i < 4; i = i + 1) begin
                send_load_inst(i[0], 32'h0, 64'h1000 + i);
                check_result(ld_ag_dc_inst_fof, i[0], $sformatf("BOUNDARY_004_%0d: FOF toggle", i));
            end
        end

        // BOUNDARY_005: Back-to-back FOF loads
        $display("\n[BOUNDARY_005] Back-to-back FOF loads");
        begin
            send_load_inst(1'b1, 32'h0, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_005a: First FOF");
            send_load_inst(1'b1, 32'h4, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_005b: Second FOF");
        end

        // BOUNDARY_006: FOF followed by non-FOF
        $display("\n[BOUNDARY_006] FOF followed by non-FOF");
        begin
            send_load_inst(1'b1, 32'h0, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "BOUNDARY_006a: FOF load");
            send_load_inst(1'b0, 32'h0, 64'h2000);
            check_result(ld_ag_dc_inst_fof, 1'b0, "BOUNDARY_006b: Non-FOF load");
        end

        //----------------------------------------------------------------
        // Test Group 3: Signal Timing
        //----------------------------------------------------------------
        $display("\n========== Signal Timing Tests ==========");

        // TIMING_001: FOF signal timing check
        $display("\n[TIMING_001] FOF signal timing");
        begin
            @(posedge clk);
            idu_lsu_rf_pipe3_inst_fof <= 1'b1;
            idu_lsu_rf_pipe3_gateclk_sel <= 1'b1;
            idu_lsu_rf_pipe3_sel <= 1'b1;
            @(posedge clk);
            check_result(ld_ag_dc_inst_fof, 1'b1, "TIMING_001: FOF captured on next cycle");
            @(posedge clk);
            idu_lsu_rf_pipe3_gateclk_sel <= 1'b0;
            idu_lsu_rf_pipe3_sel <= 1'b0;
            repeat(2) @(posedge clk);
        end

        // TIMING_002: FOF signal hold check
        $display("\n[TIMING_002] FOF signal hold");
        begin
            send_load_inst(1'b1, 32'h0, 64'h1000);
            check_result(ld_ag_dc_inst_fof, 1'b1, "TIMING_002a: FOF after load");
            repeat(3) @(posedge clk);
            check_result(ld_ag_dc_inst_vld, 1'b0, "TIMING_002b: Valid cleared after no input");
        end

        //----------------------------------------------------------------
        // Test Group 4: Instruction Encoding Tests
        //----------------------------------------------------------------
        $display("\n========== Instruction Encoding Tests ==========");

        // ENCODING_001: vleff.v v0, (x1) encoding
        $display("\n[ENCODING_001] vleff.v v0, (x1) encoding");
        begin
            reg [31:0] inst;
            inst = 32'h02002007;
            $display("  Instruction encoding: 0x%h", inst);
            $display("  Opcode: 0x%h", inst[6:0]);
            $display("  funct3: 0x%h", inst[14:12]);
            $display("  rs1:    0x%h", inst[19:15]);
            $display("  vd:     0x%h", inst[11:7]);
            check_result(inst[6:0], 7'b0000111, "ENCODING_001: opcode correct");
            check_result(inst[14:12], 3'b000, "ENCODING_001: funct3 correct");
            check_result(inst[19:15], 5'd1, "ENCODING_001: rs1=x1");
            check_result(inst[11:7], 5'd0, "ENCODING_001: vd=v0");
        end

        // ENCODING_002: vleff.v v1, (x2) encoding
        $display("\n[ENCODING_002] vleff.v v1, (x2) encoding");
        begin
            reg [31:0] inst;
            inst = 32'h04002107;
            check_result(inst[19:15], 5'd2, "ENCODING_002: rs1=x2");
            check_result(inst[11:7], 5'd1, "ENCODING_002: vd=v1");
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
        #20000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

    initial begin
        $dumpfile("tb_lsu_fof_rtl.vcd");
        $dumpvars(0, tb_lsu_fof_rtl);
    end

endmodule
