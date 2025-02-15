import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor.dart';
import 'package:medical_app/data/models/specialization.dart';

class DoctorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final snapshot = await _db.collection('doctors').get();
      List<Doctor> doctors = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final specializationId = data['specializationId'] as String?;

        Specialization? specialization;
        if (specializationId != null) {
          final specializationDoc = await _db
              .collection('specializations')
              .doc(specializationId)
              .get();

          if (specializationDoc.exists) {
            specialization = Specialization.fromMap(
                specializationDoc.data()!, specializationDoc.id);
          }
        }
        doctors.add(Doctor.fromMap(data, doc.id)
            .copyWith(specialization: specialization));
      }
      return doctors;
    } catch (e) {
      debugPrint('Błąd podczas pobierania lekarzy: $e');
      return [];
    }
  }

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    try {
      final doc = await _db.collection('doctors').doc(doctorId).get();
      if (doc.exists) {
        final data = doc.data();
        if (data == null) return null;

        final specializationId = data['specializationId'] as String?;
        Specialization? specialization;

        if (specializationId != null) {
          final specializationDoc = await _db
              .collection('specializations')
              .doc(specializationId)
              .get();

          if (specializationDoc.exists) {
            specialization = Specialization.fromMap(
                specializationDoc.data()!, specializationDoc.id);
          }
        }

        return Doctor.fromMap(data, doc.id)
            .copyWith(specialization: specialization);
      }
    } catch (e) {
      debugPrint('Błąd pobierania lekarza: $e');
    }
    return null;
  }
}
