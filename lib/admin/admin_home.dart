import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled/common/color_extension.dart';
import 'package:untitled/common/globs.dart';
import 'package:untitled/common_widget/dropdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled/more/notification_view.dart';
import 'package:untitled/welcome_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

Future<void> signOut(BuildContext context) async {
  await SharedPreferencesService.clearSharedPreferences();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => WelcomeView()),
    (Route<dynamic> route) => false,
  );
}

class _AdminHomeViewState extends State<AdminHomeView> {
  int touchedIndex = -1;
  String selectedLocation = 'Nablus';
  List<dynamic> percentages = [];
  Map<String, dynamic>? usersCount;
  Map<String, dynamic>? topKitchen;
  int? unreadCount;

  Future<void> updateUnreadCountFromNotifications(int newCount) async {
    unreadCount = await unreadNotificationsCount();
    setState(() {
      //unreadCount = newCount;
    });
  }

//////////////////////////////////////// BACKEND SECTION //////////////////////////////////////////
  Future<void> kitchensPercentage() async {
    const String apiUrl = '${SharedPreferencesService.url}kitchens-percentage';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        percentages = data['percentages'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> getUsersCount() async {
    const String apiUrl = '${SharedPreferencesService.url}users-count';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        usersCount = data['counts'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<void> getTopKitchen(String city) async {
    String apiUrl = '${SharedPreferencesService.url}top-kitchen?city=$city';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        topKitchen = data['topKitchen'];
      });
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
    }
  }

  Future<int> unreadNotificationsCount() async {
    final response = await http.get(Uri.parse(
        '${SharedPreferencesService.url}unread-notifications?destination=admin'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'];
    } else {
      throw Exception('Failed to load unread notification count');
    }
  }
///////////////////////////////////////////////////////////////////////////////////////////////////

  late Future<void> _initDataFuture;
  @override
  void initState() {
    super.initState();
    _initDataFuture = _initData();
  }

  Future<void> _initData() async {
    await kitchensPercentage();
    await getTopKitchen('Nablus');
    await getUsersCount();
    unreadCount = await unreadNotificationsCount();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: TColor.primary,
          ));
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error loading data'));
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Statistics',
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  int newCount = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationsView(),
                    ),
                  );

                  await updateUnreadCountFromNotifications(newCount);
                },
                icon: Image.asset(
                  "assets/img/notification.png",
                  width: 25,
                  height: 25,
                ),
              ),
              if (unreadCount != null && unreadCount! > 0)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () async {
              signOut(context);
            },
            icon: Image.asset(
              "assets/img/more_logout.png",
              width: 25,
              height: 25,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Kitchens In Cities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            AspectRatio(
              aspectRatio: 1.3,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildIndicators(),
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            Text(
              "Top Kitchen",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: MyDropdownMenu(
                value: selectedLocation,
                onChanged: (newValue) async {
                  setState(() {
                    selectedLocation = newValue!;
                  });
                  await getTopKitchen(selectedLocation);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 5),
            buildTopKitchenCard(),
/*             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.crown,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Top Delivery Man: ${locationData[selectedLocation]!['delivery']}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ), */
            SizedBox(
              height: 8,
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            Text("Total Numbers",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.kitchen,
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Total Number of Kitchens: " +
                        usersCount!['chef'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Total Number of Users: " +
                        usersCount!['normal'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.delivery_dining,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Total Number of Delivery Men: " +
                        usersCount!['delivery'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget buildTopKitchenCard() {
    if (topKitchen == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 4,
      color: TColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.crown,
              color: Colors.amber,
              size: 25,
            ),
            const SizedBox(width: 16),
            Stack(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: TColor.primary,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          topKitchen!["logo"],
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topKitchen!['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: TColor.primary,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      '${topKitchen!['kitchen_rate'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildIndicators() {
    List<Color> colors = [
      Colors.purple,
      Colors.yellow,
      Colors.orange,
      Colors.green,
      Colors.blue
    ];
    return List.generate(percentages.length, (i) {
      final city = percentages[i]['city'];
      final color = colors[i % colors.length];
      return Indicator(
        color: color,
        text: city,
        isSquare: true,
      );
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(percentages.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final percentage = double.parse(percentages[i]['percentage']);
      final city = percentages[i]['city'];

      Color color;
      switch (i) {
        case 0:
          color = Colors.purple;
          break;
        case 1:
          color = Colors.yellow;
          break;
        case 2:
          color = Colors.orange;
          break;
        case 3:
          color = Colors.green;
          break;
        default:
          color = Colors.blue; // Default color if more than 4 cities
      }

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          shadows: shadows,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 15,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
