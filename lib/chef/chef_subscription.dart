import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/common/globs.dart';
import 'package:untitled/main_page.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isAnnually = false;
  TextEditingController txtCardNumber = TextEditingController();
  TextEditingController txtCardMonth = TextEditingController();
  TextEditingController txtCardYear = TextEditingController();
  TextEditingController txtCardCode = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void toggleSubscriptionPlan() {
    setState(() {
      isAnnually = !isAnnually;
    });
  }

  Future<Map<String, dynamic>> subscribeKitchen(String type) async {
    int kitchenId = await _loadKitchenId();
    final url = Uri.parse('${SharedPreferencesService.url}subscribe?id=$kitchenId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'type': type}),
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

  Future<int> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    return kitchenid!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Subscription Plans',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColor.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Choose Your Subscription Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: TColor.primary,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ChoiceChip(
                      label: Text('Monthly'),
                      selected: !isAnnually,
                      onSelected: (bool selected) {
                        if (selected) toggleSubscriptionPlan();
                      },
                      backgroundColor: TColor.placeholder,
                      selectedColor: Colors.deepOrange[100],
                    ),
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text('Annually'),
                      selected: isAnnually,
                      onSelected: (bool selected) {
                        if (selected) toggleSubscriptionPlan();
                      },
                      backgroundColor: TColor.placeholder,
                      selectedColor: Colors.deepOrange[100],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: SubscriptionCard(
                    planName: isAnnually ? 'Annual Plan' : 'Monthly Plan',
                    description: 'Access to all features for ${isAnnually ? '12 months' : '1 month'}.',
                    price: isAnnually ? '300₪/year' : '30₪/month',
                  ),
                ),
                SizedBox(height: 20),
                RoundTextfield(
                  hintText: "Card Number",
                  controller: txtCardNumber,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a card number';
                    } else if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                      return 'Enter a valid 16-digit card number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      "Expiry",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 100,
                      child: RoundTextfield(
                        hintText: "MM",
                        controller: txtCardMonth,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          } else if (!RegExp(r'^(0[1-9]|1[0-2])$').hasMatch(value)) {
                            return 'Syntax: MM';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 25),
                    SizedBox(
                      width: 100,
                      child: RoundTextfield(
                        hintText: "YYYY",
                        controller: txtCardYear,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          } else if (!RegExp(r'^[0-9]{4}$').hasMatch(value) || int.parse(value) < DateTime.now().year) {
                            return 'Syntax: YYYY';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                RoundTextfield(
                  hintText: "Card Security Code",
                  controller: txtCardCode,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the security code';
                    } else if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
                      return 'Enter a valid 3 or 4 digit code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                RoundTextfield(
                  hintText: "First Name",
                  controller: txtFirstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                RoundTextfield(
                  hintText: "Last Name",
                  controller: txtLastName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),  // Ensure there's enough space at the bottom
                Center(
                  child: RoundButton(
                    title: 'Subscribe Now',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String type = isAnnually ? 'annually' : 'monthly';
                        Map<String, dynamic> result = await subscribeKitchen(type);
                        if (result['success']) {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Subscription successful!',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String planName;
  final String description;
  final String price;

  SubscriptionCard({required this.planName, required this.description, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,

      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(planName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TColor.primary)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
