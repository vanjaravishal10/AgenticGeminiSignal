import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

# Initialize Firebase
cred = credentials.Certificate("serviceAccountKey.json")  # <-- Update path
firebase_admin.initialize_app(cred)
db = firestore.client()

# Agent types
agents = {
    'emergencyAgent': [
        {
            'log_id': 'log_001',
            'entries': [
                {
                    'doc_id': 'log_001',
                    'action': 'Dispatch ambulance',
                    'confidence': 0.88,
                    'reason': 'Multiple sensors detect distress',
                    'triggered_at': datetime(2025, 7, 17, 5, 33, 51),
                    'zoneId': 1
                }
            ]
        }
    ],
    'pollutionAgent': [
        {
            'log_id': 'log_001',
            'entries': [
                {
                    'doc_id': 'log_001',
                    'action': 'Trigger air quality alert',
                    'reason': 'AQI > 120',
                    'triggered_at': datetime(2025, 7, 16, 23, 48, 12),
                    'zoneId': 2
                }
            ]
        },
        {
            'log_id': 'log_002',
            'entries': [
                {
                    'doc_id': 'log_002',
                    'action': 'Trigger air quality alert',
                    'reason': 'AQI spiked by 60 units in last 30 mins',
                    'triggered_at': datetime(2025, 7, 16, 23, 53, 2),
                    'zoneId': 3
                }
            ]
        }
    ],
    'trafficAgent': [
        {
            'log_id': 'log_001',
            'entries': [
                {
                    'doc_id': 'log_001',
                    'action': 'Suggest reroute',
                    'confidence': 0.87,
                    'reason': 'Density > 80',
                    'triggered_at': datetime(2025, 7, 16, 23, 44, 34),
                    'zoneId': 4
                }
            ]
        }
    ],
    'weatherAgent': [
        {
            'log_id': 'log_001',
            'entries': [
                {
                    'doc_id': 'log_001',
                    'action': 'Issue rain advisory',
                    'confidence': 0.91,
                    'reason': 'Rainfall > 40mm',
                    'triggered_at': datetime(2025, 7, 17, 0, 0, 43),
                    'zoneId': 6
                }
            ]
        }
    ]
}

# Inserting data
for agent, logs in agents.items():
    for log in logs:
        log_doc_ref = db.collection("agent_logs").document(agent).collection("log_{}".format(log['log_id'].split('_')[-1])).document()
        for entry in log["entries"]:
            log_values_ref = log_doc_ref.collection("log_values").document(entry["doc_id"])
            log_data = {
                "action": entry["action"],
                "confidence": entry.get("confidence"),
                "reason": entry["reason"],
                "triggered_at": entry["triggered_at"],
                "zoneId": entry["zoneId"]
            }
            log_values_ref.set(log_data)
            print(f"Seeded: {agent}/{log['log_id']}/{entry['doc_id']}")

print("✅ All agent logs seeded successfully.")
