import 'package:flutter/material.dart';
import 'package:untitled/common_widget/customformfield.dart';
import 'package:untitled/signin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({Key? key});

  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup> {
  String? user = "Normal";
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _phone;
  String errorMessage = '';
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool errorFlag = false;

  @override
  void initState() {
    super.initState();
    //Default Value
    user = "Normal";
  }

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> signUp() async {
    const url = 'http://192.168.1.106:3000/signup';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': _firstName,
          'lastName': _lastName,
          'email': _email,
          'password': _password,
          'phone': _phone,
          'userType': user,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Sign up successful'};
      } else if (response.statusCode == 400) {
        return {'success': false, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regular Expression for email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

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
    String? password = _passwordController.text;

    if (password == null || value == null || password != value) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Check if the phone number is 10 digits long
    if (value.length != 10) {
      return 'Phone number must be 10 digits long';
    }
    // Check if the phone number starts with either 059 or 056
    if (!value.startsWith('059') && !value.startsWith('056')) {
      return 'Phone number must start with 059 or 056';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 230, 81, 0),
                Color.fromARGB(255, 239, 108, 0),
                Color.fromARGB(255, 239, 167, 38)
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome To Cookly!",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Let's create your account",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(240, 144, 104, 0.988),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CustomFormFields.buildTextFormField(
                                  hintText: "First Name",
                                  validator: (value) => value!.isEmpty
                                      ? "Couldn't be empty"
                                      : null,
                                  onSaved: (newValue) => _firstName = newValue,
                                ),
                                SizedBox(height: 10),
                                CustomFormFields.buildTextFormField(
                                  hintText: "Last Name",
                                  validator: (value) => value!.isEmpty
                                      ? "Couldn't be empty"
                                      : null,
                                  onSaved: (newValue) => _lastName = newValue,
                                ),
                                SizedBox(height: 10),
                                CustomFormFields.buildTextFormField(
                                  hintText: "Email",
                                  validator: _validateEmail,
                                  onSaved: (value) => _email = value,
                                ),
                                SizedBox(height: 10),
                                CustomFormFields.buildTextFormField(
                                  hintText: "Password",
                                  validator: _validatePassword,
                                  controller: _passwordController,
                                  onSaved: (value) => _password = value,
                                  obscureText: !_passwordVisible,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    child: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomFormFields.buildTextFormField(
                                  hintText: "Confirm Password",
                                  validator: (value) =>
                                      _validateConfirmPassword(value),
                                  onSaved: (value) => _confirmPassword = value,
                                  obscureText: !_confirmPasswordVisible,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _confirmPasswordVisible =
                                            !_confirmPasswordVisible;
                                      });
                                    },
                                    child: Icon(
                                      _confirmPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                CustomFormFields.buildTextFormField(
                                  hintText: "Phone Number",
                                  keyboardType: TextInputType.number,
                                  validator: _validatePhoneNumber,
                                  onSaved: (value) => _phone = value,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text("User:",
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Radio(
                                            activeColor: Color.fromARGB(
                                                255, 239, 108, 0),
                                            value: "Normal",
                                            groupValue: user,
                                            onChanged: (value) {
                                              setState(() {
                                                user = value.toString();
                                              });
                                            },
                                          ),
                                          Text("Normal",
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Radio(
                                            activeColor: Color.fromARGB(
                                                255, 239, 108, 0),
                                            value: "Chef",
                                            groupValue: user,
                                            onChanged: (value) {
                                              setState(() {
                                                user = value.toString();
                                              });
                                            },
                                          ),
                                          Text("Chef",
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Visibility(
                            visible: errorFlag,
                            child: Text(errorMessage,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 230, 81, 0),
                                  fontSize: 16,
                                )),
                          ),
                          Visibility(
                              visible: errorFlag, child: SizedBox(height: 8)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Signin()));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 230, 81, 0),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          MaterialButton(
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                formState.currentState!.save();
                                Map<String, dynamic> result = await signUp();
                                bool success = result['success'];
                                String message = result['message'];
                                //print(success);
                                print(message);
                                // Check the credentials in db if correct navigate to next page
                                if (success) {
                                  setState(() {
                                    errorFlag = false;
                                    errorMessage = "";
                                  });
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Signin()));
                                } else {
                                  setState(() {
                                    errorFlag = true;
                                    errorMessage = message;
                                  });
                                }
                              }
                            },
                            color: Color.fromARGB(255, 230, 81, 0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            minWidth: 200,
                            height: 50,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
