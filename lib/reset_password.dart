import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import 'new_password.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController txtEmail = TextEditingController();
  String? email = "wasanjehad75@gmail.com";

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<String> resetPassword() async {
    const url = 'http://192.168.1.106:3000/reset-password';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email
        }),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
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
                hintText: "Your Email",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 30,
              ),
              RoundButton(
                  title: "Send",
                  onPressed: () async {
                    String result = await resetPassword();
                    print(result);
                    /*Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => NewPassword()));*/
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
