import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/order/chef_order_delivered.dart';
import 'package:untitled/order/chef_order_inprogress.dart';
import 'package:untitled/order/chef_order_pending.dart';

class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          title: Text(
            "Cookly",
            style: TextStyle(color: TColor.primary, fontSize: 30),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            Image.asset(
              "assets/img/notification.png",
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: 20,
            )
          ],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Pending',
              ),
              Tab(text: 'In Progress'),
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
            ChefOrderDelievered(),
          ],
        ),
      ),
    );
  }
}
