import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/base_input.dart';
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
        appBar: AppBar(
          title: const Text(
            'Rejestracja',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 166, 184),
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
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
                              hintText: 'Hasło'),
                          const SizedBox(height: 16),
                          PasswordTextField(
                            hintText: 'Potwierdź hasło',
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Potwierdź hasło';
                              } else if (value != _passwordController.text) {
                                return 'Hasła nie są takie same';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            text: 'Zarejestruj',
                            // Add a child widget to the ElevatedButton
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
