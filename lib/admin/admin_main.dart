import 'package:flutter/material.dart';
import 'package:untitled/admin/add_delivery.dart';
import 'package:untitled/admin/admin_home.dart';
import 'package:untitled/admin/admin_kitchens.dart';
import 'package:untitled/admin/delivery_tab.dart';
import 'package:untitled/common/color_extension.dart';
import '../../common_widget/tab_button.dart';

class AdminMainView extends StatefulWidget {
  const AdminMainView({super.key});

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  int selectTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  late Widget selectPageView = const AdminHomeView();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: TColor.white,
      bottomNavigationBar: BottomAppBar(
        color: TColor.white,
        elevation: 1,
        height: 64,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: "Statistics",
                icon: "assets/img/statics.png",
                onTap: () {
                  if (selectTab != 0) {
                    selectTab = 0;
                    selectPageView = const AdminHomeView();
                  }
                  setState(() {});
                },
                isSelected: selectTab == 0,
              ),
              TabButton(
                title: "Delivery",
                icon: "assets/img/delivery.png",
                onTap: () {
                  if (selectTab != 1) {
                    selectTab = 1;
                    selectPageView = DeliveryTabBar();
                  }
                  setState(() {});
                },
                isSelected: selectTab == 1,
              ),
              TabButton(
                title: "Kitchens",
                icon: "assets/img/kitchen.png",
                onTap: () {
                  if (selectTab != 2) {
                    selectTab = 2;
                    selectPageView = AdminKitchensPage();
                  }
                  setState(() {});
                },
                isSelected: selectTab == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
