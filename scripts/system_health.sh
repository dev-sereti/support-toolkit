# System Health Monitoring Script

THRESHOLDS_FILE="/etc/support-toolkit/thresholds.conf"
LOG_DIR="/var/log/support-toolkit"
LOG_FILE="$LOG_DIR/system-health-$(date +%Y%m%d).log"

# Load thresholds
source $THRESHOLDS_FILE

# Check CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
if (( $(echo "$cpu_usage > $CPU_CRITICAL" | bc -l) )); then
    echo "[CRITICAL] CPU usage: $cpu_usage%" | tee -a $LOG_FILE
elif (( $(echo "$cpu_usage > $CPU_WARNING" | bc -l) )); then
    echo "[WARNING] CPU usage: $cpu_usage%" | tee -a $LOG_FILE
else
    echo "[OK] CPU usage: $cpu_usage%" | tee -a $LOG_FILE
fi

# Check Memory usage
mem_total=$(free -m | awk '/Mem:/ {print $2}')
mem_used=$(free -m | awk '/Mem:/ {print $3}')
mem_percent=$((mem_used * 100 / mem_total))

if (( mem_percent > MEM_CRITICAL )); then
    echo "[CRITICAL] Memory usage: $mem_percent%" | tee -a $LOG_FILE
elif (( mem_percent > MEM_WARNING )); then
    echo "[WARNING] Memory usage: $mem_percent%" | tee -a $LOG_FILE
else
    echo "[OK] Memory usage: $mem_percent%" | tee -a $LOG_FILE
fi

# Check Disk usage
disk_usage=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
if (( disk_usage > DISK_CRITICAL )); then
    echo "[CRITICAL] Disk usage: $disk_usage%" | tee -a $LOG_FILE
elif (( disk_usage > DISK_WARNING )); then
    echo "[WARNING] Disk usage: $disk_usage%" | tee -a $LOG_FILE
else
    echo "[OK] Disk usage: $disk_usage%" | tee -a $LOG_FILE
fi

# System uptime
uptime | tee -a $LOG_FILE

exit 0