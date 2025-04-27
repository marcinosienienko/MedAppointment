import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_input.dart';

class VerificationCodeInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const VerificationCodeInput({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      hintText: 'Kod weryfikacyjny',
      prefixIcon: Icons.lock,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Tylko cyfry
        LengthLimitingTextInputFormatter(6), // Maksymalna długość: 6 znaków
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kod weryfikacyjny jest wymagany';
        }
        if (value.length != 6) {
          return 'Kod weryfikacyjny musi mieć 6 cyfr';
        }
        return null;
      },
    );
  }
}
