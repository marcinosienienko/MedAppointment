import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/primary_button.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/name_input.dart';
import 'package:medical_app/presentation/widgets/inputs/password_input.dart';
import 'package:medical_app/presentation/widgets/inputs/phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:medical_app/data/viewmodels/register_page_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final registerViewModel =
        Provider.of<RegisterViewModel>(context, listen: false);

    // Initialize controller values based on ViewModel
    _firstNameController.text = registerViewModel.firstName ?? '';
    _lastNameController.text = registerViewModel.lastName ?? '';
    _emailController.text = registerViewModel.email ?? '';
    _phoneController.text = registerViewModel.phoneNumber ?? '';
    _passwordController.text = registerViewModel.password ?? '';
    _confirmPasswordController.text = registerViewModel.confirmPassword ?? '';

    // Bind controllers to ViewModel methods
    _firstNameController.addListener(() {
      registerViewModel.setFirstName(_firstNameController.text);
    });
    _lastNameController.addListener(() {
      registerViewModel.setLastName(_lastNameController.text);
    });
    _emailController.addListener(() {
      registerViewModel.setEmail(_emailController.text);
    });
    _phoneController.addListener(() {
      registerViewModel.setPhoneNumber(_phoneController.text);
    });
    _passwordController.addListener(() {
      registerViewModel.setPassword(_passwordController.text);
    });
    _confirmPasswordController.addListener(() {
      registerViewModel.setConfirmPassword(_confirmPasswordController.text);
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                        controller: _firstNameController,
                        hintText: 'Imię',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.name,
                        onChanged: registerViewModel.setFirstName,
                      ),
                      const SizedBox(height: 16),
                      NameInput(
                        controller: _lastNameController,
                        hintText: 'Nazwisko',
                        prefixIcon: Icons.person,
                        validationType: ValidationType.surname,
                        onChanged: registerViewModel.setLastName,
                      ),
                      const SizedBox(height: 16),
                      EmailTextField(
                        controller: _emailController,
                        onChanged: registerViewModel.setEmail,
                      ),
                      const SizedBox(height: 16),
                      PhoneNumberInput(
                        controller: _phoneController,
                        onChanged: registerViewModel.setPhoneNumber,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: _passwordController,
                        hintText: 'Hasło',
                        onChanged: registerViewModel.setPassword,
                      ),
                      const SizedBox(height: 16),
                      PasswordTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Potwierdź hasło',
                        onChanged: registerViewModel.setConfirmPassword,
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
                              registerViewModel.resetForm();
                              registerViewModel.isLoading = false;
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Rejestracja zakończona sukcesem!'),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              }
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
