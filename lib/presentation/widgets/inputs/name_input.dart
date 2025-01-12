import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/inputs/base_input.dart';

enum ValidationType {
  name, // Walidacja dla imienia
  surname, // Walidacja dla nazwiska
}

class NameInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValidationType validationType;
  final IconData prefixIcon;
  final Function(String)? onChanged;

  NameInput({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validationType,
    required this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  final RegExp containNumberRegex =
      RegExp(r'[0-9@!#$%^&*()_+\-=\[\]{}|\\:;"<>,.?/]');

  String? _validate(String? value) {
    switch (validationType) {
      case ValidationType.name:
        if (value == null || value.isEmpty) {
          return 'Podaj imię';
        }
        if (value.length < 2) {
          return 'Imię musi mieć min. 2 znaki';
        }
        if (containNumberRegex.hasMatch(value)) {
          return 'Imię musi składać się tylko z liter';
        }
        break;
      case ValidationType.surname:
        if (value == null || value.isEmpty) {
          return 'Podaj nazwisko';
        }
        if (value.length < 2) {
          return 'Nazwisko musi mieć min. 2 znaki';
        }
        if (containNumberRegex.hasMatch(value)) {
          return 'Nazwisko musi składać się tylko z liter';
        }
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.text,
      validator: _validate, // Użycie walidatora z logiką wyboru
      prefixIcon: prefixIcon,
    );
  }
}
