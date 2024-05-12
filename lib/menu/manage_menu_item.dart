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

class ManageMenuItemView extends StatefulWidget {
  final List<MenuItem> menu;
  final MenuItem item;
  final Function(MenuItem) RemoveItemFromList; // Callback function
  final Function(MenuItem) updateMenuItem;
  const ManageMenuItemView(
      {Key? key,
      required this.menu,
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
  void initState() {
    super.initState();
    txtName.text = widget.item.name!;
    txtNotes.text = widget.item.notes!;
    txtPrice.text = widget.item.price!;
    txtTime.text = widget.item.time!;
    category = widget.item.category!;
    quantity = widget.item.quantity;
    imageUrl = widget.item.image!;
  }

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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: RoundButton(
                      title: "Edit",
                      type: RoundButtonType.textPrimary,
                      onPressed: () {
                        MenuItem updatedItem = MenuItem(
                          itemId: widget.item.itemId,
                          kitchenId: widget.item.kitchenId,
                          name: txtName.text,
                          notes: txtNotes.text,
                          price: txtPrice.text,
                          time: txtTime.text,
                          category: category,
                          quantity: quantity,
                          image: widget.item.image,
                        );

                        widget.updateMenuItem(updatedItem);

                        Navigator.pop(context);
                      },
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
                          widget.RemoveItemFromList(widget.item);
                          Navigator.pop(context);
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
