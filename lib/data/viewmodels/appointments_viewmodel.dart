import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  // Dodanie nowej wizyty
  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  // Pobieranie wizyt dla użytkownika
  List<Appointment> getAppointmentsForUser(String userId) {
    return _appointments.where((appt) => appt.userId == userId).toList();
  }
}
