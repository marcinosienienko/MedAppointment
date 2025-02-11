import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_app/data/models/auth_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthModel _authModel = AuthModel();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      User? user = await _authModel.registerUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      _setLoading(false);
      return user != null;
    } catch (e) {
      _setErrorMessage('Błąd rejestracji: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      User? user = await _authModel.loginUser(
        email: email,
        password: password,
      );

      _setLoading(false);
      return user != null;
    } catch (e) {
      _setErrorMessage('Błąd logowania: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Wylogowanie użytkownika
  Future<bool> logout() async {
    try {
      _setLoading(true);
      _setErrorMessage(null);
      await _authModel.logout();
      _setLoading(false);
      return true;
    } catch (e) {
      _setErrorMessage('Błąd wylogowania: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _setLoading(true);
      _setErrorMessage(null);
      await _authModel.resetPassword(email);
      _setLoading(false);
    } catch (e) {
      _setErrorMessage('Błąd resetowania hasła: ${e.toString()}');
      _setLoading(false);
    }
  }
}
