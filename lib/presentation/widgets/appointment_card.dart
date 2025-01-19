import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onCancel;

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? appointmentDate;

    // Parsowanie daty wizyty
    if (appointment.date != null) {
      try {
        appointmentDate = DateTime.parse(appointment.date!);
      } catch (e) {
        print('Błąd konwersji daty: $e');
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,

          backgroundColor: Colors.blueAccent, // Domyślne tło avatara
        ),
        title: Text(
          appointment.doctorName ?? 'Nieznany lekarz', // Wyświetla imię doktora
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specjalizacja: ${appointment.specialization ?? 'Brak specjalizacji'}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Termin: ${appointmentDate != null ? _formatDateTime(appointmentDate) : 'Brak terminu'}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: onCancel,
        ),
      ),
    );
  }

  // Formatowanie daty i godziny w czytelny sposób
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
