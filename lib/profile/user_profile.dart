import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:untitled/common/globs.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/order/cart.dart';
import 'package:untitled/profile/change_password.dart';
import 'package:untitled/welcome_page.dart';
import 'dart:convert';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import 'package:http/http.dart' as http;

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  late Future<void> _initDataFuture;
  String errorMessage = '';
  bool errorFlag = false;

  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  String? username;
  int? id;
  int? points;

  String? initialFirstName;
  String? initialLastName;
  String? initialMobileNum;

  bool isDataChanged = false;

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

  Future<void> getPoints() async {
    await _loadUserId();
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}get-points?id=$id'));

    if (response.statusCode == 200) {
      setState(() {
        points = jsonDecode(response.body)['points'];
      });
    } else {
      print(response.statusCode);
      throw Exception('Failed to load points');
    }
  }

  Future<void> signOut(BuildContext context) async {
    await SharedPreferencesService.clearSharedPreferences();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => WelcomeView()),
      (Route<dynamic> route) => false,
    );
  }
  /////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _initDataFuture = _loadUserData();
    _loadUserName();
    _loadUserId();
    getPoints();
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
          return Center(
              child: CircularProgressIndicator(color: TColor.primary));
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
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
            child: Form(
          key: formState,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*               const SizedBox(
                    height: 20,
                  ), */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Profile",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    username != null
                        ? "Welcome to your profile $username!"
                        : "Welcome to your profile!",
                    style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.crown,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${points.toString()} points",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      signOut(context);
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "First Name",
                      hintText: "Enter First Name",
                      controller: txtFirstName,
                      validator: (value) =>
                          value!.isEmpty ? "Couldn't be empty" : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Last Name",
                      hintText: "Enter Last Name",
                      controller: txtLastName,
                      validator: (value) =>
                          value!.isEmpty ? "Couldn't be empty" : null,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Email",
                      hintText: "Enter Email",
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      readOnly: true,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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
                                    confirmBtnColor: Colors.green,
                                    onConfirmBtnTap: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.of(context).pop();
                                      //Navigator.of(context).pop();
                                    },
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
