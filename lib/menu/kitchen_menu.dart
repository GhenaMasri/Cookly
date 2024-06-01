import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common_widget/slide_animation.dart';
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
  late Future<void> _initDataFuture;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<List<MenuItem>> getMenuItems(
      {required int kitchenId, String? name}) async {
    final Uri uri =
        Uri.parse('${SharedPreferencesService.url}chef-menu-items').replace(
      queryParameters: {
        'kitchenId': kitchenId.toString(),
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
            cName: item['category_name'],
            price: item['price'].toDouble(),
            time: item['time'],
            qName: item['quantity_name']
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
      String? name = txtSearch.text.isNotEmpty ? txtSearch.text : null;

      result = await getMenuItems(kitchenId: kitchenId, name: name);

      setState(() {
        menuArr = result;
      });
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }
  /////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    txtSearch.addListener(_updateMenuArr);
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    int kitchenId = widget.mObj["id"];
    String? name = txtSearch.text.isNotEmpty ? txtSearch.text : null;
    getMenuItems(kitchenId: kitchenId, name: name);
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
                        "Kitchen: ${widget.mObj["kitchen_name"].toString()}",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        pushReplacementWithAnimation(context,CartPage(kitchen:widget.mObj));
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(kitchen:widget.mObj),
                          ),
                        ); */
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
                  hintText: "Search for item",
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
                itemCount: menuArr.length,
                itemBuilder: ((context, index) {
                  var mObj1 = menuArr[index];
                  return MenuItemRow(
                    mObj: mObj1,
                    onTap: () {
                      pushReplacementWithAnimation(context,ItemDetailsView(item: mObj1, kitchen: widget.mObj));
                     /*  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ItemDetailsView()),
                      ); */
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
