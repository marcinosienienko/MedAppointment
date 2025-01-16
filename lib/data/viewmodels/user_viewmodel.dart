import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class UserViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String encryptionKey = '0123456789abcdef0123456789abcdef';
  final _encrypter =
      encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptionKey)));
  final _iv = encrypt.IV.fromUtf8('abcdefghijklmnop'); // Inicjalizacyjny wektor

  UserModel? _currentUser;
  final TextEditingController peselController = TextEditingController();

  UserModel? get currentUser => _currentUser;

  /// Pobieranie danych użytkownika z Firestore
  Future<void> fetchUserData() async {
    try {
      print("Rozpoczynam pobieranie danych użytkownika");

      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          if (data['pesel'] != null) {
            try {
              final decryptedPesel = _decryptPesel(data['pesel']);
              data['pesel'] = decryptedPesel; // Odszyfrowany PESEL
            } catch (e) {
              print("Błąd odszyfrowywania PESEL: $e");
              data['pesel'] = ''; // Opcjonalnie ustaw pustą wartość
            }
          }
          _currentUser = UserModel.fromMap(data, user.uid);
          // Przypisz odszyfrowany PESEL do kontrolera
          peselController.text = _currentUser?.pesel ?? '';
        } else {
          print("Dane użytkownika nie istnieją w Firestore.");
        }
      } else {
        print("Użytkownik niezalogowany.");
      }
    } catch (e) {
      print("Błąd podczas pobierania danych użytkownika: $e");
    } finally {
      notifyListeners();
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
      if (_currentUser == null) {
        print("Użytkownik niezalogowany. Nie można zaktualizować danych.");
        return;
      }

      final updatedData = <String, dynamic>{};

      if (firstName != null && firstName != _currentUser!.firstName) {
        updatedData['firstName'] = firstName;
      }
      if (lastName != null && lastName != _currentUser!.lastName) {
        updatedData['lastName'] = lastName;
      }
      if (phoneNumber != null && phoneNumber != _currentUser!.phoneNumber) {
        updatedData['phoneNumber'] = phoneNumber;
      }
      if (street != null && street != _currentUser!.street) {
        updatedData['street'] = street;
      }
      if (houseNumber != null && houseNumber != _currentUser!.houseNumber) {
        updatedData['houseNumber'] = houseNumber;
      }
      if (apartmentNumber != null &&
          apartmentNumber != _currentUser!.apartmentNumber) {
        updatedData['apartmentNumber'] = apartmentNumber;
      }
      if (city != null && city != _currentUser!.city) {
        updatedData['city'] = city;
      }
      if (pesel != null && pesel.isNotEmpty) {
        final encryptedPesel = _encryptPesel(pesel);
        if (encryptedPesel != _currentUser!.pesel) {
          updatedData['pesel'] = encryptedPesel;
        }
      }

      print("Dane do aktualizacji: $updatedData");

      if (updatedData.isEmpty) {
        print("Brak zmian do zaktualizowania.");
        return;
      }

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updatedData);

      // Aktualizacja lokalnego modelu
      _currentUser = UserModel.fromMap({
        ..._currentUser!.toMap(),
        ...updatedData,
      }, _currentUser!.id);

      notifyListeners();
      print("Dane użytkownika zostały zaktualizowane.");
    } catch (e) {
      print("Błąd podczas aktualizacji danych użytkownika: $e");
    }
  }

  String _encryptPesel(String pesel) {
    try {
      final encrypted = _encrypter.encrypt(pesel, iv: _iv);
      print("Zaszyfrowany PESEL: ${encrypted.base64}");
      return encrypted.base64;
    } catch (e) {
      print("Błąd podczas szyfrowania PESEL: $e");
      rethrow;
    }
  }

  String _decryptPesel(String encryptedPesel) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedPesel, iv: _iv);
      print("Odszyfrowany PESEL: $decrypted");
      return decrypted;
    } catch (e) {
      print("Błąd podczas odszyfrowywania PESEL: $e");
      rethrow;
    }
  }

  /// Wylogowanie użytkownika
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print("Błąd podczas wylogowania: $e");
    }
  }

  @override
  void dispose() {
    peselController.dispose();
    super.dispose();
  }
}
