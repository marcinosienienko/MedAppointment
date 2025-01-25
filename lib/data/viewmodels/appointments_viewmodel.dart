import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/firestore_service.dart';
import '../viewmodels/slot_viewmodel.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;
  Future<Appointment?> fetchNextAppointment(String userId) async {
    try {
      final snapshot =
          await _firestoreService.fetchAppointmentsByUserId(userId);

      if (snapshot.isNotEmpty) {
        // Filtruj tylko przyszłe wizyty
        final now = DateTime.now();
        final upcomingAppointments = snapshot
            .where((appointment) =>
                appointment.date != null &&
                DateTime.parse(appointment.date!).isAfter(now))
            .toList();

        // Posortuj wizyty rosnąco według daty
        upcomingAppointments.sort((a, b) =>
            DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));

        // Zwróć najbliższą wizytę
        return upcomingAppointments.isNotEmpty
            ? upcomingAppointments.first
            : null;
      }
      return null;
    } catch (e) {
      print('Błąd podczas pobierania najbliższej wizyty: $e');
      return null;
    }
  }

  Future<void> fetchAppointments(String userId) async {
    try {
      print('Ładowanie wizyt dla użytkownika: $userId');
      _appointments = await _firestoreService.fetchAppointmentsByUserId(userId);

      // Dodaj debug print aby sprawdzić format daty
      for (var appointment in _appointments) {
        print('Appointment date: ${appointment.date}');
      }

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
