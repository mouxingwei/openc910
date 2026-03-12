$jsFiles = Get-ChildItem -Path "d:\code\openc910\.trae\documents" -Filter "gen_*_docx.js"
$total = $jsFiles.Count
$success = 0
$failed = 0

Write-Host "Found $total JS files to process..."
Write-Host ""

foreach ($file in $jsFiles) {
    Write-Host "Processing: $($file.Name)"
    try {
        $output = & node $file.FullName 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Success: $output" -ForegroundColor Green
            $success++
        } else {
            Write-Host "  Failed: $output" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host "  Error: $_" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Summary:"
Write-Host "  Total: $total"
Write-Host "  Success: $success" -ForegroundColor Green
Write-Host "  Failed: $failed" -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })
