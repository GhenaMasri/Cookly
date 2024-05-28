import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
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
  String errorMessage = '';
  bool errorFlag = false;

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
  int? kitchenId;
  Map<String, dynamic>? kitchenData;
  int? category_id;

  String? initialName;
  String? initialNumber;
  String? initialLocation;
  String? initialStreet;
  String? initialDescription;
  String? initialCategory;
  String? initialOrderingSystem;
  String? initialSpecialOrders;
  String? initialImage;

  bool isDataChanged = false;

  void _checkDataChanged() {
    bool dataChanged = txtName.text != initialName ||
        txtDescription.text != initialDescription ||
        txtStreet.text != initialStreet ||
        txtNumber.text != initialNumber ||
        category != initialCategory ||
        specialOrders != initialSpecialOrders ||
        orderingSystem != initialOrderingSystem ||
        location != initialLocation ||
        imageUrl != initialImage;

    setState(() {
      isDataChanged = dataChanged;
    });
  }

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

  Future<Map<String, dynamic>?> getKitchenData(int chefId) async {
    final String url = '${SharedPreferencesService.url}chef-data?id=$chefId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': response.body,
          'kitchen': data['kitchen']
        };
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<void> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    setState(() {
      kitchenId = kitchenid;
    });
  }

  Future<void> _saveKitchenNameToSharedPreferences() async {
    await SharedPreferencesService.saveKitchenName(txtName.text);
  }

  Future<Map<String, dynamic>> editKitchen(
      int id, Map<String, dynamic> updates) async {
    final String url = '${SharedPreferencesService.url}edit-chef?id=$id';
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
  //////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
    txtName.addListener(_checkDataChanged);
    txtNumber.addListener(_checkDataChanged);
    txtDescription.addListener(_checkDataChanged);
    txtStreet.addListener(_checkDataChanged);
  }

  Future<void> _initData() async {
    await _loadKitchenId();
    if (kitchenId != null) {
      final result = await getKitchenData(kitchenId!);
      if (result != null && result['success'] == true) {
        setState(() {
          kitchenData = result['kitchen'] ?? " ";
          imageUrl = kitchenData!['logo'] ?? " ";
          initialImage = imageUrl;
          txtName.text = kitchenData!['name'] ?? " ";
          initialName = txtName.text;
          location = kitchenData!['city'] ?? " ";
          initialLocation = location;
          txtStreet.text = kitchenData!['street'] ?? " ";
          initialStreet = txtStreet.text;
          txtNumber.text = kitchenData!['contact'] ?? " ";
          initialNumber = txtNumber.text;
          txtDescription.text = kitchenData!['description'] ?? " ";
          initialDescription = txtDescription.text;
          category_id = kitchenData!['category_id'] ?? 1;
          OrdersDb = kitchenData!['order_system'] ?? 0;
          orderingSystem =
              OrdersDb == 0 ? 'Order the day before' : 'Order in the same day';
          initialOrderingSystem = orderingSystem;
          specialOrders = kitchenData!['special_orders'] ?? "yes";
        });
      } else {
        print('Failed to fetch kitchen data: ${result?['message']}');
      }
    } else {
      print('Kitchen ID is not loaded');
    }
    if (specialOrders == "yes") {
      specialOrders = "Yes";
    } else {
      specialOrders = "No";
    }
    initialSpecialOrders = specialOrders;
    try {
      var fetchedCategories = await getKitchenCategories();
      setState(() {
        categories = fetchedCategories;
        for (var element in categories) {
          if (element['id'] == category_id) {
            category = element['category'];
            initialCategory = category;
          }
          if (element.containsKey('category')) {
            categoriesList.add(element['category']);
          }
        }
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              )),
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
                _checkDataChanged();
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
                header: 'City',
                items: ['Nablus', 'Jenin', 'Ramallah', 'Tulkarm'],
                validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                onChanged: (String? value) {
                  setState(() {
                    location = value;
                    _checkDataChanged();
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
                header: 'Category',
                items: categoriesList, //this should be categoriesList
                validator: (value) =>
                    value!.isEmpty ? "Couldn't be empty" : null,
                onChanged: (String? value) {
                  setState(() {
                    category = value;
                    if (value != null) {
                      var selectedItem = categories.firstWhere(
                          (element) => element['category'] == value,
                          orElse: () => {});
                      selectedCategory = selectedItem['id'];
                    }
                    _checkDataChanged();
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundDropdown(
                value: orderingSystem, // Initial value
                header: 'Ordering System',
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
                    _checkDataChanged();
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
                            specialOrders = value;
                            _checkDataChanged();
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
                            specialOrders = value;
                            _checkDataChanged();
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
              isEnabled: isDataChanged,
              onPressed: isDataChanged
                  ? () async {
                      if (formState.currentState!.validate()) {
                        Map<String, dynamic> updates = {};

                        if (txtName.text != initialName)
                          updates['name'] = txtName.text;
                        if (txtStreet.text != initialStreet)
                          updates['street'] = txtStreet.text;
                        if (txtNumber.text != initialNumber)
                          updates['contact'] = txtNumber.text;
                        if (txtDescription.text != initialDescription)
                          updates['description'] = txtDescription.text;
                        if (imageUrl != initialImage)
                          updates['logo'] = imageUrl;
                        if (location != initialLocation)
                          updates['city'] = location;
                        if (category != initialCategory)
                          updates['category_id'] = selectedCategory;
                        if (orderingSystem != initialOrderingSystem)
                          updates['order_system'] = OrdersDb;
                        if (specialOrders != initialSpecialOrders)
                          updates['special_orders'] =
                              specialOrders!.toLowerCase();

                        Map<String, dynamic> result =
                            await editKitchen(kitchenId!, updates);
                        bool success = result['success'];
                        String message = result['message'];
                        print(message);
                        if (success) {
                          // save kitchen name to shared preferences
                          _saveKitchenNameToSharedPreferences();
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
