from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta

# Initialize Firebase app and Firestore client
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)
db = firestore.client()

app = Flask(__name__)

@app.route("/evaluate_alerts", methods=["POST"])
def evaluate_alerts():
    data = request.json
    zone = data.get("zone")
    pollution = data.get("pollution")
    water = data.get("water")

    alerts = []

    # Pollution threshold logic
    if pollution is not None:
        if pollution > 150:
            alerts.append({
                "zone": zone,
                "severity": "high",
                "type": "pollution",
                "message": f"Air quality alert in {zone}: AQI {pollution}",
                "created_at": datetime.utcnow(),
                "expires_at": datetime.utcnow() + timedelta(hours=1),
                "source": "sensor_unit"
            })

    # Water level threshold logic
    if water is not None:
        if water < 30:
            alerts.append({
                "zone": zone,
                "severity": "medium",
                "type": "water",
                "message": f"Water shortage alert in {zone}: Level {water}%",
                "created_at": datetime.utcnow(),
                "expires_at": datetime.utcnow() + timedelta(hours=1),
                "source": "sensor_unit"
            })

    # Store alerts if any
    for alert in alerts:
        db.collection("alerts").add(alert)

    if alerts:
        return jsonify({"status": "alerts_created", "count": len(alerts)}), 201
    else:
        return jsonify({"status": "no_alert_triggered"}), 200

if __name__ == "__main__":
    app.run(debug=True)
