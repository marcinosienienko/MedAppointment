import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/name_input.dart';
import 'package:medical_app/presentation/widgets/inputs/password_input.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Rejestracja',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NameInput(
                        controller: _firstNameController,
                        hintText: 'Imię',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.name,
                      ),
                      const SizedBox(height: 16),
                      NameInput(
                        controller: _lastNameController,
                        hintText: 'Nazwisko',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.surname,
                      ),
                      const SizedBox(height: 16),
                      EmailTextField(controller: _emailController),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: _passwordController,
                        hintText: 'Hasło',
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        hintText: 'Potwierdź hasło',
                        controller: _confirmPasswordController,
                        otherController: _passwordController,
                        isConfirmation: true,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Rejestracja...')),
                            );
                            // Logika rejestracji
                          }
                        },
                        text: 'Zarejestruj',
                      ),
                      const SizedBox(height: 16),
                      // Odnośnik do logowania
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Wróć do poprzedniego ekranu (LoginPage)
                        },
                        child: const Text(
                          'Masz już konto? Zaloguj się',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
