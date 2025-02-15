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

  Future<bool> createAppointment(
      {required String slotId,
      required String doctorId,
      required String userId}) async {
    try {
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
        'dateTime': DateTime.now().toIso8601String(),
        'status': 'booked',
      };
      await _db.collection('appointments').add(appointment);
      return true;
    } catch (e) {
      print('Błąd podczas tworzenia wizyty: $e');
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
