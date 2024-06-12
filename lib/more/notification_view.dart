import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/chef_order_details.dart';
import 'package:untitled/order/user_final_order_view.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List<dynamic>? notifications = [];
  String? type;
  int? id;
//////////////////////////////// BACKEND SECTION ////////////////////////////////

  Future<void> fetchNotifications() async {
    type = await _loadUserType();
    if (type == "chef") {
      id = await _loadKitchenId();
    } else {
      id = await _loadUserId();
    }
    final String url =
        '${SharedPreferencesService.url}get-notifications?id=$id&destination=$type';

    final Uri uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          notifications = jsonData['notifications'];
        });
      } else {
        print('Failed to fetch notifications: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }
  }

  Future<Map<String, dynamic>> updateNotification(int id) async {
    final url = Uri.parse(
        '${SharedPreferencesService.url}change-notification-status?notificationId=$id');

    try {
      final response = await http.put(url);
      print(response.body);
      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<int> _loadUserId() async {
    int? id = await SharedPreferencesService.getId();
    return id!;
  }

  Future<int> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    return kitchenid!;
  }

  Future<String> _loadUserType() async {
    String? userType = await SharedPreferencesService.getType();
    return userType!;
  }

/////////////////////////////////////////////////////////////////////////////////
  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await fetchNotifications();
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
        title: Text(
          "Notifications",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: notifications!.isEmpty
              ? Center(
                  child: Text('No Notifications Yet'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: notifications!.length,
                      separatorBuilder: ((context, index) => Divider(
                            //indent: 25,
                            //endIndent: 25,
                            color: TColor.secondaryText.withOpacity(0.4),
                            height: 1,
                          )),
                      itemBuilder: ((context, index) {
                        var cObj = notifications![index] as Map? ?? {};
                      Color? cardColor = cObj['is_read'] == 1
                                      ? TColor.white
                                      : Colors.deepOrange[100];
                        return InkWell(
                            onTap: () async {
                              if (cObj['is_read'] == 0) {
                                Map<String, dynamic> result =
                                    await updateNotification(cObj['id']);
                                    if (result['success']) {
                                setState(() {
                                  cObj['is_read'] = 1;
                                });
                              }
                              }
                              if (type == 'chef') {
                                pushReplacementWithAnimation(
                                    context,
                                    OrderDetailsPage(
                                        orderId: cObj['order_id']));
                              } else if (type == 'normal') {
                                pushReplacementWithAnimation(context,
                                    FinalOrderView(orderId: cObj['order_id']));
                              }
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: cardColor),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: TColor.primary,
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cObj["message"].toString(),
                                          style: TextStyle(
                                              color: TColor.primaryText,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          cObj["time"].toString(),
                                          style: TextStyle(
                                              color: TColor.secondaryText,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
