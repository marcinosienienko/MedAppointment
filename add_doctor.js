const admin = require('firebase-admin');
const serviceAccount = require('./przychodnia-6e705-firebase-adminsdk-hx5nb-55544b6b7f.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function addDoctorsWithSlots() {
  const doctors = [
    {
      id: 'doctor_001',
      name: 'Jan Kowalski',
      specializationId: 'specialization_003', // Lekarz rodzinny
      pwzNumber: '123456',
      description: 'Doświadczony lekarz rodzinny z ponad 20-letnim stażem.',
      avatarUrl: 'https://example.com/avatar1.jpg',
      location: 'Warszawa, ul. Szpitalna 10',
      contact: { phone: '+48 123 456 789', email: 'jan.kowalski@example.com' },
    },
    {
      id: 'doctor_002',
      name: 'Anna Nowak',
      specializationId: 'specialization_002', // Chirurg
      pwzNumber: '654321',
      description: 'Specjalistka chirurgii ogólnej.',
      avatarUrl: 'https://example.com/avatar2.jpg',
      location: 'Kraków, ul. Lekarska 5',
      contact: { phone: '+48 987 654 321', email: 'anna.nowak@example.com' },
    },
    {
      id: 'doctor_003',
      name: 'Tomasz Zieliński',
      specializationId: 'specialization_005', // Okulista
      pwzNumber: '112233',
      description: 'Ekspert w diagnostyce i leczeniu chorób oczu.',
      avatarUrl: 'https://example.com/avatar3.jpg',
      location: 'Poznań, ul. Zdrowa 12',
      contact: { phone: '+48 555 666 777', email: 'tomasz.zielinski@example.com' },
    },
    {
      id: 'doctor_004',
      name: 'Magdalena Wiśniewska',
      specializationId: 'specialization_004', // Ginekolog
      pwzNumber: '334455',
      description: 'Doświadczona ginekolog z wieloletnim doświadczeniem.',
      avatarUrl: 'https://example.com/avatar4.jpg',
      location: 'Wrocław, ul. Kliniczna 3',
      contact: { phone: '+48 111 222 333', email: 'magdalena.wisniewska@example.com' },
    },
    {
      id: 'doctor_005',
      name: 'Katarzyna Nowicka',
      specializationId: 'specialization_006', // Dermatolog
      pwzNumber: '223344',
      description: 'Specjalistka w leczeniu chorób skóry.',
      avatarUrl: 'https://example.com/avatar5.jpg',
      location: 'Gdańsk, ul. Derma 8',
      contact: { phone: '+48 444 555 666', email: 'katarzyna.nowicka@example.com' },
    },
    {
      id: 'doctor_006',
      name: 'Piotr Grabowski',
      specializationId: 'specialization_007', // Pediatra
      pwzNumber: '556677',
      description: 'Pediatra z pasją do opieki nad dziećmi.',
      avatarUrl: 'https://example.com/avatar6.jpg',
      location: 'Łódź, ul. Dziecięca 1',
      contact: { phone: '+48 333 444 555', email: 'piotr.grabowski@example.com' },
    },
    {
      id: 'doctor_007',
      name: 'Ewa Lis',
      specializationId: 'specialization_008', // Urolog
      pwzNumber: '778899',
      description: 'Ekspertka w leczeniu chorób układu moczowego.',
      avatarUrl: 'https://example.com/avatar7.jpg',
      location: 'Lublin, ul. Moczna 14',
      contact: { phone: '+48 666 777 888', email: 'ewa.lis@example.com' },
    },
    {
      id: 'doctor_008',
      name: 'Rafał Dąbrowski',
      specializationId: 'specialization_009', // Onkolog
      pwzNumber: '889900',
      description: 'Specjalista w terapii nowotworów złośliwych.',
      avatarUrl: 'https://example.com/avatar8.jpg',
      location: 'Katowice, ul. Onkologiczna 20',
      contact: { phone: '+48 999 000 111', email: 'rafal.dabrowski@example.com' },
    },
  ];

  for (const doctor of doctors) {
    try {
      const specializationRef = db.collection('specializations').doc(doctor.specializationId);
      const specializationDoc = await specializationRef.get();

      if (!specializationDoc.exists) {
        throw new Error(`Specjalizacja z ID ${doctor.specializationId} nie istnieje.`);
      }

      const doctorRef = db.collection('doctors').doc(doctor.id);
      await doctorRef.set({
        ...doctor,
        status: 'active',
        calendarSyncId: `calendar_${doctor.id}`,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Generowanie slotów
      const slots = generateTwoWeeksSlots(new Date(), '08:00', '16:00');
      const slotsCollection = doctorRef.collection('slots');
      for (const slot of slots) {
        await slotsCollection.doc(slot.id).set(slot); // Ustawienie predefiniowanego ID slotu
      }

      console.log(`Dodano lekarza: ${doctor.name}`);
    } catch (error) {
      console.error(`Błąd podczas dodawania lekarza ${doctor.name}:`, error);
    }
  }
}

function generateTwoWeeksSlots(startDate, startTime, endTime) {
  const slots = [];
  const daysToGenerate = 14; // Generowanie na 14 dni
  const intervalMinutes = 30;

  for (let day = 0; day < daysToGenerate; day++) {
    const currentDate = new Date(startDate);
    currentDate.setDate(currentDate.getDate() + day);

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

        // Generowanie ID slotu
        const slotId = `${currentDate.toISOString().split('T')[0]}_${currentSlotTime
          .toISOString()
          .split('T')[1]
          .substring(0, 5)}`.replace(/:/g, '-');

        slots.push({
          id: slotId, // Predefiniowane ID
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
addDoctorsWithSlots();