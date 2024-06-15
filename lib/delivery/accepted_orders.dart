import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/delivery/order.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/common/globs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryAcceptedOrders extends StatefulWidget {
  @override
  _DeliveryAcceptedOrdersState createState() => _DeliveryAcceptedOrdersState();
}

class _DeliveryAcceptedOrdersState extends State<DeliveryAcceptedOrders> {
  List<Order> orders = [
    Order('Kitchen A', '123456', 'John Doe', '987654', '123 Elm St, City'),
  ];
  int? id;
  List<dynamic> acceptedOrders = [];

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> getDeliveryOrders() async {
    final String apiUrl = '${SharedPreferencesService.url}get-delivery-orders?id=$id&status=pending';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        acceptedOrders = data['orders'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(int id) async {
    final String apiUrl = '${SharedPreferencesService.url}update-order-status?orderId=$id';
    try {
      final response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"status": "delivered"}));

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<void> _loadDeliveryId() async {
    int? id = await SharedPreferencesService.getDeliveryId();
    setState(() {
      this.id = id;
    });
  }
/////////////////////////////////////////////////////////////////////////////////

  void removeOrder(int index) async {
    setState(() {
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success,
          label: 'Order Delivered',
          snackBarStyle: SnackBarStyle(
              labelTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
    });
    await Future.delayed(const Duration(seconds: 2));
    orders.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Delivery Orders',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              pushReplacementWithAnimation(context, NotificationsView());
            },
            icon: Image.asset(
              "assets/img/notification.png",
              width: 25,
              height: 25,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(
            order: orders[index],
            onRemove: () => removeOrder(index),
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onRemove;

  OrderCard({required this.order, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColor.white,
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Icon(Icons.local_dining, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text(
                  'Kitchen: ${order.kitchenName}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Kitchen Number: ${order.kitchenNumber}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('Customer: ${order.customerName}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text('Customer Number: ${order.customerNumber}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.purple, size: 20),
                SizedBox(width: 8),
                Text('Delivery Address: ${order.deliveryAddress}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  onRemove(); // Call the callback to remove the order
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Background color
                ),
                child: Text(
                  'Delivered',
                  style: TextStyle(color: TColor.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
