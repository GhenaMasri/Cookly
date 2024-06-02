import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class MyDropdownMenu extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final String? value;

  const MyDropdownMenu({Key? key, this.value, this.onChanged})
      : super(key: key);

  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButton<String>(
          dropdownColor: TColor.white,
          isExpanded:
              true, // Ensures the dropdown button expands to fill available width
          value: selectedOption,
          onChanged: (String? newValue) {
            setState(() {
              selectedOption = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
          items: <String>['Nablus', 'Ramallah', 'Tulkarm', 'Jenin']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            'Current Location',
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          icon: Icon(Icons.arrow_drop_down),
          iconEnabledColor: TColor.primary,
          underline: SizedBox(),
        ),
      ],
    );
  }
}
