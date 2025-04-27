import 'package:flutter/material.dart';
import 'base_input.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const EmailTextField({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  String? _emailValidator(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Podaj email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Podaj poprawny email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hintText: 'E-mail',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: _emailValidator,
      prefixIcon: Icons.email,
    );
  }
}
