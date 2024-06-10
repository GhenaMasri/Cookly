import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/round_icon_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled/common/globs.dart';

class SubscriptionManagementPage extends StatefulWidget {
  @override
  _SubscriptionManagementPageState createState() =>
      _SubscriptionManagementPageState();
}

class _SubscriptionManagementPageState extends State<SubscriptionManagementPage> {
  final bool isActive = true; 
  final String expiryDate = "31st December 2024";
  bool isAnnually = false;
  void toggleSubscriptionPlan() {
    setState(() {
      isAnnually = !isAnnually;
    });
  }

  TextEditingController txtCardNumber = TextEditingController();
  TextEditingController txtCardMonth = TextEditingController();
  TextEditingController txtCardYear = TextEditingController();
  TextEditingController txtCardCode = TextEditingController();
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? subscriptionInfo;

//////////////////////////////// BACKEND SECTION ////////////////////////////////
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
  
  Future<void> fetchSubscriptionDetails() async {
    int kitchenId = await _loadKitchenId();
    final url = Uri.parse('${SharedPreferencesService.url}get-subscription?id=$kitchenId'); 

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        subscriptionInfo = json.decode(response.body)['subscription'];
        return;
      } else {
        throw Exception('No kitchen found with this id');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  Future<int> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    return kitchenid!;
  }
/////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        appBar: AppBar(
          title: Text(
            'Subscription Management',
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: TColor.white,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Subscription Status',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: TColor.primary),
                ),
                SizedBox(height: 20),
                Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Subscription Expiry: $expiryDate',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                     
                        Text(
                          'Type: ${isAnnually ? 'Annual' : 'Monthly'}',
                          style: TextStyle(fontSize: 18),
                        ),
                           SizedBox(height: 10),
                        Text(
                          'Status: ${isActive ? 'Active' : 'Expired'}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isActive ? Colors.green : Colors.red),
                        ),
                      ],
                    ),
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
                SizedBox(
                  height: 20,
                ),
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
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      "Expiry",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 100,
                      child: RoundTextfield(
                        hintText: "MM",
                        controller: txtCardMonth,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          } else if (!RegExp(r'^(0[1-9]|1[0-2])$')
                              .hasMatch(value)) {
                            return 'Syntax: MM';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 25),
                    SizedBox(
                      width: 100,
                      child: RoundTextfield(
                        hintText: "YYYY",
                        controller: txtCardYear,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field Required';
                          } else if (!RegExp(r'^[0-9]{4}$').hasMatch(value) ||
                              int.parse(value) < DateTime.now().year) {
                            return 'Syntax: YYYY';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
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
                const SizedBox(
                  height: 15,
                ),
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
                const SizedBox(
                  height: 15,
                ),
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
                Spacer(),
                RoundButton(
                  title: 'Activate Subscription',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
