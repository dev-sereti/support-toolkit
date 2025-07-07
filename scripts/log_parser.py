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
