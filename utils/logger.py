import logging
import os
from pathlib import Path
from datetime import datetime

LOG_DIR = Path('/var/log/support-toolkit')
LOG_FILE = LOG_DIR / 'toolkit.log'

def setup_logger(name='support-toolkit'):
    # Create log directory if it doesn't exist
    LOG_DIR.mkdir(mode=0o755, parents=True, exist_ok=True)
    
    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)
    
    # File handler
    file_handler = logging.FileHandler(LOG_FILE)
    file_handler.setLevel(logging.DEBUG)
    file_formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(file_formatter)
    
    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    console_formatter = logging.Formatter('%(levelname)s - %(message)s')
    console_handler.setFormatter(console_formatter)
    
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)
    
    return logger
