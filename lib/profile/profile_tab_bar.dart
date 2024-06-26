import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/profile/kitchen_profile.dart';
import 'package:untitled/profile/profile.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Cookly",
            style: TextStyle(color: TColor.primary, fontSize: 30),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Profile',
              ),
              Tab(text: 'Kitchen'),
            ],
            indicatorColor: Color.fromARGB(255, 230, 81, 0),
            labelColor: Color.fromARGB(255, 230, 81, 0),
          ),
        ),
        body: const TabBarView(
          children: <Widget>[ProfileView(), KitchenProfileView()],
        ),
      ),
    );
  }
}
