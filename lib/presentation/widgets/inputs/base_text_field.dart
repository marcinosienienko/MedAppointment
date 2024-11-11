import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final InputDecoration? decoration;
  final IconData? prefixIcon;

  const BaseTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.decoration,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: decoration ??
          InputDecoration(
            labelText: labelText,
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
      validator: validator,
    );
  }
}
