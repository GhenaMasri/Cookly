import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:http/http.dart' as http;

class AdminKitchensPage extends StatefulWidget {
  @override
  _AdminKitchensPageState createState() => _AdminKitchensPageState();
}

class _AdminKitchensPageState extends State<AdminKitchensPage> {
  String selectedCity = 'Nablus';
  int? selectedCategoryId;
  late Future<void> _initDataFuture;
  List<Map<String, dynamic>> categories = [];
  List<String> categoriesList = [];
  String? category;
  List<dynamic> adminKitchens = [];

//////////////////////////////////////// BACKEND SECTION //////////////////////////////////////////
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

  Future<List<dynamic>> getKitchens({required String city, int? categoryId}) async {
    final Uri uri = Uri.parse('${SharedPreferencesService.url}get-kitchens')
        .replace(queryParameters: {
      'city': city,
      if (categoryId != null) 'category_id': categoryId.toString()
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['kitchens'];
    } else {
      throw Exception('Failed to load kitchens');
    }
  }

  Future<void> _updateAdminKitchensArray() async {
    try {
      List<dynamic> result = [];
      String city = selectedCity;
      int? categoryId = selectedCategoryId;

      result = await getKitchens(city: city, categoryId: categoryId);

      setState(() {
        print(result);
        adminKitchens = result;
      });
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    _updateAdminKitchensArray();
    try {
      var fetchedCategories = await getKitchenCategories();
      if (mounted) {
        setState(() {
          categories = fetchedCategories;

          for (var element in categories) {
            if (element.containsKey('category')) {
              categoriesList.add(element['category']);
            }
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }

  final Map<String, List<Kitchen>> kitchens = {
    'Nablus': [
      Kitchen('Kitchen 1', 'Active', 4.5, '123-456-7890'),
      Kitchen('Kitchen 2', 'Expired', 3.8, '123-456-7891'),
    ],
    'Ramallah': [
      Kitchen('Kitchen 3', 'Active', 4.2, '123-456-7892'),
      Kitchen('Kitchen 4', 'Expired', 3.5, '123-456-7893'),
    ],
    'Jenin': [
      Kitchen('Kitchen 5', 'Active', 4.0, '123-456-7894'),
      Kitchen('Kitchen 6', 'Expired', 3.7, '123-456-7895'),
    ],
    'Tulkarm': [
      Kitchen('Kitchen 7', 'Active', 4.1, '123-456-7896'),
      Kitchen('Kitchen 8', 'Expired', 3.9, '123-456-7897'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: TColor.primary));
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kitchens',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Location Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select City",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyDropdownMenu(
                          value: selectedCity,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCity = newValue!;
                              _updateAdminKitchensArray();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      width: 10),
                  // Category Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        CartDropdownMenu(
                          items: categoriesList,
                          hint: 'Choose Category',
                          value: category,
                          onChanged: (newValue) {
                            setState(() {
                              category = newValue;
                              var selectedItem = categories.firstWhere(
                                (element) => element['category'] == newValue,
                                orElse: () => {},
                              );
                              selectedCategoryId = selectedItem['id'];
                              _updateAdminKitchensArray();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: kitchens[selectedCity]!.length,
                itemBuilder: (context, index) {
                  final kitchen = kitchens[selectedCity]![index];
                  return Card(
                    color: TColor.white,
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: FaIcon(
                        FontAwesomeIcons.utensils,
                        color: Colors.teal,
                        size: 30,
                      ),
                      title: Text(
                        kitchen.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                kitchen.status == 'Active'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: kitchen.status == 'Active'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              SizedBox(width: 5),
                              Text(
                                kitchen.status,
                                style: TextStyle(
                                  color: kitchen.status == 'Active'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '${kitchen.rate} / 5',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5),
                              Text(
                                kitchen.contact,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Kitchen {
  final String name;
  final String status;
  final double rate;
  final String contact;

  Kitchen(this.name, this.status, this.rate, this.contact);
}
