import 'package:flutter/material.dart';
import 'package:medical_app/data/models/doctor_model.dart';
import 'package:medical_app/data/models/user_model.dart';
import 'package:medical_app/presentation/widgets/inputs/search_input.dart';
import 'package:medical_app/presentation/widgets/inputs/search_input2.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Witaj, ${user.name.split(' ')[0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name[0],
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
      body: Container(
        color: Colors.lightBlueAccent,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: SearchInput2(),
            )
          ],
        ),
      ),
    );
  }
}
