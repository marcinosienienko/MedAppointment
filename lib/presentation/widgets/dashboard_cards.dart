import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/dashboard_card.dart';

class DashboardCards extends StatelessWidget {
  const DashboardCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DashboardCard(
          title: 'Wszystkie wizyty',
          subtitle: 'Sprawdź i zarządzaj swoimi wizytami.',
          icon: Icons.calendar_today,
          color: Colors.blue,
          onTap: () => Navigator.pushNamed(context, '/appointments'),
        ),
        const SizedBox(height: 8.0),
        DashboardCard(
          title: 'Recepty',
          subtitle: 'Zobacz swoje recepty',
          icon: Icons.local_pharmacy,
          color: Colors.red,
          onTap: () => Navigator.pushNamed(context, '/prescriptions'),
        ),
        const SizedBox(height: 8.0),
        DashboardCard(
          title: 'Skierowania',
          subtitle: 'Zobacz swoje skierowania',
          icon: Icons.upload_file,
          color: Colors.teal,
          onTap: () => Navigator.pushNamed(context, '/referrals'),
        ),
        const SizedBox(height: 8.0),
        DashboardCard(
          title: 'Uzupełnij swój profil',
          subtitle: 'Dodaj brakujące informacje o sobie.',
          icon: Icons.person,
          color: Colors.lightBlue,
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }
}
