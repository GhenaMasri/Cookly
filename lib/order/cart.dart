import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/cart_drop_down.dart';
import 'package:untitled/common_widget/food_list_tile.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/order/my_order_view.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String? selectedKitchen;
  List<String> kitchens = ['Nosha', 'Enaba', 'Alf-lela'];
  List<Map<String, dynamic>> foodItems = [
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

  void removeItem(int index) {
    setState(() {
      foodItems.removeAt(index);
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
                  ...foodItems.map((item) => FoodItemTile(
                        imageUrl: item['imageUrl'],
                        foodName: item['foodName'],
                        quantity: item['quantity'],
                        price: item['price'],
                        onRemove: () => removeItem(foodItems.indexOf(item)),
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
