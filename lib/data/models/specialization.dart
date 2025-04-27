class Specialization {
  final String id;
  final String name;

  Specialization({
    required this.id,
    required this.name,
  });

  factory Specialization.fromMap(Map<String, dynamic> data, String documentId) {
    return Specialization(
      id: documentId,
      name: data['name'] ?? 'Brak nazwy',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
