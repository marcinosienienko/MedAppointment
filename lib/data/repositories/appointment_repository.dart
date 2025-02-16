import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_app/data/services/firestore_service.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentRepository {
  final FirestoreService _firestoreService = FirestoreService();
  final _db = FirebaseFirestore.instance;

  Future<List<Appointment>> getAppointments(String userId) async {
    final snapshot = await _db
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => Appointment.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<bool> createAppointment({
    required String slotId,
    required String doctorId,
    required String userId,
  }) async {
    try {
      final slotDoc = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .get();

      if (!slotDoc.exists) {
        print('❌ Błąd: Slot nie istnieje!');
        return false;
      }

      final slotData = slotDoc.data();
      final String? startTime = slotData?['startTime'];
      final String? date = slotData?['date'];

      if (startTime == null || date == null) {
        print('❌ Błąd: Slot nie zawiera startTime lub date!');
        return false;
      }

      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'status': 'booked'});

      final appointment = {
        'doctorId': doctorId,
        'userId': userId,
        'slotId': slotId,
        'date': date, // Dodajemy date
        'startTime': startTime, // Dodajemy startTime
        'status': 'booked',
        'createdAt': DateTime.now().toIso8601String(),
      };

      await _db.collection('appointments').add(appointment);
      print('✅ Wizyta utworzona: $appointment');
      return true;
    } catch (e) {
      print('❌ Błąd podczas tworzenia wizyty: $e');
      return false;
    }
  }

  Future<void> updateAppointment(Appointment appointment) {
    return _firestoreService.updateAppointment(appointment);
  }

  Future<void> cancelAppointment({
    required appointmentId,
    required doctorId,
    required slotId,
  }) async {
    try {
      await _db.collection('appointments').doc(appointmentId).delete();

      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'status': 'available'});
    } catch (e) {
      print('Błąd podczas odwoływania wizyty: $e');
      rethrow;
    }
  }
}
