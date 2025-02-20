import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medical_app/data/services/secure_encryption_service.dart';

class UserViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _encryptionService = SecureEncryptionService();

  UserModel? _currentUser;
  final peselController = TextEditingController();

  UserModel? get currentUser => _currentUser;

  Future<void> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return;

      final data = doc.data()!;
      if (data['pesel'] != null) {
        try {
          data['pesel'] = await _encryptionService.decryptData(data['pesel']);
        } catch (_) {
          data['pesel'] = '';
        }
      }

      _currentUser = UserModel.fromMap(data, user.uid);
      peselController.text = _currentUser?.pesel ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint("Błąd pobierania danych użytkownika: $e");
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? street,
    String? houseNumber,
    String? apartmentNumber,
    String? city,
    String? pesel,
  }) async {
    try {
      if (_currentUser == null) return;

      final updatedData = <String, dynamic>{};

      void updateField(String? newValue, String? currentField, String key) {
        if (newValue != null && newValue != currentField) {
          updatedData[key] = newValue;
        }
      }

      updateField(firstName, _currentUser!.firstName, 'firstName');
      updateField(lastName, _currentUser!.lastName, 'lastName');
      updateField(phoneNumber, _currentUser!.phoneNumber, 'phoneNumber');
      updateField(street, _currentUser!.street, 'street');
      updateField(houseNumber, _currentUser!.houseNumber, 'houseNumber');
      updateField(
          apartmentNumber, _currentUser!.apartmentNumber, 'apartmentNumber');
      updateField(city, _currentUser!.city, 'city');

      if (pesel != null && pesel.isNotEmpty) {
        try {
          final encryptedPesel = await _encryptionService.encryptData(pesel);
          if (encryptedPesel != _currentUser!.pesel) {
            updatedData['pesel'] = encryptedPesel;
          }
        } catch (e) {
          debugPrint("Błąd szyfrowania PESEL: $e");
        }
      }

      if (updatedData.isEmpty) return;

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updatedData);
      _currentUser = UserModel.fromMap(
          {..._currentUser!.toMap(), ...updatedData}, _currentUser!.id);
      notifyListeners();
    } catch (e) {
      debugPrint("Błąd aktualizacji danych użytkownika: $e");
    }
  }

  @override
  void dispose() {
    peselController.dispose();
    super.dispose();
  }
}

// to do 
/*  import 'package:flutter/material.dart';
import '../../../core/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _currentUser;
  final peselController = TextEditingController();

  UserModel? get currentUser => _currentUser;

  UserViewModel(this._userRepository);

  Future<void> fetchUserData() async {
    try {
      _currentUser = await _userRepository.fetchUserData();
      peselController.text = _currentUser?.pesel ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint("Błąd pobierania użytkownika: $e");
    }
  }

  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? street,
    String? houseNumber,
    String? apartmentNumber,
    String? city,
    String? pesel,
  }) async {
    try {
      if (_currentUser == null) return;
      await _userRepository.updateUserProfile(
        userId: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        street: street,
        houseNumber: houseNumber,
        apartmentNumber: apartmentNumber,
        city: city,
        pesel: pesel,
      );
      await fetchUserData(); // Odśwież dane po aktualizacji
    } catch (e) {
      debugPrint("Błąd aktualizacji użytkownika: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _userRepository.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Błąd wylogowania: $e");
    }
  }

  @override
  void dispose() {
    peselController.dispose();
    super.dispose();
  }
}
void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => AuthRepository()),
        Provider(create: (context) => UserRepository()),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UserViewModel(context.read<UserRepository>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}






*/