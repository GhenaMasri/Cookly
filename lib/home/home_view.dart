import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/menu/user_kitchens_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/order/cart.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedLocation;
  late Future<void> _initDataFuture;
  String? username;
  int? selectedCategoryId;
  List<Map<String, dynamic>> menuArr = [];

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadUserName();
    await _updateMenuArr();
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

  Future<void> _loadUserName() async {
    String? name = await SharedPreferencesService.getUserName();
    if (mounted) {
      setState(() {
        username = name;
      });
    }
  }

  Future<List<Map<String, dynamic>>> kitchensByCategories({String? city, int? category}) async {
    final Uri uri = Uri.parse('${SharedPreferencesService.url}home-page')
        .replace(queryParameters: {
      if (city != null) 'city': city,
      if (category != null) 'category': category.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> kitchensCount = data['kitchensCount'];
      if (mounted) {
        setState(() {
          menuArr = kitchensCount.map((category) {
            return {
              'id': category['id'],
              'category': category['category'],
              'count': category['kitchen_count'],
              'image': category['image']
            };
          }).toList();
        });
      }
      return menuArr;
    } else {
      throw Exception('Failed to load categories count');
    }
  }

  Future<void> _updateMenuArr() async {
    try {
      List<Map<String, dynamic>> result = [];
      String? city = selectedLocation;
      int? category = selectedCategoryId;

      result = await kitchensByCategories(city: city, category: category);

      if (mounted) {
        setState(() {
          menuArr = result;
        });
      }
    } catch (error) {
      print('Error loading menu items: $error');
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

  List<Map<String, dynamic>> categories = [];
  List<String> categoriesList = [];
  String? category;

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
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 200,
            child: Container(
              width: media.width * 0.27,
              height: media.height,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        username != null ? "Hello $username!" : "Hello!",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Container(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/img/notification.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
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
                                _updateMenuArr();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Add some space between the dropdowns
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
                                _updateMenuArr();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (menuArr.isEmpty)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
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
                        "There are no kitchens in this\n location and/or category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
                    itemCount: menuArr.length,
                    itemBuilder: ((context, index) {
                      var mObj = menuArr[index] as Map? ?? {};
                      return GestureDetector(
                        onTap: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuItemsView(
                                mObj: mObj,
                              ),
                            ),
                          );*/
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 90,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 7,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 4),
                                    ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: mObj["image"],
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: Center(
                                            child: CircularProgressIndicator(
                                                color: TColor.primary),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 12),
                                          Text(
                                            mObj["category"].toString(),
                                            style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${mObj["count"].toString()} Kitchens",
                                            style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  pushReplacementWithAnimation(
                                      context,
                                      UserKitchensView(
                                          mObj: mObj,
                                          location: selectedLocation));
                                  /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserKitchensView(
                                          mObj: mObj,
                                          location: selectedLocation),
                                    ),
                                  ); */
                                },
                                icon: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(17.5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/img/btn_next.png",
                                    width: 15,
                                    height: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
