import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/color_extension.dart';
import 'package:http/http.dart' as http;
import '../../common_widget/round_textfield.dart';

class KitchenProfileView extends StatefulWidget {
  const KitchenProfileView({super.key});

  @override
  State<KitchenProfileView> createState() => _KitchenProfileViewState();
}

class _KitchenProfileViewState extends State<KitchenProfileView> {
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  String? imageUrl;
  File? _image;

  TextEditingController txtName = TextEditingController();
  String? location;
  TextEditingController txtStreet = TextEditingController();
  TextEditingController txtNumber = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  String? category;
  int? selectedCategory; //id of the selected category
  List<String> categoriesList = [];
  List<Map<String, dynamic>> categories = [];
  String? orderingSystem; // For UI only, db should be 0 or 1
  String? specialOrders;
  int? OrdersDb;
  GlobalKey<FormState> formState = GlobalKey();
  late Future<void> _initDataFuture;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<List<Map<String, dynamic>>> getKitchenCategories() async {
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}kitchen-categories'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];
      final List<Map<String, dynamic>> categories =
          categoryList.map((category) {
        return {'id': category['id'], 'category': category['category']};
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to load kitchen categories');
    }
  }
//////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    //Filling Kitchen data
    imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/cookly-495b4.appspot.com/o/images%2Fcookly.png?alt=media&token=24a53307-3c41-489b-a94b-e687751722b8";
    txtName.text = "Cookly";
    location = 'Nablus';
    txtStreet.text = 'Itihad';
    txtNumber.text = '0597280457';
    txtDescription.text = "Description about the kitchen";
    category = 'Default';
    OrdersDb = 0;
    orderingSystem =
        OrdersDb == 1 ? 'Order the day before' : 'Order in the same day';
    specialOrders = "Yes";

    try {
      var fetchedCategories = await getKitchenCategories();

      setState(() {
        categories = fetchedCategories;

//Wasan should remove the comment and edit line 91 if statement

        /*for (var element in categories) {
          if (element['id'] == /*category from db*/) {
            category = element['category'];
          }
          if (element.containsKey('category')) {
            categoriesList.add(element['category']);
          }
        }*/
      });
    } catch (error) {
      print(error);
    }
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColor.placeholder,
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(imageUrl!,
                        width: 100, height: 100, fit: BoxFit.cover),
                  )
                : Icon(
                    Icons.person,
                    size: 65,
                    color: TColor.secondaryText,
                  ),
          ),
          TextButton.icon(
            onPressed: () async {
              pickedFile = await picker.pickImage(source: ImageSource.gallery);
              String uniqueFileName =
                  DateTime.now().millisecondsSinceEpoch.toString();
              setState(() {
                if (pickedFile != null) {
                  _image = File(pickedFile!.path);
                } else {
                  print('No image selected.');
                }
              });
              Reference referenceRoot = FirebaseStorage.instance.ref();
              Reference referenceDirectory = referenceRoot.child('images');
              Reference referenceImageToUpload =
                  referenceDirectory.child(uniqueFileName);

              try {
                //Store the file
                await referenceImageToUpload.putFile(File(pickedFile!.path));
                //Success: get the download URL
                imageUrl = await referenceImageToUpload.getDownloadURL();
              } catch (error) {
                //Some error occurred
              }
              setState(() {});
            },
            icon: Icon(
              Icons.edit,
              color: TColor.primary,
              size: 12,
            ),
            label: Text(
              "Edit Logo",
              style: TextStyle(color: TColor.primary, fontSize: 12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Kitchen Name",
              hintText: "Enter Name",
              controller: txtName,
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundDropdown(
                value: location, // Initial value
                hintText: 'Select City',
                items: ['Nablus', 'Jenin', 'Ramallah', 'Tulkarm'],
                validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                onChanged: (String? value) {
                  setState(() {
                    location = value;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Street",
              hintText: "Street",
              controller: txtStreet,
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Contact Number",
              hintText: "Enter Contact Number",
              controller: txtNumber,
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundTitleTextfield(
              title: "Description",
              hintText: "Description",
              controller: txtDescription,
              maxLines: 2,
              validator: (value) => value!.isEmpty ? "Couldn't be empty" : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundDropdown(
                value: category, // Initial value
                hintText: 'Select Category',
                items: categoriesList, //this should be categoriesList
                validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                onChanged: (String? value) {
                  setState(() {
                    category = value;
                    /*if (value != null) {
                      var selectedItem = categories.firstWhere(
                          (element) => element['category'] == value,
                          orElse: () => {});
                      selectedCategory = selectedItem['id'];
                    }*/
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundDropdown(
                value: orderingSystem, // Initial value
                hintText: 'Ordering System',
                validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                items: ['Order in the same day', 'Order the day before'],
                onChanged: (String? value) {
                  setState(() {
                    orderingSystem = value;
                    if (orderingSystem == 'Order the day before') {
                      OrdersDb = 0;
                    } else {
                      OrdersDb = 1;
                    }
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              children: [
                Text("Special Orders:", style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                Flexible(
                  child: Row(
                    children: [
                      Radio(
                        activeColor: Color.fromARGB(255, 239, 108, 0),
                        value: "Yes",
                        groupValue: specialOrders,
                        onChanged: (value) {
                          setState(() {
                            specialOrders = value.toString();
                          });
                        },
                      ),
                      Text("Yes", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Radio(
                        activeColor: Color.fromARGB(255, 239, 108, 0),
                        value: "No",
                        groupValue: specialOrders,
                        onChanged: (value) {
                          setState(() {
                            specialOrders = value.toString();
                          });
                        },
                      ),
                      Text("No", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundButton(
                title: "Save",
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    //save edits to db
                  }
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
