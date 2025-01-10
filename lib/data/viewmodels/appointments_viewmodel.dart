import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void cancelAppointment(String appointmentId) {
    _appointments.removeWhere((appointment) => appointment.id == appointmentId);
    notifyListeners();
  }
}
