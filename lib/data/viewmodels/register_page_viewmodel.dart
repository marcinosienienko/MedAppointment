import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? verificationCode;
  String? password;

  bool isLoading = false;
  String? errorMessage;

  Future<void> registerUser() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Rejestracja za pomocą e-maila i hasła
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // Aktualizacja profilu użytkownika
      await userCredential.user?.updateDisplayName("$firstName $lastName");

      // Tutaj możesz zapisać dodatkowe dane użytkownika w Firestore
      print("Użytkownik zarejestrowany: ${userCredential.user?.uid}");

      // Resetuj formularz
      resetForm();
    } catch (e) {
      errorMessage = _handleFirebaseError(e);
      print("Błąd rejestracji: $errorMessage");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetForm() {
    firstName = null;
    lastName = null;
    email = null;
    phoneNumber = null;
    verificationCode = null;
    password = null;
    notifyListeners();
  }

  String? _handleFirebaseError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Adres e-mail jest już zarejestrowany.';
        case 'invalid-email':
          return 'Podany adres e-mail jest nieprawidłowy.';
        case 'weak-password':
          return 'Hasło musi mieć co najmniej 6 znaków.';
        default:
          return 'Wystąpił nieoczekiwany błąd: ${error.message}';
      }
    }
    return 'Nieznany błąd.';
  }

  // Metody do ustawiania danych z pól tekstowych
  void setFirstName(String value) {
    firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    lastName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }
}
