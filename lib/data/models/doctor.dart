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
  final List<Slot> slots;

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
    this.slots = const [],
  });

  factory Doctor.fromMap(Map<String, dynamic> data, String documentId,
      {Specialization? specialization}) {
    return Doctor(
      id: documentId,
      name: data['name'] ?? 'Nieznany lekarz',
      specializationId: data['specializationId'] ?? '',
      specialization: specialization,
      pwzNumber: data['pwzNumber'] ?? '',
      description: data['description'],
      avatarUrl: data['avatarUrl'],
      location: data['location'],
      phone: data['contact']?['phone'],
      email: data['contact']?['email'],
      slots: [],
    );
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specializationId,
    Specialization? specialization,
    String? pwzNumber,
    String? description,
    String? avatarUrl,
    String? location,
    String? phone,
    String? email,
    List<Slot>? slots,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specializationId: specializationId ?? this.specializationId,
      specialization: specialization ?? this.specialization,
      pwzNumber: pwzNumber ?? this.pwzNumber,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      slots: slots ?? this.slots,
    );
  }
}
