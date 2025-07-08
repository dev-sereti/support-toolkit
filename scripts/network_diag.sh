#!/bin/bash

# Network Diagnostics Tool

echo -e "\n[NETWORK DIAGNOSTICS]"

# 1. Check Internet Connection
echo -e "\n➤ Internet Connection:"
if ping -c 3 8.8.8.8 &> /dev/null; then
    echo "✅ Internet connection is active"
    
    # Get public IP
    public_ip=$(curl -s ifconfig.me)
    echo "🌐 Public IP: $public_ip"
    
    # Check DNS resolution
    if nslookup google.com &> /dev/null; then
        echo "🔗 DNS resolution working"
    else
        echo "❌ DNS resolution failing"
    fi
else
    echo "❌ No internet connection"
fi

