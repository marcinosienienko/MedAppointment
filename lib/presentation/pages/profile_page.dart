import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/auth_view_model.dart';
import 'package:medical_app/data/viewmodels/user_vievmodel.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final userViewModel = Provider.of<UserViewModel>(context);

    final user = userViewModel.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profil użytkownika'),
        backgroundColor: Colors.blue,
      ),
      body: user != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar użytkownika
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? Text(
                              '${user.firstName[0]}${user.lastName[0]}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Informacje o użytkowniku
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Imię: ${user.firstName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nazwisko: ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: ${user.email}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Numer telefonu: ${user.phoneNumber}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Przycisk do ustawień
                  PrimaryButton(
                    text: 'Przejdź do ustawień',
                    onPressed: () {
                      // Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Przycisk edycji danych
                  PrimaryButton(
                    text: 'Uzupełnij dane',
                    color: Colors.blueGrey,
                    textColor: Colors.black,
                    onPressed: () {
                      //Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  const Spacer(),

                  // Przycisk wylogowania
                  PrimaryButton(
                    text: authViewModel.isLoading
                        ? 'Wylogowywanie...'
                        : 'Wyloguj',
                    onPressed: authViewModel.isLoading
                        ? null
                        : () async {
                            final success = await authViewModel.logout();
                            if (success) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Wylogowano pomyślnie'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authViewModel.errorMessage ??
                                      'Błąd wylogowania'),
                                ),
                              );
                            }
                          },
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
