import 'package:flutter/material.dart';
import 'package:medical_app/presentation/widgets/inputs/base_text_field.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;

  const PasswordTextField({Key? key, this.controller}) : super(key: key);

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
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (value == null || value.isEmpty) {
      return 'Podaj hasło';
    } else if (!regex.hasMatch(value)) {
      return 'Hasło musi mieć min. 8 znaków, wielką literę, cyfrę i znak specjalny';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      hintText: 'Hasło',
      controller: widget.controller,
      obscureText: _isObscured,
      validator: _passwordValidator,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: _toggleVisibility,
        ),
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
