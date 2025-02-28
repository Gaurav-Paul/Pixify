import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String? Function(String?)? validatorFunction;
  final bool obscureText;
  final String labelText;
  final IconData? icon;

  const AuthTextField({
    super.key,
    this.validatorFunction,
    required this.obscureText,
    required this.labelText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validatorFunction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.amber,
        ),
        prefixIcon: icon != null
            ? Icon(
                icon,
                color: Colors.grey,
              )
            : null,
        label: Text(labelText),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.amber, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.amber, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
