class Appointment {
  final String doctorId;
  final String userId; // Identyfikator użytkownika
  final DateTime date; // Data i godzina wizyty
  final bool isConfirmed;

  Appointment({
    required this.doctorId,
    required this.userId,
    required this.date,
    this.isConfirmed = false, // Domyślnie wizyta jest niepotwierdzona
  });
}
