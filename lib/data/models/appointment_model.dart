import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String? date;
  final String? doctorId;
  final String? patientId;
  final String? slotId;
  final String? startTime;
  final String? endTime;
  final String? doctorName; // Dodane pole
  final String? patientName; // Dodane pole
  final String status;
  final DateTime? createdAt;
  final String? specialization;

  Appointment({
    required this.id,
    this.date,
    this.doctorId,
    this.patientId,
    this.slotId,
    this.startTime,
    this.endTime,
    this.doctorName,
    this.patientName,
    this.specialization,
    required this.status,
    this.createdAt,
  });

  // Metoda do tworzenia obiektu Appointment z mapy danych (np. z Firestore)
  factory Appointment.fromMap(Map<String, dynamic> data, String documentId) {
    return Appointment(
      id: documentId,
      date: data['date'] as String?,
      doctorId: data['doctorId'] as String?,
      patientId: data['patientId'] as String?,
      slotId: data['slotId'] as String?,
      startTime: data['startTime'] as String?,
      endTime: data['endTime'] as String?,
      doctorName: data['doctorName']
          as String?, // Dla uproszczenia, jeśli dane są już w dokumentach
      patientName: data['patientName'] as String?,
      specialization: data['specialization'] as String?,
      status: data['status'] as String? ?? 'pending',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Metoda do konwersji obiektu Appointment na mapę danych (np. do zapisu w Firestore)
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'doctorId': doctorId,
      'patientId': patientId,
      'slotId': slotId,
      'startTime': startTime,
      'endTime': endTime,
      'doctorName': doctorName,
      'patientName': patientName,
      'status': status,
      'specialization': specialization,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  // Metoda do tworzenia obiektu Appointment z danych JSON
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      date: json['date'] as String?,
      doctorId: json['doctorId'] as String?,
      patientId: json['patientId'] as String?,
      slotId: json['slotId'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      doctorName: json['doctorName'] as String?,
      patientName: json['patientName'] as String?,
      specialization: json['specialization'] as String?,
      status: json['status'] as String? ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Metoda copyWith do tworzenia kopii obiektu z modyfikacjami
  Appointment copyWith({
    String? id,
    String? date,
    String? doctorId,
    String? patientId,
    String? slotId,
    String? startTime,
    String? endTime,
    String? doctorName,
    String? patientName,
    String? status,
    DateTime? createdAt,
    String? specialization,
  }) {
    return Appointment(
      id: id ?? this.id,
      date: date ?? this.date,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      slotId: slotId ?? this.slotId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      doctorName: doctorName ?? this.doctorName,
      patientName: patientName ?? this.patientName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      specialization: specialization ?? this.specialization,
    );
  }
}
