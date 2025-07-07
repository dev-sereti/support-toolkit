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

