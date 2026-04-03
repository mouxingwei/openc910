# RVV 1.0 Verification Test Suite

## Overview

This directory contains verification testbenches for the RVV 1.0 upgrade modifications to OpenC910.

## Directory Structure

```
verification/
├── tb/
│   ├── cp0/
│   │   └── tb_cp0_vcsr.v          # VCSR register tests
│   ├── rtu/
│   │   └── tb_rtu_vtype.v         # vtype field extension tests
│   ├── idu/
│   │   └── tb_idu_vsetivli.v      # vsetivli instruction decode tests
│   ├── lsu/
│   │   └── tb_lsu_fof.v           # FOF load signal tests
│   └── full_chip/
│       └── tb_rvv1_0_basic.v      # System-level basic tests
├── tests/                          # Test programs (assembly)
├── Makefile                        # Make build script
├── run_tests.ps1                   # PowerShell run script
└── README.md                       # This file
```

## Prerequisites

### Simulation Tools

- **IVerilog**: Icarus Verilog (recommended for basic tests)
  - Install: `apt install iverilog` (Linux) or download from http://bleyer.org/icarus/

- **Verilator**: Fast simulator
  - Install: `apt install verilator` or from https://www.verilator.org/

### Waveform Viewer (Optional)

- **GTKWave**: For viewing VCD waveforms
- **Verdi**: For advanced waveform analysis

## Running Tests

### Using Make (Linux/WSL)

```bash
# Run all tests
make

# Run specific test
make tb_cp0_vcsr

# Clean build files
make clean

# Show help
make help
```

### Using PowerShell (Windows)

```powershell
# Run all tests
.\run_tests.ps1

# Run specific test
.\run_tests.ps1 -Test tb_cp0_vcsr

# Use Verilator instead
.\run_tests.ps1 -Tool verilator
```

## Test Descriptions

### 1. VCSR Register Test (tb_cp0_vcsr.v)

Tests the VCSR register functionality:
- VCSR read/write operations
- VCSR synchronization with VXSAT and VXRM
- VCSR mirror behavior

**Test Cases:**
| ID | Description |
|----|-------------|
| VCSR_001 | VCSR read operation |
| VCSR_002 | VCSR write operation |
| VCSR_003 | VCSR and VXSAT synchronization |
| VCSR_004 | VCSR and VXRM synchronization |

### 2. vtype Field Test (tb_rtu_vtype.v)

Tests the vtype field extensions:
- vlmul field extension to 3 bits
- vma field setting
- vta field setting
- Fractional LMUL support (1/8, 1/4, 1/2)

**Test Cases:**
| ID | Description |
|----|-------------|
| VTYPE_001 | vlmul = 5 (LMUL = 1/8) |
| VTYPE_002 | vlmul = 6 (LMUL = 1/4) |
| VTYPE_003 | vlmul = 7 (LMUL = 1/2) |
| VTYPE_004 | vma field setting |
| VTYPE_005 | vta field setting |

### 3. vsetivli Instruction Test (tb_idu_vsetivli.v)

Tests the vsetivli instruction decoding:
- Basic vsetivli decode
- Different AVL values
- Different SEW values
- Fractional LMUL encoding
- vma/vta encoding

**Test Cases:**
| ID | Description |
|----|-------------|
| VSETIVLI_001 | Basic vsetivli decode |
| VSETIVLI_002 | Different AVL values |
| VSETIVLI_003 | LMUL = 1/8 encoding |
| VSETIVLI_004 | LMUL = 1/4 encoding |
| VSETIVLI_005 | LMUL = 1/2 encoding |

### 4. FOF Load Test (tb_lsu_fof.v)

Tests the Fault-Only-First load signal propagation:
- FOF signal at IDU stage
- FOF signal propagation through pipeline stages
- FOF signal reset behavior

**Test Cases:**
| ID | Description |
|----|-------------|
| FOF_001 | FOF signal at IDU stage |
| FOF_002 | FOF signal propagation to LD_AG |
| FOF_003 | FOF signal propagation to LD_DC |
| FOF_004 | FOF signal propagation to LD_DA |

### 5. Basic System Test (tb_rvv1_0_basic.v)

System-level integration test:
- VCSR register tests
- vtype field tests
- vsetivli instruction tests
- Approximate compute instruction tests
- FOF load tests
- Exception handling tests
- Fractional LMUL tests

## Coverage Goals

| Coverage Type | Target |
|--------------|--------|
| Code Coverage | ≥ 95% |
| Functional Coverage | ≥ 90% |
| Assertion Coverage | ≥ 95% |

## Adding New Tests

1. Create test file in appropriate subdirectory under `tb/`
2. Follow naming convention: `tb_<module>_<feature>.v`
3. Include test counters and pass/fail reporting
4. Add waveform dump for debugging
5. Update Makefile and run_tests.ps1

## Debugging

### Viewing Waveforms

```bash
# Generate VCD during test (automatic)
# View with GTKWave
gtkwave tb_cp0_vcsr.vcd
```

### Common Issues

1. **Compilation Error**: Check IVerilog/Verilator installation
2. **Test Timeout**: Increase timeout in testbench
3. **Unexpected Failures**: Check waveform for signal timing

## Reference Documents

- [RVV 1.0 Upgrade Plan](../../doc/modify_plan/RVV_0.7.1_to_1.0_升级计划.md)
- [RVV 1.0 Modification Log](../../doc/modify_plan/RVV_1.0_修改记录.md)
- [RISC-V Vector Extension Specification v1.0](https://github.com/riscv/riscv-v-spec)

## Contact

For questions or issues, please refer to the main project documentation.
