class Appointment {
  final String id;
  final String slotId;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.slotId,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.dateTime,
  });

  // Konwersja obiektu na mapę JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'slotId': slotId,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'specialization': specialization,
        'dateTime': dateTime.toIso8601String(),
      };

  // Tworzenie obiektu z mapy JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      slotId: json['slotId'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      specialization: json['specialization'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}
