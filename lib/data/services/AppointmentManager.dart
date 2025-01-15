import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Do pracy z JSON
import '../models/appointment_model.dart';

class AppointmentManager {
  static const String _key = 'appointments';

  // Odczyt listy wizyt z SharedPreferences
  Future<List<Appointment>> getAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Appointment.fromJson(json)).toList();
  }

  // Zapis listy wizyt do SharedPreferences
  Future<void> saveAppointments(List<Appointment> appointments) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString =
        json.encode(appointments.map((a) => a.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  // Dodanie wizyty do listy
  Future<void> addAppointment(Appointment appointment) async {
    List<Appointment> appointments = await getAppointments();
    appointments.add(appointment);
    await saveAppointments(appointments);
  }
}
