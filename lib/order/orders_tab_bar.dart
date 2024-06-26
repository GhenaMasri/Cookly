import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/order/chef_order_delivered.dart';
import 'package:untitled/order/chef_order_done.dart';
import 'package:untitled/order/chef_order_inprogress.dart';
import 'package:untitled/order/chef_order_pending.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          title: Text(
            "Cookly",
            style: TextStyle(color: TColor.primary, fontSize: 30),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                text: 'Pending',
              ),
              Tab(text: 'In Progress'),
              Tab(text: 'Done'),
              Tab(text: 'Delivered'),
            ],
            indicatorColor: Color.fromARGB(255, 230, 81, 0),
            labelColor: Color.fromARGB(255, 230, 81, 0),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ChefOrderPending(),
            ChefOrderInprogress(),
            ChefOrderDone(),
            ChefOrderDelievered(),
          ],
        ),
      ),
    );
  }
}
