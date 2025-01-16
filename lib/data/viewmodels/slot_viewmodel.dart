import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_app/data/models/slot_model.dart';

class SlotViewModel extends ChangeNotifier {
  final Map<String, List<Slot>> doctorSlots = {};
  List<Slot> filteredSlots = [];
  String? _currentDoctorId;
  Slot? _selectedSlot;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<Slot> get slots => filteredSlots;
  Slot? get selectedSlot => _selectedSlot;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void setCurrentDoctorId(String doctorId) async {
    _currentDoctorId = doctorId;

    if (!doctorSlots.containsKey(doctorId)) {
      _generateMockSlots(doctorId);
    }

    // Load slots state from preferences
    await _loadSlotsFromPreferences();

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

  void _filterSlotsForDay(DateTime selectedDay) {
    if (_currentDoctorId == null ||
        !doctorSlots.containsKey(_currentDoctorId)) {
      filteredSlots = [];
      print('Filtered slots: [] (no doctor ID or no slots)');
      return;
    }

    final allSlotsForDoctor = doctorSlots[_currentDoctorId]!;

    filteredSlots = allSlotsForDoctor.where((slot) {
      return slot.dateTime.year == selectedDay.year &&
          slot.dateTime.month == selectedDay.month &&
          slot.dateTime.day == selectedDay.day;
    }).toList();

    print(
        'Filtered slots for day $selectedDay: ${filteredSlots.map((s) => s.id).toList()}');
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
    notifyListeners();
  }

  void reserveSlot(String slotId) {
    if (_currentDoctorId == null) return;

    final slots = doctorSlots[_currentDoctorId];
    if (slots == null) return;

    final slot = slots.firstWhere((slot) => slot.id == slotId,
        orElse: () => throw Exception('Slot not found'));
    slot.isAvailable = false;

    _saveSlotsToPreferences(); // Save changes
    notifyListeners();
  }

  void restoreSlotAvailability(String slotId, String doctorId) {
    if (!doctorSlots.containsKey(doctorId)) {
      print('Doctor ID $doctorId not found in doctorSlots');
      return;
    }

    final slots = doctorSlots[doctorId];
    if (slots == null) {
      print('No slots found for Doctor ID $doctorId');
      return;
    }

    final slot = slots.firstWhere(
      (slot) => slot.id == slotId,
      orElse: () {
        print('Slot ID $slotId not found for Doctor ID $doctorId');
        return Slot(
            id: '', dateTime: DateTime.now(), doctorId: '', isAvailable: true);
      },
    );

    if (slot.id.isNotEmpty) {
      print(
          'Before restoring: Slot ID: ${slot.id}, isAvailable: ${slot.isAvailable}');
      slot.isAvailable = true;
      print(
          'After restoring: Slot ID: ${slot.id}, isAvailable: ${slot.isAvailable}');

      // Zaktualizuj listę filtrowanych slotów i powiadom UI
      _filterSlotsForDay(_selectedDay ?? _focusedDay);
      notifyListeners();

      // Zapisz zmiany w SharedPreferences
      _saveSlotsToPreferences();
    } else {
      print('Failed to restore slot $slotId for Doctor ID $doctorId');
    }
  }

  Future<void> _saveSlotsToPreferences() async {
    if (_currentDoctorId == null) return;

    final slots = doctorSlots[_currentDoctorId];
    if (slots == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> slotsJson =
        slots.map((slot) => slot.toJson()).toList();
    await prefs.setString('slots_${_currentDoctorId!}', json.encode(slotsJson));

    print('Saved slots for Doctor ID $_currentDoctorId:');
    for (var slot in slots) {
      print('Slot ID: ${slot.id}, isAvailable: ${slot.isAvailable}');
    }
  }

  Future<void> _loadSlotsFromPreferences() async {
    if (_currentDoctorId == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? slotsJson = prefs.getString('slots_${_currentDoctorId!}');
    if (slotsJson != null) {
      List<dynamic> decoded = json.decode(slotsJson);
      doctorSlots[_currentDoctorId!] =
          decoded.map((data) => Slot.fromJson(data)).toList();

      print('Loaded slots for Doctor ID $_currentDoctorId:');
      for (var slot in doctorSlots[_currentDoctorId!]!) {
        print('Slot ID: ${slot.id}, isAvailable: ${slot.isAvailable}');
      }
    } else {
      print(
          'No slots found for Doctor ID $_currentDoctorId in SharedPreferences');
    }
    notifyListeners();
  }

  bool _isWeekday(DateTime date) {
    return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
  }

  // Future<void> saveSlotsToPreferences() async {
  //   if (_currentDoctorId == null) return;

  //   final slots = doctorSlots[_currentDoctorId];
  //   if (slots == null) return;

  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<Map<String, dynamic>> slotsJson =
  //       slots.map((slot) => slot.toJson()).toList();
  //   await prefs.setString('slots_${_currentDoctorId!}', json.encode(slotsJson));
  // }
}
