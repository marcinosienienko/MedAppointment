import 'package:flutter/material.dart';
import 'package:medical_app/data/models/slot_model.dart';

class SlotViewModel extends ChangeNotifier {
  final Map<String, List<Slot>> doctorSlots =
      {}; // Mapa dla slotów każdego lekarza
  List<Slot> filteredSlots = [];
  String? _currentDoctorId;
  Slot? _selectedSlot;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Slot> get slots => filteredSlots;
  Slot? get selectedSlot => _selectedSlot;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void setCurrentDoctorId(String doctorId) {
    _currentDoctorId = doctorId;

    // Generowanie slotów, jeśli jeszcze nie istnieją
    if (!doctorSlots.containsKey(doctorId)) {
      _generateMockSlots(doctorId);
    }

    // Filtruj sloty dla wybranego lekarza
    _filterSlotsForDay(DateTime.now());
  }

  void _generateMockSlots(String doctorId) {
    if (doctorSlots.containsKey(doctorId)) return;

    final List<Slot> slots = [];
    final now = DateTime.now();
    final startHour = 8;
    final endHour = 16;

    for (var i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      if (_isWeekday(date)) {
        for (var hour = startHour; hour < endHour; hour++) {
          for (var minute = 0; minute < 60; minute += 15) {
            slots.add(
              Slot(
                id: '${doctorId}_${date.toIso8601String()}_${hour}_${minute}',
                dateTime:
                    DateTime(date.year, date.month, date.day, hour, minute),
                doctorId: doctorId,
                isAvailable: true,
              ),
            );
          }
        }
      }
    }

    doctorSlots[doctorId] = slots;
    notifyListeners();
  }

  // void _filterSlotsForDoctor() {
  //   if (_currentDoctorId == null ||
  //       !doctorSlots.containsKey(_currentDoctorId)) {
  //     filteredSlots = [];
  //   } else {
  //     filteredSlots = doctorSlots[_currentDoctorId]!;
  //   }
  //   notifyListeners();
  // }
  void _filterSlotsForDay(DateTime selectedDay) {
    if (_currentDoctorId == null ||
        !doctorSlots.containsKey(_currentDoctorId)) {
      filteredSlots = [];
      print('No slots available for selected doctor');
      return;
    }

    final allSlotsForDoctor = doctorSlots[_currentDoctorId]!;

    // Filtrowanie slotów dla wybranego dnia
    filteredSlots = allSlotsForDoctor.where((slot) {
      return slot.dateTime.year == selectedDay.year &&
          slot.dateTime.month == selectedDay.month &&
          slot.dateTime.day == selectedDay.day;
    }).toList();

    print(
        'Filtered slots for day $selectedDay for doctor $_currentDoctorId: ${filteredSlots.length}');
    notifyListeners();
  }

  void selectSlot(Slot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _filterSlotsForDay(selectedDay);
    // Optionally, filter slots for the selected day
    notifyListeners();
  }

  void reserveSlot(String slotId) {
    final slots = doctorSlots[_currentDoctorId];
    if (slots == null) return;

    final slot = slots.firstWhere((slot) => slot.id == slotId,
        orElse: () => throw Exception('Slot not found'));
    slot.isAvailable = false;
    notifyListeners();
  }

  void restoreSlotAvailability(String slotId, String doctorId) {
    if (!doctorSlots.containsKey(doctorId)) return;

    final slots = doctorSlots[doctorId];
    if (slots == null) return;

    final slot = slots.firstWhere((slot) => slot.id == slotId,
        orElse: () => throw Exception('Slot not found'));
    slot.isAvailable = true;
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = null;
    notifyListeners();
  }

  bool _isWeekday(DateTime date) {
    return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
  }
}
