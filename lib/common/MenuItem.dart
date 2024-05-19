import 'dart:io';

import 'package:flutter/material.dart';

// Define the class
class MenuItem {
  int? kitchenId;
  int? itemId;
  String? image;
  String? name;
  String? notes;
  int? quantity;
  int? category;
  double? price;
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

 MenuItem copyWith({
    String? name,
    String? notes,
    double? price,
    String? time,
    int? category,
    int? quantity,
    String? image,
  }) {
    return MenuItem(
      name: name ?? this.name,
      notes: notes ?? this.notes,
      price: price ?? this.price,
      time: time ?? this.time,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
    );
  }

}
