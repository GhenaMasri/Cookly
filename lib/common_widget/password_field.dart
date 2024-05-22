import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';

class PassRoundTitleTextfield extends StatefulWidget {
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
  final bool readOnly;

  const PassRoundTitleTextfield({
    Key? key,
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
    this.readOnly = false,
  }) : super(key: key);

  @override
  _PassRoundTitleTextfieldState createState() => _PassRoundTitleTextfieldState();
}

class _PassRoundTitleTextfieldState extends State<PassRoundTitleTextfield> {
  bool _obscureText = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.bgColor ?? TColor.textfield,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: TColor.placeholder,
              fontSize: 13,
            ),
          ),
          Row(
            children: [
              if (widget.left != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.left!,
                ),
              Expanded(
                child: TextFormField(
                  maxLines: widget.maxLines,
                  validator: (value) {
                    final error = widget.validator?.call(value);
                    setState(() {
                      _errorText = error;
                    });
                    return error;
                  },
                  onSaved: widget.onSaved,
                  autocorrect: false,
                  controller: widget.controller,
                  obscureText: _obscureText,
                  keyboardType: widget.keyboardType,
                  readOnly: widget.readOnly,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: TColor.placeholder,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

