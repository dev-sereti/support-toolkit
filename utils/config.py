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
