import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> loginUser(String email, String password) async {
    _setLoading(true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_getErrorMessage(e.code));
      _setLoading(false);
      return false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika z tym adresem e-mail.';
      case 'wrong-password':
        return 'Nieprawidłowe hasło.';
      case 'invalid-email':
        return 'Nieprawidłowy format e-maila.';
      default:
        return 'Wystąpił nieznany błąd. Spróbuj ponownie.';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
