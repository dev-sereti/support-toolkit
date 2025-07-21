# utils/constants.py
import os

# Incident Reporting
INCIDENT_DIR = os.path.join("/var/log/support-toolkit", "incidents")
os.makedirs(INCIDENT_DIR, exist_ok=True)

# Add other constants here as needed