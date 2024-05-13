import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLasttName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            "Hi there UserName!",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Sign Out",
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ),
          ),
       
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "First Name",
              hintText: "Enter First Name",
              controller: txtFirstName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Last Name",
              hintText: "Enter Last Name",
              controller: txtFirstName,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Address",
              hintText: "Enter Address",
              controller: txtAddress,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Password",
              hintText: "* * * * * *",
              obscureText: true,
              controller: txtPassword,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Confirm Password",
              hintText: "* * * * * *",
              obscureText: true,
              controller: txtConfirmPassword,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(title: "Save", onPressed: () {}),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    ));
  }
}
