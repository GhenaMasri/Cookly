import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/order/chef_order_view.dart';


class OrdersTabBar extends StatelessWidget {
  const OrdersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cookly", style: TextStyle(color: TColor.primary, fontSize: 30),),
          centerTitle: true,
          actions: [Image.asset(
                        "assets/img/notification.png",
                        width: 25,
                        height: 25,
                      ), SizedBox(width: 20,)],
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Current Orders',
              ),
              Tab(text: 'Past Orders'),
            ],
            indicatorColor: Color.fromARGB(255, 230, 81, 0),
           labelColor: Color.fromARGB(255, 230, 81, 0),
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            OrdersPage(),
            OrdersPage(),
          ],
        ),
      ),
    );
  }
}