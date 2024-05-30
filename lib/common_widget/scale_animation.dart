import 'package:flutter/material.dart';

void pushReplacementWithScaleAnimation(BuildContext context, Widget destination) {
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
