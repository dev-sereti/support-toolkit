# System Health Monitoring Script

THRESHOLDS_FILE="/etc/support-toolkit/thresholds.conf"
LOG_DIR="/var/log/support-toolkit"
LOG_FILE="$LOG_DIR/system-health-$(date +%Y%m%d).log"

# Load thresholds
source $THRESHOLDS_FILE
