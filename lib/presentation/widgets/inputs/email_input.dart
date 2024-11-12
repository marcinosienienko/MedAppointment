import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/inputs/base_text_field.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;

  const EmailTextField({Key? key, this.controller}) : super(key: key);

  String? _emailValidator(String? value) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (value == null || !value.isNotEmpty) {
      return 'Podaj email';
    } else if (!regex.hasMatch(value)) {
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
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
