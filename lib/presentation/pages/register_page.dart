import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/inputs/base_input.dart';
import 'package:medical_app/presentation/widgets/inputs/email_input.dart';
import 'package:medical_app/presentation/widgets/inputs/name_input.dart';

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
                          NameInput(controller: _firstNameController),
                          NameInput(controller: _lastNameController),
                          EmailTextField(controller: _emailController),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            child: const Text(
                                'Submit'), // Add a child widget to the ElevatedButton
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
