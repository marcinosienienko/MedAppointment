import 'package:medical_app/data/models/appointment_model.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentsViewModel extends ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<AppointmentModel> get upcomingAppointments =>
      _appointments.where((a) => a.status == 'nadchodzące').toList();
  List<AppointmentModel> get completedAppointments =>
      _appointments.where((a) => a.status == 'zakończone').toList();
  List<AppointmentModel> get cancelledAppointments =>
      _appointments.where((a) => a.status == 'odwołane').toList();

  // Future<void> fetchAppointments() async {
  //   final snapshot = await _firestore.collection('appointments').get();
  //   _appointments.clear();
  //   for (var doc in snapshot.docs) {
  //     _appointments.add(Appointment(
  //       id: doc.id,
  //       status: doc['status'],
  //       date: (doc['date'] as Timestamp).toDate(),
  //       doctorName: doc['doctorName'],
  //       specializationName: doc['specializationName'],
  //     ));
  //   }
  //   notifyListeners();
  // }
}
