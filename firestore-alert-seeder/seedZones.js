const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const zones = {
  zoneA: {
    name: "Andheri West",
    coordinates: { lat: 19.1197, lng: 72.8468 }
  },
  zoneB: {
    name: "Bandra East",
    coordinates: { lat: 19.056, lng: 72.8407 }
  },
  zoneC: {
    name: "Ghatkopar",
    coordinates: { lat: 19.0847, lng: 72.908 }
  }
};

async function seedZones() {
  const settingsRef = db.collection("settings").doc("zones");
  await settingsRef.set(zones);
  console.log("✅ Zones data seeded successfully.");
}

seedZones().catch(console.error);
