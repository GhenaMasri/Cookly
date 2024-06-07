import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/more/more_view.dart';
import 'package:untitled/more/user_more_view.dart';
import 'package:untitled/order/chef_order_pending.dart';
import 'package:untitled/order/orders_tab_bar.dart';
import 'package:untitled/order/user_orders.dart';
import 'package:untitled/profile/profile_tab_bar.dart';
import 'package:untitled/profile/user_profile.dart';
import '../common_widget/tab_button.dart';
import '../home/home_view.dart';
import 'package:untitled/home/chef_home_view.dart';
import 'package:untitled/common/globs.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectTab = 0;
  PageStorageBucket storageBucket = PageStorageBucket();
  late Widget selectPageView = const HomeView();
  String? type;

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> _loadUserType() async {
    String? userType = await SharedPreferencesService.getType();
    setState(() {
      type = userType;
      if (type == "chef") {
        selectPageView = const ChefHomeView();
      } else {
        selectPageView = const HomeView();
      }
    });
  }
  ////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _loadUserType();
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
                      if (type == "chef") {
                        selectPageView = const ChefHomeView();
                      } else {
                        selectPageView = const HomeView();
                      }
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 0),
              TabButton(
                  title: "Orders",
                  icon: "assets/img/tab_offer.png",
                  onTap: () {
                    if (selectTab != 1) {
                      selectTab = 1;
                      if (type == "chef") {
                        selectPageView = OrdersTabBar();
                      } else {
                        selectPageView = UserOrders();
                      }
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  isSelected: selectTab == 1),
              TabButton(
                  title: "Profile",
                  icon: "assets/img/tab_profile.png",
                  onTap: () {
                    if (selectTab != 3) {
                      selectTab = 3;
                      if (type == "chef") {
                        selectPageView = ProfileTabBar();
                      } else {
                        selectPageView = UserProfileView();
                      }
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

                      if (type == "chef") {
                        selectPageView = MoreView();
                      } else {
                        selectPageView = UserMoreView();
                      }
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
