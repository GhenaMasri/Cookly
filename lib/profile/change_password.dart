import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _MenuItemsViewState();
}

class _MenuItemsViewState extends State<ChangePasswordView> {
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  TextEditingController txtOldPassword = TextEditingController();
  String errorMessage = '';
  GlobalKey<FormState> formState = GlobalKey();
  bool errorFlag = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: formState,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/img/btn_back.png",
                              width: 20, height: 20),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Old Password",
                      hintText: "* * * * * *",
                      obscureText: true,
                      controller: txtOldPassword,
                       validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Password",
                      hintText: "* * * * * *",
                      obscureText: true,
                      controller: txtPassword,
                      validator: _validatePassword,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Confirm Password",
                      hintText: "* * * * * *",
                      obscureText: true,
                      controller: txtConfirmPassword,
                      validator: _validateConfirmPassword,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: errorFlag,
                    child: Text(errorMessage,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 230, 81, 0),
                          fontSize: 16,
                        )),
                  ),
                  Visibility(visible: errorFlag, child: SizedBox(height: 8)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundButton(
                        title: "Save",
                        onPressed: () {
                          if (formState.currentState!.validate()) {
                            //Check if the old password == the one in the db

                            //Don't forget to hash the new password

                            //Use txtPassword.text

                            /*if (success) {
                                setState(() {
                                  errorFlag = false;
                                  errorMessage = "";
                                });
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  errorFlag = true;
                                  errorMessage = message;
                                });
                              }*/
                          }
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
