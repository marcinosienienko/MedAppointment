import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor.dart';
import 'package:medical_app/presentation/pages/doctor_details_page.dart'; // Import strony szczegółów

class SearchResults extends StatelessWidget {
  final List<Doctor> doctors;

  const SearchResults({
    super.key,
    required this.doctors,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return const SizedBox.shrink(); // Ukryj listę, gdy brak wyników
    }

    return Container(
      constraints: const BoxConstraints(
        maxHeight: 400.0, // Maksymalna wysokość listy wyników
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1.0),
            child: Material(
              color: Colors.blue[50], // Tło każdego elementu
              borderRadius: BorderRadius.circular(8.0),
              child: InkWell(
                onTap: () {
                  // Nawigacja do szczegółów doktora
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorDetailsPage(doctor: doctor),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8.0),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.all(16.0), // Padding wewnętrzny
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: doctor.avatarUrl != null
                        ? NetworkImage(doctor.avatarUrl!)
                        : const AssetImage('assets/images/default_avatar.png')
                            as ImageProvider,
                    backgroundColor: Colors.grey[300],
                  ),
                  title: Text(
                    doctor.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Kolor tekstu
                    ),
                  ),
                  subtitle: Text(
                    doctor.specialization?.name ?? 'Brak specjalizacji',
                    style: const TextStyle(
                      color: Colors.black54, // Kolor podtytułu
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
