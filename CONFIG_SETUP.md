# Configuration Setup

This project uses a configuration file to store Discord bot credentials and webhook URLs. 

## Setup Instructions

1. Copy `config.json` to `config.local.json`
2. Edit `config.local.json` with your actual values:
   - `bot_token`: Your Discord bot token
   - `guild_id`: Your Discord server ID
   - `channel_id`: Your Discord channel ID  
   - `keylogger_webhook`: Your Discord webhook URL
   - `payload_name`: Name for your payload executable

## Security Notes

- Never commit `config.local.json` or any files containing real credentials
- The `config.json` file contains placeholder values only
- Real credentials should only exist in your local `config.local.json` file
- Update build scripts to use `config.local.json` for actual deployments

## Example config.local.json

```json
{
    "payload_name": "my_payload",
    "guild_id": "123456789012345678",
    "bot_token": "your_actual_bot_token_here",
    "channel_id": "987654321098765432",
    "keylogger_webhook": "https://discord.com/api/webhooks/your_webhook_url"
}
```
