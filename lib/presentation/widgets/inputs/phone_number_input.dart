import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_input.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const PhoneNumberInput({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      hintText: 'Numer telefonu',
      prefixIcon: Icons.phone,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^\+?[0-9]*$')), // Tylko cyfry i opcjonalny "+"
        LengthLimitingTextInputFormatter(15), // Maksymalna długość numeru
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Numer telefonu jest wymagany';
        }
        final regex = RegExp(r'^\+?[0-9]{9,15}$'); // + i od 9 do 15 cyfr
        if (!regex.hasMatch(value)) {
          return 'Podaj poprawny numer telefonu';
        }
        return null;
      },
    );
  }
}
