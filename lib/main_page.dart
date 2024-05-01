import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import '../common_widget/tab_button.dart';

import '../home/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selectTab != 2) {
              selectTab = 2;
              selectPageView = const HomeView();
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor: selectTab == 2 ? TColor.primary : TColor.placeholder,
          child: Image.asset(
            "assets/img/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: 12,
        height: 64,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  title: "Menu",
                  icon: "assets/img/tab_menu.png",
                  onTap: () {
                    if (selectTab != 0) {
                      selectTab = 0;
                      selectPageView = Container();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 0),
              TabButton(
                  title: "Offer",
                  icon: "assets/img/tab_offer.png",
                  onTap: () {
                    if (selectTab != 1) {
                      selectTab = 1;
                      selectPageView = Container();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 1),
        
        
                const  SizedBox(width: 40, height: 40, ),
        
              TabButton(
                  title: "Profile",
                  icon: "assets/img/tab_profile.png",
                  onTap: () {
                    if (selectTab != 3) {
                      selectTab = 3;
                     selectPageView = Container();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 3),
              TabButton(
                  title: "More",
                  icon: "assets/img/tab_more.png",
                  onTap: () {
                    if (selectTab != 4) {
                      selectTab = 4;
                      selectPageView = Container();
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 4),
            ],
          ),
        ),
      ),
    );
  }
}