const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin with your service account
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function exportData() {
  const collections = ['users', 'alerts', 'agent_logs', 'city_data', 'city_graph', 'settings'];
  const output = {};

  for (const col of collections) {
    const snapshot = await db.collection(col).get();
    output[col] = [];
    snapshot.forEach(doc => {
      output[col].push({
        id: doc.id,
        data: doc.data()
      });
    });
  }

  fs.writeFileSync('firestore.seed.json', JSON.stringify(output, null, 2));
  console.log('Export completed to firestore.seed.json');
}

exportData();
