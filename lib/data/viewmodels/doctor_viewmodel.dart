import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';

class DoctorsViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  String _query = '';
  //Timer? _debounce;

  List<Doctor> get filteredDoctors => _filteredDoctors;
  String get query => _query;

  DoctorsViewModel() {
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final snapshot = await _firestore.collection('doctors').get();
      _allDoctors = snapshot.docs.map((doc) {
        return Doctor.fromFirestore(
          doc.data(),
          doc.id,
        );
      }).toList();
      print('Pobrano lekarzy: $_allDoctors');
      _filteredDoctors = List.from(_allDoctors);
      notifyListeners();
    } catch (e) {
      print('Error fetching doctors: $e');
    }
  }

  void updateQuery(String query) {
    _query = query.toLowerCase();
    _filteredDoctors = _allDoctors.where((doctor) {
      final nameMatches = doctor.name.toLowerCase().contains(_query);
      final categoryMatches =
          doctor.specialization.toLowerCase().contains(_query);
      return nameMatches || categoryMatches;
    }).toList();
    notifyListeners();
  }

  Doctor? getDoctorById(String doctorId) {
    return _allDoctors.firstWhere(
      (doctor) => doctor.id == doctorId,
    );
  }
  // void _fetchDoctors() {
  //   _allDoctors.addAll([
  //     Doctor(
  //       id: '1',
  //       name: 'Anna Nowak',
  //       category: 'Kardiolog',
  //       avatarUrl: null, // Przykładowo brak obrazu
  //       pwzNumber: '123456',
  //       description: 'Specjalista kardiolog z wieloletnim doświadczeniem.',
  //     ),
  //     Doctor(
  //       id: '2',
  //       name: 'Jan Kowalski',
  //       category: 'Chirurg',
  //       avatarUrl: null, // Przykładowo brak obrazu
  //       pwzNumber: '654321',
  //       description: 'Doświadczony chirurg z sukcesami w wielu operacjach.',
  //     ),
  //     Doctor(
  //       id: '3',
  //       name: 'Marek Zieliński',
  //       category: 'Neurolog',
  //       avatarUrl: null, // Przykładowo brak obrazu
  //       pwzNumber: '789012',
  //       description: 'Neurolog z pasją do pomagania pacjentom.',
  //     ),
  //   ]);
  //   _filteredDoctors = List.from(_allDoctors);
  //   notifyListeners();
  // }

  // void updateQuery(String query) {
  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 300), () {
  //     _query = query.toLowerCase();
  //     _filteredDoctors = _allDoctors.where((doctor) {
  //       final nameMatches = doctor.name.toLowerCase().contains(_query);
  //       final categoryMatches = doctor.category.toLowerCase().contains(_query);
  //       return nameMatches || categoryMatches;
  //     }).toList();
  //     notifyListeners();
  //   });
  // }

  // @override
  // void dispose() {
  //   _debounce?.cancel();
  //   super.dispose();
  // }
}
