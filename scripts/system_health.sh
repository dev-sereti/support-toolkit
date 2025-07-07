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
