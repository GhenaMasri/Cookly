import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/delivery/accepted_orders.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/common/globs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeliveryOrdersPage extends StatefulWidget {
  @override
  _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  String _status = 'Available';
  int? id;
  List<dynamic> pendingOrders = [];
  int? unreadCount;
  Future<void> updateUnreadCountFromNotifications(int newCount) async {
    unreadCount = 0; /*await unreadNotificationsCount();*/
    setState(() {});
  }

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<String> fetchDeliveryStatus() async {
    final response = await http.get(
        Uri.parse('${SharedPreferencesService.url}get-delivery-status?id=$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['status'];
    } else {
      throw Exception('Failed to load status');
    }
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

  Future<void> getDeliveryOrders() async {
    final String apiUrl =
        '${SharedPreferencesService.url}get-delivery-orders?id=$id&status=pending';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        pendingOrders = data['orders'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> _loadDeliveryId() async {
    int? id = await SharedPreferencesService.getDeliveryId();
    setState(() {
      this.id = id;
    });
  }
/////////////////////////////////////////////////////////////////////////////////

  void _updateStatus(String newStatus) async {
    setState(() {
      _status = newStatus;
    });

    Map<String, dynamic> result =
        await changeDeliveryStatus(_status.toLowerCase());
    bool success = result['success'];
  }

  void _acceptOrder(var order) {
    setState(() {
      _updateStatus('busy');
      pendingOrders.remove(order);
      IconSnackBar.show(context,
          snackBarType: SnackBarType.success,
          label: 'Order Accepted',
          snackBarStyle: SnackBarStyle(
              labelTextStyle:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)));
    });
  }

  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await _loadDeliveryId();
    _status = await fetchDeliveryStatus();
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
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  int newCount = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsView(),
                    ),
                  );

                  await updateUnreadCountFromNotifications(newCount);
                },
                icon: Image.asset(
                  "assets/img/notification.png",
                  width: 25,
                  height: 25,
                ),
              ),
              if (unreadCount != null && unreadCount! > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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
                      _buildStatusButton('available'),
                      SizedBox(width: 10),
                      _buildStatusButton('busy'),
                      SizedBox(width: 10),
                      _buildStatusButton('out of service'),
                    ],
                  ),
                ],
              ),
            ),
            pendingOrders.isEmpty
                ? Align(alignment: Alignment.center,child: Text("No Orders Assigned To You"))
                : Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: pendingOrders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(
                            order: pendingOrders[index],
                            onUpdateStatus: (newStatus) =>
                                _acceptOrder(pendingOrders[index]),
                            onCancel: () {
                              setState(() {
                                pendingOrders.removeAt(index);

                                IconSnackBar.show(context,
                                    snackBarType: SnackBarType.fail,
                                    label: 'Order Declined',
                                    snackBarStyle: SnackBarStyle(
                                        labelTextStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)));
                              });
                            });
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
      onPressed: () {
        _updateStatus(status);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _status == status ? _getButtonColor(status) : Colors.grey,
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
            color: _status == status ? Colors.white : Colors.black,
            fontSize: 12),
      ),
    );
  }

  Color _getButtonColor(String status) {
    switch (status) {
      case 'available':
        return Colors.green;
      case 'busy':
        return Colors.orange;
      case 'out of service':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class OrderCard extends StatelessWidget {
  final order;
  final Function(String) onUpdateStatus;

  final Function onCancel;

  OrderCard({
    required this.order,
    required this.onUpdateStatus,
    required this.onCancel,
  });

  Future<Map<String, dynamic>> acceptDeclineOrder(String status, int id) async {
    final url =
        Uri.parse('${SharedPreferencesService.url}accept-decline-order?id=$id');

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
            Text('Kitchen: ${order['kitchen_name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text('Kitchen Number: ${order['kitchen_number']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Customer: ${order['user_name']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Customer Number: ${order['user_number']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text('Delivery Address: ${order['address']}',
                style: TextStyle(fontSize: 16)),
            if (order['payment'] == 'cash') SizedBox(height: 5),
            if (order['payment'] == 'cash')
              Text('User Will Pay Upon Delivery',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (order['payment'] == 'cash')
              SizedBox(
                height: 5,
              ),
            if (order['payment'] == 'cash')
              Text('Total Price: ${order['total_price'].toStringAsFixed(2)}₪',
                  style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green, size: 30),
                  onPressed: () async {
                    onUpdateStatus('Busy');

                    Map<String, dynamic> result = await acceptDeclineOrder(
                        'accepted', order['delivery_order_id']);
                    bool success = result['success'];
                    print(success);
                  },
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red, size: 30),
                  onPressed: () async {
                    Map<String, dynamic> result = await acceptDeclineOrder(
                        'declined', order['delivery_order_id']);
                    bool success = result['success'];
                    if (success) {
                      onCancel();
                    }
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
