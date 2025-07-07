#!/bin/bash

# Support Toolkit Setup Script

echo "Installing Support Automation Toolkit..."

# Check Python version
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is required but not installed. Installing..."
    apt-get update && apt-get install -y python3
fi

# Check for required packages
REQUIRED_PKGS=("python3-pip" "nmap" "rsync" "cron" "gzip")
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! dpkg -s "$pkg" &> /dev/null; then
        echo "Installing $pkg..."
        apt-get install -y "$pkg"
    fi
done
 