#!/bin/bash

# Service Controller

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SERVICE_LOG="/var/log/service-ctl.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$SERVICE_LOG"
}

service_action() {
    service=$1
    action=$2
    
    case $action in
        start)
            systemctl start "$service"
            status=$?
            [ $status -eq 0 ] && log "Started $service" || log "Failed to start $service"
            ;;
        stop)
            systemctl stop "$service"
            status=$?
            [ $status -eq 0 ] && log "Stopped $service" || log "Failed to stop $service"
            ;;
        restart)
            systemctl restart "$service"
            status=$?
            [ $status -eq 0 ] && log "Restarted $service" || log "Failed to restart $service"
            ;;
        status)
            systemctl status "$service" --no-pager
            return $?
            ;;
        enable)
            systemctl enable "$service"
            status=$?
            [ $status -eq 0 ] && log "Enabled $service" || log "Failed to enable $service"
            ;;
        disable)
            systemctl disable "$service"
            status=$?
            [ $status -eq 0 ] && log "Disabled $service" || log "Failed to disable $service"
            ;;
        *)
            echo -e "${RED}Invalid action${NC}"
            return 1
            ;;
    esac
    
    return $status
}
