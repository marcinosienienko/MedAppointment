import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_app/data/models/doctor.dart';
import 'package:medical_app/data/models/slot_model.dart';
import 'package:medical_app/data/models/specialization.dart';

class SlotRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    final doctorDoc = await _db.collection('doctors').doc(doctorId).get();
    if (!doctorDoc.exists) return null;

    final data = doctorDoc.data()!;
    final specializationId = data['specializationId'];

    Specialization? specialization;
    if (specializationId != null && specializationId.isNotEmpty) {
      final specializationDoc =
          await _db.collection('specializations').doc(specializationId).get();
      if (specializationDoc.exists) {
        specialization = Specialization.fromMap(
            specializationDoc.data()!, specializationDoc.id);
      }
    }

    return Doctor.fromMap(data, doctorDoc.id)
        .copyWith(specialization: specialization);
  }

  Future<List<Slot>> fetchSlotsByDoctorId(String doctorId) async {
    final snapshot =
        await _db.collection('doctors').doc(doctorId).collection('slots').get();
    return snapshot.docs
        .map((doc) => Slot.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> restoreSlotAvailability(String slotId, String doctorId) async {
    await _db
        .collection('doctors')
        .doc(doctorId)
        .collection('slots')
        .doc(slotId)
        .update({'status': 'available'});
  }
}
