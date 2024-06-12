import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/chef/chef_subscription.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/fade_animation.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/scale_animation.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/menu/manage_menu_item.dart';
import 'package:untitled/menu/menu_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:untitled/more/notification_view.dart';

class ChefHomeView extends StatefulWidget {
  const ChefHomeView({Key? key}) : super(key: key);

  @override
  State<ChefHomeView> createState() => _ChefHomeViewState();
}

class _ChefHomeViewState extends State<ChefHomeView> {
  String? selectedLocation;
  TextEditingController txtSearch = TextEditingController();
  int? kitchenId;
  bool? isActive;
  late Future<void> _initDataFuture;
  List<Map<String, dynamic>> categories = [];
  bool? statusBool; //open
  String? status;

  late List<MenuItem> menuArr = [];
  void addItemToList(MenuItem item) {
    if (mounted) {
      setState(() {
        menuArr.add(item);
      });
    }
  }

  void RemoveItemFromList(MenuItem item) {
    if (mounted) {
      setState(() {
        menuArr.remove(item);
      });
    }
  }

  void updateMenuItem(MenuItem updatedItem) {
    if (mounted) {
      setState(() {
        final index =
            menuArr.indexWhere((item) => item.itemId == updatedItem.itemId);
        if (index != -1) {
          menuArr[index] = updatedItem;
        }
      });
    }
  }

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
              qName: item['quantity_name']);
        }).toList();
      });
      return menuArr;
    } else {
      throw Exception('Failed to load menu items');
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

  Future<void> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    if (mounted) {
      setState(() {
        kitchenId = kitchenid;
      });
    }
  }

  Future<void> _updateMenuArr() async {
    try {
      List<MenuItem> items;
      var fetchedCategories = await getFoodCategories();
      if (txtSearch.text.isNotEmpty) {
        items = await getMenuItems(kitchenId: kitchenId!, name: txtSearch.text);
      } else {
        items = await getMenuItems(kitchenId: kitchenId!);
      }
      if (mounted) {
        setState(() {
          menuArr = items;
          categories = fetchedCategories;
        });
      }
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }

  Future<Map<String, dynamic>> changeKitchenStatus(String status) async {
    final url = Uri.parse(
        '${SharedPreferencesService.url}change-kitchen-status?kitchenId=$kitchenId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
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

  Future<bool> checkSubscription() async {
    final url = Uri.parse('${SharedPreferencesService.url}check-subscription?id=$kitchenId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['isActive'];
      } else {
        print('Error: ${response.statusCode}');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  Future<String> fetchKitchenStatus() async {
    final response = await http.get(Uri.parse('${SharedPreferencesService.url}get-kitchen-status?id=$kitchenId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to load status');
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

  String getCategoryName(int? categoryId) {
    if (categoryId == null) {
      return 'Unknown';
    }

    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'id': categoryId, 'category': 'Unknown'},
    );
    return category['category'];
  }

  Future<void> _initData() async {
    await _loadKitchenId();
    isActive = await checkSubscription();
    print(isActive);
    status = await fetchKitchenStatus();
    if (status == "open") {
      statusBool = true;
    } else {
      statusBool = false;
    }
     if (!isActive!) {
      _showSubscriptionAlert();
    }
    try {
      await _updateMenuArr();
    } catch (error) {
      print('Error loading menu items: $error');
    }
  }

    void _showSubscriptionAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.white,
          title: Text('Activate Kitchen'),
          content: Text('Activate your kitchen by subscribing now.'),
          actions: <Widget>[
            TextButton(
              child: Text('Subscribe Now', style: TextStyle(color: TColor.primary),),
              onPressed: () {
                Navigator.of(context).pop();
                pushReplacementWithAnimation(context,SubscriptionPage());
              },
            ),
         
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
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
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
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
                      pushReplacementWithAnimation(
                          context, NotificationsView());
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
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10,),
                      Text(
                        "Status",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Transform.scale(
                        scale:
                            1.3, // Adjust this value to increase or decrease the size
                        child: Switch(
                          value: statusBool!,
                          activeColor: TColor.primary,
                          onChanged: (newVal) async {
                            setState(() {
                              statusBool = newVal;
                              if (statusBool == true)
                                status = 'open';
                              else
                                status = 'closed';
                            });
                            Map<String, dynamic> result =
                                await changeKitchenStatus(status!);
                            bool success = result['success'];
                            print(success);
                            if (statusBool!) {
                              IconSnackBar.show(context,
                                  snackBarType: SnackBarType.success,
                                  label: 'Can Receive Orders Now',
                                  snackBarStyle: SnackBarStyle(
                                      backgroundColor: TColor.primary,
                                      labelTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)));
                            } else {
                              IconSnackBar.show(context,
                                  snackBarType: SnackBarType.fail,
                                  label: 'Cannot Receive Orders Now',
                                  snackBarStyle: SnackBarStyle(
                                      //backgroundColor: TColor.primary,
                                      labelTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)));
                            }
                          },
                        ),
                      )
                    ])),
            const SizedBox(height: 10),
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
                                    child: CircularProgressIndicator(
                                        color: TColor.primary),
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
                                    "Category: ${getCategoryName(menuItem.category)}",
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
                                pushReplacementWithAnimation(
                                    context,
                                    ManageMenuItemView(
                                      RemoveItemFromList: RemoveItemFromList,
                                      updateMenuItem: updateMenuItem,
                                      item: menuItem,
                                    ));
                                /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ManageMenuItemView(
                                      RemoveItemFromList: RemoveItemFromList,
                                      updateMenuItem: updateMenuItem,
                                      item: menuItem,
                                    ),
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
                    ),
                  );
                }),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pushReplacementWithScaleAnimation(context,
              MenuItemView(menu: menuArr, addItemToList: addItemToList));
          /*  Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MenuItemView(menu: menuArr, addItemToList: addItemToList),
            ),
          ); */
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
