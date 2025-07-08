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
