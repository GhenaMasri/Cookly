import 'package:flutter/material.dart';
import 'package:untitled/signin.dart';
import 'package:untitled/signup.dart';

import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            var media = MediaQuery.of(context).size;
            var isLargeScreen = constraints.maxWidth > 600;

            return  Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stack with two images
             Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset(
                  "assets/img/welcome_top_shape.png",
                  width: media.width,
                   height: isLargeScreen ? media.height * 0.0: media.height * 0.65,
                  fit: BoxFit.fitWidth,
                ),
                Image.asset(
                  "assets/img/app_cookly.png",
                  width: isLargeScreen ? media.width * 0.3 : media.width * 0.53,
                      height: isLargeScreen ? media.width * 0.3 : media.width * 0.53,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            SizedBox(
              height: isLargeScreen ? media.width * 0.05 : media.width * 0.1,
            ),
            Text(
              "Discover the best and most delicious\n home made food with fast delivery to your\ndoorstep",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: isLargeScreen ? media.width * 0.05 : media.width * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: RoundButton(
                title: "Login",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signin(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: RoundButton(
                title: "Create an Account",
                type: RoundButtonType.textPrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Signup(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );}),
      ),
    );
  }
}
