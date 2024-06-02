import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/chef_order_details.dart';

class OrdersPage extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      "customerName": "John Doe",
      "location": "123 Main St",
      "orderTime": "12:30 PM",
      "status": "waiting",
      "items": [
        {
          "name": "Beef Burger",
          "qty": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "qty": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "qty": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "qty": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "qty": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
    {
      "customerName": "John Doe",
      "location": "123 Main St",
      "orderTime": "12:30 PM",
      "status": "waiting",
      "items": [
        {
          "name": "Beef Burger",
          "qty": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "qty": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "qty": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "qty": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "qty": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
    {
      "customerName": "John Doe",
      "location": "123 Main St",
      "orderTime": "12:30 PM",
      "status": "waiting",
      "items": [
        {
          "name": "Beef Burger",
          "qty": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "qty": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "qty": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "qty": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "qty": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
    {
      "customerName": "John Doe",
      "location": "123 Main St",
      "orderTime": "12:30 PM",
      "status": "waiting",
      "items": [
        {
          "name": "Beef Burger",
          "qty": "1",
          "price": 16.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Classic Burger",
          "qty": "1",
          "price": 14.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Cheese Chicken Burger",
          "qty": "1",
          "price": 17.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "Chicken Legs Basket",
          "qty": "1",
          "price": 15.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        },
        {
          "name": "French Fries Large",
          "qty": "1",
          "price": 6.0,
          "notes": "Nothing to add",
          "sub_quantity": "1 person"
        }
      ],
      "ContactNumber": "0597280457"
    },
    // Add more orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                                  order['customerName'],
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
                                    Icon(Icons.assignment_turned_in,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(
                                      order['status'].toUpperCase(),
                                      style: TextStyle(
                                        color: order['status'] == 'accepted'
                                            ? Colors.green
                                            : order['status'] == 'declined'
                                                ? Colors.red
                                                : Colors.orange,
                                        fontWeight: FontWeight.bold,
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
                          context, OrderDetailsPage(order: order));
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
