import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/round_icon_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:http/http.dart' as http;

class AssignDeliveryView extends StatefulWidget {
  final List<dynamic> deliveryMen;
  final int orderId;
  const AssignDeliveryView(
      {Key? key, required this.deliveryMen, required this.orderId})
      : super(key: key);

  @override
  State<AssignDeliveryView> createState() => _AssignDeliveryViewState();
}

class _AssignDeliveryViewState extends State<AssignDeliveryView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: media.width,
      decoration: BoxDecoration(
          color: TColor.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Assing Delivery",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: TColor.primaryText,
                    size: 25,
                  ),
                )
              ],
            ),
            Divider(
              color: TColor.secondaryText.withOpacity(0.4),
              height: 1,
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap:
                  true, // Important: This ensures the ListView doesn't take up more space than necessary
              physics:
                  NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
              itemCount: widget.deliveryMen.length,
              itemBuilder: (context, index) {
                return DeliveryManCard(
                  deliveryMan: widget.deliveryMen[index],
                  orderId: widget.orderId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryManCard extends StatelessWidget {
  final deliveryMan;
  final int orderId;
  const DeliveryManCard(
      {Key? key, required this.deliveryMan, required this.orderId})
      : super(key: key);

  Future<Map<String, dynamic>> assignDelivery(int deliveryId) async {
    const url = '${SharedPreferencesService.url}assign-delivery';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': orderId,
          'deliveryId': deliveryId,
        }),
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
      color: TColor.white,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5, // Slightly increased elevation for better shadow effect
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person, color: TColor.primary, size: 24),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deliveryMan['full_name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(deliveryMan['phone'],
                        style: TextStyle(color: TColor.secondaryText)),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.assignment_turned_in, color: TColor.primary),
              onPressed: () async {
                Map<String, dynamic> result =
                    await assignDelivery(deliveryMan['id']);
                bool success = result['success'];
                if (success) {
                  IconSnackBar.show(context,
                      snackBarType: SnackBarType.success,
                      label: 'Order Assigned, Waiting Response',
                      snackBarStyle: SnackBarStyle(
                          backgroundColor: TColor.primary,
                          labelTextStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)));

                  Navigator.pop(context, 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
