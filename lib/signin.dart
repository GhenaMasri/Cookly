import 'package:flutter/material.dart';
import 'package:untitled/admin/admin_main.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/delivery/delivery_main.dart';
import 'package:untitled/main_page.dart';
import 'package:untitled/reset_password.dart';
import 'package:untitled/signup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/home/chef_home_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
  bool errorFlag = false;
  late Map<String, dynamic> userData;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> signIn() async {
    const url = '${SharedPreferencesService.url}signin';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        userData = responseData['user'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _clearSharedPreferences();
        await prefs.setBool('isSet', true);
        _saveDataToSharedPreferences(
            userData['id'],
            userData['first_name'],
            userData['last_name'],
            userData['email'],
            userData['phone'],
            userData['type']);
        if (userData['type'] == "chef") {
          //store kitchen id in shared preferences
          int chefId = await getChefId(userData['email']);
          await prefs.setInt('kitchen_id', chefId);
          //store kitchen name in shared preferences
          String kitchenName = await getKitchenName(chefId);
          await prefs.setString('kitchen_name', kitchenName);
        } else if (userData['type'] == "delivery") {
          //store delivery id in shared preferences
          int deliveryId = await getDeliveryId(userData['id']);
          await prefs.setInt('delivery_id', deliveryId);
        }
        //save FCM token
        await _saveFCMToken(userData['id']);
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<int> getDeliveryId(int userId) async {
    final response = await http.get(
      Uri.parse('${SharedPreferencesService.url}get-delivery-id?id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['delieryId'];
    } else {
      throw Exception('Failed to load delivery id');
    }
  }

  Future<int> getChefId(String email) async {
    final response = await http.get(
      Uri.parse('${SharedPreferencesService.url}chefId?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['chefId'];
    } else {
      throw Exception('Failed to load chef id');
    }
  }

  Future<String> getKitchenName(int chefId) async {
    final response = await http.get(
      Uri.parse('${SharedPreferencesService.url}kitchenName?chefId=$chefId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['kitchenName'];
    } else {
      throw Exception('Failed to load kitchen name');
    }
  }

  Future<void> _saveDataToSharedPreferences(int id, String firstName,
      String lastName, String email, String phone, String type) async {
    await SharedPreferencesService.saveDataAfterSignin(
        id, firstName, lastName, email, phone, type);
  }

  Future<void> _clearSharedPreferences() async {
    await SharedPreferencesService.clearSharedPreferences();
  }

  Future<void> _saveFCMToken(int id) async {

    String? token = await FirebaseMessaging.instance.getToken();
    await http.post(
      Uri.parse('${SharedPreferencesService.url}save-token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'token': token!,
        'userId': '$id',
      }),
    );
  }
  //////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                    width: media.width,
                    height: media.height,
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
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Visibility(
                                visible: errorFlag,
                                child: Text(errorMessage,
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 230, 81, 0),
                                      fontSize: 16,
                                    )),
                              ),
                              Visibility(
                                  visible: errorFlag,
                                  child: SizedBox(height: 8)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResetPassword()));
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
                                              builder: (context) =>
                                                  const Signup()));
                                    },
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        "Sign up",
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
                                onPressed: () async {
                                  if (formState.currentState!.validate()) {
                                    formState.currentState!.save();
                                    ////////////////////////// BACKEND SECTION ///////////////////////////
                                    Map<String, dynamic> result =
                                        await signIn();
                                    bool success = result['success'];
                                    String message = result['message'];
                                    print(success);
                                    ////////////////////////////////////////////////////////////////////////
                                    if (success) {
                                      setState(() {
                                        errorFlag = false;
                                        errorMessage = "";
                                      });
                                      print(userData['type']);
                                      if (userData['type'] == "admin") {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminMainView()));
                                      } else if (userData['type'] ==
                                          "delivery") {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DeliveryMainView()));
                                      } else {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MainView()));
                                      }
                                    } else {
                                      setState(() {
                                        errorFlag = true;
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
                            ],
                          ),
                        )))
              ],
            )),
          ),
        ));
  }
}
