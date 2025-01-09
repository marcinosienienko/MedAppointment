import 'package:flutter/material.dart';
import 'package:medical_app/data/models/slot_model.dart';

class SlotViewModel extends ChangeNotifier {
  final List<Slot> _allSlots = [];
  List<Slot> _filteredSlots = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Slot> get slots => _filteredSlots;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  Slot? _selectedSlot;
  Slot? get selectedSlot => _selectedSlot;

  SlotViewModel() {
    _generateMockSlots();
    _filterSlotsForDay(_focusedDay);
  }

  void _generateMockSlots() {
    _allSlots.clear();
    final now = DateTime.now();
    final startHour = 8;
    final endHour = 16;

    for (var i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      if (_isWeekday(date)) {
        for (var hour = startHour; hour < endHour; hour++) {
          for (var minute = 0; minute < 60; minute += 15) {
            _allSlots.add(
              Slot(
                id: '${date.toIso8601String()}_${hour}_${minute}',
                dateTime:
                    DateTime(date.year, date.month, date.day, hour, minute),
                doctorId: 'doctor_001',
                isAvailable: true,
              ),
            );
          }
        }
      }
    }
    notifyListeners();
  }

  void _filterSlotsForDay(DateTime day) {
    _filteredSlots = _allSlots
        .where((slot) =>
            slot.dateTime.year == day.year &&
            slot.dateTime.month == day.month &&
            slot.dateTime.day == day.day)
        .toList();
    notifyListeners();
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _filterSlotsForDay(selectedDay);
  }

  void selectSlot(Slot slot) {
    _selectedSlot = slot;
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
