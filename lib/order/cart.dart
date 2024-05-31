import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/food_list_tile.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/order/my_order_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? selectedKitchen;
  int? userId;
  List<String> kitchens = ['Nosha', 'Enaba', 'Alf-lela'];
  List<Map<String, dynamic>> cartItems = [
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pizza',
      'quantity': 2,
      'price': 15.99,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Burger',
      'quantity': 1,
      'price': 8.99,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
    {
      'imageUrl': 'assets/img/dess_2.png',
      'foodName': 'Pasta',
      'quantity': 3,
      'price': 12.49,
    },
  ];

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> getCartItems(int userId) async { //call it in future data
    final url = Uri.parse('${SharedPreferencesService.url}get-cart-items?userId=$userId');
    
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

  Future<Map<String, dynamic>> deleteCartItem(int cartItemId) async { //call it when verify deletion 
    final url ='${SharedPreferencesService.url}delete-cart-item?cartItemId=$cartItemId';
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

  Future<void> _loadUserId() async { //call it in future data
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Container()));
            },
            icon: Image.asset(
              "assets/img/notification.png",
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order From",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                CartDropdownMenu(
                  items: kitchens,
                  value: selectedKitchen,
                  hint: 'Choose Kitchen',
                  onChanged: (newValue) {
                    setState(() {
                      selectedKitchen = newValue;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...cartItems.map((item) => FoodItemTile(
                        imageUrl: item['imageUrl'],
                        foodName: item['foodName'],
                        quantity: item['quantity'],
                        price: item['price'],
                        onRemove: () => removeItem(cartItems.indexOf(item)),
                      )),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: RoundButton(
              title: "Order Now",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrderView(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
