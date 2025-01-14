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
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(label: 'Imię', value: user.firstName),
            _buildInfoRow(label: 'Nazwisko', value: user.lastName),
            _buildInfoRow(label: 'Email', value: user.email),
            _buildInfoRow(label: 'Numer telefonu', value: user.phoneNumber),
            _buildInfoRow(label: 'Ulica', value: user.street ?? 'Brak danych'),
            _buildInfoRow(
                label: 'Numer domu', value: user.houseNumber ?? 'Brak danych'),
            _buildInfoRow(
                label: 'Numer mieszkania',
                value: user.apartmentNumber ?? 'Brak danych'),
            _buildInfoRow(label: 'Miasto', value: user.city ?? 'Brak danych'),
            _buildInfoRow(label: 'PESEL', value: user.pesel ?? 'Brak danych'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
