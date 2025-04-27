const admin = require('firebase-admin');
const serviceAccount = require('./przychodnia-6e705-firebase-adminsdk-hx5nb-55544b6b7f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addSpecializations() {
  const specializations = [
    { id: 'specialization_001', name: 'Lekarz POZ' },
    { id: 'specialization_002', name: 'Chirurg' },
    { id: 'specialization_003', name: 'Lekarz rodzinny' },
    { id: 'specialization_004', name: 'Ginekolog' },
    { id: 'specialization_005', name: 'Okulista' },
    { id: 'specialization_006', name: 'Dermatolog' },
    { id: 'specialization_007', name: 'Pediatra' },
    { id: 'specialization_008', name: 'Urolog' },
    { id: 'specialization_009', name: 'Onkolog' },
  ];

  for (const specialization of specializations) {
    try {
      const specializationRef = db.collection('specializations').doc(specialization.id);
      await specializationRef.set({ name: specialization.name });
      console.log(`Dodano specjalizację: ${specialization.name}`);
    } catch (error) {
      console.error(`Błąd przy dodawaniu specjalizacji ${specialization.name}:`, error);
    }
  }
}

addSpecializations();