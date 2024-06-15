import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'package:http/http.dart' as http;
class KitchenDetailsPage extends StatefulWidget {
  final int kitchenId;
  const KitchenDetailsPage({super.key, required this.kitchenId});

  @override
  _KitchenDetailsPageState createState() => _KitchenDetailsPageState();
}

class _KitchenDetailsPageState extends State<KitchenDetailsPage> {
  Map<String, dynamic>? kitchenInfo;
  List<dynamic> kitchenItems = [];

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> fetchKitchenDetails() async {
    final String apiUrl ='${SharedPreferencesService.url}get-kitchen-details?id=${widget.kitchenId}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        kitchenInfo = data['kitchenInfo'];
        kitchenItems = data['kitchenItems'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

/////////////////////////////////////////////////////////////////////////////////

  String getOrderingSystemText(int systemValue) {
    switch (systemValue) {
      case 0:
        return "Order the day before";
      case 1:
        return "Order the same day";
      default:
        return "Unknown ordering system";
    }
  }
  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
   await fetchKitchenDetails();
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
        appBar: AppBar(
          backgroundColor: TColor.white,
          title: Text('Kitchen Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TColor.primary,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.transparent,
                              backgroundImage: CachedNetworkImageProvider(
                                kitchenInfo!['logo'],
                              ),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          kitchenInfo!['kitchen_name'],
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 8),
                        Text(
                          kitchenInfo!['description'],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: TColor.primary,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                  '${kitchenInfo!['city']}, ${kitchenInfo!['street']}',
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12)),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.phone, color: TColor.primary, size: 20),
                            SizedBox(width: 5),
                            Text(kitchenInfo!['contact'],
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.star, color: TColor.primary, size: 20),
                            SizedBox(width: 5),
                            Text('${kitchenInfo!['rate'].toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.subscriptions,
                                color: TColor.primary, size: 20),
                            SizedBox(width: 5),
                            Text('${kitchenInfo!['subscription_type']} ',
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.delivery_dining,
                                color: TColor.primary, size: 20),
                            SizedBox(width: 5),
                            Text(kitchenInfo!['special_orders'] == 'yes'
                                ? 'Special orders available'
                                : 'No special orders available',
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.timelapse, color: TColor.primary, size: 20),
                            SizedBox(width: 5),
                            Text(getOrderingSystemText(kitchenInfo!['order_system']),
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Menu Items:',
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: kitchenItems.length,
                itemBuilder: (context, index) {
                  var item = kitchenItems[index];
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(16.0), 
                      child: Card(
                        elevation: 4,
                        color: TColor.white,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: item['image'],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(
                                color: TColor.primary,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item['item_name']),
                          subtitle:
                              Text('${item['price']}₪ - ${item['quantity']}'),
                        ),
                      ));
                },
              ),
            ],
          ),
        ));
  }
}
