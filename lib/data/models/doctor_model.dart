class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String? avatarUrl;
  final String? pwzNumber;
  final String? description;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    this.avatarUrl,
    this.pwzNumber,
    this.description,
  });

  // bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  // Creating Doctor object from Firestore data
  factory Doctor.fromFirestore(Map<String, dynamic> data, String id) {
    return Doctor(
      id: id,
      name: data['name'] ?? 'Brak imienia',
      specialization: data['specialization'] ?? 'Brak kategorii',
      avatarUrl: data['avatarUrl'],
      pwzNumber: data['pwzNumber'],
      description: data['description'] ?? 'Brak opisu',
    );
  }

  //Map Doctor object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'specialization': specialization,
      'avatarUrl': avatarUrl,
      'pwzNumber': pwzNumber,
      'description': description,
    };
  }
}
