from textual.app import App, ComposeResult
from textual.widgets import DataTable, Header, Footer
from utils.constants import INCIDENT_DIR

import os
import json

# Add this line at the top (same path as in incident_reporter.py)
INCIDENT_DIR = "/var/log/support-toolkit/incidents"

class IncidentTUI(App):
    CSS_PATH = "incident_tui.css"
    BINDINGS = [("q", "quit", "Quit")]
    
    def compose(self) -> ComposeResult:
        yield Header()
        yield DataTable()
        yield Footer()
    
    def on_mount(self) -> None:
        table = self.query_one(DataTable)
        table.add_columns("Timestamp", "Title", "Severity", "Status")
        
        # Create directory if missing
        os.makedirs(INCIDENT_DIR, exist_ok=True)
        
        for filename in os.listdir(INCIDENT_DIR):
            if filename.endswith('.json'):
                with open(os.path.join(INCIDENT_DIR, filename)) as f:
                    incident = json.load(f)
                    table.add_row(
                        incident['timestamp'],
                        incident['title'],
                        incident['severity'],
                        incident['status']
                    )

if __name__ == "__main__":
    app = IncidentTUI()
    app.run()