
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/kitchenData.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/round_textarea.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/signin.dart';
import 'package:untitled/common/globs.dart';

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
  int? selectedCategory; //id of the selected category
  String? description;
  String? orderingSystem;
  String? specialOrders = "Yes";
  List<String> categoriesList = [];
  List<Map<String, dynamic>> categories = [];
  late Future<void> _initDataFuture;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> chefSignUp() async {
    const url = '${SharedPreferencesService.url}chef-signup';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': widget.MykitchenData.name,
          'logo': widget.MykitchenData.image,
          'description': widget.MykitchenData.description,
          'city': widget.MykitchenData.location,
          'street': widget.MykitchenData.street,
          'contact': widget.MykitchenData.phone,
          'category_id': selectedCategory,
          'order_system': widget.MykitchenData.orderingSystem,
          'special_orders': widget.MykitchenData.specialOrders,
          'user_id': widget.MykitchenData.userId,
        }),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<List<Map<String, dynamic>>> getKitchenCategories() async {
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}kitchen-categories'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];
      final List<Map<String, dynamic>> categories =
          categoryList.map((category) {
        return {'id': category['id'], 'category': category['category']};
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to load kitchen categories');
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

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
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    try {
      var fetchedCategories = await getKitchenCategories();

      setState(() {
        categories = fetchedCategories;

        for (var element in categories) {
          if (element.containsKey('category')) {
            categoriesList.add(element['category']);
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
    return Scaffold(
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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: TColor.white,
                      ),
                    ),

                    // SizedBox(width: 40), // Add SizedBox to provide spacing
                  ],
                ),
              ),
              //const SizedBox(height: 4),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                height: MediaQuery.of(context).size.height,
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                                  value: category, // Initial value
                                  hintText: 'Select Category',
                                  items: categoriesList,
                                  validator: validateField,
                                  onChanged: (String? value) {
                                    setState(() {
                                      category = value;
                                      if (value != null) {
                                        var selectedItem =
                                            categories.firstWhere(
                                                (element) =>
                                                    element['category'] ==
                                                    value,
                                                orElse: () => {});
                                        selectedCategory = selectedItem['id'];
                                      }
                                    });
                                  }),
                              SizedBox(height: 15),
                              RoundDropdown(
                                  value: orderingSystem, // Initial value
                                  hintText: 'Ordering System',
                                  validator: validateField,
                                  items: [
                                    'Order in the same day',
                                    'Order the day before'
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      orderingSystem = value;
                                    });
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
                                          activeColor:
                                              Color.fromARGB(255, 239, 108, 0),
                                          value: "Yes",
                                          groupValue: specialOrders,
                                          onChanged: (value) {
                                            setState(() {
                                              specialOrders = value.toString();
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
                                          activeColor:
                                              Color.fromARGB(255, 239, 108, 0),
                                          value: "No",
                                          groupValue: specialOrders,
                                          onChanged: (value) {
                                            setState(() {
                                              specialOrders = value.toString();
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
                              widget.MykitchenData.description = description;
                              widget.MykitchenData.category = selectedCategory;
                              if (orderingSystem == 'Order the day before') {
                                widget.MykitchenData.orderingSystem = 0;
                              } else {
                                widget.MykitchenData.orderingSystem = 1;
                              }
                              widget.MykitchenData.specialOrders =
                                  specialOrders;
                              /////////////////////// BACKEND SECTION /////////////////////////
                              Map<String, dynamic> result = await chefSignUp();
                              bool success = result['success'];
                              String message = result['message'];
                              print(success);
                              print(message);
                              ////////////////////////////////////////////////////////////////
                              if (success) {
                                setState(() {
                                  errorFlag = false;
                                  errorMessage = "";
                                });
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Signin()));
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
    );
  }
}
