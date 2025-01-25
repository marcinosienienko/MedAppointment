import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';

class UserInfoCard extends StatelessWidget {
  final UserModel user;

  const UserInfoCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.lightBlue[50],
      margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Twoje dane',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(thickness: 1.0, height: 20.0),
            ..._buildInfoRows(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildInfoRows() {
    final info = [
      {'label': 'Imię', 'value': user.firstName},
      {'label': 'Nazwisko', 'value': user.lastName},
      {'label': 'Email', 'value': user.email},
      {'label': 'Numer telefonu', 'value': user.phoneNumber},
      {'label': 'Ulica', 'value': user.street ?? 'Brak danych'},
      {'label': 'Numer domu', 'value': user.houseNumber ?? 'Brak danych'},
      {
        'label': 'Numer mieszkania',
        'value': user.apartmentNumber ?? 'Brak danych'
      },
      {'label': 'Miasto', 'value': user.city ?? 'Brak danych'},
      {'label': 'PESEL', 'value': user.pesel ?? 'Brak danych'},
    ];

    return info.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              entry['label']!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Flexible(
              child: Text(
                entry['value']!,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
