import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';

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
                child: Image.network(
                  doctor.avatarUrl ??
                      'https://via.placeholder.com/150', // Domyślne zdjęcie
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
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
              'Specjalizacja: ${doctor.category}',
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
              doctor.description ?? 'Brak opisu dostępnego.',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),

            // Przycisk "Umów wizytę"
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logika dla umawiania wizyty
                  Navigator.pushNamed(context, '/appointments',
                      arguments: doctor);
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Umów wizytę'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
