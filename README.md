# Support Automation Toolkit

## Overview

The Support Automation Toolkit is a CLI-based system administration tool designed for IT support engineers. It provides comprehensive system monitoring, user management, log analysis, network diagnostics, and automation capabilities for Linux systems.

## Features

- **System Health Monitoring**: CPU, RAM, disk usage, and uptime tracking
- **User Management**: Add/remove/lock/unlock users, password resets
- **Log Analysis**: Parse system logs with critical event highlighting
- **Network Diagnostics**: Connectivity checks, speed tests, port scanning
- **Automation**: Scheduled tasks and alerts
- **Security Audits**: Permission checks and system hardening

## Installation

### Prerequisites

- Python 3.8+
- Linux system (Debian/Ubuntu recommended)
- Basic system utilities: `iproute2`, `net-tools`, `curl`

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
   chmod +x scripts/*.sh
   chmod +x setup.sh
   ```

5. **Run setup**:
   ```bash
   ./setup.sh
   ```

6. **Install optional dependencies** (recommended):
   ```bash
   sudo apt install speedtest-cli nmap
   ```

## Usage

### Basic Commands

```bash
# Show help menu
support-toolkit --help

# Check system health
support-toolkit health

# Manage users
support-toolkit users list
support-toolkit users modify <username> --lock

# Analyze logs
support-toolkit logs --parse auth --critical

# Network diagnostics
support-toolkit network
support-toolkit network --speedtest
```

### Common Operations

**1. System Monitoring**:
```bash
# Check current system status
support-toolkit health

# Set custom thresholds (CPU=85%, MEM=80%, DISK=90%)
support-toolkit health --set-thresholds "cpu=85,mem=80,disk=90"
```

**2. User Management**:
```bash
# List inactive users
support-toolkit users list --inactive

# Reset password
support-toolkit users modify johndoe --reset-password
```

**3. Network Diagnostics**:
```bash
# Full network check
support-toolkit network

# Just test internet speed
support-toolkit network --speedtest

# Show open ports
support-toolkit network --ports
```

### Scheduling Tasks

To schedule regular health checks (runs hourly):
```bash
(crontab -l 2>/dev/null; echo "0 * * * * /path/to/support-toolkit health >> /var/log/support-toolkit/health.log") | crontab -
```

## Configuration

Configuration files are stored in `/etc/support-toolkit/`:
- `config.ini`: Main configuration
- `thresholds.conf`: Alert thresholds

To modify configurations:
```bash
sudo nano /etc/support-toolkit/config.ini
```

## Logs

The tool logs to:
- `/var/log/support-toolkit/toolkit.log`: Main application log
- `/var/log/support-toolkit/system-health-*.log`: Health check results
- `/var/log/support-toolkit/network-*.log`: Network test results

## Troubleshooting

**Permission Errors**:
```bash
sudo mkdir -p /var/log/support-toolkit
sudo chown $USER /var/log/support-toolkit
```

**Missing Dependencies**:
```bash
sudo apt install python3-venv python3-pip
```

**Virtual Environment Issues**:
```bash
deactivate
rm -rf venv/
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## License

MIT License - See LICENSE file for details

## Contributing

Contributions are welcome! Please submit pull requests or open issues on our GitHub repository.

---

**Note**: Always run the tool from within the virtual environment (`source venv/bin/activate`) for proper functionality.