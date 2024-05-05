import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/kitchenData.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/image_selection.dart';
import 'package:untitled/common_widget/round_textarea.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/signin.dart';

class ChefSignupDetails extends StatefulWidget {
  KitchenData MykitchenData;

  ChefSignupDetails({
    Key? key,
    required this.MykitchenData,
  });

  @override
  State<StatefulWidget> createState() => _ChefSignupDetails();
}

class _ChefSignupDetails extends State<ChefSignupDetails> {
  TextEditingController txtName = TextEditingController();
  String errorMessage = '';
  String? category;
  String? description;
  String? orderingSystem;
  String? specialOrders = "Yes";

  String? validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This Field is required';
    }

    return null;
  }

  void saveDescription(String? value) {
    description = value;
  }

  GlobalKey<FormState> formState = GlobalKey();
  bool errorFlag = false;

  @override
  void initState() {
    super.initState();
    specialOrders = "Yes";
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
                        "Last Step",
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
                                RoundTextArea(
                                  hintText: "Description",
                                  controller: txtName,
                                  validator: validateField,
                                  onSaved: saveDescription,
                                ),
                                SizedBox(height: 15),
                                RoundDropdown(
                                    value: null, // Initial value
                                    hintText: 'Select Category',
                                    items: [
                                      'Food',
                                      'Dessert',
                                      'Bakery',
                                      'Yalanji'
                                    ],
                                    onChanged: (String? value) {
                                      category = value;
                                    }),
                                SizedBox(height: 15),
                                RoundDropdown(
                                    value: null, // Initial value
                                    hintText: 'Ordering System',
                                    items: [
                                      'Order in the same day',
                                      'Order the day before'
                                    ],
                                    onChanged: (String? value) {
                                      orderingSystem = value;
                                    }),
                                SizedBox(height: 15),
                                Row(
                                  children: [
                                    Text("Special Orders:",
                                        style: TextStyle(fontSize: 16)),
                                    SizedBox(width: 10),
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Radio(
                                            activeColor: Color.fromARGB(
                                                255, 239, 108, 0),
                                            value: "Yes",
                                            groupValue: specialOrders,
                                            onChanged: (value) {
                                              setState(() {
                                                specialOrders =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                          Text("Yes",
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
                                            value: "No",
                                            groupValue: specialOrders,
                                            onChanged: (value) {
                                              setState(() {
                                                specialOrders =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                          Text("No",
                                              style: TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '(Custom user orders)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: TColor.secondaryText,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
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
                                if (success) {
                                  widget.MykitchenData.description =
                                      description;
                                  widget.MykitchenData.category = category;
                                  widget.MykitchenData.orderingSystem =
                                      orderingSystem;
                                  widget.MykitchenData.specialOrders =
                                      specialOrders;

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
                              "Register",
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
