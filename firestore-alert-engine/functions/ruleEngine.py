import firebase_admin
from firebase_admin import credentials, firestore
import functions_framework

# Initialize Firebase Admin SDK
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred)
db = firestore.client()

@functions_framework.http
def evaluate_alerts(request):
    try:
        # Fetch thresholds from settings
        settings_ref = db.collection("settings").document("global")
        settings_doc = settings_ref.get()
        if not settings_doc.exists:
            return "Settings document not found", 404
        thresholds = settings_doc.to_dict().get("thresholds", {})

        # Fetch latest alerts
        alerts_ref = db.collection("alerts")
        alerts = alerts_ref.stream()

        results = []
        for alert in alerts:
            data = alert.to_dict()
            metric_type = data.get("type")
            severity = data.get("severity")
            value = data.get("value")

            limit = thresholds.get(f"{metric_type}_limit")
            if limit is not None and value > limit:
                results.append({
                    "alert_id": alert.id,
                    "type": metric_type,
                    "value": value,
                    "limit": limit,
                    "status": "exceeded"
                })

        return {"results": results}, 200

    except Exception as e:
        return {"error": str(e)}, 500
