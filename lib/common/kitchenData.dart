import 'dart:io';

import 'package:flutter/material.dart';

// Define the class
class KitchenData {
  String? image;
  String? location;
  String? name;
  String? phone;
  String? street;
  int? category;
  String? description;
  int? orderingSystem;
  String? specialOrders;
  int? userId;

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
    this.userId
  });
}
