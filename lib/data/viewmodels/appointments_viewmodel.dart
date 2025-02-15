import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/appointment_repository.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/presentation/widgets/confirmation_dialog.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> reserveAppointment({
    required String slotId,
    required String doctorId,
    required String userId,
  }) async {
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

  Future<void> cancelAppointment({
    required String appointmentId,
    required String doctorId,
    required String slotId,
  }) async {
    try {
      await _repository.cancelAppointment(
        appointmentId: appointmentId,
        doctorId: doctorId,
        slotId: slotId,
      );

      // Usunięcie wizyty z lokalnej listy
      _appointments
          .removeWhere((appointment) => appointment.id == appointmentId);
      notifyListeners();
    } catch (e) {
      print('Błąd podczas odwoływania wizyty: $e');
    }
  }

  Future<void> handleAppointmentReservation(
      BuildContext context, String userId, SlotViewModel slotViewModel) async {
    if (slotViewModel.selectedSlot == null ||
        !slotViewModel.isSlotAvailable(slotViewModel.selectedSlot!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wybierz godzinę przed rezerwacją.')),
      );
      return;
    }

    if (slotViewModel.currentDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Dane lekarza nie są załadowane. Spróbuj ponownie.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        slot: slotViewModel.selectedSlot!,
        doctorName: slotViewModel.currentDoctor?.name ?? '',
        specialization: slotViewModel.currentDoctor?.specialization?.name ?? '',
        date: slotViewModel.selectedDay.toString(),
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      final success = await reserveAppointment(
        slotId: slotViewModel.selectedSlot!.id,
        doctorId: slotViewModel.currentDoctor!.id,
        userId: userId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wizyta zarezerwowana!')),
        );
        await fetchAppointments(userId);
      } else {
        throw Exception('Błąd podczas rezerwacji');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: ${e.toString()}')),
      );
    }
  }
}
