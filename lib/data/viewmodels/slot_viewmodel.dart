import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/slot_repository.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/slot_model.dart';
import '../models/doctor.dart';

class SlotViewModel extends ChangeNotifier {
  final SlotRepository _slotRepository = SlotRepository();

  List<Slot> _allSlots = [];
  List<Slot> _filteredSlots = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Slot? _selectedSlot;
  Doctor? _currentDoctor;

  List<Slot> get slots => _filteredSlots;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  Slot? get selectedSlot => _selectedSlot;
  Doctor? get currentDoctor => _currentDoctor;

  void setSlots(List<Slot> slots) {
    _allSlots = slots;
    _filterSlotsBySelectedDay();
  }

  void toggleSlotSelection(Slot slot) {
    if (_selectedSlot == slot) {
      _selectedSlot = null;
    } else {
      _selectedSlot = slot;
    }
    notifyListeners();
  }

  void clearSelectedSlot() {
    _selectedSlot = null;
    notifyListeners();
  }

  bool isSlotAvailable(Slot slot) {
    return slot.status == 'available';
  }

  void selectSlot(Slot slot) {
    if (!isSlotAvailable(slot)) return;
    _selectedSlot = slot;
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _filterSlotsBySelectedDay();
    notifyListeners();
  }

  void _filterSlotsBySelectedDay() {
    _filteredSlots = _allSlots.where((slot) {
      DateTime slotDate = DateTime.parse(slot.date);
      return isSameDay(slotDate, _selectedDay);
    }).toList();
  }

  Future<void> setCurrentDoctorId(String doctorId) async {
    _currentDoctor = await _slotRepository.fetchDoctorById(doctorId);
    final slots = await _slotRepository.fetchSlotsByDoctorId(doctorId);
    setSlots(slots);
    notifyListeners();
  }

  // bool isSameDay(DateTime date1, DateTime date2) {
  //   return date1.year == date2.year &&
  //       date1.month == date2.month &&
  //       date1.day == date2.day;
  // }

  Future<void> restoreSlotAvailalility(String slotId, String doctorId) async {
    await _slotRepository.restoreSlotAvailability(slotId, doctorId);
    _allSlots = _allSlots.map((slot) {
      if (slot.id == slotId) {
        return slot.copyWith(status: 'available');
      }
      return slot;
    }).toList();
    _filterSlotsBySelectedDay();
    notifyListeners();
  }

  // Future<bool> handleAppointmentReservation(
  //     BuildContext context, String userId, String doctorId) async {
  //   if (selectedSlot == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           content: Text('Wybierz dodstępną godzinę przed rezerwacją.')),
  //     );
  //     return false;
  //   }

  //   final confirm = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Potwierdź rezerwację'),
  //       content: Text('Czy na pewno chcesz zarezerwować wizytę?'),
  //       actions: [
  //         TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: const Text('Anuluj')),
  //         TextButton(
  //             onPressed: () => Navigator.pop(context, true),
  //             child: const Text('Potwierdź')),
  //       ],
  //     ),
  //   );

  //   if (confirm == true) {
  //     final success = await reserveSlot(selectedSlot!.id, doctorId, userId);
  //     final message = success
  //         ? 'Wizyta zarezerwowana!'
  //         : 'Nie udało się zarezerwować wizyty.';

  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(message)));
  //     return success;
  //   }

  //   return false;
  // }
}
