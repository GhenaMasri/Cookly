import 'package:flutter/material.dart';
import 'package:untitled/signin.dart';
import 'package:untitled/signup.dart';
import 'package:untitled/splash.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cookly",
      theme: ThemeData(
        fontFamily: "Metropolis",
      ),
      // ignore: prefer_const_constructors
      home: SplashView(),
    );
  }
}
