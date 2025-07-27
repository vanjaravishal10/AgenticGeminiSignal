const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function seedAlerts() {
  const now = admin.firestore.Timestamp.now();
  const sixHoursLater = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 6 * 60 * 60 * 1000));
  const threeHoursLater = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 3 * 60 * 60 * 1000));
  const twelveHoursLater = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 12 * 60 * 60 * 1000));

  const alerts = {
    zoneA: {
      alert_001: {
        type: "flood",
        severity: "high",
        message: "Heavy rainfall detected. Flash flooding possible.",
        issued_at: now,
        expires_at: sixHoursLater,
        source: "weatherAgent"
      }
    },
    zoneB: {
      alert_002: {
        type: "pollution",
        severity: "moderate",
        message: "AQI levels rising. Sensitive groups should limit outdoor activity.",
        issued_at: now,
        expires_at: threeHoursLater,
        source: "pollutionAgent"
      }
    },
    zoneC: {
      alert_003: {
        type: "fire",
        severity: "high",
        message: "Fire reported near residential block. Avoid the area.",
        issued_at: now,
        expires_at: twelveHoursLater,
        source: "emergencyAgent"
      }
    }
  };

  for (const [zone, alertsMap] of Object.entries(alerts)) {
    const zoneRef = db.collection('alerts').doc(zone);
    for (const [alertId, data] of Object.entries(alertsMap)) {
      await zoneRef.collection(alertId.split('_')[0]).doc(alertId).set(data);
      console.log(`Seeded ${zone}/${alertId}`);
    }
  }

  console.log("Seeding complete.");
}

seedAlerts().catch(console.error);
