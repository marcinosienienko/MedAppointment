import 'package:flutter/material.dart';
import 'package:medical_app/data/repositories/doctor_repository.dart';
import '../models/doctor.dart';

class DoctorViewModel extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();
  final TextEditingController searchController = TextEditingController();

  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];

  List<Doctor> get filteredDoctors => _filteredDoctors;

  Future<void> fetchDoctors() async {
    debugPrint('Pobieranie danych lekarzy...');
    try {
      _allDoctors = await _repository.fetchDoctors();
      _filteredDoctors = _allDoctors;
      notifyListeners();
    } catch (e) {
      debugPrint('Błąd podczas pobierania danych lekarzy: $e');
      _allDoctors = [];
      _filteredDoctors = [];
      notifyListeners();
    }
  }

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    return await _repository.fetchDoctorById(doctorId);
  }

  void searchDoctors(String query) {
    if (query.isEmpty) {
      _filteredDoctors = _allDoctors;
    } else {
      _filteredDoctors = _allDoctors
          .where((doctor) =>
              (doctor.name.toLowerCase().trim())
                  .contains(query.toLowerCase().trim()) ||
              (doctor.specialization?.name.toLowerCase().trim() ?? '')
                  .contains(query.toLowerCase().trim()))
          .toList();
    }

    if (_filteredDoctors.isEmpty) {
      debugPrint('Nie znaleziono lekarzy dla zapytania: $query');
    }
    notifyListeners();
  }

  void clearSearch() {
    _filteredDoctors = _allDoctors;
    notifyListeners();
  }
}
