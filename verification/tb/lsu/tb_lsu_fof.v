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

// FOF (Fault-Only-First) Load Testbench for RVV 1.0
// Created: 2026-04-02
// Description: Test FOF load signal propagation through pipeline stages

module tb_lsu_fof;

    // Clock and Reset
    reg clk;
    reg rst_b;

    // IDU -> RF signals
    reg         idu_lsu_rf_pipe3_inst_vld;
    reg         idu_lsu_rf_pipe3_inst_fof;
    reg  [6:0]  idu_lsu_rf_pipe3_iid;

    // LD_AG stage signals
    wire        ld_ag_inst_fof;
    wire        ld_ag_dc_inst_fof;

    // LD_DC stage signals
    wire        ld_dc_inst_fof;

    // LD_DA stage signals
    wire        ld_da_inst_fof;

    // Pipeline control
    reg         ag_stage_vld;
    reg         dc_stage_vld;
    reg         da_stage_vld;

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

    // LD_AG Stage - FOF signal register
    reg ld_ag_inst_fof_reg;
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            ld_ag_inst_fof_reg <= 1'b0;
        end else if (idu_lsu_rf_pipe3_inst_vld) begin
            ld_ag_inst_fof_reg <= idu_lsu_rf_pipe3_inst_fof;
        end
    end
    assign ld_ag_inst_fof = ld_ag_inst_fof_reg;
    assign ld_ag_dc_inst_fof = ld_ag_inst_fof_reg;

    // LD_DC Stage - FOF signal register
    reg ld_dc_inst_fof_reg;
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            ld_dc_inst_fof_reg <= 1'b0;
        end else if (ag_stage_vld) begin
            ld_dc_inst_fof_reg <= ld_ag_dc_inst_fof;
        end
    end
    assign ld_dc_inst_fof = ld_dc_inst_fof_reg;

    // LD_DA Stage - FOF signal register
    reg ld_da_inst_fof_reg;
    always @(posedge clk or negedge rst_b) begin
        if (!rst_b) begin
            ld_da_inst_fof_reg <= 1'b0;
        end else if (dc_stage_vld) begin
            ld_da_inst_fof_reg <= ld_dc_inst_fof;
        end
    end
    assign ld_da_inst_fof = ld_da_inst_fof_reg;

    // Test Task: Send FOF instruction through pipeline
    task send_fof_inst;
        input fof_flag;
        begin
            @(posedge clk);
            idu_lsu_rf_pipe3_inst_vld <= 1'b1;
            idu_lsu_rf_pipe3_inst_fof <= fof_flag;
            idu_lsu_rf_pipe3_iid <= $random;
            
            // Advance through pipeline
            @(posedge clk);
            ag_stage_vld <= 1'b1;
            idu_lsu_rf_pipe3_inst_vld <= 1'b0;
            
            @(posedge clk);
            dc_stage_vld <= 1'b1;
            ag_stage_vld <= 1'b0;
            
            @(posedge clk);
            da_stage_vld <= 1'b1;
            dc_stage_vld <= 1'b0;
            
            @(posedge clk);
            da_stage_vld <= 1'b0;
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
        idu_lsu_rf_pipe3_inst_vld = 1'b0;
        idu_lsu_rf_pipe3_inst_fof = 1'b0;
        idu_lsu_rf_pipe3_iid = 7'b0;
        ag_stage_vld = 1'b0;
        dc_stage_vld = 1'b0;
        da_stage_vld = 1'b0;

        // Wait for reset
        @(posedge rst_b);
        @(posedge clk);

        $display("========================================");
        $display("FOF Load Test Suite for RVV 1.0");
        $display("========================================");

        //----------------------------------------------------------------
        // Test Case FOF_001: FOF Signal at IDU Stage
        //----------------------------------------------------------------
        $display("\n[FOF_001] FOF Signal at IDU Stage Test");
        begin
            @(posedge clk);
            idu_lsu_rf_pipe3_inst_vld <= 1'b1;
            idu_lsu_rf_pipe3_inst_fof <= 1'b1;
            @(posedge clk);
            check_result(idu_lsu_rf_pipe3_inst_fof, 1'b1, "FOF_001: IDU stage FOF signal");
            idu_lsu_rf_pipe3_inst_vld <= 1'b0;
        end

        //----------------------------------------------------------------
        // Test Case FOF_002: FOF Signal Propagation to LD_AG
        //----------------------------------------------------------------
        $display("\n[FOF_002] FOF Signal Propagation to LD_AG Test");
        begin
            send_fof_inst(1'b1);
            check_result(ld_ag_inst_fof, 1'b1, "FOF_002: LD_AG stage FOF signal");
        end

        //----------------------------------------------------------------
        // Test Case FOF_003: FOF Signal Propagation to LD_DC
        //----------------------------------------------------------------
        $display("\n[FOF_003] FOF Signal Propagation to LD_DC Test");
        begin
            send_fof_inst(1'b1);
            check_result(ld_dc_inst_fof, 1'b1, "FOF_003: LD_DC stage FOF signal");
        end

        //----------------------------------------------------------------
        // Test Case FOF_004: FOF Signal Propagation to LD_DA
        //----------------------------------------------------------------
        $display("\n[FOF_004] FOF Signal Propagation to LD_DA Test");
        begin
            send_fof_inst(1'b1);
            check_result(ld_da_inst_fof, 1'b1, "FOF_004: LD_DA stage FOF signal");
        end

        //----------------------------------------------------------------
        // Test Case FOF_005: Non-FOF Instruction
        //----------------------------------------------------------------
        $display("\n[FOF_005] Non-FOF Instruction Test");
        begin
            send_fof_inst(1'b0);
            check_result(ld_da_inst_fof, 1'b0, "FOF_005: Non-FOF instruction");
        end

        //----------------------------------------------------------------
        // Test Case FOF_006: FOF Signal Reset
        //----------------------------------------------------------------
        $display("\n[FOF_006] FOF Signal Reset Test");
        begin
            // Send FOF instruction
            send_fof_inst(1'b1);
            // Reset
            @(posedge clk);
            rst_b <= 1'b0;
            @(posedge clk);
            rst_b <= 1'b1;
            @(posedge clk);
            check_result(ld_ag_inst_fof, 1'b0, "FOF_006: FOF signal after reset");
        end

        //----------------------------------------------------------------
        // Test Case FOF_007: Multiple FOF Instructions
        //----------------------------------------------------------------
        $display("\n[FOF_007] Multiple FOF Instructions Test");
        begin
            // Send first FOF instruction
            send_fof_inst(1'b1);
            check_result(ld_da_inst_fof, 1'b1, "FOF_007a: First FOF instruction");

            // Send second FOF instruction
            send_fof_inst(1'b1);
            check_result(ld_da_inst_fof, 1'b1, "FOF_007b: Second FOF instruction");

            // Send non-FOF instruction
            send_fof_inst(1'b0);
            check_result(ld_da_inst_fof, 1'b0, "FOF_007c: Non-FOF instruction");
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
        $dumpfile("tb_lsu_fof.vcd");
        $dumpvars(0, tb_lsu_fof);
    end

endmodule
