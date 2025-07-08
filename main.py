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
    banner = r"""
    [bold blue]
███████╗██╗   ██╗██████╗ ██████╗  ██████╗ ██████╗ ████████╗    ████████╗ ██████╗  ██████╗ ██╗  ██╗██╗████████╗
██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗██╔══██╗╚══██╔══╝    ╚══██╔══╝██╔═══██╗██╔═══██╗██║ ██╔╝██║╚══██╔══╝
███████╗██║   ██║██████╔╝██████╔╝██║   ██║██████╔╝   ██║          ██║   ██║   ██║██║   ██║█████╔╝ ██║   ██║   
╚════██║██║   ██║██╔═══╝ ██╔═══╝ ██║   ██║██╔═══╝    ██║          ██║   ██║   ██║██║   ██║██╔═██╗ ██║   ██║   
███████║╚██████╔╝██║     ██║     ╚██████╔╝██║        ██║          ██║   ╚██████╔╝╚██████╔╝██║  ██╗██║   ██║   
╚══════╝ ╚═════╝ ╚═╝     ╚═╝      ╚═════╝ ╚═╝        ╚═╝          ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝   
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
    
    # Network Diagnostics
    network_parser = subparsers.add_parser('network', help='Network diagnostics')
    network_parser.add_argument('--speedtest', action='store_true', help='Run internet speed test')
    network_parser.add_argument('--ports', action='store_true', help='Show open ports only')
    network_parser.add_argument('--interfaces', action='store_true', help='Show network interfaces only')
    
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
        elif args.command == 'network':
            handle_network(args)
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

def handle_users(args):
    """Handle user management commands"""
    if hasattr(args, 'user_command'):
        if args.user_command == 'list':
            cmd = './scripts/user_mgmt.sh list'
            if args.active:
                cmd += ' --active'
            elif args.inactive:
                cmd += ' --inactive'
            os.system(cmd)
        elif args.user_command == 'modify':
            cmd = f'./scripts/user_mgmt.sh modify {args.username}'
            if args.lock:
                cmd += ' --lock'
            elif args.unlock:
                cmd += ' --unlock'
            elif args.reset_password:
                cmd += ' --reset-password'
            os.system(cmd)
    else:
        os.system('./scripts/user_mgmt.sh')

def handle_logs(args):
    """Handle log management commands"""
    if args.parse:
        os.system(f'python3 scripts/log_parser.py --file {args.parse}' + (' --critical' if args.critical else ''))
    elif args.archive:
        os.system('./scripts/log_parser.py --archive')
    else:
        os.system('python3 scripts/log_parser.py')

def handle_network(args):
    """Handle network diagnostics commands"""
    cmd = './scripts/network_diag.sh'
    if args.speedtest:
        cmd += ' --speedtest'
    elif args.ports:
        cmd += ' --ports'
    elif args.interfaces:
        cmd += ' --interfaces'
    os.system(cmd)

if __name__ == '__main__':
    main()