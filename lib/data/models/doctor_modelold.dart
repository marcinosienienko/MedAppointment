import 'specialization.dart';
import 'slot_model.dart';

class Doctor {
  final String id;
  final String name;
  final String specializationId;
  final Specialization? specialization; // Specjalizacja jako obiekt
  final String pwzNumber;
  final String? description;
  final String? avatarUrl;
  final String? location;
  final String? phone;
  final String? email;
  final List<Slot>? slots;

  Doctor({
    required this.id,
    required this.name,
    required this.specializationId,
    this.specialization,
    required this.pwzNumber,
    this.description,
    this.avatarUrl,
    this.location,
    this.phone,
    this.email,
    this.slots,
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String documentId) {
    return Doctor(
      id: documentId,
      name: data['name'] ?? 'Nieznany lekarz',
      specializationId: data['specializationId'] ?? '',
      pwzNumber: data['pwzNumber'] ?? '',
      description: data['description'],
      avatarUrl: data['avatarUrl'],
      location: data['location'],
      phone: data['contact']?['phone'],
      email: data['contact']?['email'],
      slots: [],
    );
  }

  Doctor copyWith({Specialization? specialization}) {
    return Doctor(
      id: id,
      name: name,
      specializationId: specializationId,
      specialization: specialization ?? this.specialization,
      pwzNumber: pwzNumber,
      description: description,
      avatarUrl: avatarUrl,
      location: location,
      phone: phone,
      email: email,
      slots: slots,
    );
  }
}
