import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_icon_button.dart';
import 'package:untitled/common_widget/round_textfield.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Credit/Debit Card Details",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
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
            const SizedBox(
              height: 25,
            ),
            RoundIconButton(
                title: "Add Card",
                icon: "assets/img/add.png",
                color: TColor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                }),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
