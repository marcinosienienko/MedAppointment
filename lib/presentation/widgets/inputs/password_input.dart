import 'package:flutter/material.dart';
import 'base_input.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? otherController;
  final String hintText;
  final bool isConfirmation;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.otherController,
    this.isConfirmation = false,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Podaj hasło';
    }
    if (!widget.isConfirmation) {
      final regex = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
      if (!regex.hasMatch(value)) {
        return 'Hasło musi mieć min. 8 znaków, wielką literę, cyfrę i znak specjalny';
      }
    }

    if (widget.isConfirmation && widget.otherController != null) {
      if (value != widget.otherController!.text) {
        return 'Hasła się nie zgadzają';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: BaseTextField(
        hintText: widget.hintText,
        controller: widget.controller,
        obscureText: _isObscured,
        validator: _passwordValidator,
        prefixIcon: Icons.lock,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _toggleVisibility,
        ),
      ),
    );
  }
}
