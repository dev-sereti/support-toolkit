#!/bin/bash

# System Health Monitoring Script

THRESHOLDS_FILE="config/thresholds.conf"
LOG_DIR="/var/log/support-toolkit"
LOG_FILE="$LOG_DIR/system-health-$(date +%Y%m%d).log"

# Create log directory if not exists
mkdir -p "$LOG_DIR"

# Load thresholds
if [ -f "$THRESHOLDS_FILE" ]; then
    . "$THRESHOLDS_FILE"
else
    # Default thresholds if file doesn't exist
    CPU_WARNING=70
    CPU_CRITICAL=90
    MEM_WARNING=75
    MEM_CRITICAL=90
    DISK_WARNING=80
    DISK_CRITICAL=95
fi

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
cpu_usage=${cpu_usage%.*}  # Convert to integer

if [ "$cpu_usage" -gt "$CPU_CRITICAL" ]; then
    echo "[CRITICAL] CPU usage: ${cpu_usage}%"
elif [ "$cpu_usage" -gt "$CPU_WARNING" ]; then
    echo "[WARNING] CPU usage: ${cpu_usage}%"
else
    echo "[OK] CPU usage: ${cpu_usage}%"
fi

# Check Memory usage
mem_total=$(free -m | awk '/Mem:/ {print $2}')
mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_percent=$((mem_used * 100 / mem_total))

if [ "$mem_percent" -gt "$MEM_CRITICAL" ]; then
    echo "[CRITICAL] Memory usage: ${mem_percent}%"
elif [ "$mem_percent" -gt "$MEM_WARNING" ]; then
    echo "[WARNING] Memory usage: ${mem_percent}%"
else
    echo "[OK] Memory usage: ${mem_percent}%"
fi

# Check Disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$disk_usage" -gt "$DISK_CRITICAL" ]; then
    echo "[CRITICAL] Disk usage: ${disk_usage}%"
elif [ "$disk_usage" -gt "$DISK_WARNING" ]; then
    echo "[WARNING] Disk usage: ${disk_usage}%"
else
    echo "[OK] Disk usage: ${disk_usage}%"
fi

# System uptime
uptime

exit 0