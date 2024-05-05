import 'dart:io';

import 'package:flutter/material.dart';
import '../common/color_extension.dart'; 
class ImageSelectionTextField extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImageSelectionTextField({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: TColor.textfield,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: TextFormField(
                      autocorrect: false,
                      enabled: false, 
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText:
                            image == null ? 'Select Your Logo' : 'Logo Selected',
                        hintStyle: TextStyle(
                          color:
                              image == null ? TColor.placeholder : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: onTap,
                    child: Icon(Icons.image),
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
