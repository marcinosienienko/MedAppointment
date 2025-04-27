const admin = require('firebase-admin');
const serviceAccount = require('./przychodnia-6e705-firebase-adminsdk-hx5nb-55544b6b7f.json'); // Ścieżka do klucza serwisowego Firebase
const data = require('./assets/firebase_data/doctors.json'); // Ścieżka do pliku JSON

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const importData = async () => {
  const collectionRef = db.collection('doctors');

  for (const id in data) {
    const doctor = data[id];
    await collectionRef.doc(id).set(doctor);
    console.log(`Imported doctor with ID: ${id}`);
  }

  console.log('Import completed!');
};

importData().catch((error) => {
  console.error('Error importing data:', error);
});