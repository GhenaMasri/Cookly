import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class CartDropdownMenu extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final String? value;
  final List<String> items;
  final String hint;

  const CartDropdownMenu({
    Key? key,
    this.value,
    this.onChanged,
    required this.items,
    required this.hint,
  }) : super(key: key);

  @override
  _CartDropdownMenuState createState() => _CartDropdownMenuState();
}

class _CartDropdownMenuState extends State<CartDropdownMenu> {
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
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            widget.hint,
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
