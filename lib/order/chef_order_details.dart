import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/order/assign_delivery.dart';
import '../common_widget/round_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  OrderDetailsPage({required this.orderId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late String _currentStatus;
  Map<String, dynamic>? orderInfo;
  List<dynamic> orderItems = [];
  List<dynamic> deliveryMen = [];

//////////////////////////////// BACKEND SECTION ////////////////////////////////

  Future<void> fetchOrderDetails() async {
    final String apiUrl =
        '${SharedPreferencesService.url}chef-order-details?orderId=${widget.orderId}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        orderInfo = data['orderInfo'];
        orderItems = data['orderItems'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus(String newStatus) async {
    final String apiUrl =
        '${SharedPreferencesService.url}update-order-status?orderId=${widget.orderId}';
    try {
      final response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"status": newStatus}));

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (e) {
      return {'success': false, 'message': '$e'};
    }
  }

  Future<void> fetchAvailableDelivery() async {
    int kitchenId = await _loadKitchenId();
    String apiUrl = '${SharedPreferencesService.url}get-available-delivery?id=$kitchenId';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        deliveryMen = data['deliveryMen'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<Map<String, dynamic>> assignDelivery(int deliveryId) async {
    const url = '${SharedPreferencesService.url}assign-delivery';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': widget.orderId,
          'deliveryId': deliveryId,
        }),
      );
      if (response.statusCode == 200) {
        return { 'success': true, 'message': response.body };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<int> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    return kitchenid!;
  }
/////////////////////////////////////////////////////////////////////////////////

  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await fetchOrderDetails();
    _currentStatus = orderInfo!['status'];
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
    //double subtotal = orderItems.fold(0, (sum, item) => sum + item['price']);
    double deliveryCost = 10.0; // example delivery cost
    double total = orderInfo!['total_price'].toDouble();
    double subtotal = total; // not used
    if (orderInfo!['delivery'] == 'yes') total = total - 10;

    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(color: TColor.white),
        ),
        backgroundColor: TColor.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); // Pass a result back
          },
        ),
        iconTheme: IconThemeData(color: TColor.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomerDetails(),
              const SizedBox(height: 20),
              if (_currentStatus != 'delivered') _buildStatusSegmentedControl(),
              if (_currentStatus != 'delivered') const SizedBox(height: 20),
              Text(
                'Items:',
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildOrderItems(),
              const SizedBox(height: 20),
              if (!orderInfo!['order_notes'].toString().isEmpty)
                _buildOrderNotes(),
              if (!orderInfo!['order_notes'].toString().isEmpty)
                const SizedBox(height: 15),
              _buildCostSummary(subtotal, deliveryCost, total),
              const SizedBox(height: 25),
              if ((_currentStatus == 'done') && orderInfo!['delivery'] == 'yes')
                _bulidAssignButton()
              else if ((_currentStatus == 'done') &&
                  orderInfo!['delivery'] == 'no')
                _bulidPickedUpButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulidAssignButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RoundButton(
            title: "Assign to Delivery",
            onPressed: () async {
              await fetchAvailableDelivery();
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return const AssignDeliveryView();
                  });
            }));
  }

  Widget _bulidPickedUpButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: RoundButton(
            title: "Picked Up",
            onPressed: () async {
              await updateOrderStatus('delivered');
               IconSnackBar.show(context,
                        snackBarType: SnackBarType.success,
                        label: 'Order Delivered',
                        snackBarStyle: SnackBarStyle(
                            backgroundColor: TColor.primary,
                            labelTextStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)));
                                Navigator.pop(context,true);
            }));
  }

  Widget _buildCustomerDetails() {
    return Row(
      children: [
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderInfo!['full_name'],
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Order Time: ${orderInfo!['order_time']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Contact Number: ${orderInfo!['user_number']}',
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Container(
      decoration: BoxDecoration(color: TColor.textfield),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: orderItems.length,
        separatorBuilder: (context, index) => Divider(
          indent: 25,
          endIndent: 25,
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
        itemBuilder: (context, index) {
          var item = orderItems[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item['item_name']} x${item['quantity'].toString()}",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${item['price'].toString()}₪",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!item["item_notes"].toString().isEmpty)
                        Text(
                          "Notes: ${item["notes"]}",
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                       if (!item["item_notes"].toString().isEmpty) const SizedBox(height: 5),
                    
                        Text(
                          "Sub-Quantity: ${item["sub_quantity"]}",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Any Notes',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          orderInfo!['order_notes'],
          style: TextStyle(
            color: TColor.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Divider(
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
      ],
    );
  }

  Widget _buildCostSummary(double subtotal, double deliveryCost, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Delivery Method",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
            if (orderInfo!['delivery'] == 'yes')
              Text("Delivery",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700))
            else
              Text("Self Pick-up",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700))
          ],
        ),
        if (orderInfo!['delivery'] == 'yes')
          SizedBox(
            height: 8,
          ),
        if (orderInfo!['delivery'] == 'yes') const SizedBox(height: 4),
        if (orderInfo!['delivery'] == 'yes')
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 8.0, // Add space between the elements
            runSpacing: 4.0, // Add space between the lines
            children: [
              Text(
                "Delivery Address",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                orderInfo!['address'].toString(),
                style: TextStyle(
                    color: TColor.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Payment Method",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
            if (orderInfo!['payment'] == 'cash')
              Text(orderInfo!['payment'],
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700))
            else
              Text(orderInfo!['payment'] + " (Paid)",
                  style: TextStyle(
                      color: TColor.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700))
          ],
        ),
        SizedBox(
          height: 8,
        ),
        if (orderInfo!['pickup_time'] != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pick Up Time",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                orderInfo!['pickup_time'],
                style: TextStyle(
                    color: TColor.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        const SizedBox(height: 15),
        Divider(
          color: TColor.secondaryText.withOpacity(0.5),
          height: 1,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${total.toStringAsFixed(2)}₪",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCostRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "${amount.toStringAsFixed(2)}₪",
          style: TextStyle(
            color: TColor.primary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSegmentedControl() {
    List<String> statusesOrder = ['pending', 'in progress', 'done'];

    // Find the index of the current status in the order
    int currentStatusIndex = statusesOrder.indexOf(_currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Order Status',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(10),
              children: <Widget>[
                _buildStatusButton(
                    'Pending', Colors.yellow, _currentStatus == 'pending'),
                _buildStatusButton('In Progress', Colors.orange,
                    _currentStatus == 'in progress'),
                _buildStatusButton(
                    'Done', Colors.green, _currentStatus == 'done'),
              ],
              isSelected: [
                _currentStatus == 'pending',
                _currentStatus == 'in progress',
                _currentStatus == 'done'
              ],
              onPressed: (int index) async {
                int nextStatusIndex = currentStatusIndex + 1;

                if (index == nextStatusIndex &&
                    nextStatusIndex < statusesOrder.length) {
                  setState(() {
                    _currentStatus = statusesOrder[nextStatusIndex];

                    //If current status == 'done' and no delivery send noification to the user
                  });
                  await updateOrderStatus(_currentStatus);
                }
              },
              color: TColor.primaryText,
              selectedColor: TColor.white,
              fillColor: Colors.transparent,
              selectedBorderColor: TColor.white,
              //borderColor: TColor.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusButton(String text, Color color, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.7),
            color.withOpacity(0.9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? TColor.white : TColor.primaryText,
        ),
      ),
    );
  }
}
