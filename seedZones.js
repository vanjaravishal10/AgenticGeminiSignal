const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const zones = [
  { id: "zoneA", name: "Downtown Core" },
  { id: "zoneB", name: "Uptown Residential" },
  { id: "zoneC", name: "Industrial Park" },
  { id: "zoneD", name: "Smart Tech Hub" },
  { id: "zoneE", name: "Riverbank District" },
  { id: "zoneF", name: "Transit Crossroads" },
  { id: "zoneG", name: "Civic Center" },
  { id: "zoneH", name: "Healthcare Cluster" },
  { id: "zoneI", name: "University Town" },
  { id: "zoneJ", name: "Green Belt Zone" }
];

async function uploadZones() {
  const batch = db.batch();

  zones.forEach(zone => {
    const zoneRef = db.collection("zones").doc(zone.id);
    batch.set(zoneRef, { name: zone.name });
  });

  await batch.commit();
  console.log("✅ Zones uploaded successfully.");
}

uploadZones().catch(console.error);
