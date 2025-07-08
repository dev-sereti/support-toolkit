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

pull_logs() {
    if [ -z "$1" ]; then
        echo -e "${RED}Usage: $0 <user@host> [log_path]${NC}"
        return 1
    fi

    remote_host=$1
    log_path=${2:-"/var/log"}

    echo -e "${YELLOW}Pulling logs from $remote_host ($log_path)${NC}"
    
    # Create temp dir on remote host
    ssh "$remote_host" "mkdir -p $REMOTE_LOG_DIR"
    
    # Archive logs
    ssh "$remote_host" "tar czf $REMOTE_LOG_DIR/remote-logs-$(date +%Y%m%d).tar.gz $log_path 2>/dev/null"
    
    # Copy archive
    scp "$remote_host:$REMOTE_LOG_DIR/remote-logs-*.tar.gz" "$LOCAL_LOG_DIR/"
    
    # Cleanup
    ssh "$remote_host" "rm -rf $REMOTE_LOG_DIR"
    
    echo -e "${GREEN}Logs saved to $LOCAL_LOG_DIR/remote-logs-$(date +%Y%m%d).tar.gz${NC}"
}
