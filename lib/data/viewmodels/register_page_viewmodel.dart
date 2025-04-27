import 'package:flutter/material.dart';
import 'package:medical_app/data/models/auth_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthModel _authModel = AuthModel();
  final String allFieldsRequired = "Wszystkie pola są wymagane.";
  final String passwordsDoNotMatch = "Hasła nie są zgodne.";
  final String successMessage = 'Rejestracja zakończona sukcesem!';
  final String errorRegistration =
      'Rejestracja nie powiodła się. Spróbuj ponownie.';

  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;
  String? errorMessage;
  bool isLoading = false;

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

  void setConfirmPassword(String value) {
    confirmPassword = value;
    notifyListeners();
  }

  void resetForm() {
    firstName = null;
    lastName = null;
    email = null;
    phoneNumber = null;
    password = null;
    confirmPassword = null;
    notifyListeners();
  }

  Future<bool> registerUser() async {
    if (firstName == null ||
        lastName == null ||
        email == null ||
        phoneNumber == null ||
        password == null ||
        confirmPassword == null) {
      errorMessage = allFieldsRequired;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      errorMessage = passwordsDoNotMatch;
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      await _authModel.registerUser(
        email: email!,
        password: password!,
        firstName: firstName!,
        lastName: lastName!,
        phoneNumber: phoneNumber!,
      );
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
