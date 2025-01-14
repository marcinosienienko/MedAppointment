import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<void> fetchUserData() async {
    try {
      print("rozpoczynam pobieranie danych użytkownika");

      final user = _auth.currentUser;
      if (user != null) {
        print("zalogowany użytkownik");

        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          print("dane użytkownika pobrane z firestore: ${doc.data()}");
          _currentUser = UserModel.fromMap(doc.data()!, user.uid);
          print("dane użytkownika przypisane do _currentUser: ${_currentUser}");
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

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      if (_currentUser != null) {
        await _firestore
            .collection('users')
            .doc(_currentUser!.id)
            .update(updatedData);
        _currentUser = UserModel.fromMap(
          {
            ..._currentUser!.toMap(),
            ...updatedData,
          },
          _currentUser!.id,
        );
        notifyListeners();
      }
    } catch (e) {
      print("Błąd podczas aktualizacji danych użytkownika: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print("Błąd podczas wylogowania: $e");
    }
  }
}
