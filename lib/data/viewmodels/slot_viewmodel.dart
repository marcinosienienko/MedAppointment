import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/slot_model.dart';
import '../models/doctor.dart';
import '../models/specialization.dart';

class SlotViewModel extends ChangeNotifier {
  List<Slot> _allSlots = [];
  List<Slot> _filteredSlots = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Slot? _selectedSlot;
  Doctor? _currentDoctor;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<Slot> get slots => _filteredSlots;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  Slot? get selectedSlot => _selectedSlot;
  Doctor? get currentDoctor => _currentDoctor;

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
      await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .update({'status': 'booked'});

      final appointment = {
        'doctorName': doctorId,
        'userId': userId,
        'slotId': slotId,
        'dateTime': DateTime.now().toIso8601String(),
        'status': 'booked',
      };

      await _db.collection('appointments').add(appointment);

      _allSlots = _allSlots.map((slot) {
        if (slot.id == slotId) {
          return slot.copyWith(status: 'booked');
        }
        return slot;
      }).toList();

      _filterSlotsBySelectedDay();
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> setCurrentDoctorId(String doctorId) async {
    try {
      _currentDoctor = await fetchDoctorById(doctorId);
      final slots = await fetchSlotsByDoctorId(doctorId);
      setSlots(slots);
      notifyListeners();
    } catch (e) {
      debugPrint('Błąd podczas pobierania danych lekarza: $e');
    }
  }

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    try {
      final doctorDoc = await _db.collection('doctors').doc(doctorId).get();
      if (doctorDoc.exists) {
        final doctorData = doctorDoc.data()!;
        final specializationId = doctorData['specializationId'];

        Specialization? specialization;
        if (specializationId != null && specializationId.isNotEmpty) {
          final specializationDoc = await _db
              .collection('specializations')
              .doc(specializationId)
              .get();

          if (specializationDoc.exists) {
            specialization = Specialization.fromMap(
              specializationDoc.data()!,
              specializationDoc.id,
            );
          }
        }

        return Doctor.fromMap(doctorData, doctorDoc.id).copyWith(
          specialization: specialization,
        );
      }
    } catch (e) {
      print('Błąd podczas pobierania danych lekarza: $e');
    }
    return null;
  }

  Future<bool> confirmReservation(
      BuildContext context, String userId, String doctorId) async {
    if (selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wybierz slot przed rezerwacją.')),
      );
      return false;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potwierdź rezerwację'),
        content: Text('Czy na pewno chcesz zarezerwować wizytę?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Anuluj')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Potwierdź')),
        ],
      ),
    );

    if (confirm == true) {
      final success = await reserveSlot(selectedSlot!.id, doctorId, userId);
      final message = success
          ? 'Wizyta zarezerwowana!'
          : 'Nie udało się zarezerwować wizyty.';

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return success;
    }

    return false;
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
          .update({'status': 'available'});
      print('Dostępność slotu przywrócona.');

      // Lokalna aktualizacja stanu slotów
      _allSlots = _allSlots.map((slot) {
        if (slot.id == slotId) {
          return slot.copyWith(status: 'available');
        }
        return slot;
      }).toList();

      _filterSlotsBySelectedDay();
      notifyListeners();
    } catch (e) {
      print('Błąd podczas przywracania dostępności slotu: $e');
      throw e;
    }
  }
}
