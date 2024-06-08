import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_icon_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';

class AssignDeliveryView extends StatefulWidget {
  const AssignDeliveryView({Key? key}) : super(key: key);

  @override
  State<AssignDeliveryView> createState() => _AssignDeliveryViewState();
}

class _AssignDeliveryViewState extends State<AssignDeliveryView> {
  final List<DeliveryMan> deliveryMen = [
    DeliveryMan('John Doe', '123-456-7890'),
    DeliveryMan('Jane Smith', '234-567-8901'),
    DeliveryMan('Alice Johnson', '345-678-9012'),
    DeliveryMan('Bob Brown', '456-789-0123'),
  ];

  TextEditingController txtCardNumber = TextEditingController();
  TextEditingController txtCardMonth = TextEditingController();
  TextEditingController txtCardYear = TextEditingController();
  TextEditingController txtCardCode = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          mainAxisSize: MainAxisSize
              .min, 
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
              itemCount: deliveryMen.length,
              itemBuilder: (context, index) {
                return DeliveryManCard(deliveryMan: deliveryMen[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DeliveryMan {
  final String name;
  final String contactNumber;

  DeliveryMan(this.name, this.contactNumber);
}

class DeliveryManCard extends StatelessWidget {
  final DeliveryMan deliveryMan;

  const DeliveryManCard({Key? key, required this.deliveryMan})
      : super(key: key);

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
                    Text(deliveryMan.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(deliveryMan.contactNumber,
                        style: TextStyle(color: TColor.secondaryText)),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.assignment_turned_in, color: TColor.primary),
              onPressed: () {
                IconSnackBar.show(context,
                    snackBarType: SnackBarType.success,
                    label: 'Order Assigned',
                    snackBarStyle: SnackBarStyle(
                        backgroundColor: TColor.primary,
                        labelTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)));

                            Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
