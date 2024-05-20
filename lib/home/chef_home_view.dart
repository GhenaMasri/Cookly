import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/menu/manage_menu_item.dart';
import 'package:untitled/menu/menu_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChefHomeView extends StatefulWidget {
  const ChefHomeView({Key? key}) : super(key: key);

  @override
  State<ChefHomeView> createState() => _ChefHomeViewState();
}

class _ChefHomeViewState extends State<ChefHomeView> {
  String? selectedLocation;
  TextEditingController txtSearch = TextEditingController();
  int? kitchenId;
  late Future<void> _initDataFuture;
  List<Map<String, dynamic>> categories = [];

  late List<MenuItem> menuArr = [];
  void addItemToList(MenuItem item) {
    setState(() {
      menuArr.add(item);
      //Also Add to DB
    });
  }

  void RemoveItemFromList(MenuItem item) {
    setState(() {
      menuArr.remove(item);
      //Also remove from DB
    });
  }

  void updateMenuItem(MenuItem updatedItem) {
    setState(() {
      final index =
          menuArr.indexWhere((item) => item.itemId == updatedItem.itemId);
      if (index != -1) {
        menuArr[index] = updatedItem;
        //Also update in DB
      }
    });
  }

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<List<MenuItem>> chefMenuItems() async {
    final url =
        '${SharedPreferencesService.url}chef-menu-items?kitchenId=$kitchenId';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'];
        List<MenuItem> menuItems = data.map((item) {
          return MenuItem(
            kitchenId: item['kitchen_id'],
            itemId: item['id'],
            image: item['image'],
            name: item['name'],
            notes: item['notes'],
            quantity: item['quantity_id'],
            category: item['category_id'],
            price: item['price'].toDouble(),
            time: item['time'],
          );
        }).toList();
        return menuItems;
      } else {
        throw Exception('Failed to load menu items');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<Map<String, dynamic>>> getFoodCategories() async {
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}food-categories'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];
      final List<Map<String, dynamic>> categories =
          categoryList.map((category) {
        return {'id': category['id'], 'category': category['category']};
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to load food categories');
    }
  }

  Future<List<MenuItem>> searchMenuItems(String query) async {
    final url = '${SharedPreferencesService.url}search-menu-items';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kitchenId': kitchenId,
          'query': query,
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'];
        List<MenuItem> menuItems = data.map((item) {
          return MenuItem(
            kitchenId: item['kitchen_id'],
            itemId: item['id'],
            image: item['image'],
            name: item['name'],
            notes: item['notes'],
            quantity: item['quantity_id'],
            category: item['category_id'],
            price: item['price'].toDouble(),
            time: item['time'],
          );
        }).toList();
        return menuItems;
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    setState(() {
      kitchenId = kitchenid;
    });
    try {
      await _updateMenuArr();
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }

  Future<void> _updateMenuArr() async {
    try {
      List<MenuItem> items;
      var fetchedCategories = await getFoodCategories();
      if (txtSearch.text.isNotEmpty) {
        items = await searchMenuItems(txtSearch.text);
      } else {
        items = await chefMenuItems();
      }
      setState(() {
        menuArr = items;
        categories = fetchedCategories;
      });
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

  String getCategoryName(int categoryId) {
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'id': categoryId, 'category': 'Unknown'},
    );
    return category['category'];
  }

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadKitchenId();
    txtSearch.addListener(_updateMenuArr);
  }

  @override
  void dispose() {
    txtSearch.removeListener(_updateMenuArr);
    txtSearch.dispose();
    super.dispose();
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
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 46),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Menu",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Notifications()));*/
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundTextfield(
                hintText: "Search",
                controller: txtSearch,
                left: Container(
                  alignment: Alignment.center,
                  width: 30,
                  child: Image.asset(
                    "assets/img/search.png",
                    width: 20,
                    height: 20,
                    color: TColor.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            if (menuArr.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Text(
                    "Start Adding Your Menu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                itemCount: menuArr.length,
                itemBuilder: ((context, index) {
                  var menuItem = menuArr[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageMenuItemView(
                            RemoveItemFromList: RemoveItemFromList,
                            updateMenuItem: updateMenuItem,
                            item: menuItem,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 3),
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: menuItem.image!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),

                            /* ClipOval(
                              child: Image.network(
                                menuItem.image!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),*/
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 12),
                                  Text(
                                    menuItem.name!,
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Category: ${getCategoryName(menuItem.category!)}",
                                    style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageMenuItemView(
                                      RemoveItemFromList: RemoveItemFromList,
                                      updateMenuItem: updateMenuItem,
                                      item: menuItem,
                                    ),
                                  ),
                                );
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
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MenuItemView(menu: menuArr, addItemToList: addItemToList),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: TColor.primary,
        foregroundColor: TColor.white,
        child: Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
