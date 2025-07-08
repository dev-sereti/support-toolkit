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

list_services() {
    echo -e "${YELLOW}=== System Services ===${NC}"
    systemctl list-unit-files --type=service --no-pager | head -n -3
    
    echo -e "\n${YELLOW}=== Running Services ===${NC}"
    systemctl list-units --type=service --state=running --no-pager | head -n -7
}

monitor_services() {
    echo -e "${YELLOW}Monitoring essential services...${NC}"
    services=("sshd" "nginx" "postgresql" "redis")
    
    for service in "${services[@]}"; do
        if ! systemctl is-active --quiet "$service"; then
            echo -e "${RED}$service is down! Attempting to restart...${NC}"
            systemctl restart "$service"
            log "Restarted crashed service: $service"
        fi
    done
}

case "$1" in
    list)
        list_services
        ;;
    monitor)
        monitor_services
        ;;
    action)
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo -e "${RED}Usage: $0 action <service> {start|stop|restart|status|enable|disable}${NC}"
            exit 1
        fi
        service_action "$2" "$3"
        ;;
    *)
        echo -e "${YELLOW}Usage: $0 {list|monitor|action} [options]${NC}"
        echo -e "Commands:"
        echo -e "  list                     - List all services"
        echo -e "  monitor                  - Monitor essential services"
        echo -e "  action <service> <cmd>   - Control a service"
        exit 1
        ;;
esac

exit 0