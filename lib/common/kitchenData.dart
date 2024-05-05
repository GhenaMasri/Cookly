import 'dart:io';

import 'package:flutter/material.dart';

// Define the class
class KitchenData {
  File? image;
  String? location;
  String? name;
  String? phone;
  String? street;
  String? category;
  String? description;
  String? orderingSystem;
  String? specialOrders;

  KitchenData({
    this.image,
    this.location,
    this.name,
    this.phone,
    this.street,
    this.category,
    this.description,
    this.orderingSystem,
    this.specialOrders = "Yes",
  });
}
