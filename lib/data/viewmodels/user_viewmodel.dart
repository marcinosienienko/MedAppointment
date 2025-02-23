import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:medical_app/data/repositories/auth_repository.dart';
import 'package:medical_app/data/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _currentUser;
  final peselController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();

  UserModel? get currentUser => _currentUser;
  UserViewModel(this._userRepository);

  //Fetching user data from repository
  Future<void> fetchUserData() async {
    try {
      _currentUser = await _userRepository.fetchUserData();
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
      await _userRepository.updateUserProfile(
          userId: _currentUser!.id,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
          street: street,
          houseNumber: houseNumber,
          apartamentNumber: apartmentNumber,
          city: city,
          pesel: pesel);
      await fetchUserData();
    } catch (e) {
      debugPrint("Błąd aktualizacji danych uytkownika: $e");
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Błąd wylogowania użytkownika: $e");
    }
  }

  @override
  void dispose() {
    peselController.dispose();
    super.dispose();
  }
}
