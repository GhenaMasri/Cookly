import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/delivery/accepted_orders.dart';
import 'package:untitled/delivery/order.dart';
import 'package:untitled/more/notification_view.dart';

class DeliveryOrdersPage extends StatefulWidget {
  @override
  _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  String _status = 'Available';
  List<Order> orders = [
    Order('Kitchen A', '123456', 'John Doe', '987654', '123 Elm St, City'),
    Order('Kitchen B', '234567', 'Jane Smith', '876543', '456 Oak St, City'),
    Order(
        'Kitchen C', '345678', 'Alice Johnson', '765432', '789 Pine St, City'),
  ];
  List<Order> acceptedOrders = [];

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  void _acceptOrder(Order order) {
    setState(() {
      _updateStatus('Busy');
      orders.remove(order);
      acceptedOrders.add(order);
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success,
          label: 'Order Accepted',
          snackBarStyle: SnackBarStyle(
              labelTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text('Status: $_status',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusButton('Available'),
                      SizedBox(width: 10),
                      _buildStatusButton('Busy'),
                      SizedBox(width: 10),
                      _buildStatusButton('Out Of Service'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderCard(
                    order: orders[index],
                    onUpdateStatus: (newStatus) => _acceptOrder(orders[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String status) {
    return ElevatedButton(
      onPressed: () => _updateStatus(status),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _status == status ? _getButtonColor(status) : Colors.grey,
      ),
      child: Text(
        status,
        style: TextStyle(
            color: _status == status ? Colors.white : Colors.black,
            fontSize: 14),
      ),
    );
  }

  Color _getButtonColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Busy':
        return Colors.orange;
      case 'Out Of Service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  final Function(String) onUpdateStatus;

  OrderCard({required this.order, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Kitchen: ${order.kitchenName}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Kitchen Number: ${order.kitchenNumber}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Customer: ${order.customerName}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Customer Number: ${order.customerNumber}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Delivery Address: ${order.deliveryAddress}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                  onPressed: () => onUpdateStatus('Busy'),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red, size: 30),
                  onPressed: () {
                    // Handle decline order
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
