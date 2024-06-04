import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/food_list_tile.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/order/my_order_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class CartPage extends StatefulWidget {
  final Map kitchen;
  CartPage({Key? key, required this.kitchen}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int? userId;
  late Future<void> _initDataFuture;
  List<Map<String, dynamic>> cartItems = [];

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> getCartItems(int userId) async {
    final url = Uri.parse(
        '${SharedPreferencesService.url}get-cart-items?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cartItems = List<Map<String, dynamic>>.from(data['cartItems']);
        });
      } else {
        print('Failed to load cart items');
      }
    } catch (error) {
      print('Error fetching cart items: $error');
    }
  }

  Future<Map<String, dynamic>> deleteCartItem(int cartItemId) async {
    final url =
        '${SharedPreferencesService.url}delete-cart-item?cartItemId=$cartItemId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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

  Future<void> _loadUserId() async {
    int? id = await SharedPreferencesService.getId();
    setState(() {
      userId = id;
    });
  }
/////////////////////////////////////////////////////////////////////////////////

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await _loadUserId();
    await getCartItems(userId!);
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
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset("assets/img/btn_back.png", width: 20, height: 20),
        ),
        title: Text(
          "My Cart",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
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
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                "There are no items added to cart",
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...cartItems.map((item) => FoodItemTile(
                            imageUrl: item['image'],
                            foodName: item['name'],
                            quantity: item['quantity'],
                            price: item['price'].toDouble(),
                            onRemove: () {
                              QuickAlert.show(
                                context: context,
                                title: 'Delete',
                                type: QuickAlertType.error,
                                text:
                                    'Are you sure you want to delete this item?',
                                showCancelBtn: true,
                                confirmBtnText: 'Delete',
                                cancelBtnText: 'Cancel',
                                confirmBtnColor:
                                    Color.fromARGB(255, 222, 0, 56),
                                onConfirmBtnTap: () async {
                                  deleteCartItem(item['id']);
                                  removeItem(cartItems.indexOf(item));
                                  Navigator.of(context).pop();
                                },
                                onCancelBtnTap: () {
                                  Navigator.of(context).pop();
                                },
                              );
                            })),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: cartItems.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: RoundButton(
                        title: "Order Now",
                        onPressed: () {
                          pushReplacementWithAnimation(
                              context, MyOrderView(items: cartItems, kitchen: widget.kitchen, userId: userId!));
                        },
                      ),
                    )),
              ],
            ),
    );
  }
}
