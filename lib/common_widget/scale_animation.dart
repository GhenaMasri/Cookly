import 'package:flutter/material.dart';
Future<T?> pushReplacementWithScaleAnimation<T, TO>(
    BuildContext context, Widget destination) {
  return
  Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return destination;
      },
    ),
  );
}
