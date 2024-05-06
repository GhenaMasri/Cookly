import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled/chef_signup.dart';
import 'package:untitled/chef_signup_more.dart';
import 'package:untitled/common/kitchenData.dart';
import 'package:untitled/main_page.dart';
import 'package:untitled/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDBr3kDt_-WmqxXkVSlxyPle7XAbrgcRHo",
            authDomain: "cookly-495b4.firebaseapp.com",
            projectId: "cookly-495b4",
            storageBucket: "cookly-495b4.appspot.com",
            messagingSenderId: "13158533461",
            appId: "1:13158533461:web:118e6c10b556e6bd6287dc",
            measurementId: "G-S3NFN865JQ"));
  } else {
    await Firebase.initializeApp();
  }
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
        home: SplashView());
  }
}
