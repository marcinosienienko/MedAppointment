import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/name_input.dart';
import 'package:medical_app/presentation/widgets/inputs/password_input.dart';
import 'package:medical_app/presentation/widgets/inputs/phone_number_input.dart';
import 'package:medical_app/presentation/widgets/inputs/veryfication_code_input.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/register_page_viewmodel.dart';

class RegisterPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerViewModel = Provider.of<RegisterViewModel>(context);

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
                        controller: TextEditingController(
                            text: registerViewModel.firstName),
                        hintText: 'Imię',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.name,
                        onChanged: registerViewModel.setFirstName,
                      ),
                      const SizedBox(height: 16),
                      NameInput(
                        controller: TextEditingController(
                            text: registerViewModel.lastName),
                        hintText: 'Nazwisko',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.surname,
                        onChanged: registerViewModel.setLastName,
                      ),
                      const SizedBox(height: 16),
                      EmailTextField(
                        controller: TextEditingController(
                            text: registerViewModel.email),
                        onChanged: registerViewModel.setEmail,
                      ),
                      const SizedBox(height: 16),
                      PhoneNumberInput(
                        controller: TextEditingController(
                            text: registerViewModel.phoneNumber),
                        onChanged: registerViewModel.setPhoneNumber,
                      ),
                      const SizedBox(height: 16),
                      VerificationCodeInput(
                        controller: TextEditingController(
                            text: registerViewModel.verificationCode),
                        onChanged: (value) =>
                            registerViewModel.verificationCode = value,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: TextEditingController(
                            text: registerViewModel.password),
                        hintText: 'Hasło',
                        onChanged: registerViewModel.setPassword,
                      ),
                      const SizedBox(height: 24),
                      if (registerViewModel.errorMessage != null)
                        Text(
                          registerViewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 8),
                      PrimaryButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await registerViewModel.registerUser();
                            if (registerViewModel.errorMessage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Rejestracja zakończona sukcesem!'),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          }
                        },
                        text: registerViewModel.isLoading
                            ? 'Proszę czekać...'
                            : 'Zarejestruj',
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
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
