import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/user_final_order_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class UserOrders extends StatefulWidget {
  @override
  _UserOrdersState createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  late List<dynamic> orders;
  int? id;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> fetchOrders() async {
    final String apiUrl =
        '${SharedPreferencesService.url}get-user-orders?userId=$id';

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

  Future<void> _loadUserId() async {
    int? id = await SharedPreferencesService.getId();
    setState(() {
      this.id = id;
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
    await _loadUserId();
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: TColor.primary));
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text('Error loading data'));
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
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
            var order = orders[index];
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
                    child: (orders.isEmpty)
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: Text(
                                  "No Orders Yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order['name'],
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
                                          Text('₪',
                                              style: TextStyle(color: TColor.primary,fontSize: 20),),
                                          SizedBox(width: 5.0),
                                          Text(order['total_price'].toString() + "₪"),
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
                                                color: order['status'] == 'done'
                                                    ? Colors.green
                                                    : order['status'] ==
                                                            'in progress'
                                                        ? TColor.primary
                                                        : Color.fromARGB(
                                                            255, 253, 231, 36),
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
                          context,
                          FinalOrderView(
                            orderId: order['id'],
                          ));
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
