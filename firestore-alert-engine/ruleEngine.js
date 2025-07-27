const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function evaluateAndTriggerAlert(mockData) {
  const thresholdsRef = db.collection("settings").doc("thresholds");
  const thresholdsSnap = await thresholdsRef.get();
  const thresholds = thresholdsSnap.data();

  const alerts = [];

  // --- Pollution ---
  if (mockData.aqi > thresholds.pollution_aqi_limit) {
    alerts.push({
      zone: "zoneA",
      type: "pollution",
      severity: "high",
      message: `AQI reached ${mockData.aqi}, above limit ${thresholds.pollution_aqi_limit}`,
      source: "pollutionAgent"
    });
  }

  // --- Rainfall ---
  if (mockData.rainfall_mm > thresholds.rainfall_flood_risk_mm) {
    alerts.push({
      zone: "zoneB",
      type: "flood",
      severity: "moderate",
      message: `Rainfall is ${mockData.rainfall_mm}mm, above risk limit.`,
      source: "weatherAgent"
    });
  }

  // --- Traffic ---
  if (mockData.traffic_density > thresholds.traffic_density_limit) {
    alerts.push({
      zone: "zoneC",
      type: "traffic",
      severity: "high",
      message: `Traffic density ${mockData.traffic_density} exceeds threshold.`,
      source: "trafficAgent"
    });
  }

  // --- Write alerts to Firestore ---
  for (const alert of alerts) {
    const alertRef = db.collection("alerts").doc(alert.zone).collection("alerts").doc();
    await alertRef.set({
      ...alert,
      issued_at: admin.firestore.FieldValue.serverTimestamp(),
      expires_at: admin.firestore.Timestamp.fromDate(new Date(Date.now() + 3600 * 1000)) // 1 hour
    });
    console.log(`✅ Alert written to ${alert.zone}: ${alert.type}`);
  }
}

// 🚀 Example Mock Sensor Data
const sampleData = {
  aqi: 130,
  rainfall_mm: 45,
  traffic_density: 90
};

evaluateAndTriggerAlert(sampleData).catch(console.error);
