class AppointmentModel {
  final String id;
  final String status;
  final DateTime date;
  final String doctorName;
  final String specializationName;

  AppointmentModel({
    required this.id,
    required this.status,
    required this.date,
    required this.doctorName,
    required this.specializationName,
  });
}
