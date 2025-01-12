import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/password_input.dart';
import 'package:medical_app/data/viewmodels/login_page_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  'Logowanie',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<LoginViewModel>(
                  builder: (context, viewModel, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (viewModel.errorMessage != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                viewModel.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          EmailTextField(controller: _emailController),
                          const SizedBox(height: 16),
                          PasswordTextField(
                            controller: _passwordController,
                            hintText: 'Hasło',
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final success = await viewModel.loginUser(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                      );
                                      if (success) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Zalogowano pomyślnie'),
                                          ),
                                        );
                                        Navigator.pushReplacementNamed(
                                            context, '/dashboard');
                                      }
                                    }
                                  },
                            text: viewModel.isLoading
                                ? 'Logowanie...'
                                : 'Zaloguj się',
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Nie masz konta? Zarejestruj się',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
