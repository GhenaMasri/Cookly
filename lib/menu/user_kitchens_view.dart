import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/custom_list_tile.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/menu/kitchen_menu.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/order/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../common_widget/menu_item_row.dart';
import 'package:untitled/common/globs.dart';

class UserKitchensView extends StatefulWidget {
  final Map mObj;
  final String? location;

  const UserKitchensView({
    super.key,
    required this.mObj,
    required this.location,
  });

  @override
  State<UserKitchensView> createState() => _UserKitchensViewState();
}

class _UserKitchensViewState extends State<UserKitchensView> {
  TextEditingController txtSearch = TextEditingController();
  String? selectedLocation;
  late Future<void> _initDataFuture;
  List<Map<String, dynamic>> kitchens = [];

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<List<Map<String, dynamic>>> kitchensPerCategory({
    required int categoryId,
    String? city,
    String? name,
  }) async {
    final Uri uri = Uri.parse('${SharedPreferencesService.url}kitchens').replace(queryParameters: {
      'category_id': categoryId.toString(),
      if (city != null) 'city': city,
      if (name != null) 'name': name,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> kitchensPerCategory = data['kitchens'];
      setState(() {
        kitchens = kitchensPerCategory.map((kitchen) {
          return {
            'id': kitchen['id'],
            'kitchen_name': kitchen['kitchen_name'],
            'logo': kitchen['logo'],
            'category_name': kitchen['category_name'],
            'rates_num': kitchen['rates_num'],
            'rate': kitchen['rate'],
            'order_system': kitchen['order_system'],
            'status': 'open', // Replace this with actual status
            'street': kitchen['street'], 
            'contact': kitchen['contact'],
            'city': kitchen['city']
          };
        }).toList();
      });
      return kitchens;
    } else {
      throw Exception('Failed to load kitchens');
    }
  }

  Future<void> _updateKitchensArr() async {
    try {
      List<Map<String, dynamic>> result = [];
      int categoryId = widget.mObj["id"];
      String? city = selectedLocation;
      String? name = txtSearch.text.isNotEmpty ? txtSearch.text : null;

      result = await kitchensPerCategory(categoryId: categoryId, city: city, name: name);

      setState(() {
        kitchens = result;
      });
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
    if (widget.location != null) selectedLocation = widget.location;
    txtSearch.addListener(_updateKitchensArr);
  }

  @override
  void dispose() {
    txtSearch.removeListener(_updateKitchensArr);
    txtSearch.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await kitchensPerCategory(
      categoryId: widget.mObj['id'],
      city: widget.location,
      name: txtSearch.text.isNotEmpty ? txtSearch.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: TColor.primary));
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
      backgroundColor: TColor.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 46),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Category: " + widget.mObj["category"].toString(),
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            pushReplacementWithAnimation(
                            context, NotificationsView());
                          },
                          icon: Image.asset("assets/img/notification.png", width: 25, height: 25),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivering to",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                        MyDropdownMenu(
                          value: selectedLocation,
                          onChanged: (newValue) {
                            setState(() {
                              selectedLocation = newValue;
                              _updateKitchensArr();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundTextfield(
                      hintText: "Search by kitchen name",
                      controller: txtSearch,
                      left: Container(
                        alignment: Alignment.center,
                        width: 30,
                        child: Image.asset(
                          "assets/img/search.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          if (kitchens.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "There is no kitchens with this\n name or in this location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 7.5 / 10,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var mObj = kitchens[index];
                    return CustomListTile(
                      mObj: mObj,
                      onTap: () {
                        pushReplacementWithAnimation(context, KitchenMenuView(mObj: mObj));
                        /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    KitchenMenuView(mObj: mObj))); */
                      },
                    );
                  },
                  childCount: kitchens.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
