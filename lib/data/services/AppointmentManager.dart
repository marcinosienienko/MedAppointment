// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert'; // Do pracy z JSON
// import '../models/appointment_model.dart';

// void saveAppointmentsToLocal(List<Appointment> appointments) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String jsonString = jsonEncode(
//       appointments.map((appointment) => appointment.toJson()).toList());
//   await prefs.setString('appointments', jsonString);
// }

// Future<List<Appointment>> loadAppointmentsFromLocal() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? jsonString = prefs.getString('appointments');
//   if (jsonString == null) return [];
//   List<dynamic> jsonList = jsonDecode(jsonString);
//   return jsonList
//       .map((json) => Appointment.fromMap(json as Map<String, dynamic>, ''))
//       .toList();
// }
