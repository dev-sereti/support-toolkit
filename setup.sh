#!/bin/bash

# Updated Support Toolkit Setup Script

echo "Installing Support Automation Toolkit..."

# Create virtual environment if not exists
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate venv and install dependencies
source venv/bin/activate
pip install -r requirements.txt

# Create directories
mkdir -p /var/log/support-toolkit
sudo chown $USER /var/log/support-toolkit  # Avoid sudo for logging

# Make scripts executable
chmod +x scripts/*.sh

# Create symlink for easy access
ln -sf "$(pwd)/main.py" "$(pwd)/support-toolkit"
chmod +x support-toolkit

echo "Installation complete. Run './support-toolkit' to start."
echo "Always activate virtual environment first: source venv/bin/activate"