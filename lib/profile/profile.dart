import 'dart:io';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/common/globs.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/profile/change_password.dart';
import 'package:untitled/welcome_page.dart';
import 'package:http/http.dart' as http;
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import 'dart:convert';
import 'package:untitled/common/globs.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  late Future<void> _initDataFuture;
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  String? username;
  int? id;

  String? initialFirstName;
  String? initialLastName;
  String? initialMobileNum;

  bool isDataChanged = false;

  String errorMessage = '';
  bool errorFlag = false;

  void _checkDataChanged() {
    bool dataChanged = txtFirstName.text != initialFirstName ||
        txtLastName.text != initialLastName ||
        txtMobile.text != initialMobileNum;

    setState(() {
      isDataChanged = dataChanged;
    });
  }

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> _loadUserData() async {
    List<String?> data = await SharedPreferencesService.getUserProfile();
    setState(() {
      txtFirstName.text = data[0] ?? "First Name";
      initialFirstName = txtFirstName.text;
      txtLastName.text = data[1] ?? "Last Name";
      initialLastName = txtLastName.text;
      txtEmail.text = data[2] ?? "Email";
      txtMobile.text = data[3] ?? "Phone";
      initialMobileNum = txtMobile.text;
    });
  }

  Future<void> _loadUserName() async {
    String? name = await SharedPreferencesService.getUserName();
    setState(() {
      username = name;
    });
  }

  Future<void> _loadUserId() async {
    int? id = await SharedPreferencesService.getId();
    setState(() {
      this.id = id;
    });
  }

  Future<void> _saveDataToSharedPreferences() async {
    await SharedPreferencesService.saveDataToSharedPreferences(
        txtFirstName.text, txtLastName.text, txtMobile.text);
  }

  Future<Map<String, dynamic>> editUser(
      int id, Map<String, dynamic> updates) async {
    final String url = '${SharedPreferencesService.url}edit-user?id=$id';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updates),
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }
  /////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadUserData();
    _loadUserName();
    _loadUserId();
    txtFirstName.addListener(_checkDataChanged);
    txtLastName.addListener(_checkDataChanged);
    txtMobile.addListener(_checkDataChanged);
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
          Text(
            username != null
                ? "Welcome to your profile $username!"
                : "Welcome to your profile!",
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangePasswordView()));
                }),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
              title: "Save",
              isEnabled: isDataChanged,
              onPressed: isDataChanged
                  ? () async {
                      if (formState.currentState!.validate()) {
                        Map<String, dynamic> updates = {};

                        if (txtFirstName.text != initialFirstName)
                          updates['first_name'] = txtFirstName.text;
                        if (txtLastName.text != initialLastName)
                          updates['last_name'] = txtLastName.text;
                        if (txtMobile.text != initialMobileNum)
                          updates['phone'] = txtMobile.text;

                        Map<String, dynamic> result =
                            await editUser(id!, updates);
                        bool success = result['success'];
                        String message = result['message'];
                        print(message);
                        if (success) {
                          // save new user data to shared preferences
                          _saveDataToSharedPreferences();
                          // add success indicator
                          setState(() {
                            errorFlag = false;
                            errorMessage = "";
                          });
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.success,
                            text: 'Profile Edited Successfully!',
                            confirmBtnColor: TColor.primary,
                          );
                        } else {
                          setState(() {
                            errorFlag = true;
                            errorMessage = message;
                          });
                        }
                      }
                    }
                  : null,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: errorFlag,
            child: Text(errorMessage,
                style: TextStyle(
                  color: const Color.fromARGB(255, 230, 81, 0),
                  fontSize: 16,
                )),
          ),
          Visibility(visible: errorFlag, child: SizedBox(height: 8)),
        ]),
      ),
    )));
  }
}
