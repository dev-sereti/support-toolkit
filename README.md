# Support Automation Toolkit

## Overview

The Support Automation Toolkit is a comprehensive CLI-based system administration tool designed for IT support engineers. It provides complete system monitoring and management capabilities for Linux systems through an intuitive command-line interface.

## Features

- **System Health Monitoring**: Real-time CPU, RAM, disk usage, and uptime tracking
- **User Management**: Complete user account control and activity monitoring
- **Log Analysis**: Advanced log parsing with critical event detection
- **Network Diagnostics**: Comprehensive connectivity and performance testing
- **Package Management**: System updates and security patching
- **Remote Support**: Secure remote command execution and log collection
- **Security Audits**: System hardening checks and vulnerability detection
- **Service Control**: Automated service monitoring and recovery

## Installation

### Prerequisites

- Python 3.8+
- Linux system (Debian/Ubuntu recommended)
- Basic system utilities:
  ```bash
  sudo apt install iproute2 net-tools curl nmap sshpass
  ```

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-repo/support-toolkit.git
   cd support-toolkit
   ```

2. **Set up virtual environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Make scripts executable**:
   ```bash
   chmod +x scripts/*.sh setup.sh
   ```

5. **Run setup**:
   ```bash
   ./setup.sh
   ```

6. **Install optional tools**:
   ```bash
   sudo apt install speedtest-cli
   ```

## Usage

### Basic Commands

```bash
# Show help menu
support-toolkit --help

# Display system information
support-toolkit health

# List active users
support-toolkit users list --active
```

### System Health

```bash
# Check current status
support-toolkit health

# Set custom thresholds
support-toolkit health --set-thresholds "cpu=85,mem=80,disk=90"

# View current thresholds
support-toolkit health --thresholds
```

### User Management

```bash
# List all users
support-toolkit users list

# Lock user account
support-toolkit users modify <username> --lock

# Reset password
support-toolkit users modify <username> --reset-password
```

### Log Management

```bash
# Analyze auth log
support-toolkit logs --parse auth

# Archive old logs
support-toolkit logs --archive

# Show critical events
support-toolkit logs --parse syslog --critical
```

### Network Diagnostics

```bash
# Full network check
support-toolkit network

# Run speed test
support-toolkit network --speedtest

# Show open ports
support-toolkit network --ports
```

### Package Management

```bash
# Update packages
support-toolkit pkg update

# Upgrade system
support-toolkit pkg upgrade

# Security updates
support-toolkit pkg security

# Clean orphans
support-toolkit pkg clean
```

### Remote Support

```bash
# Execute remote command
support-toolkit remote cmd user@host "df -h"

# Pull remote logs
support-toolkit remote logs user@host --path /var/log

# Batch command
support-toolkit remote batch hosts.txt "apt update"
```

### Security Audits

```bash
# Check SUID/SGID files
support-toolkit audit suid

# Scan open ports
support-toolkit audit ports

# Full system audit
support-toolkit audit full
```

### Service Control

```bash
# List services
support-toolkit service list

# Monitor services
support-toolkit service monitor

# Manage services
support-toolkit service action nginx restart
```

## Configuration

Configuration files are located in `/etc/support-toolkit/`:

| File              | Description                          |
|-------------------|--------------------------------------|
| `config.ini`      | Main application configuration       |
| `thresholds.conf` | Health monitoring thresholds         |
| `services.conf`   | Essential services configuration     |

Edit configurations with:
```bash
sudo nano /etc/support-toolkit/config.ini
```

## Logging

Log files are stored in `/var/log/support-toolkit/`:

| File                          | Contents                              |
|-------------------------------|---------------------------------------|
| `toolkit.log`                 | Main application log                  |
| `health-<date>.log`           | System health reports                 |
| `security-audit-<date>.log`   | Security audit results                |
| `remote-logs-<date>.tar.gz`   | Archived remote logs                  |

## Scheduled Tasks

Example cron jobs for automation:

```bash
# Daily health check at 2am
0 2 * * * /path/to/support-toolkit health >> /var/log/support-toolkit/health.log

# Weekly security audit on Mondays
0 3 * * 1 /path/to/support-toolkit audit full >> /var/log/support-toolkit/security-audit.log

# Hourly service monitoring
0 * * * * /path/to/support-toolkit service monitor
```

## Troubleshooting

**Common Issues and Solutions**:

1. **Permission Errors**:
   ```bash
   sudo mkdir -p /var/log/support-toolkit
   sudo chown -R $USER /var/log/support-toolkit
   ```

2. **Missing Dependencies**:
   ```bash
   sudo apt install python3-venv python3-pip nmap speedtest-cli sshpass
   ```

3. **Virtual Environment Issues**:
   ```bash
   deactivate
   rm -rf venv/
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

4. **Network Diagnostics Failures**:
   ```bash
   sudo apt install net-tools iproute2 nmap
   ```

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Contributing

We welcome contributions! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

For major changes, please open an issue first to discuss your proposed changes.

---

**Note**: Always activate the virtual environment before use:
```bash
source venv/bin/activate
```

For production deployments, consider using:
```bash
sudo ./setup.sh --install-system-wide
```