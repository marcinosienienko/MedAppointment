class Slot {
  final String id;
  final String date;
  final String startTime;
  final String endTime;
  final String status;

  Slot({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory Slot.fromMap(Map<String, dynamic> data, String documentId) {
    return Slot(
      id: documentId,
      date: data['date'] ?? 'Brak daty',
      startTime: data['startTime'] ?? 'Brak godziny rozpoczęcia',
      endTime: data['endTime'] ?? 'Brak godziny zakończenia',
      status: data['status'] ?? 'Brak statusu',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
    };
  }

  bool get isAvailable => status == 'available';

  Slot copyWith({
    String? id,
    String? date,
    String? startTime,
    String? endTime,
    String? status,
  }) {
    return Slot(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
}
