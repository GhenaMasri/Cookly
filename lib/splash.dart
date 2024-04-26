import 'package:flutter/material.dart';
import 'package:untitled/welcome_page.dart';

import '../../common/globs.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _StarupViewState();
}

class _StarupViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    goWelcomePage();
  }

  void goWelcomePage() async {

      await Future.delayed( const Duration(seconds: 3) );
      Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WelcomeView()));
  }
 /* void welcomePage(){

    if (Globs.udValueBool(Globs.userLogin)) {
       Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MainTabView()));
    }else{
       Navigator.push(
        context, MaterialPageRoute(builder: (context) => const WelcomeView()));
    }
  }*/

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