import 'package:flutter/material.dart';
import 'package:medical_app/data/models/appointment_model.dart';
import 'package:medical_app/data/models/doctor_model.dart';
import 'package:medical_app/presentation/pages/appointment.dart';
import 'package:medical_app/presentation/pages/calendar_page.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr ${doctor.name}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zdjęcie doktora
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: doctor.avatarUrl != null //hasAvatar
                    ? Image.network(
                        doctor.avatarUrl!,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _defaultAvatar();
                        },
                      )
                    : _defaultAvatar(),
              ),
            ),
            const SizedBox(height: 16),

            // Imię i specjalizacja
            Text(
              'Dr ${doctor.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Specjalizacja: ${doctor.specialization}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Numer PWZ
            Text(
              'Numer PWZ: ${doctor.pwzNumber ?? "Brak informacji"}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Opis
            Text(
              'Opis:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              doctor.description ?? 'Brak informacji',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),

            // Przycisk "Umów wizytę"
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarPage(
                          doctorId: doctor.id,
                        ),
                      ),
                    );
                  },
                  text: 'Umów wizytę',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _defaultAvatar() {
  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
    child: Icon(Icons.person, size: 80, color: Colors.grey[600]),
  );
}
