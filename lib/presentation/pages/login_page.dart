import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/buttons/PrimaryButton.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/password_input.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Logowanie do przychodni',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 166, 184),
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  EmailTextField(controller: _emailController),
                  const SizedBox(height: 8),
                  PasswordTextField(),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: PrimaryButton(
                      text: "Zaloguj",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Logowanie...')));
                        }
                      },
                    ),
                  )
                ],
              ),
            )));
  }
}
