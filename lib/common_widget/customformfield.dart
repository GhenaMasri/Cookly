import 'package:flutter/material.dart';

class CustomFormFields {
  static Widget buildTextFormField({
    required String hintText,
    required String? Function(String?)? validator,
    required Function(String?)? onSaved,
    TextEditingController? controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color.fromARGB(255, 238, 238, 238))),
      ),
      child: TextFormField(
        validator: validator,
        onSaved: onSaved,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          errorStyle: const TextStyle(color: Color.fromARGB(255, 230, 81, 0)),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
