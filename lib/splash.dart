import 'package:flutter/material.dart';
import 'package:untitled/welcome_page.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/main_page.dart';

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeView()));
      //welcomePage();
  }

  void welcomePage() async{
    bool? isSet = await SharedPreferencesService.getIsSet();
    if (isSet == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainView()));
    } else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeView()));
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