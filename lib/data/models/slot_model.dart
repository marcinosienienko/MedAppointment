class Slot {
  final String id;
  final DateTime dateTime;
  final String doctorId;
  bool isAvailable;

  Slot({
    required this.id,
    required this.dateTime,
    required this.doctorId,
    required this.isAvailable,
  });

  // Konwersja na JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'dateTime': dateTime.toIso8601String(),
        'doctorId': doctorId,
        'isAvailable': isAvailable,
      };

  // Tworzenie obiektu Slot z JSON
  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      doctorId: json['doctorId'],
      isAvailable: json['isAvailable'],
    );
  }
}
