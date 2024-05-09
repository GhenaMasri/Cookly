import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Widget? left;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const RoundTextfield({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.left,
    this.obscureText = false,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: bgColor ?? TColor.textfield,
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          if (left != null)
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: left!,
            ),
          Expanded(
            child: TextFormField(
              validator: validator,
              onSaved: onSaved,
              autocorrect: false,
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: TColor.placeholder,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundTitleTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Widget? left;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final int? maxLines;

  const RoundTitleTextfield({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.left,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.maxLines = 1,
  });

 @override
Widget build(BuildContext context) {
  return Container(
    height: maxLines! * 55.0,
    decoration: BoxDecoration(
      color: bgColor ?? TColor.textfield,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
      children: [
        if (left != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: left!,
          ),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: maxLines! * 55.0,
                margin: EdgeInsets.only(
                  top: maxLines == 1 ? 8 : 10,
                ),
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 0), 
                  child: TextFormField(
                    maxLines: maxLines,
                    validator: validator,
                    onSaved: onSaved,
                    autocorrect: false,
                    controller: controller,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          
                      errorBorder: InputBorder.none, 
                      focusedErrorBorder: InputBorder.none,
                      errorStyle: TextStyle(
                        fontSize: 10,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: TColor.placeholder,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: maxLines! > 1 ? 4 : 0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: maxLines! * 55.0,
                margin: EdgeInsets.only(
                  top: 10 ,
                  left: 20,
                ),
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  style: TextStyle(color: TColor.placeholder, fontSize: 11),
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

}
