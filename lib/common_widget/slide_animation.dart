import 'package:flutter/material.dart';

Future<T?> pushReplacementWithAnimation<T, TO>(
    BuildContext context, Widget destination) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return destination;
      },
    ),
  );
}
