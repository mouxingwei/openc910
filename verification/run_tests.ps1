# RVV 1.0 Test Run Script (PowerShell)
# Created: 2026-04-02
# Description: Compile and run RVV 1.0 verification tests
# Modified: 2026-04-03 - Added RTL-connected testbenches with real RTL modules

param(
    [string]$Test = "all",
    [string]$Tool = "iverilog",
    [string]$Mode = "basic"
)

$SIM_PATH = ".\sim"
$TB_PATH = "."
$RTL_PATH = "..\C910_RTL_FACTORY\gen_rtl _rvv1.0"

if (-not (Test-Path $SIM_PATH)) {
    New-Item -ItemType Directory -Path $SIM_PATH | Out-Null
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "RVV 1.0 Verification Test Suite" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tool: $Tool"
Write-Host "Test: $Test"
Write-Host "Mode: $Mode"
Write-Host ""

function Compile-Test {
    param(
        [string]$TestName,
        [string]$TestFile,
        [string[]]$IncludeFiles,
        [string[]]$RTLFiles
    )
    
    Write-Host "Compiling $TestName..." -ForegroundColor Yellow
    
    if ($Tool -eq "iverilog") {
        $compileCmd = "iverilog -g2012 -I `"$TB_PATH\tb`" -o `"$SIM_PATH\$TestName`""
        
        foreach ($inc in $IncludeFiles) {
            $compileCmd += " `"$inc`""
        }
        
        foreach ($rtl in $RTLFiles) {
            $compileCmd += " `"$rtl`""
        }
        
        $compileCmd += " `"$TB_PATH\$TestFile`""
        
        Write-Host "  Command: $compileCmd" -ForegroundColor Gray
        Invoke-Expression $compileCmd
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

$BasicTests = @(
    @{Name="tb_cp0_vcsr"; File="tb\cp0\tb_cp0_vcsr.v"},
    @{Name="tb_rtu_vtype"; File="tb\rtu\tb_rtu_vtype.v"},
    @{Name="tb_idu_vsetivli"; File="tb\idu\tb_idu_vsetivli.v"},
    @{Name="tb_lsu_fof"; File="tb\lsu\tb_lsu_fof.v"},
    @{Name="tb_rvv1_0_basic"; File="tb\full_chip\tb_rvv1_0_basic.v"}
)

$IDU_RTL_FILES = @(
    "$RTL_PATH\idu\rtl\ct_idu_id_decd.v",
    "$RTL_PATH\idu\rtl\ct_idu_id_decd_special.v"
)

$LSU_RTL_FILES = @(
    "$RTL_PATH\lsu\rtl\ct_lsu_ld_ag.v",
    "$RTL_PATH\lsu\rtl\ct_lsu_ld_dc.v",
    "$RTL_PATH\lsu\rtl\ct_lsu_ld_da.v"
)

$RTLTests = @(
    @{Name="tb_cp0_vcsr_rtl"; File="tb\cp0\tb_cp0_vcsr_rtl.v"; Includes=@("tb\rvv1_0_encoding.vh"); RTL=@()},
    @{Name="tb_rtu_vtype_rtl"; File="tb\rtu\tb_rtu_vtype_rtl.v"; Includes=@("tb\rvv1_0_encoding.vh"); RTL=@()},
    @{Name="tb_idu_vsetivli_rtl"; File="tb\idu\tb_idu_vsetivli_rtl.v"; Includes=@("tb\rvv1_0_encoding.vh"); RTL=$IDU_RTL_FILES},
    @{Name="tb_lsu_fof_rtl"; File="tb\lsu\tb_lsu_fof_rtl.v"; Includes=@("tb\rvv1_0_encoding.vh"); RTL=@()}
)

if ($Mode -eq "rtl") {
    $Tests = $RTLTests
} elseif ($Mode -eq "all") {
    $Tests = $BasicTests + $RTLTests
} else {
    $Tests = $BasicTests
}

if ($Test -eq "all") {
    $passCount = 0
    $failCount = 0
    
    foreach ($t in $Tests) {
        Write-Host ""
        Write-Host "----------------------------------------" -ForegroundColor Gray
        
        $includes = @()
        if ($t.Includes) {
            $includes = $t.Includes
        }
        
        $rtlFiles = @()
        if ($t.RTL) {
            $rtlFiles = $t.RTL
        }
        
        if (Compile-Test -TestName $t.Name -TestFile $t.File -IncludeFiles $includes -RTLFiles $rtlFiles) {
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
    $found = $false
    foreach ($t in $Tests) {
        if ($t.Name -eq $Test) {
            $found = $true
            $includes = @()
            if ($t.Includes) {
                $includes = $t.Includes
            }
            $rtlFiles = @()
            if ($t.RTL) {
                $rtlFiles = $t.RTL
            }
            if (Compile-Test -TestName $t.Name -TestFile $t.File -IncludeFiles $includes -RTLFiles $rtlFiles) {
                Run-Test -TestName $t.Name
            }
            break
        }
    }
    
    if (-not $found) {
        Write-Host "Unknown test: $Test" -ForegroundColor Red
        Write-Host "Available tests: all, $($Tests.Name -join ', ')"
        Write-Host ""
        Write-Host "Modes:" -ForegroundColor Yellow
        Write-Host "  -Mode basic  : Run basic behavioral tests"
        Write-Host "  -Mode rtl    : Run RTL-connected tests"
        Write-Host "  -Mode all    : Run all tests"
    }
}

Write-Host ""
Write-Host "Done."
