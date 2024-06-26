import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/chef_order_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class ChefOrderDone extends StatefulWidget {
  @override
  _ChefOrderDoneState createState() => _ChefOrderDoneState();
}

class _ChefOrderDoneState extends State<ChefOrderDone> {
  int? kitchenId;
  List<dynamic> orders = [];

  void _showReportReasonDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReportReasonDialog(userId: userId);
      },
    );
  }

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> fetchOrders() async {
    await _loadKitchenId();
    final String apiUrl =
        '${SharedPreferencesService.url}get-chef-orders?kitchenId=$kitchenId&status=done';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orders = data['orders'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> _loadKitchenId() async {
    int? id = await SharedPreferencesService.getKitchenId();
    setState(() {
      kitchenId = id;
    });
  }

/////////////////////////////////////////////////////////////////////////////////
  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await fetchOrders();
  }

  Future<void> _navigateToOrderDetails(
      BuildContext context, int orderId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderId: orderId),
      ),
    );
    if (result == true) {
      await fetchOrders(); // Refresh the orders when returning
    }
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Stack(
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
                                  order['full_name'],
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(order['time']),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(
                                      order['user_number'],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Icon(Icons.delivery_dining,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    if (order['delivery'] == 'yes')
                                      Text(
                                        "Delivery",
                                      )
                                    else
                                      Text(
                                        "Self Pick-up",
                                      ),
                                    SizedBox(width: 15.0),
                                    if (order['pickup_time'] != null)
                                      Icon(Icons.access_time,
                                          size: 20, color: TColor.primary),
                                    if (order['pickup_time'] != null)
                                      SizedBox(width: 5.0),
                                    if (order['pickup_time'] != null)
                                      Text(order['pickup_time']),
                                  ],
                                ),
                                SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    Icon(Icons.payment,
                                        size: 20, color: TColor.primary),
                                    SizedBox(width: 5.0),
                                    Text(
                                      order['payment'],
                                    ),
                                    SizedBox(width: 15.0),
                                    Text(
                                      '₪',
                                      style: TextStyle(
                                          color: TColor.primary, fontSize: 20),
                                    ),
                                    SizedBox(width: 5.0),
                                    Text(
                                      (order['delivery'] == 'yes'
                                          ? (order['total_price'] - 10)
                                              .toStringAsFixed(2)
                                          : order['total_price']
                                              .toStringAsFixed(2)),
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
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: TColor.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text('Report User'),
                              content: Text('Do you want to report this user?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: TColor.primary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: TColor.primary),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _showReportReasonDialog(
                                        context, order['user_id']);
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
                          Icons.report,
                          color: TColor.primary,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        _navigateToOrderDetails(context, order['id']);
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


class ReportReasonDialog extends StatefulWidget {
  final int userId;

  ReportReasonDialog({required this.userId});

  @override
  _ReportReasonDialogState createState() => _ReportReasonDialogState();
}

class _ReportReasonDialogState extends State<ReportReasonDialog> {
  String _reportReason = 'Fake order';

    Future<Map<String, dynamic>> reportUser(int userId) async {
    final url =
        Uri.parse('${SharedPreferencesService.url}report-user?userId=$userId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      title: Text("Report reason:"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Row(
              children: [
                Radio(
                  activeColor: TColor.primary,
                  value: "Fake order",
                  groupValue: _reportReason,
                  onChanged: (value) {
                    setState(() {
                      _reportReason = value.toString();
                    });
                  },
                ),
                Text("Fake order", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: [
                Radio(
                  activeColor: TColor.primary,
                  value: "Did not pickup his order",
                  groupValue: _reportReason,
                  onChanged: (value) {
                    setState(() {
                      _reportReason = value.toString();
                    });
                  },
                ),
                Text("Did not pickup his order", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Back", style: TextStyle(color: TColor.primary)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Done", style: TextStyle(color: TColor.primary)),
          onPressed: () async {
            // Report user API
            Map<String, dynamic> result = await reportUser(widget.userId);
            if (result['success']) {
              IconSnackBar.show(context,
snackBarType: SnackBarType.success,
label: 'User Reported Successfully',
snackBarStyle: SnackBarStyle(
backgroundColor: TColor.primary,
labelTextStyle: TextStyle(
fontWeight: FontWeight.bold, fontSize: 18)));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}