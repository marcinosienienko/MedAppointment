import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:medical_app/data/services/secure_encryption_service.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SecureEncryptionService _encryptionService = SecureEncryptionService();

  Future<UserModel?> fetchUserData() async {
    const String passPesel = 'uzupełnij numer PESEL';
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data() ?? {};

      if (data.containsKey('pesel') && data['pesel'] is String) {
        try {
          data['pesel'] = await _encryptionService.decryptData(data['pesel']);
        } catch (_) {
          data['pesel'] = passPesel;
        }
      } else {
        data['pesel'] = passPesel;
      }

      return UserModel.fromMap(data, user.uid);
    } catch (e) {
      throw Exception(
          "Nie udało się pobrać danych użytkownika: ${e.toString()}");
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? street,
    String? houseNumber,
    String? apartamentNumber,
    String? city,
    String? pesel,
  }) async {
    try {
      final updatedData = <String, dynamic>{};

      void updateField(String? newValue, String? currentField, String key) {
        if (newValue != null && newValue != currentField) {
          updatedData[key] = newValue;
        }
      }

      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) return;

      final currentUserData = userDoc.data() ?? {};
      updateField(firstName, currentUserData['firstName'], 'firstName');
      updateField(lastName, currentUserData['lastName'], 'lastName');
      updateField(phoneNumber, currentUserData['phoneNumber'], 'phoneNumber');
      updateField(street, currentUserData['street'], 'street');
      updateField(houseNumber, currentUserData['houseNumber'], 'houseNumber');
      updateField(apartamentNumber, currentUserData['apartmentNumber'],
          'apartmentNumber');
      updateField(city, currentUserData['city'], 'city');

      if (pesel != null && pesel.isNotEmpty) {
        try {
          final encryptedPesel = await _encryptionService.encryptData(pesel);
          updateField(encryptedPesel, currentUserData['pesel'], 'pesel');
        } catch (e) {
          throw Exception("Błąd szyfrowania numeru PESEL: ${e.toString()}");
        }
      }

      if (updatedData.isEmpty) {
        return;
      }

      await _firestore.collection('users').doc(userId).update(updatedData);
    } catch (e) {
      throw Exception(
          "Nie udało się zaktualizować danych użytkownika: ${e.toString()}");
    }
  }
}
