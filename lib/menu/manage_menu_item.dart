import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/home/chef_home_view.dart';

import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_textfield.dart';

class ManageMenuItemView extends StatefulWidget {
  final MenuItem item;
  final Function(MenuItem) RemoveItemFromList; // Callback function
  final Function(MenuItem) updateMenuItem;
  const ManageMenuItemView(
      {Key? key,
      required this.RemoveItemFromList,
      required this.updateMenuItem,
      required this.item});

  @override
  State<ManageMenuItemView> createState() => _ManageMenuItemViewState();
}

class _ManageMenuItemViewState extends State<ManageMenuItemView> {
  MenuItem? menuItem;
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  File? _image;
  String? imageUrl;
  String? category;
  String? quantity;
  String errorMessage = '';
  bool errorFlag = false;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtTime = TextEditingController();

  List<String> categoriesList = [];
  List<Map<String, dynamic>> categories = [];
  int? selectedCategory; //id of the selected category

  List<String> quantityList = [];
  List<Map<String, dynamic>> quantities = [];
  int? selectedQuantity; //id of the selected quantity

  double dbPrice = 0.0; //price to store in db
  late Future<void> _initDataFuture;
  late String initialName;
  late String initialNotes;
  late String initialPrice;
  late String initialTime;
  late String? initialCategory;
  late String? initialQuantity;
  late String? initialImageUrl;

  bool isDataChanged = false;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
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

  Future<Map<String, dynamic>> deleteMenuItem(int menuItemId) async {
    final url =
        '${SharedPreferencesService.url}delete-menu-item?id=$menuItemId';
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        if (imageUrl != null) {
          Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl!);
          await imageRef.delete();
        }
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': response.body};
      }
    } catch (error) {
      return {'success': false, 'message': '$error'};
    }
  }

  Future<Map<String, dynamic>> editMenuItem(
      int id, Map<String, dynamic> updates) async {
    final String url = '${SharedPreferencesService.url}edit-menu-item?id=$id';
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updates),
      );
      if (response.statusCode == 200) {
        widget.updateMenuItem(MenuItem(
          itemId: widget.item.itemId,
          kitchenId: widget.item.kitchenId,
          name: txtName.text,
          notes: txtNotes.text,
          price: double.parse(txtPrice.text),
          time: txtTime.text,
          category: selectedCategory,
          quantity: selectedQuantity,
          image: imageUrl,
        ));
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Item Edited Successfully!',
          confirmBtnColor: TColor.primary,
        );
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
    txtNotes.addListener(_checkDataChanged);
    txtPrice.addListener(_checkDataChanged);
    txtTime.addListener(_checkDataChanged);
  }

  void _checkDataChanged() {
    bool dataChanged = txtName.text != initialName ||
        txtNotes.text != initialNotes ||
        txtPrice.text != initialPrice ||
        txtTime.text != initialTime ||
        category != initialCategory ||
        quantity != initialQuantity ||
        imageUrl != initialImageUrl;

    setState(() {
      isDataChanged = dataChanged;
    });
  }

  Future<void> _initData() async {
    txtName.text = widget.item.name ?? '';
    txtNotes.text = widget.item.notes ?? '';
    txtPrice.text = widget.item.price?.toString() ?? '';
    txtTime.text = widget.item.time ?? '';
    imageUrl = widget.item.image ?? '';

    initialName = txtName.text;
    initialNotes = txtNotes.text;
    initialPrice = txtPrice.text;
    initialTime = txtTime.text;
    initialImageUrl = imageUrl;

    try {
      var fetchedCategories = await getFoodCategories();
      var fetchedQuantities = await getFoodQuantities();

      setState(() {
        categories = fetchedCategories;
        quantities = fetchedQuantities;

        for (var element in categories) {
          if (element['id'] == widget.item.category) {
            category = element['category'];
            initialCategory = category;
          }
          if (element.containsKey('category')) {
            categoriesList.add(element['category']);
          }
        }

        for (var element in quantities) {
          if (element['id'] == widget.item.quantity) {
            quantity = element['quantity'];
            initialQuantity = quantity;
          }
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
  void dispose() {
    txtName.dispose();
    txtNotes.dispose();
    txtPrice.dispose();
    txtTime.dispose();
    super.dispose();
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
                              "Manage Menu Item",
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
                    child: widget.item.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // Half of the width (or height)
                            child: Image.network(
                              widget.item.image!,
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
                        _checkDataChanged();
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
                      "Edit Image",
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
                                _checkDataChanged();
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
                                _checkDataChanged();
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.textPrimary,
                      isEnabled: isDataChanged,
                      onPressed: isDataChanged
                          ? () {
                              Map<String, dynamic> updates = {};

                              if (txtName.text != initialName)
                                updates['name'] = txtName.text;
                              if (txtNotes.text != initialNotes)
                                updates['notes'] = txtNotes.text;
                              if (txtPrice.text != initialPrice)
                                updates['price'] = double.parse(txtPrice.text);
                              if (txtTime.text != initialTime)
                                updates['time'] = txtTime.text;
                              if (category != initialCategory)
                                updates['category_id'] = selectedCategory;
                              if (quantity != initialQuantity)
                                updates['quantity_id'] = selectedQuantity;
                              if (imageUrl != initialImageUrl)
                                updates['image'] = imageUrl;

                              editMenuItem(widget.item.itemId!, updates);
                            }
                          : null,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundButton(
                        title: "Delete",
                        onPressed: () {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.confirm,
                            text: 'You want to delete this item?',
                            confirmBtnText: 'Delete',
                            cancelBtnText: 'Cancel',
                            confirmBtnColor: TColor.primary,
                            onConfirmBtnTap: () async {
                              ////////////////////////// BACKEND SECTION ///////////////////////////
                              print(widget.item.itemId);
                              Map<String, dynamic> result =
                                  await deleteMenuItem(widget.item.itemId!);
                              bool success = result['success'];
                              String message = result['message'];
                              print(success);
                              print(message);
                              //////////////////////////////////////////////////////////////////////////////////
                              if (success) {
                                widget.RemoveItemFromList(widget.item);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChefHomeView()));
                              }
                            },
                            onCancelBtnTap: () {
                              Navigator.of(context).pop();
                            },
                          );
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
