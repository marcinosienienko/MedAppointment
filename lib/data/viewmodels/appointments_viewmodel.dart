import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  final SlotViewModel _slotViewModel;

  AppointmentsViewModel(this._slotViewModel);

  List<Appointment> get appointments => _appointments;

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
    notifyListeners();
  }

  void cancelAppointment(String appointmentId) {
    final appointment = _appointments.firstWhere(
      (appointment) => appointment.id == appointmentId,
      orElse: () => throw Exception('Appointment not found'),
    );

    if (appointment != null) {
      _appointments.remove(appointment);

      // Przekazujemy doctorId razem z slotId do SlotViewModel
      _slotViewModel.restoreSlotAvailability(
        appointment.slotId,
        appointment.doctorId,
      );
    }

    notifyListeners();
  }
}
