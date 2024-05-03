import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class MyDropdownMenu extends StatefulWidget {
  final ValueChanged<String?>? onChanged; // Callback function to pass selected value
final String? value; // Define value property
  const MyDropdownMenu({Key? key, this.value, this.onChanged}) : super(key: key);

  @override
  _MyDropdownMenuState createState() => _MyDropdownMenuState();
  
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String? selectedOption;

    @override
  void initState() {
    super.initState();
    // Initialize selectedOption with the provided value
    selectedOption = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(newValue); // Pass the selected value to the callback function
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
       icon: Icon(Icons.arrow_drop_down), // Set dropdown button icon
      iconEnabledColor: TColor.primary,
      underline: SizedBox(),
    );
  }
}
