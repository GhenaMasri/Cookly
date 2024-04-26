import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/signin.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key});

  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup> {
  String? user;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _phone;
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 230, 81, 0),
          Color.fromARGB(255, 239, 108, 0),
          Color.fromARGB(255, 239, 167, 38)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome To Cookly!",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Let's create your account",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Form(
                        key: formState,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(
                                              240, 144, 104, 0.988),
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
                                                255, 238, 238, 238),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Couldn't be empty";
                                                }
                                              },
                                              onSaved: (newValue) {
                                                _firstName = newValue;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "First Name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                errorStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 230, 81, 0)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Couldn't be empty";
                                                }
                                              },
                                              onSaved: (newValue) {
                                                _lastName = newValue;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Last Name",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                errorStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 230, 81, 0)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                        validator: _validateEmail,
                                        onSaved: (value) {
                                          _email = value;
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
                                        validator: _validatePassword,
                                        controller: _passwordController,
                                        onSaved: (value) {
                                          _password = value;
                                        },
                                        obscureText: !_passwordVisible,
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          errorStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 81, 0)),
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
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 238, 238, 238)))),
                                      child: TextFormField(
                                        validator: (value) {
                                          return _validateConfirmPassword(
                                              value);
                                        },
                                        onSaved: (value) {
                                          _confirmPassword = value;
                                        },
                                        obscureText: !_confirmPasswordVisible,
                                        decoration: InputDecoration(
                                          hintText: "Confirm Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          errorStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 230, 81, 0)),
                                          border: InputBorder.none,
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
                                        keyboardType: TextInputType.number,
                                        validator: _validatePhoneNumber,
                                        onSaved: (value) {
                                          _phone = value;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Phone Number",
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
                                                255, 238, 238, 238),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Text("User:",
                                              style: TextStyle(fontSize: 16)),
                                          const SizedBox(
                                              width:
                                                  10), // Add spacing between the label and radio button
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
                                                      user = value;
                                                    });
                                                  },
                                                ),
                                                const Text(
                                                  "Normal",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
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
                                                      user = value;
                                                    });
                                                  },
                                                ),
                                                const Text("Chef",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => Signin()));
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 230, 81, 0),
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (formState.currentState!.validate()) {
                                    formState.currentState!.save();
                                    //check the credintials in db if correct navigate to next page
                                    /*if( valid credintials ) {
                                    
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                                    }*/
                                  }
                                },
                                color: const Color.fromARGB(255, 230, 81, 0),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                minWidth: 200,
                                height: 50,
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          ),
                        ))))
          ],
        ),
      ),
    ));
  }
}
