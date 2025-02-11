import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/appointment_repository.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentsViewModel extends ChangeNotifier {
  // final FirestoreService _firestoreService = FirestoreService();

  final AppointmentRepository _repository = AppointmentRepository();

  List<Appointment> _appointments = [];
  List<Appointment> get appointments => _appointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // List<Appointment> get upcomingAppointments => _appointments
  //     .where((appointment) => appointment.status == 'booked')
  //     .toList();

  // List<Appointment> get cancelledAppointments => _appointments
  //     .where((appointment) => appointment.status == 'cancelled')
  //     .toList();

  // List<Appointment> get completedAppointments => _appointments
  //     .where((appointment) => appointment.status == 'completed')
  //     .toList();

  Future<bool> reserveAppointment(
      {required String slotId,
      required String doctorId,
      required String userId}) async {
    final success = await _repository.createAppointment(
      slotId: slotId,
      doctorId: doctorId,
      userId: userId,
    );

    if (success) {
      await fetchAppointments(userId);
      notifyListeners();
    }
    return success;
  }

  Future<void> fetchAppointments(String patientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointments(patientId);
    } catch (e) {
      debugPrint('Błąd podczas pobierania wizyt: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(
      {required String appointmentId,
      required String doctorId,
      required String slotId}) async {
    try {
      await _repository.cancelAppointment(
          appointmentId: appointmentId, doctorId: doctorId, slotId: slotId);

      appointments
          .removeWhere((appointment) => appointment.id == appointmentId);
    } catch (e) {
      print('Błąd podczas odwoływania wizyty: $e');
    }
  }
}
