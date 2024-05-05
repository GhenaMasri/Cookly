import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:untitled/chef_signup_more.dart';
import 'package:untitled/common/kitchenData.dart';
import 'package:untitled/common_widget/customformfield.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/image_selection.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/signin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChefSignup extends StatefulWidget {
  const ChefSignup({Key? key});

  @override
  State<StatefulWidget> createState() => _ChefSignup();
}

class _ChefSignup extends State<ChefSignup> {
  TextEditingController txtName = TextEditingController();
  String errorMessage = '';
  File? _image;
  String? location;
  String? name;
  String? phone;
  String? street;
  late KitchenData kitchenData;

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This Field is required';
    }

    return null;
  }

  void saveName(String? value) {
    name = value;
  }

  void savePhone(String? value) {
    phone = value;
  }

  void saveStreet(String? value) {
    street = value;
  }

  GlobalKey<FormState> formState = GlobalKey();
  bool errorFlag = false;

  @override
  void initState() {
    super.initState();
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Check if the phone number is 10 digits long
    if (value.length != 10 || value.length != 9) {
      return 'Phone number must be 9 or 10 digits long';
    }
    // Check if the phone number starts with either 059 or 056
    if (!value.startsWith('059') &&
        !value.startsWith('056') &&
        !value.startsWith('092')) {
      return 'Phone number must start with 092 or 059 or 056';
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
                        "Complete Registration",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Add more information",
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
                                RoundTextfield(
                                  hintText: "Business Name",
                                  controller: txtName,
                                  validator: validateField,
                                  onSaved: saveName,
                                ),
                                SizedBox(height: 15),
                                ImageSelectionTextField(
                                  image: _image,
                                  onTap: _getImageFromGallery,
                                ),
                                SizedBox(height: 15),
                                RoundDropdown(
                                    value: null, // Initial value
                                    hintText: 'Select City',
                                    items: [
                                      'Nablus',
                                      'Jenin',
                                      'Ramallah',
                                      'Tulkarm'
                                    ],
                                    onChanged: (String? value) {
                                      location = value;
                                    }),
                                SizedBox(height: 15),
                                RoundTextfield(
                                  hintText: "Street",
                                  controller: txtName,
                                  validator: validateField,
                                  onSaved: saveStreet,
                                ),
                                SizedBox(height: 15),
                                RoundTextfield(
                                  hintText: "Contact Number",
                                  keyboardType: TextInputType.number,
                                  validator: _validatePhoneNumber,
                                  onSaved: savePhone,
                                  controller: txtName,
                                ),
                                SizedBox(height: 15),
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
                          SizedBox(height: 10),
                          MaterialButton(
                            onPressed: () async {
                              if (formState.currentState!.validate()) {
                                formState.currentState!.save();

                                bool success = true;
                                String message = "";
                                //print(success);
                                print(message);
                                // Check the credentials in db if correct navigate to next page
                                if (success) {
                                  setState(() {
                                    errorFlag = false;
                                    errorMessage = "";
                                  });
                                  kitchenData = KitchenData(
                                      image: this._image,
                                      name: this.name,
                                      location: this.location,
                                      phone: this.phone,
                                      street: this.street);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                               ChefSignupDetails(
                                                MykitchenData: kitchenData,
                                              )));
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
                              "Next",
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
