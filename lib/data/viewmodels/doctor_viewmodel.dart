import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';

class DoctorsViewModel extends ChangeNotifier {
  final List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  String _query = '';
  Timer? _debounce;

  List<Doctor> get filteredDoctors => _filteredDoctors;
  String get query => _query;

  DoctorsViewModel() {
    _fetchDoctors();
  }

  void _fetchDoctors() {
    _allDoctors.addAll([
      Doctor(
        name: 'Anna Nowak',
        category: 'Kardiolog',
        avatarUrl: null, // Przykładowo brak obrazu
        pwzNumber: '123456',
        description: 'Specjalista kardiolog z wieloletnim doświadczeniem.',
      ),
      Doctor(
        name: 'Jan Kowalski',
        category: 'Chirurg',
        avatarUrl: null, // Przykładowo brak obrazu
        pwzNumber: '654321',
        description: 'Doświadczony chirurg z sukcesami w wielu operacjach.',
      ),
      Doctor(
        name: 'Marek Zieliński',
        category: 'Neurolog',
        avatarUrl: null, // Przykładowo brak obrazu
        pwzNumber: '789012',
        description: 'Neurolog z pasją do pomagania pacjentom.',
      ),
    ]);
    _filteredDoctors = List.from(_allDoctors);
    notifyListeners();
  }

  void updateQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _query = query.toLowerCase();
      _filteredDoctors = _allDoctors.where((doctor) {
        final nameMatches = doctor.name.toLowerCase().contains(_query);
        final categoryMatches = doctor.category.toLowerCase().contains(_query);
        return nameMatches || categoryMatches;
      }).toList();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
