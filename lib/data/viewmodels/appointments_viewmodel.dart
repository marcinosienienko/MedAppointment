import 'package:flutter/material.dart';
import 'package:medical_app/data/models/slot_model.dart';
import 'package:medical_app/data/repositories/appointment_repository.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/repositories/doctor_repository.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:medical_app/presentation/widgets/confirmation_dialog.dart';
import 'package:provider/provider.dart';

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
        if (appointment.doctorId == null || appointment.slotId == null) {
          debugPrint("Brak doctorId lub slotId dla wizyty: ${appointment.id}");
          updatedAppointments.add(appointment);
          continue;
        }

        // Pobierz lekarza i slot
        final doctor = await doctorRepo.fetchDoctorById(appointment.doctorId!);
        final slot = await doctorRepo.fetchSlotDetails(
            appointment.doctorId!, appointment.slotId!);
        debugPrint("Pobieranie slotu: ${appointment.slotId}");
        debugPrint("Slot startTime: ${slot?.startTime}");

        final updatedAppointment = appointment.copyWith(
          doctorName: doctor?.name ?? "Nieznany lekarz",
          specialization: doctor?.specialization?.name ?? "Brak specjalizacji",
          date: slot?.date,
          startTime: slot?.startTime,
        );

        updatedAppointments.add(updatedAppointment);
      }

      _appointments = updatedAppointments;
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

      // Usuń odwołaną wizytę z lokalnej listy
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
        const SnackBar(
            content: Text('Wybierz dostępny slot przed rezerwacją.')),
      );
      return;
    }

    if (slotViewModel.currentDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Dane lekarza nie są załadowane. Spróbuj ponownie.')),
      );
      return;
    }

    if (slotViewModel.currentDoctor!.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd: Brak identyfikatora lekarza.')),
      );
      return;
    }

    if (slotViewModel.selectedSlot!.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd: Brak identyfikatora slotu.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Potwierdź rezerwację',
        message: 'Czy na pewno chcesz zarezerwować wizytę?',
        isCancellation: false,
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

  Future<void> handleAppointmentCancelation(
      BuildContext context,
      Appointment appointment,
      String userId,
      SlotViewModel slotViewModel) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Anulowanie wizyty',
        message: 'Czy na pewno chcesz anulować wizytę?',
        isCancellation: true,
        doctorName: appointment.doctorName ?? '',
        specialization: appointment.specialization ?? 'Brak specjalizacji',
        slot: Slot(
          id: appointment.slotId?.toString() ?? 'Brak slotId',
          date: appointment.date ?? 'Brak daty',
          startTime: appointment.startTime ?? 'Brak godziny',
          endTime: appointment.endTime ?? 'Brak godziny',
          status: 'available',
        ),
        date: '',
      ),
    );

    if (confirm != true) return;

    try {
      final appointmentsViewModel =
          Provider.of<AppointmentsViewModel>(context, listen: false);

      await appointmentsViewModel.cancelAppointment(
        appointmentId: appointment.id,
        doctorId: appointment.doctorId!,
        slotId: appointment.slotId!,
      );

      await appointmentsViewModel.fetchAppointments(userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wizyta została anulowana.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd podczas anulowania: ${e.toString()}')),
      );
    }
  }
}
