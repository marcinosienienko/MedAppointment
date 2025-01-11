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
}
