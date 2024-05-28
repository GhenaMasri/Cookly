import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/menu/rating_page.dart';
import 'package:untitled/order/cart.dart';
import 'package:untitled/order/item_details_view.dart';
import 'package:untitled/common/globs.dart';
import '../../common_widget/menu_item_row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/common/MenuItem.dart';

class KitchenMenuView extends StatefulWidget {
  final Map mObj;
  const KitchenMenuView({
    super.key,
    required this.mObj,
  });

  @override
  State<KitchenMenuView> createState() => _KitchenMenuViewState();
}

class _KitchenMenuViewState extends State<KitchenMenuView> {
  TextEditingController txtSearch = TextEditingController();
  List<MenuItem> menuArr = [];

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<List<MenuItem>> getMenuItems({required int kitchenId, String? name}) async {
    final Uri uri = Uri.parse('${SharedPreferencesService.url}chef-menu-items').replace(
      queryParameters: {
        'kitchenId': kitchenId,
        if (name != null) 'name': name,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      setState(() {
        menuArr = items.map((item) {
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
      });
      return menuArr;
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> _updateMenuArr() async {
    try {
      List<MenuItem> result = [];
      int kitchenId = widget.mObj["id"];
      String? name = txtSearch.text.isNotEmpty? txtSearch.text : null;

      result = await getMenuItems(kitchenId: kitchenId, name: name);
      
      setState(() {
        menuArr = result;
      });
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }
  /////////////////////////////////////////////////////////////////////////////////

  List menuItemsArr = [
    {
      "image": "assets/img/dess_1.png",
      "name": "French Apple Pie",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_2.png",
      "name": "Dark Chocolate Cake",
      "rate": "4.9",
      "rating": "124",
      "type": "Cakes by Tella",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_3.png",
      "name": "Street Shake",
      "rate": "4.9",
      "rating": "124",
      "type": "Café Racer",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_4.png",
      "name": "Fudgy Chewy Brownies",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_1.png",
      "name": "French Apple Pie",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_2.png",
      "name": "Dark Chocolate Cake",
      "rate": "4.9",
      "rating": "124",
      "type": "Cakes by Tella",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_3.png",
      "name": "Street Shake",
      "rate": "4.9",
      "rating": "124",
      "type": "Café Racer",
      "food_type": "Desserts"
    },
    {
      "image": "assets/img/dess_4.png",
      "name": "Fudgy Chewy Brownies",
      "rate": "4.9",
      "rating": "124",
      "type": "Minute by tuk tuk",
      "food_type": "Desserts"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/img/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        widget.mObj["name"].toString(),
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/img/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Container()));
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
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
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: menuItemsArr.length,
                itemBuilder: ((context, index) {
                  var mObj1 = menuItemsArr[index] as Map? ?? {};
                  return MenuItemRow(
                    mObj: mObj1,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemDetailsView()),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) {
                return const RateItemView();
              });
        },
        child: Icon(
          Icons.star,
          color: TColor.white,
        ),
        backgroundColor: TColor.primary,
      ),
    );
  }
}