# incident_tui.py
from textual.app import App, ComposeResult
from textual.widgets import DataTable, Header, Footer
import json
import os

class IncidentTUI(App):
    """Terminal-based incident browser"""
    
    CSS_PATH = "incident_tui.css"
    BINDINGS = [("q", "quit", "Quit")]
    
    def compose(self) -> ComposeResult:
        yield Header()
        yield DataTable()
        yield Footer()
    
    def on_mount(self) -> None:
        table = self.query_one(DataTable)
        table.add_columns("Time", "Title", "Severity", "Status")
        
        for file in os.listdir(INCIDENT_DIR):
            if file.endswith('.json'):
                with open(f"{INCIDENT_DIR}/{file}") as f:
                    incident = json.load(f)
                    table.add_row(
                        incident['timestamp'],
                        incident['title'],
                        incident['severity'],
                        incident['status']
                    )