#!/usr/bin/env python3
import argparse
import re
from datetime import datetime, timedelta
from pathlib import Path
import gzip
import shutil
from utils.logger import setup_logger

logger = setup_logger()
log_dir = Path('/var/log')
archive_dir = Path('/var/log/archives')
archive_dir.mkdir(exist_ok=True)

CRITICAL_PATTERNS = {
    'auth': [
        r'Failed password',
        r'authentication failure',
        r'user NOT in sudoers',
        r'POSSIBLE BREAK-IN ATTEMPT'
    ],
    'syslog': [
        r'error',
        r'failed',
        r'critical',
        r'segmentation fault',
        r'out of memory'
    ],
    'dmesg': [
        r'kernel panic',
        r'hardware error',
        r'disk failure',
        r'CPU throttling'
    ]
}

def parse_log_file(log_file, show_critical=False):
    log_path = log_dir / log_file
    if not log_path.exists():
        print(f"Log file {log_path} not found")
        return
    
    critical_count = 0
    print(f"\nAnalyzing {log_path}...\n")
    
    with open(log_path, 'r') as f:
        for line in f:
            if show_critical:
                for pattern in CRITICAL_PATTERNS.get(log_file.name, []):
                    if re.search(pattern, line, re.IGNORECASE):
                        print(f"[CRITICAL] {line.strip()}")
                        critical_count += 1
                        break
            else:
                print(line.strip())
    
    if show_critical:
        print(f"\nFound {critical_count} critical events in {log_path}")

def archive_logs(days=30):
    cutoff_date = datetime.now() - timedelta(days=days)
    archived = 0
    
    for log_file in log_dir.glob('*.log'):
        if log_file.stat().st_mtime < cutoff_date.timestamp():
            archive_file = archive_dir / f"{log_file.name}-{datetime.now().strftime('%Y%m%d')}.gz"
            
            with open(log_file, 'rb') as f_in:
                with gzip.open(archive_file, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            
            log_file.unlink()
            archived += 1
            logger.info(f"Archived {log_file} to {archive_file}")
    
    print(f"Archived {archived} log files older than {days} days")

def main():
    parser = argparse.ArgumentParser(description='Log Parser Tool')
    parser.add_argument('--file', choices=['auth', 'syslog', 'dmesg'], 
                       help='Specify which log file to parse')
    parser.add_argument('--critical', action='store_true', 
                       help='Show only critical events')
    parser.add_argument('--archive', action='store_true', 
                       help='Archive logs older than 30 days')
    
    args = parser.parse_args()
    
    if args.archive:
        archive_logs()
    elif args.file:
        log_file = {
            'auth': 'auth.log',
            'syslog': 'syslog',
            'dmesg': 'dmesg'
        }[args.file]
        parse_log_file(Path(log_file), args.critical)
    else:
        print("Please specify a log file to parse with --file")

if __name__ == '__main__':
    main()