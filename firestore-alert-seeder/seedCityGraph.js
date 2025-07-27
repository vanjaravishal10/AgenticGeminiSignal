// cityGraphSeeder.js

const admin = require("firebase-admin");
const serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const cityGraph = {
  entity_road_A: {
    type: "road",
    connected_to: ["intersection_X", "intersection_Y"],
    feeds: ["zoneA"]
  },
  intersection_X: {
    type: "intersection",
    connected_to: ["entity_road_A", "entity_road_B"]
  },
  entity_road_B: {
    type: "road",
    connected_to: ["intersection_X"],
    feeds: ["zoneB"]
  },
  entity_pipe_A: {
    type: "pipe",
    connected_to: ["waterTank_1", "valve_4"],
    feeds: ["zoneC"]
  }
};

async function seedCityGraph() {
  const cityGraphRef = db.collection("city_graph");

  for (const [id, data] of Object.entries(cityGraph)) {
    await cityGraphRef.doc(id).set(data);
    console.log(`Seeded ${id}`);
  }

  console.log("✅ City graph seeding complete.");
}

seedCityGraph().catch(console.error);
