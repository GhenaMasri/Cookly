import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  String? _password;
  String? _confirmPassword;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Password must be at least 8 characters
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Password must contain at least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    String? password = txtPassword.text;

    if (password == null || value == null || password != value) {
      return 'Passwords do not match';
    }
    return null;
  }

  void savePassword(String? value) {
    _password = value;
  }

  void saveConfirmPassword(String? value) {
    _confirmPassword = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          child: Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  Text(
                    "New Password",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Please enter your new password",
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  RoundTextfield(
                    validator: _validatePassword,
                    onSaved: savePassword,
                    hintText: "New Password",
                    controller: txtPassword,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  RoundTextfield(
                    validator: _validateConfirmPassword,
                    onSaved: saveConfirmPassword,
                    hintText: "Confirm Password",
                    controller: txtConfirmPassword,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                      title: "Confirm",
                      onPressed: () {
                        if (formState.currentState!.validate()) {
                          formState.currentState!.save();
                          //Backend Logic
                        }
                      }),
                ],
              )),
        ),
      ),
    );
  }
}
