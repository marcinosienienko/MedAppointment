import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/appointment_repository.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/repositories/doctor_repository.dart';
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

  Future<void> fetchAppointments(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Appointment> fetchedAppointments =
          await _repository.getAppointments(userId);
      final doctorRepo = DoctorRepository();

      List<Appointment> updatedAppointments = [];

      for (var appointment in fetchedAppointments) {
        final doctor = await doctorRepo.fetchDoctorById(appointment.doctorId!);
        if (doctor != null) {
          final updatedAppointment = appointment.copyWith(
            doctorName: doctor.name,
            specialization: doctor.specialization?.name ?? 'Brak specjalizacji',
          );
          updatedAppointments.add(updatedAppointment);
        } else {
          updatedAppointments.add(appointment);
        }
      }

      _appointments = updatedAppointments;
    } catch (e) {
      debugPrint('❌ Błąd podczas pobierania wizyt: $e');
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
    // ✅ Sprawdzenie, czy użytkownik wybrał slot
    if (slotViewModel.selectedSlot == null ||
        !slotViewModel.isSlotAvailable(slotViewModel.selectedSlot!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Wybierz dostępny slot przed rezerwacją.')),
      );
      return;
    }

    // ✅ Sprawdzenie, czy załadowano lekarza
    if (slotViewModel.currentDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Dane lekarza nie są załadowane. Spróbuj ponownie.')),
      );
      return;
    }

    // ✅ Sprawdzenie, czy lekarz ma poprawne ID
    if (slotViewModel.currentDoctor!.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd: Brak identyfikatora lekarza.')),
      );
      return;
    }

    // ✅ Sprawdzenie, czy slot ma poprawne ID
    if (slotViewModel.selectedSlot!.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd: Brak identyfikatora slotu.')),
      );
      return;
    }

    // ✅ Wyświetlenie dialogu z potwierdzeniem
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        slot: slotViewModel.selectedSlot!,
        doctorName: slotViewModel.currentDoctor!.name,
        specialization: slotViewModel.currentDoctor!.specialization?.name ??
            'Brak specjalizacji',
        date: slotViewModel.selectedDay.toString(),
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      // ✅ Próba rezerwacji wizyty
      final success = await reserveAppointment(
        slotId: slotViewModel.selectedSlot!.id,
        doctorId: slotViewModel.currentDoctor!.id,
        userId: userId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wizyta zarezerwowana!')),
        );
        await fetchAppointments(userId);
      } else {
        throw Exception('Nie udało się zarezerwować wizyty.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: ${e.toString()}')),
      );
    }
  }
}
