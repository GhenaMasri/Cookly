import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart'; // Ensure you've added the correct package for QuickAlert
import 'package:untitled/common/color_extension.dart'; // Custom colors extension
import 'package:untitled/common/globs.dart'; // Common globals
import 'package:untitled/common_widget/dropdown.dart'; // Custom dropdown widget

class DeliveryManager extends StatefulWidget {
  const DeliveryManager({super.key});

  @override
  _DeliveryManagerState createState() => _DeliveryManagerState();
}

class _DeliveryManagerState extends State<DeliveryManager> {
  String selectedCity = 'Nablus';
  List<dynamic> deliveryMen = [];

  Future<void> fetchDeliveryMen(String city) async {
    final response = await http.get(
        Uri.parse('${SharedPreferencesService.url}get-delivery?city=$city'));
    if (response.statusCode == 200) {
      setState(() {
        deliveryMen = json.decode(response.body)['delivery'];
      });
    } else {
      throw Exception('Failed to load delivery men');
    }
  }

  void deleteDeliveryMan() async {
    final response = await http.delete(Uri.parse(''));
    if (response.statusCode == 200) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Delivery Man Deleted Successfully!',
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () {
          Navigator.of(context).pop();
          fetchDeliveryMen(selectedCity); // Refresh the list
        },
      );
    }
  }

  late Future<void> _initDataFuture;

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await fetchDeliveryMen(selectedCity);
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyDropdownMenu(
              value: selectedCity,
              onChanged: (newValue) async {
                setState(() {
                  selectedCity = newValue!;
                });
                await fetchDeliveryMen(selectedCity);
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: deliveryMen.length,
                itemBuilder: (context, index) {
                  var deliveryMan = deliveryMen[index];
                  return Card(
                    color: TColor.white,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      title: Text(deliveryMan['full_name'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Phone: ${deliveryMan['phone']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: TColor.primary),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: TColor.white,
                                title: Text('Delete'),
                                content: Text(
                                    'Are you sure you want to delete this delivery man?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Yes',
                                        style:
                                            TextStyle(color: TColor.primary)),
                                    onPressed: () {
                                      deleteDeliveryMan(); //fix it
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('No',
                                        style:
                                            TextStyle(color: TColor.primary)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      leading: CircleAvatar(
                        child: Text(
                          deliveryMan['status'][0].toString().toUpperCase(),
                          style: TextStyle(color: TColor.white),
                        ),
                        backgroundColor: deliveryMan['status'] == 'available'
                            ? Colors.green
                            : deliveryMan['status'] == 'busy'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
