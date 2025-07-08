#!/bin/bash

# Remote Support Tool

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REMOTE_LOG_DIR="/tmp/remote-support"
LOCAL_LOG_DIR="$HOME/remote-logs"

mkdir -p "$LOCAL_LOG_DIR"
