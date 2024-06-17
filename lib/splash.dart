import 'package:flutter/material.dart';
import 'package:untitled/admin/admin_main.dart';
import 'package:untitled/delivery/delivery_main.dart';
import 'package:untitled/welcome_page.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/main_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _StarupViewState();
}

class _StarupViewState extends State<SplashView> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in foreground: ${message.messageId}');
      // Handle foreground message
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Handle notification click
    });
    FirebaseMessaging.instance.getToken().then((token) {
      print("Device Token: $token");
    });
    goWelcomePage();
  }

  void goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 3));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeView()));
    welcomePage();
  }

  void welcomePage() async {
    bool? isSet = await SharedPreferencesService.getIsSet();
    String? type = await SharedPreferencesService.getType();
    if (isSet == true && type != 'admin' && type != 'delivery') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainView()));
    } else if (isSet == true && type == 'admin') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AdminMainView()));
    } else if (isSet == true && type == 'delivery') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DeliveryMainView()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WelcomeView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/img/app_cookly.png",
            width: media.width * 0.55,
            height: media.width * 0.55,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
