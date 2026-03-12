@echo off
cd /d d:\code\openc910\.trae\documents
echo Starting docx generation...
set count=0
for %%f in (gen_*_docx.js) do (
    set /a count+=1
    echo [!count!] Processing: %%f
    node "%%f" 2>nul
    if !errorlevel! equ 0 (
        echo     Success
    ) else (
        echo     Failed
    )
)
echo.
echo Total processed: %count% files
echo Done!
