import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/profile/change_password.dart';
import 'package:untitled/welcome_page.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  late Future<void> _initDataFuture;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  @override
  void initState() {
    super.initState();
    _initDataFuture; //  _initDataFuture = load profile data from API as commented below;
   /* txtFirstName.text = "FirstName";
    txtLastName.text = "LastName";
    txtEmail.text = "ghenama77@gmail.com";
    txtMobile.text = "0597280457";*/
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Check if the phone number is 10 digits long
    if (value.length != 10) {
      return 'Phone number must be 10 digits long';
    }
    // Check if the phone number starts with either 059 or 056
    if (!value.startsWith('059') && !value.startsWith('056')) {
      return 'Phone number must start with 059 or 056';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: formState,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 46,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w800),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Container()));
                  },
                  icon: Image.asset(
                    "assets/img/notification.png",
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Hi there UserName!",
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () {
              //Set shared prefernces to false.
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => WelcomeView()));
            },
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
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Last Name",
              hintText: "Enter Last Name",
              controller: txtLastName,
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Email",
              hintText: "Enter Email",
              keyboardType: TextInputType.emailAddress,
              controller: txtEmail,
              readOnly: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Mobile No",
              hintText: "Enter Mobile No",
              controller: txtMobile,
              keyboardType: TextInputType.phone,
              validator: _validatePhoneNumber,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "Change Password",
                type: RoundButtonType.textPrimary,
                onPressed: () {
                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordView()));
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "Save",
                onPressed: () {
                  if (formState.currentState!.validate()) {}
                }),
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    )));
  }
}
