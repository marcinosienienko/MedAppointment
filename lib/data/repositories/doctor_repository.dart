import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor.dart';
import 'package:medical_app/data/models/slot_model.dart';
import 'package:medical_app/data/models/specialization.dart';

class DoctorRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Doctor>> fetchDoctors() async {
    try {
      final snapshot = await _db.collection('doctors').get();
      List<Doctor> doctors = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final specialization =
            await _fetchSpecialization(data['specializationId']);

        doctors.add(Doctor.fromMap(data, doc.id)
            .copyWith(specialization: specialization));
      }

      return doctors;
    } catch (e, stackTrace) {
      debugPrint('Błąd podczas pobierania lekarzy: $e');
      debugPrint(stackTrace.toString());
      return [];
    }
  }

  Future<Slot?> fetchSlotDetails(String doctorId, String slotId) async {
    try {
      final doc = await _db
          .collection('doctors')
          .doc(doctorId)
          .collection('slots')
          .doc(slotId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Slot.fromMap(doc.data()!, doc.id);
      } else {
        debugPrint(
            'Slot $slotId nie istnieje w bazie danych lekarza $doctorId');
      }
    } catch (e, stackTrace) {
      debugPrint('Błąd podczas pobierania szczegółów slotu: $slotId: $e');
      debugPrint(stackTrace.toString());
    }
    return null;
  }

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    try {
      final doc = await _db.collection('doctors').doc(doctorId).get();
      if (!doc.exists || doc.data() == null) {
        debugPrint('Nie znaleziono lekarza o id: $doctorId');
        return null;
      }

      final data = doc.data()!;
      final specialization =
          await _fetchSpecialization(data['specializationId']);

      return Doctor.fromMap(data, doc.id)
          .copyWith(specialization: specialization);
    } catch (e, stackTrace) {
      debugPrint('Błąd podczas pobierania lekarza: $doctorId: $e');
      debugPrint(stackTrace.toString());
      return null;
    }
  }

  Future<Specialization?> _fetchSpecialization(String? specializationId) async {
    if (specializationId == null || specializationId.isEmpty) return null;

    try {
      final doc =
          await _db.collection('specializations').doc(specializationId).get();

      if (doc.exists && doc.data() != null) {
        return Specialization.fromMap(doc.data()!, doc.id);
      }
    } catch (e, stackTrace) {
      debugPrint(
          'Błąd podczas pobierania specjalizacji: $specializationId: $e ');
      debugPrint(stackTrace.toString());
    }
    return null;
  }
}
