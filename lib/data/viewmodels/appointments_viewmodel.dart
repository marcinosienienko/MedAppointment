import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/firestore_service.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  Future<void> fetchAppointments(String userId) async {
    try {
      print('Ładowanie wizyt dla użytkownika: $userId');
      _appointments = await _firestoreService.fetchAppointmentsByUserId(userId);
      print('Załadowano ${_appointments.length} wizyt.');
      notifyListeners();
    } catch (e) {
      print('Błąd podczas pobierania wizyt: $e');
    }
  }

  Future<void> cancelAppointment(
      String appointmentId, String doctorId, String slotId) async {
    try {
      await _firestoreService.cancelAppointment(
          appointmentId, doctorId, slotId);
      _appointments
          .removeWhere((appointment) => appointment.id == appointmentId);
      notifyListeners();
    } catch (e) {
      print('Błąd podczas anulowania wizyty: $e');
    }
  }
}
