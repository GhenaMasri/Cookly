import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/common/globs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryAcceptedOrders extends StatefulWidget {
  @override
  _DeliveryAcceptedOrdersState createState() => _DeliveryAcceptedOrdersState();
}

class _DeliveryAcceptedOrdersState extends State<DeliveryAcceptedOrders> {
  int? id;
  List<dynamic> acceptedOrders = [];

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> getDeliveryOrders() async {
    final String apiUrl =
        '${SharedPreferencesService.url}get-delivery-orders?id=$id&status=accepted';

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
    final String apiUrl =
        '${SharedPreferencesService.url}update-order-status?orderId=$id';
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

  Future<Map<String, dynamic>> changeDeliveryStatus(String status) async {
    final url = Uri.parse(
        '${SharedPreferencesService.url}change-delivery-status?id=$id');

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
/////////////////////////////////////////////////////////////////////////////////

  void deliverOrder(int index) async {
    Map<String, dynamic> result =
        await updateOrderStatus(acceptedOrders[index]['id']);
    bool success = result['success'];
    if (success) {
      await changeDeliveryStatus('available');
      setState(() {
        acceptedOrders[index]['status'] = 'delivered';
        IconSnackBar.show(context,
            snackBarType: SnackBarType.success,
            label: 'Order Delivered',
            snackBarStyle: SnackBarStyle(
                labelTextStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
      });
    }
  }

  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await _loadDeliveryId();
    await getDeliveryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: TColor.primary,
          ));
        } else if (snapshot.hasError) {
          print(snapshot.error);
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
        automaticallyImplyLeading: false,
        title: Text(
          'Delivery Orders',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: acceptedOrders.isEmpty
          ? Center(child: Text("No Orders Assigned To You"))
          : ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: acceptedOrders.length,
              itemBuilder: (context, index) {
                return OrderCard(
                  order: acceptedOrders[index],
                  onRemove: () => deliverOrder(index),
                );
              },
            ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final order;
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
                  'Kitchen: ${order['kitchen_name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text('Kitchen Number: ${order['kitchen_number']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text('Customer: ${order['user_name']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text('Customer Number: ${order['user_number']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 0.0, // Add space between the elements
              runSpacing: 4.0, // Add space between the lines
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.purple, size: 20),
                    SizedBox(width: 8),
                    // Using Flexible to allow the text to wrap
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${order['address']}',
                            style: TextStyle(fontSize: 16),
                            softWrap:
                                true, 
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (order['payment'] == 'cash') SizedBox(height: 10),
            if (order['payment'] == 'cash')
              Text('User Will Pay Upon Delivery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (order['payment'] == 'cash')
              SizedBox(
                height: 10,
              ),
            if (order['payment'] == 'cash')
              Row(
                children: [
                  Icon(Icons.price_change, color: TColor.primary, size: 20),
                  SizedBox(width: 8),
                  Text(
                      'Total Price: ${order['total_price'].toStringAsFixed(2)}₪',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            SizedBox(height: 15),
            order['status'] != 'delivered'
                ? Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        onRemove();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Background color
                      ),
                      child: Text(
                        'Delivered',
                        style: TextStyle(color: TColor.white, fontSize: 14),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Text('Delivered Successfully',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.green))),
          ],
        ),
      ),
    );
  }
}
