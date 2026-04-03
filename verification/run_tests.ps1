# RVV 1.0 Test Run Script (PowerShell)
# Created: 2026-04-02
# Description: Compile and run RVV 1.0 verification tests

param(
    [string]$Test = "all",
    [string]$Tool = "iverilog"
)

$SIM_PATH = ".\sim"
$TB_PATH = "."

# Create simulation directory
if (-not (Test-Path $SIM_PATH)) {
    New-Item -ItemType Directory -Path $SIM_PATH | Out-Null
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RVV 1.0 Verification Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tool: $Tool"
Write-Host "Test: $Test"
Write-Host ""

function Compile-Test {
    param([string]$TestName, [string]$TestFile)
    
    Write-Host "Compiling $TestName..." -ForegroundColor Yellow
    
    if ($Tool -eq "iverilog") {
        iverilog -g2012 -o "$SIM_PATH\$TestName" "$TB_PATH\$TestFile"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Compilation successful" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  Compilation failed" -ForegroundColor Red
            return $false
        }
    } elseif ($Tool -eq "verilator") {
        verilator --cc --exe --build -j 0 -o "$SIM_PATH\$TestName" "$TB_PATH\$TestFile"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Compilation successful" -ForegroundColor Green
            return $true
        } else {
            Write-Host "  Compilation failed" -ForegroundColor Red
            return $false
        }
    }
    return $false
}

function Run-Test {
    param([string]$TestName)
    
    Write-Host "Running $TestName..." -ForegroundColor Yellow
    
    if ($Tool -eq "iverilog") {
        vvp "$SIM_PATH\$TestName"
    } elseif ($Tool -eq "verilator") {
        & "$SIM_PATH\$TestName"
    }
}

# Test definitions
$Tests = @(
    @{Name="tb_cp0_vcsr"; File="tb\cp0\tb_cp0_vcsr.v"},
    @{Name="tb_rtu_vtype"; File="tb\rtu\tb_rtu_vtype.v"},
    @{Name="tb_idu_vsetivli"; File="tb\idu\tb_idu_vsetivli.v"},
    @{Name="tb_lsu_fof"; File="tb\lsu\tb_lsu_fof.v"},
    @{Name="tb_rvv1_0_basic"; File="tb\full_chip\tb_rvv1_0_basic.v"}
)

# Run tests
if ($Test -eq "all") {
    $passCount = 0
    $failCount = 0
    
    foreach ($t in $Tests) {
        Write-Host ""
        Write-Host "----------------------------------------" -ForegroundColor Gray
        
        if (Compile-Test -TestName $t.Name -TestFile $t.File) {
            Run-Test -TestName $t.Name
            if ($LASTEXITCODE -eq 0) {
                $passCount++
            } else {
                $failCount++
            }
        } else {
            $failCount++
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Test Summary" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "Passed: $passCount" -ForegroundColor Green
    Write-Host "Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) {"Red"} else {"Green"})
    
} else {
    # Run specific test
    $found = $false
    foreach ($t in $Tests) {
        if ($t.Name -eq $Test) {
            $found = $true
            if (Compile-Test -TestName $t.Name -TestFile $t.File) {
                Run-Test -TestName $t.Name
            }
            break
        }
    }
    
    if (-not $found) {
        Write-Host "Unknown test: $Test" -ForegroundColor Red
        Write-Host "Available tests: all, $($Tests.Name -join ', ')"
    }
}

Write-Host ""
Write-Host "Done."
