import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class KitchenProfileView extends StatefulWidget {
  const KitchenProfileView({super.key});

  @override
  State<KitchenProfileView> createState() => _KitchenProfileViewState();
}

class _KitchenProfileViewState extends State<KitchenProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
   return Center(
              child: Text("Profile"),
            );
  }
}