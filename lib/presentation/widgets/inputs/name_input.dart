import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/inputs/base_input.dart';

class NameInput extends StatelessWidget {
  final TextEditingController? controller;

  NameInput({Key? key, required this.controller}) : super(key: key);
  final RegExp containNumberRegex =
      RegExp(r'[0-9@!#$%^&*()_+\-=\[\]{}|\\:;"<>,.?/]');

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Podaj imię';
    }
    if (value.length < 2) {
      return 'Imię musi mieć min. 2 znaki';
    }
    if (containNumberRegex.hasMatch(value)) {
      return 'Imię musi składać się tylko z liter';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hintText: 'Imię',
      controller: controller,
      keyboardType: TextInputType.text,
      validator: _nameValidator,
      prefixIcon: Icons.person,
    );
  }
}
