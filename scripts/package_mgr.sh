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

# Function to clean up orphaned packages
clean_orphans() {
    echo -e "${YELLOW}Cleaning up orphaned packages...${NC}"
    apt-get autoremove -y
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Orphaned packages cleaned successfully${NC}"
    else
        echo -e "${RED}Failed to clean orphaned packages${NC}"
    fi
}

# Function to check for available updates
check_updates() {
    echo -e "${YELLOW}Checking for available updates...${NC}"
    updates=$(apt-get upgrade -s | grep "^Inst")
    if [ -z "$updates" ]; then
        echo -e "${GREEN}System is up to date${NC}"
    else
        echo -e "${YELLOW}Available updates:${NC}"
        echo "$updates"
    fi
}

# Function to search for a package
search_package() {
    if [ -z "$1" ]; then
        echo -e "${RED}Please specify a package name to search${NC}"
        exit 1
    fi
    echo -e "${YELLOW}Searching for package: $1${NC}"
    apt-cache search "$1"
}

# Main menu
case "$1" in
    update)
        update_packages
        ;;
    upgrade)
        update_packages
        upgrade_system
        ;;
    security)
        security_updates
        ;;
    clean)
        clean_orphans
        ;;
    check)
        check_updates
        ;;
    search)
        search_package "$2"
        ;;
    *)
        echo -e "${YELLOW}Usage: $0 {update|upgrade|security|clean|check|search <package>}${NC}"
        echo -e "Options:"
        echo -e "  update      - Update package lists"
        echo -e "  upgrade     - Upgrade all packages"
        echo -e "  security    - Install security updates only"
        echo -e "  clean       - Remove orphaned packages"
        echo -e "  check       - Check for available updates"
        echo -e "  search      - Search for a package"
        exit 1
        ;;
esac

exit 0