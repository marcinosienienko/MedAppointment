import 'package:flutter/material.dart';
import 'package:medical_app/data/models/slot_model.dart';

class SlotViewModel extends ChangeNotifier {
  final List<Slot> allSlots = [];
  List<Slot> filteredSlots = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _currentDoctorId;

  List<Slot> get slots => filteredSlots;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  Slot? _selectedSlot;
  Slot? get selectedSlot => _selectedSlot;
  String? get currentDoctorId => _currentDoctorId;

  SlotViewModel() {
    _generateMockSlots('');
    _filterSlotsForDay(_focusedDay);
  }

  void _filterSlotsForDoctor() {
    if (_currentDoctorId == null) {
      filteredSlots = [];
      print('No doctor selected, clearing slots');
      notifyListeners();
      return;
    }

    filteredSlots =
        allSlots.where((slot) => slot.doctorId == _currentDoctorId).toList();

    print(
        'Filtered slots for doctor $_currentDoctorId: ${filteredSlots.length}');
    if (_selectedDay != null) {
      _filterSlotsForDay(_selectedDay!);
    }
    notifyListeners();
  }

  void setCurrentDoctorId(String doctorId) {
    if (_currentDoctorId == doctorId) return; // Avoid redundant updates
    _currentDoctorId = doctorId;
    print('Current doctor ID set to: $_currentDoctorId');
    _generateMockSlots(doctorId);
    _selectedDay = null;
    resetSelectedSlot();
    _filterSlotsForDay(_focusedDay);
  }

  void _generateMockSlots(String doctorId) {
    if (doctorId.isEmpty) return; // Skip generation if no doctorId provided
    allSlots.removeWhere((slot) => slot.doctorId == doctorId);
    final now = DateTime.now();
    final startHour = 8;
    final endHour = 16;

    for (var i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      if (_isWeekday(date)) {
        for (var hour = startHour; hour < endHour; hour++) {
          for (var minute = 0; minute < 60; minute += 15) {
            allSlots.add(
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
    print('Generated mock slots for doctor $doctorId: ${allSlots.length}');
  }

  void _filterSlotsForDay(DateTime day) {
    if (_currentDoctorId == null) {
      print('No doctor selected, skipping day filter');
      return;
    }

    filteredSlots = allSlots
        .where((slot) =>
            slot.dateTime.year == day.year &&
            slot.dateTime.month == day.month &&
            slot.dateTime.day == day.day &&
            slot.doctorId == _currentDoctorId)
        .toList();

    print(
        'Filtered slots for day ${day.toIso8601String()} and doctor $_currentDoctorId: ${filteredSlots.length}');
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    print('Day selected: $_selectedDay');
    _filterSlotsForDay(selectedDay);
    resetSelectedSlot();
  }

  void selectSlot(Slot slot) {
    if (_selectedSlot == slot) {
      _selectedSlot = null; // Unselect if clicked again
    } else {
      _selectedSlot = slot; // Select a new slot
    }
    print('Selected slot: ${_selectedSlot?.id}');
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = null;
    print('Reset selected slot');
    notifyListeners();
  }

  void reserveSlot(String slotId) {
    if (_currentDoctorId == null || _selectedSlot == null) return;

    final slot = allSlots.firstWhere(
      (slot) => slot.id == slotId && slot.doctorId == _currentDoctorId,
      orElse: () => throw Exception('Slot not found'),
    );

    slot.isAvailable = false; // Mark as reserved
    print('Reserved slot: ${slot.id} for doctor $_currentDoctorId');
    notifyListeners();
  }

  bool _isWeekday(DateTime date) {
    return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
  }
}
