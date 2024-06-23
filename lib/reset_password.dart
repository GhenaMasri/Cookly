import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import 'package:untitled/new_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController txtEmail = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  String errorMessage = '';
  bool errorFlag = false;
  String? email;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  void saveEmail(String? value) {
    email = value;
  }

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<String> resetPassword() async {
    const url = 'http://192.168.1.106:3000/reset-password';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else if (response.statusCode == 400) {
        return response.body;
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

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
                    "Reset Password",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Please enter your email to receive a\n reset email to create a new password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  RoundTextfield(
                    validator: validateEmail,
                    onSaved: saveEmail,
                    hintText: "Your Email",
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: errorFlag,
                    child: Text(errorMessage,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 230, 81, 0),
                          fontSize: 16,
                        )),
                  ),
                  RoundButton(
                      title: "Send",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          formState.currentState!.save();
                          /* String result = await resetPassword(); */
                          bool success = true;
                          String message = "";
                          if (success) {
                            errorFlag = false;
                            errorMessage = "";
                            Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => NewPassword()));
                          } else {
                            setState(() {
                              errorFlag = true;
                              errorMessage = message;
                            });
                          }
                        }
                      }),
                ],
              )),
        ),
      ),
    );
  }
}
