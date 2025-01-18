import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/slot_model.dart';

class SlotViewModel extends ChangeNotifier {
  List<Slot> _allSlots = [];
  List<Slot> _filteredSlots = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Slot? _selectedSlot;

  List<Slot> get slots => _filteredSlots;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  Slot? get selectedSlot => _selectedSlot;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void setSlots(List<Slot> slots) {
    _allSlots = slots;
    _filterSlotsBySelectedDay();
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

  void selectSlot(Slot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }

  Future<bool> reserveSlot(
      String slotId, String doctorId, String userId) async {
    try {
      print('Rozpoczęto rezerwację slotu: $slotId');

      // Aktualizacja slotu w Firestore
      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'status': 'booked'});

      print('Zaktualizowano status slotu.');

      // Dodanie wizyty do Firestore
      final appointment = {
        'doctorId': doctorId,
        'userId': userId,
        'slotId': slotId,
        'dateTime': DateTime.now().toIso8601String(), // Przykładowa data
        'status': 'booked',
      };

      await _db.collection('appointments').add(appointment);
      print('Dodano wizytę do kolekcji appointments.');

      // Lokalna aktualizacja slotów
      _allSlots = _allSlots.map((slot) {
        if (slot.id == slotId) {
          return slot.copyWith(status: 'available');
        }
        return slot;
      }).toList();

      _filterSlotsBySelectedDay();
      notifyListeners();

      return true;
    } catch (e) {
      print('Błąd podczas rezerwacji slotu: $e');
      return false;
    }
  }

  Future<void> setCurrentDoctorId(String doctorId) async {
    try {
      final slots = await fetchSlotsByDoctorId(doctorId);
      setSlots(slots);
    } catch (e) {
      print('Błąd podczas pobierania slotów: $e');
    }
  }

  Future<List<Slot>> fetchSlotsByDoctorId(String doctorId) async {
    try {
      final snapshot = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .get();

      return snapshot.docs
          .map((doc) => Slot.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Błąd podczas pobierania slotów: $e');
      return [];
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> restoreSlotAvailability(String slotId, String doctorId) async {
    try {
      print('Przywracanie dostępności slotu: $slotId dla lekarza: $doctorId');
      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'isAvailable': true});
      print('Dostępność slotu przywrócona.');
    } catch (e) {
      print('Błąd podczas przywracania dostępności slotu: $e');
    }
  }
}
