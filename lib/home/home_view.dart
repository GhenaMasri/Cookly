import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:untitled/common_widget/round_textfield.dart';
import 'package:untitled/common/globs.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? selectedLocation;
  TextEditingController txtSearch = TextEditingController();
  late Future<void> _initDataFuture;
//////////////////////////////// BACKEND SECTION ///////////////////////////
  String? username;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _initDataFuture; //_initDataFuture = load user home page API
  }

  Future<void> _loadUserName() async {
    String? name = await SharedPreferencesService.getUserName();
    setState(() {
      username = name;
    });
  }
//////////////////////////////////////////////////////////////////////////
  List menuArr = [
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Food",
      "image": "assets/img/menu_1.png",
      "items_count": "120",
    },
    {
      "name": "Beverages",
      "image": "assets/img/menu_2.png",
      "items_count": "220",
    },
    {
      "name": "Desserts",
      "image": "assets/img/menu_3.png",
      "items_count": "155",
    },
    {
      "name": "Promotions",
      "image": "assets/img/menu_4.png",
      "items_count": "25",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading data'));
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 250,
            child: Container(
              width: media.width * 0.27,
              height: media.height,
              decoration: BoxDecoration(
                color: TColor.primary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      username != null ? "Hello $username!" : "Hello!",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Notifications()));*/
                      },
                      icon: Image.asset(
                        "assets/img/notification.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivering to",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MyDropdownMenu(
                      value: selectedLocation,
                      onChanged: (newValue) {
                        setState(() {
                          selectedLocation = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: "Search Food",
                  controller: txtSearch,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      "assets/img/search.png",
                      width: 20,
                      height: 20,
                      color: TColor.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  itemCount: menuArr.length,
                  itemBuilder: ((context, index) {
                    var mObj = menuArr[index] as Map? ?? {};
                    return GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuItemsView(
                                mObj: mObj,
                              ),
                            ),
                          );*/
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 90,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  bottomLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 7,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipOval(
                                      child: Image.asset(
                                    mObj["image"].toString(),
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 12),
                                        Text(
                                          mObj["name"].toString(),
                                          style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${mObj["items_count"].toString()} items",
                                          style: TextStyle(
                                            color: TColor.secondaryText,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MenuItemsView(
                                        mObj: mObj,
                                      ),
                                    ),
                                  );*/
                              },
                              icon: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(17.5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/img/btn_next.png",
                                  width: 15,
                                  height: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
