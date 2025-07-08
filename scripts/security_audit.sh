#!/bin/bash

# Security Audit Tool

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

AUDIT_DIR="/var/log/security-audit"
AUDIT_FILE="$AUDIT_DIR/audit-$(date +%Y%m%d).log"

mkdir -p "$AUDIT_DIR"

check_suid() {
    echo -e "\n${YELLOW}=== SUID/SGID Files ===${NC}"
    find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ld {} \; 2>/dev/null | tee -a "$AUDIT_FILE"
}

check_passwd_perms() {
    echo -e "\n${YELLOW}=== Password File Permissions ===${NC}"
    for file in /etc/passwd /etc/shadow /etc/group /etc/gshadow; do
        perms=$(stat -c "%a %n" "$file" 2>/dev/null)
        if [[ "$perms" =~ "644" ]] || [[ "$perms" =~ "600" ]]; then
            echo -e "${GREEN}$perms${NC}" | tee -a "$AUDIT_FILE"
        else
            echo -e "${RED}$perms${NC}" | tee -a "$AUDIT_FILE"
        fi
    done
}

check_open_ports() {
    echo -e "\n${YELLOW}=== Open Ports ===${NC}"
    ss -tulnp | tee -a "$AUDIT_FILE"
}

check_login_history() {
    echo -e "\n${YELLOW}=== Failed Login Attempts ===${NC}"
    grep "Failed password" /var/log/auth.log | tail -n 20 | tee -a "$AUDIT_FILE"
}

check_sudo_users() {
    echo -e "\n${YELLOW}=== Users with Sudo Privileges ===${NC}"
    grep -Po '^sudo.+:\K.*$' /etc/group | tee -a "$AUDIT_FILE"
}
