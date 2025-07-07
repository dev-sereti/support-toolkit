import configparser
from pathlib import Path
import os

CONFIG_DIR = Path('/etc/support-toolkit')
CONFIG_FILE = CONFIG_DIR / 'config.ini'
THRESHOLDS_FILE = CONFIG_DIR / 'thresholds.conf'

DEFAULT_CONFIG = {
    'DEFAULT': {
        'backup_dir': '/var/backups',
        'retention_days': '30',
        'notification_email': 'devsereti@gmail.com.com',
        'telegram_webhook': ''
    }
}

DEFAULT_THRESHOLDS = {
    'CPU_WARNING': '70',
    'CPU_CRITICAL': '90',
    'MEM_WARNING': '75',
    'MEM_CRITICAL': '90',
    'DISK_WARNING': '80',
    'DISK_CRITICAL': '95'
}
def load_config():
    """Load or create configuration"""
    if not CONFIG_DIR.exists():
        CONFIG_DIR.mkdir(mode=0o755, parents=True)
    
    if not CONFIG_FILE.exists():
        with open(CONFIG_FILE, 'w') as f:
            config = configparser.ConfigParser()
            config.read_dict(DEFAULT_CONFIG)
            config.write(f)
    
    if not THRESHOLDS_FILE.exists():
        with open(THRESHOLDS_FILE, 'w') as f:
            for key, value in DEFAULT_THRESHOLDS.items():
                f.write(f"{key}={value}\n")
    
    config = configparser.ConfigParser()
    config.read(CONFIG_FILE)
    
    return config

def get_thresholds():
    """Get current threshold values"""
    thresholds = {}
    with open(THRESHOLDS_FILE, 'r') as f:
        for line in f:
            if '=' in line:
                key, value = line.strip().split('=')
                thresholds[key] = value
    
    return thresholds
def set_thresholds(threshold_str):
    """Update threshold values"""
    updates = {}
    for item in threshold_str.split(','):
        key, value = item.split('=')
        updates[key.upper()] = value
    
    # Read current thresholds
    with open(THRESHOLDS_FILE, 'r') as f:
        lines = f.readlines()
    
    # Update values
    new_lines = []
    for line in lines:
        if '=' in line:
            key = line.split('=')[0]
            if key in updates:
                new_lines.append(f"{key}={updates[key]}\n")
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)
    
    # Write back
    with open(THRESHOLDS_FILE, 'w') as f:
        f.writelines(new_lines)
    
    print("Thresholds updated successfully")