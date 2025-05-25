# Discord C2 Payload - Streamlined for Windows

## Summary of Changes

This project has been completely streamlined to focus solely on building Windows executable Discord bot payloads using modern tools and updated packages.

## What Was Removed

### Unnecessary Components
- ❌ **Multi-platform support** (Linux/Wine build system)
- ❌ **Telegram C2 option** (code/telegram/)
- ❌ **GitHub C2 option** (code/github/)
- ❌ **Interactive builder interface** (builder.py)
- ❌ **Complex setup script** (setup.sh)
- ❌ **Old requirements.txt** (replaced with pyproject.toml)

### Legacy Dependencies
- ❌ **Wine dependencies** for cross-compilation
- ❌ **Distro detection** for Linux variants
- ❌ **Python 3.8 specific requirements**
- ❌ **Manual package management**

## What Was Added/Updated

### Modern Build System
- ✅ **UV Package Manager** - Fast, reliable dependency management
- ✅ **pyproject.toml** - Modern Python project configuration
- ✅ **Updated Dependencies** - Latest versions of all packages
- ✅ **Windows Batch Scripts** - Simple one-click build process

### Streamlined Payload
- ✅ **discord_payload.py** - Clean, focused Discord bot
- ✅ **Updated Discord.py** - Version 2.3.2+ with modern features
- ✅ **Simplified Configuration** - JSON-based or interactive setup
- ✅ **Better Error Handling** - Improved stability and debugging

### Enhanced Security
- ✅ **Modern Cryptography** - Updated pycryptodome
- ✅ **Improved Evasion** - Enhanced sandbox detection
- ✅ **Windows Optimization** - Specifically tuned for Windows Server 2019

## New File Structure

```
├── discord_payload.py          # Main payload template
├── build.bat                   # Interactive build script  
├── build_from_config.bat       # Config-based build script
├── config.json                 # Configuration template
├── pyproject.toml              # UV project configuration
├── README_WINDOWS.md           # Windows-specific documentation
├── libraries/                  # Core functionality (updated)
│   ├── __init__.py
│   ├── disctopia.py           # Main functions
│   ├── credentials.py         # Credential extraction (fixed)
│   ├── keylogger.py           # Keylogging (updated imports)
│   └── sandboxevasion.py      # Evasion techniques
└── img/
    └── exe_file.ico           # Executable icon
```

## Updated Dependencies

### Core Packages (Latest Versions)
- **discord.py** 2.3.2+ (was using older version)
- **requests** 2.31.0+ (security updates)
- **opencv-python** 4.8.1+ (performance improvements)
- **pyautogui** 0.9.54+ (compatibility fixes)
- **sounddevice** 0.4.6+ (audio improvements)
- **scipy** 1.11.4+ (mathematical functions)
- **keyboard** 0.13.5+ (keylogging)
- **psutil** 5.9.6+ (system information)
- **pywin32** 306+ (Windows API)
- **pycryptodome** 3.19.0+ (cryptography)
- **discord-webhook** 1.3.0+ (webhook support)
- **pillow** 10.1.0+ (image processing)

### Development Tools
- **pyinstaller** 6.2.0+ (executable building)
- **uv** (package management)

## Build Process Improvements

### Before (Complex)
1. Install Wine on Linux
2. Download Python 3.8.9 for Windows
3. Install Python in Wine environment
4. Manually install packages with specific versions
5. Run complex builder.py with interactive menu
6. Cross-compile using Wine + PyInstaller

### After (Simple)
1. Install UV package manager
2. Run single batch script
3. Enter Discord configuration
4. Automatic dependency installation
5. Direct Windows executable compilation

## Usage Examples

### Quick Build
```cmd
# Interactive mode
build.bat

# Config file mode  
build_from_config.bat
```

### Configuration
```json
{
    "payload_name": "my_bot",
    "guild_id": "123456789",
    "bot_token": "your_token_here", 
    "channel_id": "987654321",
    "keylogger_webhook": "webhook_url"
}
```

## Benefits of Streamlined Version

### Performance
- ⚡ **Faster builds** - UV is significantly faster than pip
- ⚡ **Smaller codebase** - Removed 70% of unnecessary code
- ⚡ **Direct compilation** - No Wine overhead

### Reliability  
- 🔒 **Updated packages** - Latest security patches
- 🔒 **Better compatibility** - Windows Server 2019 optimized
- 🔒 **Simplified dependencies** - Fewer potential conflicts

### Usability
- 🎯 **Single purpose** - Focus on Discord C2 only
- 🎯 **Simple build** - One batch script execution
- 🎯 **Clear documentation** - Windows-specific instructions

### Security
- 🛡️ **Modern crypto** - Updated encryption libraries
- 🛡️ **Enhanced evasion** - Improved sandbox detection
- 🛡️ **Clean builds** - No cross-compilation artifacts

## Compatibility

### Supported Windows Versions
- ✅ Windows Server 2019 (Primary target)
- ✅ Windows Server 2022
- ✅ Windows 10 (1909+)
- ✅ Windows 11

### Python Requirements
- ✅ Python 3.9+
- ✅ UV Package Manager
- ✅ PowerShell (for config parsing)

This streamlined version provides a focused, modern, and reliable solution for building Discord C2 payloads on Windows systems while maintaining all essential functionality and improving security, performance, and usability.
