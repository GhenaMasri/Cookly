import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/MenuItem.dart';
import 'package:untitled/common_widget/dropdownfield.dart';
import 'package:untitled/common_widget/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/home/chef_home_view.dart';

import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/round_textfield.dart';

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
  String? name;
  String? notes;
  String? price;
  String? time;
  String errorMessage = '';
  bool errorFlag = false;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtNotes = TextEditingController();
  TextEditingController txtPrice = TextEditingController();
  TextEditingController txtTime = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      title: "Estimated Preperation Time",
                      hintText: "Enter Time",
                      keyboardType: TextInputType.datetime,
                      controller: txtTime,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundDropdown(
                          value: category, // Initial value
                          hintText: 'Select Category',
                          items: ["Default", "Food", "Yalanji", "Desserts"],
                          onChanged: (String? value) {
                            setState(() {
                              category = value;
                            });
                          })),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
                      child: RoundDropdown(
                          value: quantity, // Initial value
                          hintText: 'Select Quantity',
                          items: ["Small", "Medium", "Large"],
                          onChanged: (String? value) {
                            setState(() {
                              quantity = value;
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
                        onPressed: () {
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
                              errorFlag = false;
                              errorMessage = "";
                            });
                            menuItem = MenuItem(
                                kitchenId: 1,
                                itemId: 2,
                                image: imageUrl,
                                name: txtName.text,
                                notes: txtNotes.text,
                                quantity: quantity,
                                category: category);

                            widget.addItemToList(menuItem!);
                            Navigator.pop(context);
                          }
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
