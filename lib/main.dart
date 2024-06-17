import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/splash.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:untitled/firebase_options.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDBr3kDt_-WmqxXkVSlxyPle7XAbrgcRHo",
            authDomain: "cookly-495b4.firebaseapp.com",
            projectId: "cookly-495b4",
            storageBucket: "cookly-495b4.appspot.com",
            messagingSenderId: "13158533461",
            appId: "1:13158533461:web:118e6c10b556e6bd6287dc",
            measurementId: "G-S3NFN865JQ"));
    await FirebaseAppCheck.instance.activate();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('Error initializing Firebase: $e');
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "Metropolis",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // ignore: prefer_const_constructors
        home: SplashView());
  }
}