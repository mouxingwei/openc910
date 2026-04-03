# RVV 1.0 Test Makefile
# Created: 2026-04-02
# Description: Compile and run RVV 1.0 verification tests

# Paths
RTL_PATH = ../C910_RTL_FACTORY/gen_rtl _rvv1.0
TB_PATH = .
SIM_PATH = ./sim

# Simulation tool selection (iverilog, verilator, vcs)
SIM_TOOL ?= iverilog

# Test targets
TESTS = tb_cp0_vcsr tb_rtu_vtype tb_idu_vsetivli tb_lsu_fof tb_rvv1_0_basic

# Default target
all: $(TESTS)

# Create simulation directory
$(SIM_PATH):
	mkdir -p $(SIM_PATH)

# IVerilog compilation
iverilog: $(SIM_PATH)
	@echo "========================================"
	@echo "Compiling with IVerilog..."
	@echo "========================================"
	iverilog -g2012 -o $(SIM_PATH)/tb_cp0_vcsr \
		$(TB_PATH)/tb/cp0/tb_cp0_vcsr.v
	iverilog -g2012 -o $(SIM_PATH)/tb_rtu_vtype \
		$(TB_PATH)/tb/rtu/tb_rtu_vtype.v
	iverilog -g2012 -o $(SIM_PATH)/tb_idu_vsetivli \
		$(TB_PATH)/tb/idu/tb_idu_vsetivli.v
	iverilog -g2012 -o $(SIM_PATH)/tb_lsu_fof \
		$(TB_PATH)/tb/lsu/tb_lsu_fof.v
	iverilog -g2012 -o $(SIM_PATH)/tb_rvv1_0_basic \
		$(TB_PATH)/tb/full_chip/tb_rvv1_0_basic.v
	@echo "Compilation complete!"

# Run individual tests
tb_cp0_vcsr: iverilog
	@echo "========================================"
	@echo "Running VCSR Test..."
	@echo "========================================"
	vvp $(SIM_PATH)/tb_cp0_vcsr

tb_rtu_vtype: iverilog
	@echo "========================================"
	@echo "Running vtype Test..."
	@echo "========================================"
	vvp $(SIM_PATH)/tb_rtu_vtype

tb_idu_vsetivli: iverilog
	@echo "========================================"
	@echo "Running vsetivli Test..."
	@echo "========================================"
	vvp $(SIM_PATH)/tb_idu_vsetivli

tb_lsu_fof: iverilog
	@echo "========================================"
	@echo "Running FOF Test..."
	@echo "========================================"
	vvp $(SIM_PATH)/tb_lsu_fof

tb_rvv1_0_basic: iverilog
	@echo "========================================"
	@echo "Running Basic System Test..."
	@echo "========================================"
	vvp $(SIM_PATH)/tb_rvv1_0_basic

# Run all tests
run_all: iverilog
	@echo "========================================"
	@echo "Running All Tests..."
	@echo "========================================"
	@for test in $(TESTS); do \
		echo ""; \
		echo "Running $$test..."; \
		vvp $(SIM_PATH)/$$test; \
	done

# Verilator compilation
verilator: $(SIM_PATH)
	@echo "========================================"
	@echo "Compiling with Verilator..."
	@echo "========================================"
	verilator --cc --exe --build -j 0 \
		-o $(SIM_PATH)/tb_rvv1_0_basic \
		$(TB_PATH)/full_chip/tb_rvv1_0_basic.v
	@echo "Verilator compilation complete!"

# Clean
clean:
	rm -rf $(SIM_PATH)
	rm -f *.vcd
	rm -f *.log

# Help
help:
	@echo "RVV 1.0 Verification Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make              - Compile and run all tests"
	@echo "  make iverilog     - Compile with IVerilog"
	@echo "  make verilator    - Compile with Verilator"
	@echo "  make tb_cp0_vcsr  - Run VCSR test"
	@echo "  make tb_rtu_vtype - Run vtype test"
	@echo "  make tb_idu_vsetivli - Run vsetivli test"
	@echo "  make tb_lsu_fof   - Run FOF test"
	@echo "  make tb_rvv1_0_basic - Run basic system test"
	@echo "  make run_all      - Run all tests"
	@echo "  make clean        - Clean build files"
	@echo ""
	@echo "Simulation tool selection:"
	@echo "  make SIM_TOOL=iverilog  - Use IVerilog (default)"
	@echo "  make SIM_TOOL=verilator - Use Verilator"

.PHONY: all clean help iverilog verilator run_all $(TESTS)
