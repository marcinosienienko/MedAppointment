import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/viewmodels/slot_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final SlotViewModel? slotViewModel;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Appointment> _appointments = [];
  AppointmentsViewModel(this.slotViewModel); // Konstruktor z parametrem

  List<Appointment> get appointments => _appointments;

  Future<void> addAppointment(Appointment appointment, String userId) async {
    if (_appointments.any((existing) => existing.id == appointment.id)) {
      print('Wizyta już istnieje: ${appointment.id}');
      return;
    }

    _appointments.add(appointment);
    print('Dodano wizytę: ${appointment.toJson()}');

    // Upewnij się, że slot jest zarezerwowany
    if (slotViewModel != null) {
      slotViewModel!.reserveSlot(appointment.slotId);
    } else {
      print('SlotViewModel jest niedostępny!');
    }

    await _saveToPreferences();

    // Zapisz w Firestore
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set({...appointment.toJson(), 'userId': userId});
      print('Wizyta zapisana w Firestore: ${appointment.id}');
    } catch (e) {
      print('Błąd zapisu do Firestore: $e');
    }

    notifyListeners();
  }

  Future<void> cancelAppointment(String id) async {
    final appointment = _appointments.firstWhere(
      (appointment) => appointment.id == id,
      orElse: () => throw Exception('Appointment not found'),
    );

    if (appointment != null) {
      _appointments.remove(appointment);
      print('Anulowano wizytę: $id');

      // Odblokuj slot
      slotViewModel?.restoreSlotAvailability(
        appointment.slotId,
        appointment.doctorId,
      );

      await _saveToPreferences();
      await _firestore.collection('appointments').doc(id).delete();
      notifyListeners();
    } else {
      print('Nie znaleziono wizyty o ID: $id');
    }
  }

  Future<void> loadAppointmentsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appointmentsJson = prefs.getString('appointments');
    if (appointmentsJson != null && appointmentsJson.isNotEmpty) {
      List<dynamic> decoded = json.decode(appointmentsJson);
      _appointments =
          decoded.map((data) => Appointment.fromJson(data)).toList();

      // Aktualizuj stan slotów
      for (var appointment in _appointments) {
        slotViewModel?.reserveSlot(appointment.slotId);
      }

      print('Załadowane wizyty: $_appointments');
    } else {
      _appointments = [];
      print('Brak zapisanych wizyt w SharedPreferences');
    }
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> appointmentsJson =
        _appointments.map((appointment) => appointment.toJson()).toList();
    await prefs.setString('appointments', json.encode(appointmentsJson));
  }
}
