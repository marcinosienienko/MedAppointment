import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../services/firestore_service.dart';

class DoctorViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController searchController = TextEditingController();
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];

  List<Doctor> get filteredDoctors => _filteredDoctors;

  Future<void> fetchDoctors() async {
    print('Pobieranie danych lekarzy...');
    try {
      _allDoctors = await _firestoreService.fetchDoctors();
      _filteredDoctors = _allDoctors; // Domyślnie pokazujemy wszystkich lekarzy
      notifyListeners();
    } catch (e) {
      print('Błąd podczas pobierania danych lekarzy: $e');
      _allDoctors = [];
      _filteredDoctors = [];
      notifyListeners();
    }
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      _filteredDoctors = _allDoctors;
    } else {
      _filteredDoctors = _allDoctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(query.toLowerCase()) ||
              (doctor.specialization?.name.toLowerCase() ?? '')
                  .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredDoctors = _allDoctors;
    notifyListeners();
  }
}
