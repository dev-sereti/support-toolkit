#!/usr/bin/env python3
import argparse
from rich.console import Console
from rich.table import Table
from rich import print
import importlib
import sys
import os
from utils.logger import setup_logger
from utils.config import load_config

logger = setup_logger()
config = load_config()
console = Console()

def display_banner():
    banner = """
    [bold blue]
     _____ _____ ____  _____ _____ _   _ _______       _____ _   _ _______ _____ ____  _   _ 
    /  ___|  ___|  _ \|_   _|_   _| | | | | ___ \     |_   _| | | | | ___ \_   _/  _ \| \ | |
    \ `--.| |__ | |_) | | |   | | | | | | | |_/ /______ | | | | | | | |_/ / | | | | | |  \| |
     `--. \  __||  ___/  | |   | | | | | | | ___ \______| | | | | | |  __/  | | | | | | . ` |
    /\__/ / |___| |      | |  _| |_| |_| | | |_/ /      | | | |_| | | |    _| |_| |/ /| |\  |
    \____/\____/\_|      \_/  \___/ \___/\_|____/       \_/  \___/\_\_|    \___/ \___/ \_| \_/
    [/bold blue]
    """
    print(banner)
    print(f"[bold green]Support Automation Toolkit v1.0[/bold green]\n")
