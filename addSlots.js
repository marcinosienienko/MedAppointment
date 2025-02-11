const admin = require('firebase-admin');
const serviceAccount = require('./przychodnia-6e705-firebase-adminsdk-hx5nb-01ba48b34e.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addSlotsForDoctors() {
  const doctors = [
    { id: 'doctor_001', name: 'Jan Kowalski' },
    { id: 'doctor_002', name: 'Anna Nowak' },
    { id: 'doctor_003', name: 'Tomasz Zieliński' },
    { id: 'doctor_004', name: 'Magdalena Wiśniewska' },
    { id: 'doctor_005', name: 'Katarzyna Nowicka' },
    { id: 'doctor_006', name: 'Piotr Grabowski' },
    { id: 'doctor_007', name: 'Ewa Lis' },
    { id: 'doctor_008', name: 'Rafał Dąbrowski' },
  ];

  for (const doctor of doctors) {
    try {
      const doctorRef = db.collection('doctors').doc(doctor.id);

      const slots = generateTwoWeeksSlots(new Date(), '08:00', '16:00');
      const slotsCollection = doctorRef.collection('slots');

      for (const slot of slots) {
        await slotsCollection.doc(slot.id).set(slot);
      }

      console.log(`Dodano sloty dla lekarza: ${doctor.name}`);
    } catch (error) {
      console.error(`Błąd podczas dodawania slotów dla ${doctor.name}:`, error);
    }
  }
}

function generateTwoWeeksSlots(startDate, startTime, endTime) {
  const slots = [];
  const daysToGenerate = 14; // 14 dni
  const intervalMinutes = 30; // Interwał 30 minut

  for (let day = 0; day < daysToGenerate; day++) {
    const currentDate = new Date(startDate);
    currentDate.setDate(currentDate.getDate() + day);

    // Generuj tylko dla dni roboczych (poniedziałek–piątek)
    if (currentDate.getDay() !== 0 && currentDate.getDay() !== 6) {
      let currentSlotTime = new Date(
        `${currentDate.toISOString().split('T')[0]}T${startTime}:00`
      );

      const endSlotTime = new Date(
        `${currentDate.toISOString().split('T')[0]}T${endTime}:00`
      );

      while (currentSlotTime < endSlotTime) {
        const nextSlotTime = new Date(currentSlotTime);
        nextSlotTime.setMinutes(nextSlotTime.getMinutes() + intervalMinutes);

        const slotId = `${currentDate.toISOString().split('T')[0]}_${currentSlotTime
          .toISOString()
          .split('T')[1]
          .substring(0, 5)
          .replace(/:/g, '-')}`;

        slots.push({
          id: slotId,
          date: currentDate.toISOString().split('T')[0],
          startTime: currentSlotTime.toISOString().split('T')[1].substring(0, 5),
          endTime: nextSlotTime.toISOString().split('T')[1].substring(0, 5),
          status: 'available',
        });

        currentSlotTime = nextSlotTime;
      }
    }
  }

  return slots;
}

// Uruchomienie skryptu
addSlotsForDoctors();