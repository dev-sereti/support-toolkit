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

# 2. Display Current Network Connections
echo -e "\n➤ Active Network Interfaces:"
echo "---------------------------------"
ip -br -c addr show | awk '{print "📶 " $1 " | IP: " $3 " | Status: " $2}'

# 3. Current WiFi Connection (if available)
echo -e "\n➤ WiFi Connection:"
if command -v nmcli &> /dev/null; then
    wifi_info=$(nmcli -t -f active,ssid,bssid,signal dev wifi | grep '^yes')
    if [ -n "$wifi_info" ]; then
        IFS=':' read -r _ ssid bssid signal <<< "$wifi_info"
        echo "📡 Connected to: $ssid"
        echo "🔌 BSSID: $bssid"
        echo "📶 Signal Strength: $signal%"
    else
        echo "❌ Not connected to WiFi"
    fi
else
    echo "ℹ️ nmcli not available - cannot detect WiFi details"
fi

# 4. Network Speed Test (if speedtest-cli is available)
echo -e "\n➤ Network Speed:"
if command -v speedtest-cli &> /dev/null; then
    echo "Running speed test (this may take 30 seconds)..."
    speedtest-cli --simple
else
    echo "ℹ️ Install speedtest-cli for speed tests:"
    echo "  sudo apt install speedtest-cli"
fi

# 5. Open Ports Check
echo -e "\n➤ Listening Ports:"
echo "---------------------------------"
ss -tulnp | awk 'NR>1 {print "🔘 " $1 " | Port: " $5 " | Process: " $7}'

exit 0