import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/more/add_card_view.dart';
import 'package:untitled/order/checkout_message_view.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/common/globs.dart';

class CheckoutView extends StatefulWidget {
  final double totalPrice;
  final double deliveryCost;
  final int orderId;
  final Map kitchen;
  final String notes;
  final String delivery;
  const CheckoutView(
      {super.key,
      required this.totalPrice,
      required this.deliveryCost,
      required this.orderId,
      required this.kitchen,
      required this.notes,
      required this.delivery});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  List paymentArr = [
    {"name": "Cash on delivery", "icon": "assets/img/cash.png"},
    {"name": "**** **** **** 2187", "icon": "assets/img/visa_icon.png"},
  ];

  double? discount = 0.0;
  double? checkoutPrice = 0.0;

  int selectMethod = 0;
  TextEditingController txtStreet = TextEditingController();
  TextEditingController txtNumber = TextEditingController();
  String? pickupTime;
  String? payment = "cash";
  int? points;
  bool usePointsForDiscount = false;
  bool isValid = true;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> placeOrder() async {
    int userId = await _loadUserId();
    const String apiUrl = '${SharedPreferencesService.url}place-order';

    final Map<String, dynamic> requestBody = {
      'orderId': widget.orderId,
      'totalPrice': checkoutPrice,
      'status': "pending",
      'userNumber': txtNumber.text,
      'kitchenNumber': widget.kitchen['contact'],
      'city': widget.kitchen['city'],
      'address': txtStreet.text,
      'notes': widget.notes,
      'pickupTime': pickupTime,
      'payment': payment,
      'delivery': widget.delivery,
      'kitchenId': widget.kitchen['id'],
      'userId': userId
    };

    try {
      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
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

  Future<void> _loadUserNumber() async {
    String? number = await SharedPreferencesService.getUserNumber();
    setState(() {
      txtNumber.text = number!;
    });
  }

  Future<int> _loadUserId() async {
    int? id = await SharedPreferencesService.getId();
    return id!;
  }

  Future<void> getPoints() async {
    int userId = await _loadUserId();
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}get-points?id=$userId'));

    if (response.statusCode == 200) {
      setState(() {
        points = jsonDecode(response.body)['points'];
        calculateDiscount();
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to load points');
    }
  }

  void calculateDiscount() {
    if (points != null) {
      discount = (points! / 20.0);
      calculateTotalPrice();
    }
  }

  void calculateTotalPrice() {
    if (usePointsForDiscount && points != null) {
      checkoutPrice = widget.totalPrice + widget.deliveryCost - discount!;
    } else {
      checkoutPrice = widget.totalPrice + widget.deliveryCost;
    }
    setState(() {});
  }

  Future<void> deletePoints() async {
    int userId = await _loadUserId();
    final response = await http.get(
        Uri.parse('${SharedPreferencesService.url}delete-points?id=$userId'));

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.statusCode);
      throw Exception('Failed to load points');
    }
  }

  /////////////////////////////////////////////////////////////////////////////////
  GlobalKey<FormState> formState = GlobalKey();
  @override
  void initState() {
    super.initState();
    _loadUserNumber();
    checkoutPrice = widget.deliveryCost + widget.totalPrice - discount!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset("assets/img/btn_back.png",
                              width: 20, height: 20),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.kitchen['order_system'] == 0)
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Time To Pick Up Next Day",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TimePickerSpinnerPopUp(
                                    iconSize: 20,
                                    mode: CupertinoDatePickerMode.time,
                                    initTime: DateTime.now(),
                                    onChange: (dateTime) {
                                      // Implement your logic with select time
                                      pickupTime =
                                          "${dateTime.hour}:${dateTime.minute}";
                                    },
                                  )
                                ],
                              )),
                        if (widget.delivery == 'yes')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: RoundTitleTextfield(
                              title: "Address",
                              hintText: "Enter Detaild Address",
                              controller: txtStreet,
                              validator: (value) => value!.isEmpty
                                  ? "This field is required"
                                  : null,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: RoundTitleTextfield(
                            title: "Contact Number",
                            hintText: "Enter Contact Number",
                            controller: txtNumber,
                            keyboardType: TextInputType.number,
                            validator: (value) =>
                                value!.isEmpty ? "Couldn't be empty" : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(color: TColor.textfield),
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment method",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: paymentArr.length,
                            itemBuilder: (context, index) {
                              var pObj = paymentArr[index] as Map? ?? {};
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                    color: TColor.textfield,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: TColor.secondaryText
                                            .withOpacity(0.2))),
                                child: Row(
                                  children: [
                                    Image.asset(pObj["icon"].toString(),
                                        width: 50,
                                        height: 20,
                                        fit: BoxFit.contain),
                                    // const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        pObj["name"],
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),

                                    InkWell(
                                      onTap: () {
                                        setState(() async {
                                          selectMethod = index;
                                          if (selectMethod == 1) {
                                            isValid = false;
                                            payment = 'card';
                                            isValid =
                                                await showModalBottomSheet(
                                                    isDismissible: false,
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (context) {
                                                      return const AddCardView();
                                                    });
                                          } else
                                            payment = 'cash';
                                        });
                                      },
                                      child: Icon(
                                        selectMethod == index
                                            ? Icons.radio_button_on
                                            : Icons.radio_button_off,
                                        color: TColor.primary,
                                        size: 25,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(color: TColor.textfield),
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sub Total",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.totalPrice.toString() + "₪",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Delivery Cost",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              widget.deliveryCost.toString() + "₪",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Discount",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${discount?.toStringAsFixed(2) ?? '0.00'}₪",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: TColor.secondaryText.withOpacity(0.5),
                          height: 1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              checkoutPrice.toString() + "₪",
                              style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(color: TColor.textfield),
                    height: 8,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: RoundButton(
                      title: usePointsForDiscount
                          ? "Unuse points"
                          : "Use points to get discount",
                      onPressed: () {
                        setState(() {
                          usePointsForDiscount = !usePointsForDiscount;
                        });
                        if (usePointsForDiscount) {
                          getPoints();
                        } else {
                          discount = 0.0;
                          calculateTotalPrice();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    child: RoundButton(
                        title: "Send Order",
                        onPressed: () async {
                          bool valid = true;
                          if (widget.delivery == 'yes')
                            valid = formState.currentState!.validate();
                          if (selectMethod == 1 && isValid == false) {
                            IconSnackBar.show(context,
                                snackBarType: SnackBarType.fail,
                                label: 'Fill All Visa Card Details',
                                snackBarStyle: SnackBarStyle(
                                    labelTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)));
                          } else {
                            if (valid) {
                              Map<String, dynamic> result = await placeOrder();
                              bool success = result['success'];
                              String message = result['message'];
                              print(message);
                              if (success) {
                                showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return const CheckoutMessageView();
                                    });
                              }
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
