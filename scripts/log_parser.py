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
