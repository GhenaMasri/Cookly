import 'package:flutter/material.dart';
import 'package:untitled/main_page.dart';
import 'package:untitled/reset_password.dart';
import 'package:untitled/signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  const Signin({Key? key});

  @override
  State<StatefulWidget> createState() => _Signin();
}

class _Signin extends State<Signin> {
  bool _passwordVisible = false;
  GlobalKey<FormState> formState = GlobalKey();
  String? email;
  String? password;
  String errorMessage = '';

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> signIn() async {
    const url = 'http://192.168.1.106:3000/signin';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Sign in successful'};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 230, 81, 0),
          Color.fromARGB(255, 239, 108, 0),
          Color.fromARGB(255, 239, 167, 38)
        ])),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 88,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Welcome Back!",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Form(
                    key: formState,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(240, 144, 104, 0.988),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)),
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 238, 238, 238)))),
                                  child: TextFormField(
                                    onSaved: (newValue) {
                                      email = newValue;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter the email";
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                        errorStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 230, 81, 0)),
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 238, 238, 238)))),
                                  child: TextFormField(
                                    obscureText: (!_passwordVisible),
                                    onSaved: (newValue) {
                                      password = newValue;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter your password";
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      errorStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 230, 81, 0)),
                                      border: InputBorder.none,
                                      suffixIcon: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ResetPassword()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Signup()));
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 230, 81, 0),
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                formState.currentState!.save();
                                Map<String, dynamic> result = await signIn();
                                bool success = result['success'];
                                String message = result['message'];
                                print(success);
                                print(message);
                                //check the credintials in db if correct navigate to home page
                                if (success) {
                                  setState(() {
                                    errorMessage = "";
                                  });
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MainView()));
                                  //Save the credentials
                                } else {
                                  setState(() {
                                    errorMessage = message;
                                  });
                                }
                              }
                            },
                            color: const Color.fromARGB(255, 230, 81, 0),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            minWidth: 200,
                            height: 50,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            errorMessage,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 230, 81, 0),
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    )))
          ],
        )),
      ),
    ));
  }
}
