import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Register
  Future<User?> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);

      final user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName.trim(),
          'lastName': lastName.trim(),
          'email': email.trim(),
          'phoneNumber': phoneNumber.trim(),
          'createdAt': FieldValue.serverTimestamp()
        });
        return user;
      }
      return null;
    } catch (e) {
      throw Exception("Błąd rejestracji: ${e.toString()}");
    }
  }

  //Login
  Future<User?> loginUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Błąd logowania: ${e.toString()}");
    }
  }

  //Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Reset password, preparing to implementation in the future
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
