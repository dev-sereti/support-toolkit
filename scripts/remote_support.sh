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

remote_command() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}Usage: $0 <user@host> <command>${NC}"
        return 1
    fi

    echo -e "${YELLOW}Executing on $1: $2${NC}"
    ssh -t "$1" "$2"
}
