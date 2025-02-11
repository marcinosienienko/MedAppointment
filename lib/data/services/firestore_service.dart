import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';
import '../models/specialization.dart';
import '../models/slot_model.dart';
import '../models/appointment_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final doctorsSnapshot = await _db.collection('doctors').get();
      final doctors = <Doctor>[];

      for (var doc in doctorsSnapshot.docs) {
        final doctorData = doc.data();
        final doctorId = doc.id;

        // Pobieranie specjalizacji
        Specialization? specialization;
        final specializationId = doctorData['specializationId'];
        if (specializationId != null) {
          specialization = await fetchSpecialization(specializationId);
        }

        // Pobieranie slotów
        final slotsSnapshot = await _db
            .collection('doctors')
            .doc(doctorId)
            .collection('slots')
            .get();
        final slots = slotsSnapshot.docs
            .map((slotDoc) => Slot.fromMap(slotDoc.data(), slotDoc.id))
            .toList();

        // Tworzenie obiektu Doctor
        final doctor = Doctor.fromMap(doctorData, doctorId).copyWith(
          specialization: specialization,
          slots: slots,
        );
        doctors.add(doctor);
      }

      return doctors;
    } catch (e) {
      print('Błąd podczas pobierania lekarzy: $e');
      return [];
    }
  }

  Future<void> createAppointment(appointment) async {
    await _db.collection('appointments').add(appointment.toMap());
  }

  Future updateAppointment(Appointment appointment) async {
    await _db
        .collection('appointments')
        .doc(appointment.id)
        .update(appointment.toJson());
  }

  Future<void> deleteAppointment(Appointment appointment) async {
    await _db.collection('appointments').doc(appointment.id).delete();
  }

  Future<List<Appointment>> fetchAppointmentsByUserId(String userId) async {
    try {
      final snapshot = await _db
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      final appointments = <Appointment>[];

      for (var doc in snapshot.docs) {
        final appointmentData = doc.data();
        final doctorId = appointmentData['doctorId'];

        // Pobieranie danych doktora
        final doctorDoc = await _db.collection('doctors').doc(doctorId).get();
        final doctorData = doctorDoc.data();

        // Pobieranie specjalizacji doktora
        final specializationId = doctorData?['specializationId'];
        String? specializationName;

        if (specializationId != null) {
          final specializationDoc = await _db
              .collection('specializations')
              .doc(specializationId)
              .get();
          specializationName = specializationDoc.data()?['name'];
        }

        // Tworzenie obiektu Appointment z dodatkowymi danymi
        appointments.add(
          Appointment.fromMap(appointmentData, doc.id).copyWith(
            doctorName: doctorData?['name'],
            specialization: specializationName,
          ),
        );
      }

      return appointments;
    } catch (e) {
      print('Błąd podczas pobierania wizyt: $e');
      return [];
    }
  }

  Future<void> cancelAppointment(
      String appointmentId, String doctorId, String slotId) async {
    try {
      print('Anulowanie wizyty: $appointmentId');

      // Usuń wizytę
      await _db.collection('appointments').doc(appointmentId).delete();
      print('Wizyta została usunięta.');

      // Przywróć dostępność slotu
      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'status': 'available'});
      print('Dostępność slotu została przywrócona.');
    } catch (e) {
      print('Błąd podczas anulowania wizyty: $e');
      throw e;
    }
  }

  Future<Specialization?> fetchSpecialization(String specializationId) async {
    try {
      print('Pobieranie specjalizacji o ID: $specializationId');
      final doc =
          await _db.collection('specializations').doc(specializationId).get();

      if (doc.exists) {
        print('Dane specjalizacji: ${doc.data()}');
        return Specialization.fromMap(doc.data()!, doc.id);
      } else {
        print('Specjalizacja o ID $specializationId nie istnieje.');
        return null;
      }
    } catch (e) {
      print('Błąd podczas pobierania specjalizacji: $e');
      return null;
    }
  }
}

 // Future<Appointment> fetchAppointmentWithDetails(
  //     Map<String, dynamic> data, String documentId) async {
  //   final String? doctorId = data['doctorId'] as String?;
  //   final String? patientId = data['patientId'] as String?;

  //   String? doctorName;
  //   String? patientName;

  //   // Pobranie imienia doktora
  //   if (doctorId != null) {
  //     final doctorSnapshot =
  //         await _db.collection('doctors').doc(doctorId).get();
  //     if (doctorSnapshot.exists) {
  //       doctorName = doctorSnapshot.data()?['name'] as String?;
  //     }
  //   }

  //   // Pobranie imienia pacjenta
  //   if (patientId != null) {
  //     final patientSnapshot =
  //         await _db.collection('users').doc(patientId).get();
  //     if (patientSnapshot.exists) {
  //       patientName = patientSnapshot.data()?['name'] as String?;
  //     }
  //   }

  //   // Utworzenie obiektu Appointment
  //   return Appointment(
  //     id: documentId,
  //     date: data['date'] as String?,
  //     doctorId: doctorId,
  //     patientId: patientId,
  //     slotId: data['slotId'] as String?,
  //     startTime: data['startTime'] as String?,
  //     endTime: data['endTime'] as String?,
  //     doctorName: doctorName,
  //     patientName: patientName,
  //     status: data['status'] as String? ?? 'pending',
  //     createdAt: data['createdAt'] != null
  //         ? (data['createdAt'] as Timestamp).toDate()
  //         : null,
  //   );
  // }
