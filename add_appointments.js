const admin = require('firebase-admin');
const serviceAccount = require('./przychodnia-6e705-firebase-adminsdk-hx5nb-55544b6b7f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function initializeAppointmentsCollection() {
  try {
    // Dodanie dokumentu z polami o domyślnych wartościach
    const appointmentRef = db.collection('appointments').doc();
    await appointmentRef.set({
      patientId: null,       // ID pacjenta (null, bo jeszcze nie przypisano)
      doctorId: null,        // ID lekarza (null, bo jeszcze nie przypisano)
      slotId: null,          // ID slotu (null, bo jeszcze nie przypisano)
      date: null,            // Data wizyty (null, bo jeszcze nie ustalono)
      startTime: null,       // Godzina rozpoczęcia (null, bo jeszcze nie ustalono)
      endTime: null,         // Godzina zakończenia (null, bo jeszcze nie ustalono)
      status: 'pending',     // Status wizyty (domyślnie 'pending')
      createdAt: admin.firestore.FieldValue.serverTimestamp(), // Znacznik czasu
    });

    console.log('Kolekcja `appointments` została utworzona.');
  } catch (error) {
    console.error('Błąd podczas tworzenia kolekcji `appointments`:', error);
  }
}

// Wywołanie funkcji
initializeAppointmentsCollection();