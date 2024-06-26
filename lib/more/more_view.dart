import 'package:flutter/material.dart';
import 'package:untitled/chef/chef_subscription.dart';
import 'package:untitled/chef/subscription_mngt.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/slide_animation.dart';
import 'package:untitled/more/about_us.dart';
import 'package:untitled/more/chat.dart';
import 'package:untitled/more/inbox.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/more/payment_details_view.dart';
import 'package:untitled/welcome_page.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  List moreArr = [
    
    {
      "index": "1",
      "name": "My Subscription",
      "image": "assets/img/subscription.png",
      "base": 0
    },
    {
      "index": "2",
      "name": "Inbox",
      "image": "assets/img/more_inbox.png",
      "base": 0
    },
    {
      "index": "3",
      "name": "About Us",
      "image": "assets/img/more_info.png",
      "base": 0
    },
    {
      "index": "4",
      "name": "Logout",
      "image": "assets/img/more_logout.png",
      "base": 0
    },
  ];

  //////////////////////////////// BACKEND SECTION ////////////////////////////////
  Future<void> signOut(BuildContext context) async {
    await SharedPreferencesService.clearSharedPreferences();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => WelcomeView()),
      (Route<dynamic> route) => false,
    );
  }

  Future<int> _loadKitchenId() async {
    int? kitchenid = await SharedPreferencesService.getKitchenId();
    return kitchenid!;
  }
  /////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: moreArr.length,
                  itemBuilder: (context, index) {
                    var mObj = moreArr[index] as Map? ?? {};
                    var countBase = mObj["base"] as int? ?? 0;
                    return InkWell(
                      onTap: () async {
                        switch (mObj["index"].toString()) {
                        
                          case "1":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>SubscriptionManagementPage()));

                          case "2":
                            int id = await _loadKitchenId();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InboxPage(id: id, type: "chef")));
                          case "3":
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUsPage()));
                          case "4":
                            signOut(context);

                          default:
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 20),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(5)),
                              margin: const EdgeInsets.only(right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: TColor.placeholder,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    alignment: Alignment.center,
                                    child: Image.asset(mObj["image"].toString(),
                                        width: 25,
                                        height: 25,
                                        fit: BoxFit.contain),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      mObj["name"].toString(),
                                      style: TextStyle(
                                          color: TColor.primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (countBase > 0) //Number of inbox msgs
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12.5)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        countBase.toString(),
                                        style: TextStyle(
                                            color: TColor.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: TColor.textfield,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Image.asset("assets/img/btn_next.png",
                                  width: 10,
                                  height: 10,
                                  color: TColor.primary),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
