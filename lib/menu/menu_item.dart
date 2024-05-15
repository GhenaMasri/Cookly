import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuItemView extends StatefulWidget {
  final List<MenuItem> menu;
  final Function(MenuItem) addItemToList; // Callback function
  const MenuItemView(
      {Key? key, required this.menu, required this.addItemToList});

  @override
  State<MenuItemView> createState() => _MenuItemViewState();
}

class _MenuItemViewState extends State<MenuItemView> {
  MenuItem? menuItem;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? _image;
  String? imageUrl;
  String? category;
  String? quantity;
  String errorMessage = '';
  bool errorFlag = false;
  int? kitchenId;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtTime = TextEditingController();

  late List<String> categoriesList = [];
  late List<Map<String, dynamic>> categories;
  int? selectedCategory; //id of the selected category

  late List<String> quantityList = [];
  late List<Map<String, dynamic>> quantities;
  int? selectedQuantity; //id of the selected quantity

  double dbPrice = 0.0; //price to store in db
  late Future<void> _initDataFuture;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<Map<String, dynamic>> addMenuItem() async {
    const url = '${SharedPreferencesService.url}add-menu-item';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': txtName.text,
          'image': imageUrl,
          'notes': txtNotes.text,
          'kitchen_id': kitchenId,
          'category_id': selectedCategory,
          'quantity_id': selectedQuantity,
          'price': dbPrice,
          'time': txtTime.text,
        }),
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

  Future<void> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    setState(() {
      kitchenId = kitchenid;
    });
  }

  Future<List<Map<String, dynamic>>> getFoodCategories() async {
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}food-categories'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> categoryList = data['categories'];
      final List<Map<String, dynamic>> categories =
          categoryList.map((category) {
        return {'id': category['id'], 'category': category['category']};
      }).toList();
      return categories;
    } else {
      throw Exception('Failed to load food categories');
    }
  }

  Future<List<Map<String, dynamic>>> getFoodQuantities() async {
    final response = await http
        .get(Uri.parse('${SharedPreferencesService.url}food-quantities'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> quantityList = data['quantities'];
      final List<Map<String, dynamic>> quantities =
          quantityList.map((quantity) {
        return {'id': quantity['id'], 'quantity': quantity['quantity']};
      }).toList();
      return quantities;
    } else {
      throw Exception('Failed to load food quantities');
    }
  }
  //////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _loadKitchenId();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    try {
      var fetchedCategories = await getFoodCategories();
      var fetchedQuantities = await getFoodQuantities();

      setState(() {
        categories = fetchedCategories;
        quantities = fetchedQuantities;

        for (var element in categories) {
          if (element.containsKey('category')) {
            categoriesList.add(element['category']);
          }
        }

        for (var element in quantities) {
          if (element.containsKey('quantity')) {
            quantityList.add(element['quantity']);
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
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 46,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, size: 25),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Add Menu Item",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 40), // Add SizedBox to provide spacing
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 300, // Increase the width
                    height:
                        200, // Make it a square by setting height equal to width
                    decoration: BoxDecoration(
                      color: TColor.placeholder,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: pickedFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // Half of the width (or height)
                            child: Image.file(
                              File(pickedFile!.path),
                              width: 300,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Icon(
                            Icons.image,
                            size: 75,
                            color: TColor.secondaryText,
                          ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
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
                      Reference referenceDirectory =
                          referenceRoot.child('images');
                      Reference referenceImageToUpload =
                          referenceDirectory.child(uniqueFileName);

                      try {
                        //Store the file
                        await referenceImageToUpload
                            .putFile(File(pickedFile!.path));
                        //Success: get the download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {
                        //Some error occurred
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: TColor.primary,
                      size: 12,
                    ),
                    label: Text(
                      "Add Image",
                      style: TextStyle(color: TColor.primary, fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Food Name",
                      hintText: "Enter Name",
                      controller: txtName,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Notes or Ingredients",
                      hintText: "Main Ingredients",
                      controller: txtNotes,
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Price",
                      hintText: "Enter Price",
                      controller: txtPrice,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: RoundTitleTextfield(
                      title: "Estimated Preparation Time",
                      hintText: "Enter Time (day:hour:minutes)",
                      controller: txtTime,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundDropdown(
                          value: category, // Initial value
                          hintText: 'Select Category',
                          items: categoriesList,
                          onChanged: (String? value) {
                            setState(() {
                              category = value;
                              if (value != null) {
                                var selectedItem = categories.firstWhere(
                                    (element) => element['category'] == value,
                                    orElse: () => {});
                                selectedCategory = selectedItem['id'];
                              }
                            });
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundDropdown(
                          value: quantity, // Initial value
                          hintText: 'Select Quantity',
                          items: quantityList,
                          onChanged: (String? value) {
                            setState(() {
                              quantity = value;
                              if (value != null) {
                                var selectedItem = quantities.firstWhere(
                                    (element) => element['quantity'] == value,
                                    orElse: () => {});
                                selectedQuantity = selectedItem['id'];
                              }
                            });
                          })),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: errorFlag,
                    child: Text(errorMessage,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 230, 81, 0),
                          fontSize: 12,
                        )),
                  ),
                  Visibility(visible: errorFlag, child: SizedBox(height: 8)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundButton(
                        title: "Save",
                        onPressed: () async {
                          if (imageUrl == null ||
                              category == null ||
                              quantity == null ||
                              txtName.text == "" ||
                              txtNotes.text == "" ||
                              txtPrice.text == "" ||
                              txtTime.text == "") {
                            setState(() {
                              errorFlag = true;
                              errorMessage = "All Fields Are Required";
                            });
                          } else {
                            setState(() {
                              dbPrice = (double.parse(txtPrice.text));
                              errorFlag = false;
                              errorMessage = "";
                            });
                            menuItem = MenuItem(
                                kitchenId: kitchenId,
                                itemId: 0,
                                image: imageUrl,
                                name: txtName.text,
                                notes: txtNotes.text,
                                quantity: selectedQuantity,
                                category: selectedCategory,
                                price: dbPrice,
                                time: txtTime.text);

                            widget.addItemToList(menuItem!);
                            Navigator.pop(context);
                          }
                          /////////////////////// BACKEND SECTION /////////////////////////
                          Map<String, dynamic> result = await addMenuItem();
                          bool success = result['success'];
                          String message = result['message'];
                          print(success);
                          print(message);
                          ////////////////////////////////////////////////////////////////
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ])),
      ),
    );
  }
}
