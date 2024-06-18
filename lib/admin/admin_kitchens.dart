import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/admin/kitchen_details.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/common_widget/slide_animation.dart';

class AdminKitchensPage extends StatefulWidget {
  @override
  _AdminKitchensPageState createState() => _AdminKitchensPageState();
}

class _AdminKitchensPageState extends State<AdminKitchensPage> {
  String? selectedCity = 'Nablus';
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

  Future<List<dynamic>> getKitchens(
      {required String? city, int? categoryId}) async {
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
      String? city = selectedCity;
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
        padding: const EdgeInsets.all(10.0),
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
                  const SizedBox(width: 10),
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
                itemCount: adminKitchens.length,
                itemBuilder: (context, index) {
                  final kitchen = adminKitchens[index];
                  String status =
                      kitchen['is_active'] == 1 ? 'Active' : 'Expired';
                  return InkWell(
                      onTap: () {
                        pushReplacementWithAnimation(context,
                            KitchenDetailsPage(kitchenId: kitchen['id']));
                      },
                      child: Card(
                        color: TColor.white,
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: kitchen['logo'],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: TColor.primary,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            kitchen['kitchen_name'],
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
                                    kitchen['is_active'] == 1
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: kitchen['is_active'] == 1
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: kitchen['is_active'] == 1
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
                                    color: TColor.primary,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '${kitchen['rate'].toStringAsFixed(2)} / 5',
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
                                    kitchen['contact'],
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
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
