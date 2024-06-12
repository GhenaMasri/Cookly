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
  const MyOrderView(
      {super.key,
      required this.items,
      required this.kitchen,
      required this.userId});

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
  String deliver = 'yes';
  bool checkoutPressed = false;

  double calculateTotalPrice() {
    return widget.items.fold(0.0, (sum, item) {
      return sum + (item['price'].toDouble());
    });
  }

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

  Future<Map<String, dynamic>> deleteOrder() async {
    final url ='${SharedPreferencesService.url}delete-order?orderId=$orderId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
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
/////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    delivery = "Delivery";
    deliver = 'yes';
    totalPrice = calculateTotalPrice();
    finalPrice = deliveryCost + totalPrice!;
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
                      onPressed: () async {
                        // handle back logic if there is order added
                        if (checkoutPressed == true) {
                          
                        } else {
                          Navigator.pop(context);
                        }
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
                                  widget.kitchen['logo'],
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      width: 15,
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
                           const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.phone, color: TColor.primary,size: 13),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  widget.kitchen['contact'],
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
                                if (cObj["notes"] != '')
                                  Text(
                                    "Notes: ${cObj["notes"]}",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                const SizedBox(height: 5),
                                if (cObj["sub_quantity"] != null)
                                  Text(
                                    "Sub-Quantity: ${cObj["sub_quantity"]}",
                                    style: TextStyle(
                                      color: TColor.primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
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
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "General Notes On Order",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        RoundTitleTextfield(
                          title: "Notes",
                          hintText: "Add Notes",
                          maxLines: 2,
                          controller: txtNotes,
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
                      height: 7,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 7),
                        Flexible(
                          child: Row(
                            children: [
                              Radio(
                                activeColor: Color.fromARGB(255, 239, 108, 0),
                                value: "Delivery",
                                groupValue: delivery,
                                onChanged: (value) {
                                  setState(() {
                                    delivery = value;
                                    deliveryCost = 10.0;
                                    deliver = 'yes';
                                    finalPrice = deliveryCost + totalPrice!;
                                    setState(() {});
                                  });
                                },
                              ),
                              Text("Delivery",
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
                                value: "Self Pick Up",
                                groupValue: delivery,
                                onChanged: (value) {
                                  setState(() {
                                    delivery = value;
                                    deliver = 'no';
                                    deliveryCost = 0.0;
                                    finalPrice = deliveryCost + totalPrice!;
                                    setState(() {});
                                  });
                                },
                              ),
                              Text("Self Pick Up",
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
                          deliveryCost.toString() + "₪",
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
                          finalPrice.toString() + "₪",
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
                          /////////////////// BACKEND SECTION /////////////////////////
                          if (checkoutPressed == false) {
                            Map<String, dynamic> result = await addOrderItems(
                              widget.userId,
                              widget.kitchen['id'],
                              cartId,
                              widget.items
                            );
                            bool success = result['success'];
                            print(success);
                            if (success) {
                              checkoutPressed = true;
                              pushReplacementWithAnimation(
                                context,
                                CheckoutView(
                                  totalPrice: totalPrice!,
                                  deliveryCost: deliveryCost,
                                  orderId: orderId!,
                                  kitchen: widget.kitchen,
                                  notes: txtNotes.text,
                                  delivery: deliver
                                )
                              );
                            }
                          } else {
                            pushReplacementWithAnimation(
                              context,
                              CheckoutView(
                                totalPrice: totalPrice!,
                                deliveryCost: deliveryCost,
                                orderId: orderId!,
                                kitchen: widget.kitchen,
                                notes: txtNotes.text,
                                delivery: deliver
                              )
                            );
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
