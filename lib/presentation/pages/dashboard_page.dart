import 'package:flutter/material.dart';
import 'package:medical_app/data/models/user_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserModel(
      name: 'Jan Kowalski',
      avatarUrl: null,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false, // Usunięcie przycisku wstecz
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Powitanie użytkownika
            Expanded(
              child: Text(
                'Witaj, ${user.name.split(' ')[0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24, // Zmniejszenie, by wyglądało estetycznie
                  color: Colors.black,
                ),
              ),
            ),
            // Awatar użytkownika
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, '/profile'); // Przejście do profilu
              },
              child: CircleAvatar(
                radius: 20, // Promień awatara
                backgroundColor: Colors.blueGrey,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name[0], // Pierwsza litera imienia
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Dashboard Content Goes Here'),
      ),
    );
  }
}
