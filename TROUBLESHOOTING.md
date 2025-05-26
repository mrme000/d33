# Discord C2 Payload - Troubleshooting Guide

## Common Build Errors

### 1. "name 'YOUR_CHANNEL_ID' is not defined"

**Problem:** Placeholder replacement failed during build process.

**Solution:**
1. Use the **debug_build.bat** script to see what's happening:
   ```cmd
   debug_build.bat
   ```

2. Check if placeholders are being replaced correctly:
   ```cmd
   test_replacement.bat
   ```

3. Verify your configuration values are correct in the build script.

**Root Cause:** The PowerShell replacement commands may not be working correctly.

### 2. "UV not found" or "Python not found"

**Problem:** Missing prerequisites.

**Solution:**
1. Install Python 3.9+ from [python.org](https://python.org)
2. Install UV package manager:
   ```cmd
   powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
   ```

### 3. "Build failed" with PyInstaller errors

**Problem:** Dependency or compilation issues.

**Solutions:**
1. Run as Administrator
2. Add antivirus exclusion for project folder
3. Check Windows Defender real-time protection
4. Verify all dependencies are installed:
   ```cmd
   uv sync
   ```

### 4. "Bot failed to start" in debug mode

**Problem:** Discord bot configuration issues.

**Solutions:**
1. Verify bot token is valid
2. Check bot permissions in Discord server
3. Ensure channel ID exists and bot has access
4. Test with debug mode: `d3.exe -d`

## Debug Mode Troubleshooting

### Running Debug Mode

```cmd
d3.exe -d
```

### Expected Debug Output

```
============================================================
DEBUG MODE ENABLED
============================================================
Bot Token: MTM37NTkzNTQ5OTU0OTU0...
Guild ID: 1375935187250057216
Channel ID: 1375935188265209989
============================================================
[14:32:15] DEBUG: Starting payload in DEBUG MODE
[14:32:16] DEBUG: Sending debug hit to Discord server...
[14:32:17] DEBUG: Debug hit sent successfully!
[14:32:18] DEBUG: Bot connected successfully
```

### Debug Mode Issues

#### "Debug hit failed"
- Check bot token validity
- Verify channel permissions
- Ensure bot is in the correct server

#### "Bot failed to start"
- Invalid bot token
- Network connectivity issues
- Discord API rate limiting

#### "Channel not found"
- Wrong channel ID
- Bot lacks channel access
- Channel deleted or moved

## Build Script Issues

### PowerShell Execution Policy

If PowerShell commands fail:
```cmd
powershell -ExecutionPolicy Bypass -Command "Your command here"
```

### File Permissions

Run Command Prompt as Administrator if you get permission errors.

### Antivirus Interference

Add exclusions for:
- Project folder
- Python installation
- UV cache directory
- Temp directories

## Configuration Validation

### Test Configuration Replacement

```cmd
test_replacement.bat
```

Expected output:
```
✅ GUILD_ID converts to int: 1375935187250057216
✅ CHANNEL_ID converts to int: 1375935188265209989
✅ All configuration values are properly set!
```

### Manual Configuration Check

1. Open the generated Python file before compilation
2. Look for these lines:
   ```python
   GUILD_ID = "1375935187250057216"
   BOT_TOKEN = "MTM37NTkzNTQ5OTU0OTU0MDM3Mg..."
   CHANNEL_ID = "1375935188265209989"
   ```

3. Ensure no `{` or `}` characters remain

## Discord Bot Setup Issues

### Bot Token Problems

1. **Invalid Token:** Generate new token in Discord Developer Portal
2. **Expired Token:** Regenerate bot token
3. **Wrong Token:** Copy token exactly, no extra spaces

### Permission Issues

Required bot permissions:
- Send Messages
- Read Message History
- Use Slash Commands
- Attach Files
- Embed Links

### Server Setup

1. Bot must be invited to server with correct permissions
2. Channel must exist and be accessible to bot
3. Guild ID must match the server where bot is invited

## Network and Connectivity

### Firewall Issues

Ensure outbound HTTPS (443) is allowed for:
- discord.com
- discordapp.com
- Discord CDN domains

### Proxy/Corporate Networks

May need proxy configuration for Discord API access.

## Advanced Debugging

### Enable Verbose Logging

Use debug_build.bat for detailed build process logging.

### Manual Testing

1. Test configuration replacement:
   ```cmd
   test_replacement.bat
   ```

2. Test Python syntax:
   ```cmd
   python -m py_compile d3.py
   ```

3. Test Discord connectivity:
   ```cmd
   d3.exe -d
   ```

### Log Files

Debug mode creates:
- `debug.log` - Detailed operation logs
- Console output - Real-time status

## Getting Help

### Information to Provide

When reporting issues, include:
1. Windows version
2. Python version (`python --version`)
3. UV version (`uv --version`)
4. Complete error message
5. Build script used
6. Debug mode output (if applicable)

### Common Solutions Summary

1. **Build fails:** Run as Administrator, check antivirus
2. **Placeholders not replaced:** Use debug_build.bat
3. **Bot won't start:** Verify token and permissions
4. **No Discord message:** Check channel ID and bot access
5. **Syntax errors:** Verify configuration replacement

### Quick Fix Checklist

- ✅ Run as Administrator
- ✅ Disable antivirus temporarily
- ✅ Use debug_build.bat for verbose output
- ✅ Test with d3.exe -d
- ✅ Verify bot token and permissions
- ✅ Check Discord server setup
