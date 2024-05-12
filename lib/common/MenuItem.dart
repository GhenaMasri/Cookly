import 'dart:io';

import 'package:flutter/material.dart';

// Define the class
class MenuItem {
  int? kitchenId;
  int? itemId;
  String? image;
  String? name;
  String? notes;
  String? quantity;
  String? category;
  String? price;
  String? time;
 
  MenuItem({
    this.kitchenId,
    this.itemId,
    this.image,
    this.name,
    this.notes,
    this.quantity,
    this.category,
    this.price,
    this.time,
  });
}
