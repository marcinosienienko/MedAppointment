import 'package:flutter/material.dart';
import 'package:medical_app/data/models/auth_model.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthModel _authModel = AuthModel();

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

  Future<void> registerUser() async {
    if (firstName == null ||
        lastName == null ||
        email == null ||
        phoneNumber == null ||
        password == null ||
        confirmPassword == null) {
      errorMessage = "Wszystkie pola są wymagane.";
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      errorMessage = "Hasła nie są zgodne.";
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authModel.registerUser(
        email: email!,
        password: password!,
        firstName: firstName!,
        lastName: lastName!,
        phoneNumber: phoneNumber!,
      );
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
