import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/firestore_service.dart';
import '../viewmodels/slot_viewmodel.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;
  Appointment? getNextUpcomingAppointment() {
    final now = DateTime.now();

    final upcomingAppointments = _appointments.where((appointment) {
      if (appointment.date != null) {
        final appointmentDate = DateTime.parse(appointment.date!);
        return appointmentDate.isAfter(now);
      }
      return false;
    }).toList();

    if (upcomingAppointments.isNotEmpty) {
      upcomingAppointments.sort(
          (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
      return upcomingAppointments.first;
    }

    return null;
  }

  List<Appointment> get upcomingAppointments => _appointments
      .where((appointment) => appointment.status == 'booked')
      .toList();

  List<Appointment> get cancelledAppointments => _appointments
      .where((appointment) => appointment.status == 'cancelled')
      .toList();

  List<Appointment> get completedAppointments => _appointments
      .where((appointment) => appointment.status == 'completed')
      .toList();

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

  Future<void> cancelAppointment(String appointmentId, String doctorId,
      String slotId, SlotViewModel slotViewModel) async {
    try {
      await _firestoreService.cancelAppointment(
          appointmentId, doctorId, slotId);

      // Usuń wizytę z listy lokalnej
      _appointments
          .removeWhere((appointment) => appointment.id == appointmentId);

      // Przywróć dostępność slotu i odśwież widok
      await slotViewModel.restoreSlotAvailability(slotId, doctorId);

      notifyListeners(); // Powiadomienie widoku o zmianach
    } catch (e) {
      print('Błąd podczas anulowania wizyty: $e');
    }
  }
}
