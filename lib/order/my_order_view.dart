import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/order/checkout.dart';
import 'dart:convert';
import 'package:untitled/common/globs.dart';
import 'package:http/http.dart' as http;

class MyOrderView extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Map kitchen;
  final int userId;
  const MyOrderView({super.key, required this.items, required this.kitchen, required this.userId});

  @override
  State<MyOrderView> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  TextEditingController txtNotes = TextEditingController();
  String? delivery;
  double? totalPrice;
  double deliveryCost = 10.0;
  double? finalPrice;
  int? cartId;
  int? orderId;

  double calculateTotalPrice() {
    return widget.items.fold(0.0, (sum, item) {
      return sum + (item['price'].toDouble());
    });}

//////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> addOrderItems(userId, kitchenId, cartId, cartItems) async {
    const String apiUrl = '${SharedPreferencesService.url}add-order-items';

    final Map<String, dynamic> requestBody = {
      'userId': userId,
      'kitchenId': kitchenId,
      'cartId': cartId,
      'cartItems': cartItems,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          orderId = responseData['orderId'];
        });
        return {'success': true};
      } else {
        return {'success': false};
      }
    } catch (error) {
      return {'success': false};
    }
  }
/////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    delivery = "Yes";
    totalPrice = calculateTotalPrice();
    finalPrice  = deliveryCost+totalPrice!;
    cartId = widget.items.isNotEmpty ? widget.items[0]['cart_id'] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
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
                        "My Order",
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
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          imageUrl: widget.kitchen['logo'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: TColor.primary),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.kitchen['kitchen_name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/img/rate.png",
                                width: 10,
                                height: 10,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                widget.kitchen['rate'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.primary, fontSize: 12),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Category",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12),
                              ),
                              Text(
                                " : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.primary, fontSize: 12),
                              ),
                              Text(
                                widget.kitchen['category_name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: TColor.secondaryText, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/img/location-pin.png",
                                width: 13,
                                height: 13,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  widget.kitchen['street'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: TColor.secondaryText,
                                      fontSize: 12),
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
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.textfield),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.items.length,
                  separatorBuilder: ((context, index) => Divider(
                        indent: 25,
                        endIndent: 25,
                        color: Colors.grey.withOpacity(0.5),
                        height: 1,
                      )),
                  itemBuilder: ((context, index) {
                    var cObj = widget.items[index] as Map? ?? {};
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: ExpansionTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "${cObj["name"].toString()} x${cObj["quantity"].toString()}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${cObj["price"].toString()}₪",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (cObj["notes"] != null)
                                  Text(
                                    "Notes: ${cObj["notes"]}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                if (cObj["sub_quantity"] != null)
                                  Text(
                                    "Sub-Quantity: ${cObj["sub_quantity"]}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "General notes on the order",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        RoundTitleTextfield(
                          title: "Notes",
                          hintText: "Add Notes",
                          controller: txtNotes,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Divider(
                      color: TColor.secondaryText.withOpacity(0.5),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text("Delivery:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w700)),
                        SizedBox(width: 10),
                        Flexible(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Color.fromARGB(255, 239, 108, 0),
                                value: "Yes",
                                groupValue: delivery,
                                onChanged: (value) {
                                  setState(() {
                                    delivery = value;
                                    deliveryCost = 10.0;
                                    finalPrice  = deliveryCost+totalPrice!;
                                    setState(() {
                                      
                                    });
                                  });
                                },
                              ),
                              Text("Yes",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Color.fromARGB(255, 239, 108, 0),
                                value: "No",
                                groupValue: delivery,
                                onChanged: (value) {
                                  setState(() {
                                    delivery = value;
                                    deliveryCost = 0.0;
                                    finalPrice  = deliveryCost+totalPrice!;
                                    setState(() {
                                      
                                    });
                                  });
                                },
                              ),
                              Text("No",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
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
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          totalPrice.toString(),
                          style: TextStyle(
                              color: TColor.primary,
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
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          deliveryCost.toString()+"₪",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        )
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
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          finalPrice.toString()+"₪",
                          style: TextStyle(
                              color: TColor.primary,
                              fontSize: 22,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RoundButton(
                        title: "Checkout",
                        onPressed: () async {
                          Map<String, dynamic> result = await addOrderItems(widget.userId, widget.kitchen['id'], cartId, widget.items);
                          bool success = result['success'];
                          print(success);
                          if (success) {
                            pushReplacementWithAnimation(context, CheckoutView(totalPrice:totalPrice!,deliveryCost:deliveryCost, orderId: orderId!, kitchen: widget.kitchen, notes: txtNotes.text,));
                          }
                          /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckoutView(finalPrice:finalPrice!,deliveryCost:deliveryCost)
                            ),
                          ); */
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
