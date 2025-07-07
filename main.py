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

def main():
    display_banner()
    
    parser = argparse.ArgumentParser(description='Support Automation Toolkit')
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # System Health
    health_parser = subparsers.add_parser('health', help='System health monitoring')
    health_parser.add_argument('--thresholds', action='store_true', help='Show current threshold values')
    health_parser.add_argument('--set-thresholds', type=str, help='Set thresholds (cpu=80,mem=90,disk=85)')
    
    # User Management
    user_parser = subparsers.add_parser('users', help='User management tools')
    user_subparsers = user_parser.add_subparsers(dest='user_command')
    
    list_parser = user_subparsers.add_parser('list', help='List users')
    list_parser.add_argument('--active', action='store_true', help='Show only active users')
    list_parser.add_argument('--inactive', action='store_true', help='Show only inactive users')
    
    modify_parser = user_subparsers.add_parser('modify', help='Modify user')
    modify_parser.add_argument('username', help='Username to modify')
    modify_parser.add_argument('--lock', action='store_true', help='Lock user account')
    modify_parser.add_argument('--unlock', action='store_true', help='Unlock user account')
    modify_parser.add_argument('--reset-password', action='store_true', help='Reset user password')
    
    # Log Management
    log_parser = subparsers.add_parser('logs', help='Log management')
    log_parser.add_argument('--parse', choices=['auth', 'syslog', 'dmesg'], help='Parse specific log file')
    log_parser.add_argument('--critical', action='store_true', help='Show only critical events')
    log_parser.add_argument('--archive', action='store_true', help='Archive logs')
    
    # Add other command parsers...
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    try:
        if args.command == 'health':
            handle_health(args)
        elif args.command == 'users':
            handle_users(args)
        elif args.command == 'logs':
            handle_logs(args)
        # Add other command handlers...
    except Exception as e:
        logger.error(f"Command failed: {str(e)}")
        console.print(f"[bold red]Error:[/bold red] {str(e)}")

def handle_health(args):
    """Handle system health commands"""
    if args.thresholds:
        from utils.config import get_thresholds
        thresholds = get_thresholds()
        table = Table(title="System Thresholds")
        table.add_column("Metric", style="cyan")
        table.add_column("Warning", style="magenta")
        table.add_column("Critical", style="red")
        
        for metric, values in thresholds.items():
            table.add_row(metric.upper(), str(values['warning']), str(values['critical']))
        
        console.print(table)
    elif args.set_thresholds:
        from utils.config import set_thresholds
        set_thresholds(args.set_thresholds)
    else:
        os.system('./scripts/system_health.sh')
