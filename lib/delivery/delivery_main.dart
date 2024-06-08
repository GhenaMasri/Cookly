import 'package:flutter/material.dart';
import 'package:untitled/admin/add_delivery.dart';
import 'package:untitled/admin/admin_home.dart';
import 'package:untitled/admin/admin_kitchens.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/delivery/accepted_orders.dart';
import 'package:untitled/delivery/delivery_orders.dart';
import 'package:untitled/delivery/delivery_profile.dart';
import '../../common_widget/tab_button.dart';

class DeliveryMainView extends StatefulWidget {
  const DeliveryMainView({super.key});

  @override
  State<DeliveryMainView> createState() => _DeliveryMainViewState();
}

class _DeliveryMainViewState extends State<DeliveryMainView> {
  int selectTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  late Widget selectPageView = DeliveryOrdersPage();

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
                title: "Home",
                icon: "assets/img/tab_home.png",
                onTap: () {
                  if (selectTab != 0) {
                    selectTab = 0;
                    selectPageView =  DeliveryOrdersPage();
                  }
                  setState(() {});
                },
                isSelected: selectTab == 0,
              ),
                  TabButton(
                title: "Accepted Orders",
                icon: "assets/img/tab_offer.png",
                onTap: () {
                  if (selectTab != 1) {
                    selectTab = 1;
                    selectPageView = DeliveryAcceptedOrders();
                  }
                  setState(() {});
                },
                isSelected: selectTab == 1,
              ),
              TabButton(
                title: "Profile",
                icon: "assets/img/tab_profile.png",
                onTap: () {
                  if (selectTab != 2) {
                    selectTab = 2;
                    selectPageView = DeliveryProfileView();
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
