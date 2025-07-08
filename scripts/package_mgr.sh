#!/bin/bash

# Package Management Tool

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error: This script must be run as root${NC}"
    exit 1
fi

# Function to update package lists
update_packages() {
    echo -e "${YELLOW}Updating package lists...${NC}"
    apt-get update
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Package lists updated successfully${NC}"
    else
        echo -e "${RED}Failed to update package lists${NC}"
        exit 1
    fi
}

# Function to upgrade all packages
upgrade_system() {
    echo -e "${YELLOW}Upgrading installed packages...${NC}"
    apt-get upgrade -y
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}System upgraded successfully${NC}"
    else
        echo -e "${RED}Failed to upgrade system${NC}"
        exit 1
    fi
}

# Function to install security updates
security_updates() {
    echo -e "${YELLOW}Checking for security updates...${NC}"
    apt-get upgrade --only-upgrade -y $(apt-get upgrade --dry-run | grep "^Inst" | grep -i security | awk '{print $2}')
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Security updates applied successfully${NC}"
    else
        echo -e "${RED}No security updates available or failed to apply${NC}"
    fi
}
