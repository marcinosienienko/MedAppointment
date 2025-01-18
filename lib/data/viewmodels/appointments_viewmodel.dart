import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/services/firestore_service.dart';
import 'package:flutter/material.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  Future<void> fetchAppointments(String userId) async {
    try {
      print('Ładowanie wizyt dla użytkownika: $userId');
      _appointments = await _firestoreService.fetchAppointmentsByUserId(userId);
      print('Załadowano ${_appointments.length} wizyt.');
      notifyListeners(); // Powiadamia UI o zmianach w danych
    } catch (e) {
      print('Błąd podczas pobierania wizyt: $e');
    }
  }

  Future<void> loadAppointmentsFromPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString('appointments');
      if (jsonString != null) {
        List<dynamic> jsonList = json.decode(jsonString);
        _appointments =
            jsonList.map((json) => Appointment.fromJson(json)).toList();
      }
      notifyListeners();
    } catch (e) {
      print('Błąd podczas ładowania wizyt z pamięci lokalnej: $e');
    }
  }

  void _saveAppointmentsToPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString =
          json.encode(_appointments.map((a) => a.toJson()).toList());
      prefs.setString('appointments', jsonString);
    } catch (e) {
      print('Błąd podczas zapisywania wizyt do pamięci lokalnej: $e');
    }
  }

  void cancelAppointment(String appointmentId) {
    _appointments.removeWhere((appointment) => appointment.id == appointmentId);
    _saveAppointmentsToPreferences();
    notifyListeners();
  }
}
