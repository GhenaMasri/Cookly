import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class RoundDropdown extends StatelessWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final void Function(String?)? onChanged;

  const RoundDropdown({
    Key? key,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Set the height to match other fields
      decoration: BoxDecoration(
        color:
            TColor.textfield, // Using the same background color as other fields
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                      left: 20, right: 15), 
                  margin: const EdgeInsets.only(top: 4),
                  alignment: Alignment.centerLeft,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      hint: Text(
                        hintText,
                        style: TextStyle(
                          color: TColor
                              .placeholder, // Using placeholder color for hint text
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onChanged: onChanged,
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
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
