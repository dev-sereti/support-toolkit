from rich.table import Table
from rich.console import Console
import argparse

def register_incident_commands(subparsers):
    """Add incident commands to CLI parser"""
    incident_parser = subparsers.add_parser('incident', help='Incident reporting')
    incident_sub = incident_parser.add_subparsers(dest='incident_command')
    
    # Report incident
    report_parser = incident_sub.add_parser('report', help='Report new incident')
    report_parser.add_argument('title', help='Incident title')
    report_parser.add_argument('description', help='Incident description')
    report_parser.add_argument('--severity', choices=['critical','high','medium','low'], 
                             default='medium')
    
    # List incidents
    list_parser = incident_sub.add_parser('list', help='List recent incidents')
    list_parser.add_argument('--days', type=int, default=7, 
                           help='Number of days to look back')
    list_parser.add_argument('--severity', choices=['critical','high','medium','low'],
                           help='Filter by severity level')

def handle_incident(args, reporter):
    """Process incident commands"""
    console = Console()
    
    if args.incident_command == 'report':
        result = reporter.log_incident(
            args.title,
            args.description,
            args.severity
        )
        console.print(f"[green]Incident logged:[/green] {result}")
        
    elif args.incident_command == 'list':
        report = reporter.generate_report(args.days, args.severity)
        table = Table(title=f"Incidents ({report['time_range']})")
        
        table.add_column("Timestamp", style="cyan")
        table.add_column("Title", style="magenta")
        table.add_column("Severity", style="red")
        table.add_column("Status")
        
        for incident in report['incidents']:
            table.add_row(
                incident['timestamp'],
                incident['title'],
                incident['severity'],
                incident['status']
            )
        
        console.print(table)