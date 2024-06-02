import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/chef_order_details.dart';
import 'package:untitled/order/user_final_order_view.dart';

class UserOrders extends StatefulWidget {
  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  final List<Map<String, dynamic>> orders = [
    {
      "kitchen_name": "John Doe",
      "street":"Rafidia",
      "rate": 0,
      "logo":"https://firebasestorage.googleapis.com/v0/b/cookly-495b4.appspot.com/o/images%2F1715700074577?alt=media&token=15443768-f23b-4810-b462-65302da07d80",
      "location": "123 Main St",
      "category_name":"All",
      "orderTime": "12:30 PM",
      "status": "In Progress",
      "items": [
        {
          "name": "Beef Burger",
          "quantity": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "quantity": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "quantity": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "quantity": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "quantity": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
   {
      "kitchen_name": "John Doe",
      "street":"Rafidia",
      "rate": 0,
      "logo":"https://firebasestorage.googleapis.com/v0/b/cookly-495b4.appspot.com/o/images%2F1715700074577?alt=media&token=15443768-f23b-4810-b462-65302da07d80",
      "location": "123 Main St",
      "category_name":"All",
      "orderTime": "12:30 PM",
      "status": "In Progress",
      "items": [
        {
          "name": "Beef Burger",
          "quantity": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "quantity": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "quantity": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "quantity": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "quantity": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
    {
      "kitchen_name": "John Doe",
      "street":"Rafidia",
      "rate": 0,
      "logo":"https://firebasestorage.googleapis.com/v0/b/cookly-495b4.appspot.com/o/images%2F1715700074577?alt=media&token=15443768-f23b-4810-b462-65302da07d80",
      "location": "123 Main St",
      "category_name":"All",
      "orderTime": "12:30 PM",
      "status": "In Progress",
      "items": [
        {
          "name": "Beef Burger",
          "quantity": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "quantity": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "quantity": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "quantity": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "quantity": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: TColor.white,
        title: Text(
          "My Orders",
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
          SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order['kitchen_name'],
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(order['location']),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(order['orderTime']),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                  Row(
                                  children: [
                                    Icon(Icons.phone,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(order['ContactNumber']),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: order['status'] == 'Delivered'
                                              ? Colors.green
                                              : order['status'] == 'In Progress'
                                                  ? TColor.primary
                                                  : Color.fromARGB(255, 253, 231, 36),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            order['status'].toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      pushReplacementWithAnimation(
                          context, FinalOrderView(order: order));
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      ); */
                    },
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_forward,
                        color: TColor.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
